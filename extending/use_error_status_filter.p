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
    File        : use_error_status_filter.p
    Purpose     : Using the ErrorStatusFilter
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2023-03-15
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using OpenEdge.Core.*.
using OpenEdge.Net.*.
using OpenEdge.Net.HTTP.*.
using OpenEdge.Net.HTTP.Filter.Writer.*.
using extending.* from propath.
using Progress.Json.ObjectModel.* from propath.

define variable oHttpClient as IHttpClient no-undo.
define variable oReq as IHttpRequest no-undo.
define variable oResp as IHttpResponse no-undo.

/* Register the status handler */
StatusCodeWriterBuilder:Registry:Put("404", get-class(ErrorStatusFilter)).
StatusCodeWriterBuilder:Registry:Put("501", get-class(ErrorStatusFilter)).

/* Make a request */
oHttpClient = ClientBuilder:Build():Client.

oReq = RequestBuilder:Get("http://httpbin.org/status/501")
        :Request.

/* Make multiple requests */
oResp = oHttpClient:Execute(oReq).

catch err as Progress.Lang.Error:
    message
    err:GetMessage(1)
    view-as alert-box title "Caught Error!".
end catch.


