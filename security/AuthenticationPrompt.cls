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
    File        : AuthenticationPrompt
    Purpose     : ${input#description#}
    Syntax      :
    Description :
    Author(s)   : Author / Consultingwerk Ltd.
    Created     : 2023-03-15
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

@lowercase.

using OpenEdge.Net.HTTP.* from propath.
using Progress.Lang.* from propath.
using OpenEdge.Net.HTTP.Filter.Auth.* from propath.

class security.AuthenticationPrompt implements IAuthFilterEventHandler:

    /** Event handler for the HttpCredentialRequest event.

        @param Object The filter object that publishes the event.
        @param AuthenticationRequestEventArgs The event args for the event */
    method public void AuthFilter_HttpCredentialRequestHandler(
                                input poSender as Object,
                                input poEventArgs as AuthenticationRequestEventArgs):
        message
            "prompt for user/pass for " poEventArgs:Realm
        view-as alert-box title "IN CLASS".

        poEventArgs:Credentials = new Credentials(poEventArgs:Realm, "bob", "sofia").

    end method.

end class.
