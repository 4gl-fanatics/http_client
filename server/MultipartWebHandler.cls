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
    File        : MultipartWebHandler
    Purpose     : Returns a dataset as JSON
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2023-03-15
    Notes       : * Configure as handlerN=server.MultipartWebHandler:/multipart
                  * Requires the workshop repo on PROPATH
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using OpenEdge.Net.* from propath.
using OpenEdge.Web.*.
using Progress.IO.* from propath.
using Progress.Json.ObjectModel.* from propath.
using OpenEdge.Net.HTTP.*.

class server.MultipartWebHandler inherits WebHandler:

    /* Handler for unsupported methods

       @param IWebRequest The request being serviced
       @return integer An optional status code. A zero or null value means this
                              method will deal with all errors */
    method override protected integer HandleNotAllowedMethod(poRequest as IWebRequest):
        return integer(StatusCodeEnum:MethodNotAllowed).
    end method.

    /* Handler for unknown methods

       @param IWebRequest The request being serviced
       @return integer An optional status code. A zero or null value means this
                              method will deal with all errors */
    method override protected integer HandleNotImplemented(poRequest as IWebRequest):
        return integer(StatusCodeEnum:NotImplemented).
    end method.

    /* Handler for unknown methods

       @param IWebRequest The request being serviced
       @return integer An optional status code. A zero or null value means this
                              method will deal with all errors */
    method override protected integer HandleGet(poRequest as IWebRequest):
        define variable oResp as WebResponse no-undo.
        define variable oWriter as WebResponseWriter no-undo.
        define variable oMultipartEntity as MultipartEntity no-undo.
        define variable oPart as MessagePart no-undo.
        define variable oJson as JsonObject no-undo.
        define variable oFile as FileInputStream no-undo.
        define variable oHeader as HttpHeader no-undo.

        /* The multipart message - the "container" */
        oMultipartEntity = new MultipartEntity().
        oMultipartEntity:Boundary = "workshop-server-boundary".    /* optional */

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
        file-info:file-name = "img/person.png".
        oFile = new FileInputStream(file-info:full-pathname).

        /* Equivalent to the above HttpHeaderBuilder call */
        oHeader = HttpHeaderBuilder:Build("Content-Disposition")
                        :Value("form-data")
                        :AddParameter("name", "photo")
                        :AddParameter("fileName*", "person.png")
                        :Header.

        oPart = new MessagePart("image/png", oFile).
        oPart:Headers:Put(oHeader).
        oMultipartEntity:AddPart(oPart).


        /* Build the response */
        oResp = new WebResponse().
        oResp:StatusCode = 200.

        /* NOTE - the boundary is NOT automatically added */
        oResp:ContentType = "multipart/form-data; boundary=":u + oMultipartEntity:Boundary.
        oResp:Entity = oMultipartEntity.

        /* Return data */
        oWriter = new WebResponseWriter(oResp).
        oWriter:Open().
        oWriter:Close().

        return 0.
    end method.

end class.
