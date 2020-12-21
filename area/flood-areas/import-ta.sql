# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.html#Appendix.PostgreSQL.CommonDBATasks.PostGIS

ogr2ogr -a_srs "EPSG:27700" -f "PostgreSQL" "PG:host=xws-contact-db.cezam6iy9y1a.eu-west-1.rds.amazonaws.com user=postgres dbname=postgres password=xwspostgres" "/Users/dstone/Documents/dev/XWS/xws-contact-db/target-areas/EA_FloodWarningAreas_SHP_Full/data/Flood_Warning_Areas.shp" -lco GEOMETRY_NAME=geom -lco FID=gid -lco PRECISION=no -nlt PROMOTE_TO_MULTI -nln fwa -overwrite
ogr2ogr -a_srs "EPSG:27700" -f "PostgreSQL" "PG:host=xws-contact-db.cezam6iy9y1a.eu-west-1.rds.amazonaws.com user=postgres dbname=postgres password=xwspostgres" "/Users/dstone/Documents/dev/XWS/xws-contact-db/target-areas/EA_FloodAlertAreas_SHP_Full/data/Flood_Alert_Areas.shp" -lco GEOMETRY_NAME=geom -lco FID=gid -lco PRECISION=no -nlt PROMOTE_TO_MULTI -nln faa -overwrite

#Northwich
E/N 364848, 373274


# Keswick
E/N 325858.5, 523486.41



# Working
select * from fwa where st_intersects(st_setsrid(st_makepoint(325858.5, 523486.41), 27700), fwa.geom);
select * from faa where st_intersects(st_setsrid(st_makepoint(325858.5, 523486.41), 27700), faa.geom);