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
    File        : put_post.p
    Purpose     : PUT and POST via HttpClient
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2023-03-15
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using OpenEdge.Core.* from propath.
using OpenEdge.Core.Collections.* from propath.
using OpenEdge.Net.* from propath.
using OpenEdge.Net.HTTP.* from propath.
using Progress.Json.ObjectModel.* from propath.

define variable oHttpClient as IHttpClient no-undo.
define variable oReq as IHttpRequest no-undo.
define variable oResp as IHttpResponse no-undo.
define variable oJsonBody as JsonObject no-undo.
define variable oFormBody as IStringStringMap no-undo.
define variable oStringBody as OpenEdge.Core.String no-undo.

/* Create once */
oHttpClient = ClientBuilder:Build():Client.

/** JSON **/
oJsonBody = new JsonObject().
oJsonBody:Add("sentBy", "me").
oJsonBody:Add("sentAt", now).

oReq = RequestBuilder:Post("http://httpbin.org/post", oJsonBody)
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
    cast(oResp:Entity, JsonConstruct):WriteFile("resp1.json", yes).

/** FORM FIELDS 1 **/

oFormBody = new StringStringMap().
oFormBody:Put("fldSentAt", iso-date(now)).
oFormBody:Put("fldSentBy", "me").

oReq = RequestBuilder:Post("http://httpbin.org/post", oFormBody)
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
    cast(oResp:Entity, JsonConstruct):WriteFile("resp2.json", yes).

/** FORM FIELDS 2 **/
oStringBody = new String("fldSentAt=" + iso-date(now) + "&fldSentBy=me").

/* specify a content-type */
oReq = RequestBuilder:Post(URI:Parse("http://httpbin.org/post"),
                           oStringBody,
                           "application/x-www-form-urlencoded")
        :Request.

/* All variations on the same thing
oReq = RequestBuilder:Post("http://httpbin.org/post", oStringBody)
                  :ContentType("application/x-www-form-urlencoded")
                  :Request.

oReq = RequestBuilder:Post("http://httpbin.org/post")
          :WithData(oStringBody, "application/x-www-form-urlencoded")
          :Request.

oReq = RequestBuilder:Post("http://httpbin.org/post")
          :WithData(oStringBody)
          :ContentType("application/x-www-form-urlencoded")
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

if MimeTypeHelper:IsJson(oResp:ContentType) then
    cast(oResp:Entity, JsonConstruct):WriteFile("resp3.json", yes).
