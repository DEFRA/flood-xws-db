INSERT INTO xws_contact.contact_type(name)
VALUES
  ('public'), ('partner'), ('staff'), ('edw'), ('system');

INSERT INTO xws_contact.location_type(name)
VALUES
  ('uprn'), ('osgb'), ('faa'), ('fwa');

INSERT INTO xws_contact.channel(name)
VALUES
  ('sms'), ('voice'), ('email');

INSERT INTO xws_contact.hazard(name)
VALUES
  ('flood');

INSERT INTO xws_contact.contact_kind(name)
VALUES
  ('mobile'), ('landline'), ('email');
