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
    File        : header.p
    Purpose     : Use a header to privde an API key or similar
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2023-03-16
    Notes       :
  ----------------------------------------------------------------------*/
@lowercase.

block-level on error undo, throw.

using OpenEdge.Net.HTTP.* from propath.

define variable oHttpClient as IHttpClient no-undo.
define variable oReq as IHttpRequest no-undo.
define variable oResp as IHttpResponse no-undo.
define variable cBearerToken as character no-undo.

session:debug-alert = no .

log-manager:logfile-name = session:temp-dir + 'basic_auth.log'.
log-manager:logging-level = 5.
log-manager:clear-log().

/* Make a request */
oHttpClient = ClientBuilder:Build():Client.

oReq = RequestBuilder:Get("http://httpbin.org/get")
        :AddHeader("Authorization", "bearer " + cBearerToken)
        :Request.

/* Make multiple requests */
oResp = oHttpClient:Execute(oReq).

message
oResp:StatusCode skip
oResp:ContentType skip
oResp:ContentLength skip
oResp:Entity
view-as alert-box.
