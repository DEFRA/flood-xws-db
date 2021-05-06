-- This schema and the associated views are to provide schema isolation when using PostgREST
-- in line with best practice outlined below and also to map from postgres column name format
-- to standardjs format:
-- https://postgrest.org/en/v7.0.0/schema_structure.html

DROP SCHEMA IF EXISTS xws_rest CASCADE;
CREATE SCHEMA IF NOT EXISTS xws_rest;

CREATE VIEW xws_rest.area AS
  SELECT code, region, name, description
  FROM xws_area.area;

CREATE VIEW xws_rest.contact AS
  SELECT id, value, active, contact_kind_name AS "contactKindName", contact_type_name AS "contactTypeName", hazard_name AS "hazardName"
  FROM xws_contact.contact;

CREATE VIEW xws_rest.subscription AS
  SELECT id, contact_id AS "contactId", area_code AS "areaCode", channel_name AS "channelName", wnlif
  FROM xws_contact.subscription;
