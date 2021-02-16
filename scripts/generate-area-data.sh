#!/bin/bash

# Utility script to generate the sql for inserting TA data from shape files
# As the bind mounts are absolute then the script needs to be run from the repo root directory
# The generated sql files should not be commited as they can be regenerated from the shape files.

function generate {
  docker run --volume $PWD/area/flood-areas:/target-area-data osgeo/gdal ogr2ogr \
    --config PG_USE_COPY YES \
    -s_srs "EPSG:27700" \
    -a_srs "EPSG:4326" \
    -t_srs "EPSG:4326" \
    -f PGDump /target-area-data/$1.sql /vsizip//target-area-data/EA_$(echo $2 | sed 's/_//g')_SHP_Full.zip/data/$2.shp \
    -lco GEOMETRY_NAME=geom \
    -lco FID=gid \
    -lco PRECISION=no \
    -nlt PROMOTE_TO_MULTI \
    -nln $1
}

generate faa Flood_Alert_Areas
generate fwa Flood_Warning_Areas
