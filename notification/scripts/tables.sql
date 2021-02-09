CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

/********* 
 * Tables
 *********/

CREATE TABLE xws_notification.alert (
  id uuid PRIMARY KEY,
  area_code varchar(40) NOT NULL,
  area_name varchar(100) NOT NULL,
  sender varchar(255) NOT NULL,
  source varchar(255) NOT NULL,
  alert_xml xml NOT NULL,
  alert_json json NOT NULL,
  active boolean NULL,
  created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX active_idx ON xws_notification.alert USING btree (active nulls LAST);
CREATE UNIQUE INDEX area_code_active_idx ON xws_notification.alert USING btree (area_code, active nulls LAST);


CREATE OR REPLACE FUNCTION xws_notification.ensure_only_one_active_area_trigger()
RETURNS trigger
AS $function$
BEGIN
    -- Nothing to do if updating the row currently enabled
    IF (TG_OP = 'UPDATE' AND OLD.active = true) THEN
      RETURN NEW;
    END IF;

    -- Disable the currently active row
    UPDATE xws_notification.alert
    SET active = null --, expired_at = CURRENT_TIMESTAMP
    WHERE active = TRUE
    AND area_code = NEW.area_code;

    -- Activate new row
    -- NEW.active := true;
    RETURN NEW;
END;
$function$
LANGUAGE plpgsql;

CREATE TRIGGER alert_only_one_active_area_code
BEFORE INSERT OR UPDATE OF active ON xws_notification.alert
FOR EACH ROW WHEN (NEW.active = true)
EXECUTE PROCEDURE xws_notification.ensure_only_one_active_area_trigger();


CREATE TABLE xws_notification.contact (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  contact_id uuid NOT NULL, -- REFERENCES xws_contact.contact (id),
  value varchar(1000) NOT NULL,
  kind varchar(255) NOT NULL CHECK (kind IN ('mobile', 'landline', 'email')),
  created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE xws_notification.subscription (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  contact_id uuid NOT NULL REFERENCES xws_notification.contact (id),
  area_code varchar(40) NOT NULL,
  channel varchar(100) NOT NULL CHECK (channel IN ('sms', 'voice', 'email')), 
  created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE xws_notification.message (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  alert_id uuid NOT NULL REFERENCES xws_notification.alert (id),
  subscription_id uuid NOT NULL REFERENCES xws_notification.subscription (id),
  value varchar(1000) NOT NULL,
  contact_kind varchar(255) NOT NULL CHECK (contact_kind IN ('mobile', 'landline', 'email')),
  subscription_channel varchar(100) NOT NULL CHECK (subscription_channel IN ('sms', 'voice', 'email')),
  created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE xws_notification.message_sent (
  reference uuid PRIMARY KEY,
  alert_id uuid NOT NULL REFERENCES xws_alert.alert (id),
  contact_id uuid NOT NULL, -- REFERENCES xws_contact.contact (id)
  value varchar(1000) NOT NULL,
  result json NOT NULL,
  created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  -- https://docs.notifications.service.gov.uk/node.html#delivery-receipts
  delivery_created_at timestamptz,
  delivery_status varchar(100),
  delivery_to varchar(100),
  delivery_result json
);
CREATE INDEX message_sent_value_idx ON xws_notification.message_sent(value);
CREATE INDEX message_sent_alert_id_idx ON xws_notification.message_sent(alert_id);
CREATE INDEX message_sent_contact_id_idx ON xws_notification.message_sent(contact_id);
CREATE INDEX message_sent_delivery_status_idx ON xws_notification.message_sent(delivery_status);

CREATE TABLE xws_notification.message_failed (
  reference uuid PRIMARY KEY,
  alert_id uuid NOT NULL REFERENCES xws_alert.alert (id),
  contact_id uuid NOT NULL, -- REFERENCES xws_notification.contact (id), // No FK as contact could be removed
  value varchar(1000) NOT NULL,
  result json NOT NULL,
  created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX message_failed_value_idx ON xws_notification.message_failed(value);
CREATE INDEX message_failed_alert_id_idx ON xws_notification.message_failed(alert_id);
CREATE INDEX message_failed_contact_id_idx ON xws_notification.message_failed(contact_id);
