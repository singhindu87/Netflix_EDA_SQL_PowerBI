--Table: public.netflix_shows

--DROP TABLE IF EXISTS public.netflix_shows;

CREATE TABLE IF NOT EXISTS public.netflixshows
(
    show_id character varying COLLATE pg_catalog."default",
    type character varying COLLATE pg_catalog."default",
    title character varying COLLATE pg_catalog."default",
    director character varying COLLATE pg_catalog."default",
    "cast" character varying COLLATE pg_catalog."default",
    country character varying COLLATE pg_catalog."default",
    date_added date,
    release_year integer,
    rating character varying COLLATE pg_catalog."default",
    duration character varying COLLATE pg_catalog."default",
    listed_in character varying COLLATE pg_catalog."default",
    description character varying COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.netflix_shows
    OWNER to postgres;