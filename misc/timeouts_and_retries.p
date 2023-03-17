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
    File        : timeouts_and_retries.p
    Purpose     : Shows various timeouts and retry options
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2023-03-16
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using OpenEdge.Core.*                            from propath.
using OpenEdge.Core.Collections.*                from propath.
using OpenEdge.Net.*                             from propath.
using OpenEdge.Net.HTTP.*                        from propath.
using OpenEdge.Net.HTTP.Lib.ClientLibraryBuilder from propath.
using OpenEdge.Net.ServerConnection.*            from propath.
using Progress.Json.ObjectModel.*                from propath.

define variable oHttpClient as IHttpClient no-undo.
define variable oReq as IHttpRequest no-undo.
define variable oResp as IHttpResponse no-undo.
define variable dtTimer as datetime extent 2 no-undo.
define variable oParameters as ClientSocketConnectionParameters no-undo.
define variable oLibrary as IHttpClientLibrary no-undo.

oParameters = new ClientSocketConnectionParameters().

/* This usually times out, just to show. 0=no-timeout
 oParameters:ConnectTimeout = 1.     /* milliseconds */
 */

oLibrary = ClientLibraryBuilder:Build()
                :Option(get-class(ClientSocketConnectionParameters):TypeName, oParameters)
                :Library.

oHttpClient = ClientBuilder:Build()
                :AllowTracing(true)

                /* Specify custom tracing; defaults to PROPATH
                :TracingConfig("cfg/hctracing.config")
                trace_<mtime>.json shows the various redirects as individual
                output
                */

                :SetNumRetries(1)   /* default=10*/
                /* How long to wait between retries; default=0 */
                :SetRetryPause(5.0)

                :SetRequestTimeout(10.0)

                :UsingLibrary(oLibrary)

                :Client.

oReq = RequestBuilder:Get("http://httpbin.org/redirect/10")
        :Request.

dtTimer[1] = now.
oResp = oHttpClient:Execute(oReq).
dtTimer[2] = now.

message
oResp:StatusCode skip
oResp:ContentType skip
oResp:ContentLength skip
oResp:Entity skip
interval(dtTimer[2], dtTimer[1], "milliseconds")
view-as alert-box.

