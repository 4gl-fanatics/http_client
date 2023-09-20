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
    File        : template.p
    Purpose     : A template for making HTTP Client calls, including boilerplate
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
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


/* Create HTTP client once  */
oHttpClient = ClientBuilder:Build():Client.


/* Create an HTTP request */


/* Make the request to the server */
oResp = oHttpClient:Execute(oReq).


/* Process the response */

message
    oResp:StatusCode skip
    oResp:ContentType skip
    oResp:ContentLength
view-as alert-box.

catch err as Progress.Lang.Error:
    message
        err:GetMessage(1)
    view-as alert-box error title "Whoops!".
end catch.