# XWS DB

This project currently contains the database scripts for all the XWS subsystems.

These subsystems are mapped to individual postgres schema: `xws_alert`, `xws_area`, `xws_notification`, `xws_contact`. Eventually, this repo may get split into a number of separate db repos per each subsystem. Also, they may eventually be installed to separate databases.


## Getting started

***Docker***

It is recommended to run postgres in a docker container. The instructions for running a populated DB and all three XWS applications are found in the [development](https://github.com/NeXt-Warning-System/development) repository. The database will be populated with the alert and warning target area as well as all the schema definitions and data for each subsystem.

***Local Install***

If needed, a locally installed instance of postgres can be populated using the following commands:

```
  scripts/generate-area-data.sh
  psql -Atx postgresql://postgres:postgres@localhost -f run.sql
```

`generate-area-data.sh` creates the sql from the shape files to insert the target area data for flood alerts and warnings
 
Pre-requisites: Postgres v12, Plugins -  PostGIS, uuid-ossp

***PaaS service DB***

`docker-compose up --build --file docker-compose-cf.yaml`

Note: cf credential env vars (CF_USERNAME and CF_PASSWORD) should be populated using an env file called cf.env
