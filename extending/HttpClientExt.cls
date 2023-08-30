
 /*------------------------------------------------------------------------
    File        : HttpClientExt
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Peter
    Created     : Thu Feb 23 13:01:29 EST 2023
    Notes       : - workaround for an issue in the shipped HttpClient
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using OpenEdge.Net.HTTP.* from propath.
using Progress.Lang.*     from propath.

class extending.HttpClientExt inherits HttpClient:

    constructor public HttpClientExt(pcClientName    as character,
                                     pcClientVersion as character,
                                     poLibrary as IHttpClientLibrary):
        super(pcClientName, pcClientVersion, poLibrary).
    end constructor.

    method override public void Execute(poRequest  as IHttpRequest,
                                        poResponse as IHttpResponse):
        super:Execute(poRequest, poResponse).

&if proversion begins "12.5":u  &then
        /* tracing only available from 12.5+; this catch block is not needed in 12.6+ */
        catch e as Progress.Lang.Error :
            this-object:WriteTraceData().
            this-object:ClearTraceData().
        end catch.
&endif
    end method.

end class.