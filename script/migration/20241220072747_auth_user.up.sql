CREATE TABLE IF NOT EXISTS public.auth_user
(
    id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    name character varying(255) COLLATE pg_catalog."default",
    username character varying(255) COLLATE pg_catalog."default" NOT NULL,
    email character varying(100) COLLATE pg_catalog."default" NOT NULL,
    password character varying(60) COLLATE pg_catalog."default" NOT NULL,
    role_id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    person_id integer,
    commodity_id integer,
    confidence_absensi integer,
    confidence_daftar integer,
    status_ekspresi boolean,
    ekspresi_smile integer,
    ekspresi_eyes integer,
    lock_lokasi boolean,
    lock_login boolean,
    manual_produksi_tph boolean,
    manual_produksi_pabrik boolean,
    status character varying(1) COLLATE pg_catalog."default",
    foto character varying COLLATE pg_catalog."default",
    active boolean DEFAULT true,
    created_by character varying(36) COLLATE pg_catalog."default",
    created_at timestamp without time zone,
    updated_by character varying(36) COLLATE pg_catalog."default",
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    is_deleted boolean DEFAULT false,
    CONSTRAINT auth_user_pkey PRIMARY KEY (id),
    CONSTRAINT auth_user_email_unique UNIQUE (email),
    CONSTRAINT auth_user_username_unique UNIQUE (username),
    CONSTRAINT auth_user_role_id_fkey FOREIGN KEY (role_id)
        REFERENCES public.auth_role (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);