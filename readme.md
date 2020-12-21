# XWS DB

This project currently contains the database scripts for all the XWS subsystems.
These subsystems are mapped to individual postgres schema: `xws_alert`, `xws_area`, `xws_notification`, `xws_contact`. Eventually, this repo may get split into a number of separate db repos per each subsystem. Also, they may eventually be installed to separate databases.


## Getting started

You'll need a Postgres v12 database with the PostGIS plugin installed and the `ogr2ogr` binary (alternatively, see [docker](#docker) below).

First, you need to import the 2 flood areas to the `public` schema using `ogr2ogr` (ensure you change or set up the PG_CONNECTION environment variable).

`ogr2ogr -s_srs "EPSG:27700" -a_srs "EPSG:4326" -t_srs "EPSG:4326" -f "PostgreSQL" "PG:${PG_CONNECTION}" "/area/flood-areas/EA_FloodWarningAreas_SHP_Full/data/Flood_Warning_Areas.shp" -lco GEOMETRY_NAME=geom -lco FID=gid -lco PRECISION=no -nlt PROMOTE_TO_MULTI -nln fwa -overwrite -progress`

and

`ogr2ogr -s_srs "EPSG:27700" -a_srs "EPSG:4326" -t_srs "EPSG:4326" -f PostgreSQL "PG:${PG_CONNECTION}" "/area/flood-areas/EA_FloodAlertAreas_SHP_Full/data/Flood_Alert_Areas.shp" -lco GEOMETRY_NAME=geom -lco FID=gid -lco PRECISION=no -nlt PROMOTE_TO_MULTI -nln faa -overwrite -progress`


Now connect to postgres instance using `psql`

`psql -Atx postgresql://username:password@host`

At the command prompt, run

`psql> \i run.sql`

This will install all the tables and schemas

## Docker

### ogr2ogr

If you'd rather not install [GDAL](https://github.com/OSGeo/gdal), you can run ogr2ogr in a docker container using the offical image.

`docker pull osgeo/gdal:alpine-small-latest`

Then start an interactive session using docker run. The container need access to the shape files and so we map volumes and it needs a PG_CONNECTION env var.

`docker run --rm -it -e PG_CONNECTION="Enter pg connection here" -v $(pwd):/root:ro osgeo/gdal:alpine-small-latest`

You can then run the two ogr2ogr commands above.

### Postgres
...