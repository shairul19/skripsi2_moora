--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4
-- Dumped by pg_dump version 15.4

-- Started on 2023-09-11 20:37:49

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

DROP DATABASE db_seleksi;
--
-- TOC entry 3371 (class 1262 OID 16399)
-- Name: db_seleksi; Type: DATABASE; Schema: -; Owner: shairul
--

CREATE DATABASE db_seleksi WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_Indonesia.1252';


ALTER DATABASE db_seleksi OWNER TO shairul;

\connect db_seleksi

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
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 3372 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 214 (class 1259 OID 16400)
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
-- TOC entry 215 (class 1259 OID 16407)
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
-- TOC entry 3373 (class 0 OID 0)
-- Dependencies: 215
-- Name: tbl_admin_id_admin_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shairul
--

ALTER SEQUENCE public.tbl_admin_id_admin_seq OWNED BY public.tbl_admin.id_admin;


--
-- TOC entry 216 (class 1259 OID 16408)
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
-- TOC entry 217 (class 1259 OID 16413)
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
-- TOC entry 3374 (class 0 OID 0)
-- Dependencies: 217
-- Name: tbl_kriteria_id_kriteria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shairul
--

ALTER SEQUENCE public.tbl_kriteria_id_kriteria_seq OWNED BY public.tbl_kriteria.id_kriteria;


--
-- TOC entry 218 (class 1259 OID 16414)
-- Name: tbl_nilai_kriteria; Type: TABLE; Schema: public; Owner: shairul
--

CREATE TABLE public.tbl_nilai_kriteria (
    nisn character varying(10) NOT NULL,
    id_kriteria integer NOT NULL,
    nilai numeric(5,2)
);


ALTER TABLE public.tbl_nilai_kriteria OWNER TO shairul;

--
-- TOC entry 219 (class 1259 OID 16417)
-- Name: tbl_pemain; Type: TABLE; Schema: public; Owner: shairul
--

