--
-- PostgreSQL database dump
--

-- Dumped from database version 14.8 (Ubuntu 14.8-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.8 (Ubuntu 14.8-0ubuntu0.22.04.1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: tbl_admin; Type: TABLE; Schema: public; Owner: shairul
--

CREATE TABLE public.tbl_admin (
    id_admin integer NOT NULL,
    id_user integer,
    nama_admin character varying(255),
    tgl_lahir_admin date,
    jabatan character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.tbl_admin OWNER TO shairul;

--
-- Name: tbl_admin_id_admin_seq; Type: SEQUENCE; Schema: public; Owner: shairul
--

CREATE SEQUENCE public.tbl_admin_id_admin_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_admin_id_admin_seq OWNER TO shairul;

--
-- Name: tbl_admin_id_admin_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shairul
--

ALTER SEQUENCE public.tbl_admin_id_admin_seq OWNED BY public.tbl_admin.id_admin;


--
-- Name: tbl_kriteria; Type: TABLE; Schema: public; Owner: shairul
--

CREATE TABLE public.tbl_kriteria (
    id_kriteria integer NOT NULL,
    kode_kriteria character varying(255),
    nama_kriteria character varying(255),
    posisi character varying(255),
    tipe character varying(10),
    bobot numeric(4,2)
);


ALTER TABLE public.tbl_kriteria OWNER TO shairul;

--
-- Name: tbl_kriteria_id_kriteria_seq; Type: SEQUENCE; Schema: public; Owner: shairul
--

CREATE SEQUENCE public.tbl_kriteria_id_kriteria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_kriteria_id_kriteria_seq OWNER TO shairul;

--
-- Name: tbl_kriteria_id_kriteria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shairul
--

ALTER SEQUENCE public.tbl_kriteria_id_kriteria_seq OWNED BY public.tbl_kriteria.id_kriteria;


--
-- Name: tbl_nilai_kriteria; Type: TABLE; Schema: public; Owner: shairul
--

CREATE TABLE public.tbl_nilai_kriteria (
    nisn integer NOT NULL,
    id_kriteria integer NOT NULL,
    nilai numeric(4,2)
);


ALTER TABLE public.tbl_nilai_kriteria OWNER TO shairul;

--
-- Name: tbl_pemain; Type: TABLE; Schema: public; Owner: shairul
--

CREATE TABLE public.tbl_pemain (
    nisn integer NOT NULL,
    id_user integer,
    nama_pemain character varying(255),
    tgl_lahir_pemain date,
    posisi character varying(255),
    asal_sekolah character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.tbl_pemain OWNER TO shairul;

--
-- Name: tbl_skor_moora; Type: TABLE; Schema: public; Owner: shairul
--

CREATE TABLE public.tbl_skor_moora (
    nisn integer NOT NULL,
    skor numeric(9,6),
    status character varying(50)
);


ALTER TABLE public.tbl_skor_moora OWNER TO shairul;

--
-- Name: tbl_users; Type: TABLE; Schema: public; Owner: shairul
--

CREATE TABLE public.tbl_users (
    id_user integer NOT NULL,
    username character varying(255),
    password character(64),
    role character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    admin_data_completed boolean DEFAULT false,
    user_data_completed boolean DEFAULT false
);


ALTER TABLE public.tbl_users OWNER TO shairul;

--
-- Name: tbl_users_id_user_seq; Type: SEQUENCE; Schema: public; Owner: shairul
--

CREATE SEQUENCE public.tbl_users_id_user_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_users_id_user_seq OWNER TO shairul;

--
-- Name: tbl_users_id_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shairul
--

ALTER SEQUENCE public.tbl_users_id_user_seq OWNED BY public.tbl_users.id_user;


--
-- Name: tbl_admin id_admin; Type: DEFAULT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_admin ALTER COLUMN id_admin SET DEFAULT nextval('public.tbl_admin_id_admin_seq'::regclass);


--
-- Name: tbl_kriteria id_kriteria; Type: DEFAULT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_kriteria ALTER COLUMN id_kriteria SET DEFAULT nextval('public.tbl_kriteria_id_kriteria_seq'::regclass);


--
-- Name: tbl_users id_user; Type: DEFAULT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_users ALTER COLUMN id_user SET DEFAULT nextval('public.tbl_users_id_user_seq'::regclass);


--
-- Data for Name: tbl_admin; Type: TABLE DATA; Schema: public; Owner: shairul
--

COPY public.tbl_admin (id_admin, id_user, nama_admin, tgl_lahir_admin, jabatan, created_at, updated_at) FROM stdin;
1	9	Superadmin	1987-12-14	Head Coach	2023-07-05 20:17:25.273351	2023-07-05 20:17:25.273351
2	12	Wawan Hendrawan	1966-12-19	Head Coach	2023-07-06 14:40:58.33863	2023-07-06 14:40:58.33863
3	13	Mukti Wibisono	1978-05-04	Asst. Coach	2023-07-06 14:41:33.714784	2023-07-06 14:41:33.714784
4	14	Andrian winarto	1992-01-13	Scout Staff	2023-07-06 14:42:17.321109	2023-07-06 14:42:17.321109
\.


--
-- Data for Name: tbl_kriteria; Type: TABLE DATA; Schema: public; Owner: shairul
--

COPY public.tbl_kriteria (id_kriteria, kode_kriteria, nama_kriteria, posisi, tipe, bobot) FROM stdin;
5	C001	Speed	DF	\N	\N
6	C002	Age	MF	\N	0.06
7	C004	Shoot	FW	benefit	0.21
\.


--
-- Data for Name: tbl_nilai_kriteria; Type: TABLE DATA; Schema: public; Owner: shairul
--

COPY public.tbl_nilai_kriteria (nisn, id_kriteria, nilai) FROM stdin;
\.


--
-- Data for Name: tbl_pemain; Type: TABLE DATA; Schema: public; Owner: shairul
--

COPY public.tbl_pemain (nisn, id_user, nama_pemain, tgl_lahir_pemain, posisi, asal_sekolah, created_at, updated_at) FROM stdin;
12345678	8	Shairul Annam	2000-10-31	DF	SDS Miftahul Jannah	2023-07-05 20:14:15.717602	2023-07-05 20:14:15.717602
444444	10	Asan Basri	2000-03-10	FW	SDN 1 Cikupa	2023-07-05 20:15:38.810173	2023-07-05 20:15:38.810173
447890	11	Muhammad Faturrahman	2008-01-10	DF	SMPN 1 CIKUPA	2023-07-06 14:05:58.345674	2023-07-06 14:05:58.345674
\.


--
-- Data for Name: tbl_skor_moora; Type: TABLE DATA; Schema: public; Owner: shairul
--

COPY public.tbl_skor_moora (nisn, skor, status) FROM stdin;
\.


--
-- Data for Name: tbl_users; Type: TABLE DATA; Schema: public; Owner: shairul
--

COPY public.tbl_users (id_user, username, password, role, created_at, updated_at, admin_data_completed, user_data_completed) FROM stdin;
8	shairul	a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3	user	2023-07-04 12:10:04.931547	2023-07-04 12:10:04.931547	f	t
10	asan	a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3	user	2023-07-05 20:15:11.71078	2023-07-05 20:15:11.71078	f	t
9	superadmin	a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3	admin	2023-07-04 12:11:14.477708	2023-07-04 12:11:14.477708	t	f
11	fatur	a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3	user	2023-07-06 14:05:45.83033	2023-07-06 14:05:45.83033	f	t
12	wawan	a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3	admin	2023-07-06 14:40:16.281273	2023-07-06 14:40:16.281273	t	f
13	mukti	a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3	admin	2023-07-06 14:40:27.934501	2023-07-06 14:40:27.934501	t	f
14	andri	a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3	admin	2023-07-06 14:40:41.583132	2023-07-06 14:40:41.583132	t	f
\.


--
-- Name: tbl_admin_id_admin_seq; Type: SEQUENCE SET; Schema: public; Owner: shairul
--

SELECT pg_catalog.setval('public.tbl_admin_id_admin_seq', 4, true);


--
-- Name: tbl_kriteria_id_kriteria_seq; Type: SEQUENCE SET; Schema: public; Owner: shairul
--

SELECT pg_catalog.setval('public.tbl_kriteria_id_kriteria_seq', 7, true);


--
-- Name: tbl_users_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: shairul
--

SELECT pg_catalog.setval('public.tbl_users_id_user_seq', 14, true);


--
-- Name: tbl_admin tbl_admin_pkey; Type: CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_admin
    ADD CONSTRAINT tbl_admin_pkey PRIMARY KEY (id_admin);


--
-- Name: tbl_kriteria tbl_kriteria_pkey; Type: CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_kriteria
    ADD CONSTRAINT tbl_kriteria_pkey PRIMARY KEY (id_kriteria);


--
-- Name: tbl_nilai_kriteria tbl_nilai_kriteria_pkey; Type: CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_nilai_kriteria
    ADD CONSTRAINT tbl_nilai_kriteria_pkey PRIMARY KEY (nisn, id_kriteria);


--
-- Name: tbl_pemain tbl_pemain_pkey; Type: CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_pemain
    ADD CONSTRAINT tbl_pemain_pkey PRIMARY KEY (nisn);


--
-- Name: tbl_skor_moora tbl_skor_moora_pkey; Type: CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_skor_moora
    ADD CONSTRAINT tbl_skor_moora_pkey PRIMARY KEY (nisn);


--
-- Name: tbl_users tbl_users_pkey; Type: CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_users
    ADD CONSTRAINT tbl_users_pkey PRIMARY KEY (id_user);


--
-- Name: tbl_admin tbl_admin_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_admin
    ADD CONSTRAINT tbl_admin_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.tbl_users(id_user);


--
-- Name: tbl_nilai_kriteria tbl_nilai_kriteria_id_kriteria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_nilai_kriteria
    ADD CONSTRAINT tbl_nilai_kriteria_id_kriteria_fkey FOREIGN KEY (id_kriteria) REFERENCES public.tbl_kriteria(id_kriteria);


--
-- Name: tbl_nilai_kriteria tbl_nilai_kriteria_nisn_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_nilai_kriteria
    ADD CONSTRAINT tbl_nilai_kriteria_nisn_fkey FOREIGN KEY (nisn) REFERENCES public.tbl_pemain(nisn);


--
-- Name: tbl_pemain tbl_pemain_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_pemain
    ADD CONSTRAINT tbl_pemain_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.tbl_users(id_user);


--
-- Name: tbl_skor_moora tbl_skor_moora_nisn_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_skor_moora
    ADD CONSTRAINT tbl_skor_moora_nisn_fkey FOREIGN KEY (nisn) REFERENCES public.tbl_pemain(nisn);


--
-- PostgreSQL database dump complete
--
