FROM osgeo/gdal AS faa-data
ARG FAA_DATA_FILE
COPY $FAA_DATA_FILE /target-area-data/faa.zip
RUN ogr2ogr --config PG_USE_COPY YES -s_srs "EPSG:27700" -a_srs "EPSG:4326" -t_srs "EPSG:4326" -f PGDump /target-area-data/faa.sql /vsizip//target-area-data/faa.zip/data/Flood_Alert_Areas.shp -lco GEOMETRY_NAME=geom -lco FID=gid -lco PRECISION=no -nlt PROMOTE_TO_MULTI -nln faa 


FROM osgeo/gdal AS fwa-data
ARG FWA_DATA_FILE
COPY $FWA_DATA_FILE /target-area-data/fwa.zip
RUN ogr2ogr --config PG_USE_COPY YES -s_srs "EPSG:27700" -a_srs "EPSG:4326" -t_srs "EPSG:4326" -f PGDump target-area-data/fwa.sql /vsizip//target-area-data/fwa.zip/data/Flood_Warning_Areas.shp -lco GEOMETRY_NAME=geom -lco FID=gid -lco PRECISION=no -nlt PROMOTE_TO_MULTI -nln fwa 

FROM postgis/postgis
ENV PATH=${PATH}:/scripts
COPY --from=faa-data /target-area-data/faa.sql /db-init-scripts/  
COPY --from=fwa-data /target-area-data/fwa.sql /db-init-scripts/  
COPY scripts/populate-db /docker-entrypoint-initdb.d/populate-db.sh
COPY scripts/setup.sql /db-init-scripts/setup.sql
COPY contact/scripts /db-init-scripts/contact
COPY area/scripts /db-init-scripts/area
COPY alert/scripts /db-init-scripts/alert
COPY notification/scripts /db-init-scripts/notification
RUN ls -l /db-init-scripts