CREATE TABLE public.tbl_pemain (
    nisn character varying(10) NOT NULL,
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
-- TOC entry 220 (class 1259 OID 16424)
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
-- TOC entry 221 (class 1259 OID 16431)
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
-- TOC entry 3375 (class 0 OID 0)
-- Dependencies: 221
-- Name: tbl_users_id_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shairul
--

ALTER SEQUENCE public.tbl_users_id_user_seq OWNED BY public.tbl_users.id_user;


--
-- TOC entry 3191 (class 2604 OID 16432)
-- Name: tbl_admin id_admin; Type: DEFAULT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_admin ALTER COLUMN id_admin SET DEFAULT nextval('public.tbl_admin_id_admin_seq'::regclass);


--
-- TOC entry 3194 (class 2604 OID 16433)
-- Name: tbl_kriteria id_kriteria; Type: DEFAULT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_kriteria ALTER COLUMN id_kriteria SET DEFAULT nextval('public.tbl_kriteria_id_kriteria_seq'::regclass);


--
-- TOC entry 3197 (class 2604 OID 16434)
-- Name: tbl_users id_user; Type: DEFAULT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_users ALTER COLUMN id_user SET DEFAULT nextval('public.tbl_users_id_user_seq'::regclass);


--
-- TOC entry 3358 (class 0 OID 16400)
-- Dependencies: 214
-- Data for Name: tbl_admin; Type: TABLE DATA; Schema: public; Owner: shairul
--

INSERT INTO public.tbl_admin VALUES (8, 74, 'MUKTI HERIANSYAH', '1981-10-13', 'Asst. Coach', '2023-08-09 18:13:00.872024', '2023-08-09 18:13:00.872024');
INSERT INTO public.tbl_admin VALUES (7, 73, 'WAWAN HENDRAWAN', '1970-03-17', 'Head Coach', '2023-08-09 17:34:06.823263', '2023-08-09 17:34:06.823263');
INSERT INTO public.tbl_admin VALUES (6, 30, 'SUPERADMIN', '1971-01-04', 'superadmin', '2023-08-09 13:55:56.273797', '2023-08-09 13:55:56.273797');
INSERT INTO public.tbl_admin VALUES (10, 81, 'SHAIRUL ANNAM', '2000-10-31', 'Scout Staff', '2023-08-29 16:47:50.841724', '2023-08-29 16:47:50.841724');
INSERT INTO public.tbl_admin VALUES (11, 82, 'FERRY KURNIAWAN', '1994-11-21', 'Scout Staff', '2023-09-11 01:57:58.752871', '2023-09-11 01:57:58.752871');


--
-- TOC entry 3360 (class 0 OID 16408)
-- Dependencies: 216
-- Data for Name: tbl_kriteria; Type: TABLE DATA; Schema: public; Owner: shairul
--

INSERT INTO public.tbl_kriteria VALUES (8, 'CGK01', 'Age', 'GK', 'cost', 0.02);
INSERT INTO public.tbl_kriteria VALUES (9, 'CGK02', 'Height', 'GK', 'benefit', 0.10);
INSERT INTO public.tbl_kriteria VALUES (10, 'CGK03', 'Stamina', 'GK', 'benefit', 0.07);
INSERT INTO public.tbl_kriteria VALUES (11, 'CGK04', 'Positioning', 'GK', 'benefit', 0.08);
INSERT INTO public.tbl_kriteria VALUES (12, 'CGK05', 'Passing/Crossing', 'GK', 'benefit', 0.03);
INSERT INTO public.tbl_kriteria VALUES (13, 'CGK06', 'teamwork', 'GK', 'benefit', 0.08);
INSERT INTO public.tbl_kriteria VALUES (14, 'CGK07', 'Ball Control', 'GK', 'benefit', 0.07);
INSERT INTO public.tbl_kriteria VALUES (15, 'CGK08', 'Save the ball', 'GK', 'benefit', 0.20);
INSERT INTO public.tbl_kriteria VALUES (16, 'CGK09', 'Serenity', 'GK', 'benefit', 0.15);
INSERT INTO public.tbl_kriteria VALUES (17, 'CGK10', 'Reflect', 'GK', 'benefit', 0.20);
INSERT INTO public.tbl_kriteria VALUES (18, 'CDF01', 'Age', 'DF', 'cost', 0.02);
INSERT INTO public.tbl_kriteria VALUES (19, 'CDF02', 'Height', 'DF', 'benefit', 0.10);
INSERT INTO public.tbl_kriteria VALUES (20, 'CDF03', 'Body Balance', 'DF', 'benefit', 0.20);
INSERT INTO public.tbl_kriteria VALUES (21, 'CDF04', 'Stamina', 'DF', 'benefit', 0.07);
INSERT INTO public.tbl_kriteria VALUES (22, 'CDF05', 'Positioning', 'DF', 'benefit', 0.10);
INSERT INTO public.tbl_kriteria VALUES (23, 'CDF06', 'Passing/Crossing', 'DF', 'benefit', 0.10);
INSERT INTO public.tbl_kriteria VALUES (24, 'CDF07', 'Speed', 'DF', 'benefit', 0.07);
INSERT INTO public.tbl_kriteria VALUES (25, 'CDF08', 'Teamwork', 'DF', 'benefit', 0.10);
INSERT INTO public.tbl_kriteria VALUES (26, 'CDF09', 'Ball Control', 'DF', 'benefit', 0.10);
INSERT INTO public.tbl_kriteria VALUES (27, 'CDF10', 'Drible', 'DF', 'benefit', 0.06);
INSERT INTO public.tbl_kriteria VALUES (28, 'CDF11', 'Serenity', 'DF', 'benefit', 0.08);
INSERT INTO public.tbl_kriteria VALUES (29, 'CMF01', 'Age', 'MF', 'cost', 0.02);
INSERT INTO public.tbl_kriteria VALUES (30, 'CMF02', 'Height', 'MF', 'benefit', 0.07);
INSERT INTO public.tbl_kriteria VALUES (31, 'CMF03', 'Body Balance', 'MF', 'benefit', 0.10);
INSERT INTO public.tbl_kriteria VALUES (32, 'CMF04', 'Stamina', 'MF', 'benefit', 0.10);
INSERT INTO public.tbl_kriteria VALUES (33, 'CMF05', 'Positioning', 'MF', 'benefit', 0.08);
INSERT INTO public.tbl_kriteria VALUES (34, 'CMF06', 'Passing/Crossing', 'MF', 'benefit', 0.15);
INSERT INTO public.tbl_kriteria VALUES (35, 'CMF07', 'Speed', 'MF', 'benefit', 0.08);
INSERT INTO public.tbl_kriteria VALUES (36, 'CMF08', 'Teamwork', 'MF', 'benefit', 0.15);
INSERT INTO public.tbl_kriteria VALUES (37, 'CMF09', 'Ball Control', 'MF', 'benefit', 0.10);
INSERT INTO public.tbl_kriteria VALUES (38, 'CMF10', 'Drible', 'MF', 'benefit', 0.07);
INSERT INTO public.tbl_kriteria VALUES (39, 'CMF11', 'Serenity', 'MF', 'benefit', 0.08);
INSERT INTO public.tbl_kriteria VALUES (40, 'CFW01', 'Age', 'FW', 'cost', 0.02);
INSERT INTO public.tbl_kriteria VALUES (41, 'CFW02', 'Height', 'FW', 'benefit', 0.07);
INSERT INTO public.tbl_kriteria VALUES (42, 'CFW03', 'Body Balance', 'FW', 'benefit', 0.08);
INSERT INTO public.tbl_kriteria VALUES (43, 'CFW04', 'Stamina', 'FW', 'benefit', 0.07);
INSERT INTO public.tbl_kriteria VALUES (44, 'CFW05', 'Positioning', 'FW', 'benefit', 0.08);
INSERT INTO public.tbl_kriteria VALUES (45, 'CFW06', 'Passing/Crossing', 'FW', 'benefit', 0.03);
INSERT INTO public.tbl_kriteria VALUES (46, 'CFW07', 'Speed', 'FW', 'benefit', 0.07);
INSERT INTO public.tbl_kriteria VALUES (47, 'CFW08', 'Teamwork', 'FW', 'benefit', 0.06);
INSERT INTO public.tbl_kriteria VALUES (48, 'CFW09', 'Ball Control', 'FW', 'benefit', 0.07);
INSERT INTO public.tbl_kriteria VALUES (50, 'CFW10', 'Shoot', 'FW', 'benefit', 0.15);
INSERT INTO public.tbl_kriteria VALUES (51, 'CFW11', 'Finishing', 'FW', 'benefit', 0.15);
INSERT INTO public.tbl_kriteria VALUES (52, 'CFW12', 'Drible', 'FW', 'benefit', 0.08);
INSERT INTO public.tbl_kriteria VALUES (61, 'CFW13', 'Serenity', 'FW', 'benefit', 0.07);


--
-- TOC entry 3362 (class 0 OID 16414)
-- Dependencies: 218
-- Data for Name: tbl_nilai_kriteria; Type: TABLE DATA; Schema: public; Owner: shairul
--

INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 8, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 9, 174.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 10, 74.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 11, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 12, 78.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 13, 78.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 14, 75.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 15, 93.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 16, 73.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 17, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098446398', 8, 14.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098446398', 9, 165.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098446398', 10, 84.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098446398', 11, 75.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098446398', 12, 60.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098446398', 13, 71.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098446398', 14, 61.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098446398', 15, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098446398', 16, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098446398', 17, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082914887', 8, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082914887', 9, 164.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082914887', 10, 73.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082914887', 11, 73.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082914887', 12, 71.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082914887', 13, 84.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082914887', 14, 75.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082914887', 15, 87.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082914887', 16, 70.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082914887', 17, 94.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092908938', 8, 14.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092908938', 9, 178.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092908938', 10, 85.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092908938', 11, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092908938', 12, 72.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092908938', 13, 87.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092908938', 14, 64.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092908938', 15, 84.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092908938', 16, 79.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092908938', 17, 85.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086006326', 8, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086006326', 9, 183.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086006326', 10, 75.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086006326', 11, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086006326', 12, 73.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086006326', 13, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086006326', 14, 65.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086006326', 15, 80.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086006326', 16, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086006326', 17, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083603701', 8, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083603701', 9, 178.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083603701', 10, 73.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083603701', 11, 73.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083603701', 12, 64.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083603701', 13, 76.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083603701', 14, 65.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083603701', 15, 87.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083603701', 16, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083603701', 17, 83.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084596941', 8, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084596941', 9, 167.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084596941', 10, 83.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084596941', 11, 72.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084596941', 12, 64.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084596941', 13, 78.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084596941', 14, 71.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084596941', 15, 95.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084596941', 16, 85.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084596941', 17, 94.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086243601', 8, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086243601', 9, 180.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086243601', 10, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086243601', 11, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086243601', 12, 63.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086243601', 13, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086243601', 14, 70.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086243601', 15, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086243601', 16, 70.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086243601', 17, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0093798023', 8, 14.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0093798023', 9, 178.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0093798023', 10, 80.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0093798023', 11, 75.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0093798023', 12, 69.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0093798023', 13, 70.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0093798023', 14, 66.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0093798023', 15, 95.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0093798023', 16, 78.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0093798023', 17, 85.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0103057626', 8, 13.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0103057626', 9, 168.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0103057626', 10, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0103057626', 11, 77.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0103057626', 12, 66.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0103057626', 13, 70.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0103057626', 14, 60.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0103057626', 15, 83.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0103057626', 16, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0103057626', 17, 94.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095097724', 18, 14.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095097724', 19, 167.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095097724', 20, 91.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095097724', 21, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095097724', 22, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095097724', 23, 79.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095097724', 24, 66.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095097724', 25, 71.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095097724', 26, 84.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095097724', 27, 69.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095097724', 28, 70.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0097758843', 18, 14.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0097758843', 19, 169.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0097758843', 20, 70.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0097758843', 21, 87.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0097758843', 22, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0097758843', 23, 78.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0097758843', 24, 65.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0097758843', 25, 70.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0097758843', 26, 83.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0097758843', 27, 77.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0097758843', 28, 71.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084927673', 18, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084927673', 19, 170.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084927673', 20, 87.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084927673', 21, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084927673', 22, 84.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084927673', 23, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084927673', 24, 80.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084927673', 25, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084927673', 26, 76.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084927673', 27, 63.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084927673', 28, 87.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084553151', 18, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084553151', 19, 172.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084553151', 20, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084553151', 21, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084553151', 22, 80.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084553151', 23, 78.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084553151', 24, 71.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084553151', 25, 73.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084553151', 26, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084553151', 27, 72.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0084553151', 28, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083620141', 18, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083620141', 19, 173.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083620141', 20, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083620141', 21, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083620141', 22, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083620141', 23, 73.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083620141', 24, 68.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083620141', 25, 76.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083620141', 26, 84.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083620141', 27, 66.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0083620141', 28, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085075344', 18, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085075344', 19, 165.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085075344', 20, 73.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085075344', 21, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085075344', 22, 71.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085075344', 23, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085075344', 24, 66.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085075344', 25, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085075344', 26, 84.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085075344', 27, 77.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085075344', 28, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092676863', 18, 14.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092676863', 19, 171.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092676863', 20, 85.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092676863', 21, 83.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092676863', 22, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092676863', 23, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092676863', 24, 68.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092676863', 25, 72.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092676863', 26, 80.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092676863', 27, 69.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092676863', 28, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089769870', 18, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089769870', 19, 165.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089769870', 20, 87.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089769870', 21, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089769870', 22, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089769870', 23, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089769870', 24, 78.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089769870', 25, 79.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089769870', 26, 85.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089769870', 27, 73.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089769870', 28, 70.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082863042', 18, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082863042', 19, 177.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082863042', 20, 85.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082863042', 21, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082863042', 22, 80.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082863042', 23, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082863042', 24, 67.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082863042', 25, 85.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082863042', 26, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082863042', 27, 75.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082863042', 28, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082653758', 18, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082653758', 19, 173.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082653758', 20, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082653758', 21, 77.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082653758', 22, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082653758', 23, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082653758', 24, 75.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082653758', 25, 80.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082653758', 26, 80.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082653758', 27, 73.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0082653758', 28, 75.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086598102', 29, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086598102', 30, 160.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086598102', 31, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086598102', 32, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086598102', 33, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086598102', 34, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086598102', 35, 80.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086598102', 36, 76.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086598102', 37, 81.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086598102', 38, 76.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086598102', 39, 77.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086989979', 29, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086989979', 30, 160.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086989979', 31, 94.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086989979', 32, 84.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086989979', 33, 84.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086989979', 34, 95.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086989979', 35, 70.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086989979', 36, 84.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086989979', 37, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086989979', 38, 79.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086989979', 39, 85.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096237878', 29, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096237878', 30, 170.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096237878', 31, 93.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096237878', 32, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096237878', 33, 79.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096237878', 34, 81.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096237878', 35, 85.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096237878', 36, 84.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096237878', 37, 91.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096237878', 38, 87.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096237878', 39, 75.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099181363', 29, 14.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099181363', 30, 170.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099181363', 31, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099181363', 32, 79.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099181363', 33, 87.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099181363', 34, 83.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099181363', 35, 74.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099181363', 36, 72.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099181363', 37, 91.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099181363', 38, 83.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099181363', 39, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088307428', 29, 14.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088307428', 30, 164.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088307428', 31, 79.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088307428', 32, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088307428', 33, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088307428', 34, 95.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088307428', 35, 80.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088307428', 36, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088307428', 37, 81.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088307428', 38, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088307428', 39, 70.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0094279823', 29, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0094279823', 30, 165.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0094279823', 31, 87.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0094279823', 32, 79.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0094279823', 33, 71.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0094279823', 34, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0094279823', 35, 76.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0094279823', 36, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0094279823', 37, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0094279823', 38, 75.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0094279823', 39, 81.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086329831', 29, 14.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086329831', 30, 156.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086329831', 31, 79.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086329831', 32, 79.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086329831', 33, 81.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086329831', 34, 92.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086329831', 35, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086329831', 36, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086329831', 37, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086329831', 38, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086329831', 39, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092081244', 29, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092081244', 30, 165.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092081244', 31, 76.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092081244', 32, 77.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092081244', 33, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092081244', 34, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092081244', 35, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092081244', 36, 76.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092081244', 37, 91.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092081244', 38, 76.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0092081244', 39, 78.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098897929', 29, 14.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098897929', 30, 165.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098897929', 31, 79.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098897929', 32, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098897929', 33, 72.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098897929', 34, 95.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098897929', 35, 87.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098897929', 36, 72.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098897929', 37, 81.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098897929', 38, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098897929', 39, 80.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087002934', 29, 14.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087002934', 30, 165.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087002934', 31, 93.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087002934', 32, 76.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087002934', 33, 78.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087002934', 34, 84.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087002934', 35, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087002934', 36, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087002934', 37, 92.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087002934', 38, 79.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087002934', 39, 81.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088080800', 40, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088080800', 41, 167.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088080800', 42, 78.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088080800', 43, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088080800', 44, 76.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088080800', 45, 85.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088080800', 46, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088080800', 47, 76.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088080800', 48, 87.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088080800', 50, 91.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088080800', 51, 87.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088080800', 52, 84.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0088080800', 61, 76.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098056987', 40, 14.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098056987', 41, 164.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098056987', 42, 81.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098056987', 43, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098056987', 44, 83.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098056987', 45, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098056987', 46, 83.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098056987', 47, 83.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098056987', 48, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098056987', 50, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098056987', 51, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098056987', 52, 92.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0098056987', 61, 84.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096726860', 40, 14.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096726860', 41, 163.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096726860', 42, 87.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096726860', 43, 76.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096726860', 44, 71.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096726860', 45, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096726860', 46, 76.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096726860', 47, 84.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096726860', 48, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096726860', 50, 94.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096726860', 51, 91.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096726860', 52, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0096726860', 61, 80.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087959666', 40, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087959666', 41, 170.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087959666', 42, 87.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087959666', 43, 79.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087959666', 44, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087959666', 45, 83.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087959666', 46, 78.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087959666', 47, 70.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087959666', 48, 87.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087959666', 50, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087959666', 51, 95.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087959666', 52, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0087959666', 61, 81.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089295384', 40, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089295384', 41, 170.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089295384', 42, 83.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089295384', 43, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089295384', 44, 77.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089295384', 45, 77.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089295384', 46, 84.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089295384', 47, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089295384', 48, 81.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089295384', 50, 93.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089295384', 51, 95.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089295384', 52, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0089295384', 61, 81.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0081987805', 40, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0081987805', 41, 168.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0081987805', 42, 77.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0081987805', 43, 76.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0081987805', 44, 71.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0081987805', 45, 81.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0081987805', 46, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0081987805', 47, 76.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0081987805', 48, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0081987805', 50, 91.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0081987805', 51, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0081987805', 52, 91.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0081987805', 61, 74.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095919243', 40, 14.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095919243', 41, 166.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095919243', 42, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095919243', 43, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095919243', 44, 78.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095919243', 45, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095919243', 46, 85.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095919243', 47, 78.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095919243', 48, 84.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095919243', 50, 87.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095919243', 51, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095919243', 52, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095919243', 61, 83.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086341319', 40, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086341319', 41, 165.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086341319', 42, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086341319', 43, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086341319', 44, 85.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086341319', 45, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086341319', 46, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086341319', 47, 76.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086341319', 48, 84.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086341319', 50, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086341319', 51, 92.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086341319', 52, 95.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0086341319', 61, 70.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099290297', 40, 14.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099290297', 41, 170.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099290297', 42, 85.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099290297', 43, 78.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099290297', 44, 78.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099290297', 45, 79.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099290297', 46, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099290297', 47, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099290297', 48, 89.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099290297', 50, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099290297', 51, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099290297', 52, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0099290297', 61, 86.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095656740', 40, 14.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095656740', 41, 160.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095656740', 42, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095656740', 43, 85.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095656740', 44, 82.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095656740', 45, 75.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095656740', 46, 77.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095656740', 47, 74.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095656740', 48, 85.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095656740', 50, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095656740', 51, 88.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095656740', 52, 84.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0095656740', 61, 78.00);


