-- CurlFFI/Curl.lean
namespace Curl

@[extern "lcurl_get"]
opaque curlGet (url : @& String) : IO String

/-- GET with HTTP headers. Each pair is (Header-Name, Header-Value). -/
@[extern "lcurl_get_with_headers"]
opaque curlGetWithHeaders (url : @& String) (headers : @& Array (String × String)) : IO String

end Curl
