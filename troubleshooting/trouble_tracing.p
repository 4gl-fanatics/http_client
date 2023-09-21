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
    File        : trouble_tracing.p
    Purpose     : Troubleshooting using tracing
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2023-03-16
    Notes       :
  ----------------------------------------------------------------------*/
@lowercase.

block-level on error undo, throw.

using OpenEdge.Net.HTTP.* from propath.
using extending.* from propath.

&if proversion begins "12.5":u  &then
/* Workaround for a bug fixed in 12.6 */
OpenEdge.Net.HTTP.ClientBuilder:Registry:Put(get-class(IHttpClient):TypeName,
                                             get-class(HttpClientExt)).
&endif

define variable oHttpClient as IHttpClient no-undo.
define variable oReq as IHttpRequest no-undo.
define variable oResp as IHttpResponse no-undo.
define variable oCredentials as Credentials no-undo.

/* Make a request */
oHttpClient = ClientBuilder:Build()
                :AllowTracing(true)
                /* Specify custom tracing; defaults to PROPATH */
                :TracingConfig("troubleshooting/tracing.config")
                :Client.

oCredentials = new Credentials("realm", "bob", "sofia").

/* PROVIDE CREDENTIALS. We may not know what the authentication approach is, so let the HttpClient
   figure it out. This will make 2 requests to the server. Both of these are captured in the trace data */
oReq = RequestBuilder:Get("http://httpbin.org/basic-auth/bob/sofia")
        :UsingCredentials(oCredentials)
        /* Individual requests can programatically opt out of tracing
        :AllowTracing(false) */
        :Request.

/* Make multiple requests */
oResp = oHttpClient:Execute(oReq).

oReq = RequestBuilder:Get("http://httpbin.org/get")
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
tmp/trace_<Mtime>.json
*/

