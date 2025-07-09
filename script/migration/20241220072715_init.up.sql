CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS public.c_menu
(
    id character varying(36) COLLATE pg_catalog."default" NOT NULL DEFAULT uuid_generate_v4(),
    name character varying COLLATE pg_catalog."default",
    link character varying(100) COLLATE pg_catalog."default",
    icon character varying(50) COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    permission_label character varying(50) COLLATE pg_catalog."default",
    action character varying(50) COLLATE pg_catalog."default",
    level integer,
    seq integer,
    created_by character varying(36) COLLATE pg_catalog."default",
    created_at timestamp without time zone,
    updated_by character varying(36) COLLATE pg_catalog."default",
    updated_at timestamp without time zone,
    is_deleted boolean DEFAULT false,
    parent_id character varying(36) COLLATE pg_catalog."default",
    CONSTRAINT c_menu_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.auth_role
(
    id character varying(10) COLLATE pg_catalog."default" NOT NULL,
    name character varying(100) COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    CONSTRAINT auth_role_pkey PRIMARY KEY (id),
    CONSTRAINT auth_role_name_key UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS public.c_menu_role
(
    id character varying(36) COLLATE pg_catalog."default" NOT NULL DEFAULT uuid_generate_v4(),
    menu_id character varying(36) COLLATE pg_catalog."default",
    role_id character varying(36) COLLATE pg_catalog."default",
    permission character varying(50) COLLATE pg_catalog."default",
    created_at timestamp without time zone DEFAULT now(),
    commodity_id integer,
    CONSTRAINT c_menu_role_pk PRIMARY KEY (id),
    CONSTRAINT c_menu_role_menu_id_fkey FOREIGN KEY (menu_id)
        REFERENCES public.c_menu (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT c_menu_role_role_id_fkey FOREIGN KEY (role_id)
        REFERENCES public.auth_role (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

-- public.auth_user definition

-- Drop table

-- DROP TABLE public.auth_user;

CREATE TABLE public.auth_user (
	id varchar(36) NOT NULL,
	"name" varchar(255) NULL,
	username varchar(255) NOT NULL,
	email varchar(100) NULL,
	"password" varchar(60) NOT NULL,
	role_id varchar(36) NOT NULL,
	person_id int4 NULL,
	status varchar(1) NULL,
	foto varchar NULL,
	active bool DEFAULT true NULL,
	created_by varchar(36) NULL,
	created_at timestamp NULL,
	updated_by varchar(36) NULL,
	updated_at timestamp NULL,
	deleted_at timestamptz NULL,
	is_deleted bool DEFAULT false NULL,
	commodity_id int4 NULL,
	confidence_absensi int4 NULL,
	confidence_daftar int4 NULL,
	status_ekspresi bool NULL,
	ekspresi_smile int4 NULL,
	ekspresi_eyes int4 NULL,
	lock_lokasi bool NULL,
	lock_login bool NULL,
	manual_produksi_tph bool NULL,
	manual_produksi_pabrik bool NULL,
	toleh_kanan bool NULL,
	toleh_kiri bool NULL,
	pabrik_id int4 NULL,
	"trigger" bool DEFAULT false NULL,
	tracehold float8 DEFAULT 1.0 NULL,
	CONSTRAINT auth_user_email_unique UNIQUE (email),
	CONSTRAINT auth_user_pkey PRIMARY KEY (id),
	CONSTRAINT auth_user_username_unique UNIQUE (username)
);


-- public.auth_user foreign keys

ALTER TABLE public.auth_user ADD CONSTRAINT auth_user_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.auth_role(id);

INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('30ce74aa-a99f-40b3-9666-3fbef030fa5b', 'Jam  Kerja', '/master/jam-kerja', 'PointIcon', 'Menu  Jam Kerja', 'JAM_KERJA', 'VIEW,CREATE,UPDATE,DELETE', 2, 2, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2024-12-30 13:12:52.169', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-02 10:52:33.361', false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('c431db7d-7e92-4965-8b81-741c9627a9e1', 'Atur Jadwal Jam Kerja', '/mapping/atur-jam-kerja', 'PointIcon', '   Atur Jadwal Jam Kerja', 'ATUR_JADWAL_JAM_KERJA', 'VIEW,CREATE,DELETE,UPDATE', 2, 2, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-02 12:46:49.485', NULL, NULL, false, '12ffe181-18cf-4b52-ab92-c466cd54bb6a');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('1f0fef05-fda4-4fc2-a954-935075a7e136', 'User', '/pengaturan/user', 'PointIcon', 'Menu Pengaturan User', 'USER', 'VIEW,CREATE,UPDATE,DELETE', 2, 1, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2024-12-17 15:12:51.282', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2024-12-18 09:28:15.401', false, '2c1bad8c-99a5-45b9-b349-c717d68616ee');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('edd59047-3ec9-45ab-91f0-85e656986654', 'Menu', '/pengaturan/menu', 'PointIcon', 'Menu Pengaturan Menu', 'MENU', 'VIEW,CREATE,UPDATE,DELETE', 2, 2, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2024-12-17 15:14:34.853', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2024-12-18 09:28:25.100', false, '2c1bad8c-99a5-45b9-b349-c717d68616ee');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('682af65a-bd6e-4796-9c9a-d078a4f2bf47', 'Mandor', '/master/hr-mandor', 'PointIcon', 'MENU HR MANDOR', 'HRMANDOR', 'VIEW,CREATE,UPDATE,DELETE', 2, 1, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2024-12-31 10:50:39.464', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-02 12:45:10.427', false, '12ffe181-18cf-4b52-ab92-c466cd54bb6a');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('c466bca9-10f3-47c9-afa2-8f258a89389c', 'Jabatan', '/master/jabatan', 'PointIcon', 'Menu Master Jabatan', 'JABATAN', 'VIEW,CREATE,UPDATE,DELETE', 2, 6, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2024-12-18 15:56:14.335', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-03 08:52:04.879', false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('cfddc1b1-e9ea-4e12-b72b-ebfbf6433f88', 'Kebun', '/master/kebun', 'PointIcon', 'Master Data Kebun', 'KEBUN', 'VIEW,CREATE,UPDATE,DELETE', 2, 8, '61da883c-cef4-11ee-b56c-676fc742392f', '2024-12-19 12:58:55.609', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-03 08:53:01.914', false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('70c16c30-1de1-4c41-87b3-bc4e1f87e29e', 'Golongan', '/master/golongan', 'PointIcon', 'Menu Master Data Golongan', 'GOLONGAN', 'VIEW,CREATE,UPDATE,DELETE', 2, 11, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2024-12-20 14:15:10.150', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-03 08:54:05.507', false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('298bdb15-97a5-42bf-a388-5f7d4f0eccb1', 'Data Pegawai', '/master/pegawai', 'PointIcon', 'Menu  Data Pegawai', 'PEGAWAI', 'VIEW,CREATE,UPDATE,DELETE', 2, 1, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2024-12-17 15:16:17.140', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-02 10:50:47.992', false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('ab811af9-0f13-4159-8228-e234581c4f47', 'Presensi', '#', 'UserPinIcon', 'Presensi', 'PRESENSI', 'VIEW', 1, 3, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-02 11:25:21.302', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-02 11:29:12.122', false, NULL);
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('1a894cb0-e41c-4fad-913a-f343c9a82597', 'Hari Kerja', '/master/hari-kerja', 'PointIcon', 'Hari Kerja', 'HARIKERJA', 'VIEW,CREATE,UPDATE,DELETE', 2, 3, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2024-12-24 14:46:38.505', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-02 10:52:46.870', false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('152dd5a3-2b28-4849-91bf-35e8d1820d61', 'Rekapitulasi Presensi', '/presensi/rekap-presensi', 'PointIcon', '   Rekapitulasi Presensi', 'REKAP_PRESENSI', 'VIEW', 2, 2, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-02 12:43:59.310', NULL, NULL, false, 'ab811af9-0f13-4159-8228-e234581c4f47');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('4a9dad4f-bdd0-4a6a-bea6-89ba821092e9', 'Lokasi', '/master/lokasi', 'PointIcon', 'Lokasi', 'LOKASI', 'VIEW,CREATE,UPDATE,DELETE', 2, 5, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-02 11:11:19.506', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-02 11:11:58.010', false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('3ef0adb5-7f25-407e-8be5-4a6c5a0114a0', 'Atur Lokasi', '/mapping/atur-lokasi', 'PointIcon', ' Atur Lokasi', 'ATUR_LOKASI', 'VIEW,CREATE,UPDATE,DELETE', 2, 3, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-02 12:48:11.454', NULL, NULL, false, '12ffe181-18cf-4b52-ab92-c466cd54bb6a');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('c4285da7-28bc-41a7-917e-424cbb2bec8d', 'Regional', '/master/regional', 'PointIcon', 'Menu Master Regional', 'REGIONAL', 'VIEW,CREATE,UPDATE,DELETE', 2, 7, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2024-12-19 12:53:05.913', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-03 08:52:30.018', false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('8e8f55a1-02ae-48c7-a9d3-86d994b45b13', 'Komoditas', '/master/komoditas', 'PointIcon', 'Master Data Komoditas', 'KOMODITAS', 'VIEW,CREATE,UPDATE,DELETE', 2, 9, '61da883c-cef4-11ee-b56c-676fc742392f', '2024-12-19 13:00:10.792', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-03 08:53:21.930', false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('0699c49d-acf6-46e2-b71e-9ecc40299f35', 'Truk', '/master/truk', 'PointIcon', 'Master Truk', 'TRUK', 'VIEW,CREATE,UPDATE,DELETE', 2, 12, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-20 15:25:29.203', NULL, NULL, false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('33d00eb2-caaf-4ae3-b2ba-9dcfe49c8e7c', 'Log absen', '/presensi/log-absen', 'PointIcon', '   Log absen', 'LOG_ABSEN', 'VIEW', 2, 1, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-02 12:42:57.863', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-17 14:05:07.279', false, 'ab811af9-0f13-4159-8228-e234581c4f47');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('8bd58d19-be48-497f-be97-cfcf5d0bbff9', 'Wadah Panen', '/master/wadah-panen', 'PointIcon', 'WADAH PANEN', 'WADAH_PANEN', 'VIEW,CREATE,UPDATE,DELETE', 2, 13, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-21 13:12:27.978', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-21 13:19:16.302', false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('056ca3a6-2847-45d4-8920-a92f73fb52d2', 'Tph', '/master/tph', 'PointIcon', 'Master TPH', 'TPH', 'VIEW,CREATE,UPDATE,DELETE', 2, 13, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-20 16:38:39.668', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-21 13:34:05.188', false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('2c1bad8c-99a5-45b9-b349-c717d68616ee', 'Pengaturan', '#', 'SettingsIcon', 'Menu Pengaturan', 'PENGATURAN', 'VIEW', 1, 7, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2024-12-17 14:57:27.507', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-02-07 16:14:52.705', false, NULL);
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('0d373001-9dd6-4f2e-8d78-31ef4bb5bb48', 'Kategori Produk', '/master/kategori-produk', 'PointIcon', 'Kategori Produk', 'KATEGORI_PRODUK', 'VIEW,CREATE,UPDATE,DELETE', 2, 15, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-21 15:11:30.689', NULL, NULL, false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('804dc040-8882-4b3a-b54d-14635c27a2c2', 'Konfigurasi', '#', 'Settings2Icon', 'Menu Konfigurasi', 'KONFIGURASI', 'VIEW', 1, 7, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-02 10:45:10.838', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 14:42:08.183', false, NULL);
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('aa30981f-f4b6-4a0c-a08b-d9fb4c9b9d04', 'Location Code', '/master/location-code', 'PointIcon', 'Menu Location Code', 'LOCATION_CODE', 'VIEW,CREATE,UPDATE,DELETE', 2, 4, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2024-12-20 08:28:56.087', '5ae695bc-74b5-4afd-a8a2-22b436cee282', '2025-03-17 12:08:30.580', false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('b89c8f3a-b192-49fd-a7e9-119638cd4d06', 'Afdeling', '/master/afdeling', 'PointIcon', 'Menu Master Data Afdeling', 'AFDELING', 'VIEW,CREATE,UPDATE,DELETE', 2, 10, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2024-12-20 08:28:07.682', '5ae695bc-74b5-4afd-a8a2-22b436cee282', '2025-05-14 21:33:30.086', false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('a7e26426-c27b-4fb0-bdb5-f1b43297de11', 'Master Data', '#', 'ListIcon', 'Menu Master Data', 'MASTER_DATA', 'VIEW,UPDATE,CREATE,DELETE', 1, 2, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2024-12-17 14:53:59.157', '5ae695bc-74b5-4afd-a8a2-22b436cee282', '2025-05-14 21:44:25.640', false, NULL);
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('56c47256-8bf8-482e-a67e-36290f1f19ee', 'Dashboard', '/dashboard', 'ApertureIcon', 'Menu Dashboard', 'DASHBOARD', 'VIEW,UPDATE,CREATE,DELETE', 1, 1, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2024-12-17 06:41:50.683', '5ae695bc-74b5-4afd-a8a2-22b436cee282', '2025-05-14 21:44:39.578', false, NULL);
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('d932f807-bf63-4e13-8110-fb006c93b447', 'Produk', '/master/produk', 'PointIcon', 'Menu Produk', 'PRODUK', 'VIEW,CREATE,UPDATE,DELETE', 2, 16, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-22 13:19:34.004', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-22 13:19:47.000', false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('4603cca9-edbc-42db-9606-11bc145c7ecf', 'Jenis Aktivitas', '/master/jenis-aktivitas', 'PointIcon', 'Master Jenis Aktivitas', 'JENIS_AKTIVITAS', 'VIEW,CREATE,UPDATE,DELETE', 2, 14, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-24 13:33:13.163', NULL, NULL, false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('95c9165f-b03f-4deb-8713-142739cd4fac', 'Jenis Panen', '/master/jenis-panen', 'PointIcon', 'JENIS_PANEN', 'JENIS_PANEN', 'VIEW,CREATE,UPDATE,DELETE', 2, 14, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-21 14:30:43.480', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-30 13:46:14.461', false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('21b25999-03cd-498c-a9e4-9b3e629dda59', 'Rekapitulasi Produksi', '/prestasi/rekap-produksi/karet', 'PointIcon', 'Menu Rekap Produksi Karet', 'REKAP_PRODUKSI_KARET', 'VIEW', 2, 1, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-30 17:30:02.581', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-02-07 16:05:05.079', false, '9383b490-dc68-4479-9d23-1372fb42d557');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('e7ba24c1-92b5-4723-8f2d-abe76a5c3f8e', 'BKM', '/report/bkm', 'PointIcon', 'Menu Report BKM', 'BKM', 'VIEW', 2, 1, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-02-07 16:19:36.812', NULL, NULL, false, 'a07dcc4a-7af3-4aac-9482-216a66e7fb9b');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('b0d30610-caad-4508-adbc-f1115c30fc29', 'Rule Approval', '/pengaturan/rule-approval', 'PointIcon', 'Menu Rule Approval', 'RULE_APPROVAL', 'VIEW,CREATE,UPDATE,DELETE', 2, 3, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-02-25 10:24:37.638', NULL, NULL, false, '2c1bad8c-99a5-45b9-b349-c717d68616ee');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('2a8cb1ee-9e34-441e-accd-9457b41305c1', 'Bak', '/master/bak', 'PointIcon', 'Master Bak', 'BAK', 'VIEW,CREATE,UPDATE,DELETE', 2, 20, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-02-26 10:41:46.928', NULL, NULL, false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('9383b490-dc68-4479-9d23-1372fb42d557', 'Prestasi Karet', '#', 'trophyIcon', 'Menu Prestasi Karet', 'PRESTASI', 'VIEW', 1, 4, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-30 17:25:49.422', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-02-07 15:59:28.195', false, NULL);
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('f3b248d2-8fa2-4385-8f4e-6e20560bf842', 'Pemasok', '/master/pemasok', 'PointIcon', 'Menu Pemasok', 'PEMASOK', 'VIEW,CREATE,UPDATE,DELETE', 2, 17, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-22 15:00:49.496', NULL, '2025-02-11 09:06:42.482', true, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('ee19e628-3b71-4ac4-8e6a-bb7841cd7aff', 'Petani/Pemasok', '/master/petani-pemasok', 'PointIcon', 'Master Petani', 'PETANI', 'VIEW,UPDATE,CREATE,DELETE', 2, 18, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-22 15:44:15.511', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-02-11 09:07:18.490', false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('c2c6a9a1-3b76-405c-8d6c-50161d2e3fd3', 'List Produksi Karet Basah', '/prestasi/list-karet-basah', 'PointIcon', 'List Produksi Karet Basah', 'PRODUKSI_KARET_BASAH', 'VIEW,DELETE,CREATE,UPDATE', 2, 3, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-02-28 16:18:41.982', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-02-28 16:20:23.590', false, '9383b490-dc68-4479-9d23-1372fb42d557');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('61bb02a1-b91a-45a9-b727-23f1cbddb9aa', 'Prestasi Kopi', '#', 'trophyIcon', 'Prestasi Kopi Menu', 'PRESTASI', 'VIEW', 1, 5, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-02-13 10:42:35.285', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-02-13 10:44:50.983', false, NULL);
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('f9640347-b9a8-4afe-8ef2-db4bb2be462a', 'List Produksi Kopi Basah', '/prestasi/list-kopi-basah', 'PointIcon', 'List Produksi Kopi Basah', 'PRODUKSI_KOPI_BASAH', 'VIEW', 2, 2, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-03-03 11:23:50.445', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-03-03 11:25:16.563', false, '61bb02a1-b91a-45a9-b727-23f1cbddb9aa');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('7bb8b836-31d5-43ec-9d39-6cff5ab2c25c', 'List Produksi Kopi', '/prestasi/produksi-kopi', 'PointIcon', 'Menu Master Prestasi Kopi', 'PRODUKSI_KOPI', 'VIEW,CREATE,UPDATE,DELETE', 2, 1, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-02-13 10:47:13.070', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-03-03 11:25:37.237', false, '61bb02a1-b91a-45a9-b727-23f1cbddb9aa');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('7b2fb3a9-eabf-4866-8d9d-537f53a4609e', 'List Produksi Teh Basah', '/prestasi/list-teh-basah', 'PointIcon', 'Menu Produksi Teh Basah', 'PRODUKSI_TEH_BASAH', 'VIEW,CREATE,DELETE,UPDATE', 2, 3, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-03-03 10:47:55.153', '5ae695bc-74b5-4afd-a8a2-22b436cee282', '2025-05-14 21:31:42.628', false, '202813ae-a9c3-46ff-a37f-796571ab7870');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('202813ae-a9c3-46ff-a37f-796571ab7870', 'Prestasi Teh', '#', 'trophyIcon', 'Menu Prestasi Teh', 'PRESTASI', 'VIEW,CREATE,UPDATE,DELETE', 1, 4, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-02-07 16:00:29.159', '5ae695bc-74b5-4afd-a8a2-22b436cee282', '2025-06-10 13:14:21.489', false, NULL);
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('b6b362a0-a61c-4758-b7d5-ef8e3687d7f3', 'Rekapitulasi Produksi	', '/prestasi/rekap-produksi/teh', 'PointIcon', 'Rekapitulasi Produksi Teh	', 'REKAP_PRODUKSI_TEH', 'VIEW,CREATE,UPDATE,DELETE', 2, 2, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-02-07 11:05:56.688', '5ae695bc-74b5-4afd-a8a2-22b436cee282', '2025-06-10 13:14:37.794', false, '202813ae-a9c3-46ff-a37f-796571ab7870');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('9aae36ed-33c6-4fd2-bf0f-13b6aa4833d7', 'Pabrik', '/master/pabrik', 'PointIcon', 'MENU MASTER PABRIK', 'PABRIK', 'VIEW,CREATE,UPDATE,DELETE', 2, 19, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-02-10 10:48:15.516', '5ae695bc-74b5-4afd-a8a2-22b436cee282', '2025-05-14 21:56:21.362', false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('767c3205-49b0-41d5-bf52-3c2e98c28827', 'List Penerimaan Pabrik Teh', '/prestasi/produksi-teh', 'PointIcon', 'Menu Produksi Teh Penerimaan', 'PRODUKSI_TEH', 'VIEW,CREATE,UPDATE,DELETE', 2, 3, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-02-07 14:37:50.451', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-05-19 08:42:10.345', false, '202813ae-a9c3-46ff-a37f-796571ab7870');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('a07dcc4a-7af3-4aac-9482-216a66e7fb9b', 'Report', '#', 'VocabularyIcon', 'Menu Report', 'REPORT', 'VIEW', 1, 12, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-02-07 16:17:50.908', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:00:51.110', false, NULL);
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('cb1664d3-90a2-4732-bd9e-e69e42d72c21', 'List Produksi Karet', '/prestasi/list-karet-poduksi', 'PointIcon', 'List Produksi Karet', 'PRODUKSI_KARET_LIST', 'VIEW', 2, 4, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-03-05 14:45:54.433', NULL, NULL, false, '9383b490-dc68-4479-9d23-1372fb42d557');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('12ffe181-18cf-4b52-ab92-c466cd54bb6a', 'Mapping Karyawan', '#', 'UserPlusIcon', 'Mapping Karyawan', 'MAPPINGKARYAWAN', 'VIEW,UPDATE,CREATE,DELETE', 1, 5, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-01-02 11:27:15.679', 'cabfaa42-4a0d-4b32-9753-0ba173b3d622', '2025-03-11 00:31:20.213', false, NULL);
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('1e3d413f-49dd-4e27-9aeb-0fe4ab786d3c', 'Sheeter', '/master/sheeter	', 'PointIcon', 'Menu Sheeter', 'SHEETER', 'VIEW,CREATE,UPDATE,DELETE', 2, 21, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-04-24 13:11:03.549', NULL, NULL, false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('20cb8775-bbb6-40fc-90a0-4162a891ea64', 'Lori', '/master/lori', 'PointIcon', 'Lori', 'LORI', 'VIEW,CREATE,UPDATE,DELETE', 2, 22, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-04-24 13:31:54.175', NULL, NULL, false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('10d0c8f0-e519-4041-8a5e-6036d581af6f', 'Ruang Asap', '/master/ruang-asap', 'PointIcon', 'Ruang Asap', 'RUANG_ASAP', 'VIEW,CREATE,UPDATE,DELETE', 2, 23, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-04-24 13:34:44.139', NULL, NULL, false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('648f1174-9b13-4d55-88f4-5846b8a12efb', 'List Penerimaan Pabrik', '/prestasi/produksi-karet', 'PointIcon', 'Menu List Produksi Karet', 'PRODUKSI_KARET', 'VIEW,CREATE,UPDATE,DELETE', 2, 2, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-02-06 09:43:56.847', '5ae695bc-74b5-4afd-a8a2-22b436cee282', '2025-05-14 21:40:09.423', false, '9383b490-dc68-4479-9d23-1372fb42d557');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('533c3f52-712c-4b1a-bd4d-fdf8434c43b2', 'Jenis Pengolahan', '/master/jenis-pengolahan', 'PointIcon', NULL, 'JENIS_PENGOLAHAN', 'VIEW,CREATE,UPDATE,DELETE', 2, 24, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-05-21 08:28:48.964', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-05-21 08:29:29.400', false, '804dc040-8882-4b3a-b54d-14635c27a2c2');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('79ab7b75-c141-4b97-89de-6b9dc9a53028', 'Prestasi Kopi', '#', 'trophyIcon', 'Menu Prestasi Kopi', 'PRESTASI', 'VIEW', 1, 6, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 14:43:03.449', NULL, '2025-06-02 14:43:47.366', true, NULL);
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('09fa34f5-6394-4689-9c02-d0c7d202209a', 'Bokar', '#', 'trophyIcon', 'BOKAR', 'BOKAR', 'VIEW', 1, 6, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 14:35:26.907', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 14:44:31.145', false, NULL);
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('64d3ddf3-bb5b-4847-8a13-0606bd45abe4', 'Kartu Stok', '/report/kartu-stok', 'PointIcon', 'Menu Report Kartu Stok', 'KARTU_STOK', 'VIEW', 2, 2, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:00:21.528', NULL, NULL, false, 'a07dcc4a-7af3-4aac-9482-216a66e7fb9b');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('844c6547-55e3-41e7-8e05-25908211d185', 'Karet Pengolahan', '#', 'trophyIcon', 'Karet Pengolahan', 'DATA_PENGOLAHAN_PABRIK', 'VIEW', 1, 9, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:03:00.394', NULL, NULL, false, NULL);
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('6af37da4-b5b9-4579-a187-a574d3c50be1', 'Teh Pengolahan', '#', 'trophyIcon', 'Teh Pengolahan', 'DATA_PENGOLAHAN_PABRIK', 'VIEW', 1, 10, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:03:51.634', NULL, NULL, false, NULL);
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('53e1efe3-6b2f-40ab-88e8-4a8f570d8b70', 'Kopi Pengolahan', '#', 'trophyIcon', 'Kopi Pengolahan', 'DATA_PENGOLAHAN_PABRIK', 'VIEW', 1, 11, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:04:36.684', NULL, NULL, false, NULL);
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('8692feb7-d67d-4877-8617-782de0e26261', 'Head Monitoring', '#', 'trophyIcon', 'Head Monitoring', 'DATA_PENGOLAHAN_PABRIK', 'VIEW', 1, 8, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:02:08.997', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:05:36.406', false, NULL);
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('8b642f13-8bcd-4305-a890-ce3926a63336', 'Tap Inspeksi', '/prestasi/tap-inspeksi', 'PointIcon', 'Menu Data Tap Inspeksi', 'TAP_INSPEKSI', 'VIEW', 2, 1, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:08:11.395', NULL, NULL, false, '8692feb7-d67d-4877-8617-782de0e26261');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('0a436993-f400-4832-bd37-e28840e19d97', 'SIR Palet', '/prestasi/sir-palet', 'PointIcon', 'Menu SIR Palet', 'SIR_PALET', 'VIEW', 2, 5, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:12:31.279', NULL, NULL, false, '844c6547-55e3-41e7-8e05-25908211d185');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('28fda96b-62a6-4163-bbc1-fe086c059de9', 'SIR Pengiriman', '/prestasi/sir-pengiriman', 'PointIcon', 'Menu SIR Pengiriman', 'PENGIRIMAN_SIR', 'VIEW', 2, 12, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:13:31.572', NULL, NULL, false, '844c6547-55e3-41e7-8e05-25908211d185');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('932ee7e9-11dc-4120-8093-9da3183a4aba', 'RSS Pengiriman', '/prestasi/pengiriman-rss', 'PointIcon', 'Menu RSS Pengiriman', 'PENGIRIMAN_RSS', 'VIEW', 2, 11, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:14:39.888', NULL, NULL, false, '844c6547-55e3-41e7-8e05-25908211d185');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('61865328-3288-4d85-a8be-70eaf4ee352c', 'BAST', '/prestasi/bast', 'PointIcon', 'Menu BAST', 'LIST_BAST', 'VIEW', 2, 10, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:15:23.966', NULL, NULL, false, '844c6547-55e3-41e7-8e05-25908211d185');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('481728dc-c773-4434-8316-c7eff38d8f53', 'Packing', '/prestasi/packing', 'PointIcon', 'Menu Packing', 'LIST_PACKING', 'VIEW', 2, 9, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:16:11.157', NULL, NULL, false, '844c6547-55e3-41e7-8e05-25908211d185');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('10a985de-293e-4cb5-8031-8bedb37aa3ef', 'Sortasi', '/prestasi/sortasi', 'PointIcon', 'Menu Sortasi', 'LIST_SORTASI', 'VIEW', 2, 8, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:17:26.563', NULL, NULL, false, '844c6547-55e3-41e7-8e05-25908211d185');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('90f2da9b-e205-4792-81ac-d013a05e4e91', 'Turun Pengasapan', '/prestasi/turun-pengasapan', 'PointIcon', 'Menu Turun Pengasapan', 'LIST_TURUNPENGASAPAN', 'VIEW', 2, 7, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:18:31.125', NULL, NULL, false, '844c6547-55e3-41e7-8e05-25908211d185');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('bd58f76d-06a1-4ed1-82f6-539adb1b595b', 'Pengasapan', '/prestasi/pengasapan', 'PointIcon', 'Menu Pengasapan', 'LIST_PENGASAPAN', 'VIEW', 2, 6, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:19:13.204', NULL, NULL, false, '844c6547-55e3-41e7-8e05-25908211d185');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('1502e99f-3593-4a45-a16c-1a28976f0378', 'Penggilingan Lori', '/prestasi/penggilingan-lori', 'PointIcon', 'Menu Penggilingan Lori', 'LIST_PENGGILINGAN_LORI', 'VIEW', 2, 3, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:20:22.201', NULL, NULL, false, '844c6547-55e3-41e7-8e05-25908211d185');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('b17b3c86-5819-4273-8eb5-f485db743bbf', 'Penggilingan', '/prestasi/penggilingan', 'PointIcon', 'Menu Penggilingan', 'LIST_PENGGILINGAN', 'VIEW', 2, 2, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:21:03.734', NULL, NULL, false, '844c6547-55e3-41e7-8e05-25908211d185');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('0949b0b6-faae-4bb8-aaa9-e12c70148821', 'Pengenceran Penggumpalan', '/prestasi/pengenceran-penggumpalan', 'PointIcon', 'Menu Mixing', 'LIST_MIXING', 'VIEW', 2, 1, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:21:49.779', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:23:33.836', false, '844c6547-55e3-41e7-8e05-25908211d185');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('eb749a98-5b92-4b67-b19f-6c92226a7b1c', 'SIR Penimbangan', '/prestasi/sir-penimbangan', 'PointIcon', 'Menu SIR Penimbangan', 'LIST_SIR_PENIMBANGAN', 'VIEW', 2, 4, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:11:38.104', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 15:23:46.722', false, '844c6547-55e3-41e7-8e05-25908211d185');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('f1ed102f-dcb3-4003-b390-fa9a2182900c', 'Teh QC Scoring Mutu Pengeringan', '/prestasi/teh-qc-scoring-mutu-pengeringan', 'PointIcon', 'Menu Teh QC Scoring Mutu Pengeringan', 'LIST_TEH_QC_MUTU', 'VIEW', 2, 10, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:16:48.237', NULL, NULL, false, '6af37da4-b5b9-4579-a187-a574d3c50be1');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('c77bf6d3-419f-44be-ad97-37f577030ce9', 'Teh Sortasi QC', '/prestasi/teh-sortasi-qc', 'PointIcon', 'Menu Teh Sortasi QC', 'LIST_TEH_SORTASI_QC', 'VIEW', 2, 9, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:18:06.727', NULL, NULL, false, '6af37da4-b5b9-4579-a187-a574d3c50be1');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('793686b3-50ef-4bef-9157-9b47504f5ced', 'Teh pengiriman', '/prestasi/teh-pengiriman', 'PointIcon', 'Menu Teh pengiriman', 'LIST_TEH_PENGIRIMAN', 'VIEW', 2, 8, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:19:03.151', NULL, NULL, false, '6af37da4-b5b9-4579-a187-a574d3c50be1');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('78ebd4ad-0068-450a-ba78-bbd5b5d33995', 'Teh BA Pengepakan', '/prestasi/teh-ba-pengepakan', 'PointIcon', 'Menu Teh BA Pengepakan', 'LIST_TEH_BA_PENGEPAKAN', 'VIEW', 2, 7, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:19:56.403', NULL, NULL, false, '6af37da4-b5b9-4579-a187-a574d3c50be1');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('9f1472a1-c449-4069-bf8e-a20b48fc9d8e', 'Teh Pengepakan', '/prestasi/teh-pengepakan', 'PointIcon', 'Menu Teh Pengepakan', 'LIST_TEH_PENGEPAKAN', 'VIEW', 2, 6, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:20:45.654', NULL, NULL, false, '6af37da4-b5b9-4579-a187-a574d3c50be1');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('f3ac13de-e1ff-4200-a9b8-8fd76f23fef9', 'Teh Sortasi', '/prestasi/teh-sortasi', 'PointIcon', 'Menu Teh Sortasi', 'LIST_TEH_SORTASI', 'VIEW', 2, 5, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:21:31.583', NULL, NULL, false, '6af37da4-b5b9-4579-a187-a574d3c50be1');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('406687fe-4772-4c5a-9c52-b8d07472933e', 'Teh Pengeringan', '/prestasi/teh-pengeringan', 'PointIcon', 'Menu Teh Pengeringan', 'LIST_TEH_PENGERINGAN', 'VIEW', 2, 4, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:22:19.424', NULL, NULL, false, '6af37da4-b5b9-4579-a187-a574d3c50be1');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('d066318c-73ab-4c4a-9e28-b71ecc64ec2b', 'Teh Penggilingan', '/prestasi/teh-penggilingan', 'PointIcon', 'Menu Teh Penggilingan', 'LIST_TEH_PENGGILINGAN', 'VIEW', 2, 3, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:23:06.546', NULL, NULL, false, '6af37da4-b5b9-4579-a187-a574d3c50be1');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('3a68c96f-84c0-438f-9b60-2886c4756294', 'Teh Pelayuan', '/prestasi/teh-pelayuan', 'PointIcon', 'Menu Teh Pelayuan', 'LIST_TEH_PELAYUAN', 'VIEW', 2, 2, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:23:55.702', NULL, NULL, false, '6af37da4-b5b9-4579-a187-a574d3c50be1');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('ba828490-947e-4030-b98d-1ccf8aa6e326', 'Teh WT', '/prestasi/teh-wt', 'PointIcon', 'Menu Teh WT', 'TEH_WT', 'VIEW', 2, 1, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:24:46.969', NULL, NULL, false, '6af37da4-b5b9-4579-a187-a574d3c50be1');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('64d909c5-a521-47ef-b6d2-407c6a223b40', 'Kopi QC Pengamatan Jemuran', '/prestasi/kopi-qc-pengamatan-jemuran', 'PointIcon', 'Menu Kopi QC Pengamatan Jemuran', 'KOPI_QC_PENGAMATAN_JEMURAN', 'VIEW', 2, 17, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:37:08.972', NULL, NULL, false, '53e1efe3-6b2f-40ab-88e8-4a8f570d8b70');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('ae6f63fd-c1b4-496b-95f1-29c66f202eec', 'Kopi QC Hasil Kivu Pump', '/prestasi/kopi-qc-hasil-kivu-pump', 'PointIcon', 'Menu Kopi QC Hasil Kivu Pump', 'KOPI_QC_HASIL_KIVU_PUMP', 'VIEW', 2, 15, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:37:53.385', NULL, NULL, false, '53e1efe3-6b2f-40ab-88e8-4a8f570d8b70');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('d47570ec-13ea-4db5-867c-a9c3d33c51a9', 'Kopi QC Pengeringan Mekanis', '/prestasi/kopi-qc-pengeringan-mekanis', 'PointIcon', 'Menu Kopi QC Pengeringan Mekanis', 'LIST_KOPI_QC_PENGERINGAN_MEKANIS', 'VIEW', 2, 10, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:38:50.632', NULL, NULL, false, '53e1efe3-6b2f-40ab-88e8-4a8f570d8b70');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('ff28be31-0ae6-4753-a4d0-d2431854873c', 'Kopi QC Fermentasi', '/prestasi/kopi-qc-fermentasi', 'PointIcon', 'Menu Data Kopi QC Fermentasi', 'KOPI_QC_FERMENTASI', 'VIEW', 2, 13, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:39:42.268', NULL, NULL, false, '53e1efe3-6b2f-40ab-88e8-4a8f570d8b70');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('7bffd126-03db-4c01-8391-aab7928e60f5', 'Kopi QC Analisa Pengeringan', '/prestasi/kopi-qc-analisapengeringan', 'PointIcon', 'Menu Kopi QC Analisa Pengeringan', 'LIST_KOPI_QC_ANALISA_PENGERINGAN', 'VIEW', 2, 9, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:40:34.855', NULL, NULL, false, '53e1efe3-6b2f-40ab-88e8-4a8f570d8b70');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('effcad0d-9341-4095-b5cd-99f68201d4ba', 'Kopi QC Pulping Washing', '/prestasi/kopi-qc-pulping-washing', 'PointIcon', 'Menu Kopi QC Pulping Washing', 'LIST_KOPI_QC_PULPING_WASHING', 'VIEW', 2, 8, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:41:30.870', NULL, NULL, false, '53e1efe3-6b2f-40ab-88e8-4a8f570d8b70');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('680f3ad8-91d9-43a2-b9ad-a5b45fb29d8f', 'Kopi QC Analisa Penerimaan', '/prestasi/kopi-qc-analisapenerimaan', 'PointIcon', 'Menu Kopi QC Analisa Penerimaan', 'LIST_KOPI_QC_ANALISA_PENERIMAAN', 'VIEW', 2, 7, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:42:27.374', NULL, NULL, false, '53e1efe3-6b2f-40ab-88e8-4a8f570d8b70');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('9dff200c-6ba2-401e-840d-3d1545ac2c47', 'Kopi QC Penggerbusan', '/prestasi/kopi-qc-penggerbusan', 'PointIcon', 'Menu Kopi QC Penggerbusan', 'LIST_KOPI_QC_PENGGERBUSAN', 'VIEW', 2, 11, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:43:19.792', NULL, NULL, false, '53e1efe3-6b2f-40ab-88e8-4a8f570d8b70');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('7771233c-0629-4452-a429-21d7a442302a', 'Kopi Sortasi', '/prestasi/kopi-sortasi', 'PointIcon', 'Menu Kopi Sortasi', 'LIST_KOPI_SORTASI', 'VIEW', 2, 6, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:44:02.522', NULL, NULL, false, '53e1efe3-6b2f-40ab-88e8-4a8f570d8b70');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('bc23ab7b-6818-4340-9776-4cf19344b0bd', 'Kopi Penggerbusan', '/prestasi/kopi-penggerbusan', 'PointIcon', 'Menu Kopi Penggerbusan', 'LIST_KOPI_PENGGERBUSAN', 'VIEW', 2, 5, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:49:19.176', NULL, NULL, false, '53e1efe3-6b2f-40ab-88e8-4a8f570d8b70');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('1d43dc43-8c1e-458f-bd71-dc0974d73e56', 'Kopi QC Analisa Normal', '/prestasi/kopi-qc-analisa-normal', 'PointIcon', 'Menu Kopi QC Analisa Normal', 'KOPI_QC_ANALISA_NORMAL', 'VIEW', 2, 12, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:50:23.975', NULL, NULL, false, '53e1efe3-6b2f-40ab-88e8-4a8f570d8b70');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('8af7faf3-09da-446d-8036-a142d734e62d', 'Kopi QC Analisa Boon', '/prestasi/kopi-qc-analisa-boon', 'PointIcon', 'Menu Kopi QC Analisa Boon', 'KOPI_QC_ANALISA_BOON', 'VIEW', 2, 14, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:51:11.298', NULL, NULL, false, '53e1efe3-6b2f-40ab-88e8-4a8f570d8b70');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('4d90cba0-876a-4661-8f7e-0a95928c3c7a', 'Kopi QC Analisa Bubuk Buah', '/prestasi/kopi-qc-analisa-bubuk-buah', 'PointIcon', 'Menu Kopi QC Analisa Bubuk Buah', 'KOPI_QC_ANALISA_BUAH', 'VIEW', 2, 16, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:52:10.245', NULL, NULL, false, '53e1efe3-6b2f-40ab-88e8-4a8f570d8b70');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('71c54d57-6dce-46c2-b406-b2b81a27769d', 'Kopi Tempering', '/prestasi/kopi-tempering', 'PointIcon', 'Menu Kopi Tempering', 'KOPI_TEMPERING', 'VIEW', 2, 4, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:53:01.822', NULL, NULL, false, '53e1efe3-6b2f-40ab-88e8-4a8f570d8b70');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('4c8ce1ab-9b1a-48e1-9319-43b5942883c2', 'Kopi Pengeringan Mekanis', '/prestasi/kopi-pengeringan-mekanis', 'PointIcon', 'Menu Kopi Pengeringan Mekanis', 'LIST_KOPI_PENGERINGAN_MEKANIS', 'VIEW', 2, 3, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:53:49.329', NULL, NULL, false, '53e1efe3-6b2f-40ab-88e8-4a8f570d8b70');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('921b92f8-c91b-4bc2-aaef-a2cfec703711', 'Kopi Sun Drying', '/prestasi/kopi-sun-driying', 'PointIcon', 'Menu Kopi Sun Drying', 'KOPI_SUN_DRIYING', 'VIEW', 2, 2, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:54:40.671', NULL, NULL, false, '53e1efe3-6b2f-40ab-88e8-4a8f570d8b70');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('83144c77-9bd4-4a36-bcf1-9f3c6c697563', 'Kopi Pengolahan Basah', '/prestasi/kopi-pengolahan-basah', 'PointIcon', 'Menu Kopi Pengolahan Basah', 'KOPI_PENGOLAHAN_BASAH', 'VIEW', 2, 1, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 16:55:33.172', NULL, NULL, false, '53e1efe3-6b2f-40ab-88e8-4a8f570d8b70');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('401df06b-38c2-4b06-97a3-21874ccdce4b', 'List Bokar Penerimaan Pabrik', '/prestasi/list-karet-bokar-penerimaan-pabrik', 'PointIcon', 'Menu Data Bokar Penerimaan Pabrik', 'LIST_BOKAR', 'VIEW', 2, 1, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 14:38:07.148', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-23 08:44:39.158', false, '09fa34f5-6394-4689-9c02-d0c7d202209a');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('a809485f-b634-4624-85bd-7eeb32097723', 'History Bokar Petani', '/prestasi/list-history-bokar-petani', 'PointIcon', 'LIST HISTORY BOKAR PETANI', 'LIST_HISTORY_BOKAR_PETANI', 'VIEW', 2, 4, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-23 08:07:35.230', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-23 10:21:51.488', false, '09fa34f5-6394-4689-9c02-d0c7d202209a');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('791685f8-18d4-4b14-96f2-102e05525a93', 'History Bokar Pemasok', '/prestasi/list-history-bokar-pemasok', 'PointIcon', 'List History Bokar Pemasok', 'LIST_HISTORY_BOKAR_PEMASOK', 'VIEW', 2, 5, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-23 08:06:40.246', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-23 10:21:58.671', false, '09fa34f5-6394-4689-9c02-d0c7d202209a');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('e33d5bb2-d16a-4234-bacf-4b4cf1707667', 'Penerimaan Bokar Pabrik', '/prestasi/list-karet-bokar-pabrik', 'PointIcon', 'Menu Bokar Pabrik', 'LIST_BOKAR_PABRIK', 'VIEW', 2, 2, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-02 14:39:08.194', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-23 10:22:17.601', false, '09fa34f5-6394-4689-9c02-d0c7d202209a');
INSERT INTO public.c_menu
(id, "name", link, icon, description, permission_label, "action", "level", seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id)
VALUES('aacfe382-a539-4be0-aa9f-67f7d56f1f60', 'Penerimaan Pemasok', '/prestasi/list-karet-bokar-penerimaan-petani', 'PointIcon', 'Menu Data Bokar Penerimaan Petani', 'LIST_BOKAR', 'VIEW', 2, 2, 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-23 08:10:05.837', 'f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', '2025-06-23 10:22:26.466', false, '09fa34f5-6394-4689-9c02-d0c7d202209a');


--ROLE
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA01', 'SUPER_ADMIN', 'Super Admin');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA02', 'REGIONAL', 'Regional');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA03', 'UNIT_KEBUN', 'Unit Kebun (manager & admin)');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA04', 'ADMIN_AFDELING', 'Asisten Afdeling/ Admin Afdeling');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA05', 'MANDOR', 'Mandor');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA06', 'ADMIN_ANPER', 'Admin Anper');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA07', 'ADMIN_HOLDING', 'Admin Holding');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA08', 'ADMIN_UNIT', 'Admin Unit');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA09', 'ASISTEN_UNIT', 'Asisten Unit');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA10', 'BOM_ANPER', 'Bom Anper');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA12', 'KERANI_PENERIMAAN', 'Kerani Penerimaan');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA14', 'MANAGER_UNIT', 'Manager Unit');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA16', 'MANDOR_PEMELIHARAAN', 'Mandor Pemeliharaan');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA17', 'MANDOR_SATU', 'Mandor Satu');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA19', 'PETANI', 'Petani');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA20', 'PEMASOK', 'Pemasok');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA21', 'OPERATOR_JAMBATAN_TIMBANG', 'Petugas Penerima BB & Operator Jembatan Timbang');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA22', 'MANDOR_PENERIMAAN_BB', 'MANDOR_PENERIMAAN_BB');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA23', 'MANDOR_PENGOLAHAN_BASAH', 'MANDOR_PENGOLAHAN_BASAH');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA24', 'MANDOR_PENGOLAHAN_KERING', 'MANDOR_PENGOLAHAN_KERING');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA25', 'MANDOR_PACKING', 'MANDOR_PACKING');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA26', 'KEPALA_LABORATORIUM', 'KEPALA_LABORATORIUM');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA27', 'ASISTEN_TEKPOL', 'ASISTEN_TEKPOL');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA28', 'ASISTEN_TU', 'ASISTEN_TU');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA29', 'MASKEP/ASKEP', 'MASKEP/ASKEP');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA30', 'MANAJER_KEBUN', 'MANAJER_KEBUN');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA31', 'MANDOR_PENGOLAHAN', 'MANDOR_PENGOLAHAN');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA32', 'MANDOR_PENGGILINGAN', 'MANDOR_PENGGILINGAN');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA33', 'MANDOR_PENGASAPAN', 'MANDOR_PENGASAPAN');
INSERT INTO public.auth_role
(id, "name", description)
VALUES('HA34', 'MANDOR_SORTASI&PENGEPAKAN', 'MANDOR_SORTASI&PENGEPAKAN');

--MENU_ROLE
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('b6f07216-ae06-49b8-9a89-511258a2a011', '56c47256-8bf8-482e-a67e-36290f1f19ee', 'HA20', 'VIEW', '2025-02-06 15:41:48.239', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('f0f3a77a-8d8d-4f02-b042-2fe760511c36', '9383b490-dc68-4479-9d23-1372fb42d557', 'HA02', 'VIEW', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('eb22c2e4-78ec-45cf-8859-612ea5761e8f', '56c47256-8bf8-482e-a67e-36290f1f19ee', 'HA01', 'VIEW,UPDATE', '2024-12-17 08:31:41.728', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('9b236518-05a9-4b43-8704-ca87d14c705f', '33d00eb2-caaf-4ae3-b2ba-9dcfe49c8e7c', 'HA01', 'VIEW', '2025-01-17 14:02:38.138', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('14dce636-b43a-43c0-90f7-bd6e6a303f71', '9383b490-dc68-4479-9d23-1372fb42d557', 'HA20', 'VIEW', '2025-02-06 15:41:48.239', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('ed47e355-3cc5-459f-90a6-c691b71f554f', '21b25999-03cd-498c-a9e4-9b3e629dda59', 'HA20', 'VIEW', '2025-02-06 15:41:48.239', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('81a6b5a2-138a-465d-8270-5871a33477ad', '56c47256-8bf8-482e-a67e-36290f1f19ee', 'HA03', 'VIEW', '2024-12-23 08:49:31.127', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('c1f08c36-0721-4aef-bd3b-daa82b3d28ca', '648f1174-9b13-4d55-88f4-5846b8a12efb', 'HA20', 'VIEW,CREATE,UPDATE,DELETE', '2025-02-06 15:41:48.239', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('59d4edc9-7485-4b13-9888-c13358308bb2', '56c47256-8bf8-482e-a67e-36290f1f19ee', 'HA05', 'VIEW', '2024-12-23 08:49:16.821', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('41700366-7d58-4eaf-9d17-d2e470e0417e', '12ffe181-18cf-4b52-ab92-c466cd54bb6a', 'HA05', 'VIEW', '2025-01-15 15:10:11.410', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('164cc019-f92b-4b6b-b2ab-2818f6e380ab', '682af65a-bd6e-4796-9c9a-d078a4f2bf47', 'HA05', 'VIEW,CREATE,UPDATE,DELETE', '2025-01-15 14:57:51.897', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('d30c73f7-87b6-4340-b75d-fb5507a22825', 'c431db7d-7e92-4965-8b81-741c9627a9e1', 'HA05', 'VIEW,CREATE,UPDATE,DELETE', '2025-01-15 14:57:51.897', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('2eb2a457-37cd-4259-919b-f446c070a7de', '3ef0adb5-7f25-407e-8be5-4a6c5a0114a0', 'HA05', 'VIEW,CREATE,UPDATE,DELETE', '2025-01-15 14:57:51.897', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('be1cb146-989e-433d-8a3c-211e35dcdc52', '152dd5a3-2b28-4849-91bf-35e8d1820d61', 'HA01', 'VIEW', '2025-01-16 12:32:51.240', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('3ddfb473-4148-4717-bd02-2f023412ae29', '9383b490-dc68-4479-9d23-1372fb42d557', 'HA01', 'VIEW', '2025-01-30 17:30:48.170', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('5fb6aa39-7668-4536-8356-464e248396d0', '21b25999-03cd-498c-a9e4-9b3e629dda59', 'HA01', 'VIEW', '2025-01-30 17:30:48.170', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('6524caa3-cdd3-4002-9b7b-4248a4d8847a', '30ce74aa-a99f-40b3-9666-3fbef030fa5b', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2024-12-30 13:13:41.222', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('924c6c7d-45dc-409a-9a1e-85d1df179f27', '1a894cb0-e41c-4fad-913a-f343c9a82597', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2024-12-24 14:47:05.082', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('3bdcd4bd-9006-4f87-a6d9-ced607886c2e', 'aa30981f-f4b6-4a0c-a08b-d9fb4c9b9d04', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2024-12-20 08:29:51.707', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('63d22606-90e6-4c2e-b783-03c9251413e0', '4a9dad4f-bdd0-4a6a-bea6-89ba821092e9', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-01-02 11:12:16.269', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('e5728807-750d-44f4-88e3-cf6399b76517', 'c4285da7-28bc-41a7-917e-424cbb2bec8d', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2024-12-19 12:57:52.324', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('e6e7bc77-b64e-4808-a1f3-3795f7550a65', 'cfddc1b1-e9ea-4e12-b72b-ebfbf6433f88', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2024-12-19 13:00:34.904', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('28ac247b-6e09-42cb-9276-aac88a967d54', '8e8f55a1-02ae-48c7-a9d3-86d994b45b13', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2024-12-19 13:00:34.904', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('0d6708a3-665c-4c5e-bfa8-ac1efe14bcc7', 'b89c8f3a-b192-49fd-a7e9-119638cd4d06', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2024-12-20 08:29:51.707', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('3916effa-a367-4a62-a63e-ba120bbc95a2', '0699c49d-acf6-46e2-b71e-9ecc40299f35', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-01-20 15:25:56.364', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('74563870-44fc-4d5a-9065-cd532a47dede', '056ca3a6-2847-45d4-8920-a92f73fb52d2', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-01-20 16:39:51.149', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('888e048d-d824-4166-aa1a-d1c9c1c59b23', '8bd58d19-be48-497f-be97-cfcf5d0bbff9', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-01-21 13:13:53.466', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('b08e573c-9778-4137-ac88-41df8d86f0c5', '4603cca9-edbc-42db-9606-11bc145c7ecf', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-01-24 13:33:41.556', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('0dfc5e7f-543b-4803-98f7-44ad5bc38e67', '95c9165f-b03f-4deb-8713-142739cd4fac', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-01-21 14:31:00.922', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('7fddbe39-7925-4243-bb46-8e608b58c768', '0d373001-9dd6-4f2e-8d78-31ef4bb5bb48', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-01-21 16:15:53.421', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('47e01395-91a0-4f45-8525-2bcd48cbbea4', 'd932f807-bf63-4e13-8110-fb006c93b447', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-01-22 13:19:58.880', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('63fb03d4-7729-4bac-ac5a-66ea77235447', 'ee19e628-3b71-4ac4-8e6a-bb7841cd7aff', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-01-22 15:44:26.353', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('d91771ab-c108-4a83-a885-6f61b5d7ef52', '9aae36ed-33c6-4fd2-bf0f-13b6aa4833d7', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-02-10 10:49:17.296', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('999603b3-30c0-408f-a2dc-2e1f52aae7ff', '2a8cb1ee-9e34-441e-accd-9457b41305c1', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-02-26 10:42:01.682', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('993fa881-831e-450c-8fdf-08b323b9de15', '1e3d413f-49dd-4e27-9aeb-0fe4ab786d3c', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-04-24 13:11:18.299', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('7a788ad0-d0a0-4d22-a518-e96a760a4efd', '20cb8775-bbb6-40fc-90a0-4162a891ea64', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-04-24 13:32:07.862', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('62713701-7538-4ad2-9b77-26ab83f3eb7f', '10d0c8f0-e519-4041-8a5e-6036d581af6f', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-04-24 13:34:56.919', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('362d2c99-c095-45aa-bd19-881e1a411974', '533c3f52-712c-4b1a-bd4d-fdf8434c43b2', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-05-21 08:29:15.394', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('9e7cc719-7ab6-4afd-a46d-2716717a8b0f', 'b6b362a0-a61c-4758-b7d5-ef8e3687d7f3', 'HA20', 'VIEW', '2025-02-07 14:38:29.308', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('69eef20e-d3cb-4aad-8bd0-b3b4b17a685c', '767c3205-49b0-41d5-bf52-3c2e98c28827', 'HA20', 'VIEW,CREATE,UPDATE,DELETE', '2025-02-07 14:38:29.308', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('5576bd58-3760-4025-a009-4109d97a7fa1', '21b25999-03cd-498c-a9e4-9b3e629dda59', 'HA02', 'VIEW', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('70e1572a-94bf-4a56-be3b-6783564ee555', '0949b0b6-faae-4bb8-aaa9-e12c70148821', 'HA01', 'VIEW', '2025-06-11 08:39:17.100', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('7b531774-2d7e-4a3c-a824-93efeddfc4a7', '648f1174-9b13-4d55-88f4-5846b8a12efb', 'HA02', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('0472e939-7a68-44d6-8e22-efcfe3d7e81d', 'b17b3c86-5819-4273-8eb5-f485db743bbf', 'HA01', 'VIEW', '2025-06-11 08:39:17.100', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('004af491-8499-48ae-a17a-8d45a67eef8e', '1502e99f-3593-4a45-a16c-1a28976f0378', 'HA01', 'VIEW', '2025-06-02 15:23:23.442', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('6cff282c-c2c4-487d-85a4-0ab9f90fa9ed', '8bd58d19-be48-497f-be97-cfcf5d0bbff9', 'HA02', 'VIEW,CREATE,UPDATE', '2025-05-22 08:49:37.647', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('c26595aa-a2e6-47c6-aa26-db257c069f78', '56c47256-8bf8-482e-a67e-36290f1f19ee', 'HA04', 'VIEW', '2024-12-23 08:49:11.248', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('cebe47cd-c6c8-4531-aab5-d4a3bc98400f', '56c47256-8bf8-482e-a67e-36290f1f19ee', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('d93bcfbc-f88b-452a-ae1a-c041adeb7c71', 'ab811af9-0f13-4159-8228-e234581c4f47', 'HA08', 'VIEW', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('44c2d702-47dd-443d-9303-261d7e106c43', '33d00eb2-caaf-4ae3-b2ba-9dcfe49c8e7c', 'HA08', 'VIEW', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('8184f5d0-1440-4907-bcc5-0f7caa99f7d0', '152dd5a3-2b28-4849-91bf-35e8d1820d61', 'HA08', 'VIEW', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('72f97888-ded7-4ace-a720-529a01b93292', '202813ae-a9c3-46ff-a37f-796571ab7870', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('b228027a-7aa9-475a-9a1d-11e4fba56b14', 'b6b362a0-a61c-4758-b7d5-ef8e3687d7f3', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('1b56b3bb-41ba-4a77-9789-819cedd548e7', 'cb1664d3-90a2-4732-bd9e-e69e42d72c21', 'HA02', 'VIEW', '2025-04-29 10:54:18.463', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('203a43b2-7102-4d50-8bfa-8aacacccf357', '61bb02a1-b91a-45a9-b727-23f1cbddb9aa', 'HA02', 'VIEW', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('9dae8f6a-cd30-4411-a396-def32cb5cb92', '7bb8b836-31d5-43ec-9d39-6cff5ab2c25c', 'HA02', 'VIEW', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('7a2be40f-a779-4735-ac60-41549c4d209e', 'bd58f76d-06a1-4ed1-82f6-539adb1b595b', 'HA01', 'VIEW', '2025-06-02 15:23:23.442', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('ca4f16df-d6a3-48e6-a56a-7e538fe31ba7', '90f2da9b-e205-4792-81ac-d013a05e4e91', 'HA01', 'VIEW', '2025-06-11 08:39:17.100', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('6af9c2a0-ec7d-4a35-b994-30ebbeedc37f', '10a985de-293e-4cb5-8031-8bedb37aa3ef', 'HA01', 'VIEW', '2025-06-11 08:39:17.100', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('895ae6b4-94ee-49a7-8b47-6a28e61c5768', '481728dc-c773-4434-8316-c7eff38d8f53', 'HA01', 'VIEW', '2025-06-11 08:39:17.100', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('3ab98d15-f1a3-452a-be4e-63c6070c763c', '61865328-3288-4d85-a8be-70eaf4ee352c', 'HA01', 'VIEW', '2025-06-11 08:39:17.100', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('6af5fbb4-46d5-4072-b885-d9089ac433f5', 'ba828490-947e-4030-b98d-1ccf8aa6e326', 'HA01', 'VIEW', '2025-06-02 16:58:34.080', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('f0d6aad6-479d-49e9-836e-96aed3eab33f', '3a68c96f-84c0-438f-9b60-2886c4756294', 'HA01', 'VIEW', '2025-06-02 16:58:34.080', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('9def2fb5-dfb4-49f9-82f3-c1fba9d18ff4', 'd066318c-73ab-4c4a-9e28-b71ecc64ec2b', 'HA01', 'VIEW', '2025-06-02 16:58:34.080', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('2e1c609d-c53b-4eb8-a7d5-aed96ebbc709', '406687fe-4772-4c5a-9c52-b8d07472933e', 'HA01', 'VIEW', '2025-06-02 16:58:34.080', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('86cf1913-a8f3-48f7-acf4-d678fc18082f', 'f3ac13de-e1ff-4200-a9b8-8fd76f23fef9', 'HA01', 'VIEW', '2025-06-02 16:58:34.080', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('5f1b1aae-d7f9-46f8-b616-ad9917c504a1', 'f9640347-b9a8-4afe-8ef2-db4bb2be462a', 'HA02', 'VIEW', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('face181d-fe3a-4d82-8df5-43470ba13c32', '3ef0adb5-7f25-407e-8be5-4a6c5a0114a0', 'HA02', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('96798ea4-74b0-4ec7-8249-061a889c9566', '804dc040-8882-4b3a-b54d-14635c27a2c2', 'HA02', 'VIEW', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('c1fb9a8b-6a97-4378-ba2b-f3b78ab4edf1', '298bdb15-97a5-42bf-a388-5f7d4f0eccb1', 'HA02', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('5afc0817-6284-472e-9ccb-a34e9f8936a3', '30ce74aa-a99f-40b3-9666-3fbef030fa5b', 'HA02', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('ef7682a6-db0a-4a12-8433-8978d2e4a3d4', 'aa30981f-f4b6-4a0c-a08b-d9fb4c9b9d04', 'HA02', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('910ece95-79be-4262-bb8b-1f6e9b475edb', '4a9dad4f-bdd0-4a6a-bea6-89ba821092e9', 'HA02', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('a0566aa0-9996-4ad4-afcd-af7789a32317', '9f1472a1-c449-4069-bf8e-a20b48fc9d8e', 'HA01', 'VIEW', '2025-06-02 16:58:34.080', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('f7f0718d-2880-4723-887d-9811532caa68', '2a8cb1ee-9e34-441e-accd-9457b41305c1', 'HA02', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('d7f020bc-5ee6-447f-8a1f-ce9263d025e2', '2c1bad8c-99a5-45b9-b349-c717d68616ee', 'HA02', 'VIEW', '2025-03-10 09:10:41.925', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('6c51e481-2bf4-47fe-bd03-f79f145af43f', '1f0fef05-fda4-4fc2-a954-935075a7e136', 'HA02', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 09:10:41.925', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('754c79f0-0acd-42f0-9a85-5d7c0ea0689d', 'a07dcc4a-7af3-4aac-9482-216a66e7fb9b', 'HA02', 'VIEW', '2025-03-10 09:10:41.925', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('0c673cc2-0018-4e33-a7f7-c752476ed72e', 'e7ba24c1-92b5-4723-8f2d-abe76a5c3f8e', 'HA02', 'VIEW', '2025-03-10 09:10:41.925', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('2e86bd60-8b7d-4f94-ade9-17ca1760da4f', '56c47256-8bf8-482e-a67e-36290f1f19ee', 'HA02', 'VIEW', '2024-12-23 08:49:00.642', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('b4215b36-e708-4771-ba57-26e2b981d3be', 'ab811af9-0f13-4159-8228-e234581c4f47', 'HA02', 'VIEW', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('9198c87b-bb0d-47a3-ae82-5734a4340478', '33d00eb2-caaf-4ae3-b2ba-9dcfe49c8e7c', 'HA02', 'VIEW', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('b5717a05-3fdc-4eff-9b3b-914fc51beba9', '152dd5a3-2b28-4849-91bf-35e8d1820d61', 'HA02', 'VIEW', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('102aaed1-6471-4f2a-bdac-a4f75b4bb3c6', 'c2c6a9a1-3b76-405c-8d6c-50161d2e3fd3', 'HA02', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('e663cac8-33ed-4da7-9066-36f937697330', '202813ae-a9c3-46ff-a37f-796571ab7870', 'HA02', 'VIEW', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('53f9f7e6-6288-417a-8efe-ff9a734869b4', 'b6b362a0-a61c-4758-b7d5-ef8e3687d7f3', 'HA02', 'VIEW', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('7244201a-5ff5-425b-9c6f-756adcbf6107', '767c3205-49b0-41d5-bf52-3c2e98c28827', 'HA02', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('06bda82e-a25f-40e5-a4bf-f71733723bc7', '7b2fb3a9-eabf-4866-8d9d-537f53a4609e', 'HA02', 'VIEW', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('eb30183b-0b83-4815-baf8-d2e1e05cb891', 'ab811af9-0f13-4159-8228-e234581c4f47', 'HA01', 'VIEW', '2025-01-16 12:32:51.240', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('acd94596-d264-4651-9ff6-62f05d663a83', '12ffe181-18cf-4b52-ab92-c466cd54bb6a', 'HA02', 'VIEW', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('d5fe8c0b-763b-494f-960e-13180f461aea', '682af65a-bd6e-4796-9c9a-d078a4f2bf47', 'HA02', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('a8599c72-214d-4bb0-a25a-8e7708b0d218', 'c431db7d-7e92-4965-8b81-741c9627a9e1', 'HA02', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('abadc7e4-028a-4ba0-94ea-7cd00954b7ad', '4603cca9-edbc-42db-9606-11bc145c7ecf', 'HA02', 'VIEW,CREATE,UPDATE,DELETE', '2025-04-23 10:50:59.919', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('51ae3902-1fc3-4566-a698-cf8894e1ba4a', '56c47256-8bf8-482e-a67e-36290f1f19ee', 'HA05', 'VIEW,UPDATE', '2024-12-24 17:00:49.830', 1);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('a65eeb0c-d718-438a-a998-9c4b8f3c3205', 'a7e26426-c27b-4fb0-bdb5-f1b43297de11', 'HA05', 'VIEW', '2024-12-30 17:18:22.636', 1);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('c3349bd5-f109-44db-be86-5ed713bc46e7', '298bdb15-97a5-42bf-a388-5f7d4f0eccb1', 'HA05', 'VIEW', '2024-12-30 17:18:22.636', 1);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('2d43393c-abfc-44bf-ad53-1c1643ae5b8e', 'cfddc1b1-e9ea-4e12-b72b-ebfbf6433f88', 'HA02', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('2c0dc2e7-5422-419f-af22-c40809cb04c0', 'b89c8f3a-b192-49fd-a7e9-119638cd4d06', 'HA02', 'VIEW,CREATE,UPDATE', '2025-04-29 11:19:41.968', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('8051753e-08c5-4fba-8286-eded928ae7ca', '0699c49d-acf6-46e2-b71e-9ecc40299f35', 'HA02', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('afc9724b-dae5-4ef4-9656-9d460a9a6841', '056ca3a6-2847-45d4-8920-a92f73fb52d2', 'HA02', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-04 13:33:32.216', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('2e07fdb9-3ca2-48a7-9449-110a6c30120c', '9aae36ed-33c6-4fd2-bf0f-13b6aa4833d7', 'HA02', 'VIEW,CREATE,UPDATE,DELETE', '2025-04-29 11:24:55.166', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('fed66500-04cb-45d5-a4c7-3469d4f6d696', '648f1174-9b13-4d55-88f4-5846b8a12efb', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-02-06 09:44:15.080', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('f38a8d88-00bf-40dd-a555-2f5d51bf6249', 'c2c6a9a1-3b76-405c-8d6c-50161d2e3fd3', 'HA01', 'VIEW,DELETE', '2025-02-28 16:18:58.126', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('9633191e-1cf1-4a83-bc23-0b5a5cc71ea2', 'cb1664d3-90a2-4732-bd9e-e69e42d72c21', 'HA01', 'VIEW', '2025-03-05 14:46:15.841', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('f8d1df39-9adf-49cd-b9de-9ee7ff73b8c3', '202813ae-a9c3-46ff-a37f-796571ab7870', 'HA01', 'VIEW', '2025-02-07 16:01:34.849', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('a6dc17bf-82f9-4717-a869-494df758462a', 'b6b362a0-a61c-4758-b7d5-ef8e3687d7f3', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-02-07 11:06:51.009', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('75c11a59-72a0-47c2-b9fa-25d8c7abb83f', 'ab811af9-0f13-4159-8228-e234581c4f47', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('6b96d86c-ba15-4606-b1f0-005b9ae34351', '33d00eb2-caaf-4ae3-b2ba-9dcfe49c8e7c', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('c4fb95c9-dbe7-4cb7-ace0-58af2e1a6c56', '152dd5a3-2b28-4849-91bf-35e8d1820d61', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('f80381ee-e393-42f9-910c-3baae8ef41b9', '9383b490-dc68-4479-9d23-1372fb42d557', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('e15e9ce0-984b-4f32-bf62-7402cf14cf5d', '21b25999-03cd-498c-a9e4-9b3e629dda59', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('ad5d257d-6e60-475f-a84c-f0f75545ebfa', '648f1174-9b13-4d55-88f4-5846b8a12efb', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('54fc5a43-c1bf-428e-8d34-2c80c158b39b', 'c2c6a9a1-3b76-405c-8d6c-50161d2e3fd3', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('e6d87b1a-b14b-4cae-99fd-5c43bafea7bc', 'cb1664d3-90a2-4732-bd9e-e69e42d72c21', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('1c73acbf-7a26-4aec-9978-a5dde26a9115', '202813ae-a9c3-46ff-a37f-796571ab7870', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('e4818b41-7ebd-490f-b900-a46214433dee', 'b6b362a0-a61c-4758-b7d5-ef8e3687d7f3', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('f8419fed-0056-4793-90b6-5e7580052950', '767c3205-49b0-41d5-bf52-3c2e98c28827', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('0a7677b0-5ca9-499b-970e-589db2f89814', '7b2fb3a9-eabf-4866-8d9d-537f53a4609e', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('fe043671-1c15-40e6-9489-9fa6b727f00c', '12ffe181-18cf-4b52-ab92-c466cd54bb6a', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('c75b574c-ccc2-4e33-b7e7-501b522a1345', '682af65a-bd6e-4796-9c9a-d078a4f2bf47', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('788b77c0-1dfb-4ba4-9fac-0ac988a90c4a', 'c431db7d-7e92-4965-8b81-741c9627a9e1', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('7de0a57a-078d-4ae3-afa8-81fb84e26b9f', '3ef0adb5-7f25-407e-8be5-4a6c5a0114a0', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('72b38423-b9c4-43d4-bb06-e1006bafc4b2', '61bb02a1-b91a-45a9-b727-23f1cbddb9aa', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('560cbf47-c818-4736-9c4c-9e767957c2d2', '7bb8b836-31d5-43ec-9d39-6cff5ab2c25c', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('d6d601f1-26b5-4ccb-8fcb-dd7ef76dfd4c', 'f9640347-b9a8-4afe-8ef2-db4bb2be462a', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('a0a4fa4b-1eb9-4267-8c00-e33611ea4b5d', '804dc040-8882-4b3a-b54d-14635c27a2c2', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('7ebfb7ff-db9f-4790-9ae9-cd3aa6893b47', '298bdb15-97a5-42bf-a388-5f7d4f0eccb1', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('6dfc0454-232f-4d61-b902-aa575e71e448', 'a07dcc4a-7af3-4aac-9482-216a66e7fb9b', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('a7fad758-6d9c-479c-bad4-994c42e16cd7', 'e7ba24c1-92b5-4723-8f2d-abe76a5c3f8e', 'HA04', 'VIEW', '2025-03-14 16:13:48.365', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('eaf6116e-4b96-430a-8878-ad0d37813a1b', 'a7e26426-c27b-4fb0-bdb5-f1b43297de11', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-06-10 13:13:01.100', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('caaae2b8-49e2-43f5-b778-86181632fffb', '767c3205-49b0-41d5-bf52-3c2e98c28827', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('8f923611-0697-40e3-88d1-c5268b1671c2', '7b2fb3a9-eabf-4866-8d9d-537f53a4609e', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('863df87b-c5b7-43d2-ae6f-13133c66e697', '9383b490-dc68-4479-9d23-1372fb42d557', 'HA08', 'VIEW', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('f28bace9-9761-439d-8ebc-dc01303cdefb', '21b25999-03cd-498c-a9e4-9b3e629dda59', 'HA08', 'VIEW', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('6f7aea9e-1e20-4e19-b5ac-256844bc97d0', '648f1174-9b13-4d55-88f4-5846b8a12efb', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('22ad2ec2-962b-42eb-aad6-d2222cadbc58', 'c2c6a9a1-3b76-405c-8d6c-50161d2e3fd3', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('97becc3a-eb88-4bd6-99b8-8e04113478cf', '767c3205-49b0-41d5-bf52-3c2e98c28827', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-02-07 14:38:10.999', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('3498add4-33e5-4163-956d-d2799a21c5b6', '7b2fb3a9-eabf-4866-8d9d-537f53a4609e', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-03 10:48:21.373', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('42b94750-da41-47ac-8a4b-6c57671beb4c', '61bb02a1-b91a-45a9-b727-23f1cbddb9aa', 'HA01', 'VIEW', '2025-02-13 10:45:28.684', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('56b1c3fb-828a-46ac-aaca-c1ca4a7d0287', '7bb8b836-31d5-43ec-9d39-6cff5ab2c25c', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-02-13 10:48:12.031', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('f4db1c78-0829-4f57-aed4-e5f1c9796a69', 'f9640347-b9a8-4afe-8ef2-db4bb2be462a', 'HA01', 'VIEW', '2025-03-03 11:24:04.311', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('ad5f6081-1b16-4539-8956-97c4ea48013b', '12ffe181-18cf-4b52-ab92-c466cd54bb6a', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-01-02 11:29:49.839', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('f95e8bb4-9161-4f0a-be44-b4616ba33d7a', '682af65a-bd6e-4796-9c9a-d078a4f2bf47', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2024-12-31 10:51:00.432', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('94eb189f-4174-4d1a-8c6c-da38f4de1035', 'c431db7d-7e92-4965-8b81-741c9627a9e1', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-01-06 14:38:27.444', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('d544e7d9-e1c5-4f00-849b-e6f783a0e3a2', '3ef0adb5-7f25-407e-8be5-4a6c5a0114a0', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2025-01-06 10:29:32.061', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('39a2866b-c65b-4b46-b43a-0a04ddfb2634', '09fa34f5-6394-4689-9c02-d0c7d202209a', 'HA01', 'VIEW', '2025-06-02 14:36:40.846', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('36fbbf12-f7cb-4018-ae6a-41af5dccfce5', 'cb1664d3-90a2-4732-bd9e-e69e42d72c21', 'HA08', 'VIEW', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('f136e1de-4f14-4b0e-b675-3091ebce0609', '61bb02a1-b91a-45a9-b727-23f1cbddb9aa', 'HA08', 'VIEW', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('5c8077e2-e862-4bf3-a9c7-621be631fb9b', '7bb8b836-31d5-43ec-9d39-6cff5ab2c25c', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('859f68b7-f411-4dff-9aa8-25a59bc8bc0f', 'f9640347-b9a8-4afe-8ef2-db4bb2be462a', 'HA08', 'VIEW', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('61f875b2-4467-4063-84c1-6cccf65fcba6', '12ffe181-18cf-4b52-ab92-c466cd54bb6a', 'HA08', 'VIEW', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('cb8375df-6186-4099-9acc-2fa8b0b0b3b2', '682af65a-bd6e-4796-9c9a-d078a4f2bf47', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('3dfeee79-2312-4aee-8da0-56df3d57c28e', 'c431db7d-7e92-4965-8b81-741c9627a9e1', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('ac77a376-be3d-439b-8e23-dc7170d02b83', '3ef0adb5-7f25-407e-8be5-4a6c5a0114a0', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('7f30be06-b78e-418c-a918-085789b4c347', '804dc040-8882-4b3a-b54d-14635c27a2c2', 'HA08', 'VIEW', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('8d88de84-0571-4788-97ae-bd7e638b8378', '298bdb15-97a5-42bf-a388-5f7d4f0eccb1', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('7d28526b-3e23-41cd-979e-c5d931816154', '30ce74aa-a99f-40b3-9666-3fbef030fa5b', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('ef181963-8f07-4f76-8617-4b3cba49e018', 'aa30981f-f4b6-4a0c-a08b-d9fb4c9b9d04', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('22c3e32b-5f36-45b5-8982-5248e08b523c', '4a9dad4f-bdd0-4a6a-bea6-89ba821092e9', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('fa0fc5bb-8971-4f52-a948-474eed935a11', '0699c49d-acf6-46e2-b71e-9ecc40299f35', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('f8cd8ed3-092d-4097-9bb5-ee944e1eb9f0', '056ca3a6-2847-45d4-8920-a92f73fb52d2', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('336b6d0d-9e57-4628-89e2-fe5c69909ab3', 'ee19e628-3b71-4ac4-8e6a-bb7841cd7aff', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('2578ed9c-d869-48ae-8fac-3301e0a36dc3', '2a8cb1ee-9e34-441e-accd-9457b41305c1', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('6b3d0bfa-e903-467b-a8f2-bf24d5e448db', 'e33d5bb2-d16a-4234-bacf-4b4cf1707667', 'HA01', 'VIEW', '2025-06-02 14:39:36.986', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('86a35865-7160-43d5-af63-3fcd59cea8f4', 'aacfe382-a539-4be0-aa9f-67f7d56f1f60', 'HA01', 'VIEW', '2025-06-23 08:11:35.534', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('1703196e-27b5-4c52-9237-3e5ad6f3f132', 'a809485f-b634-4624-85bd-7eeb32097723', 'HA01', 'VIEW', '2025-06-23 08:08:17.392', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('268c9a7d-6467-4a9a-9a14-502842f43e3a', '791685f8-18d4-4b14-96f2-102e05525a93', 'HA01', 'VIEW', '2025-06-23 08:08:17.392', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('edfa0caf-f2e0-4cd8-acd6-fb8982fb67e0', '2c1bad8c-99a5-45b9-b349-c717d68616ee', 'HA01', 'VIEW', '2024-12-17 08:31:41.728', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('d6a1d3d3-8fa1-4ada-8548-dbc3be462ab6', '2c1bad8c-99a5-45b9-b349-c717d68616ee', 'HA08', 'VIEW', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('d4e22ef2-c973-4067-97a7-8c0f6653d4fa', '1f0fef05-fda4-4fc2-a954-935075a7e136', 'HA08', 'VIEW,CREATE,UPDATE,DELETE', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('13d5b73a-6629-4325-b57f-15fbf9874173', 'a07dcc4a-7af3-4aac-9482-216a66e7fb9b', 'HA08', 'VIEW', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('43239cc4-7574-432e-9fd5-d31f90fc87f2', 'e7ba24c1-92b5-4723-8f2d-abe76a5c3f8e', 'HA08', 'VIEW', '2025-03-10 08:32:41.557', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('7c725bf4-9a85-4a61-b0f0-8a3886aeaa08', '1f0fef05-fda4-4fc2-a954-935075a7e136', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2024-12-17 08:31:41.728', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('a2103fb3-72d0-4e1a-ae64-7ccd8e0af0b2', 'edd59047-3ec9-45ab-91f0-85e656986654', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2024-12-17 08:31:41.728', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('131762bd-bb02-408a-849e-b66971a39e26', '804dc040-8882-4b3a-b54d-14635c27a2c2', 'HA01', 'VIEW', '2025-01-02 10:45:58.647', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('0512d89e-a1e3-4c58-a81d-4809c986428b', '298bdb15-97a5-42bf-a388-5f7d4f0eccb1', 'HA01', 'VIEW,CREATE,UPDATE,DELETE', '2024-12-17 08:31:41.728', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('bf646376-c496-4a4c-a400-812b7aa2c5c4', '844c6547-55e3-41e7-8e05-25908211d185', 'HA01', 'VIEW', '2025-06-02 15:05:22.077', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('48f552af-eef5-4d64-9edd-03bebd8f3e92', '78ebd4ad-0068-450a-ba78-bbd5b5d33995', 'HA01', 'VIEW', '2025-06-02 16:58:34.080', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('65b97314-71b5-4394-9592-a3b4df10d0dc', '793686b3-50ef-4bef-9157-9b47504f5ced', 'HA01', 'VIEW', '2025-06-02 16:58:34.080', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('c7945a2c-3e41-4625-bccf-c22a63e68c13', 'c77bf6d3-419f-44be-ad97-37f577030ce9', 'HA01', 'VIEW', '2025-06-02 16:58:34.080', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('6d21393d-c163-4eb7-ab15-52c295616da0', 'f1ed102f-dcb3-4003-b390-fa9a2182900c', 'HA01', 'VIEW', '2025-06-02 16:58:34.080', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('7ba77671-38fc-433a-a67f-1384c0367897', '83144c77-9bd4-4a36-bcf1-9f3c6c697563', 'HA01', 'VIEW', '2025-06-02 16:56:19.870', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('73debd19-bfea-4d1d-8a52-98252b2b2914', '921b92f8-c91b-4bc2-aaef-a2cfec703711', 'HA01', 'VIEW', '2025-06-02 16:56:19.870', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('045b4776-59e1-401b-af49-0d00a89dd9a4', '4c8ce1ab-9b1a-48e1-9319-43b5942883c2', 'HA01', 'VIEW', '2025-06-02 16:56:19.870', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('72fe3eaa-3e58-4aa7-95be-e9ebeaaed771', '71c54d57-6dce-46c2-b406-b2b81a27769d', 'HA01', 'VIEW', '2025-06-02 16:56:19.870', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('bc6bcbe4-f105-4cc1-aec2-2de241a0c2df', 'bc23ab7b-6818-4340-9776-4cf19344b0bd', 'HA01', 'VIEW', '2025-06-02 16:56:19.870', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('2a6824fb-fa21-4551-acd9-3605bfbeef8f', '7771233c-0629-4452-a429-21d7a442302a', 'HA01', 'VIEW', '2025-06-02 16:56:19.870', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('4d3ca56b-ca02-4f87-8eed-c64b586dc9d8', '680f3ad8-91d9-43a2-b9ad-a5b45fb29d8f', 'HA01', 'VIEW', '2025-06-02 16:56:19.870', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('e2494a60-eb1e-48cd-a880-8c590eef5de2', 'effcad0d-9341-4095-b5cd-99f68201d4ba', 'HA01', 'VIEW', '2025-06-02 16:56:19.870', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('148590bb-910b-4a44-a685-d0880d5e5b79', '7bffd126-03db-4c01-8391-aab7928e60f5', 'HA01', 'VIEW', '2025-06-02 16:56:19.870', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('7312302a-1605-44eb-828e-872e998307c6', 'd47570ec-13ea-4db5-867c-a9c3d33c51a9', 'HA01', 'VIEW', '2025-06-02 16:56:19.870', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('b7e97dd9-7742-4106-90ea-56b3cf69df55', '9dff200c-6ba2-401e-840d-3d1545ac2c47', 'HA01', 'VIEW', '2025-06-02 16:56:19.870', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('a79853d2-9333-42f6-81e5-51c5824bae53', '1d43dc43-8c1e-458f-bd71-dc0974d73e56', 'HA01', 'VIEW', '2025-06-02 16:56:19.870', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('8e2afbe8-dcba-46a0-b18c-8a132103633c', 'ff28be31-0ae6-4753-a4d0-d2431854873c', 'HA01', 'VIEW', '2025-06-02 16:56:19.870', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('7e26108f-f39c-4eab-a462-58971f1d792f', '8af7faf3-09da-446d-8036-a142d734e62d', 'HA01', 'VIEW', '2025-06-02 16:56:19.870', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('97dc05ec-91f7-453b-8b27-519e1a71106b', 'ae6f63fd-c1b4-496b-95f1-29c66f202eec', 'HA01', 'VIEW', '2025-06-02 16:56:19.870', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('1e21694b-087d-45be-bd11-93028fa6f236', '4d90cba0-876a-4661-8f7e-0a95928c3c7a', 'HA01', 'VIEW', '2025-06-02 16:56:19.870', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('4a0373ff-437b-468d-b290-9be59081cd66', '64d909c5-a521-47ef-b6d2-407c6a223b40', 'HA01', 'VIEW', '2025-06-02 16:56:19.870', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('5347837f-a216-4ceb-90e9-689d2d96c386', 'a07dcc4a-7af3-4aac-9482-216a66e7fb9b', 'HA01', 'VIEW', '2025-02-07 16:19:50.380', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('d5e33a87-161d-45e6-a477-c3bd66c24e0e', 'e7ba24c1-92b5-4723-8f2d-abe76a5c3f8e', 'HA01', 'VIEW', '2025-02-07 16:19:50.380', NULL);
INSERT INTO public.c_menu_role
(id, menu_id, role_id, "permission", created_at, commodity_id)
VALUES('4a683a53-c91f-4e0a-ab32-d9de7ea6a5ce', '64d3ddf3-bb5b-4847-8a13-0606bd45abe4', 'HA01', 'VIEW', '2025-06-02 15:00:32.691', NULL);

--USER
INSERT INTO public.auth_user
(id, "name", username, email, "password", role_id, person_id, status, foto, active, created_by, created_at, updated_by, updated_at, deleted_at, is_deleted, commodity_id, confidence_absensi, confidence_daftar, status_ekspresi, ekspresi_smile, ekspresi_eyes, lock_lokasi, lock_login, manual_produksi_tph, manual_produksi_pabrik, toleh_kanan, toleh_kiri, pabrik_id, "trigger", tracehold)
VALUES('f9bb8d26-2fe1-47d0-a287-6a6e201eaa23', 'Superadmin', 'superadmin', 'superadmin@gmail.com', '$2a$10$bVPxniv/QZ.8xPsQhQqss.bjZdgxS56fJAxCbmEyl5b7kl7yStLkK', 'HA01', NULL, '1', NULL, true, NULL, '2024-12-16 14:33:47.022', NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1.0);

