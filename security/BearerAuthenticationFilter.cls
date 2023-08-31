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
    File        : BearerAuthenticationFilter
    Purpose     :
    Author(s)   : Peter Judge / Consultingwerk Ltd
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.StringConstant.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.Filter.Auth.AuthenticationRequestFilter.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.IAuthenticatedRequest.
using Progress.Lang.AppError.

class security.BearerAuthenticationFilter inherits AuthenticationRequestFilter:
     /** Constructor

        @param IAuthenticatedRequest The request being authenticated. */
    constructor public BearerAuthenticationFilter (input poRequest as IAuthenticatedRequest ):
        super (input poRequest).
    end constructor.

    /** Build the actual authentication. To be implemented by concrete classes. */
    method override protected void AddAuthentication():
        define variable cCredentials as character no-undo.
        define variable oCredentials as Credentials no-undo.

        assign oCredentials = GetCredentials("Bearer").
        if not valid-object(oCredentials) then
            return error new AppError('Missing credentials for Bearer', 0).

        assign cCredentials = substitute('Bearer &1':u, oCredentials:Password).
        /* add to the request */
        this-object:Message:SetHeader(
            HttpHeaderBuilder:Build('Authorization':u):Value(cCredentials):Header).

    end method.

end class.