--
-- TOC entry 3363 (class 0 OID 16417)
-- Dependencies: 219
-- Data for Name: tbl_pemain; Type: TABLE DATA; Schema: public; Owner: shairul
--

INSERT INTO public.tbl_pemain VALUES ('0083603701', 36, 'ALDRICK ANUGERAH', '2008-10-01', 'GK', 'SMAS PGRI LEGOK', '2023-08-09 15:57:45.505849', '2023-08-09 15:57:45.505849');
INSERT INTO public.tbl_pemain VALUES ('0084596941', 37, 'CHANDRA TRI', '2008-04-04', 'GK', 'SMAN 17 KABUPATEN TANGERANG', '2023-08-09 15:59:52.20111', '2023-08-09 15:59:52.20111');
INSERT INTO public.tbl_pemain VALUES ('0086243601', 38, 'MOCHAMAD DZAKI', '2008-09-30', 'GK', 'SMAS YUPPENTEK 3', '2023-08-09 16:02:00.418973', '2023-08-09 16:02:00.418973');
INSERT INTO public.tbl_pemain VALUES ('0103057626', 40, 'SYAFAHRUL AKBAR', '2010-05-23', 'GK', 'SMPN 1 CURUG', '2023-08-09 16:05:01.774259', '2023-08-09 16:05:01.774259');
INSERT INTO public.tbl_pemain VALUES ('0095097724', 41, 'MUHAMMAD FAHRI', '2009-03-10', 'DF', 'SMP PELITA NUSA', '2023-08-09 16:10:13.914138', '2023-08-09 16:10:13.914138');
INSERT INTO public.tbl_pemain VALUES ('0097758843', 42, 'FUJI WAHYU SATRIO', '2009-01-25', 'DF', 'SMPN 1 CIKUPA', '2023-08-09 16:12:35.050916', '2023-08-09 16:12:35.050916');
INSERT INTO public.tbl_pemain VALUES ('0084927673', 43, 'GABRIEL MAGENTA', '2008-06-13', 'DF', 'SMKN 1 KABUPATEN TANGERANG', '2023-08-09 16:15:21.36322', '2023-08-09 16:15:21.36322');
INSERT INTO public.tbl_pemain VALUES ('0084553151', 44, 'SEFA ARDIANSYAH', '2008-11-08', 'DF', 'SMAN 27 KABUPATEN TANGERANG', '2023-08-09 16:17:08.424401', '2023-08-09 16:17:08.424401');
INSERT INTO public.tbl_pemain VALUES ('0083620141', 45, 'ADITYA ILHAM', '2008-02-19', 'DF', 'SMAS SIRRUL HIKMAH', '2023-08-09 16:20:24.109544', '2023-08-09 16:20:24.109544');
INSERT INTO public.tbl_pemain VALUES ('0085075344', 46, 'AHWADZ ALBAR', '2008-05-23', 'DF', 'SMAN 24 KABUPATEN TANGERANG', '2023-08-09 16:21:21.083158', '2023-08-09 16:21:21.083158');
INSERT INTO public.tbl_pemain VALUES ('0092676863', 47, 'HAFIZ ZLATAN', '2009-07-28', 'DF', 'SMAS KUTABUMI', '2023-08-09 16:23:01.664663', '2023-08-09 16:23:01.664663');
INSERT INTO public.tbl_pemain VALUES ('0082863042', 49, 'ASWAN FAWWAZ', '2008-10-10', 'DF', 'SMKN 1 KABUPATEN TANGERANG', '2023-08-09 16:26:26.271119', '2023-08-09 16:26:26.271119');
INSERT INTO public.tbl_pemain VALUES ('0082653758', 50, 'ZIAD ILYASA', '2008-12-09', 'DF', 'SMAN 30 KABUPATEN TANGERANG', '2023-08-09 16:30:21.203727', '2023-08-09 16:30:21.203727');
INSERT INTO public.tbl_pemain VALUES ('0086598102', 52, 'QHENZA MAULANA', '2008-09-15', 'MF', 'SMKS MIFTAHUL JANNAH', '2023-08-09 16:33:26.640026', '2023-08-09 16:33:26.640026');
INSERT INTO public.tbl_pemain VALUES ('0086989979', 53, 'RAIHAN ZAKI', '2008-10-28', 'MF', 'SMAN 14 KABUPATEN TANGERANG', '2023-08-09 16:34:42.540787', '2023-08-09 16:34:42.540787');
INSERT INTO public.tbl_pemain VALUES ('0096237878', 54, 'ARIYO SETO', '2009-01-29', 'MF', 'SMPN 1 CURUG', '2023-08-09 16:36:18.822762', '2023-08-09 16:36:18.822762');
INSERT INTO public.tbl_pemain VALUES ('0099181363', 55, 'AHMAD ABROR', '2009-12-07', 'MF', 'SMPN 1 MAUK', '2023-08-09 16:37:54.196142', '2023-08-09 16:37:54.196142');
INSERT INTO public.tbl_pemain VALUES ('0088307428', 56, 'MUHAMMAD ADITYA', '2008-12-13', 'MF', 'SMP ISLAM IBNU SINA', '2023-08-09 16:39:11.44128', '2023-08-09 16:39:11.44128');
INSERT INTO public.tbl_pemain VALUES ('0094279823', 57, 'MUHAMAD ALFAIZ', '2009-03-17', 'MF', 'SMPN 4 TIGARAKSA', '2023-08-09 16:40:27.913015', '2023-08-09 16:40:27.913015');
INSERT INTO public.tbl_pemain VALUES ('0086329831', 58, 'MAHESA RIZKI', '2008-08-17', 'MF', 'SMKN 1 KABUPATEN TANGERANG', '2023-08-09 16:41:54.340709', '2023-08-09 16:41:54.340709');
INSERT INTO public.tbl_pemain VALUES ('0092081244', 59, 'ABGAN FERDINAN', '2009-02-18', 'MF', 'SMPN 1 TIGARAKSA', '2023-08-09 16:42:43.37818', '2023-08-09 16:42:43.37818');
INSERT INTO public.tbl_pemain VALUES ('0098897929', 60, 'JAENAL', '2009-04-19', 'MF', 'SMPN 1 CIKUPA', '2023-08-09 16:44:01.555545', '2023-08-09 16:44:01.555545');
INSERT INTO public.tbl_pemain VALUES ('0088080800', 61, 'ADE HERMAWAN', '2008-12-03', 'FW', 'SMKN 1 KABUPATEN TANGERANG', '2023-08-09 16:45:07.055038', '2023-08-09 16:45:07.055038');
INSERT INTO public.tbl_pemain VALUES ('0098056987', 62, 'M FAKHRI GIOVANSYAH', '2009-04-12', 'FW', 'SMPN 1 CURUG', '2023-08-09 16:46:21.817223', '2023-08-09 16:46:21.817223');
INSERT INTO public.tbl_pemain VALUES ('0096726860', 63, 'ADNAN SYARIF', '2009-05-29', 'FW', 'SMPN 3 TIGARAKSA', '2023-08-09 16:47:35.863682', '2023-08-09 16:47:35.863682');
INSERT INTO public.tbl_pemain VALUES ('0087959666', 64, 'MUHAMAD BILHAQ', '2008-10-07', 'FW', 'SMAN 10 KABUPATEN TANGERANG', '2023-08-09 16:49:14.720296', '2023-08-09 16:49:14.720296');
INSERT INTO public.tbl_pemain VALUES ('0089295384', 65, 'TIVAN IRAWAN', '2008-09-14', 'FW', 'SMAS CENDIKIA ALFALLAH', '2023-08-09 16:50:35.475027', '2023-08-09 16:50:35.475027');
INSERT INTO public.tbl_pemain VALUES ('0081987805', 66, 'MUHAMMAD NAUFAL', '2008-01-19', 'FW', 'SMAN 22 KABUPATEN TANGERANG', '2023-08-09 16:51:40.593494', '2023-08-09 16:51:40.593494');
INSERT INTO public.tbl_pemain VALUES ('0095919243', 67, 'TEGUH PRASETYO', '2009-05-26', 'FW', 'SMPN 2 CIKUPA', '2023-08-09 16:53:56.166025', '2023-08-09 16:53:56.166025');
INSERT INTO public.tbl_pemain VALUES ('0086341319', 68, 'REZA ADRIANO', '2008-09-04', 'FW', 'SMAN 4 KABUPATEN TANGERANG', '2023-08-09 16:54:46.420853', '2023-08-09 16:54:46.420853');
INSERT INTO public.tbl_pemain VALUES ('0099290297', 69, 'NABIL KHOIRON', '2008-11-08', 'FW', 'SMAN 4 KABUPATEN TANGERANG', '2023-08-09 16:55:59.81666', '2023-08-09 16:55:59.81666');
INSERT INTO public.tbl_pemain VALUES ('0085702480', 71, 'REYHAN NURDIANSYAH', '2008-01-07', 'GK', 'SMAN 14 KABUPATEN TANGERANG', '2023-08-09 15:35:52.279697', '2023-08-09 15:35:52.279697');
INSERT INTO public.tbl_pemain VALUES ('0098446398', 32, 'NOUFAL SATRIA AZKA', '2009-09-15', 'GK', 'SMPN 1 RAJEG', '2023-08-09 15:37:38.855601', '2023-08-09 15:37:38.855601');
INSERT INTO public.tbl_pemain VALUES ('0082914887', 33, 'PAHRI MAUL', '2008-03-18', 'GK', 'SMAN 7 KABUPATEN TANGERANG', '2023-08-09 15:41:54.95004', '2023-08-09 15:41:54.95004');
INSERT INTO public.tbl_pemain VALUES ('0092908938', 34, 'FARHAN SEPTI', '2009-12-03', 'GK', 'SMAN 6 KABUPATEN TANGERANG', '2023-08-09 15:51:30.277078', '2023-08-09 15:51:30.277078');
INSERT INTO public.tbl_pemain VALUES ('0095656740', 70, 'FAREL PUTRA S', '2009-09-09', 'FW', 'SMPN 1 PAKUHAJI', '2023-08-09 16:57:12.642096', '2023-08-09 16:57:12.642096');
INSERT INTO public.tbl_pemain VALUES ('0086006326', 35, 'IRHAMSYAH AKBAR', '2008-07-12', 'GK', 'SMAN 14 KABUPATEN TANGERANG', '2023-08-09 15:53:23.1076', '2023-08-09 15:53:23.1076');
INSERT INTO public.tbl_pemain VALUES ('0093798023', 39, 'DAVIAN RAYANA', '2009-12-07', 'GK', 'SMPN 2 CURUG', '2023-08-09 16:03:35.51872', '2023-08-09 16:03:35.51872');
INSERT INTO public.tbl_pemain VALUES ('0089769870', 79, 'MUHAMMAD FATURRAHMAN', '2008-10-10', 'DF', 'SMAN 7 KABUPATEN TANGERANG', '2023-08-22 18:18:03.158379', '2023-08-22 18:18:03.158379');
INSERT INTO public.tbl_pemain VALUES ('0087002934', 51, 'ADE HERMAWAN', '2008-04-04', 'MF', 'SMKN 1 KABUPATEN TANGERANG', '2023-08-09 16:32:33.965421', '2023-08-09 16:32:33.965421');


