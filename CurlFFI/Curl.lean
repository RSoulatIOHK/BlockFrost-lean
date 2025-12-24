namespace Curl

@[extern "lcurl_get"]
opaque curlGet (url : @& String) : IO String

@[extern "lcurl_get_with_headers"]
opaque curlGetWithHeaders (url : @& String) (headers : @& Array (String × String)) : IO String

/-- Stream response to a file (binary-safe). -/
@[extern "lcurl_get_to_file_with_headers"]
opaque curlGetToFileWithHeaders
  (url : @& String)
  (headers : @& Array (String × String))
  (path : @& String)
  : IO Unit

@[extern "lcurl_post"]
opaque curlPost (url : @& String) (body : @& String) : IO String

@[extern "lcurl_post_with_headers"]
opaque curlPostWithHeaders
  (url : @& String)
  (headers : @& Array (String × String))
  (body : @& String)
  : IO String

end Curl
