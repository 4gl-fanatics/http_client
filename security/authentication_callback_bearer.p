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
    Purpose     : Shows use of authentication callback
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2023-03-15
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using security.* from propath.
using OpenEdge.Core.*.
using OpenEdge.Net.*.
using OpenEdge.Net.HTTP.*.
using OpenEdge.Net.HTTP.Filter.Writer.*.
using Progress.Json.ObjectModel.* from propath.
using Progress.Lang.* from propath.

define variable oHttpClient as IHttpClient no-undo.
define variable oReq as IHttpRequest no-undo.
define variable oResp as IHttpResponse no-undo.

OpenEdge.Net.HTTP.Filter.Writer.AuthenticationRequestWriterBuilder:Registry:Put(string(AuthenticationMethodEnum:Bearer),
                                                                                get-class(BearerAuthenticationFilter)).

/* Make a request */
oHttpClient = ClientBuilder:Build():Client.

oReq = RequestBuilder:Get("http://httpbin.org/bearer")
        :AuthCallback(this-procedure)
        :Request.

oResp = oHttpClient:Execute(oReq).

message
oResp:StatusCode skip
oResp:ContentType skip
oResp:ContentLength skip(2)
string(cast(oResp:Entity, JsonObject):GetJsonText())
view-as alert-box
.

catch err as Progress.Lang.Error:
    message
    err:GetMessage(1)
    view-as alert-box.
end catch.

/** Event handler for the HttpCredentialRequest event.

    @param Object The filter object that publishes the event.
    @param AuthenticationRequestEventArgs The event args for the event */
procedure AuthFilter_HttpCredentialRequestHandler:
    define input parameter poSender as Object no-undo.
    define input parameter poEventArgs as AuthenticationRequestEventArgs no-undo.

    /* password prompt here */
    message
        "prompt for user/pass for " poEventArgs:Realm
    view-as alert-box title "IN PROCEDURE"
    .

    /* The Pasword is used for the token */
    poEventArgs:Credentials = new Credentials(poEventArgs:Realm, "bob", "sofia").

end procedure.