--
-- TOC entry 3364 (class 0 OID 16424)
-- Dependencies: 220
-- Data for Name: tbl_users; Type: TABLE DATA; Schema: public; Owner: shairul
--

INSERT INTO public.tbl_users VALUES (37, 'chandra', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:40:37.255782', '2023-08-09 14:40:37.255782', false, true);
INSERT INTO public.tbl_users VALUES (38, 'dzaki', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:40:48.636829', '2023-08-09 14:40:48.636829', false, true);
INSERT INTO public.tbl_users VALUES (71, 'reyhan', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 15:35:39.584755', '2023-08-09 15:35:39.584755', false, true);
INSERT INTO public.tbl_users VALUES (32, 'noufal', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:38:41.709865', '2023-08-09 14:38:41.709865', false, true);
INSERT INTO public.tbl_users VALUES (33, 'pahri', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:38:52.852856', '2023-08-09 14:38:52.852856', false, true);
INSERT INTO public.tbl_users VALUES (34, 'farhan', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:39:26.528903', '2023-08-09 14:39:26.528903', false, true);
INSERT INTO public.tbl_users VALUES (35, 'irhamsyah', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:39:40.234624', '2023-08-09 14:39:40.234624', false, true);
INSERT INTO public.tbl_users VALUES (36, 'aldrick', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:40:01.992231', '2023-08-09 14:40:01.992231', false, true);
INSERT INTO public.tbl_users VALUES (39, 'davian', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:41:03.386274', '2023-08-09 14:41:03.386274', false, true);
INSERT INTO public.tbl_users VALUES (40, 'arul', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:41:12.715794', '2023-08-09 14:41:12.715794', false, true);
INSERT INTO public.tbl_users VALUES (41, 'fahri', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:41:37.335143', '2023-08-09 14:41:37.335143', false, true);
INSERT INTO public.tbl_users VALUES (42, 'fuji', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:41:48.339159', '2023-08-09 14:41:48.339159', false, true);
INSERT INTO public.tbl_users VALUES (43, 'gabriel', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:41:57.494229', '2023-08-09 14:41:57.494229', false, true);
INSERT INTO public.tbl_users VALUES (44, 'sefa', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:42:06.490433', '2023-08-09 14:42:06.490433', false, true);
INSERT INTO public.tbl_users VALUES (45, 'aditya', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:42:17.658098', '2023-08-09 14:42:17.658098', false, true);
INSERT INTO public.tbl_users VALUES (46, 'ahwadz', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:42:28.764764', '2023-08-09 14:42:28.764764', false, true);
INSERT INTO public.tbl_users VALUES (47, 'hafiz', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:42:42.232052', '2023-08-09 14:42:42.232052', false, true);
INSERT INTO public.tbl_users VALUES (49, 'aswan', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:43:03.470087', '2023-08-09 14:43:03.470087', false, true);
INSERT INTO public.tbl_users VALUES (50, 'ziad', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:43:14.163986', '2023-08-09 14:43:14.163986', false, true);
INSERT INTO public.tbl_users VALUES (51, 'aldi', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:43:23.088008', '2023-08-09 14:43:23.088008', false, true);
INSERT INTO public.tbl_users VALUES (52, 'qhenza', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:43:38.511936', '2023-08-09 14:43:38.511936', false, true);
INSERT INTO public.tbl_users VALUES (53, 'raihan', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:43:46.105131', '2023-08-09 14:43:46.105131', false, true);
INSERT INTO public.tbl_users VALUES (54, 'ariyo', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:44:02.896533', '2023-08-09 14:44:02.896533', false, true);
INSERT INTO public.tbl_users VALUES (55, 'abror', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:44:10.757852', '2023-08-09 14:44:10.757852', false, true);
INSERT INTO public.tbl_users VALUES (56, 'aditya2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:44:21.09399', '2023-08-09 14:44:21.09399', false, true);
INSERT INTO public.tbl_users VALUES (57, 'alfaiz', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:44:52.864696', '2023-08-09 14:44:52.864696', false, true);
INSERT INTO public.tbl_users VALUES (58, 'mahesa', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:45:02.919547', '2023-08-09 14:45:02.919547', false, true);
INSERT INTO public.tbl_users VALUES (59, 'abgan', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:45:21.872715', '2023-08-09 14:45:21.872715', false, true);
INSERT INTO public.tbl_users VALUES (60, 'jaenal', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:45:28.771275', '2023-08-09 14:45:28.771275', false, true);
INSERT INTO public.tbl_users VALUES (61, 'hermawan', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:45:47.395299', '2023-08-09 14:45:47.395299', false, true);
INSERT INTO public.tbl_users VALUES (62, 'fakhri', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:45:59.3379', '2023-08-09 14:45:59.3379', false, true);
INSERT INTO public.tbl_users VALUES (63, 'adnan', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:46:09.427577', '2023-08-09 14:46:09.427577', false, true);
INSERT INTO public.tbl_users VALUES (64, 'bilhaq', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:46:18.627954', '2023-08-09 14:46:18.627954', false, true);
INSERT INTO public.tbl_users VALUES (65, 'tivan', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:46:29.887753', '2023-08-09 14:46:29.887753', false, true);
INSERT INTO public.tbl_users VALUES (66, 'naufal', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:46:39.75173', '2023-08-09 14:46:39.75173', false, true);
INSERT INTO public.tbl_users VALUES (67, 'teguh', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:46:50.572875', '2023-08-09 14:46:50.572875', false, true);
INSERT INTO public.tbl_users VALUES (68, 'reza', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:47:02.34238', '2023-08-09 14:47:02.34238', false, true);
INSERT INTO public.tbl_users VALUES (69, 'nabil', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:47:10.413466', '2023-08-09 14:47:10.413466', false, true);
INSERT INTO public.tbl_users VALUES (70, 'farel', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 14:48:34.810404', '2023-08-09 14:48:34.810404', false, true);
INSERT INTO public.tbl_users VALUES (73, 'wawan', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'admin', '2023-08-09 17:33:45.822058', '2023-08-09 17:33:45.822058', true, false);
INSERT INTO public.tbl_users VALUES (74, 'mukti', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'admin', '2023-08-09 17:34:47.168467', '2023-08-09 17:34:47.168467', true, false);
INSERT INTO public.tbl_users VALUES (30, 'superadmin', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'superadmin', '2023-08-09 13:55:20.476741', '2023-08-09 13:55:20.476741', true, false);
INSERT INTO public.tbl_users VALUES (79, 'fatur', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-22 16:16:37.955689', '2023-08-22 16:16:37.955689', false, true);
INSERT INTO public.tbl_users VALUES (81, 'shairul', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'admin', '2023-08-29 16:47:42.670257', '2023-08-29 16:47:42.670257', true, false);
INSERT INTO public.tbl_users VALUES (82, 'ferry', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'admin', '2023-09-11 01:57:50.788131', '2023-09-11 01:57:50.788131', true, false);
INSERT INTO public.tbl_users VALUES (83, 'asan', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-09-11 02:02:41.087046', '2023-09-11 02:02:41.087046', false, false);
INSERT INTO public.tbl_users VALUES (84, 'ozy', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'admin', '2023-09-11 02:36:57.524449', '2023-09-11 02:36:57.524449', false, false);


--
-- TOC entry 3376 (class 0 OID 0)
-- Dependencies: 215
-- Name: tbl_admin_id_admin_seq; Type: SEQUENCE SET; Schema: public; Owner: shairul
--

SELECT pg_catalog.setval('public.tbl_admin_id_admin_seq', 11, true);


--
-- TOC entry 3377 (class 0 OID 0)
-- Dependencies: 217
-- Name: tbl_kriteria_id_kriteria_seq; Type: SEQUENCE SET; Schema: public; Owner: shairul
--

SELECT pg_catalog.setval('public.tbl_kriteria_id_kriteria_seq', 61, true);


--
-- TOC entry 3378 (class 0 OID 0)
-- Dependencies: 221
-- Name: tbl_users_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: shairul
--

SELECT pg_catalog.setval('public.tbl_users_id_user_seq', 84, true);


--
-- TOC entry 3203 (class 2606 OID 16436)
-- Name: tbl_admin tbl_admin_pkey; Type: CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_admin
    ADD CONSTRAINT tbl_admin_pkey PRIMARY KEY (id_admin);


--
-- TOC entry 3205 (class 2606 OID 16438)
-- Name: tbl_kriteria tbl_kriteria_pkey; Type: CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_kriteria
    ADD CONSTRAINT tbl_kriteria_pkey PRIMARY KEY (id_kriteria);


--
-- TOC entry 3207 (class 2606 OID 16440)
-- Name: tbl_nilai_kriteria tbl_nilai_kriteria_pkey; Type: CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_nilai_kriteria
    ADD CONSTRAINT tbl_nilai_kriteria_pkey PRIMARY KEY (nisn, id_kriteria);


--
-- TOC entry 3209 (class 2606 OID 16442)
-- Name: tbl_pemain tbl_pemain_pkey; Type: CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_pemain
    ADD CONSTRAINT tbl_pemain_pkey PRIMARY KEY (nisn);


--
-- TOC entry 3211 (class 2606 OID 16444)
-- Name: tbl_users tbl_users_pkey; Type: CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_users
    ADD CONSTRAINT tbl_users_pkey PRIMARY KEY (id_user);


--
-- TOC entry 3212 (class 2606 OID 16445)
-- Name: tbl_admin tbl_admin_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_admin
    ADD CONSTRAINT tbl_admin_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.tbl_users(id_user);


--
-- TOC entry 3213 (class 2606 OID 16450)
-- Name: tbl_nilai_kriteria tbl_nilai_kriteria_id_kriteria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_nilai_kriteria
    ADD CONSTRAINT tbl_nilai_kriteria_id_kriteria_fkey FOREIGN KEY (id_kriteria) REFERENCES public.tbl_kriteria(id_kriteria);


--
-- TOC entry 3214 (class 2606 OID 16455)
-- Name: tbl_nilai_kriteria tbl_nilai_kriteria_nisn_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_nilai_kriteria
    ADD CONSTRAINT tbl_nilai_kriteria_nisn_fkey FOREIGN KEY (nisn) REFERENCES public.tbl_pemain(nisn) ON DELETE CASCADE;


--
-- TOC entry 3215 (class 2606 OID 16460)
-- Name: tbl_pemain tbl_pemain_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_pemain
    ADD CONSTRAINT tbl_pemain_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.tbl_users(id_user);


-- Completed on 2023-09-11 20:37:49

--
-- PostgreSQL database dump complete
--

