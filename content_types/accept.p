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
    File        : accept.p
    Purpose     : Set Accept header
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2023-03-15
    Notes       :
  ----------------------------------------------------------------------*/
@lowercase.

block-level on error undo, throw.

using OpenEdge.Net.HTTP.* from propath.

define variable oHttpClient as IHttpClient no-undo.
define variable oReq as IHttpRequest no-undo.
define variable oResp as IHttpResponse no-undo.

session:debug-alert = no .

log-manager:logfile-name = session:temp-dir + 'accept.log'.
log-manager:logging-level = 5.
log-manager:clear-log().


/* Make a request */
oHttpClient = ClientBuilder:Build():Client.


/* This should fail with 403, and return JSON */
oReq = RequestBuilder:Get("http://localhost:8810/not-there")
        :AcceptJson()
        :Request.

oResp = oHttpClient:Execute(oReq).

message
oResp:StatusCode skip
oResp:ContentType skip
oResp:ContentLength skip
oResp:Entity
view-as alert-box.

/* This should fail with 403, and return HTML */
oReq = RequestBuilder:Get("http://localhost:8810/not-there")
        :AcceptHtml()
        :Request.

/* Make multiple requests */
oResp = oHttpClient:Execute(oReq).

message
oResp:StatusCode skip
oResp:ContentType skip
oResp:ContentLength skip
oResp:Entity
view-as alert-box.

/* This should fail with 403, and return HTML since the server cannot return XML */
oReq = RequestBuilder:Get("http://localhost:8810/not-there")
        :AcceptContentType("application/xml")
        :Request.

/* Make multiple requests */
oResp = oHttpClient:Execute(oReq).

message
oResp:StatusCode skip
oResp:ContentType skip
oResp:ContentLength skip
oResp:Entity
view-as alert-box.

