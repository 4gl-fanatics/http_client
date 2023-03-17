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
    File        : cookies.p
    Purpose     : Works with stateful client
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2023-03-17
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using OpenEdge.Core.* from propath.
using OpenEdge.Net.* from propath.
using OpenEdge.Net.HTTP.* from propath.
using Progress.Json.ObjectModel.* from propath.

define variable oHttpClient as IHttpClient no-undo.
define variable oReq as IHttpRequest no-undo.
define variable oResp as IHttpResponse no-undo.

oHttpClient = ClientBuilder:Build()
                    /* Run with and without this. The request to /get will send the cookies */
                    :KeepCookies()

                    /* allows  us to see the cookies sent and returned */
                    :AllowTracing(true)
                    :TracingConfig("troubleshooting/tracing.config")

                    :Client.

/* Set a cookie */
oReq = RequestBuilder:Get("http://httpbin.org/cookies/set/JSESSIONID/ABC.123"):Request.

oResp = oHttpClient:Execute(oReq).

/* get all the cookies sent to the server */
oReq = RequestBuilder:Get("http://httpbin.org/cookies"):Request.

oResp = oHttpClient:Execute(oReq).

if MimeTypeHelper:IsJson(oResp:ContentType) then
    cast(oResp:Entity, JsonConstruct):WriteFile("cookies.json", yes).

/* "normal" request - HTTP client sends cookies */
oReq = RequestBuilder:Get("http://httpbin.org/headers"):Request.

oResp = oHttpClient:Execute(oReq).

if MimeTypeHelper:IsJson(oResp:ContentType) then
    cast(oResp:Entity, JsonConstruct):WriteFile("resp.json", yes).



