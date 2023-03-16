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
    File        : DatasetEntityWriter
    Purpose     : ${input#description#}
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2023-03-15
    Notes       :
  ----------------------------------------------------------------------*/
@lowercase.

block-level on error undo, throw.

using OpenEdge.Core.*.
using OpenEdge.Net.HTTP.Filter.Payload.*.
using Progress.Json.ObjectModel.*.
using Progress.Lang.*.

class extending.DatasetEntityWriter inherits MessageWriter:
    define variable oJsonEntityWriter as JsonEntityWriter no-undo.

    constructor public DatasetEntityWriter():
        super(get-class(WidgetHandle)).

        oJsonEntityWriter = new JsonEntityWriter().
    end constructor.

    /** Write data to/from the entity

        @param Object Data to write */
    method override public int64 Write(poData as Object):
        define variable hDataset as handle no-undo.

        /* Convert the incoming payload to JSON. This will throw an error if it cannot be converted */
        oJsonEntityWriter:Open().
        oJsonEntityWriter:Write(poData).
        oJsonEntityWriter:Close().

        if not type-of(oJsonEntityWriter:Entity, JsonObject) then
            undo, throw new AppError(substitute("&1 not supported for extending.DatasetEntityWriter",
                                                oJsonEntityWriter:Entity:GetClass():TypeName),
                                     0) .

        create dataset hDataset.
        hDataset:read-json("JsonObject", cast(oJsonEntityWriter:Entity, JsonObject)).

        assign this-object:Entity = new WidgetHandle(hDataset, yes).

        return 1.
    end method.

end class.

