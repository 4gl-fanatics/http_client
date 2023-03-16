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
    File        : bbc.p
    Purpose     : Requests the BBC home page. By defautl, BBC.COM uses TLSv1.3
                  which is not supported in OE 12.6 or earlier. This program forces
                  the connection to use TLSv1.2 or TLSv1.1
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Notes       : - From the thread at https://community.progress.com/s/question/0D74Q000009TtU0SAK/detail
                  - Debugging SSL (https://community.progress.com/s/article/P121819) using environment variable
                    The following is a list of the possible values for SSLSYS_DEBUG_LOGGING and what they yield:
                        SSLSYS_DEBUG_LOGGING=1, logs only errors
                        SSLSYS_DEBUG_LOGGING=2, as 1 above and progress internal ssl messages
                        SSLSYS_DEBUG_LOGGING=3, as 2 above plus rsa state information
                        SSLSYS_DEBUG_LOGGING=4, as 3 above plus rsa buffer information
                        SSLSYS_DEBUG_LOGGING=5, as 4 above plus rsa buffer dumps
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using OpenEdge.Net.HTTP.*  from propath.
using OpenEdge.Net.HTTP.Lib.*  from propath.
using OpenEdge.Net.ServerConnection.* from propath.

/* ***************************  Main Block  *************************** */
define variable oClient as IHttpClient   no-undo.
define variable oRequest as IHttpRequest  no-undo.
define variable oResponse as IHttpResponse no-undo.
define variable cUrl as character no-undo init "https://bbc.com".
define variable oLib as IHttpClientLibrary no-undo.
define variable cSSLProtocols as character extent 2 no-undo.

session:debug-alert = no .

log-manager:logfile-name = session:temp-dir + 'bbc.log'.
log-manager:logging-level = 5.
log-manager:clear-log().

cSSLProtocols[1] = 'TLSv1.2'.
cSSLProtocols[2] = 'TLSv1.1'.

oLib = ClientLibraryBuilder:Build()
                /* With incorrect protocols this takes ~10min to time out */
                :SetSSLProtocols(cSSLProtocols)
                :Library.

oClient = ClientBuilder:Build()
                :UsingLibrary(oLib)
                :Client.

oRequest = RequestBuilder:Get(cUrl):Request.
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