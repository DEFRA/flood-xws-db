CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

/********* 
 * Tables
 *********/

CREATE TABLE xws_contact.contact_type (
  name varchar(100) PRIMARY KEY,
	created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE xws_contact.channel (
  name varchar(100) PRIMARY KEY,
	created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE xws_contact.contact_kind (
  name varchar(255) PRIMARY KEY,
  created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE xws_contact.hazard (
  name varchar(255) PRIMARY KEY,
  created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE xws_contact.contact (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  value varchar(1000) NOT NULL,
  active boolean NOT NULL DEFAULT TRUE,
  contact_kind_name varchar(255) NOT NULL REFERENCES xws_contact.contact_kind (name),
  contact_type_name varchar(100) NOT NULL REFERENCES xws_contact.contact_type (name),
  hazard_name varchar(255) NOT NULL REFERENCES xws_contact.hazard (name),
  created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE UNIQUE INDEX contact_value_idx ON xws_contact.contact USING btree (value, active, contact_kind_name, hazard_name);

CREATE TABLE xws_contact.location_type (
	name varchar(40) PRIMARY KEY,
	active bool NOT NULL DEFAULT TRUE,
	created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE xws_contact.location (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	ref varchar(255) NOT NULL,
  location_type_name varchar(40) NOT NULL REFERENCES xws_contact.location_type (name),
	name varchar(255) NOT NULL,
	geom geometry,
	centroid geometry,
	created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE xws_contact.subscription (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  contact_id uuid NOT NULL REFERENCES xws_contact.contact (id),
  location_id uuid NOT NULL REFERENCES xws_contact.location (id),
  channel_name varchar(100) NOT NULL REFERENCES xws_contact.channel (name),
  wnlif bool NOT NULL DEFAULT FALSE,
  alerts bool NOT NULL DEFAULT FALSE,
  created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);


/********* 
 * Views
 *********/

-- View of the user table showing active users
-- CREATE VIEW xws_alert.user_vw_active AS
--   SELECT *
--   FROM xws_alert.user
--   WHERE active = TRUE;

-- -- View of the alert table showing active alerts
-- CREATE VIEW xws_alert.alert_vw_active AS
--   SELECT *
--   FROM xws_alert.alert
--   WHERE active = TRUE;

-- -- Summary view of the area table
-- CREATE VIEW xws_area.area_vw_summary AS
--   SELECT ar.code, ar.name, ar.region, ar.description, ar.area_type_ref, art.name as "area_type_name"
--   FROM xws_alert.area ar
--   JOIN xws_alert.area_type art ON art.ref = ar.area_type_ref;






