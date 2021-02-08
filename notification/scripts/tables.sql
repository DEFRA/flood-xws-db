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
  alert xml NOT NULL,
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE xws_notification.message_sent (
  reference uuid PRIMARY KEY,
  alert_id uuid NOT NULL REFERENCES xws_alert.alert (id),
  contact_id uuid NOT NULL REFERENCES xws_contact.contact (id),
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

CREATE TABLE xws_notification.message_queue (
  id bigserial PRIMARY KEY,
  queue varchar(255) NOT NULL,
  data json NOT NULL,
  priority int DEFAULT 0,
  created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX message_queue_idx ON xws_notification.message_queue(priority DESC, queue, created_at);
