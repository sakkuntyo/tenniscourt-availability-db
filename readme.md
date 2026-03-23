# required args
- PG_MAJOR=18
- POSTGRES_PASSWORD=<password>
- POSTGRES_USER=<user id>
- POSTGRES_DB=<database name>

# table schema

[`init/01_schema.sql`](./init/01_schema.sql)
<!-- schema:start -->
```sql
CREATE TABLE public.court_availability (
  id BIGSERIAL PRIMARY KEY,
  source_site TEXT NOT NULL,
  facility_name TEXT NOT NULL,
  court_name TEXT NOT NULL,
  play_date DATE NOT NULL,
  start_time TIME WITHOUT TIME ZONE NOT NULL,
  end_time TIME WITHOUT TIME ZONE NOT NULL,
  status TEXT NOT NULL,
  fetched_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

ALTER TABLE public.court_availability
ADD CONSTRAINT uq_court_availability_slot
UNIQUE (
  source_site,
  facility_name,
  court_name,
  play_date,
  start_time,
  end_time
);
```
<!-- schema:end -->

# sample app

- https://github.com/sakkuntyo/ace-tenniscourt-logger
- https://github.com/sakkuntyo/ichikawa-tenniscourt-logger

# sample select SQL

```
WITH base AS (
  SELECT *
  FROM court_availability
  WHERE status = 'available'
    AND EXTRACT(DOW FROM play_date) IN (6, 0)
    AND fetched_at >= NOW() - INTERVAL '10 minutes'
    AND (play_date + start_time) >= (NOW() AT TIME ZONE 'Asia/Tokyo')
),
grp AS (
  SELECT
    source_site,
    facility_name,
    court_name,
    play_date,
    start_time,
    end_time,
    start_time
      - (ROW_NUMBER() OVER (
          PARTITION BY source_site, facility_name, court_name, play_date
          ORDER BY start_time
        ) * INTERVAL '15 minutes') AS g
  FROM base
)
SELECT
  source_site,
  facility_name,
  court_name,
  play_date,
  MIN(start_time) AS range_start,
  MAX(end_time)   AS range_end,
  COUNT(*) * 15   AS total_minutes
FROM grp
GROUP BY
  source_site,
  facility_name,
  court_name,
  play_date,
  g
ORDER BY
  play_date,
  facility_name,
  court_name,
  range_start;
```

<img width="739" height="712" alt="image" src="https://github.com/user-attachments/assets/e5e3570a-0943-4447-acce-6ee241486da6" />
