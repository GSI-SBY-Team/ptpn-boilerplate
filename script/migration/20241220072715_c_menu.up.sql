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