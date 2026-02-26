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


INSERT INTO raw_data.weather_raw
    (id, city, country_code, temp_c, humidity_pct, wind_kmh, condition,recorded_at)
VALUES
    (1009, 'London',    'GB', 12.5, 111,1112, 'cloudy', '2024-01-01 12:00:00');

--Verify TIMESTAMPTZ vs TIMESTAMP behaviour by inserting with different timezone offsets
INSERT INTO raw_data.weather_raw (
  city, country_code, temp_c, humidity_pct, wind_kmh, condition, recorded_at
)
VALUES
('Chicago','US', 5.2, 60, 10.3, 'Cloudy', '2026-02-25 10:00:00-06'),
('Berlin','DE', 3.1, 75, 12.0, 'Rain',   '2026-02-25 17:00:00+01');


SELECT *FROM raw_data.weather_raw;

-- create a new database and switch to it for the next part of the setup
create database stock_market_dw;
use stock_market_dw;

-- create schemas again in the new database
create schema if not exists raw_data;
create schema if not exists staging;
create schema if not exists analytics;

--create a new table for stock prices in bronze layer
create table if not exists raw_data.stock_prices_raw(
    symbol text not null,
    price numeric(10,2),
    volume bigint,
    recorded_at timestamptz not null default now(),
    payload jsonb,
    unique(symbol, recorded_at)
);