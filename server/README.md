# Server Setup #

The `content_types/multipart.p` and `extending/use_dataset_entity_writer.p` samples call an endpoint on a PASOE instance.

## PASOE Configuration ##
A vanilla/default configuration can be used, with minor modification.

Ports: HTTP=8810, HHTPS=8811 (defaults)

PROPATH should have the Git repo root added to it.

A Sports2000 database should be connected.

### Web handler configuration, classic ###

The `[<abl-app>.ROOT.WEB]` section should have the following handlers added to it. The `handler` values may differ.
```
handler1=server.DatasetWebHandler:/Customers
handler2=server.MultipartWebHandler:/multipart
```

### Web handler configuration, .handlers ###
Alternatively, you can use the newer .handlers approach available since OE 12.2.

Create a `ROOT` directory in `webapps/ROOT/WEB-INF/adapters/web` .
Copy `<repo-root>/cfg/ROOT.handlers` into that directory.
Restart the instance, or [refresh the web handlers](https://docs.progress.com/bundle/pas-for-openedge-reference-122/page/Refresh-web-handlers-for-an-ABL-web-application-jmx-refreshWeb.html) .
