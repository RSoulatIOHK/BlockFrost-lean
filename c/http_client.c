// c/http_client.c
#include <lean/lean.h>
#include <curl/curl.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

/* -------- simple growable buffer for response body -------- */
typedef struct {
    char*  data;
    size_t size;
    size_t cap;
} buf_t;

static void buf_init(buf_t* b) {
    b->data = (char*)malloc(1);
    if (!b->data) { b->size = b->cap = 0; return; }
    b->data[0] = '\0';
    b->size = 0;
    b->cap  = 1;
}

static int buf_grow(buf_t* b, size_t add) {
    if (b->size + add + 1 <= b->cap) return 1;
    size_t need = b->size + add + 1;
    size_t newCap = b->cap * 2;
    if (newCap < need) newCap = need;
    char* p = (char*)realloc(b->data, newCap);
    if (!p) return 0;
    b->data = p;
    b->cap  = newCap;
    return 1;
}

static size_t write_cb(char* ptr, size_t size, size_t nmemb, void* userdata) {
    size_t n = size * nmemb;
    buf_t* b = (buf_t*)userdata;
    if (!buf_grow(b, n)) return 0; // signal error to libcurl
    memcpy(b->data + b->size, ptr, n);
    b->size += n;
    b->data[b->size] = '\0';
    return n;
}

/* -------- helper to build curl_slist from Array (String×String) -------- */
static struct curl_slist* build_headers_from_array(lean_obj_arg hdrs) {
    size_t n = lean_array_size(hdrs);
    struct curl_slist* list = NULL;
    for (size_t i = 0; i < n; ++i) {
        lean_obj_arg pair = lean_array_uget(hdrs, i);
        lean_obj_arg k = lean_ctor_get(pair, 0);
        lean_obj_arg v = lean_ctor_get(pair, 1);
        const char* ck = lean_string_cstr(k);
        const char* cv = lean_string_cstr(v);

        size_t lk = strlen(ck), lv = strlen(cv);
        char* line = (char*)malloc(lk + 2 + lv + 1); // "k: v\0"
        if (!line) {
            curl_slist_free_all(list);
            return NULL;
        }
        memcpy(line, ck, lk);
        line[lk] = ':'; line[lk+1] = ' ';
        memcpy(line + lk + 2, cv, lv);
        line[lk + 2 + lv] = '\0';

        list = curl_slist_append(list, line);
        free(line);
        if (!list) return NULL;
    }
    return list;
}

