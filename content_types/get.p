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
    Notes       :
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

run write_response (oResp:Entity, oResp:ContentType, "document").

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

run write_response (oResp:Entity, oResp:ContentType, "document").

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

run write_response (oResp:Entity, oResp:ContentType, "document").

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

run write_response (oResp:Entity, oResp:ContentType, "picture").

/** SVG **/
oReq = RequestBuilder:Get("http://httpbin.org/image")
        :AcceptContentType("image/svg+xml")
        /* Use this first, see the JSON payload returned
        :AcceptContentType("image/svg")
        */
        :Request.

/* Make multiple requests */
oResp = oHttpClient:Execute(oReq).

message
oResp:StatusCode skip
oResp:ContentType skip
oResp:ContentLength skip
oResp:Entity
view-as alert-box.

run write_response (oResp:Entity, oResp:ContentType, "picture").

procedure write_response:
    define input parameter poBody as Progress.Lang.Object no-undo.
    define input parameter pcContentType as character no-undo.
    define input parameter pcFileNameBase as character no-undo.

    define variable cMimeType as character extent 2.

    cMimeType = MimeTypeHelper:SplitType(pcContentType).

    /* This code needs checking of the poBody's OOABL type too */
    if cMimeType[2] = "json" then cast(poBody, JsonConstruct):WriteFile(pcFileNameBase + ".json", yes).
    else if cMimeType[1] = "image" then do:
        copy-lob from cast(poBody, ByteBucket):GetBytes():Value to file pcFileNameBase + "." + cMimeType[2].
    end.
    else if cMimeType[2] = "xml" then
        cast(poBody, WidgetHandle):Value:save("file", pcFileNameBase + ".xml").
    else if cMimeType[1] = "text" then
        copy-lob from cast(poBody, String):Value to file pcFileNameBase + "." + cMimeType[2].
    else if cMimeType[2] = "octet-stream" then
        copy-lob from cast(poBody, ByteBucket):GetBytes():Value to file pcFileNameBase + ".bin".

end procedure.