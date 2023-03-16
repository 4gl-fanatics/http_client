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
    File        : trouble_logging...p
    Purpose     : Troubleshooting using logging (pre-125)
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2023-03-16
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using OpenEdge.Core.*.
using OpenEdge.Net.*.
using OpenEdge.Net.HTTP.*.
using OpenEdge.Net.HTTP.Filter.Writer.*.
using Progress.Json.ObjectModel.* from propath.
using Progress.Lang.* from propath.

define variable oHttpClient as IHttpClient no-undo.
define variable oReq as IHttpRequest no-undo.
define variable oResp as IHttpResponse no-undo.
define variable oCredentials as Credentials no-undo.

session:debug-alert = no .

/* Enable logging of HTTP Client */
log-manager:logfile-name = session:temp-dir + 'trouble_logging.log'.
log-manager:logging-level = 6.  /* Level 6 dumps packets from the server; 5 is usually enough */
log-manager:clear-log().

/* Make a request */
oHttpClient = ClientBuilder:Build():Client.

oCredentials = new Credentials("realm", "bob", "sofia").

/* PROVIDE CREDENTIALS. We may not know what the authentication approach is, so let the HttpClient
   figure it out. This will make 2 requests to the server. Only the last one is captured in the
   .txt files */
oReq = RequestBuilder:Get("http://httpbin.org/basic-auth/bob/sofia")
        :UsingCredentials(oCredentials)
        :Request.

/* Make multiple requests */
oResp = oHttpClient:Execute(oReq).

message
oResp:StatusCode skip
oResp:ContentType skip
oResp:ContentLength skip
oResp:Entity
view-as alert-box.

/*
OUTPUT
tmp/trouble_logging.log
tmp/request-raw.txt
tmp/response-data-received.txt
tmp/response-data-child-00001.txt
*/
