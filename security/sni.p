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
    File        : sni.p
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2023-03-16
    Notes       : - Make sure cfg/amazon-root-ca-1.pem has been imported
                  - This procedure will never return successful data, because
                    we don't have login/credentials for Survey Monkey. It is
                    intended to show using the ServerNameIndicator
  ----------------------------------------------------------------------*/
@lowercase.

block-level on error undo, throw.

using OpenEdge.Net.HTTP.* from propath.
using OpenEdge.Net.HTTP.Lib.* from propath.

/* ***************************  Main Block  *************************** */
define variable oClient as IHttpClient   no-undo.
define variable oRequest as IHttpRequest  no-undo.
define variable oResponse as IHttpResponse no-undo.
define variable oLib as IHttpClientLibrary no-undo.

session:debug-alert = no .

log-manager:logfile-name = session:temp-dir + 'sni.log'.
log-manager:logging-level = 5.
log-manager:clear-log().


oLib = ClientLibraryBuilder:Build()
            :ServerNameIndicator("api.surveymonkey.com")
            :Library.

oClient = ClientBuilder:Build()
                :UsingLibrary(oLib)
                :Client.

oRequest = RequestBuilder:Get("https://api.surveymonkey.com/v3/docs")
                :Request.
oResponse = oClient:Execute(oRequest).

if oResponse:StatusCode eq 200 then
  message "Completed" view-as alert-box information.
else
    message "Error" oResponse:StatusReason view-as alert-box.

catch e as Progress.Lang.Error :
    message
    e:GetMessage(1)
    view-as alert-box.
end catch.