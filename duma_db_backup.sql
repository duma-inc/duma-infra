--
-- PostgreSQL database dump
--

-- Dumped from database version 16.13 (Debian 16.13-1.pgdg13+1)
-- Dumped by pg_dump version 17.5 (Ubuntu 17.5-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: duma
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO duma;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: duma
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: attempts; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.attempts (
    id bigint NOT NULL,
    student_id uuid NOT NULL,
    lesson_id uuid NOT NULL,
    exercise_id character varying(255) NOT NULL,
    answer_given text NOT NULL,
    is_correct boolean NOT NULL,
    score integer NOT NULL,
    time_spent_seconds integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    feedback text
);


ALTER TABLE public.attempts OWNER TO duma;

--
-- Name: attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: duma
--

CREATE SEQUENCE public.attempts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attempts_id_seq OWNER TO duma;

--
-- Name: attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: duma
--

ALTER SEQUENCE public.attempts_id_seq OWNED BY public.attempts.id;


--
-- Name: attendances; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.attendances (
    id bigint NOT NULL,
    student_id uuid NOT NULL,
    meeting_id uuid NOT NULL,
    status boolean DEFAULT false NOT NULL,
    notes character varying(255),
    checked_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.attendances OWNER TO duma;

--
-- Name: attendances_id_seq; Type: SEQUENCE; Schema: public; Owner: duma
--

CREATE SEQUENCE public.attendances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attendances_id_seq OWNER TO duma;

--
-- Name: attendances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: duma
--

ALTER SEQUENCE public.attendances_id_seq OWNED BY public.attendances.id;


--
-- Name: cash_categories; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.cash_categories (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cash_categories OWNER TO duma;

--
-- Name: cash_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: duma
--

CREATE SEQUENCE public.cash_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cash_categories_id_seq OWNER TO duma;

--
-- Name: cash_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: duma
--

ALTER SEQUENCE public.cash_categories_id_seq OWNED BY public.cash_categories.id;


--
-- Name: cash_transactions; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.cash_transactions (
    id uuid NOT NULL,
    type character varying(10) NOT NULL,
    amount numeric(15,2) NOT NULL,
    category_id bigint NOT NULL,
    student_id uuid,
    discount numeric(15,2),
    responsible_user_id uuid,
    observations text,
    transaction_date date DEFAULT CURRENT_DATE NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cash_transactions OWNER TO duma;

--
-- Name: enrollments; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.enrollments (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    skill_id bigint NOT NULL,
    stage_id bigint NOT NULL,
    status character varying(255),
    source character varying(255),
    pace character varying(255),
    progress_percentage integer NOT NULL,
    enrolled_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_activity_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    plan_id bigint,
    current_lesson_id uuid
);


ALTER TABLE public.enrollments OWNER TO duma;

--
-- Name: enrollments_id_seq; Type: SEQUENCE; Schema: public; Owner: duma
--

CREATE SEQUENCE public.enrollments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.enrollments_id_seq OWNER TO duma;

--
-- Name: enrollments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: duma
--

ALTER SEQUENCE public.enrollments_id_seq OWNED BY public.enrollments.id;


--
-- Name: exercise_reported_issues; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.exercise_reported_issues (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    exercise_id character varying(255) NOT NULL,
    comment text NOT NULL,
    reported_by uuid NOT NULL,
    status character varying(20) DEFAULT 'OPEN'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.exercise_reported_issues OWNER TO duma;

--
-- Name: files; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.files (
    id bigint NOT NULL,
    original_name character varying(255) NOT NULL,
    storage_key character varying(512) NOT NULL,
    bucket character varying(255) NOT NULL,
    content_type character varying(255) NOT NULL,
    size_bytes bigint,
    public_url character varying(2048) NOT NULL,
    status character varying(30) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.files OWNER TO duma;

--
-- Name: files_id_seq; Type: SEQUENCE; Schema: public; Owner: duma
--

CREATE SEQUENCE public.files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.files_id_seq OWNER TO duma;

--
-- Name: files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: duma
--

ALTER SEQUENCE public.files_id_seq OWNED BY public.files.id;


--
-- Name: flashcards; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.flashcards (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    front character varying(255) NOT NULL,
    front_normalized character varying(255) NOT NULL,
    back text NOT NULL,
    context text,
    example text,
    due_date date NOT NULL,
    interval_days integer DEFAULT 0 NOT NULL,
    ease_factor double precision DEFAULT 2.5 NOT NULL,
    repetitions integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.flashcards OWNER TO duma;

--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO duma;

--
-- Name: lesson_book_chapters; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.lesson_book_chapters (
    id character varying(160) NOT NULL,
    lesson_book_id character varying(160) NOT NULL,
    order_index integer NOT NULL,
    title character varying(255) NOT NULL,
    summary character varying(1000) NOT NULL,
    markdown text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.lesson_book_chapters OWNER TO duma;

--
-- Name: lesson_books; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.lesson_books (
    id character varying(160) NOT NULL,
    lesson_id uuid NOT NULL,
    title character varying(255) NOT NULL,
    subtitle character varying(500) DEFAULT ''::character varying NOT NULL,
    pdf_url character varying(2048) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.lesson_books OWNER TO duma;

--
-- Name: lesson_progress; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.lesson_progress (
    id bigint NOT NULL,
    student_id uuid NOT NULL,
    lesson_id uuid NOT NULL,
    status character varying(255) NOT NULL,
    progress_percent integer NOT NULL,
    watched_minutes integer NOT NULL,
    started_at timestamp without time zone,
    last_access_at timestamp without time zone,
    completed_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.lesson_progress OWNER TO duma;

--
-- Name: lesson_progress_id_seq; Type: SEQUENCE; Schema: public; Owner: duma
--

CREATE SEQUENCE public.lesson_progress_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lesson_progress_id_seq OWNER TO duma;

--
-- Name: lesson_progress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: duma
--

ALTER SEQUENCE public.lesson_progress_id_seq OWNED BY public.lesson_progress.id;


--
-- Name: lessons; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.lessons (
    id uuid NOT NULL,
    title character varying(100) NOT NULL,
    content text,
    order_index integer NOT NULL,
    is_active boolean NOT NULL,
    module_id uuid NOT NULL,
    stage_id bigint NOT NULL,
    skill_id bigint NOT NULL,
    video_url character varying(255),
    duration_in_minutes integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.lessons OWNER TO duma;

--
-- Name: meetings; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.meetings (
    id uuid NOT NULL,
    title character varying(100) NOT NULL,
    description character varying(255),
    teacher_id uuid NOT NULL,
    skill_id bigint NOT NULL,
    stage_id bigint NOT NULL,
    scheduled_start timestamp without time zone NOT NULL,
    meeting_url character varying(255) NOT NULL,
    recording_url character varying(255),
    status character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    lesson_id uuid,
    plan_id bigint,
    meeting_type character varying(30)
);


ALTER TABLE public.meetings OWNER TO duma;

--
-- Name: module_performance; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.module_performance (
    id bigint NOT NULL,
    student_id uuid NOT NULL,
    module_id uuid NOT NULL,
    total_exercises integer NOT NULL,
    exercises_completed integer NOT NULL,
    average_score integer NOT NULL,
    time_spent_minutes integer NOT NULL,
    progress_percent integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.module_performance OWNER TO duma;

--
-- Name: module_performance_id_seq; Type: SEQUENCE; Schema: public; Owner: duma
--

CREATE SEQUENCE public.module_performance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.module_performance_id_seq OWNER TO duma;

--
-- Name: module_performance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: duma
--

ALTER SEQUENCE public.module_performance_id_seq OWNED BY public.module_performance.id;


--
-- Name: modules; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.modules (
    id uuid NOT NULL,
    title character varying(100) NOT NULL,
    description character varying(255),
    order_index integer NOT NULL,
    is_active boolean NOT NULL,
    stage_id bigint NOT NULL,
    skill_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.modules OWNER TO duma;

--
-- Name: news_articles; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.news_articles (
    id character varying(160) NOT NULL,
    news_category_id bigint NOT NULL,
    headline character varying(255) NOT NULL,
    summary character varying(1000) NOT NULL,
    highlighted_article boolean DEFAULT false NOT NULL,
    source character varying(255) NOT NULL,
    published_at character varying(80) NOT NULL,
    content text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.news_articles OWNER TO duma;

--
-- Name: news_categories; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.news_categories (
    id bigint NOT NULL,
    name character varying(120) NOT NULL,
    sort_order integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.news_categories OWNER TO duma;

--
-- Name: news_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: duma
--

CREATE SEQUENCE public.news_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.news_categories_id_seq OWNER TO duma;

--
-- Name: news_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: duma
--

ALTER SEQUENCE public.news_categories_id_seq OWNED BY public.news_categories.id;


--
-- Name: plan_resources; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.plan_resources (
    plan_id bigint NOT NULL,
    resource_order integer NOT NULL,
    resource_text character varying(255) NOT NULL,
    resource_active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.plan_resources OWNER TO duma;

--
-- Name: plans; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.plans (
    id bigint NOT NULL,
    nome character varying(255) NOT NULL,
    preco character varying(50) NOT NULL,
    periodo character varying(50) NOT NULL,
    destaque boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.plans OWNER TO duma;

--
-- Name: plans_id_seq; Type: SEQUENCE; Schema: public; Owner: duma
--

CREATE SEQUENCE public.plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.plans_id_seq OWNER TO duma;

--
-- Name: plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: duma
--

ALTER SEQUENCE public.plans_id_seq OWNED BY public.plans.id;


--
-- Name: podcast_categories; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.podcast_categories (
    id bigint NOT NULL,
    name character varying(120) NOT NULL,
    sort_order integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.podcast_categories OWNER TO duma;

--
-- Name: podcast_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: duma
--

CREATE SEQUENCE public.podcast_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.podcast_categories_id_seq OWNER TO duma;

--
-- Name: podcast_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: duma
--

ALTER SEQUENCE public.podcast_categories_id_seq OWNED BY public.podcast_categories.id;


--
-- Name: podcasts; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.podcasts (
    id character varying(160) NOT NULL,
    title character varying(255) NOT NULL,
    podcast_category_id bigint NOT NULL,
    cover_image_url character varying(2048) NOT NULL,
    audio_url character varying(2048) NOT NULL,
    duration_label character varying(20) NOT NULL,
    transcript text NOT NULL,
    description text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.podcasts OWNER TO duma;

--
-- Name: resource_categories; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.resource_categories (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.resource_categories OWNER TO duma;

--
-- Name: resource_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: duma
--

CREATE SEQUENCE public.resource_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.resource_categories_id_seq OWNER TO duma;

--
-- Name: resource_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: duma
--

ALTER SEQUENCE public.resource_categories_id_seq OWNED BY public.resource_categories.id;


--
-- Name: resources; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.resources (
    id bigint NOT NULL,
    title character varying(255) NOT NULL,
    skill_id bigint,
    stage_id bigint,
    lesson_id uuid,
    url character varying(2048) NOT NULL,
    media_type character varying(20) NOT NULL,
    resource_category_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    file_id bigint
);


ALTER TABLE public.resources OWNER TO duma;

--
-- Name: resources_id_seq; Type: SEQUENCE; Schema: public; Owner: duma
--

CREATE SEQUENCE public.resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.resources_id_seq OWNER TO duma;

--
-- Name: resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: duma
--

ALTER SEQUENCE public.resources_id_seq OWNED BY public.resources.id;


--
-- Name: skill_categories; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.skill_categories (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.skill_categories OWNER TO duma;

--
-- Name: skill_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: duma
--

CREATE SEQUENCE public.skill_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.skill_categories_id_seq OWNER TO duma;

--
-- Name: skill_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: duma
--

ALTER SEQUENCE public.skill_categories_id_seq OWNED BY public.skill_categories.id;


--
-- Name: skills; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.skills (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(120) NOT NULL,
    short_description character varying(255) NOT NULL,
    full_description text,
    category_id bigint,
    icon_url character varying(255),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.skills OWNER TO duma;

--
-- Name: skills_id_seq; Type: SEQUENCE; Schema: public; Owner: duma
--

CREATE SEQUENCE public.skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.skills_id_seq OWNER TO duma;

--
-- Name: skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: duma
--

ALTER SEQUENCE public.skills_id_seq OWNED BY public.skills.id;


--
-- Name: stages; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.stages (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(100) NOT NULL,
    short_description character varying(255) NOT NULL,
    full_description text,
    icon_url character varying(255),
    color character varying(15),
    order_index integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    skill_id bigint NOT NULL
);


ALTER TABLE public.stages OWNER TO duma;

--
-- Name: stages_id_seq; Type: SEQUENCE; Schema: public; Owner: duma
--

CREATE SEQUENCE public.stages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stages_id_seq OWNER TO duma;

--
-- Name: stages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: duma
--

ALTER SEQUENCE public.stages_id_seq OWNED BY public.stages.id;


--
-- Name: students; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.students (
    id uuid NOT NULL,
    bio character varying(255) DEFAULT ''::character varying,
    profile_picture_url character varying(255),
    timezone character varying(255),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.students OWNER TO duma;

--
-- Name: teachers; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.teachers (
    id uuid NOT NULL,
    bio character varying(255),
    profile_picture_url character varying(255),
    timezone character varying(255),
    is_active boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.teachers OWNER TO duma;

--
-- Name: users; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    keycloak_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    phone character varying(20),
    birth_date date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    role character varying(20)
);


ALTER TABLE public.users OWNER TO duma;

--
-- Name: video_categories; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.video_categories (
    id bigint NOT NULL,
    name character varying(120) NOT NULL,
    sort_order integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.video_categories OWNER TO duma;

--
-- Name: video_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: duma
--

CREATE SEQUENCE public.video_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.video_categories_id_seq OWNER TO duma;

--
-- Name: video_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: duma
--

ALTER SEQUENCE public.video_categories_id_seq OWNED BY public.video_categories.id;


--
-- Name: videos; Type: TABLE; Schema: public; Owner: duma
--

CREATE TABLE public.videos (
    id character varying(160) NOT NULL,
    title character varying(255) NOT NULL,
    video_category_id bigint NOT NULL,
    embed_url character varying(2048) NOT NULL,
    thumbnail_url character varying(2048) NOT NULL,
    duration_label character varying(20) NOT NULL,
    description text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.videos OWNER TO duma;

--
-- Name: attempts id; Type: DEFAULT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.attempts ALTER COLUMN id SET DEFAULT nextval('public.attempts_id_seq'::regclass);


--
-- Name: attendances id; Type: DEFAULT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.attendances ALTER COLUMN id SET DEFAULT nextval('public.attendances_id_seq'::regclass);


--
-- Name: cash_categories id; Type: DEFAULT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.cash_categories ALTER COLUMN id SET DEFAULT nextval('public.cash_categories_id_seq'::regclass);


--
-- Name: enrollments id; Type: DEFAULT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.enrollments ALTER COLUMN id SET DEFAULT nextval('public.enrollments_id_seq'::regclass);


--
-- Name: files id; Type: DEFAULT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.files ALTER COLUMN id SET DEFAULT nextval('public.files_id_seq'::regclass);


--
-- Name: lesson_progress id; Type: DEFAULT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.lesson_progress ALTER COLUMN id SET DEFAULT nextval('public.lesson_progress_id_seq'::regclass);


--
-- Name: module_performance id; Type: DEFAULT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.module_performance ALTER COLUMN id SET DEFAULT nextval('public.module_performance_id_seq'::regclass);


--
-- Name: news_categories id; Type: DEFAULT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.news_categories ALTER COLUMN id SET DEFAULT nextval('public.news_categories_id_seq'::regclass);


--
-- Name: plans id; Type: DEFAULT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.plans ALTER COLUMN id SET DEFAULT nextval('public.plans_id_seq'::regclass);


--
-- Name: podcast_categories id; Type: DEFAULT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.podcast_categories ALTER COLUMN id SET DEFAULT nextval('public.podcast_categories_id_seq'::regclass);


--
-- Name: resource_categories id; Type: DEFAULT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.resource_categories ALTER COLUMN id SET DEFAULT nextval('public.resource_categories_id_seq'::regclass);


--
-- Name: resources id; Type: DEFAULT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.resources ALTER COLUMN id SET DEFAULT nextval('public.resources_id_seq'::regclass);


--
-- Name: skill_categories id; Type: DEFAULT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.skill_categories ALTER COLUMN id SET DEFAULT nextval('public.skill_categories_id_seq'::regclass);


--
-- Name: skills id; Type: DEFAULT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.skills ALTER COLUMN id SET DEFAULT nextval('public.skills_id_seq'::regclass);


--
-- Name: stages id; Type: DEFAULT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.stages ALTER COLUMN id SET DEFAULT nextval('public.stages_id_seq'::regclass);


--
-- Name: video_categories id; Type: DEFAULT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.video_categories ALTER COLUMN id SET DEFAULT nextval('public.video_categories_id_seq'::regclass);


--
-- Data for Name: attempts; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.attempts (id, student_id, lesson_id, exercise_id, answer_given, is_correct, score, time_spent_seconds, created_at, feedback) FROM stdin;
1	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	a8266af0-d70c-3ff7-ae06-682698956039	6a055545a474ac29332574c7	We are students.	t	10	6	2026-05-20 06:03:21.81889	\N
2	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	a8266af0-d70c-3ff7-ae06-682698956039	6a055545a474ac29332574cf	They are teachers.	t	10	6	2026-05-20 06:03:21.855533	\N
3	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	a8266af0-d70c-3ff7-ae06-682698956039	6a055545a474ac2933257485	morning	t	10	11	2026-05-20 06:03:21.862532	\N
4	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	a8266af0-d70c-3ff7-ae06-682698956039	6a055545a474ac29332574ef	how are you?	t	0	8	2026-05-20 06:03:21.870781	\N
5	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	a8266af0-d70c-3ff7-ae06-682698956039	6a055545a474ac29332574bd	They are teachers.	t	10	7	2026-05-20 06:03:21.876982	\N
6	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	a8266af0-d70c-3ff7-ae06-682698956039	6a055545a474ac2933257523	prazer em conhecer	f	0	11	2026-05-20 06:03:21.884926	\N
7	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	a8266af0-d70c-3ff7-ae06-682698956039	6a055545a474ac29332574eb	we are happy	t	0	10	2026-05-20 06:03:21.889868	\N
8	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	a8266af0-d70c-3ff7-ae06-682698956039	6a055545a474ac29332574e5	hey, whats your name?	t	0	21	2026-05-20 06:03:21.895189	\N
9	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	a8266af0-d70c-3ff7-ae06-682698956039	6a055545a474ac29332574dd	And you?	t	10	5	2026-05-20 06:03:21.902071	\N
10	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	a8266af0-d70c-3ff7-ae06-682698956039	6a055545a474ac29332574f1	eles sao	t	0	10	2026-05-20 06:03:21.907158	\N
11	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	a8266af0-d70c-3ff7-ae06-682698956039	6a055545a474ac2933257523	prazer em conhecer voce	t	10	10	2026-05-20 06:03:21.912122	\N
\.


--
-- Data for Name: attendances; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.attendances (id, student_id, meeting_id, status, notes, checked_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: cash_categories; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.cash_categories (id, name, description, created_at, updated_at) FROM stdin;
1	Colaboradores	\N	2026-05-19 02:44:05.855347	2026-05-19 02:44:05.855347
\.


--
-- Data for Name: cash_transactions; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.cash_transactions (id, type, amount, category_id, student_id, discount, responsible_user_id, observations, transaction_date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: enrollments; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.enrollments (id, user_id, skill_id, stage_id, status, source, pace, progress_percentage, enrolled_at, last_activity_at, plan_id, current_lesson_id) FROM stdin;
3	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	1	1	ACTIVE	SELF_ENROLLED	CASUAL	0	2026-05-20 05:30:31.330764	2026-05-20 05:35:14.446149	2	a8266af0-d70c-3ff7-ae06-682698956039
\.


--
-- Data for Name: exercise_reported_issues; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.exercise_reported_issues (id, exercise_id, comment, reported_by, status, created_at, updated_at) FROM stdin;
fe13b340-58d1-48ef-8808-9856365a0f26	6a055545a474ac29332574f9	Teste	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	OPEN	2026-05-20 05:39:50.935554	2026-05-20 05:39:50.935554
4fee6edf-1d83-40a2-b47e-5322fe561d52	6a055545a474ac29332574f9	teste	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	OPEN	2026-05-21 11:44:07.086263	2026-05-21 11:44:07.086263
\.


--
-- Data for Name: files; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.files (id, original_name, storage_key, bucket, content_type, size_bytes, public_url, status, created_at, updated_at) FROM stdin;
1	podcast_episode (2).wav	2026/05/22/28562101-8af1-42a1-9553-aa25bacef7d3-podcast_episode-2-.wav	duma-resources	audio/wav	12129210	https://7816743d29a119ac46560b1cfb1f4895.r2.cloudflarestorage.com/duma-resources/2026/05/22/28562101-8af1-42a1-9553-aa25bacef7d3-podcast_episode-2-.wav	PENDING_UPLOAD	2026-05-22 01:17:27.058091	2026-05-22 01:17:27.058091
2	podcast_episode (2).wav	2026/05/22/f934b918-3413-440a-9271-2b8d47202407-podcast_episode-2-.wav	duma-resources	audio/wav	12129210	https://7816743d29a119ac46560b1cfb1f4895.r2.cloudflarestorage.com/duma-resources/2026/05/22/f934b918-3413-440a-9271-2b8d47202407-podcast_episode-2-.wav	PENDING_UPLOAD	2026-05-22 01:17:50.441732	2026-05-22 01:17:50.441732
3	podcast_episode (2).wav	2026/05/22/44594202-1d68-4e94-a896-c3d453797854-podcast_episode-2-.wav	duma-resources	audio/wav	12129210	https://7816743d29a119ac46560b1cfb1f4895.r2.cloudflarestorage.com/duma-resources/2026/05/22/44594202-1d68-4e94-a896-c3d453797854-podcast_episode-2-.wav	PENDING_UPLOAD	2026-05-22 01:18:31.913248	2026-05-22 01:18:31.913248
4	podcast_episode (2).wav	2026/05/22/be1a35ba-2466-4718-8939-ab735d6c33ad-podcast_episode-2-.wav	duma-resources	audio/wav	12129210	https://7816743d29a119ac46560b1cfb1f4895.r2.cloudflarestorage.com/duma-resources/2026/05/22/be1a35ba-2466-4718-8939-ab735d6c33ad-podcast_episode-2-.wav	PENDING_UPLOAD	2026-05-22 01:24:01.758414	2026-05-22 01:24:01.758414
5	podcast_episode (2).wav	2026/05/22/08192304-579e-4a64-a9d8-e64449721c20-podcast_episode-2-.wav	duma-resources	audio/wav	12129210	https://7816743d29a119ac46560b1cfb1f4895.r2.cloudflarestorage.com/duma-resources/2026/05/22/08192304-579e-4a64-a9d8-e64449721c20-podcast_episode-2-.wav	PENDING_UPLOAD	2026-05-22 01:28:20.70191	2026-05-22 01:28:20.70191
6	podcast_episode (2).wav	2026/05/22/18140bd5-dfc7-47d8-b7c1-34ff211f0ede-podcast_episode-2-.wav	duma-resources	audio/wav	12129210	https://7816743d29a119ac46560b1cfb1f4895.r2.cloudflarestorage.com/duma-resources/2026/05/22/18140bd5-dfc7-47d8-b7c1-34ff211f0ede-podcast_episode-2-.wav	PENDING_UPLOAD	2026-05-22 01:33:37.219015	2026-05-22 01:33:37.219015
7	podcast_episode (2).wav	2026/05/22/7d1a3c2d-4130-49af-9dc4-f64dad734d24-podcast_episode-2-.wav	duma-resources	audio/wav	12129210	https://7816743d29a119ac46560b1cfb1f4895.r2.cloudflarestorage.com/duma-resources/2026/05/22/7d1a3c2d-4130-49af-9dc4-f64dad734d24-podcast_episode-2-.wav	UPLOADED	2026-05-22 01:35:43.075516	2026-05-22 01:35:47.632716
8	sciencePodcast.png	2026/05/22/6094cef1-3a16-4f9c-b18a-fde406e159a4-sciencePodcast.png	duma-resources	image/png	2226464	https://7816743d29a119ac46560b1cfb1f4895.r2.cloudflarestorage.com/duma-resources/2026/05/22/6094cef1-3a16-4f9c-b18a-fde406e159a4-sciencePodcast.png	UPLOADED	2026-05-22 01:47:43.915162	2026-05-22 01:47:47.007577
9	historyBrazil.wav	2026/05/22/35f64790-9249-40a3-a804-22f173436ba1-historyBrazil.wav	duma-resources	audio/wav	9327930	https://7816743d29a119ac46560b1cfb1f4895.r2.cloudflarestorage.com/duma-resources/2026/05/22/35f64790-9249-40a3-a804-22f173436ba1-historyBrazil.wav	UPLOADED	2026-05-22 01:55:33.588364	2026-05-22 01:55:37.428671
10	historyPodcast.png	2026/05/22/50149253-5812-4ddf-beba-662e33c7c2e2-historyPodcast.png	duma-resources	image/png	2921131	https://7816743d29a119ac46560b1cfb1f4895.r2.cloudflarestorage.com/duma-resources/2026/05/22/50149253-5812-4ddf-beba-662e33c7c2e2-historyPodcast.png	UPLOADED	2026-05-22 01:55:37.454271	2026-05-22 01:55:40.393278
11	theuglyduckling.wav	2026/05/22/10b90888-1aa6-43a1-bad5-22544b73f2aa-theuglyduckling.wav	duma-resources	audio/wav	17916090	https://7816743d29a119ac46560b1cfb1f4895.r2.cloudflarestorage.com/duma-resources/2026/05/22/10b90888-1aa6-43a1-bad5-22544b73f2aa-theuglyduckling.wav	UPLOADED	2026-05-22 02:00:32.349234	2026-05-22 02:00:36.230707
12	uglyduckling.png	2026/05/22/3ef696e0-43fe-4d0f-b789-5fa7fccdd512-uglyduckling.png	duma-resources	image/png	2128040	https://7816743d29a119ac46560b1cfb1f4895.r2.cloudflarestorage.com/duma-resources/2026/05/22/3ef696e0-43fe-4d0f-b789-5fa7fccdd512-uglyduckling.png	UPLOADED	2026-05-22 02:00:36.251986	2026-05-22 02:00:39.089917
\.


--
-- Data for Name: flashcards; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.flashcards (id, user_id, front, front_normalized, back, context, example, due_date, interval_days, ease_factor, repetitions, created_at, updated_at) FROM stdin;
fb6d30c2-57bb-4751-a23d-4c0849fa65f8	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	count	count	contar	Can you count from 1 to 10?	\N	2026-05-23	1	2.06	1	2026-05-21 01:28:25.548051+00	2026-05-22 05:12:52.530801+00
8bcecce7-8904-4cd9-bbc5-1627435ea9d0	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	fox	fox	raposa	The quick brown fox jumps over the lazy dog.	\N	2026-05-28	6	2.6	2	2026-05-21 12:27:47.938745+00	2026-05-22 05:13:08.067216+00
8eb5eb44-271c-4048-8b42-8cfa2f3b3713	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	jumps	jumps	salta	The quick brown fox jumps over the lazy dog.	\N	2026-05-28	6	2.6	2	2026-05-21 12:27:41.676654+00	2026-05-22 05:13:13.489767+00
ac2aaa0b-c374-4d5d-8408-24d9087c59d4	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	man	man	homem	Say: "My mother is years old" or "My brother is years old."\nEmma: Remember to use "I am" for yourself, "He is" for a man, and "She is" for a woman!	\N	2026-05-23	1	2.06	1	2026-05-21 01:37:20.745466+00	2026-05-22 05:13:15.597243+00
8f7cb6ce-13fe-4313-9828-ee92725b9388	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	old	old	velho	How old are you, Lucas?	\N	2026-05-23	1	1.96	1	2026-05-21 01:37:43.779155+00	2026-05-22 05:13:17.969632+00
fd07e8b7-03ed-4726-9cf2-96307b59e06a	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	programming	programming	programação	Programming is a challenging but rewarding skill that requires logic and creativity.	\N	2026-05-28	6	2.5	2	2026-05-21 12:49:30.531582+00	2026-05-22 05:13:20.50018+00
8c5fe711-de12-49f4-b46b-72f72b9b869c	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	rather	rather	em vez de	They also say the best development systems protect consistency rather than chasing quick visibility.	\N	2026-05-28	6	2.5	2	2026-05-21 04:22:49.455334+00	2026-05-22 05:13:29.35834+00
d418a3e2-f575-4273-bb1c-490f3c5e3f01	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	rewarding	rewarding	gratificante	Programming is a challenging but rewarding skill that requires logic and creativity.	\N	2026-05-28	6	2.46	2	2026-05-21 12:28:11.652645+00	2026-05-22 05:13:31.510853+00
bd2bd523-3f53-42a1-936f-b28f05aea049	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	teacher	teacher	professor	I am a teacher and a student.	\N	2026-05-23	1	2.06	1	2026-05-21 01:36:56.617572+00	2026-05-22 05:13:33.331182+00
427a5c31-6921-4987-963f-a4b9a27ae303	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	youth	youth	juventude	Youth Development Programs Prioritize Patience Over Immediate Results	\N	2026-05-23	1	2.06	1	2026-05-21 04:22:59.906521+00	2026-05-22 05:13:35.396586+00
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	create users table	SQL	V1__create_users_table.sql	-441728299	duma	2026-05-18 11:23:37.608053	26	t
2	2	create students table	SQL	V2__create_students_table.sql	-1704828357	duma	2026-05-18 11:23:37.672039	13	t
3	3	create teachers table	SQL	V3__create_teachers_table.sql	286358968	duma	2026-05-18 11:23:37.699642	12	t
4	4	create skill categories table	SQL	V4__create_skill_categories_table.sql	1451921898	duma	2026-05-18 11:23:37.724569	23	t
5	5	create skills table	SQL	V5__create_skills_table.sql	1656967219	duma	2026-05-18 11:23:37.758274	29	t
6	6	create stages table	SQL	V6__create_stages_table.sql	-1912476694	duma	2026-05-18 11:23:37.797966	25	t
7	7	create modules table	SQL	V7__create_modules_table.sql	734459898	duma	2026-05-18 11:23:37.832575	12	t
8	8	create lessons table	SQL	V8__create_lessons_table.sql	2006867476	duma	2026-05-18 11:23:37.853497	16	t
9	9	create enrollments table	SQL	V9__create_enrollments_table.sql	-822209021	duma	2026-05-18 11:23:37.877835	18	t
10	10	create meetings table	SQL	V10__create_meetings_table.sql	1967912027	duma	2026-05-18 11:23:37.902449	13	t
11	11	create attendances table	SQL	V11__create_attendances_table.sql	-973411980	duma	2026-05-18 11:23:37.922708	12	t
12	12	create lesson progress table	SQL	V12__create_lesson_progress_table.sql	203403657	duma	2026-05-18 11:23:37.954125	12	t
13	13	create module performance table	SQL	V13__create_module_performance_table.sql	-1351407094	duma	2026-05-18 11:23:37.97566	12	t
14	14	create attempts table	SQL	V14__create_attempts_table.sql	-837503578	duma	2026-05-18 11:23:37.995459	15	t
15	15	add feedback to attempts	SQL	V15__add_feedback_to_attempts.sql	-1707699677	duma	2026-05-18 11:23:38.020229	1	t
16	16	convert lob text columns	SQL	V16__convert_lob_text_columns.sql	2040333147	duma	2026-05-18 11:23:38.028907	16	t
17	17	make student bio nullable	SQL	V17__make_student_bio_nullable.sql	-63653855	duma	2026-05-18 11:23:38.052027	2	t
18	18	create exercise reported issues table	SQL	V18__create_exercise_reported_issues_table.sql	635184876	duma	2026-05-18 11:23:38.061886	12	t
19	19	add skill id to stages	SQL	V19__add_skill_id_to_stages.sql	-57418511	duma	2026-05-18 11:23:38.082419	26	t
20	20	create plans table	SQL	V20__create_plans_table.sql	-1958720905	duma	2026-05-18 11:23:38.127236	27	t
21	21	add plan and lesson to enrollments	SQL	V21__add_plan_and_lesson_to_enrollments.sql	1203113661	duma	2026-05-18 11:23:38.161936	3	t
22	22	add forever period to plans	SQL	V22__add_forever_period_to_plans.sql	-298675871	duma	2026-05-18 11:23:38.176093	1	t
23	23	add role to users table	SQL	V23__add_role_to_users_table.sql	-1298279130	duma	2026-05-18 11:23:38.186427	3	t
24	24	add lesson and plan to meetings	SQL	V24__add_lesson_and_plan_to_meetings.sql	-1798850086	duma	2026-05-18 11:23:38.198182	18	t
25	25	add meeting type to meetings	SQL	V25__add_meeting_type_to_meetings.sql	-1268217468	duma	2026-05-18 11:23:38.223733	2	t
26	26	create resource categories table	SQL	V26__create_resource_categories_table.sql	-1143910951	duma	2026-05-18 11:23:38.23242	11	t
27	27	create resources table	SQL	V27__create_resources_table.sql	574452939	duma	2026-05-18 11:23:38.249957	14	t
28	28	create files table	SQL	V28__create_files_table.sql	40584829	duma	2026-05-18 11:23:38.273476	16	t
29	29	alter resources add file id and nullable url	SQL	V29__alter_resources_add_file_id_and_nullable_url.sql	-295155461	duma	2026-05-18 11:23:38.296633	4	t
30	30	backfill resources url and make not null	SQL	V30__backfill_resources_url_and_make_not_null.sql	414983778	duma	2026-05-18 11:23:38.308608	2	t
31	31	create flashcards table	SQL	V31__create_flashcards_table.sql	-1718000666	duma	2026-05-18 11:23:38.317594	29	t
32	32	create cash flow tables	SQL	V32__create_cash_flow_tables.sql	-1237046316	duma	2026-05-19 02:41:35.717229	68	t
33	33	create podcast categories and podcasts tables	SQL	V33__create_podcast_categories_and_podcasts_tables.sql	-1661301546	duma	2026-05-21 16:40:39.252269	54	t
34	34	create video categories and videos tables	SQL	V34__create_video_categories_and_videos_tables.sql	48366339	duma	2026-05-22 03:36:46.297977	106	t
35	35	create lesson books tables	SQL	V35__create_lesson_books_tables.sql	-1047398291	duma	2026-05-22 04:42:14.416696	152	t
36	36	create news categories and news articles tables	SQL	V36__create_news_categories_and_news_articles_tables.sql	942328212	duma	2026-05-22 05:34:21.200919	147	t
\.


--
-- Data for Name: lesson_book_chapters; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.lesson_book_chapters (id, lesson_book_id, order_index, title, summary, markdown, created_at, updated_at) FROM stdin;
foundations-chapter-1	lesson-book-foundations	1	Chapter 1 · Introductions	Apresentações básicas, greetings e construção de frases curtas.	### Slide 1: Greetings (Saudações)\n**Common Greetings:**\n- **Hello!** / **Hi!** - Olá!\n- **Good morning!** - Bom dia!\n- **Good afternoon!** - Boa tarde!\n- **Good evening!** - Boa noite! (chegada)\n- **Goodbye!** / **Bye!** - Tchau!\n- **Good night!** - Boa noite! (despedida)\n\n**Practice:** Alunos repetem após o professor\n\n---\n\n### Slide 2: How are you? (Como você está?)\n**Question:** How are you?\n\n**Possible Answers:**\n- I'm fine, thank you!\n- I'm good!\n- I'm great!\n- I'm OK.\n- I'm tired.\n\n**Practice Dialogue:**\n- A: Hello! How are you?\n- B: I'm fine, thank you! And you?\n- A: I'm great!\n\n---\n\n### Slide 3: Personal Pronouns (Pronomes Pessoais)\n| English | Portuguese |\n|---------|------------|\n| I | Eu |\n| You | Você |\n| He | Ele |\n| She | Ela |\n| It | Ele/Ela (objetos/animais) |\n| We | Nós |\n| They | Eles/Elas |\n\n---\n\n### Slide 4: Verb "To Be" - Affirmative\n**Conjugation:**\n- I **am** (I'm)\n- You **are** (You're)\n- He **is** (He's)\n- She **is** (She's)\n- It **is** (It's)\n- We **are** (We're)\n- They **are** (They're)\n\n**Examples:**\n- I am Maria.\n- You are a student.\n- He is John.\n- We are friends.\n\n---\n\n### Slide 5: Introductions (Apresentações)\n**Introducing Yourself:**\n- Hello! My name is [name].\n- Hi! I'm [name].\n- Nice to meet you!\n\n**Asking Someone's Name:**\n- What's your name?\n- What is your name?\n\n**Example Dialogue:**\n- A: Hello! My name is Ana. What's your name?\n- B: Hi! I'm Carlos. Nice to meet you!\n- A: Nice to meet you too!\n\n---	2026-05-22 04:42:14.50113	2026-05-22 04:46:25.657807
lesson-book-foundations-chapter-2-numbers	lesson-book-foundations	2	Chapter 2 - Numbers	Aprendendo a usar os números	### Numbers 0-20\n| Number | English | Number | English |\n|--------|---------|--------|---------|\n| 0 | Zero | 11 | Eleven |\n| 1 | One | 12 | Twelve |\n| 2 | Two | 13 | Thirteen |\n| 3 | Three | 14 | Fourteen |\n| 4 | Four | 15 | Fifteen |\n| 5 | Five | 16 | Sixteen |\n| 6 | Six | 17 | Seventeen |\n| 7 | Seven | 18 | Eighteen |\n| 8 | Eight | 19 | Nineteen |\n| 9 | Nine | 20 | Twenty |\n| 10 | Ten | | |\n\n### Tens (20-100)\n- 20 = Twenty\n- 30 = Thirty\n- 40 = Forty\n- 50 = Fifty\n- 60 = Sixty\n- 70 = Seventy\n- 80 = Eighty\n- 90 = Ninety\n- 100 = One hundred\n\n### Age Vocabulary\n- How old are you? = Quantos anos você tem?\n- I am ___ years old = Eu tenho ___ anos\n- Birthday = Aniversário\n- Age = Idade\n- Year = Ano\n- Old = Velho (para idade)\n- Young = Jovem\n\n---\n\n## 📚 Grammar: Numbers with "To Be"\n\n### Talking About Age\n**Structure:** Subject + to be + number + years old\n\n**Examples:**\n- I **am** 25 years old.\n- You **are** 30 years old.\n- He **is** 18 years old.\n- She **is** 22 years old.\n- We **are** 20 years old.\n- They **are** 35 years old.\n\n### Questions About Age\n- **How old are you?** = Quantos anos você tem?\n- **How old is he/she?** = Quantos anos ele/ela tem?\n- **How old are they?** = Quantos anos eles têm?\n\n---	2026-05-22 04:48:48.663306	2026-05-22 04:48:48.663306
\.


--
-- Data for Name: lesson_books; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.lesson_books (id, lesson_id, title, subtitle, pdf_url, created_at, updated_at) FROM stdin;
lesson-book-foundations	a8266af0-d70c-3ff7-ae06-682698956039	English Foundations	Introdução guiada com leitura, vocabulário e exemplos visuais.	https://example.com/apostila.pdf	2026-05-22 04:42:14.50113	2026-05-22 04:42:14.50113
\.


--
-- Data for Name: lesson_progress; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.lesson_progress (id, student_id, lesson_id, status, progress_percent, watched_minutes, started_at, last_access_at, completed_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: lessons; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.lessons (id, title, content, order_index, is_active, module_id, stage_id, skill_id, video_url, duration_in_minutes, created_at, updated_at) FROM stdin;
60bfba6d-6a76-3c7b-974a-b131f0c51379	Seed 11 - Body, Health & Feelings	Partes do corpo, sintomas simples, sentimentos e pedidos de ajuda. Gramatica: "I have a...", "My ___ hurts", "feel + adjective", "should" inicial para conselho simples.	11	t	aa5d40a2-b02a-333a-88eb-608939a5a851	1	1	\N	\N	2026-05-18 11:23:48.43387	2026-05-22 05:34:47.243425
a98ac91d-4476-3819-b349-b8a6d00176c0	Seed 12 - A1 Integration: People, Places & Needs	Revisao integrada de apresentacao pessoal, rotina, comida, cidade, compras, saude e lazer. Foco em pequenos dialogos, emails/notas curtas, listening lento e pronuncia de sons basicos, word stress e entonacao de perguntas.	12	t	aa5d40a2-b02a-333a-88eb-608939a5a851	1	1	\N	\N	2026-05-18 11:23:48.43577	2026-05-22 05:34:47.246498
8f06baf8-dafc-3328-80d9-8b171e68e3e8	Root 01 - Shopping, Money & Quantities	Compras, precos, tamanhos, medidas, embalagem, formas de pagamento e trocas simples. Gramatica: quantifiers, demonstratives, comparativos basicos, "How much/How many" e pedidos educados.	1	t	d2fffdc9-88cc-3b48-805a-2ea4309a30ed	2	1	\N	\N	2026-05-18 11:23:48.442311	2026-05-22 05:34:47.259135
a8ff0ea0-c818-36a2-a4c0-042d14de0efe	Root 02 - Travel, Transport & Accommodation	Transporte, viagens, hospedagem, horarios, bilhetes, reservas e informacoes turisticas. Gramatica: preposicoes de movimento, "going to", perguntas indiretas simples e leitura de avisos/horarios.	2	t	d2fffdc9-88cc-3b48-805a-2ea4309a30ed	2	1	\N	\N	2026-05-18 11:23:48.443886	2026-05-22 05:34:47.262217
72bed3f6-ed36-311f-b903-34c4b04e7fce	Root 03 - Past Events & Life Stories	Experiencias passadas, memorias, biografia simples e eventos pessoais. Gramatica: Past Simple regular/irregular, "was/were", expressoes de tempo passado e narrativa curta em sequencia.	3	t	d2fffdc9-88cc-3b48-805a-2ea4309a30ed	2	1	\N	\N	2026-05-18 11:23:48.445515	2026-05-22 05:34:47.265211
50721237-885b-39d2-a110-f84a13e70b11	Root 04 - Restaurants, Cooking & Service Encounters	Restaurante, cardapio, pedidos, preferencias alimentares, formas de preparo e problemas no atendimento. Gramatica: "would like", "could/can I", countable/uncountable em contexto e linguagem de reclamacao simples.	4	t	51e6a8ab-c369-3b27-b2d0-ed7de47793b0	2	1	\N	\N	2026-05-18 11:23:48.449729	2026-05-22 05:34:47.271305
4a469a5b-a001-3925-8a4a-a709c8efb812	Root 05 - Education, Study & Learning Habits	Escola, materias, tarefas, cursos, habilidades de estudo e objetivos de aprendizagem. Gramatica: Present Simple vs Present Continuous, "good at/interested in", infinitive of purpose e linguagem de instrucao.	5	t	51e6a8ab-c369-3b27-b2d0-ed7de47793b0	2	1	\N	\N	2026-05-18 11:23:48.45188	2026-05-22 05:34:47.274308
55b2ca88-88eb-3cf6-80e2-d70027c4dc41	Root 06 - Describing People, Personality & Relationships	Aparencia, personalidade, relacoes sociais e comparacoes entre pessoas. Gramatica: comparative/superlative adjectives, modifiers simples e adjetivos com preposicao.	6	t	51e6a8ab-c369-3b27-b2d0-ed7de47793b0	2	1	\N	\N	2026-05-18 11:23:48.453505	2026-05-22 05:34:47.277429
e2ec1ea4-2963-37a8-b8a2-24406d52eb27	Root 07 - Home, Neighbourhood & Services	Moradia, bairro, servicos locais, problemas domesticos e convivencia. Gramatica: "there was/were", preposicoes mais amplas, "need to/have to" e pedidos de manutencao.	7	t	b84ab2f7-fdb9-3f8c-b032-97b5aea8044a	2	1	\N	\N	2026-05-18 11:23:48.456749	2026-05-22 05:34:47.283575
54143d5f-26db-33db-9f6f-586cd45119ab	Root 08 - Technology, Communication & Online Basics	Celular, computador, internet, mensagens, emails simples, apps e seguranca digital basica. Gramatica: imperatives para instrucoes, "can/could", object pronouns e sequenciadores simples.	8	t	b84ab2f7-fdb9-3f8c-b032-97b5aea8044a	2	1	\N	\N	2026-05-18 11:23:48.458467	2026-05-22 05:34:47.286537
2458b8a7-451b-3d7c-8515-5e08e8b3d787	Root 09 - Work, Jobs & Daily Responsibilities	Profissoes, local de trabalho, tarefas, horarios, responsabilidades e entrevistas simples. Gramatica: "What do you do?", "have to/don't have to", adverbios de frequencia e perguntas de rotina profissional.	9	t	b84ab2f7-fdb9-3f8c-b032-97b5aea8044a	2	1	\N	\N	2026-05-18 11:23:48.460184	2026-05-22 05:34:47.289711
a1d62146-40cf-3bcf-8615-350e785cd7a6	Root 10 - Sports, Entertainment & Events	Esportes, atividades culturais, eventos, ingressos, convites e combinacoes sociais. Gramatica: "would you like to", "shall", "let's", "going to" para planos e aceitar/recusar convites.	10	t	5f2425bf-f771-33d9-bb79-36a785c61e85	2	1	\N	\N	2026-05-18 11:23:48.465181	2026-05-22 05:34:47.29743
f12bc8dd-05a0-3459-9adc-584a27a2eb56	Root 11 - Nature, Animals & Environment Basics	Natureza, animais, paisagens, clima extremo e habitos ambientais simples. Gramatica: comparativos, "should/shouldn't", Zero Conditional inicial e linguagem de causa simples.	11	t	5f2425bf-f771-33d9-bb79-36a785c61e85	2	1	\N	\N	2026-05-18 11:23:48.470737	2026-05-22 05:34:47.300321
eeb93412-e1bc-3294-8396-37a04e49bdc1	Seed 02 - Personal Information, Numbers & Forms	Nome, idade, telefone, endereco, nacionalidade, paises, numeros, datas basicas e preenchimento de formularios simples. Gramatica: "to be", possessive adjectives, question words e ordem basica da pergunta.	2	t	39249b18-1cf2-3736-8fe7-b17433d8f5c7	1	1	\N	\N	2026-05-18 11:23:48.4045	2026-05-22 05:34:47.20198
df4e3584-8948-3133-964a-19f499de7e11	Seed 03 - Family, People & Possessions	Familia, relacoes, objetos pessoais e descricao simples de pessoas. Gramatica: "have/have got", possessive 's, plurais regulares/irregulares, "this/that/these/those".	3	t	39249b18-1cf2-3736-8fe7-b17433d8f5c7	1	1	\N	\N	2026-05-18 11:23:48.40677	2026-05-22 05:34:47.205116
ccb7e14c-004f-3fc8-b7e3-8e1e0eefcd0e	Seed 04 - Time, Days & Daily Routine	Horas, dias da semana, meses, partes do dia e rotina diaria. Gramatica: Present Simple afirmativo/negativo/interrogativo, adverbios de frequencia iniciais e preposicoes de tempo "at/in/on".	4	t	7631815d-97aa-38ad-af94-0e081dc21cd5	1	1	\N	\N	2026-05-18 11:23:48.411791	2026-05-22 05:34:47.211893
0f944b4c-05ad-3d8e-b633-b2f387198244	Seed 05 - Food, Drinks & Preferences	Comidas, bebidas, refeicoes, frutas, vegetais e preferencias. Gramatica: countable/uncountable nouns, "some/any", "much/many", "I like/don't like", perguntas com "do/does".	5	t	7631815d-97aa-38ad-af94-0e081dc21cd5	1	1	\N	\N	2026-05-18 11:23:48.414325	2026-05-22 05:34:47.215461
acaf7b28-2782-39b8-9e84-5dda8d7c4323	Seed 06 - Clothes, Colours & Appearance	Roupas, cores, acessorios, tamanhos e aparencia fisica. Gramatica: ordem basica dos adjetivos, "be wearing", Present Continuous e diferenca entre rotina e momento atual.	6	t	7631815d-97aa-38ad-af94-0e081dc21cd5	1	1	\N	\N	2026-05-18 11:23:48.416766	2026-05-22 05:34:47.218663
437e372b-b328-3069-bb6a-95a7c59d4177	Seed 07 - Home, Rooms & Everyday Objects	Comodos, moveis, objetos domesticos e localizacao. Gramatica: "there is/there are", preposicoes de lugar, artigos "a/an/the" e descricoes simples de forma, cor e funcao.	7	t	42755161-bedb-384c-9d9e-8f0df993c98a	1	1	\N	\N	2026-05-18 11:23:48.421492	2026-05-22 05:34:47.225592
9e869cd7-23b9-3d5e-bd4c-5d140c263cf3	Seed 08 - City Places, Directions & Signs	Lugares da cidade, placas, instrucoes simples e direcoes. Gramatica: imperatives, "can" para pedidos, "where is...?", "next to/opposite/between" e linguagem funcional de localizacao.	8	t	42755161-bedb-384c-9d9e-8f0df993c98a	1	1	\N	\N	2026-05-18 11:23:48.423819	2026-05-22 05:34:47.228869
26f5163d-be0b-3e73-85fb-a460bf2793e1	Seed 09 - Weather, Seasons & Activities	Clima, estacoes, atividades comuns e planos simples ligados ao tempo. Gramatica: "It's sunny", Present Simple para fatos, "can/can't" e vocabulario de sensacoes fisicas basicas.	9	t	42755161-bedb-384c-9d9e-8f0df993c98a	1	1	\N	\N	2026-05-18 11:23:48.426011	2026-05-22 05:34:47.232205
06b78cd3-f1a3-3a70-b8e6-ccb8ddbee3b6	Seed 10 - Hobbies, Abilities & Free Time	Hobbies, esportes, musica, filmes, jogos e habilidades. Gramatica: "can" para habilidade, "like/love/hate + -ing", adverbios de frequencia e perguntas sobre lazer.	10	t	aa5d40a2-b02a-333a-88eb-608939a5a851	1	1	\N	\N	2026-05-18 11:23:48.431629	2026-05-22 05:34:47.239314
3d30f11e-c00a-3a5e-8464-454a9a65e7db	Leaf 10 - Real and Hypothetical Conditions	Condicoes reais e hipoteticas ligadas a estudo, trabalho, saude e decisoes. Gramatica: Zero, First e Second Conditional, "unless", "if/when" e consequencias.	10	t	c6e1a8f5-c259-317b-971a-17bb532f8fd5	3	1	\N	\N	2026-05-18 11:23:48.536559	2026-05-22 05:34:47.35275
feb0fb27-8dc5-3fc8-a8a5-4c1dc679a6e0	Leaf 11 - Passive Voice & Public Information	Noticias simples, processos, produtos, regras e informacoes publicas. Gramatica: passive voice no presente e passado, agente com "by", notices, signs e instrucoes formais.	11	t	c6e1a8f5-c259-317b-971a-17bb532f8fd5	3	1	\N	\N	2026-05-18 11:23:48.539033	2026-05-22 05:34:47.355649
8d7cd088-787b-32f4-bac4-4d5fe4caf2ca	Leaf 12 - A2+ Integration: Functional Fluency	Revisao com roleplays de viagem, servicos, saude, trabalho, estudo, convivencia e online. Foco em fluencia controlada, reparo de comunicacao, pronuncia inteligivel e escrita funcional.	12	t	c6e1a8f5-c259-317b-971a-17bb532f8fd5	3	1	\N	\N	2026-05-18 11:23:48.541352	2026-05-22 05:34:47.358223
77642a3d-d9f1-399d-95dc-2d881ba2005b	Branch 01 - Habits, Lifestyles & Stative Verbs	Habitos, estilo de vida, tendencias pessoais e mudancas em andamento. Gramatica: Present Simple vs Present Continuous, stative verbs, frequency adverbs avancados e "tend to".	1	t	0457bb19-7f63-348c-873d-0334eb33801c	4	1	\N	\N	2026-05-18 11:23:48.548864	2026-05-22 05:34:47.36715
eaf1a04e-581c-3c24-a0dc-5f1b94e4be78	Branch 02 - Narrative Tenses & Personal Anecdotes	Narrativas pessoais mais longas, incidentes, viagens e experiencias marcantes. Gramatica: Past Simple, Past Continuous, Past Perfect, sequenciadores e expressao de surpresa/contraste.	2	t	0457bb19-7f63-348c-873d-0334eb33801c	4	1	\N	\N	2026-05-18 11:23:48.551541	2026-05-22 05:34:47.369821
29994dd5-773a-3dd5-a49f-a50369d92bcd	Branch 03 - Future Forms & Arrangements	Planos, decisoes, previsoes, agendas e combinacoes. Gramatica: "will", "going to", Present Continuous futuro, "be about to", "likely/unlikely" e graus de certeza.	3	t	0457bb19-7f63-348c-873d-0334eb33801c	4	1	\N	\N	2026-05-18 11:23:48.553929	2026-05-22 05:34:47.37247
39f08cf7-a3a6-389a-9b97-33e7300118ba	Branch 04 - Travel, Culture Shock & Practical Survival	Viagens, aeroportos, hospedagem, costumes, problemas em outro pais e negociacao de sentido. Gramatica: indirect questions, polite requests, reported instructions e vocabulario intercultural basico.	4	t	2fa59dc1-c018-311e-9e48-d9cdff283a67	4	1	\N	\N	2026-05-18 11:23:48.558877	2026-05-22 05:34:47.378082
d1024478-08bb-3545-9987-ee18d9f7c38b	Branch 05 - Problems, Solutions & Decision Making	Problemas cotidianos, alternativas, consequencias, prioridades e tomada de decisao. Gramatica: modals of obligation/necessity, "managed to/failed to", gerunds/infinitives e conectores de causa/resultado.	5	t	2fa59dc1-c018-311e-9e48-d9cdff283a67	4	1	\N	\N	2026-05-18 11:23:48.56167	2026-05-22 05:34:47.380836
c9b66c14-38b8-31b2-b84c-804c1f24bbcf	Branch 06 - Preferences, Taste & Consumer Choices	Preferencias, consumo, avaliacoes de produtos, lazer e escolhas pessoais. Gramatica: verb patterns, "would rather/prefer", gradable adjectives, intensifiers e linguagem de reviews.	6	t	2fa59dc1-c018-311e-9e48-d9cdff283a67	4	1	\N	\N	2026-05-18 11:23:48.564036	2026-05-22 05:34:47.383512
8f6d4c89-52ae-3bbd-8d69-6416a17ad1a9	Branch 07 - Health, Wellbeing & Lifestyle Advice	Saude fisica/mental, sintomas, habitos, dieta, sono, estresse e consulta medica. Gramatica: Present Perfect Continuous, advice modals, "for/since", "I've been feeling..." e collocations de saude.	7	t	45e2aed0-e189-3a57-b5e8-1844ed0749d5	4	1	\N	\N	2026-05-18 11:23:48.568889	2026-05-22 05:34:47.388626
34a19ebb-4f48-3d2f-bc57-f8863f0c8185	Branch 08 - Work, Careers & Professional Communication	Carreira, curriculo, entrevistas, ambiente corporativo, emails e reunioes simples. Gramatica: Present Perfect para experiencia, formal register inicial, polite requests e reported speech basico.	8	t	45e2aed0-e189-3a57-b5e8-1844ed0749d5	4	1	\N	\N	2026-05-18 11:23:48.571271	2026-05-22 05:34:47.391373
a21b399e-80b0-3b4a-8a05-c89b6323d2e8	Branch 09 - Media, News & Digital Literacy	Noticias, manchetes, redes sociais, fontes, opiniao, vies e checagem de informacao. Gramatica: passive voice, reporting verbs, "it is said/reported", discurso indireto inicial e leitura critica.	9	t	45e2aed0-e189-3a57-b5e8-1844ed0749d5	4	1	\N	\N	2026-05-18 11:23:48.573913	2026-05-22 05:34:47.394072
7112d42b-3fc6-3c7e-a9a3-8261db6e61a5	Branch 10 - Environment, Sustainability & Science Basics	Sustentabilidade, energia, clima, poluicao, biodiversidade e acoes ambientais. Gramatica: Zero/First Conditional, "should/ought to", cause-effect language e linguagem de dados simples.	10	t	c4b0725f-cc8c-3f5a-865f-42ddb583f631	4	1	\N	\N	2026-05-18 11:23:48.580261	2026-05-22 05:34:47.40048
649d4fce-5426-3daa-826a-91995269e2cf	Leaf 01 - Requests, Offers, Permission & Politeness	Pedidos, permissoes, favores, oferecimentos e niveis de formalidade. Gramatica: "could", "would", "may", "Would you mind...?", respostas educadas e entonacao de cortesia.	1	t	ba3a7410-0671-370e-8ec5-4d792e37c90a	3	1	\N	\N	2026-05-18 11:23:48.493254	2026-05-22 05:34:47.31311
710a087a-6c1a-3345-9319-889718580a8f	Leaf 02 - Past Continuous & Interrupted Actions	Acoes em progresso no passado, interrupcoes, incidentes e pequenas historias. Gramatica: Past Continuous vs Past Simple, "when/while", conectores narrativos e ordem cronologica.	2	t	ba3a7410-0671-370e-8ec5-4d792e37c90a	3	1	\N	\N	2026-05-18 11:23:48.497019	2026-05-22 05:34:47.31607
e21c8518-636a-3534-8554-6ebbe15f6101	Leaf 03 - Experiences & Present Perfect	Experiencias de vida, viagens, conquistas e novidades recentes. Gramatica: Present Perfect com "ever/never/already/yet/just", contraste com Past Simple e perguntas de experiencia.	3	t	ba3a7410-0671-370e-8ec5-4d792e37c90a	3	1	\N	\N	2026-05-18 11:23:48.507139	2026-05-22 05:34:47.319103
9d47287d-2631-3b9f-91ee-e49dcb1cfe07	Leaf 04 - Comparing, Contrasting & Choosing	Comparar produtos, lugares, pessoas, opcoes e experiencias. Gramatica: comparativos, superlativos, "as...as", "less/more than", "too/enough" e justificativas de escolha.	4	t	d15bc9d7-216b-32a6-ba04-45af94f6594e	3	1	\N	\N	2026-05-18 11:23:48.512445	2026-05-22 05:34:47.325481
7e016249-9559-3fa1-8fa0-30d1b359b2f9	Leaf 05 - Opinions, Agreement & Disagreement	Opinioes pessoais, preferencias, concordancia, discordancia e justificativas. Gramatica: opinion phrases, "because/so/although", intensifiers simples e organizacao de resposta curta.	5	t	d15bc9d7-216b-32a6-ba04-45af94f6594e	3	1	\N	\N	2026-05-18 11:23:48.514736	2026-05-22 05:34:47.328569
15eb1534-1de4-31f6-9478-35992ac2f45e	Leaf 06 - Future Plans, Predictions & Possibilities	Planos, previsoes, possibilidades e graus de certeza. Gramatica: "will", "going to", Present Continuous futuro, "might/may/could", "probably/definitely/maybe".	6	t	d15bc9d7-216b-32a6-ba04-45af94f6594e	3	1	\N	\N	2026-05-18 11:23:48.51781	2026-05-22 05:34:47.331721
2de51be1-f510-3825-a4d3-5ab0d30969ad	Leaf 07 - Advice, Obligation & Rules	Conselhos, regras, proibicoes, obrigacoes e falta de necessidade. Gramatica: "should", "must", "have to", "don't have to", "mustn't", "needn't" e avisos.	7	t	a4f3c09c-493e-3d08-a078-ca675a12de3d	3	1	\N	\N	2026-05-18 11:23:48.524235	2026-05-22 05:34:47.338674
b15c4ff6-b410-385e-abd7-3ab5e39d9f09	Leaf 08 - Phrasal Verbs & Everyday Actions	Phrasal verbs frequentes em casa, trabalho, estudo, tecnologia e vida social. Gramatica: separable/inseparable phrasal verbs, object pronouns e colocacao de particulas.	8	t	a4f3c09c-493e-3d08-a078-ca675a12de3d	3	1	\N	\N	2026-05-18 11:23:48.527479	2026-05-22 05:34:47.34232
604aff68-8c35-373c-825a-320716ffc12c	Leaf 09 - Stories, Sequencing & Simple Narratives	Contar historias pessoais, resumir acontecimentos, descrever personagens e criar finais. Gramatica: Past Simple, Past Continuous, introducao ao Past Perfect, sequencers e paragraphing.	9	t	a4f3c09c-493e-3d08-a078-ca675a12de3d	3	1	\N	\N	2026-05-18 11:23:48.529581	2026-05-22 05:34:47.34532
46f3bbc0-950d-3b61-b657-440a9cfa502f	Bud 10 - Technology, Society & Change Over Time	Tecnologia, privacidade, automacao, IA, redes sociais e impacto social. Gramatica: Present Perfect Continuous, "used to/would", cause-effect connectors e linguagem de tendencia.	10	t	ccc45760-67a8-3f1c-9a13-492f9e2ad00f	5	1	\N	\N	2026-05-18 11:23:48.663347	2026-05-22 05:34:47.448089
8f076ad1-0698-3bfe-821b-456155e5080c	Bud 11 - Abstract Topics & Critical Thinking	Educacao, felicidade, liberdade, desigualdade, justica e valores. Gramatica: abstract nouns, nominalization, advanced opinion phrases, "one might argue" e desenvolvimento de ideias abstratas.	11	t	ccc45760-67a8-3f1c-9a13-492f9e2ad00f	5	1	\N	\N	2026-05-18 11:23:48.665704	2026-05-22 05:34:47.450829
c18b8323-968f-3728-ae9a-bd679aed85d5	Bud 12 - B2 Entry Integration: Presentations & Discussion	Revisao com apresentacoes curtas, debates, emails formais, leitura critica e listening semi-autentico. Foco em coesao, pronuncia para apresentacao, reparo e manejo de interacao.	12	t	ccc45760-67a8-3f1c-9a13-492f9e2ad00f	5	1	\N	\N	2026-05-18 11:23:48.667682	2026-05-22 05:34:47.453425
1e072c84-d372-3ab5-8cb3-78e6fd748741	Flower 01 - Complex Grammar in Context	Uso integrado de estruturas complexas em comunicacao natural. Gramatica: mixed conditionals, unreal time, advanced modals, cleft sentences iniciais e correcao de erros fossilizados.	1	t	d75dae5e-079e-36df-9379-7264c1fb2fd5	6	1	\N	\N	2026-05-18 11:23:48.674701	2026-05-22 05:34:47.461977
72f5faf4-1421-3c5d-9ef0-1f7e10e7ed66	Flower 02 - Discourse, Cohesion & Text Flow	Coesao, coerencia, organizacao de texto, referencia e progressao de ideias. Gramatica: substitution, ellipsis inicial, reference devices, connectors avancados, hedging/boosting e topic sentences.	2	t	d75dae5e-079e-36df-9379-7264c1fb2fd5	6	1	\N	\N	2026-05-18 11:23:48.676834	2026-05-22 05:34:47.464311
164c4a4d-aa46-3a7d-9b69-6385db5dc0f1	Flower 03 - Idioms, Collocations & Phrasal Verbs	Expressao idiomatica, collocations fortes, phrasal verbs menos transparentes e registro coloquial/profissional. Gramatica: word order in phrasal verbs, fixed expressions e conotacao.	3	t	d75dae5e-079e-36df-9379-7264c1fb2fd5	6	1	\N	\N	2026-05-18 11:23:48.679164	2026-05-22 05:34:47.466515
5199aca3-8a06-334c-8836-fa4c4d07990b	Flower 04 - Academic & Professional Writing	Ensaios, relatorios, propostas, reviews e escrita profissional. Gramatica: nominalization, passive formal, hedging academico, paragraph structure, linking devices e citacao/parafrase.	4	t	b2e05aa0-191e-356a-b7bb-8c2e6143563d	6	1	\N	\N	2026-05-18 11:23:48.68369	2026-05-22 05:34:47.471341
48450b53-a2b1-3ba3-bd67-e6a5523ade19	Flower 05 - Complex Listening & Inference	Listening autentico, inferencia, tom, atitude, implicito, ironia e fala conectada. Foco em reduced forms, discourse markers naturais, gist/detail e tomada de notas.	5	t	b2e05aa0-191e-356a-b7bb-8c2e6143563d	6	1	\N	\N	2026-05-18 11:23:48.68536	2026-05-22 05:34:47.473594
181d6241-3d3f-39d0-9623-8f3258047c7f	Flower 07 - Advanced Storytelling & Narrative Voice	Narrativa avancada, ponto de vista, ritmo, tensao, flashback e descricao sensorial. Gramatica: full narrative tenses, past perfect continuous, participle clauses iniciais e estilo direto/indireto.	7	t	47a3e3a0-6491-3de3-8c33-099ec6ff4411	6	1	\N	\N	2026-05-18 11:23:48.691701	2026-05-22 05:34:47.481277
83ad8903-57e3-3dba-a418-d9d5af281f2f	Flower 08 - Critical Reading & Text Analysis	Analise de textos autenticos, argumento, vies, pressupostos, evidencia e avaliacao. Gramatica: stance markers, contrast structures, reporting language e linguagem de critica.	8	t	47a3e3a0-6491-3de3-8c33-099ec6ff4411	6	1	\N	\N	2026-05-18 11:23:48.693676	2026-05-22 05:34:47.483894
fb6a2223-74c4-3706-9e5e-f02127a34dc0	Flower 09 - Register, Varieties & Sociolinguistics	Variacao de registro, formalidade, slang, jargon, texting, ingles americano/britanico e adequacao social. Gramatica: register shifting, pragmatics, politeness e reformulacao por audiencia.	9	t	47a3e3a0-6491-3de3-8c33-099ec6ff4411	6	1	\N	\N	2026-05-18 11:23:48.695358	2026-05-22 05:34:47.486588
ec0c661f-6ed1-3b24-b5bb-7c21dd551b10	Branch 12 - B1 Integration: Real Conversations & Writing	Revisao B1 com conversas extendidas, emails, mensagens, narrativas, opinioes e resolucao de problemas. Foco em coesao, turn-taking, question tags iniciais e pronuncia de word/sentence stress.	12	t	c4b0725f-cc8c-3f5a-865f-42ddb583f631	4	1	\N	\N	2026-05-18 11:23:48.585531	2026-05-22 05:34:47.405021
c137b008-dffe-3a78-8164-95ccd9275559	Bud 01 - Advanced Conditionals & Consequences	Condicoes reais, hipoteticas e impossiveis em decisoes pessoais, trabalho e sociedade. Gramatica: First, Second, Third Conditional, "unless/as long as/provided that" e introducao a mixed conditionals.	1	t	8cbb3b58-c59b-3b77-808f-b408cdd84cac	5	1	\N	\N	2026-05-18 11:23:48.597488	2026-05-22 05:34:47.413798
4c2df7ff-2c8d-30ff-9db7-e3d6a1df0233	Bud 02 - Reported Speech & Reporting Verbs	Reportar falas, perguntas, pedidos, promessas, sugestoes e reclamacoes. Gramatica: backshift, reported questions, reporting verbs com infinitive/gerund/that-clause e mudancas de tempo/lugar.	2	t	8cbb3b58-c59b-3b77-808f-b408cdd84cac	5	1	\N	\N	2026-05-18 11:23:48.599924	2026-05-22 05:34:47.416475
72140c10-ffff-3c11-8ea4-79d408c4ad9f	Bud 03 - Advanced Passive & Process Description	Processos, invencoes, noticias, ciencia, producao e procedimentos. Gramatica: passive em varios tempos, passive with modals, get passive, impersonal passive e escolha ativo/passivo.	3	t	8cbb3b58-c59b-3b77-808f-b408cdd84cac	5	1	\N	\N	2026-05-18 11:23:48.602434	2026-05-22 05:34:47.419411
ce50f988-d465-3b00-9cb1-c8dd4c8a1c3b	Bud 04 - Relative Clauses & Information Control	Definir, especificar e adicionar informacao sobre pessoas, objetos, lugares e ideias. Gramatica: defining/non-defining relative clauses, "whose", omission, reduced relative clauses iniciais.	4	t	64f4e506-7f9d-3fe7-a0b7-57d97e80136e	5	1	\N	\N	2026-05-18 11:23:48.634759	2026-05-22 05:34:47.424756
808f6701-b39d-3788-805d-dee4087fb387	Bud 05 - Emotions, Attitudes & Nuanced Description	Emocoes, sentimentos complexos, reacoes, personalidade e atitudes. Gramatica: adjective + preposition, -ed/-ing adjectives, intensifiers, gradable/non-gradable adjectives e collocations emocionais.	5	t	64f4e506-7f9d-3fe7-a0b7-57d97e80136e	5	1	\N	\N	2026-05-18 11:23:48.642838	2026-05-22 05:34:47.427449
3f52f480-9c3d-3bd4-81b2-6d2e1f440d9e	Bud 06 - Argumentation, Debate & Discourse Markers	Debates, opinioes estruturadas, concessao, contra-argumento e evidencia. Gramatica: discourse markers, hedging, concession clauses, "although/despite/in spite of" e paragrafo argumentativo.	6	t	64f4e506-7f9d-3fe7-a0b7-57d97e80136e	5	1	\N	\N	2026-05-18 11:23:48.648023	2026-05-22 05:34:47.430091
39d2f960-30f8-3347-8762-f81d13f997e2	Bud 07 - Processes, Instructions & Technical Language	Processos, manuais, instrucoes formais, seguranca, ferramentas e procedimentos. Gramatica: sequencing language, passive, gerunds as subjects, noun phrases e linguagem impessoal.	7	t	3c42f1fb-e16d-3ce2-b6f6-f8b01b069b46	5	1	\N	\N	2026-05-18 11:23:48.656628	2026-05-22 05:34:47.435826
9e612bf5-7fa4-3bce-84f3-c31bf4853db7	Bud 08 - Speculation, Deduction & Hypothesis	Deduzir, especular, interpretar evidencias e discutir possibilidades. Gramatica: modals of deduction present/past, "must/might/could/can't have", "looks as if", "I wonder if".	8	t	3c42f1fb-e16d-3ce2-b6f6-f8b01b069b46	5	1	\N	\N	2026-05-18 11:23:48.657924	2026-05-22 05:34:47.438859
a122559f-029d-3fb1-8184-2cce41a3e4d9	Bud 09 - Formal Writing, Emails & Professional Etiquette	Emails formais, cartas, solicitacoes, desculpas, follow-up e comunicacao profissional. Gramatica: formal register, nominalization inicial, indirect language, punctuation e paragraphing.	9	t	3c42f1fb-e16d-3ce2-b6f6-f8b01b069b46	5	1	\N	\N	2026-05-18 11:23:48.659528	2026-05-22 05:34:47.441401
d8db2ee7-371f-33ee-91b8-f0edf8771864	Fruit 10 - Power, Leadership & Influence	Linguagem de lideranca, persuasao, autoridade, inclusao, storytelling publico e tomada de decisao. Gramatica: rhetorical devices, parallelism, anaphora, abstraction e certainty management.	10	t	cbb0290c-5209-3fff-ad45-138642816a82	7	1	\N	\N	2026-05-18 11:23:48.734185	2026-05-22 05:34:47.539429
d00632be-8bd2-333e-bd0d-5abde30781c6	Fruit 11 - Philosophy, Ethics & Abstract Debate	Etica, filosofia, dilemas, valores, justica, liberdade e questoes abstratas. Gramatica: unreal time avancado, modal verbs deonticos, complex concession e noun phrases abstratas.	11	t	cbb0290c-5209-3fff-ad45-138642816a82	7	1	\N	\N	2026-05-18 11:23:48.736278	2026-05-22 05:34:47.542075
68226ec3-2d8e-3048-8b1d-7cdf66b00be5	Fruit 12 - C1 Synthesis & Capstone Communication	Sintese final: mini-palestra, painel, Q&A, relatorio, ensaio e reflexao metalinguistica. Foco em flexibilidade, precisao, autocorrecao, mediacao, fluencia e transferencia para estudo/trabalho.	12	t	cbb0290c-5209-3fff-ad45-138642816a82	7	1	\N	\N	2026-05-18 11:23:48.738441	2026-05-22 05:34:47.54471
3f18c5c2-3854-3789-85c6-65807a10eeb2	Harvest 02 - Dense Reading, Synthesis & Intertextuality	Leitura de textos densos, literarios, academicos, jornalisticos e tecnicos, conectando argumentos entre fontes. Gramatica: complex reference, ellipsis avancada, embedded clauses, nominal groups extensos e sintese intertextual.	2	t	427c0461-afc6-3d7b-9822-dab05b94137f	8	1	\N	\N	2026-05-18 11:23:48.747952	2026-05-22 05:34:47.556172
ccd9b00d-b1bf-3b6e-8563-63a423fa61b0	Harvest 03 - C2 Use of English: Idiom, Collocation & Transformation	Dominio de idioms raros, collocations especializadas, fixed phrases, complementation, word formation avancada e transformacoes complexas. Gramatica: advanced clause patterns, inversion, fronting, clefting e key-word transformations de alto nivel.	3	t	427c0461-afc6-3d7b-9822-dab05b94137f	8	1	\N	\N	2026-05-18 11:23:48.750382	2026-05-22 05:34:47.559062
9e7662d4-4aef-32b5-8176-331e77ee43c4	Harvest 04 - Literary, Rhetorical & Stylistic Analysis	Analise de estilo, voz, tom, ironia, simbolismo, ritmo, imagens e recursos retoricos. Gramatica: parallelism, antithesis, chiasmus, rhetorical questions, marked word order e linguagem figurativa sofisticada.	4	t	5d3582d1-ebd3-3286-84dd-ef8ecd42bbc0	8	1	\N	\N	2026-05-18 11:23:48.757503	2026-05-22 05:34:47.564729
b947782d-ae32-3c89-9b8e-67f83b812c5e	Harvest 05 - Expert Academic Argument & Literature Review	Revisao de literatura, construcao de lacuna academica, avaliacao critica de fontes e argumentacao disciplinar. Gramatica: cautious claims, concessive layering, citation stance, complex nominalization e metadiscourse academico.	5	t	5d3582d1-ebd3-3286-84dd-ef8ecd42bbc0	8	1	\N	\N	2026-05-18 11:23:48.759991	2026-05-22 05:34:47.567324
50a32d74-2d41-3c02-976c-986488b5368f	Harvest 06 - Specialist Professional Communication	Comunicacao em contextos especializados como legal, medico, tecnico, financeiro, diplomatico e executivo. Gramatica: genre-specific formulae, precision in obligation/liability, risk language, hedged recommendations e executive synthesis.	6	t	5d3582d1-ebd3-3286-84dd-ef8ecd42bbc0	8	1	\N	\N	2026-05-18 11:23:48.762359	2026-05-22 05:34:47.56968
4f2850c4-4dd5-37cf-9333-1c8cf6b32221	Harvest 07 - Advanced Mediation, Translation & Adaptation	Mediar ideias complexas entre publicos, resumir, adaptar registro, traduzir conceitos, explicar nuances culturais e tornar conteudo tecnico acessivel. Gramatica: paraphrase chains, register shift, condensation/expansion e equivalencia pragmatica.	7	t	780033ad-3379-37ee-b0bc-437155a5db35	8	1	\N	\N	2026-05-18 11:23:48.76824	2026-05-22 05:34:47.574592
5d4e0ea8-ee08-33cd-b6d3-5c104a91b3eb	Flower 11 - Lexical Sophistication & Word Formation	Precisao lexical, familias de palavras, prefixos/sufixos, falsos cognatos, conotacao/denotacao e intensificadores precisos. Gramatica: word formation, collocation patterns e lexical chunks.	11	t	4796550a-edd0-3c0c-a286-ba5c38712c1a	6	1	\N	\N	2026-05-18 11:23:48.702254	2026-05-22 05:34:47.495599
34b7f87a-b43a-319b-bb71-f02b2efdd59a	Flower 12 - B2 Integration: Extended Communication	Revisao B2 com fala extendida, ensaio, relatorio, debate, listening autentico e leitura analitica. Foco em fluencia, espontaneidade, complexidade controlada e autocorrecao.	12	t	4796550a-edd0-3c0c-a286-ba5c38712c1a	6	1	\N	\N	2026-05-18 11:23:48.703886	2026-05-22 05:34:47.498198
5de4db78-2575-3878-8955-c4217603380d	Fruit 01 - Nuance, Precision & Stance	Precisao lexical, distincao semantica, stance, implicacao e posicionamento sutil. Gramatica: advanced hedging, stance adverbs, litotes, understatement e escolha lexical estrategica.	1	t	bde7ca86-5bc5-31dc-818d-eb510b22e952	7	1	\N	\N	2026-05-18 11:23:48.709155	2026-05-22 05:34:47.506171
26362b86-b030-30ab-be07-086ab2e55f12	Fruit 02 - Advanced Discourse Structures	Organizacao de discurso longo, retomada, digressao, enfase e ritmo argumentativo. Gramatica: inversion, cleft/pseudo-cleft sentences, ellipsis, anaphora/cataphora e cohesion avancada.	2	t	bde7ca86-5bc5-31dc-818d-eb510b22e952	7	1	\N	\N	2026-05-18 11:23:48.710801	2026-05-22 05:34:47.508675
e7b2801e-2e78-3a16-8718-cd84f38c5d8e	Fruit 03 - Figurative, Idiomatic & Cultural Language	Idioms avancados, proverbios, metaforas, alusoes culturais, sarcasmo, humor seco e linguagem figurada em contexto. Foco em adequacao cultural e interpretacao de subtexto.	3	t	bde7ca86-5bc5-31dc-818d-eb510b22e952	7	1	\N	\N	2026-05-18 11:23:48.712478	2026-05-22 05:34:47.51126
fc4f39eb-5b57-3e80-9b74-adc8f963391d	Fruit 04 - Academic Language & Research Discourse	Pesquisa, metodologia, literatura, resultados, implicacoes e critica academica. Gramatica: complex nominalization, academic passive, citation language, synthesis e cautious claims.	4	t	c2b7d515-5091-3764-a4a9-697dd9d24285	7	1	\N	\N	2026-05-18 11:23:48.716527	2026-05-22 05:34:47.516784
5e270f9a-c31e-36f3-af15-c79fda4a551d	Fruit 05 - Authentic Listening: Lectures, Interviews & Talks	Compreensao de palestras, entrevistas, podcasts e debates naturais. Foco em connected speech, hesitation, self-correction, speaker attitude, inference e note-taking avancado.	5	t	c2b7d515-5091-3764-a4a9-697dd9d24285	7	1	\N	\N	2026-05-18 11:23:48.71858	2026-05-22 05:34:47.519645
38db3d39-3373-3fd0-9e1c-5f3cb8e06497	Fruit 06 - Sophisticated Argumentation & Critical Discourse	Argumentos complexos, falacias, premissas, inferencia, refutacao, concessao e debate formal. Gramatica: logical connectors, concessive clauses complexas, rhetorical questions e balanced evaluation.	6	t	c2b7d515-5091-3764-a4a9-697dd9d24285	7	1	\N	\N	2026-05-18 11:23:48.720244	2026-05-22 05:34:47.522277
fc56f943-c81c-3026-a38f-87ceabf57063	Fruit 07 - Advanced Writing: Essays, Reports & Proposals	Ensaios analiticos, relatorios, propostas, reviews e textos profissionais de alto impacto. Gramatica: sentence variety, cohesive devices, impersonal structures, editing e register control.	7	t	0bc55dac-e66e-3bff-bbb9-9412c3e6fd7a	7	1	\N	\N	2026-05-18 11:23:48.724979	2026-05-22 05:34:47.527542
c7145af1-be44-301d-b3cc-927f9a6fc884	Fruit 08 - Pronunciation, Fluency & Delivery	Pronuncia avancada, ritmo, entonacao, stress, pausing, emphasis, clarity e entrega oral. Foco em thought groups, contrastive stress, intonation for implication e spoken fluency.	8	t	0bc55dac-e66e-3bff-bbb9-9412c3e6fd7a	7	1	\N	\N	2026-05-18 11:23:48.727389	2026-05-22 05:34:47.530177
baad4c25-26bf-3608-9b19-8febb5cee1ea	Fruit 09 - Intercultural Communication & Global Englishes	Comunicacao intercultural, politeness strategies, estilos diretos/indiretos, face-saving, code-switching e variedades globais do ingles. Foco em mediacao e reparo intercultural.	9	t	0bc55dac-e66e-3bff-bbb9-9412c3e6fd7a	7	1	\N	\N	2026-05-18 11:23:48.7296	2026-05-22 05:34:47.532744
7590e229-9117-31ed-a5a5-d0379eb17d21	Harvest 09 - Advanced Listening: Accents, Speed & Implicit Meaning	Compreensao de fala rapida, sotaques variados, humor, subtexto, conflito, implicito, interrupcoes e sobreposicao de turnos. Foco em inferencia, attitude, discourse markers naturais e note-taking seletivo.	9	t	780033ad-3379-37ee-b0bc-437155a5db35	8	1	\N	\N	2026-05-18 11:23:48.772127	2026-05-22 05:34:47.579613
e4ab71cd-6d03-3ee1-924d-eb61242e97d8	Harvest 10 - Editorial, Policy & Public-Facing Writing	Escrita de editoriais, position papers, policy briefs, manifestos, discursos, comunicados e textos de influencia publica. Gramatica: rhetorical structuring, strategic repetition, cohesion across long texts e balanceamento de ethos, logos e pathos.	10	t	c745a5ac-a658-31a4-b5f9-8cf968a929c6	8	1	\N	\N	2026-05-18 11:23:48.776214	2026-05-22 05:34:47.585527
4b98969f-2e52-3948-ab75-4d202fca4868	Harvest 11 - Creativity, Humor & Voice	Uso criativo da lingua, humor, trocadilhos, storytelling autoral, estilo pessoal, imitacao de registros e escrita com voz distinta. Gramatica: deliberate rule-bending, rhythm, ambiguity, metaphor chains e register play.	11	t	c745a5ac-a658-31a4-b5f9-8cf968a929c6	8	1	\N	\N	2026-05-18 11:23:48.778579	2026-05-22 05:34:47.587952
6ae127e9-c6f1-30df-8d02-e7ec84793ef0	Harvest 12 - C2 Capstone: Mastery Portfolio & Real-World Performance	Projeto final de dominio C2: palestra longa, ensaio ou relatorio sofisticado, debate, mediacao de conteudo complexo e defesa oral. Foco em naturalidade, precisao, adaptabilidade, autoridade discursiva e avaliacao critica de performance.	12	t	c745a5ac-a658-31a4-b5f9-8cf968a929c6	8	1	\N	\N	2026-05-18 11:23:48.781543	2026-05-22 05:34:47.590794
a8266af0-d70c-3ff7-ae06-682698956039	Seed 01 - Greetings, Names & Classroom English	Saudacoes, despedidas, apresentacoes, soletrar nomes, pedir repeticao e usar frases de sala de aula. Gramatica: verb "to be", pronomes pessoais, perguntas curtas e respostas simples.	1	t	39249b18-1cf2-3736-8fe7-b17433d8f5c7	1	1	\N	\N	2026-05-18 11:23:48.401686	2026-05-22 05:34:47.198836
6e8d4df5-4c27-39a4-964b-13afbeb49c15	Root 12 - A2 Integration: Everyday Problem Solving	Revisao A2 com foco em resolver necessidades cotidianas: pedir informacao, explicar problemas, narrar eventos simples, fazer planos e escrever email/nota curta com clareza.	12	t	5f2425bf-f771-33d9-bb79-36a785c61e85	2	1	\N	\N	2026-05-18 11:23:48.473878	2026-05-22 05:34:47.30322
8f16d87e-0b5c-387d-8c57-898464912ddc	Branch 11 - Society, Customs & Social Etiquette	Costumes, normas sociais, diversidade, comportamento apropriado, mal-entendidos e etiqueta. Gramatica: comparativos avancados, passive cultural formulas, "used to" e linguagem de contraste cultural.	11	t	c4b0725f-cc8c-3f5a-865f-42ddb583f631	4	1	\N	\N	2026-05-18 11:23:48.583025	2026-05-22 05:34:47.402841
9af897b7-88f3-3440-8d56-db719d54dee5	Flower 06 - Negotiation, Persuasion & Conflict Resolution	Negociacao, persuasao, concessoes, prioridades, resolucao de conflito e linguagem diplomatica. Gramatica: conditional softeners, concession, counterargument language, proposals e turn-taking estrategico.	6	t	b2e05aa0-191e-356a-b7bb-8c2e6143563d	6	1	\N	\N	2026-05-18 11:23:48.687029	2026-05-22 05:34:47.475823
7562b42b-9477-356d-9e60-2169356ef806	Flower 10 - Global Issues & Public Discourse	Globalizacao, migracao, desigualdade, diplomacia, saude publica, economia e politica. Gramatica: complex clauses, passive in journalism, certainty/uncertainty language e argumentacao baseada em dados.	10	t	4796550a-edd0-3c0c-a286-ba5c38712c1a	6	1	\N	\N	2026-05-18 11:23:48.70019	2026-05-22 05:34:47.493037
3e1291b9-df91-390d-a83c-430511b37481	Harvest 01 - Near-Native Precision & Micro-Nuance	Dominio de diferencas minimas de sentido, implicatura, pressupostos, ambiguidade intencional e escolhas lexicais de alta precisao. Gramatica: subtle modality, stance stacking, advanced adverbials e reformulacao com mudanca fina de efeito.	1	t	427c0461-afc6-3d7b-9822-dab05b94137f	8	1	\N	\N	2026-05-18 11:23:48.745541	2026-05-22 05:34:47.55343
43edb84d-5251-37f4-b360-5458f5b9afad	Harvest 08 - High-Stakes Speaking & Spontaneous Eloquence	Fala improvisada em debates, entrevistas, paineis, Q&A, negociacoes e situacoes de pressao. Foco em fluencia espontanea, framing, pausing estrategico, repair elegante, emphasis e controle de interacao.	8	t	780033ad-3379-37ee-b0bc-437155a5db35	8	1	\N	\N	2026-05-18 11:23:48.770239	2026-05-22 05:34:47.577206
\.


--
-- Data for Name: meetings; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.meetings (id, title, description, teacher_id, skill_id, stage_id, scheduled_start, meeting_url, recording_url, status, created_at, updated_at, lesson_id, plan_id, meeting_type) FROM stdin;
95872a08-f1d1-4af4-a417-727b884465ab	English class	Weather and Seasons	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	1	1	2026-05-20 19:00:00	https://meet.google.com/slkdfao243523	\N	SCHEDULED	2026-05-20 16:51:51.594106	2026-05-20 16:51:51.594106	a8266af0-d70c-3ff7-ae06-682698956039	2	CONTENT
2d696c8d-4eb3-4391-ad9b-eb993b0d0a99	Speak more	Sea Animals	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	1	1	2026-05-21 19:00:00	https//meet.google.com/sdk9kd09	\N	SCHEDULED	2026-05-20 16:54:56.979857	2026-05-20 16:54:56.979857	a8266af0-d70c-3ff7-ae06-682698956039	2	PRACTICAL
56462987-0eba-42ee-9524-a93b2242c361	Midterm Test	Animals	fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	1	1	2026-05-18 20:00:00	https://meet.google.com/skero0w90	\N	COMPLETED	2026-05-20 16:58:10.887614	2026-05-20 16:58:10.887614	a8266af0-d70c-3ff7-ae06-682698956039	2	ASSESSMENT
\.


--
-- Data for Name: module_performance; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.module_performance (id, student_id, module_id, total_exercises, exercises_completed, average_score, time_spent_minutes, progress_percent, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: modules; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.modules (id, title, description, order_index, is_active, stage_id, skill_id, created_at, updated_at) FROM stdin;
ba3a7410-0671-370e-8ec5-4d792e37c90a	Leaf Module 1: Lessons 01-03	Leaf progression block covering lessons 01 to 03.	1	t	3	1	2026-05-18 11:23:48.487932	2026-05-22 05:34:47.310071
d15bc9d7-216b-32a6-ba04-45af94f6594e	Leaf Module 2: Lessons 04-06	Leaf progression block covering lessons 04 to 06.	2	t	3	1	2026-05-18 11:23:48.510334	2026-05-22 05:34:47.322197
d75dae5e-079e-36df-9379-7264c1fb2fd5	Flower Module 1: Lessons 01-03	Flower progression block covering lessons 01 to 03.	1	t	6	1	2026-05-18 11:23:48.672468	2026-05-22 05:34:47.459547
b2e05aa0-191e-356a-b7bb-8c2e6143563d	Flower Module 2: Lessons 04-06	Flower progression block covering lessons 04 to 06.	2	t	6	1	2026-05-18 11:23:48.681462	2026-05-22 05:34:47.468948
c745a5ac-a658-31a4-b5f9-8cf968a929c6	Harvest Module 4: Lessons 10-12	Harvest progression block covering lessons 10 to 12.	4	t	8	1	2026-05-18 11:23:48.773679	2026-05-22 05:34:47.583221
a4f3c09c-493e-3d08-a078-ca675a12de3d	Leaf Module 3: Lessons 07-09	Leaf progression block covering lessons 07 to 09.	3	t	3	1	2026-05-18 11:23:48.520684	2026-05-22 05:34:47.334949
47a3e3a0-6491-3de3-8c33-099ec6ff4411	Flower Module 3: Lessons 07-09	Flower progression block covering lessons 07 to 09.	3	t	6	1	2026-05-18 11:23:48.688613	2026-05-22 05:34:47.47857
c6e1a8f5-c259-317b-971a-17bb532f8fd5	Leaf Module 4: Lessons 10-12	Leaf progression block covering lessons 10 to 12.	4	t	3	1	2026-05-18 11:23:48.532344	2026-05-22 05:34:47.348565
4796550a-edd0-3c0c-a286-ba5c38712c1a	Flower Module 4: Lessons 10-12	Flower progression block covering lessons 10 to 12.	4	t	6	1	2026-05-18 11:23:48.69792	2026-05-22 05:34:47.490475
bde7ca86-5bc5-31dc-818d-eb510b22e952	Fruit Module 1: Lessons 01-03	Fruit progression block covering lessons 01 to 03.	1	t	7	1	2026-05-18 11:23:48.70755	2026-05-22 05:34:47.503632
39249b18-1cf2-3736-8fe7-b17433d8f5c7	Seed Module 1: Lessons 01-03	Seed progression block covering lessons 01 to 03.	1	t	1	1	2026-05-18 11:23:48.398562	2026-05-22 05:34:47.195173
7631815d-97aa-38ad-af94-0e081dc21cd5	Seed Module 2: Lessons 04-06	Seed progression block covering lessons 04 to 06.	2	t	1	1	2026-05-18 11:23:48.409174	2026-05-22 05:34:47.208649
42755161-bedb-384c-9d9e-8f0df993c98a	Seed Module 3: Lessons 07-09	Seed progression block covering lessons 07 to 09.	3	t	1	1	2026-05-18 11:23:48.419195	2026-05-22 05:34:47.222119
aa5d40a2-b02a-333a-88eb-608939a5a851	Seed Module 4: Lessons 10-12	Seed progression block covering lessons 10 to 12.	4	t	1	1	2026-05-18 11:23:48.429138	2026-05-22 05:34:47.235474
d2fffdc9-88cc-3b48-805a-2ea4309a30ed	Root Module 1: Lessons 01-03	Root progression block covering lessons 01 to 03.	1	t	2	1	2026-05-18 11:23:48.44025	2026-05-22 05:34:47.2558
51e6a8ab-c369-3b27-b2d0-ed7de47793b0	Root Module 2: Lessons 04-06	Root progression block covering lessons 04 to 06.	2	t	2	1	2026-05-18 11:23:48.447221	2026-05-22 05:34:47.268244
b84ab2f7-fdb9-3f8c-b032-97b5aea8044a	Root Module 3: Lessons 07-09	Root progression block covering lessons 07 to 09.	3	t	2	1	2026-05-18 11:23:48.455154	2026-05-22 05:34:47.280386
0457bb19-7f63-348c-873d-0334eb33801c	Branch Module 1: Lessons 01-03	Branch progression block covering lessons 01 to 03.	1	t	4	1	2026-05-18 11:23:48.546341	2026-05-22 05:34:47.364371
2fa59dc1-c018-311e-9e48-d9cdff283a67	Branch Module 2: Lessons 04-06	Branch progression block covering lessons 04 to 06.	2	t	4	1	2026-05-18 11:23:48.556557	2026-05-22 05:34:47.3753
45e2aed0-e189-3a57-b5e8-1844ed0749d5	Branch Module 3: Lessons 07-09	Branch progression block covering lessons 07 to 09.	3	t	4	1	2026-05-18 11:23:48.566495	2026-05-22 05:34:47.386093
c4b0725f-cc8c-3f5a-865f-42ddb583f631	Branch Module 4: Lessons 10-12	Branch progression block covering lessons 10 to 12.	4	t	4	1	2026-05-18 11:23:48.576442	2026-05-22 05:34:47.39807
8cbb3b58-c59b-3b77-808f-b408cdd84cac	Bud Module 1: Lessons 01-03	Bud progression block covering lessons 01 to 03.	1	t	5	1	2026-05-18 11:23:48.595165	2026-05-22 05:34:47.410968
64f4e506-7f9d-3fe7-a0b7-57d97e80136e	Bud Module 2: Lessons 04-06	Bud progression block covering lessons 04 to 06.	2	t	5	1	2026-05-18 11:23:48.604443	2026-05-22 05:34:47.42217
3c42f1fb-e16d-3ce2-b6f6-f8b01b069b46	Bud Module 3: Lessons 07-09	Bud progression block covering lessons 07 to 09.	3	t	5	1	2026-05-18 11:23:48.652168	2026-05-22 05:34:47.433035
ccc45760-67a8-3f1c-9a13-492f9e2ad00f	Bud Module 4: Lessons 10-12	Bud progression block covering lessons 10 to 12.	4	t	5	1	2026-05-18 11:23:48.661242	2026-05-22 05:34:47.445457
c2b7d515-5091-3764-a4a9-697dd9d24285	Fruit Module 2: Lessons 04-06	Fruit progression block covering lessons 04 to 06.	2	t	7	1	2026-05-18 11:23:48.714318	2026-05-22 05:34:47.514112
0bc55dac-e66e-3bff-bbb9-9412c3e6fd7a	Fruit Module 3: Lessons 07-09	Fruit progression block covering lessons 07 to 09.	3	t	7	1	2026-05-18 11:23:48.721929	2026-05-22 05:34:47.525024
cbb0290c-5209-3fff-ad45-138642816a82	Fruit Module 4: Lessons 10-12	Fruit progression block covering lessons 10 to 12.	4	t	7	1	2026-05-18 11:23:48.731806	2026-05-22 05:34:47.536843
427c0461-afc6-3d7b-9822-dab05b94137f	Harvest Module 1: Lessons 01-03	Harvest progression block covering lessons 01 to 03.	1	t	8	1	2026-05-18 11:23:48.743266	2026-05-22 05:34:47.550673
5d3582d1-ebd3-3286-84dd-ef8ecd42bbc0	Harvest Module 2: Lessons 04-06	Harvest progression block covering lessons 04 to 06.	2	t	8	1	2026-05-18 11:23:48.752789	2026-05-22 05:34:47.562192
780033ad-3379-37ee-b0bc-437155a5db35	Harvest Module 3: Lessons 07-09	Harvest progression block covering lessons 07 to 09.	3	t	8	1	2026-05-18 11:23:48.764711	2026-05-22 05:34:47.572301
5f2425bf-f771-33d9-bb79-36a785c61e85	Root Module 4: Lessons 10-12	Root progression block covering lessons 10 to 12.	4	t	2	1	2026-05-18 11:23:48.463418	2026-05-22 05:34:47.292895
\.


--
-- Data for Name: news_articles; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.news_articles (id, news_category_id, headline, summary, highlighted_article, source, published_at, content, created_at, updated_at) FROM stdin;
tecnologia-moon-gets-closer-to-the-earth	3	Moon gets closer to the Earth	Our aerial starts to get closer, but there is an explanation.	f	DumaNews Tech	21 May 2026	Xreal has always occupied a somewhat different niche in the smartglasses market. Rather than normal-looking glasses with some smart features, the company offers a more immersive AR experience that's particularly well-suited for entertainment. \n\nThat approach is very much the same with the company's Android XR-powered Project Aura. But after spending some time with the glasses at Google I/O, it's clear that Xreal is trying to do much, much more than make another pair of cinema glasses.	2026-05-22 05:42:02.558058	2026-05-22 05:42:02.558058
tecnologia-ai-tools	4	AI Study Tools Gain Attention as Students Seek Faster Daily Practice	New learning platforms are combining audio, reading, and revision into short study sessions.	t	DumaNews Tech	21 May 2026	Education technology platforms are gaining attention by combining audio lessons...	2026-05-22 05:34:21.313872	2026-05-22 05:47:11.951398
\.


--
-- Data for Name: news_categories; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.news_categories (id, name, sort_order, created_at, updated_at) FROM stdin;
1	Política	1	2026-05-22 05:34:21.313872	2026-05-22 05:34:21.313872
2	Economia	2	2026-05-22 05:34:21.313872	2026-05-22 05:34:21.313872
3	Tecnologia	3	2026-05-22 05:34:21.313872	2026-05-22 05:34:21.313872
5	Esportes	5	2026-05-22 05:34:21.313872	2026-05-22 05:34:21.313872
6	Geral	6	2026-05-22 05:34:21.313872	2026-05-22 05:34:21.313872
4	Ciência	4	2026-05-22 05:34:21.313872	2026-05-22 05:47:23.997976
\.


--
-- Data for Name: plan_resources; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.plan_resources (plan_id, resource_order, resource_text, resource_active) FROM stdin;
1	0	5 exercícios por dia	t
2	0	Exercícios ilimitados	t
\.


--
-- Data for Name: plans; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.plans (id, nome, preco, periodo, destaque, created_at, updated_at) FROM stdin;
1	Gratuito	R$ 0	FOREVER	f	2026-05-20 03:05:12.157965	2026-05-20 03:05:12.157965
2	Fast Trimestral	R$ 229,90	MONTHLY	f	2026-05-20 03:05:53.24139	2026-05-20 03:05:53.24139
\.


--
-- Data for Name: podcast_categories; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.podcast_categories (id, name, sort_order, created_at, updated_at) FROM stdin;
1	Contos	1	2026-05-21 16:40:39.277112	2026-05-21 16:40:39.277112
2	Ciências	2	2026-05-21 16:40:39.277112	2026-05-21 16:40:39.277112
3	História	3	2026-05-21 16:40:39.277112	2026-05-21 16:40:39.277112
4	Cultura	4	2026-05-21 16:40:39.277112	2026-05-21 16:40:39.277112
5	Conselhos	5	2026-05-21 16:40:39.277112	2026-05-21 16:40:39.277112
\.


--
-- Data for Name: podcasts; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.podcasts (id, title, podcast_category_id, cover_image_url, audio_url, duration_label, transcript, description, created_at, updated_at) FROM stdin;
contos-opening-connections	Opening Connections	1	https://cdn.seudominio.com/podcasts/opening-connections.jpg	https://cdn.seudominio.com/podcasts/opening-connections.wav	06:24	Opening\\nEmma: Hello! Good morning!...	Um diálogo leve para praticar apresentações e vocabulário cotidiano.	2026-05-21 16:40:39.277112	2026-05-21 16:40:39.277112
ciencias-how-learning-languages-changes-the-brain	How Learning Languages Changes the Brain	2	https://7816743d29a119ac46560b1cfb1f4895.r2.cloudflarestorage.com/duma-resources/2026/05/22/6094cef1-3a16-4f9c-b18a-fde406e159a4-sciencePodcast.png	https://7816743d29a119ac46560b1cfb1f4895.r2.cloudflarestorage.com/duma-resources/2026/05/22/7d1a3c2d-4130-49af-9dc4-f64dad734d24-podcast_episode-2-.wav	04:12	How Learning Languages Changes the Brain\n\nINTRO\n\nEmma:\nHey everyone, welcome back to Mind Sparks, the podcast where we explore amazing things about the human brain and learning.\n\nJake:\nAnd today’s topic is perfect for language lovers… or anyone trying to learn English right now.\n\nEmma:\nExactly! Today we’re talking about something fascinating:\n\nBoth:\nHow learning a new language changes your brain!\n\nPART 1 — YOUR BRAIN IS TRAINING\n\nJake:\nOkay Emma… serious question.\nWhen I study another language, why does my brain feel tired after twenty minutes?\n\nEmma:\nBecause your brain is working out!\n\nJake:\nSo… language learning is basically brain gym?\n\nEmma:\nPretty much, yes. Scientists say that learning a language is similar to physical exercise.\nWhen you train your body, your muscles grow stronger.\nWhen you learn a language, your brain creates and reorganizes neural connections.\n\nJake:\nThat actually sounds amazing.\n\nEmma:\nIt is! Researchers discovered that people who speak multiple languages process information differently from people who speak only one language.\n\nJake:\nSo the brain literally changes?\n\nEmma:\nYes — physically changes.\n\nPART 2 — WHAT HAPPENS INSIDE THE BRAIN?\n\nJake:\nOkay, now I’m curious.\nWhat exactly happens inside the brain when we learn another language?\n\nEmma:\nWell, several parts of the brain start working together.\n\nThere’s one system for hearing and producing sounds…\n\nAnd another system that helps us choose which language we’re using.\n\nJake:\nWait… so bilingual people are constantly switching systems?\n\nEmma:\nExactly. Their brains are constantly deciding:\n\n“Which language should I use right now?”\n\nJake:\nThat explains why bilingual people sometimes mix languages in one sentence.\n\nEmma:\nYes! That’s completely normal.\n\nScientists say areas like the auditory cortex help us process speech sounds, while motor areas control the mouth, tongue, and vocal cords.\n\nJake:\nSo even pronunciation changes the brain?\n\nEmma:\nAbsolutely.\n\nAnd there are special language regions too — like Broca’s area, which helps us build grammar and sentences.\n\nJake:\nAh yes… the enemy of every English learner.\n\nEmma:\n(Laughs) Grammar can be painful, yes.\n\nAnother important part is Wernicke’s area, which helps us understand vocabulary and remember words.\n\nPART 3 — THE BRAIN CAN REWIRE ITSELF\n\nJake:\nYou said the brain physically changes.\nThat sounds almost like science fiction.\n\nEmma:\nBut it’s real.\n\nScientists studied Syrian refugees learning German. They scanned their brains before and after learning the language.\n\nAnd guess what?\n\nThe brain connections changed as the learners improved.\n\nJake:\nThat’s incredible.\n\nEmma:\nThis process is called neuroplasticity.\n\nJake:\nBig word.\n\nEmma:\nVery big word.\nBut simple meaning: the brain can reorganize itself and adapt.\n\nJake:\nSo every new word I learn is basically building new roads inside my brain?\n\nEmma:\nExactly! That’s actually a perfect way to describe it.\n\nThe brain becomes better at memory, attention, sound recognition, and even mouth control for pronunciation.\n\nPART 4 — WHY CHILDREN LEARN FASTER\n\nJake:\nOkay… now explain something that has always made me jealous.\n\nWhy do children learn languages so fast?\n\nEmma:\nBecause children’s brains are still developing.\n\nYoung brains are more flexible and adaptable.\n\nAdults already have strong language patterns from their first language.\n\nJake:\nSo adults keep translating in their heads…\n\nEmma:\nExactly.\n\nChildren don’t usually translate. They absorb the language naturally.\n\nThat’s why kids often develop accents more easily too.\n\nJake:\nMeanwhile adults spend six months trying to pronounce “th.”\n\nEmma:\n(Laughs) Very true.\n\nPART 5 — DOES LEARNING LANGUAGES MAKE YOU SMARTER?\n\nJake:\nNow the important question…\n\nDo multilingual people become smarter?\n\nEmma:\nWell… maybe a little. But not exactly in the way people think.\n\nStudies show multilingual people often have stronger memory, attention, and problem-solving abilities.\n\nBut scientists still don’t know if languages directly increase intelligence.\n\nJake:\nSo speaking five languages doesn’t automatically make someone a genius?\n\nEmma:\nNope.\n\nBut it does increase mental flexibility and cognitive skills.\n\nAnd honestly… learning languages teaches patience, discipline, and communication too.\n\nJake:\nWhich are pretty valuable superpowers.\n\nFINAL MESSAGE\n\nEmma:\nSo today we learned that language learning is much more than memorizing vocabulary.\n\nIt actually reshapes the brain.\n\nJake:\nEvery new phrase, every conversation, every mistake…\n\nyour brain is adapting and growing.\n\nEmma:\nAnd maybe the best part is this:\n\nYou are never too old to learn.\n\nJake:\nExactly. Your brain can keep changing your whole life.\n\nEmma:\nThanks for listening to Mind Sparks!\n\nJake:\nAnd remember:\n\nEvery new language opens a new world inside your mind.\n\nSee you next time!	Great podcast to understand how our brain is affected by the language learning.	2026-05-22 01:35:47.810014	2026-05-22 01:47:47.060987
historia-the-arrival-of-the-portuguese-in-brazil	The Arrival of the Portuguese in Brazil	3	https://7816743d29a119ac46560b1cfb1f4895.r2.cloudflarestorage.com/duma-resources/2026/05/22/50149253-5812-4ddf-beba-662e33c7c2e2-historyPodcast.png	https://7816743d29a119ac46560b1cfb1f4895.r2.cloudflarestorage.com/duma-resources/2026/05/22/35f64790-9249-40a3-a804-22f173436ba1-historyBrazil.wav	03:14	The Arrival of the Portuguese in Brazil\nHosts: Sarah and Daniel\nStyle: Storytelling + educational conversation\nLanguage Level: Intermediate / Easy English\nINTRO\n\nSarah:\nHello everyone, and welcome back to History Around the World.\n\nDaniel:\nThe podcast where we travel through time and discover the events that changed our planet.\n\nSarah:\nAnd today, we are going to South America…\n\nDaniel:\nTo talk about one of the most important moments in Brazilian history:\n\nBoth:\nThe arrival of the Portuguese in Brazil!\n\nPART 1 — THE YEAR 1500\n\nSarah:\nLet’s go back more than 500 years… to the year 1500.\n\nAt that time, Portugal was one of the strongest naval powers in Europe.\n\nDaniel:\nThe Portuguese were exploring the oceans, searching for new trade routes, spices, gold, and opportunities.\n\nSarah:\nExactly. Europe was in the middle of the Age of Exploration.\n\nCountries like Portugal and Spain wanted wealth, power, and control over new lands.\n\nDaniel:\nAnd that’s when a Portuguese fleet led by Pedro Álvares Cabral left Portugal with thirteen ships.\n\nSarah:\nThe official destination was India.\n\nBut during the journey across the Atlantic Ocean, something unexpected happened.\n\nPART 2 — LAND IN SIGHT!\n\nDaniel:\nOn April 22nd, 1500, the sailors saw land.\n\nA large green coast appeared on the horizon.\n\nSarah:\nCabral and his crew had arrived in what is now Brazil.\n\nAt first, they believed it might be an island.\n\nThey called the place “Ilha de Vera Cruz,” which means “Island of the True Cross.”\n\nDaniel:\nLater, the land became known as “Terra de Santa Cruz”…\n\nAnd eventually, Brazil.\n\nSarah:\nThe name “Brazil” came from a tree called pau-brasil.\n\nThis tree produced a valuable red dye that Europeans loved at the time.\n\nPART 3 — THE FIRST CONTACT\n\nDaniel:\nBut the Portuguese were not the first people there.\n\nMillions of Indigenous people already lived across the land.\n\nSarah:\nExactly. Different Indigenous groups had lived in Brazil for thousands of years before the Europeans arrived.\n\nThey had their own languages, traditions, beliefs, and ways of life.\n\nDaniel:\nThe first meetings between the Portuguese and Indigenous people were peaceful.\n\nThe Portuguese were curious about the native people…\n\nAnd the Indigenous communities were curious about the strange visitors arriving in giant wooden ships.\n\nSarah:\nHistorical reports describe exchanges of gifts, objects, food, and gestures.\n\nBut over time, this relationship became more complicated and often violent.\n\nPART 4 — WHY BRAZIL BECAME IMPORTANT\n\nDaniel:\nAt first, Portugal didn’t pay much attention to Brazil.\n\nTheir main focus was still trade with India and Asia.\n\nSarah:\nBut soon, the Portuguese realized Brazil had valuable natural resources.\n\nEspecially pau-brasil wood.\n\nDaniel:\nThen came sugar plantations…\n\nAnd later, gold and diamonds.\n\nSarah:\nBrazil slowly became one of Portugal’s most important colonies.\n\nBut colonization also brought terrible consequences.\n\nDaniel:\nYes. Indigenous populations suffered from violence, forced labor, and diseases brought by Europeans.\n\nMillions of Africans were also brought to Brazil through slavery.\n\nSarah:\nThese painful events became part of Brazil’s history and deeply shaped Brazilian society and culture.\n\nPART 5 — THE LEGACY\n\nDaniel:\nToday, the arrival of the Portuguese is remembered as a turning point in Brazilian history.\n\nSarah:\nIt marked the beginning of colonization, cultural mixing, economic change, and centuries of transformation.\n\nDaniel:\nModern Brazil became a combination of Indigenous, African, and European influences.\n\nAnd you can still see those influences today in Brazilian language, food, music, religion, and traditions.\n\nFINAL MESSAGE\n\nSarah:\nHistory is never simple.\n\nThe arrival of the Portuguese brought exploration and cultural exchange…\n\nBut also conflict, colonization, and suffering.\n\nDaniel:\nUnderstanding these events helps us better understand Brazil today.\n\nSarah:\nThank you for joining us on History Around the World.\n\nDaniel:\nAnd remember:\n\nEvery country has a story — and every story shapes the future.	Discover how happened the arrival of the portuguese settlers in Brazil	2026-05-22 01:55:40.433906	2026-05-22 01:55:56.925124
contos-the-ugly-duckling	The Ugly Duckling	1	https://7816743d29a119ac46560b1cfb1f4895.r2.cloudflarestorage.com/duma-resources/2026/05/22/3ef696e0-43fe-4d0f-b789-5fa7fccdd512-uglyduckling.png	https://7816743d29a119ac46560b1cfb1f4895.r2.cloudflarestorage.com/duma-resources/2026/05/22/10b90888-1aa6-43a1-bad5-22544b73f2aa-theuglyduckling.wav	06:13	The Ugly Duckling\n\n.....\n\nEpisode 1 — The Egg That Was Different\n\nOne warm summer day, a mother duck sat on her nest near a quiet pond.\nShe waited for her eggs to hatch.\n\n“Quack, quack… hurry up, little ones,” she said softly.\n\nOne by one, the eggs began to crack.\n\nPop!\nPop!\nPop!\n\nSmall yellow ducklings came out of the eggs. They were cute and fluffy.\n\nBut one egg was still very big and still closed.\n\nThe mother duck looked at it.\n\n“That is a very large egg,” she said. “I wonder what is inside.”\n\nFinally…\n\nCRACK!\n\nA big gray duckling came out.\n\nHe was larger than the others.\nHe was not yellow.\nHe was not fluffy.\n\nThe other ducklings looked at him.\n\n“He looks strange,” one said.\n\n“Yes,” said another. “He is ugly.”\n\nThe little gray duckling felt sad, but he said nothing.\n\nThe next day, the mother duck took all her children to the pond.\n\n“Jump in!” she said.\n\nSplash!\n\nAll the ducklings swam happily in the water.\n\nThe gray duckling swam too.\n\nAnd he swam very well.\n\n“He may look different,” said the mother duck, “but he is still my child.”\n\nBut the other animals laughed at him.\n\n“You are too big!”\n\n“You are too gray!”\n\n“You are ugly!”\n\nEvery day, the poor duckling heard cruel words.\n\nSoon, he felt lonely and unhappy.\n\nOne cold morning, he decided to leave.\n\n“I will go somewhere far away,” he whispered.\n\nAnd slowly, sadly, the ugly duckling walked away from the farm.\n\nEpisode 2 — Alone in the World\n\nThe ugly duckling walked through fields and forests.\n\nThe wind was cold.\n\nThe nights were dark.\n\nHe was tired and hungry.\n\nAt last, he found a small house.\n\nAn old woman lived there with a cat and a chicken.\n\n“You may stay here,” the woman said kindly.\n\nThe duckling was happy at first.\n\nBut the cat laughed at him.\n\n“Can you catch mice?” asked the cat.\n\n“No,” said the duckling.\n\nThe chicken laughed too.\n\n“Can you lay eggs?” she asked.\n\n“No,” he answered quietly.\n\n“Then you are useless,” said the chicken.\n\nAgain, the duckling felt sad.\n\nOne day, he looked outside and saw birds flying across the sky.\n\nThey were large and white, with long necks and beautiful wings.\n\nSwans.\n\nThe duckling watched them carefully.\n\n“Oh…” he whispered. “They are beautiful.”\n\nSomething strange moved inside his heart.\n\nHe wanted to follow them.\n\nBut he was afraid.\n\nWinter came.\n\nSnow covered the ground.\n\nThe pond became ice.\n\nThe duckling was very cold and very weak.\n\nOne night, he lay beside the frozen water and closed his eyes.\n\n“I think this is the end,” he said softly.\n\nBut the next morning, a farmer found him and carried him home.\n\nThe farmer’s children tried to help him.\n\nBut the duckling became frightened and ran away again into the cold winter night.\n\nEpisode 3 — The Beautiful Swan\n\nAt last, winter ended.\n\nSpring arrived.\n\nThe sun became warm again.\n\nFlowers opened in the fields.\n\nThe ugly duckling had grown bigger and stronger.\n\nOne morning, he saw the beautiful swans again on a clear blue lake.\n\nHis heart beat fast.\n\n“I know they are beautiful,” he said sadly. “But they will laugh at me too.”\n\nStill, he moved closer to the water.\n\nThe swans looked at him quietly.\n\nThe duckling lowered his head.\n\n“Please do not hurt me,” he whispered.\n\nThen he looked down into the water.\n\nAnd he stopped.\n\nThe reflection in the lake was not a gray ugly bird anymore.\n\nIt was a beautiful white swan.\n\nThe duckling could not believe his eyes.\n\n“I… I am like them?”\n\nThe swans swam around him happily.\n\n“Welcome,” they said.\n\nChildren near the lake pointed at him.\n\n“Look!” they cried. “The new swan is the most beautiful of all!”\n\nFor the first time in his life, the young swan felt truly happy.\n\nHe spread his great white wings and lifted his head proudly toward the bright spring sky.\n\nAnd at last, he knew:\n\nHe had never been ugly at all.\n\nFinal Message\n\nSometimes people laugh at others because they are different.\n\nBut being different is not bad.\n\nEveryone grows in their own time.\n\nAnd sometimes, the person who feels strange or alone becomes something wonderful.	Learn english with famous stories.	2026-05-22 02:00:39.141436	2026-05-22 02:00:39.141436
\.


--
-- Data for Name: resource_categories; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.resource_categories (id, name, created_at, updated_at) FROM stdin;
1	Classes	2026-05-22 02:47:35.630185	2026-05-22 02:47:35.630185
\.


--
-- Data for Name: resources; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.resources (id, title, skill_id, stage_id, lesson_id, url, media_type, resource_category_id, created_at, updated_at, file_id) FROM stdin;
1	Lesson 07 - Part 01	1	1	a8266af0-d70c-3ff7-ae06-682698956039	https://player.cloudinary.com/embed/?cloud_name=drhybgfng&public_id=root-lesson7-2026-03-18_19.55.15_cv8hls	VIDEO	1	2026-05-22 02:52:25.395757	2026-05-22 02:56:25.921481	\N
2	Lesson 01 - Recommendations	1	1	eeb93412-e1bc-3294-8396-37a04e49bdc1	https://player.cloudinary.com/embed/?cloud_name=drhybgfng&public_id=leaf-lesson01-2026-02-20_00.05.18_eblcbb	VIDEO	1	2026-05-22 02:53:49.007729	2026-05-22 02:56:41.0905	\N
\.


--
-- Data for Name: skill_categories; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.skill_categories (id, name, description, created_at, updated_at) FROM stdin;
2	Lógica	Estudos lógico-matemáticos	2026-05-20 02:58:21.885848	2026-05-20 02:58:21.885848
1	English	English language learning skills	2026-05-18 11:23:48.38306	2026-05-22 05:34:47.167991
\.


--
-- Data for Name: skills; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.skills (id, name, slug, short_description, full_description, category_id, icon_url, is_active, created_at, updated_at) FROM stdin;
2	Matemática	matematica	Metódo Duma aplicado à Matemática		2		t	2026-05-20 02:59:59.775946	2026-05-20 02:59:59.775946
1	SpeakUp English	speakup-english	Curso progressivo de ingles A1 a C2	Grade completa SpeakUp com progressao CEFR de Seed a Harvest.	1		t	2026-05-18 11:23:48.389489	2026-05-22 05:34:47.178179
\.


--
-- Data for Name: stages; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.stages (id, name, slug, short_description, full_description, icon_url, color, order_index, is_active, created_at, updated_at, skill_id) FROM stdin;
2	Root	root	A1+ a A2	# Root - A1+ a A2\n\n## Module 1: Lessons 01-03\n\n- Lesson 01 | Shopping, Money & Quantities: Compras, precos, tamanhos, medidas, embalagem, formas de pagamento e trocas simples. Gramatica: quantifiers, demonstratives, comparativos basicos, "How much/How many" e pedidos educados.\n- Lesson 02 | Travel, Transport & Accommodation: Transporte, viagens, hospedagem, horarios, bilhetes, reservas e informacoes turisticas. Gramatica: preposicoes de movimento, "going to", perguntas indiretas simples e leitura de avisos/horarios.\n- Lesson 03 | Past Events & Life Stories: Experiencias passadas, memorias, biografia simples e eventos pessoais. Gramatica: Past Simple regular/irregular, "was/were", expressoes de tempo passado e narrativa curta em sequencia.\n\n## Module 2: Lessons 04-06\n\n- Lesson 04 | Restaurants, Cooking & Service Encounters: Restaurante, cardapio, pedidos, preferencias alimentares, formas de preparo e problemas no atendimento. Gramatica: "would like", "could/can I", countable/uncountable em contexto e linguagem de reclamacao simples.\n- Lesson 05 | Education, Study & Learning Habits: Escola, materias, tarefas, cursos, habilidades de estudo e objetivos de aprendizagem. Gramatica: Present Simple vs Present Continuous, "good at/interested in", infinitive of purpose e linguagem de instrucao.\n- Lesson 06 | Describing People, Personality & Relationships: Aparencia, personalidade, relacoes sociais e comparacoes entre pessoas. Gramatica: comparative/superlative adjectives, modifiers simples e adjetivos com preposicao.\n\n## Module 3: Lessons 07-09\n\n- Lesson 07 | Home, Neighbourhood & Services: Moradia, bairro, servicos locais, problemas domesticos e convivencia. Gramatica: "there was/were", preposicoes mais amplas, "need to/have to" e pedidos de manutencao.\n- Lesson 08 | Technology, Communication & Online Basics: Celular, computador, internet, mensagens, emails simples, apps e seguranca digital basica. Gramatica: imperatives para instrucoes, "can/could", object pronouns e sequenciadores simples.\n- Lesson 09 | Work, Jobs & Daily Responsibilities: Profissoes, local de trabalho, tarefas, horarios, responsabilidades e entrevistas simples. Gramatica: "What do you do?", "have to/don't have to", adverbios de frequencia e perguntas de rotina profissional.\n\n## Module 4: Lessons 10-12\n\n- Lesson 10 | Sports, Entertainment & Events: Esportes, atividades culturais, eventos, ingressos, convites e combinacoes sociais. Gramatica: "would you like to", "shall", "let's", "going to" para planos e aceitar/recusar convites.\n- Lesson 11 | Nature, Animals & Environment Basics: Natureza, animais, paisagens, clima extremo e habitos ambientais simples. Gramatica: comparativos, "should/shouldn't", Zero Conditional inicial e linguagem de causa simples.\n- Lesson 12 | A2 Integration: Everyday Problem Solving: Revisao A2 com foco em resolver necessidades cotidianas: pedir informacao, explicar problemas, narrar eventos simples, fazer planos e escrever email/nota curta com clareza.	\N	\N	2	t	2026-05-18 11:23:48.437615	2026-05-22 05:34:47.250165	1
4	Branch	branch	B1	# Branch - B1\n\n## Module 1: Lessons 01-03\n\n- Lesson 01 | Habits, Lifestyles & Stative Verbs: Habitos, estilo de vida, tendencias pessoais e mudancas em andamento. Gramatica: Present Simple vs Present Continuous, stative verbs, frequency adverbs avancados e "tend to".\n- Lesson 02 | Narrative Tenses & Personal Anecdotes: Narrativas pessoais mais longas, incidentes, viagens e experiencias marcantes. Gramatica: Past Simple, Past Continuous, Past Perfect, sequenciadores e expressao de surpresa/contraste.\n- Lesson 03 | Future Forms & Arrangements: Planos, decisoes, previsoes, agendas e combinacoes. Gramatica: "will", "going to", Present Continuous futuro, "be about to", "likely/unlikely" e graus de certeza.\n\n## Module 2: Lessons 04-06\n\n- Lesson 04 | Travel, Culture Shock & Practical Survival: Viagens, aeroportos, hospedagem, costumes, problemas em outro pais e negociacao de sentido. Gramatica: indirect questions, polite requests, reported instructions e vocabulario intercultural basico.\n- Lesson 05 | Problems, Solutions & Decision Making: Problemas cotidianos, alternativas, consequencias, prioridades e tomada de decisao. Gramatica: modals of obligation/necessity, "managed to/failed to", gerunds/infinitives e conectores de causa/resultado.\n- Lesson 06 | Preferences, Taste & Consumer Choices: Preferencias, consumo, avaliacoes de produtos, lazer e escolhas pessoais. Gramatica: verb patterns, "would rather/prefer", gradable adjectives, intensifiers e linguagem de reviews.\n\n## Module 3: Lessons 07-09\n\n- Lesson 07 | Health, Wellbeing & Lifestyle Advice: Saude fisica/mental, sintomas, habitos, dieta, sono, estresse e consulta medica. Gramatica: Present Perfect Continuous, advice modals, "for/since", "I've been feeling..." e collocations de saude.\n- Lesson 08 | Work, Careers & Professional Communication: Carreira, curriculo, entrevistas, ambiente corporativo, emails e reunioes simples. Gramatica: Present Perfect para experiencia, formal register inicial, polite requests e reported speech basico.\n- Lesson 09 | Media, News & Digital Literacy: Noticias, manchetes, redes sociais, fontes, opiniao, vies e checagem de informacao. Gramatica: passive voice, reporting verbs, "it is said/reported", discurso indireto inicial e leitura critica.\n\n## Module 4: Lessons 10-12\n\n- Lesson 10 | Environment, Sustainability & Science Basics: Sustentabilidade, energia, clima, poluicao, biodiversidade e acoes ambientais. Gramatica: Zero/First Conditional, "should/ought to", cause-effect language e linguagem de dados simples.\n- Lesson 11 | Society, Customs & Social Etiquette: Costumes, normas sociais, diversidade, comportamento apropriado, mal-entendidos e etiqueta. Gramatica: comparativos avancados, passive cultural formulas, "used to" e linguagem de contraste cultural.\n- Lesson 12 | B1 Integration: Real Conversations & Writing: Revisao B1 com conversas extendidas, emails, mensagens, narrativas, opinioes e resolucao de problemas. Foco em coesao, turn-taking, question tags iniciais e pronuncia de word/sentence stress.	\N	\N	4	t	2026-05-18 11:23:48.543611	2026-05-22 05:34:47.360849	1
5	Bud	bud	B1+ a B2 Inicial	# Bud - B1+ a B2 Inicial\n\n## Module 1: Lessons 01-03\n\n- Lesson 01 | Advanced Conditionals & Consequences: Condicoes reais, hipoteticas e impossiveis em decisoes pessoais, trabalho e sociedade. Gramatica: First, Second, Third Conditional, "unless/as long as/provided that" e introducao a mixed conditionals.\n- Lesson 02 | Reported Speech & Reporting Verbs: Reportar falas, perguntas, pedidos, promessas, sugestoes e reclamacoes. Gramatica: backshift, reported questions, reporting verbs com infinitive/gerund/that-clause e mudancas de tempo/lugar.\n- Lesson 03 | Advanced Passive & Process Description: Processos, invencoes, noticias, ciencia, producao e procedimentos. Gramatica: passive em varios tempos, passive with modals, get passive, impersonal passive e escolha ativo/passivo.\n\n## Module 2: Lessons 04-06\n\n- Lesson 04 | Relative Clauses & Information Control: Definir, especificar e adicionar informacao sobre pessoas, objetos, lugares e ideias. Gramatica: defining/non-defining relative clauses, "whose", omission, reduced relative clauses iniciais.\n- Lesson 05 | Emotions, Attitudes & Nuanced Description: Emocoes, sentimentos complexos, reacoes, personalidade e atitudes. Gramatica: adjective + preposition, -ed/-ing adjectives, intensifiers, gradable/non-gradable adjectives e collocations emocionais.\n- Lesson 06 | Argumentation, Debate & Discourse Markers: Debates, opinioes estruturadas, concessao, contra-argumento e evidencia. Gramatica: discourse markers, hedging, concession clauses, "although/despite/in spite of" e paragrafo argumentativo.\n\n## Module 3: Lessons 07-09\n\n- Lesson 07 | Processes, Instructions & Technical Language: Processos, manuais, instrucoes formais, seguranca, ferramentas e procedimentos. Gramatica: sequencing language, passive, gerunds as subjects, noun phrases e linguagem impessoal.\n- Lesson 08 | Speculation, Deduction & Hypothesis: Deduzir, especular, interpretar evidencias e discutir possibilidades. Gramatica: modals of deduction present/past, "must/might/could/can't have", "looks as if", "I wonder if".\n- Lesson 09 | Formal Writing, Emails & Professional Etiquette: Emails formais, cartas, solicitacoes, desculpas, follow-up e comunicacao profissional. Gramatica: formal register, nominalization inicial, indirect language, punctuation e paragraphing.\n\n## Module 4: Lessons 10-12\n\n- Lesson 10 | Technology, Society & Change Over Time: Tecnologia, privacidade, automacao, IA, redes sociais e impacto social. Gramatica: Present Perfect Continuous, "used to/would", cause-effect connectors e linguagem de tendencia.\n- Lesson 11 | Abstract Topics & Critical Thinking: Educacao, felicidade, liberdade, desigualdade, justica e valores. Gramatica: abstract nouns, nominalization, advanced opinion phrases, "one might argue" e desenvolvimento de ideias abstratas.\n- Lesson 12 | B2 Entry Integration: Presentations & Discussion: Revisao com apresentacoes curtas, debates, emails formais, leitura critica e listening semi-autentico. Foco em coesao, pronuncia para apresentacao, reparo e manejo de interacao.	\N	\N	5	t	2026-05-18 11:23:48.588911	2026-05-22 05:34:47.407765	1
6	Flower	flower	B2	# Flower - B2\n\n## Module 1: Lessons 01-03\n\n- Lesson 01 | Complex Grammar in Context: Uso integrado de estruturas complexas em comunicacao natural. Gramatica: mixed conditionals, unreal time, advanced modals, cleft sentences iniciais e correcao de erros fossilizados.\n- Lesson 02 | Discourse, Cohesion & Text Flow: Coesao, coerencia, organizacao de texto, referencia e progressao de ideias. Gramatica: substitution, ellipsis inicial, reference devices, connectors avancados, hedging/boosting e topic sentences.\n- Lesson 03 | Idioms, Collocations & Phrasal Verbs: Expressao idiomatica, collocations fortes, phrasal verbs menos transparentes e registro coloquial/profissional. Gramatica: word order in phrasal verbs, fixed expressions e conotacao.\n\n## Module 2: Lessons 04-06\n\n- Lesson 04 | Academic & Professional Writing: Ensaios, relatorios, propostas, reviews e escrita profissional. Gramatica: nominalization, passive formal, hedging academico, paragraph structure, linking devices e citacao/parafrase.\n- Lesson 05 | Complex Listening & Inference: Listening autentico, inferencia, tom, atitude, implicito, ironia e fala conectada. Foco em reduced forms, discourse markers naturais, gist/detail e tomada de notas.\n- Lesson 06 | Negotiation, Persuasion & Conflict Resolution: Negociacao, persuasao, concessoes, prioridades, resolucao de conflito e linguagem diplomatica. Gramatica: conditional softeners, concession, counterargument language, proposals e turn-taking estrategico.\n\n## Module 3: Lessons 07-09\n\n- Lesson 07 | Advanced Storytelling & Narrative Voice: Narrativa avancada, ponto de vista, ritmo, tensao, flashback e descricao sensorial. Gramatica: full narrative tenses, past perfect continuous, participle clauses iniciais e estilo direto/indireto.\n- Lesson 08 | Critical Reading & Text Analysis: Analise de textos autenticos, argumento, vies, pressupostos, evidencia e avaliacao. Gramatica: stance markers, contrast structures, reporting language e linguagem de critica.\n- Lesson 09 | Register, Varieties & Sociolinguistics: Variacao de registro, formalidade, slang, jargon, texting, ingles americano/britanico e adequacao social. Gramatica: register shifting, pragmatics, politeness e reformulacao por audiencia.\n\n## Module 4: Lessons 10-12\n\n- Lesson 10 | Global Issues & Public Discourse: Globalizacao, migracao, desigualdade, diplomacia, saude publica, economia e politica. Gramatica: complex clauses, passive in journalism, certainty/uncertainty language e argumentacao baseada em dados.\n- Lesson 11 | Lexical Sophistication & Word Formation: Precisao lexical, familias de palavras, prefixos/sufixos, falsos cognatos, conotacao/denotacao e intensificadores precisos. Gramatica: word formation, collocation patterns e lexical chunks.\n- Lesson 12 | B2 Integration: Extended Communication: Revisao B2 com fala extendida, ensaio, relatorio, debate, listening autentico e leitura analitica. Foco em fluencia, espontaneidade, complexidade controlada e autocorrecao.	\N	\N	6	t	2026-05-18 11:23:48.669621	2026-05-22 05:34:47.45629	1
7	Fruit	fruit	C1 Proficiency	# Fruit - C1 Proficiency\n\n## Module 1: Lessons 01-03\n\n- Lesson 01 | Nuance, Precision & Stance: Precisao lexical, distincao semantica, stance, implicacao e posicionamento sutil. Gramatica: advanced hedging, stance adverbs, litotes, understatement e escolha lexical estrategica.\n- Lesson 02 | Advanced Discourse Structures: Organizacao de discurso longo, retomada, digressao, enfase e ritmo argumentativo. Gramatica: inversion, cleft/pseudo-cleft sentences, ellipsis, anaphora/cataphora e cohesion avancada.\n- Lesson 03 | Figurative, Idiomatic & Cultural Language: Idioms avancados, proverbios, metaforas, alusoes culturais, sarcasmo, humor seco e linguagem figurada em contexto. Foco em adequacao cultural e interpretacao de subtexto.\n\n## Module 2: Lessons 04-06\n\n- Lesson 04 | Academic Language & Research Discourse: Pesquisa, metodologia, literatura, resultados, implicacoes e critica academica. Gramatica: complex nominalization, academic passive, citation language, synthesis e cautious claims.\n- Lesson 05 | Authentic Listening: Lectures, Interviews & Talks: Compreensao de palestras, entrevistas, podcasts e debates naturais. Foco em connected speech, hesitation, self-correction, speaker attitude, inference e note-taking avancado.\n- Lesson 06 | Sophisticated Argumentation & Critical Discourse: Argumentos complexos, falacias, premissas, inferencia, refutacao, concessao e debate formal. Gramatica: logical connectors, concessive clauses complexas, rhetorical questions e balanced evaluation.\n\n## Module 3: Lessons 07-09\n\n- Lesson 07 | Advanced Writing: Essays, Reports & Proposals: Ensaios analiticos, relatorios, propostas, reviews e textos profissionais de alto impacto. Gramatica: sentence variety, cohesive devices, impersonal structures, editing e register control.\n- Lesson 08 | Pronunciation, Fluency & Delivery: Pronuncia avancada, ritmo, entonacao, stress, pausing, emphasis, clarity e entrega oral. Foco em thought groups, contrastive stress, intonation for implication e spoken fluency.\n- Lesson 09 | Intercultural Communication & Global Englishes: Comunicacao intercultural, politeness strategies, estilos diretos/indiretos, face-saving, code-switching e variedades globais do ingles. Foco em mediacao e reparo intercultural.\n\n## Module 4: Lessons 10-12\n\n- Lesson 10 | Power, Leadership & Influence: Linguagem de lideranca, persuasao, autoridade, inclusao, storytelling publico e tomada de decisao. Gramatica: rhetorical devices, parallelism, anaphora, abstraction e certainty management.\n- Lesson 11 | Philosophy, Ethics & Abstract Debate: Etica, filosofia, dilemas, valores, justica, liberdade e questoes abstratas. Gramatica: unreal time avancado, modal verbs deonticos, complex concession e noun phrases abstratas.\n- Lesson 12 | C1 Synthesis & Capstone Communication: Sintese final: mini-palestra, painel, Q&A, relatorio, ensaio e reflexao metalinguistica. Foco em flexibilidade, precisao, autocorrecao, mediacao, fluencia e transferencia para estudo/trabalho.	\N	\N	7	t	2026-05-18 11:23:48.70552	2026-05-22 05:34:47.500781	1
8	Harvest	harvest	C2 Mastery	# Harvest - C2 Mastery\n\n## Module 1: Lessons 01-03\n\n- Lesson 01 | Near-Native Precision & Micro-Nuance: Dominio de diferencas minimas de sentido, implicatura, pressupostos, ambiguidade intencional e escolhas lexicais de alta precisao. Gramatica: subtle modality, stance stacking, advanced adverbials e reformulacao com mudanca fina de efeito.\n- Lesson 02 | Dense Reading, Synthesis & Intertextuality: Leitura de textos densos, literarios, academicos, jornalisticos e tecnicos, conectando argumentos entre fontes. Gramatica: complex reference, ellipsis avancada, embedded clauses, nominal groups extensos e sintese intertextual.\n- Lesson 03 | C2 Use of English: Idiom, Collocation & Transformation: Dominio de idioms raros, collocations especializadas, fixed phrases, complementation, word formation avancada e transformacoes complexas. Gramatica: advanced clause patterns, inversion, fronting, clefting e key-word transformations de alto nivel.\n\n## Module 2: Lessons 04-06\n\n- Lesson 04 | Literary, Rhetorical & Stylistic Analysis: Analise de estilo, voz, tom, ironia, simbolismo, ritmo, imagens e recursos retoricos. Gramatica: parallelism, antithesis, chiasmus, rhetorical questions, marked word order e linguagem figurativa sofisticada.\n- Lesson 05 | Expert Academic Argument & Literature Review: Revisao de literatura, construcao de lacuna academica, avaliacao critica de fontes e argumentacao disciplinar. Gramatica: cautious claims, concessive layering, citation stance, complex nominalization e metadiscourse academico.\n- Lesson 06 | Specialist Professional Communication: Comunicacao em contextos especializados como legal, medico, tecnico, financeiro, diplomatico e executivo. Gramatica: genre-specific formulae, precision in obligation/liability, risk language, hedged recommendations e executive synthesis.\n\n## Module 3: Lessons 07-09\n\n- Lesson 07 | Advanced Mediation, Translation & Adaptation: Mediar ideias complexas entre publicos, resumir, adaptar registro, traduzir conceitos, explicar nuances culturais e tornar conteudo tecnico acessivel. Gramatica: paraphrase chains, register shift, condensation/expansion e equivalencia pragmatica.\n- Lesson 08 | High-Stakes Speaking & Spontaneous Eloquence: Fala improvisada em debates, entrevistas, paineis, Q&A, negociacoes e situacoes de pressao. Foco em fluencia espontanea, framing, pausing estrategico, repair elegante, emphasis e controle de interacao.\n- Lesson 09 | Advanced Listening: Accents, Speed & Implicit Meaning: Compreensao de fala rapida, sotaques variados, humor, subtexto, conflito, implicito, interrupcoes e sobreposicao de turnos. Foco em inferencia, attitude, discourse markers naturais e note-taking seletivo.\n\n## Module 4: Lessons 10-12\n\n- Lesson 10 | Editorial, Policy & Public-Facing Writing: Escrita de editoriais, position papers, policy briefs, manifestos, discursos, comunicados e textos de influencia publica. Gramatica: rhetorical structuring, strategic repetition, cohesion across long texts e balanceamento de ethos, logos e pathos.\n- Lesson 11 | Creativity, Humor & Voice: Uso criativo da lingua, humor, trocadilhos, storytelling autoral, estilo pessoal, imitacao de registros e escrita com voz distinta. Gramatica: deliberate rule-bending, rhythm, ambiguity, metaphor chains e register play.\n- Lesson 12 | C2 Capstone: Mastery Portfolio & Real-World Performance: Projeto final de dominio C2: palestra longa, ensaio ou relatorio sofisticado, debate, mediacao de conteudo complexo e defesa oral. Foco em naturalidade, precisao, adaptabilidade, autoridade discursiva e avaliacao critica de performance.	\N	\N	8	t	2026-05-18 11:23:48.740572	2026-05-22 05:34:47.547541	1
3	Leaf	leaf	A2+ Consolidacao	# Leaf - A2+ Consolidacao\n\n## Module 1: Lessons 01-03\n\n- Lesson 01 | Requests, Offers, Permission & Politeness: Pedidos, permissoes, favores, oferecimentos e niveis de formalidade. Gramatica: "could", "would", "may", "Would you mind...?", respostas educadas e entonacao de cortesia.\n- Lesson 02 | Past Continuous & Interrupted Actions: Acoes em progresso no passado, interrupcoes, incidentes e pequenas historias. Gramatica: Past Continuous vs Past Simple, "when/while", conectores narrativos e ordem cronologica.\n- Lesson 03 | Experiences & Present Perfect: Experiencias de vida, viagens, conquistas e novidades recentes. Gramatica: Present Perfect com "ever/never/already/yet/just", contraste com Past Simple e perguntas de experiencia.\n\n## Module 2: Lessons 04-06\n\n- Lesson 04 | Comparing, Contrasting & Choosing: Comparar produtos, lugares, pessoas, opcoes e experiencias. Gramatica: comparativos, superlativos, "as...as", "less/more than", "too/enough" e justificativas de escolha.\n- Lesson 05 | Opinions, Agreement & Disagreement: Opinioes pessoais, preferencias, concordancia, discordancia e justificativas. Gramatica: opinion phrases, "because/so/although", intensifiers simples e organizacao de resposta curta.\n- Lesson 06 | Future Plans, Predictions & Possibilities: Planos, previsoes, possibilidades e graus de certeza. Gramatica: "will", "going to", Present Continuous futuro, "might/may/could", "probably/definitely/maybe".\n\n## Module 3: Lessons 07-09\n\n- Lesson 07 | Advice, Obligation & Rules: Conselhos, regras, proibicoes, obrigacoes e falta de necessidade. Gramatica: "should", "must", "have to", "don't have to", "mustn't", "needn't" e avisos.\n- Lesson 08 | Phrasal Verbs & Everyday Actions: Phrasal verbs frequentes em casa, trabalho, estudo, tecnologia e vida social. Gramatica: separable/inseparable phrasal verbs, object pronouns e colocacao de particulas.\n- Lesson 09 | Stories, Sequencing & Simple Narratives: Contar historias pessoais, resumir acontecimentos, descrever personagens e criar finais. Gramatica: Past Simple, Past Continuous, introducao ao Past Perfect, sequencers e paragraphing.\n\n## Module 4: Lessons 10-12\n\n- Lesson 10 | Real and Hypothetical Conditions: Condicoes reais e hipoteticas ligadas a estudo, trabalho, saude e decisoes. Gramatica: Zero, First e Second Conditional, "unless", "if/when" e consequencias.\n- Lesson 11 | Passive Voice & Public Information: Noticias simples, processos, produtos, regras e informacoes publicas. Gramatica: passive voice no presente e passado, agente com "by", notices, signs e instrucoes formais.\n- Lesson 12 | A2+ Integration: Functional Fluency: Revisao com roleplays de viagem, servicos, saude, trabalho, estudo, convivencia e online. Foco em fluencia controlada, reparo de comunicacao, pronuncia inteligivel e escrita funcional.	\N	\N	3	t	2026-05-18 11:23:48.481883	2026-05-22 05:34:47.306618	1
1	Seed	seed	A1 Fundamentos	# Seed - A1 Fundamentos\n\n## Module 1: Lessons 01-03\n\n- Lesson 01 | Greetings, Names & Classroom English: Saudacoes, despedidas, apresentacoes, soletrar nomes, pedir repeticao e usar frases de sala de aula. Gramatica: verb "to be", pronomes pessoais, perguntas curtas e respostas simples.\n- Lesson 02 | Personal Information, Numbers & Forms: Nome, idade, telefone, endereco, nacionalidade, paises, numeros, datas basicas e preenchimento de formularios simples. Gramatica: "to be", possessive adjectives, question words e ordem basica da pergunta.\n- Lesson 03 | Family, People & Possessions: Familia, relacoes, objetos pessoais e descricao simples de pessoas. Gramatica: "have/have got", possessive 's, plurais regulares/irregulares, "this/that/these/those".\n\n## Module 2: Lessons 04-06\n\n- Lesson 04 | Time, Days & Daily Routine: Horas, dias da semana, meses, partes do dia e rotina diaria. Gramatica: Present Simple afirmativo/negativo/interrogativo, adverbios de frequencia iniciais e preposicoes de tempo "at/in/on".\n- Lesson 05 | Food, Drinks & Preferences: Comidas, bebidas, refeicoes, frutas, vegetais e preferencias. Gramatica: countable/uncountable nouns, "some/any", "much/many", "I like/don't like", perguntas com "do/does".\n- Lesson 06 | Clothes, Colours & Appearance: Roupas, cores, acessorios, tamanhos e aparencia fisica. Gramatica: ordem basica dos adjetivos, "be wearing", Present Continuous e diferenca entre rotina e momento atual.\n\n## Module 3: Lessons 07-09\n\n- Lesson 07 | Home, Rooms & Everyday Objects: Comodos, moveis, objetos domesticos e localizacao. Gramatica: "there is/there are", preposicoes de lugar, artigos "a/an/the" e descricoes simples de forma, cor e funcao.\n- Lesson 08 | City Places, Directions & Signs: Lugares da cidade, placas, instrucoes simples e direcoes. Gramatica: imperatives, "can" para pedidos, "where is...?", "next to/opposite/between" e linguagem funcional de localizacao.\n- Lesson 09 | Weather, Seasons & Activities: Clima, estacoes, atividades comuns e planos simples ligados ao tempo. Gramatica: "It's sunny", Present Simple para fatos, "can/can't" e vocabulario de sensacoes fisicas basicas.\n\n## Module 4: Lessons 10-12\n\n- Lesson 10 | Hobbies, Abilities & Free Time: Hobbies, esportes, musica, filmes, jogos e habilidades. Gramatica: "can" para habilidade, "like/love/hate + -ing", adverbios de frequencia e perguntas sobre lazer.\n- Lesson 11 | Body, Health & Feelings: Partes do corpo, sintomas simples, sentimentos e pedidos de ajuda. Gramatica: "I have a...", "My ___ hurts", "feel + adjective", "should" inicial para conselho simples.\n- Lesson 12 | A1 Integration: People, Places & Needs: Revisao integrada de apresentacao pessoal, rotina, comida, cidade, compras, saude e lazer. Foco em pequenos dialogos, emails/notas curtas, listening lento e pronuncia de sons basicos, word stress e entonacao de perguntas.	\N	\N	1	t	2026-05-18 11:23:48.394806	2026-05-22 05:34:47.189603	1
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.students (id, bio, profile_picture_url, timezone, is_active, created_at, updated_at) FROM stdin;
fc484aa1-d06f-4582-9101-1eeb5f8e0ad4		\N	\N	t	2026-05-20 03:08:37.931576	2026-05-20 03:08:37.931576
\.


--
-- Data for Name: teachers; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.teachers (id, bio, profile_picture_url, timezone, is_active, created_at, updated_at) FROM stdin;
fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	Very nice man!			f	2026-05-20 16:50:40.145591	2026-05-20 16:50:40.145591
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.users (id, keycloak_id, name, email, enabled, phone, birth_date, created_at, updated_at, role) FROM stdin;
fc484aa1-d06f-4582-9101-1eeb5f8e0ad4	02a2cc76-f690-4060-81a2-b98b8785e148	Matheus Francisco Albuquerque	matheus.albuquerque@exiti.com.br	t	18991683104	1995-04-27	2026-05-20 03:08:37.925931	2026-05-20 03:08:37.925931	STUDENT
\.


--
-- Data for Name: video_categories; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.video_categories (id, name, sort_order, created_at, updated_at) FROM stdin;
1	Aulas	1	2026-05-22 03:36:46.450317	2026-05-22 03:36:46.450317
2	Extras	2	2026-05-22 03:36:46.450317	2026-05-22 03:36:46.450317
\.


--
-- Data for Name: videos; Type: TABLE DATA; Schema: public; Owner: duma
--

COPY public.videos (id, title, video_category_id, embed_url, thumbnail_url, duration_label, description, created_at, updated_at) FROM stdin;
aulas-root-lesson-7	Root Lesson 7	1	https://player.cloudinary.com/embed/?cloud_name=drhybgfng&public_id=root-lesson7-2026-03-18_19.55.15_cv8hls	https://res.cloudinary.com/drhybgfng/video/upload/root-lesson7-2026-03-18_19.55.15_cv8hls.jpg	08:14		2026-05-22 03:36:46.450317	2026-05-22 03:36:46.450317
extras-lesson-01-numbers	Lesson 01 - Numbers	2	https://player.cloudinary.com/embed/?cloud_name=drhybgfng&public_id=leaf-lesson01-2026-02-20_00.05.18_eblcbb	https://res.cloudinary.com/drhybgfng/video/upload/leaf-lesson01-2026-02-20_00.05.18_eblcbb.jpg	05:47	Aprenda um pouco mais sobre números cardinais e ordinais. Também aprenda como aplicá-los.	2026-05-22 03:47:09.793431	2026-05-22 03:49:52.020835
\.


--
-- Name: attempts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: duma
--

SELECT pg_catalog.setval('public.attempts_id_seq', 11, true);


--
-- Name: attendances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: duma
--

SELECT pg_catalog.setval('public.attendances_id_seq', 1, false);


--
-- Name: cash_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: duma
--

SELECT pg_catalog.setval('public.cash_categories_id_seq', 1, true);


--
-- Name: enrollments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: duma
--

SELECT pg_catalog.setval('public.enrollments_id_seq', 3, true);


--
-- Name: files_id_seq; Type: SEQUENCE SET; Schema: public; Owner: duma
--

SELECT pg_catalog.setval('public.files_id_seq', 12, true);


--
-- Name: lesson_progress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: duma
--

SELECT pg_catalog.setval('public.lesson_progress_id_seq', 1, false);


--
-- Name: module_performance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: duma
--

SELECT pg_catalog.setval('public.module_performance_id_seq', 1, false);


--
-- Name: news_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: duma
--

SELECT pg_catalog.setval('public.news_categories_id_seq', 6, true);


--
-- Name: plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: duma
--

SELECT pg_catalog.setval('public.plans_id_seq', 2, true);


--
-- Name: podcast_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: duma
--

SELECT pg_catalog.setval('public.podcast_categories_id_seq', 5, true);


--
-- Name: resource_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: duma
--

SELECT pg_catalog.setval('public.resource_categories_id_seq', 1, true);


--
-- Name: resources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: duma
--

SELECT pg_catalog.setval('public.resources_id_seq', 2, true);


--
-- Name: skill_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: duma
--

SELECT pg_catalog.setval('public.skill_categories_id_seq', 2, true);


--
-- Name: skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: duma
--

SELECT pg_catalog.setval('public.skills_id_seq', 2, true);


--
-- Name: stages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: duma
--

SELECT pg_catalog.setval('public.stages_id_seq', 1, false);


--
-- Name: video_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: duma
--

SELECT pg_catalog.setval('public.video_categories_id_seq', 2, true);


--
-- Name: attempts attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.attempts
    ADD CONSTRAINT attempts_pkey PRIMARY KEY (id);


--
-- Name: attendances attendances_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_pkey PRIMARY KEY (id);


--
-- Name: cash_categories cash_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.cash_categories
    ADD CONSTRAINT cash_categories_name_key UNIQUE (name);


--
-- Name: cash_categories cash_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.cash_categories
    ADD CONSTRAINT cash_categories_pkey PRIMARY KEY (id);


--
-- Name: cash_transactions cash_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.cash_transactions
    ADD CONSTRAINT cash_transactions_pkey PRIMARY KEY (id);


--
-- Name: enrollments enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_pkey PRIMARY KEY (id);


--
-- Name: exercise_reported_issues exercise_reported_issues_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.exercise_reported_issues
    ADD CONSTRAINT exercise_reported_issues_pkey PRIMARY KEY (id);


--
-- Name: files files_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- Name: files files_storage_key_key; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_storage_key_key UNIQUE (storage_key);


--
-- Name: flashcards flashcards_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.flashcards
    ADD CONSTRAINT flashcards_pkey PRIMARY KEY (id);


--
-- Name: flashcards flashcards_user_id_front_normalized_key; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.flashcards
    ADD CONSTRAINT flashcards_user_id_front_normalized_key UNIQUE (user_id, front_normalized);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: lesson_book_chapters lesson_book_chapters_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.lesson_book_chapters
    ADD CONSTRAINT lesson_book_chapters_pkey PRIMARY KEY (id);


--
-- Name: lesson_books lesson_books_lesson_id_key; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.lesson_books
    ADD CONSTRAINT lesson_books_lesson_id_key UNIQUE (lesson_id);


--
-- Name: lesson_books lesson_books_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.lesson_books
    ADD CONSTRAINT lesson_books_pkey PRIMARY KEY (id);


--
-- Name: lesson_progress lesson_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.lesson_progress
    ADD CONSTRAINT lesson_progress_pkey PRIMARY KEY (id);


--
-- Name: lessons lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (id);


--
-- Name: lessons lessons_title_key; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_title_key UNIQUE (title);


--
-- Name: meetings meetings_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.meetings
    ADD CONSTRAINT meetings_pkey PRIMARY KEY (id);


--
-- Name: module_performance module_performance_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.module_performance
    ADD CONSTRAINT module_performance_pkey PRIMARY KEY (id);


--
-- Name: modules modules_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_pkey PRIMARY KEY (id);


--
-- Name: modules modules_title_key; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_title_key UNIQUE (title);


--
-- Name: news_articles news_articles_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.news_articles
    ADD CONSTRAINT news_articles_pkey PRIMARY KEY (id);


--
-- Name: news_categories news_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.news_categories
    ADD CONSTRAINT news_categories_name_key UNIQUE (name);


--
-- Name: news_categories news_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.news_categories
    ADD CONSTRAINT news_categories_pkey PRIMARY KEY (id);


--
-- Name: plan_resources plan_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.plan_resources
    ADD CONSTRAINT plan_resources_pkey PRIMARY KEY (plan_id, resource_order);


--
-- Name: plans plans_nome_key; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_nome_key UNIQUE (nome);


--
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (id);


--
-- Name: podcast_categories podcast_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.podcast_categories
    ADD CONSTRAINT podcast_categories_name_key UNIQUE (name);


--
-- Name: podcast_categories podcast_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.podcast_categories
    ADD CONSTRAINT podcast_categories_pkey PRIMARY KEY (id);


--
-- Name: podcasts podcasts_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.podcasts
    ADD CONSTRAINT podcasts_pkey PRIMARY KEY (id);


--
-- Name: resource_categories resource_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.resource_categories
    ADD CONSTRAINT resource_categories_name_key UNIQUE (name);


--
-- Name: resource_categories resource_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.resource_categories
    ADD CONSTRAINT resource_categories_pkey PRIMARY KEY (id);


--
-- Name: resources resources_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_pkey PRIMARY KEY (id);


--
-- Name: skill_categories skill_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.skill_categories
    ADD CONSTRAINT skill_categories_name_key UNIQUE (name);


--
-- Name: skill_categories skill_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.skill_categories
    ADD CONSTRAINT skill_categories_pkey PRIMARY KEY (id);


--
-- Name: skills skills_name_key; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_name_key UNIQUE (name);


--
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- Name: skills skills_slug_key; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_slug_key UNIQUE (slug);


--
-- Name: stages stages_name_skill_unique; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stages_name_skill_unique UNIQUE (name, skill_id);


--
-- Name: stages stages_order_index_skill_unique; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stages_order_index_skill_unique UNIQUE (order_index, skill_id);


--
-- Name: stages stages_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stages_pkey PRIMARY KEY (id);


--
-- Name: stages stages_slug_skill_unique; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stages_slug_skill_unique UNIQUE (slug, skill_id);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- Name: teachers teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY (id);


--
-- Name: attendances uk_attendances_student_meeting; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT uk_attendances_student_meeting UNIQUE (student_id, meeting_id);


--
-- Name: enrollments uk_enrollments_user_skill; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT uk_enrollments_user_skill UNIQUE (user_id, skill_id);


--
-- Name: lesson_book_chapters uk_lesson_book_chapters_order; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.lesson_book_chapters
    ADD CONSTRAINT uk_lesson_book_chapters_order UNIQUE (lesson_book_id, order_index);


--
-- Name: lesson_progress uk_lesson_progress_student_lesson; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.lesson_progress
    ADD CONSTRAINT uk_lesson_progress_student_lesson UNIQUE (student_id, lesson_id);


--
-- Name: module_performance uk_module_performance_student_module; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.module_performance
    ADD CONSTRAINT uk_module_performance_student_module UNIQUE (student_id, module_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_keycloak_id_key; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_keycloak_id_key UNIQUE (keycloak_id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: video_categories video_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.video_categories
    ADD CONSTRAINT video_categories_name_key UNIQUE (name);


--
-- Name: video_categories video_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.video_categories
    ADD CONSTRAINT video_categories_pkey PRIMARY KEY (id);


--
-- Name: videos videos_pkey; Type: CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: duma
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: idx_flashcards_due_date; Type: INDEX; Schema: public; Owner: duma
--

CREATE INDEX idx_flashcards_due_date ON public.flashcards USING btree (due_date);


--
-- Name: idx_flashcards_user_front; Type: INDEX; Schema: public; Owner: duma
--

CREATE INDEX idx_flashcards_user_front ON public.flashcards USING btree (user_id, front_normalized);


--
-- Name: idx_flashcards_user_id; Type: INDEX; Schema: public; Owner: duma
--

CREATE INDEX idx_flashcards_user_id ON public.flashcards USING btree (user_id);


--
-- Name: idx_lesson_book_chapters_book_id; Type: INDEX; Schema: public; Owner: duma
--

CREATE INDEX idx_lesson_book_chapters_book_id ON public.lesson_book_chapters USING btree (lesson_book_id);


--
-- Name: idx_lesson_book_chapters_order; Type: INDEX; Schema: public; Owner: duma
--

CREATE INDEX idx_lesson_book_chapters_order ON public.lesson_book_chapters USING btree (lesson_book_id, order_index);


--
-- Name: idx_lesson_books_lesson_id; Type: INDEX; Schema: public; Owner: duma
--

CREATE INDEX idx_lesson_books_lesson_id ON public.lesson_books USING btree (lesson_id);


--
-- Name: idx_meetings_lesson_id; Type: INDEX; Schema: public; Owner: duma
--

CREATE INDEX idx_meetings_lesson_id ON public.meetings USING btree (lesson_id);


--
-- Name: idx_meetings_plan_id; Type: INDEX; Schema: public; Owner: duma
--

CREATE INDEX idx_meetings_plan_id ON public.meetings USING btree (plan_id);


--
-- Name: idx_news_articles_category_id; Type: INDEX; Schema: public; Owner: duma
--

CREATE INDEX idx_news_articles_category_id ON public.news_articles USING btree (news_category_id);


--
-- Name: idx_news_articles_created_at; Type: INDEX; Schema: public; Owner: duma
--

CREATE INDEX idx_news_articles_created_at ON public.news_articles USING btree (created_at DESC);


--
-- Name: idx_news_categories_sort_order; Type: INDEX; Schema: public; Owner: duma
--

CREATE INDEX idx_news_categories_sort_order ON public.news_categories USING btree (sort_order);


--
-- Name: idx_podcast_categories_sort_order; Type: INDEX; Schema: public; Owner: duma
--

CREATE INDEX idx_podcast_categories_sort_order ON public.podcast_categories USING btree (sort_order);


--
-- Name: idx_podcasts_category_id; Type: INDEX; Schema: public; Owner: duma
--

CREATE INDEX idx_podcasts_category_id ON public.podcasts USING btree (podcast_category_id);


--
-- Name: idx_video_categories_sort_order; Type: INDEX; Schema: public; Owner: duma
--

CREATE INDEX idx_video_categories_sort_order ON public.video_categories USING btree (sort_order);


--
-- Name: idx_videos_category_id; Type: INDEX; Schema: public; Owner: duma
--

CREATE INDEX idx_videos_category_id ON public.videos USING btree (video_category_id);


--
-- Name: uq_news_articles_highlighted_true; Type: INDEX; Schema: public; Owner: duma
--

CREATE UNIQUE INDEX uq_news_articles_highlighted_true ON public.news_articles USING btree (highlighted_article) WHERE (highlighted_article = true);


--
-- Name: enrollments enrollments_current_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_current_lesson_id_fkey FOREIGN KEY (current_lesson_id) REFERENCES public.lessons(id);


--
-- Name: enrollments enrollments_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.plans(id);


--
-- Name: attempts fk_attempts_lesson; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.attempts
    ADD CONSTRAINT fk_attempts_lesson FOREIGN KEY (lesson_id) REFERENCES public.lessons(id);


--
-- Name: attempts fk_attempts_student; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.attempts
    ADD CONSTRAINT fk_attempts_student FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: attendances fk_attendances_meeting; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT fk_attendances_meeting FOREIGN KEY (meeting_id) REFERENCES public.meetings(id);


--
-- Name: attendances fk_attendances_student; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT fk_attendances_student FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: cash_transactions fk_cash_transactions_category; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.cash_transactions
    ADD CONSTRAINT fk_cash_transactions_category FOREIGN KEY (category_id) REFERENCES public.cash_categories(id);


--
-- Name: cash_transactions fk_cash_transactions_responsible; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.cash_transactions
    ADD CONSTRAINT fk_cash_transactions_responsible FOREIGN KEY (responsible_user_id) REFERENCES public.users(id);


--
-- Name: cash_transactions fk_cash_transactions_student; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.cash_transactions
    ADD CONSTRAINT fk_cash_transactions_student FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: enrollments fk_enrollments_skill; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT fk_enrollments_skill FOREIGN KEY (skill_id) REFERENCES public.skills(id);


--
-- Name: enrollments fk_enrollments_stage; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT fk_enrollments_stage FOREIGN KEY (stage_id) REFERENCES public.stages(id);


--
-- Name: enrollments fk_enrollments_user; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT fk_enrollments_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: lesson_book_chapters fk_lesson_book_chapters_book; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.lesson_book_chapters
    ADD CONSTRAINT fk_lesson_book_chapters_book FOREIGN KEY (lesson_book_id) REFERENCES public.lesson_books(id) ON DELETE CASCADE;


--
-- Name: lesson_books fk_lesson_books_lesson; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.lesson_books
    ADD CONSTRAINT fk_lesson_books_lesson FOREIGN KEY (lesson_id) REFERENCES public.lessons(id);


--
-- Name: lesson_progress fk_lesson_progress_lesson; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.lesson_progress
    ADD CONSTRAINT fk_lesson_progress_lesson FOREIGN KEY (lesson_id) REFERENCES public.lessons(id);


--
-- Name: lesson_progress fk_lesson_progress_student; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.lesson_progress
    ADD CONSTRAINT fk_lesson_progress_student FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: lessons fk_lessons_module; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT fk_lessons_module FOREIGN KEY (module_id) REFERENCES public.modules(id);


--
-- Name: lessons fk_lessons_skill; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT fk_lessons_skill FOREIGN KEY (skill_id) REFERENCES public.skills(id);


--
-- Name: lessons fk_lessons_stage; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT fk_lessons_stage FOREIGN KEY (stage_id) REFERENCES public.stages(id);


--
-- Name: meetings fk_meetings_lesson; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.meetings
    ADD CONSTRAINT fk_meetings_lesson FOREIGN KEY (lesson_id) REFERENCES public.lessons(id);


--
-- Name: meetings fk_meetings_plan; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.meetings
    ADD CONSTRAINT fk_meetings_plan FOREIGN KEY (plan_id) REFERENCES public.plans(id);


--
-- Name: meetings fk_meetings_skill; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.meetings
    ADD CONSTRAINT fk_meetings_skill FOREIGN KEY (skill_id) REFERENCES public.skills(id);


--
-- Name: meetings fk_meetings_stage; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.meetings
    ADD CONSTRAINT fk_meetings_stage FOREIGN KEY (stage_id) REFERENCES public.stages(id);


--
-- Name: meetings fk_meetings_teacher; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.meetings
    ADD CONSTRAINT fk_meetings_teacher FOREIGN KEY (teacher_id) REFERENCES public.teachers(id);


--
-- Name: module_performance fk_module_performance_module; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.module_performance
    ADD CONSTRAINT fk_module_performance_module FOREIGN KEY (module_id) REFERENCES public.modules(id);


--
-- Name: module_performance fk_module_performance_student; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.module_performance
    ADD CONSTRAINT fk_module_performance_student FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: modules fk_modules_skill; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT fk_modules_skill FOREIGN KEY (skill_id) REFERENCES public.skills(id);


--
-- Name: modules fk_modules_stage; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT fk_modules_stage FOREIGN KEY (stage_id) REFERENCES public.stages(id);


--
-- Name: news_articles fk_news_articles_category; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.news_articles
    ADD CONSTRAINT fk_news_articles_category FOREIGN KEY (news_category_id) REFERENCES public.news_categories(id);


--
-- Name: podcasts fk_podcasts_category; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.podcasts
    ADD CONSTRAINT fk_podcasts_category FOREIGN KEY (podcast_category_id) REFERENCES public.podcast_categories(id);


--
-- Name: resources fk_resources_category; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT fk_resources_category FOREIGN KEY (resource_category_id) REFERENCES public.resource_categories(id);


--
-- Name: resources fk_resources_file; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT fk_resources_file FOREIGN KEY (file_id) REFERENCES public.files(id);


--
-- Name: resources fk_resources_lesson; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT fk_resources_lesson FOREIGN KEY (lesson_id) REFERENCES public.lessons(id);


--
-- Name: resources fk_resources_skill; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT fk_resources_skill FOREIGN KEY (skill_id) REFERENCES public.skills(id);


--
-- Name: resources fk_resources_stage; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT fk_resources_stage FOREIGN KEY (stage_id) REFERENCES public.stages(id);


--
-- Name: skills fk_skills_category; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT fk_skills_category FOREIGN KEY (category_id) REFERENCES public.skill_categories(id);


--
-- Name: students fk_students_user; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT fk_students_user FOREIGN KEY (id) REFERENCES public.users(id);


--
-- Name: teachers fk_teachers_user; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT fk_teachers_user FOREIGN KEY (id) REFERENCES public.users(id);


--
-- Name: videos fk_videos_category; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT fk_videos_category FOREIGN KEY (video_category_id) REFERENCES public.video_categories(id);


--
-- Name: flashcards flashcards_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.flashcards
    ADD CONSTRAINT flashcards_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: plan_resources plan_resources_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.plan_resources
    ADD CONSTRAINT plan_resources_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.plans(id) ON DELETE CASCADE;


--
-- Name: stages stages_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: duma
--

ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stages_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: duma
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

