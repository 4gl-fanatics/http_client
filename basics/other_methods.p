/**********************************************************************
 * Copyright (C) 2023-2023 by Consultingwerk Ltd. ("CW") -            *
 * www.consultingwerk.de and other contributors as listed             *
 * below.  All Rights Reserved.                                       *
 *                                                                    *
 *  Software is distributed on an "AS IS", WITHOUT WARRANTY OF ANY    *
 *   KIND, either express or implied.                                 *
 *                                                                    *
 *  Contributors:                                                     *
 *                                                                    *
 **********************************************************************/
/*------------------------------------------------------------------------
    File        : put_post_other.p
    Purpose     : PUT and POST via HttpClient
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2023-03-15
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using OpenEdge.Core.*.
using OpenEdge.Core.Collections.*.
using OpenEdge.Net.*.
using OpenEdge.Net.HTTP.*.
using Progress.Json.ObjectModel.* from propath.

define variable oHttpClient as IHttpClient no-undo.
define variable oReq as IHttpRequest no-undo.
define variable oResp as IHttpResponse no-undo.
define variable oJsonBody as JsonObject no-undo.

/* Create once */
oHttpClient = ClientBuilder:Build():Client.

/** JSON **/
oJsonBody = new JsonObject().
oJsonBody:Add("sentBy", "me").
oJsonBody:Add("sentAt", now).

oReq = RequestBuilder:Patch("http://httpbin.org/patch", oJsonBody)
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


/* HEAD */
oReq = RequestBuilder:Head("http://httpbin.org/get")
        :Request.

/* ALTERNATE
oReq = RequestBuilder:Build("HEAD", URI:Parse("http://httpbin.org/get"))
        :Request.
*/

        /* Make multiple requests */
oResp = oHttpClient:Execute(oReq).

message
oResp:StatusCode skip
oResp:ContentType skip
oResp:ContentLength skip
oResp:Entity
view-as alert-box.


/* OPTIONS */
oReq = RequestBuilder:Options("http://httpbin.org/" )
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

catch err as Progress.Lang.Error:
    message
    err:GetMessage(1)
    view-as alert-box.
end catch.