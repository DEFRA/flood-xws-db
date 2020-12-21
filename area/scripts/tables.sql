--------------
-- Area tables
--------------
CREATE TABLE xws_area.area_type (
  ref varchar(25) NOT NULL PRIMARY KEY,
  name varchar(100) NOT NULL UNIQUE,
	created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE xws_area.area (
  code varchar(40) NOT NULL PRIMARY KEY,
  region varchar(60) NULL,
  name varchar(100) NOT NULL, 
  description varchar(255) NOT NULL,
  area_type_ref varchar(25) NOT NULL REFERENCES xws_area.area_type (ref),
  parent_area_code varchar(40) REFERENCES xws_area.area (code),
  properties json NULL,
	geom geometry NOT NULL,
	centroid geometry NULL,
	bounding_box geometry NULL,
	created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX area_type_ref_idx ON xws_area.area USING btree (area_type_ref);
CREATE INDEX geom_idx ON xws_area.area USING gist (geom);

/********* 
 * Views
 *********/

-- Summary view of the area table
CREATE VIEW xws_area.area_vw_summary AS
  SELECT ar.code, ar.name, ar.region, ar.description, ar.area_type_ref, art.name as "area_type_name"
  FROM xws_area.area ar
  JOIN xws_area.area_type art ON art.ref = ar.area_type_ref;
