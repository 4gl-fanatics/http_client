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
    File        : use_dataset_entity_writer.p
    Purpose     : ${input#description#}
    Syntax      :
    Description :
    Author(s)   : Author / Consultingwerk Ltd.
    Created     : 2023-03-15
    Notes       :
  ----------------------------------------------------------------------*/
@lowercase.

block-level on error undo, throw.

using OpenEdge.Core.*.
using OpenEdge.Net.HTTP.*.
using Progress.Json.ObjectModel.* from propath.
using extending.*.
using OpenEdge.Net.HTTP.Filter.Writer.*.

define variable oHttpClient as IHttpClient no-undo.
define variable oReq as IHttpRequest no-undo.
define variable oResp as IHttpResponse no-undo.
define variable hDataset as handle no-undo.
define variable hBuffer as handle no-undo.

/* Register the writer for use */
EntityWriterRegistry:Registry:Put("application/prodataset+json":u,
                                  get-class(DatasetEntityWriter)).

/* Create once */
oHttpClient = ClientBuilder:Build():Client.

/** JSON **/
oReq = RequestBuilder:Get("http://localhost:8810/web/Customers/1":u)
        :Request.

/* Make multiple requests */
oResp = oHttpClient:Execute(oReq).

if type-of(oResp:Entity, WidgetHandle) then do:
    hDataset = cast(oResp:Entity, WidgetHandle):Value.
    //hDataset:write-json("file", "resp.json", yes).

    hBuffer = hDataset:get-buffer-handle(1).
    hbuffer:find-first().

    message
      hBuffer::CustNum skip
      hBuffer::Name skip
    view-as alert-box.
end.

catch err as Progress.Lang.Error:
    message
    err:GetMessage(1)
    view-as alert-box.
end catch.