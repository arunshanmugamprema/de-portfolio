-- Active: 1771963368675@@127.0.0.1@5432@de_portfolio
create schema if not exists raw_data;
create schema if not exists staging;
create schema if not exists analytics;

create table if not exists raw_data.weather_raw(
    id bigint primary key,
    city text not null,
    country_code char(2) not null,
    temp_c numeric(5,2),
    humidity_pct smallint ,
    wind_kmh numeric(6,2),
    condition text,
    recorded_at timestamptz not null ,
    source text not null default 'manual_upload');

INSERT INTO raw_data.weather_raw
    (id, city, country_code, temp_c, humidity_pct, wind_kmh, condition,recorded_at)
VALUES
    (1001, 'London',    'GB', 12.5, 78, 18.2, 'cloudy', '2024-01-01 12:00:00'),
    (1002, 'New York',  'US', 24.1, 55, 12.0, 'sunny', '2024-01-01 13:00:00'),
    (1003, 'Tokyo',     'JP', 28.3, 82, 8.5,  'humid', '2024-01-01 14:00:00'),
    (1004, 'Sydney',    'AU', 22.0, 65, 20.0, 'windy', '2024-01-01 15:35:37'    ),
    (1005, 'Paris',     'FR', 15.4, 70, 10.5, 'rainy', '2024-01-01 16:00:00');


select * from raw_data.weather_raw;

SELECT current_database();



