-- Active: 1771963368675@@127.0.0.1@5432@de_portfolio
create schema if not exists raw_data;
create schema if not exists staging;
create schema if not exists analytics;

drop table if exists raw_data.weather_raw cascade;

CREATE TABLE IF NOT EXISTS raw_data.weather_raw (
  id            BIGSERIAL PRIMARY KEY,
  city          TEXT NOT NULL,
  country_code  CHAR(2) NOT NULL,
  temp_c        NUMERIC(5,2),
  humidity_pct  SMALLINT CHECK (humidity_pct BETWEEN 0 AND 100),
  wind_kmh      NUMERIC(6,2),
  condition     TEXT,
  recorded_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  source        TEXT NOT NULL DEFAULT 'manual',    -- provenance
  ingested_at   TIMESTAMPTZ NOT NULL DEFAULT NOW() -- pipeline timestamp
);


INSERT INTO raw_data.weather_raw
    (id, city, country_code, temp_c, humidity_pct, wind_kmh, condition,recorded_at)
VALUES
    (1001, 'London',    'GB', 12.5, 78, 18.2, 'cloudy', '2024-01-01 12:00:00'),
    (1002, 'New York',  'US', 24.1, 55, 12.0, 'sunny', '2024-01-01 13:00:00'),
    (1003, 'Tokyo',     'JP', 28.3, 82, 8.5,  'humid', '2024-01-01 14:00:00'),
    (1004, 'Sydney',    'AU', 22.0, 65, 20.0, 'windy', '2024-01-01 15:35:37'    ),
    (1005, 'Paris',     'FR', 15.4, 70, 10.5, 'rainy', '2024-01-01 16:00:00');


select * from raw_data.weather_raw;


create table if not exists staging.weather_daily (
    city text not null,
    avg_temp_c numeric(5,2),
    reading_date date not null,
    row_count integer,
    updated_at timestamptz not null default now(),
    primary key(city,reading_date)
);



