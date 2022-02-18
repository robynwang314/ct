SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: data_sources; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.data_sources AS ENUM (
    'OWID',
    'Advisory',
    'ReopenEU',
    'Embassy',
    'latest OWID'
);


--
-- Name: document_types; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.document_types AS ENUM (
    'vaccine',
    'test'
);


SET default_tablespace = '';

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: charts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.charts (
    id bigint NOT NULL,
    type character varying,
    country_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: charts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.charts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: charts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.charts_id_seq OWNED BY public.charts.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.countries (
    id bigint NOT NULL,
    name character varying,
    slug character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- Name: covid_raw_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.covid_raw_data (
    id bigint NOT NULL,
    data_source public.data_sources,
    raw_json jsonb DEFAULT '{}'::jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: covid_raw_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.covid_raw_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: covid_raw_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.covid_raw_data_id_seq OWNED BY public.covid_raw_data.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.documents (
    id bigint NOT NULL,
    document_type public.document_types,
    required boolean DEFAULT false,
    antigen boolean DEFAULT false,
    pcr boolean DEFAULT false,
    validity character varying,
    data jsonb DEFAULT '{}'::jsonb,
    country_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
-- Name: embassy_raw_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.embassy_raw_data (
    id bigint NOT NULL,
    country character varying,
    raw_json jsonb DEFAULT '{}'::jsonb,
    data_source character varying DEFAULT 'Embassy'::character varying,
    covid_raw_data_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: embassy_raw_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.embassy_raw_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: embassy_raw_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.embassy_raw_data_id_seq OWNED BY public.embassy_raw_data.id;


--
-- Name: owid_country_all_time_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.owid_country_all_time_data (
    id bigint NOT NULL,
    country character varying,
    all_time_data jsonb DEFAULT '{}'::jsonb,
    data_source character varying DEFAULT 'OWID'::character varying,
    covid_raw_data_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    country_code character varying
);


--
-- Name: owid_country_all_time_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.owid_country_all_time_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: owid_country_all_time_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.owid_country_all_time_data_id_seq OWNED BY public.owid_country_all_time_data.id;


--
-- Name: owid_today_stats_raw_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.owid_today_stats_raw_data (
    id bigint NOT NULL,
    country character varying,
    raw_json jsonb DEFAULT '{}'::jsonb,
    data_source character varying DEFAULT 'latest OWID'::character varying,
    covid_raw_data_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    country_code character varying
);


--
-- Name: owid_today_stats_raw_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.owid_today_stats_raw_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: owid_today_stats_raw_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.owid_today_stats_raw_data_id_seq OWNED BY public.owid_today_stats_raw_data.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: travel_advisory_raw_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.travel_advisory_raw_data (
    id bigint NOT NULL,
    country character varying,
    raw_json jsonb DEFAULT '{}'::jsonb,
    data_source character varying DEFAULT 'Advisory'::character varying,
    covid_raw_data_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    country_code character varying
);


--
-- Name: travel_advisory_raw_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.travel_advisory_raw_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: travel_advisory_raw_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.travel_advisory_raw_data_id_seq OWNED BY public.travel_advisory_raw_data.id;


--
-- Name: charts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charts ALTER COLUMN id SET DEFAULT nextval('public.charts_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: covid_raw_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.covid_raw_data ALTER COLUMN id SET DEFAULT nextval('public.covid_raw_data_id_seq'::regclass);


--
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- Name: embassy_raw_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.embassy_raw_data ALTER COLUMN id SET DEFAULT nextval('public.embassy_raw_data_id_seq'::regclass);


--
-- Name: owid_country_all_time_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.owid_country_all_time_data ALTER COLUMN id SET DEFAULT nextval('public.owid_country_all_time_data_id_seq'::regclass);


--
-- Name: owid_today_stats_raw_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.owid_today_stats_raw_data ALTER COLUMN id SET DEFAULT nextval('public.owid_today_stats_raw_data_id_seq'::regclass);


--
-- Name: travel_advisory_raw_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.travel_advisory_raw_data ALTER COLUMN id SET DEFAULT nextval('public.travel_advisory_raw_data_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: charts charts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charts
    ADD CONSTRAINT charts_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: covid_raw_data covid_raw_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.covid_raw_data
    ADD CONSTRAINT covid_raw_data_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: embassy_raw_data embassy_raw_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.embassy_raw_data
    ADD CONSTRAINT embassy_raw_data_pkey PRIMARY KEY (id);


--
-- Name: owid_country_all_time_data owid_country_all_time_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.owid_country_all_time_data
    ADD CONSTRAINT owid_country_all_time_data_pkey PRIMARY KEY (id);


--
-- Name: owid_today_stats_raw_data owid_today_stats_raw_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.owid_today_stats_raw_data
    ADD CONSTRAINT owid_today_stats_raw_data_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: travel_advisory_raw_data travel_advisory_raw_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.travel_advisory_raw_data
    ADD CONSTRAINT travel_advisory_raw_data_pkey PRIMARY KEY (id);


--
-- Name: index_charts_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_charts_on_country_id ON public.charts USING btree (country_id);


--
-- Name: index_documents_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_country_id ON public.documents USING btree (country_id);


--
-- Name: index_embassy_raw_data_on_covid_raw_data_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_embassy_raw_data_on_covid_raw_data_id ON public.embassy_raw_data USING btree (covid_raw_data_id);


--
-- Name: index_owid_country_all_time_data_on_covid_raw_data_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_owid_country_all_time_data_on_covid_raw_data_id ON public.owid_country_all_time_data USING btree (covid_raw_data_id);


--
-- Name: index_owid_today_stats_raw_data_on_covid_raw_data_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_owid_today_stats_raw_data_on_covid_raw_data_id ON public.owid_today_stats_raw_data USING btree (covid_raw_data_id);


--
-- Name: index_travel_advisory_raw_data_on_covid_raw_data_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_travel_advisory_raw_data_on_covid_raw_data_id ON public.travel_advisory_raw_data USING btree (covid_raw_data_id);


--
-- Name: charts fk_rails_70eb90a5ec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charts
    ADD CONSTRAINT fk_rails_70eb90a5ec FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: documents fk_rails_7eaa755014; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT fk_rails_7eaa755014 FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20211207223537'),
('20211207225611'),
('20211207232901'),
('20220211200126'),
('20220212003010'),
('20220214175828'),
('20220215202759'),
('20220215204755'),
('20220215205504'),
('20220217184845'),
('20220217193216'),
('20220218001531'),
('20220218010903');


