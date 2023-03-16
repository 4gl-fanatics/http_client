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
    File        : ErrorStatusFilter
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
using OpenEdge.Net.HTTP.* from propath.
using Progress.Lang.* from propath.

class extending.ErrorStatusFilter
    implements IHttpMessageWriter:

    define variable oResponse as IHttpResponse no-undo.

    /** (mandatory) The message that's being written to. The values passed in to the Write() methods
        will be parsed/processed and writted to this message. */
    define public property Message as IHttpMessage no-undo get. private set.

    /* Constructor.

       @param IHttpRequest The request for to which this status response applies */
    constructor public ErrorStatusFilter(poMessage as IHttpRequest):
        Assert:NotNull(poMessage, 'Http request').

        assign this-object:Message = poMessage.
    end constructor.

    /** Opens the writer for output. Open/Close allows us to write the same message multiple
        times without requiring a new writer each time. */
    method public void Open():
        assign oResponse = ?.
    end method.

    method public void Write(input poData as Object):
        Assert:IsType(poData, get-class(IHttpResponse)).

        assign oResponse = cast(poData, IHttpResponse).
    end method.

    /** Write data to/from the message

        @param longchar Data to write */
    method public void Write(input-output pcData as longchar):
    end method.

    /** Write data to/from the message

        @param handle Data to write */
    method public void Write(phData as handle):
    end method.

    /** Write data to/from the message

        @param character Data to write */
    method public void Write(input-output pcData as character):
    end method.

    /** Write data to/from the message

        @param memptr Data to write */
    method public void Write(pmData as memptr):
    end method.

    /**  Flushes data to the output location. What data is flushed depends on the implementation */
    method public void Flush():
        undo, throw new AppError(substitute("Request to &1 returned status code &2",
                                            cast(this-object:Message, IHttpRequest):URI:ToString(),
                                            oResponse:StatusCode),
                                 0).
    end method.

    /**  Closes the output. See Open() */
    method public void Close():
        this-object:Flush().

        finally:
            assign oResponse = ?.
        end finally.
    end method.

end class.
