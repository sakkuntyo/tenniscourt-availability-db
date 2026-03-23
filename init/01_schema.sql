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
