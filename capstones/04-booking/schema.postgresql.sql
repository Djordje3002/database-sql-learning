-- Booking starter schema / Početna šema projekta rezervacija (PostgreSQL 16+).

CREATE SCHEMA IF NOT EXISTS booking;
CREATE EXTENSION IF NOT EXISTS btree_gist;

CREATE TABLE booking.properties (
  property_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name text NOT NULL,
  timezone text NOT NULL
);

CREATE TABLE booking.rooms (
  room_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  property_id bigint NOT NULL REFERENCES booking.properties(property_id),
  room_name text NOT NULL,
  capacity smallint NOT NULL CHECK (capacity > 0),
  UNIQUE (property_id, room_name)
);

CREATE TABLE booking.guests (
  guest_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email text NOT NULL UNIQUE,
  full_name text NOT NULL
);

CREATE TABLE booking.reservations (
  reservation_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  room_id bigint NOT NULL REFERENCES booking.rooms(room_id),
  guest_id bigint NOT NULL REFERENCES booking.guests(guest_id),
  stay daterange NOT NULL,
  status text NOT NULL CHECK (status IN ('confirmed', 'cancelled')),
  nightly_rate_cents integer NOT NULL CHECK (nightly_rate_cents >= 0),
  created_at timestamptz NOT NULL DEFAULT now(),
  CHECK (NOT isempty(stay)),
  EXCLUDE USING gist (room_id WITH =, stay WITH &&)
    WHERE (status = 'confirmed')
);

CREATE TABLE booking.reservation_events (
  reservation_event_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  reservation_id bigint NOT NULL REFERENCES booking.reservations(reservation_id),
  event_type text NOT NULL CHECK (event_type IN ('created', 'confirmed', 'cancelled')),
  occurred_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX rooms_property_id_idx ON booking.rooms(property_id);
CREATE INDEX reservations_guest_id_idx ON booking.reservations(guest_id);
CREATE INDEX reservation_events_reservation_id_idx ON booking.reservation_events(reservation_id);
