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
    File        : authentication_callback.p
    Purpose     : SHows use of authentication callback
    Syntax      :
    Description :
    Author(s)   : Author / Consultingwerk Ltd.
    Created     : 2023-03-15
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using extending.* from propath.
using OpenEdge.Core.*.
using OpenEdge.Net.*.
using OpenEdge.Net.HTTP.*.
using OpenEdge.Net.HTTP.Filter.Writer.*.
using Progress.Json.ObjectModel.* from propath.
using Progress.Lang.* from propath.

define variable oHttpClient as IHttpClient no-undo.
define variable oReq as IHttpRequest no-undo.
define variable oResp as IHttpResponse no-undo.

/* Make a request */
oHttpClient = ClientBuilder:Build():Client.

oReq = RequestBuilder:Get("http://httpbin.org/basic-auth/bob/sofia")
        :AuthCallback(this-procedure)
        /* ALT :AuthCallback(new AuthenticationPrompt()) */
        :Request.

/* Make multiple requests */
oResp = oHttpClient:Execute(oReq).

message
oResp:StatusCode skip
oResp:ContentType skip
oResp:ContentLength skip
oResp:Entity
view-as alert-box.

/** Event handler for the HttpCredentialRequest event.

    @param Object The filter object that publishes the event.
    @param AuthenticationRequestEventArgs The event args for the event */
procedure AuthFilter_HttpCredentialRequestHandler:
    define input parameter poSender as Object no-undo.
    define input parameter poEventArgs as AuthenticationRequestEventArgs no-undo.

    /* password prompt here */
    message
        "prompt for user/pass for " poEventArgs:Realm
    view-as alert-box title "IN PROCEDURE".

    poEventArgs:Credentials = new Credentials(poEventArgs:Realm, "bob", "sofia").

end procedure.