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
    File        : ssl.p
    Purpose     : SSL examples
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2023-03-16
    Notes       :
  ----------------------------------------------------------------------*/
@lowercase.


block-level on error undo, throw.

using OpenEdge.Net.HTTP.* from propath.

define variable oReq as IHttpRequest no-undo.
define variable oResp as IHttpResponse no-undo.
define variable oHttpClient as IHttpClient no-undo.

/* Create once */
oHttpClient = ClientBuilder:Build():Client.

/* Results in an error -54 due to no ROOT CA being loaded
   To fix, open ProEnv and run
    certutil -import cfg/gts-root-r1.pem
*/

oReq = RequestBuilder:Get("https://google.com")
        :Request.

/* Make multiple requests */
oResp = oHttpClient:Execute(oReq).

message
    oResp:StatusCode skip
    oResp:ContentType skip
    oResp:ContentLength skip
    oResp:Entity
view-as alert-box.

catch err as Progress.Lang.Error:
    message
        err:GetMessage(1) skip
        err:GetMessage(2) skip
        err:GetMessage(3) skip
    view-as alert-box title "ERROR".
end catch.


