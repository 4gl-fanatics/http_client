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
    File        : DatasetWebHandler
    Purpose     : Returns a dataset as JSON
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2023-03-15
    Notes       : * Configure as handlerN=server.DatasetWebHandler:/Customers
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using OpenEdge.Web.*.
using Progress.Json.ObjectModel.* from propath.
using OpenEdge.Net.HTTP.*.

class server.DatasetWebHandler inherits WebHandler:
    define temp-table eCustomer no-undo like Customer.
    define dataset dsCustomer for eCustomer.

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
        define variable oBody as JsonObject no-undo.
        define variable iCustNum as integer no-undo.

        /* Get the data */
        oBody = new JsonObject().

        /* Read the poRequest:PathInfo to figure out what to return */
        if poRequest:PathInfo begins "/Customers/":u then do:
            iCustNum = integer(entry(3, poRequest:PathInfo, "/":u)).

            find Customer where Customer.CustNum = iCustNum
                          no-lock.

            create eCustomer.
            buffer-copy Customer to eCustomer.

            dataset dsCustomer:write-json("JsonObject":u, oBody).
        end.

        /* Build the response */
        oResp = new WebResponse().
        oResp:StatusCode = 200.
        oResp:ContentType = "application/prodataset+json":u.
        oResp:Entity = oBody.

        /* Return data */
        oWriter = new WebResponseWriter(oResp).
        oWriter:Open().
        oWriter:Close().

        return 0.
    end method.

end class.
