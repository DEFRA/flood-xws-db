-- CAP Data
INSERT INTO xws_alert.cap_category(name)
		values
      ('Geo'), ('Met'),('Safety'), ('Security'),('Rescue'),('Fire'),
      ('Health'),('Env'),('Transport'),('Infra'),('CBRNE'),('Other');

INSERT INTO xws_alert.cap_response_type(name)
		values
      ('Shelter'),('Evacuate'),('Prepare'),
      ('Execute'),('Avoid'),('Monitor'),
      ('Assess'),('AllClear'),('None');

INSERT INTO xws_alert.cap_urgency(name)
		values
      ('Immediate'),('Expected'),('Future'),('Past'),('Unknown');

INSERT INTO xws_alert.cap_severity(name)
		values
      ('Extreme'),('Severe'),('Moderate'),('Minor'),('Unknown');

INSERT INTO xws_alert.cap_certainty(name)
		values
      ('Observed'),('Likely'),('Possible'),('Unlikely'),('Unknown');

INSERT INTO xws_alert.cap_status(name)
		values
      ('Actual'),('Exercise'),('System'),('Test'),('Draft');

INSERT INTO xws_alert.cap_message_type(name)
		values
      ('Alert'),('Update'),('Cancel'),('Ack'),('Error');

INSERT INTO xws_alert.cap_scope(name)
		values
      ('Public'),('Restricted'),('Private');



-- Alert templates
INSERT INTO xws_alert.alert_template(ref, name, description, cap_urgency_name, cap_severity_name, cap_certainty_name)
		values
      ('sfw', 'Severe flood warning', 'Severe flooding - danger to life', 'Immediate', 'Severe', 'Observed'),
      ('fw', 'Flood warning', 'Flooding is expected - immediate action required', 'Expected', 'Moderate', 'Likely'),
      ('fa', 'Flood alert', 'Flooding is possible - be prepared', 'Expected', 'Minor', 'Likely'),
      ('wnlif', 'Warning no longer in force', 'The warning is no longer in force', 'Past', 'Unknown', 'Unknown');
