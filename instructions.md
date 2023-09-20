HTTP Client Workshop - Lab Exercises

# Prerequisites #

OpenEdge installed (11.7+, ideally 12.2.x or later) with a development license/

Familiarity with PDSOE.

A project in PDSOE that optionally contains this repository's code, downloaded.

The project's PROPATH in PDSOE must include `%DLC%/gui/netlib/OpenEdge.Net.pl` (this is done automatically in most cases).

Some examples will work with ABLDojo ( https://abldojo.services.progress.com ) in a browser, but will have to copy & paste code.

## 3rd Party Tools ##

Git client: https://fork.dev/ , more at https://git-scm.com/download/gui/windows


# Server setup #

Certain exercises - for multipart messages, certain content types, and for extensions to the HTTP client for processing ProDataSets  - require a PASOE instance.


## Sports2000 database ##
A Sports2000 database is required for the PASOE instance; either an existing version can be used, or a new one must be created and served.

To create a new Sports2000 database, open ProEnv.
```
proenv>mkdir c:\temp\sports2000
proenv>cd c:\temp\sports2000
proenv>prodb sports2000 sports2000
proenv>proserve sports2000
```

## PASOE Configuration ##
A simple PASOE instance will be created; the configuration is described in this document.

An existing PASOE instance can also be used; in this case the Sports2000 database and the 2 webhandlers must be added to the instance's configuration. That setup is **not** described in this document.

### Create the PASOE instance ###
Open ProEnv
```
proenv> pasman create -f c:\temp\http-client-workshop
```
This uses the default ports: HTTP=8810, HTTPS=8811 and deploys the ROOT, oemanager and manager webapps into the instance.
If you have an instance already running on those ports, they can be changed by adding `-p <http-port> -P <https-port>` to the `pasman` command


### Update openedge.properties ###
A Sports2000 database must be connected, and webhandlers configured. This is all done by modifying properties in `C:\temp\http-client-workshop\conf\openedge.properties`.

#### Propath ####
PROPATH must have the Git repo root added to it. Other properties in the section should remain unchanged.

```
[AppServer.Agent.http-client-workshop]
    PROPATH=<repo-root>,${CATALINA_BASE}/webapps/ROOT/WEB-INF/openedge,${CATALINA_BASE}/ablapps/http-client-workshop/openedge,${CATALINA_BASE}/openedge,${DLC}/tty,${DLC}/tty/netlib/OpenEdge.Net.pl

```
##### Sports2000 db ####
The startup parameters must have the Sports2000 database added to it. The path to the Sports2000 database may differ if you did not create a new one. Other properties in the section should remain unchanged.
```
[AppServer.SessMgr.http-client-workshop]
    agentStartupParam=-T "${CATALINA_BASE}/temp" -db c:/temp/sports2000
```

#### Web handlers ####
The instance must be configured to use the provided webhandlers. Other properties in the section should remain unchanged.

```
[http-client-workshop.ROOT.WEB]
    adapterEnabled=1
    handler1=server.DatasetWebHandler:/Customers
    handler2=server.MultipartWebHandler:/multipart
```

# Starting, stopping an instance #

## (Re)Start the instance ##
Open ProEnv
```
proenv> pasman pasoestart -restart -I http-client-workshop
```

## Stop an instance ##
Open ProEnv
```
proenv> pasman stop -I http-client-workshop
```

# Lab exercises #

Many of the lab exercises use httpbin.org, a publicly available service that describes itself as a "simple HTTP Request & Response Service". In many cases, the request data is returned as a JSON document, which makes it useful for this workshop since

HTTP or HTTPS can be used; to use HTTPS, the certificate at `cfg/amazon-root-ca-1.pem` must be imported into the OpenEge certificate store.

To do so, open ProEnv, and run the `certutil` command.
```
proenv> certutil -import \path\to\repo\cfg\amazon-root-ca-1.pem
```

## Basics ##

### Access basic JSON, XML and image data ###
These exercises make calls to https://httpbin.org to retrieve JSON (GET https://httpbin.org/json), XML (GET https://httpbin.org/xml), HTML (GET https://httpbin.org/html) and image data (GET https://httpbin.org/image/png).

1. Create a new .P (optionally using the template procedure `template.p`)
1. Create an HTTP client instance using the ClientBuilder.
1. Create the request, using the RequestBuilder's `Get` method. Any one of the URLs above can be used.
1. Execute the request, using the client's `Execute()` method.
1. Inspect the response's `StatusCode`, `ContentType` and `ContentLength` properties.
1. Convert the entity (body) into a usable type using the ABL `CAST` function. For example, if the `ContentType` is `application/json` then a variable defined as `Progress.Json.ObjectModel.JsonConstruct` can be used.
    1. The resulting object can now be used by the application. In this workshop, the contents will typically be written to disk for inspection.
1. Also check the OOABL type of the entity object, using the ABL `TYPE-OF` function.

Note: Checks for the OOABL type can use _both_ the `ContentType`` header value and the OOABL type.

Examples are available in `basics/get.p`.

### Submitting data ###
These exercises submit data to various httpbin.org endpoints, using the PUT, POST and other HTTP methods. Different content types are submitted.

1. Create a new .P (optionally using the template procedure `template.p`)
1. Create an HTTP client instance using the ClientBuilder.
1. Create a JSON object with any data in it
1. Create the request, using the RequestBuilder's `Post` method.
    1. The request should POST to https://httpbin.org/post
    1. The JSON object should be passed in to the `Post` method as the second parameter
1. Execute the request and inspect the response. The JSON payload that's returned should contain the submitted JSON in a `json` property in the response, as well as in the `data` property.

The RequestBuilder attempts to determine a content type for the submitted object, but it can be specified in one of 3 ways:
1. Using a 3rd parameter on the `Post` method
1. Using the `ContentType` method on the RequestBuilder
1. Passing the data and content type using the `WithData` method on the RequestBuilder

To show this,
1. Modify the existing .P
1. Define a variable as a LONGCHAR.
1. Use the JSON object's `Write(INPUT-OUTPUT lcVariable)` method to write the JSON data as raw data into the LONGCHAR variable.
1. Create the request, using the RequestBuilder's `Post` method.
    1. The request should POST to https://httpbin.org/post
    1. The LONGCHAR value should be passed in to the `Post` method as the second parameter. An object must be used: `NEW OpenEdge.Core.String(lcValue)` can be used (or a variable defined)
    1. Do **not** otherwise specify the content type
1. Execute the request and inspect the response (save to disk or)
    1. Notice that the `headers.Content-Type` value is `text/html`
1. Modify the request, and add a third parameter to the `Post` method with a value of `application/json`.
1. Run the request again, and inspect the `headers.Content-Type` header value. it will now be `application/json`.

Other HTTP methods such as `DELETE`, `PATCH` and `HEAD` follow the same patterns.

Examples are available in `basics/put_post.p` and `basics/other_methods.p`.

### Setting header values ###

These exercises set a header on a request, and read a header from a response, using httpbin.org endpoints.

1. Create a new .P (optionally using the template procedure `template.p`)
1. Create an HTTP client instance using the ClientBuilder.
1. Create the request, using the RequestBuilder's `Get` method, to https://httpbin.org/get
    1. Add a header value using the `AddHeader(<name>, <value>)` method on the RequestBuilder. For example, set a value for a "X-API-KEY" header.
    1. Any number of headers can be submitted.
1. Execute the request and inspect the response. The JSON payload that's returned should contain the request header name and value in the `headers` property in the response.

The https://httpbin.org/response-headers URL can be used to set the value of the `freeform` response header.
1. Modify the current .P
1. Create the request, using the RequestBuilder's `Get` method, to https://httpbin.org/response-headers?freeform=<some-value-here>
1. Execute the request
1. Inspect the response's headers
    1. Use the  `HasHeader("freeform")` method  to see whether the header is part of the response
    1. Use the `GetHeader("freeform")` method to return a header object.
1. Headers are instances of `OpenEdge.Net.HTTP.HttpHeader` or its child classes
    1. The `Name` and `Value` properties are most frequently used

Note: Calling the `GetHeader()` method for a header that does not exist will return an instance of `OpenEdge.Net.HTTP.NullHeader`. Both the `Name` and `Value` properties return the ABL unknown value.

Examples are available in `basics/headers.p`.

## Content Types ##

**Requires PASOE instance**

This exercise sets the HTTP `Accept` header to influence the content returned from a server. The http://localhost:8810/not-there URL represents a missing URL, and will return a *404/Not Found* response. PASOE will return either a JSON or HTML response, depending on the requested content type (via the `Accept` header).

1. Create a new .P (optionally using the template procedure `template.p`)
1. Create an HTTP client instance using the ClientBuilder.
1. Create the request, using the RequestBuilder's `Get` method, to http://localhost:8810/not-there
    1. Call the `AcceptJson()` method on the RequestBuilder.
1. Execute the request and inspect the response.
    1. The response's `ContentType` property should be `application/json`.
    1. The responses `StatusCode` should be 404.
1. Create the request, using the RequestBuilder's `Get` method, to http://localhost:8810/not-there
    1. Call the `AcceptHtml()` method on the RequestBuilder.
1. Execute the request and inspect the response.
    1. The response's `ContentType` property should be `text/html`.
    1. The responses `StatusCode` should be 404.

The RequestBuilder's `AcceptContentType(<content-type>)` method can also be used for more specific content types.
1. Modify the current .P
1. Create the request, using the RequestBuilder's `Get` method, to https://httpbin.org/image
1. Execute the request and inspect the response.
    1. The response's `ContentType` property should be `application/json`.
    1. The response's `StatusCode` should be *406/Not Acceptable*.
    1. The JSON body that is returned contains an array of supported content types
1. Add `:AcceptContentType("image/svg+xml")` to the RequestBuilder
1. Execute the request and inspect the response.
    1. The response's `ContentType` property should be `image/svg+xml`.
    1. The responses `StatusCode` should be *200/OK*.

Examples are available in `content_types/accept.p`.

**Requires PASOE instance**

The HTTP client supports writing and reading multipart messages. The `content_types/multipart.p` program is provided to illustrate the use of multipart messages:
- In the `create_multipart` internal procedure, an instance of `OpenEdge.Net.MultipartEntity` is created with 2 parts (each instances of `OpenEdge.Net.MessagePart`). One part contains JSON data about a person, and the second a "photo" of the person.
- In the `read_multipart` internal procedure, the PASOE instance returns a similar multipart message. The HTTP client creates an instance of `OpenEdge.Net.MultipartEntity` with the same 2 parts (each instances of `OpenEdge.Net.MessagePart`)


## Security ##

HTTP
security/basic_auth.p
security/authentication_callback.p
security/authentication_callback_bearer.p
security/header.p

TLS
security/bbc.p
security/sni.p


## Troubleshooting ##

troubleshooting/trouble_logging.p
troubleshooting/trouble_tracing.p
troubleshooting/ssl.p


## Customisation ##

extending/use_error_status_filter.p
Status codes throw error

**Requires PASOE instance**

extending/use_dataset_entity_writer.p
Returns a ProDataSet from JSON

troubleshooting/trouble_tracing.p
Extends/replaces the default HttpClient

security/authentication_callback_bearer.p
Adds a custom authentication filter for Bearer



### Using a stateful client ###

basics_cookies.p

## Timeouts and retries ###

misc/timeouts_and_retries.p
