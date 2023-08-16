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
    nisn character varying(10) NOT NULL,
    id_kriteria integer NOT NULL,
    nilai numeric(5,2)
);


ALTER TABLE public.tbl_nilai_kriteria OWNER TO shairul;

--
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

INSERT INTO public.tbl_admin VALUES (6, 30, 'SUPERADMIN', '1970-01-04', 'Head Coach', '2023-08-09 13:55:56.273797', '2023-08-09 13:55:56.273797');
INSERT INTO public.tbl_admin VALUES (7, 73, 'WAWAN HENDRA', '1970-03-17', 'Head Coach', '2023-08-09 17:34:06.823263', '2023-08-09 17:34:06.823263');
INSERT INTO public.tbl_admin VALUES (8, 74, 'MUKTI HERIANSYAH', '1981-10-13', 'Asst. Coach', '2023-08-09 18:13:00.872024', '2023-08-09 18:13:00.872024');


--
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
INSERT INTO public.tbl_kriteria VALUES (56, 'CFW13', 'Serenity', 'FW', 'benefit', 0.07);


--
-- Data for Name: tbl_nilai_kriteria; Type: TABLE DATA; Schema: public; Owner: shairul
--

INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 8, 15.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 9, 176.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 10, 90.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 11, 87.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 12, 77.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 13, 80.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 14, 78.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 15, 65.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 16, 80.00);
INSERT INTO public.tbl_nilai_kriteria VALUES ('0085702480', 17, 85.00);


--
-- Data for Name: tbl_pemain; Type: TABLE DATA; Schema: public; Owner: shairul
--

INSERT INTO public.tbl_pemain VALUES ('0086006326', 35, 'IRHAMSYAH AKBAR', '2008-07-12', 'GK', 'SMAN 14 KABUPATEN TANGERANG', '2023-08-09 15:53:23.1076', '2023-08-09 15:53:23.1076');
INSERT INTO public.tbl_pemain VALUES ('0083603701', 36, 'ALDRICK ANUGERAH', '2008-10-01', 'GK', 'SMAS PGRI LEGOK', '2023-08-09 15:57:45.505849', '2023-08-09 15:57:45.505849');
INSERT INTO public.tbl_pemain VALUES ('0084596941', 37, 'CHANDRA TRI', '2008-04-04', 'GK', 'SMAN 17 KABUPATEN TANGERANG', '2023-08-09 15:59:52.20111', '2023-08-09 15:59:52.20111');
INSERT INTO public.tbl_pemain VALUES ('0086243601', 38, 'MOCHAMAD DZAKI', '2008-09-30', 'GK', 'SMAS YUPPENTEK 3', '2023-08-09 16:02:00.418973', '2023-08-09 16:02:00.418973');
INSERT INTO public.tbl_pemain VALUES ('0093798023', 39, 'DAVIAN RAYANA', '2009-12-07', 'GK', 'SMPN 1 CURUG', '2023-08-09 16:03:35.51872', '2023-08-09 16:03:35.51872');
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
INSERT INTO public.tbl_pemain VALUES ('0087002934', 51, 'MUHAMAD ALDI', '2008-04-04', 'MF', 'SMKN 1 KABUPATEN TANGERANG', '2023-08-09 16:32:33.965421', '2023-08-09 16:32:33.965421');
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


--
-- Data for Name: tbl_users; Type: TABLE DATA; Schema: public; Owner: shairul
--

INSERT INTO public.tbl_users VALUES (30, 'superadmin', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'admin', '2023-08-09 13:55:20.476741', '2023-08-09 13:55:20.476741', true, false);
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
INSERT INTO public.tbl_users VALUES (72, 'shairul', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-09 17:32:07.288445', '2023-08-09 17:32:07.288445', false, false);
INSERT INTO public.tbl_users VALUES (73, 'wawan', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'admin', '2023-08-09 17:33:45.822058', '2023-08-09 17:33:45.822058', true, false);
INSERT INTO public.tbl_users VALUES (74, 'mukti', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'admin', '2023-08-09 17:34:47.168467', '2023-08-09 17:34:47.168467', true, false);
INSERT INTO public.tbl_users VALUES (77, 'fatur', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'user', '2023-08-15 11:33:40.004021', '2023-08-15 11:33:40.004021', false, true);


--
-- Name: tbl_admin_id_admin_seq; Type: SEQUENCE SET; Schema: public; Owner: shairul
--

SELECT pg_catalog.setval('public.tbl_admin_id_admin_seq', 8, true);


--
-- Name: tbl_kriteria_id_kriteria_seq; Type: SEQUENCE SET; Schema: public; Owner: shairul
--

SELECT pg_catalog.setval('public.tbl_kriteria_id_kriteria_seq', 56, true);


--
-- Name: tbl_users_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: shairul
--

SELECT pg_catalog.setval('public.tbl_users_id_user_seq', 77, true);


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
    ADD CONSTRAINT tbl_nilai_kriteria_nisn_fkey FOREIGN KEY (nisn) REFERENCES public.tbl_pemain(nisn) ON DELETE CASCADE;


--
-- Name: tbl_pemain tbl_pemain_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shairul
--

ALTER TABLE ONLY public.tbl_pemain
    ADD CONSTRAINT tbl_pemain_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.tbl_users(id_user);


--
-- PostgreSQL database dump complete
--
