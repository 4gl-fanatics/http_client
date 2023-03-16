# http_client
HTTP Client  Workshop exercises

Requires $DLC/*/netlib/OpenEdge.Net.pl on PROPATH

## Making requests ##

Json
http://httpbin.org/get
https://petstore.swagger.io/v2/store/order/3
XML - https://httpbin.org/xml



## Extending the HTTP client ##
Decorator pattern & plugins (registry)
Client
Handling status codes: redirects (30*, 401)
Eg 404 throws an app error
Custom
Authentication callbacks
Client library
Writers
Eg JSON -> ProDataSet (WidgetHandle instance)
