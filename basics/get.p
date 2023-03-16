/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
    File        : get.p
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd
    Notes       : Swagger docs:
                    HTTP Bin : https://httpbin.org/
                    Swagger Petstore : https://petstore.swagger.io/
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using OpenEdge.Core.*.
using OpenEdge.Net.*.
using OpenEdge.Net.HTTP.*.
using Progress.Json.ObjectModel.* from propath.

define variable oHttpClient as IHttpClient no-undo.
define variable oReq as IHttpRequest no-undo.
define variable oResp as IHttpResponse no-undo.

/* Create once */
oHttpClient = ClientBuilder:Build():Client.

/** JSON **/
oReq = RequestBuilder:Get("http://httpbin.org/json")
        :Request.

/* Make multiple requests */
oResp = oHttpClient:Execute(oReq).

message
oResp:StatusCode skip
oResp:ContentType skip
oResp:ContentLength skip
oResp:Entity
view-as alert-box.

/** XML **/
oReq = RequestBuilder:Get("http://httpbin.org/xml")
        :Request.

/* Make multiple requests */
oResp = oHttpClient:Execute(oReq).

message
oResp:StatusCode skip
oResp:ContentType skip
oResp:ContentLength skip
oResp:Entity
view-as alert-box.

/** HTML **/
oReq = RequestBuilder:Get("http://httpbin.org/html")
        :Request.

/* Make multiple requests */
oResp = oHttpClient:Execute(oReq).

message
oResp:StatusCode skip
oResp:ContentType skip
oResp:ContentLength skip
oResp:Entity
view-as alert-box.

/** PNG **/
oReq = RequestBuilder:Get("http://httpbin.org/image/png")
        :Request.

/* Make multiple requests */
oResp = oHttpClient:Execute(oReq).

message
oResp:StatusCode skip
oResp:ContentType skip
oResp:ContentLength skip
oResp:Entity
view-as alert-box.

/** Swagger Petstore
    https://petstore.swagger.io/
**/
oReq = RequestBuilder:Get("http://petstore.swagger.io/v2/store/order/3")
        :Request.

/* Make multiple requests */
oResp = oHttpClient:Execute(oReq).

message
oResp:StatusCode skip
oResp:ContentType skip
oResp:ContentLength skip
oResp:Entity
view-as alert-box.

if MimeTypeHelper:IsJson(oResp:ContentType) then
    cast(oResp:Entity, JsonConstruct):WriteFile("resp.json", yes).

