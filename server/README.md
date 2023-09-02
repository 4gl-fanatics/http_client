# Server Setup #

The `content_types/multipart.p` and `extending/use_dataset_entity_writer.p` samples call an endpoint on a PASOE instance.

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
A vanilla/default configuration can be used, with minor modification.

### Create a PASOE instance ###
Open ProEnv
```
proenv> pasman create -f c:\temp\http-client-workshop
```
This uses the default ports: HTTP=8810, HHTPS=8811 and deploys the ROOT, oemanager and manager webapps into the instance.
If you have an instance already running on those ports, they can be changed by adding `-p <http-port> -P <https-port>` to the `pasman`` command


### Update openedge.properties ###
A Sports2000 database must be connected.

Modify the properties in `C:\temp\http-client-workshop\conf\openedge.properties`.

PROPATH must have the Git repo root added to it. Other properties in the section should remain unchanged.

```
[AppServer.Agent.http-client-workshop]
    PROPATH=<repo-root>,${CATALINA_BASE}/webapps/ROOT/WEB-INF/openedge,${CATALINA_BASE}/ablapps/http-client-workshop/openedge,${CATALINA_BASE}/openedge,${DLC}/tty,${DLC}/tty/netlib/OpenEdge.Net.pl

```
The startup parameters must have the Sports2000 database added to it. Other properties in the section should remain unchanged.
The path to the Sports2000 database may differ if you did not create a new one.
```
[AppServer.SessMgr.http-client-workshop]
    agentStartupParam=-T "${CATALINA_BASE}\temp" -db c:\temp\sports2000
```

### Web handler configuration, classic ###

The `[http-client-workshop.ROOT.WEB]` section should have the following handlers added to it.
```
handler1=server.DatasetWebHandler:/Customers
handler2=server.MultipartWebHandler:/multipart
```

### Web handler configuration, .handlers (OE12.2+) ###
Alternatively, you can use the newer .handlers approach available since OE 12.2.

Create a `ROOT` directory in `c:/temp/http-client-workshop/webapps/ROOT/WEB-INF/adapters/web` .
Copy `<repo-root>/cfg/ROOT.handlers` into that directory.
Restart the instance, or [refresh the web handlers](https://docs.progress.com/bundle/pas-for-openedge-reference-122/page/Refresh-web-handlers-for-an-ABL-web-application-jmx-refreshWeb.html) .

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



