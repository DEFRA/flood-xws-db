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
```

`generate-area-data.sh` creates the SQL from the shape files to insert the target area data for flood alerts and warnings. The SQL files it creates are referenced by the `run.sql` file (see below). After the initial run the script only needs running when the target area shape files change.


```
  psql -Atx postgresql://postgres:postgres@localhost -f run.sql
```

 
Pre-requisites: Postgres v12, Plugins -  PostGIS, uuid-ossp

***PaaS service DB***

To populate the PaaS service DB run the following command:

`docker build --file DockerfileCF . -t cf-db && docker run --env-file ./cf.env cf-db`

Note: cf env vars are populated using an env file which you will need to create (see cf.env.sample for the env vars which need populationg)
