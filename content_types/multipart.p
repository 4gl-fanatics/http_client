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
    File        : multipart.p
    Purpose     : Working with multipart messages
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2023-03-16
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Ccs.Common.Support.* from propath.
using OpenEdge.Net.* from propath.
using OpenEdge.Net.HTTP.* from propath.
using Progress.IO.* from propath.
using Progress.Json.ObjectModel.* from propath.

define variable oHttpClient as IHttpClient no-undo.

oHttpClient = ClientBuilder:Build():Client.

run create_multipart.
run read_multipart.

procedure create_multipart:
    define variable oMultipartEntity as MultipartEntity no-undo.
    define variable oPart as MessagePart no-undo.
    define variable oJson as JsonObject no-undo.
    define variable oFile as FileInputStream no-undo.
    define variable oReq as IHttpRequest no-undo.
    define variable oResp as IHttpResponse no-undo.
    define variable oHeader as HttpHeader no-undo.

    /* The multipart message - the "container" */
    oMultipartEntity = new MultipartEntity().
    oMultipartEntity:Boundary = "workshop-boundary".    /*optional*/

    /* Part 1: Person detail */
    oJson = new JsonObject().
    oJson:Add("name", "R. Smith").
    oJson:Add("dob", 2/29/2004).

    oHeader = HttpHeaderBuilder:Build("Content-Disposition")
                    :Value("form-data; name=data")
                    :Header.

    oPart = new MessagePart("application/json", oJson).
    oPart:Headers:Put(oHeader).

    oMultipartEntity:AddPart(oPart).

    /* Part 2: Person photo */
    oFile = new FileInputStream("img/person.png").

    /* Equivalent to the above HttpHeaderBuilder call */
    oHeader = HttpHeaderBuilder:Build("Content-Disposition")
                    :Value("form-data")
                    :AddParameter("name", "photo")
                    :AddParameter("fileName*", "person.png")
                    :Header.

    oPart = new MessagePart("image/png", oFile).
    oPart:Headers:Put(oHeader).
    oMultipartEntity:AddPart(oPart).

    oReq = RequestBuilder:Post("http://httpbin.org/post", oMultipartEntity)
                /* default is multipart/mixed */
                :ContentType("multipart/form-data")
                :Request.

    oResp = oHttpClient:Execute(oReq).

    message
    oResp:StatusCode skip
    oResp:ContentType skip
    oResp:ContentLength skip
    oResp:Entity
    view-as alert-box.

    if MimeTypeHelper:IsJson(oResp:ContentType) then
        cast(oResp:Entity, JsonConstruct):WriteFile("resp.json", yes).

end procedure.

procedure read_multipart:
    define variable oReq as IHttpRequest no-undo.
    define variable oResp as IHttpResponse no-undo.
    define variable oMultipartEntity as MultipartEntity no-undo.
    define variable oPart as MessagePart no-undo.
    define variable iLoop as integer no-undo.
    define variable iCnt as integer no-undo.

    oReq = RequestBuilder:Get("http://localhost:8810/web/multipart")
                :Request.

    oResp = oHttpClient:Execute(oReq).

    message
    oResp:StatusCode skip
    oResp:ContentType skip
    oResp:ContentLength skip
    oResp:Entity
    view-as alert-box.

    oMultipartEntity = cast(oResp:Entity, MultipartEntity).
    iCnt = oMultipartEntity:Size.

    do iLoop = 1 to iCnt:
        oPart = oMultipartEntity:GetPart(iLoop).

        message
        iLoop skip
        oPart
        view-as alert-box.

        if type-of(oPart:Body, JsonConstruct) then
            cast(oPart:Body, JsonConstruct):WriteFile("tmp/part-" + string(iLoop) + ".json", yes).
        else
        if type-of(oPart:Body, IMemptrHolder) then
            copy-lob cast(oPart:Body, IMemptrHolder):Value to file "tmp/part-" + string(iLoop) + ".png".
    end.

end procedure.