/* -------- plain GET: IO String -------- */
LEAN_EXPORT lean_obj_res lcurl_get(lean_obj_arg url, lean_obj_arg w) {
    const char* c_url = lean_string_cstr(url);
    CURLcode cc = curl_global_init(CURL_GLOBAL_DEFAULT);
    if (cc != CURLE_OK) {
        return lean_io_result_mk_error(lean_mk_string(curl_easy_strerror(cc)));
    }

    CURL* h = curl_easy_init();
    if (!h) {
        curl_global_cleanup();
        return lean_io_result_mk_error(lean_mk_string("curl_easy_init failed"));
    }

    buf_t b; buf_init(&b);
    if (!b.data) {
        curl_easy_cleanup(h); curl_global_cleanup();
        return lean_io_result_mk_error(lean_mk_string("out of memory"));
    }

    curl_easy_setopt(h, CURLOPT_NOSIGNAL,   1L);   // safety on macOS with timeouts/threads
    curl_easy_setopt(h, CURLOPT_ACCEPT_ENCODING, ""); // enable decompression
    curl_easy_setopt(h, CURLOPT_URL, c_url);
    curl_easy_setopt(h, CURLOPT_WRITEFUNCTION, write_cb);
    curl_easy_setopt(h, CURLOPT_WRITEDATA, &b);
    curl_easy_setopt(h, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(h, CURLOPT_USERAGENT, "lean-curl/1.0");
    curl_easy_setopt(h, CURLOPT_CONNECTTIMEOUT, 10L);
    curl_easy_setopt(h, CURLOPT_TIMEOUT, 30L);

    cc = curl_easy_perform(h);
    if (cc != CURLE_OK) {
        lean_obj_res err = lean_mk_string(curl_easy_strerror(cc));
        free(b.data); curl_easy_cleanup(h); curl_global_cleanup();
        return lean_io_result_mk_error(err);
    }

    long status = 0;
    curl_easy_getinfo(h, CURLINFO_RESPONSE_CODE, &status);

    lean_obj_res s = lean_mk_string(b.data);
    free(b.data); curl_easy_cleanup(h); curl_global_cleanup();
    return lean_io_result_mk_ok(s);
}

/* -------- GET with headers: IO String -------- */
LEAN_EXPORT lean_obj_res lcurl_get_with_headers(lean_obj_arg url, lean_obj_arg headers, lean_obj_arg w) {
    const char* c_url = lean_string_cstr(url);
    CURLcode cc = curl_global_init(CURL_GLOBAL_DEFAULT);
    if (cc != CURLE_OK) {
        return lean_io_result_mk_error(lean_mk_string(curl_easy_strerror(cc)));
    }

    CURL* h = curl_easy_init();
    if (!h) {
        curl_global_cleanup();
        return lean_io_result_mk_error(lean_mk_string("curl_easy_init failed"));
    }

    buf_t b; buf_init(&b);
    if (!b.data) {
        curl_easy_cleanup(h); curl_global_cleanup();
        return lean_io_result_mk_error(lean_mk_string("out of memory"));
    }

    struct curl_slist* hdr_list = build_headers_from_array(headers);
    if (headers != lean_box(0) && hdr_list == NULL && lean_array_size(headers) > 0) {
        free(b.data); curl_easy_cleanup(h); curl_global_cleanup();
        return lean_io_result_mk_error(lean_mk_string("out of memory building headers"));
    }

    // curl_easy_setopt(h, CURLOPT_FAILONERROR, 1L);  // treat HTTP >=400 as failure
    curl_easy_setopt(h, CURLOPT_NOSIGNAL,   1L);   // safety on macOS with timeouts/threads
    curl_easy_setopt(h, CURLOPT_ACCEPT_ENCODING, ""); // enable decompression
    curl_easy_setopt(h, CURLOPT_URL, c_url);
    curl_easy_setopt(h, CURLOPT_HTTPHEADER, hdr_list);
    curl_easy_setopt(h, CURLOPT_WRITEFUNCTION, write_cb);
    curl_easy_setopt(h, CURLOPT_WRITEDATA, &b);
    curl_easy_setopt(h, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(h, CURLOPT_USERAGENT, "lean-curl/1.0");
    curl_easy_setopt(h, CURLOPT_CONNECTTIMEOUT, 10L);
    curl_easy_setopt(h, CURLOPT_TIMEOUT, 30L);

    cc = curl_easy_perform(h);
    if (cc != CURLE_OK) {
        lean_obj_res err = lean_mk_string(curl_easy_strerror(cc));
        if (hdr_list) curl_slist_free_all(hdr_list);
        free(b.data); curl_easy_cleanup(h); curl_global_cleanup();
        return lean_io_result_mk_error(err);
    }

    long status = 0;
    curl_easy_getinfo(h, CURLINFO_RESPONSE_CODE, &status);
    lean_obj_res s = lean_mk_string(b.data);
    if (hdr_list) curl_slist_free_all(hdr_list);
    free(b.data); curl_easy_cleanup(h); curl_global_cleanup();
    return lean_io_result_mk_ok(s);
}

/* -------- GET with headers -> write raw bytes to a file path -------- */
/* IO Unit curlGetToFileWithHeaders(String url, Array (String×String) headers, String path) */
LEAN_EXPORT lean_obj_res lcurl_get_to_file_with_headers(lean_obj_arg url, lean_obj_arg headers, lean_obj_arg path, lean_obj_arg w) {
    const char* c_url  = lean_string_cstr(url);
    const char* c_path = lean_string_cstr(path);

    CURLcode cc = curl_global_init(CURL_GLOBAL_DEFAULT);
    if (cc != CURLE_OK)
        return lean_io_result_mk_error(lean_mk_string(curl_easy_strerror(cc)));

    FILE* f = fopen(c_path, "wb");
    if (!f) {
        curl_global_cleanup();
        return lean_io_result_mk_error(lean_mk_string("failed to open output file"));
    }

    CURL* h = curl_easy_init();
    if (!h) {
        fclose(f);
        curl_global_cleanup();
        return lean_io_result_mk_error(lean_mk_string("curl_easy_init failed"));
    }

    struct curl_slist* hdr_list = build_headers_from_array(headers);
    if (headers != lean_box(0) && hdr_list == NULL && lean_array_size(headers) > 0) {
        curl_easy_cleanup(h); fclose(f); curl_global_cleanup();
        return lean_io_result_mk_error(lean_mk_string("out of memory building headers"));
    }

    curl_easy_setopt(h, CURLOPT_URL, c_url);
    curl_easy_setopt(h, CURLOPT_HTTPHEADER, hdr_list);
    curl_easy_setopt(h, CURLOPT_WRITEDATA, f);               /* write directly to FILE* */
    curl_easy_setopt(h, CURLOPT_WRITEFUNCTION, NULL);         /* default fwrite */
    curl_easy_setopt(h, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(h, CURLOPT_USERAGENT, "lean-curl/1.0");
    curl_easy_setopt(h, CURLOPT_CONNECTTIMEOUT, 10L);
    curl_easy_setopt(h, CURLOPT_TIMEOUT, 60L);

    cc = curl_easy_perform(h);
    if (cc != CURLE_OK) {
        lean_obj_res err = lean_mk_string(curl_easy_strerror(cc));
        if (hdr_list) curl_slist_free_all(hdr_list);
        curl_easy_cleanup(h); fclose(f); curl_global_cleanup();
        return lean_io_result_mk_error(err);
    }

    long status = 0;
    curl_easy_getinfo(h, CURLINFO_RESPONSE_CODE, &status);
    if (hdr_list) curl_slist_free_all(hdr_list);
    curl_easy_cleanup(h);
    fclose(f);
    curl_global_cleanup();
    return lean_io_result_mk_ok(lean_box(0)); /* Unit */
}
