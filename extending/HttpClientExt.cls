
 /*------------------------------------------------------------------------
    File        : HttpClientExt
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Peter
    Created     : Thu Feb 23 13:01:29 EST 2023
    Notes       :
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

    method override public void EXECUTE(poRequest  as IHttpRequest,
                                        poResponse as IHttpResponse):
        super:Execute(poRequest, poResponse).

        catch e as Progress.Lang.Error :
            this-object:WriteTraceData().
            this-object:ClearTraceData().
        end catch.
    end method.

end class.