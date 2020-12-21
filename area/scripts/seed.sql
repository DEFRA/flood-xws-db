-- Flood Areas
INSERT INTO xws_area.area_type(ref, name)
		values
      ('faa', 'Flood alert area'), ('fwa', 'Flood warning area');

-- TRUNCATE xws_area.area RESTART IDENTITY CASCADE;
INSERT INTO xws_area.area(code, region, name, description, area_type_ref, geom)
SELECT fws_tacode AS code,
       area,
       ta_name AS name,
       descrip AS description,
       'faa' AS area_type_ref,
       geom
FROM "public".faa;


INSERT INTO xws_area.area(code, region, name, description, area_type_ref, parent_area_code, geom)
SELECT fws_tacode AS code,
       area,
       ta_name AS name,
       descrip AS description,
       'fwa' AS area_type_ref,

  (SELECT fws_tacode as code
   FROM xws_area.area
   WHERE area_type_ref = 'fwa'
     AND xws_area.area.code = parent) AS parent_area_code,
       geom
FROM "public".fwa;
