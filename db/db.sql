PGDMP      !    	    	        }            belajar #   16.9 (Ubuntu 16.9-0ubuntu0.24.04.1) #   16.8 (Ubuntu 16.8-0ubuntu0.24.04.1) 6    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    23597    belajar    DATABASE     s   CREATE DATABASE belajar WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';
    DROP DATABASE belajar;
                postgres    false            �            1255    23631    uuid_generate_v4()    FUNCTION     �   CREATE FUNCTION public.uuid_generate_v4() RETURNS uuid
    LANGUAGE c STRICT PARALLEL SAFE
    AS '$libdir/uuid-ossp', 'uuid_generate_v4';
 )   DROP FUNCTION public.uuid_generate_v4();
       public          postgres    false            �            1259    23599 	   auth_role    TABLE     �   CREATE TABLE public.auth_role (
    id character varying(10) NOT NULL,
    name character varying(100),
    description text
);
    DROP TABLE public.auth_role;
       public         heap    postgres    false            �            1259    23608 	   auth_user    TABLE     5  CREATE TABLE public.auth_user (
    id character varying(36) NOT NULL,
    name character varying(255),
    username character varying(255) NOT NULL,
    email character varying(100),
    password character varying(60) NOT NULL,
    role_id character varying(36) NOT NULL,
    person_id integer,
    status character varying(1),
    foto character varying,
    active boolean DEFAULT true,
    created_by character varying(36),
    created_at timestamp without time zone,
    updated_by character varying(36),
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    is_deleted boolean DEFAULT false,
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
    toleh_kanan boolean,
    toleh_kiri boolean,
    pabrik_id integer,
    trigger boolean DEFAULT false,
    tracehold double precision DEFAULT 1.0
);
    DROP TABLE public.auth_user;
       public         heap    postgres    false            �            1259    23742    auth_user_commodity    TABLE     �  CREATE TABLE public.auth_user_commodity (
    id character varying(36) DEFAULT public.uuid_generate_v4() NOT NULL,
    comodity_id integer,
    id_user character varying(36) NOT NULL,
    created_at timestamp without time zone DEFAULT (now())::timestamp without time zone,
    updated_at timestamp without time zone DEFAULT (now())::timestamp without time zone,
    is_deleted boolean DEFAULT false
);
 '   DROP TABLE public.auth_user_commodity;
       public         heap    postgres    false    227            �            1259    23640    c_menu    TABLE     <  CREATE TABLE public.c_menu (
    id character varying(36) DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying,
    link character varying(100),
    icon character varying(50),
    description text,
    permission_label character varying(50),
    action character varying(50),
    level integer,
    seq integer,
    created_by character varying(36),
    created_at timestamp without time zone,
    updated_by character varying(36),
    updated_at timestamp without time zone,
    is_deleted boolean DEFAULT false,
    parent_id character varying(36)
);
    DROP TABLE public.c_menu;
       public         heap    postgres    false    227            �            1259    23649    c_menu_role    TABLE     -  CREATE TABLE public.c_menu_role (
    id character varying(36) DEFAULT public.uuid_generate_v4() NOT NULL,
    menu_id character varying(36),
    role_id character varying(36),
    permission character varying(50),
    created_at timestamp without time zone DEFAULT now(),
    commodity_id integer
);
    DROP TABLE public.c_menu_role;
       public         heap    postgres    false    227            �            1259    23632    log_activity    TABLE     ;  CREATE TABLE public.log_activity (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    actions character varying(255),
    jam timestamp without time zone,
    keterangan text,
    id_user character varying(36),
    platform character varying(10),
    ip_address text,
    user_agent text,
    kode text
);
     DROP TABLE public.log_activity;
       public         heap    postgres    false    227            �            1259    23715 
   m_afdeling    TABLE       CREATE TABLE public.m_afdeling (
    id integer NOT NULL,
    kode character varying(255),
    nama character varying(255),
    kebun_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    created_by character varying(36),
    updated_by character varying(36),
    is_deleted boolean DEFAULT false,
    active boolean DEFAULT true
);
    DROP TABLE public.m_afdeling;
       public         heap    postgres    false            �            1259    23693    m_commodity    TABLE     ^  CREATE TABLE public.m_commodity (
    id integer NOT NULL,
    kode character varying(100),
    nama character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    created_by character varying(36),
    updated_by character varying(36),
    is_deleted boolean DEFAULT false,
    keterangan text
);
    DROP TABLE public.m_commodity;
       public         heap    postgres    false            �            1259    23701    m_kebun    TABLE     �  CREATE TABLE public.m_kebun (
    id integer NOT NULL,
    kode character varying(100),
    nama character varying(255),
    regional_id integer,
    alamat text,
    keterangan text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    created_by character varying(36),
    updated_by character varying(36),
    is_deleted boolean DEFAULT false,
    active boolean DEFAULT true,
    kode_lama character varying
);
    DROP TABLE public.m_kebun;
       public         heap    postgres    false            �            1259    23666 
   m_regional    TABLE     y  CREATE TABLE public.m_regional (
    id integer NOT NULL,
    nama character varying(255),
    kode character varying(50),
    alamat text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    created_by character varying(36),
    updated_by character varying(36),
    is_deleted boolean DEFAULT false,
    active boolean DEFAULT true
);
    DROP TABLE public.m_regional;
       public         heap    postgres    false            �            1259    23729    pabrik    TABLE     �  CREATE TABLE public.pabrik (
    id integer NOT NULL,
    nama character varying,
    alamat text,
    no_telp character varying,
    comodity_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    created_by character varying(36),
    updated_by character varying(36),
    is_deleted boolean DEFAULT false,
    regional_id integer,
    finish_good_id integer,
    iot_factory_id character varying(36),
    kelompok_mutu character varying
);
    DROP TABLE public.pabrik;
       public         heap    postgres    false            �            1259    23678    person_data    TABLE     !  CREATE TABLE public.person_data (
    id integer NOT NULL,
    nik character varying(20),
    nama character varying(255),
    status integer,
    job_position_id integer,
    regional_id integer,
    kebun_id integer,
    afdeling_id integer,
    golongan_id integer,
    job_code character varying(20),
    e_subgroup character varying(3),
    cost_center character varying(20),
    file_url text,
    start_date character varying,
    end_date character varying,
    mandor_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    created_by character varying(36),
    updated_by character varying(36),
    is_deleted boolean DEFAULT false,
    employee_type_id integer,
    person_type integer,
    companycode character varying,
    register character varying,
    personelsubarea character varying,
    personelsubareanew character varying,
    nama_kebun character varying,
    payrollarea character varying,
    positions character varying,
    positionsdesc character varying,
    afdeling character varying,
    plant9050 character varying,
    totalemployee character varying,
    send_date character varying,
    send_time character varying,
    kode character varying,
    alamat text,
    no_hp character varying,
    nik_ktp character varying(200)
);
    DROP TABLE public.person_data;
       public         heap    postgres    false            �           0    0    COLUMN person_data.person_type    COMMENT     ^   COMMENT ON COLUMN public.person_data.person_type IS '1=MANDOR
2=KARYAWAN
3=PEMASOK
4=PETANI';
          public          postgres    false    221            �          0    23599 	   auth_role 
   TABLE DATA           :   COPY public.auth_role (id, name, description) FROM stdin;
    public          postgres    false    215   �U       �          0    23608 	   auth_user 
   TABLE DATA           �  COPY public.auth_user (id, name, username, email, password, role_id, person_id, status, foto, active, created_by, created_at, updated_by, updated_at, deleted_at, is_deleted, commodity_id, confidence_absensi, confidence_daftar, status_ekspresi, ekspresi_smile, ekspresi_eyes, lock_lokasi, lock_login, manual_produksi_tph, manual_produksi_pabrik, toleh_kanan, toleh_kiri, pabrik_id, trigger, tracehold) FROM stdin;
    public          postgres    false    216   �W       �          0    23742    auth_user_commodity 
   TABLE DATA           k   COPY public.auth_user_commodity (id, comodity_id, id_user, created_at, updated_at, is_deleted) FROM stdin;
    public          postgres    false    226   _X       �          0    23640    c_menu 
   TABLE DATA           �   COPY public.c_menu (id, name, link, icon, description, permission_label, action, level, seq, created_by, created_at, updated_by, updated_at, is_deleted, parent_id) FROM stdin;
    public          postgres    false    218   |X       �          0    23649    c_menu_role 
   TABLE DATA           a   COPY public.c_menu_role (id, menu_id, role_id, permission, created_at, commodity_id) FROM stdin;
    public          postgres    false    219   Eu       �          0    23632    log_activity 
   TABLE DATA           u   COPY public.log_activity (id, actions, jam, keterangan, id_user, platform, ip_address, user_agent, kode) FROM stdin;
    public          postgres    false    217   #�       �          0    23715 
   m_afdeling 
   TABLE DATA           �   COPY public.m_afdeling (id, kode, nama, kebun_id, created_at, updated_at, created_by, updated_by, is_deleted, active) FROM stdin;
    public          postgres    false    224   O�       �          0    23693    m_commodity 
   TABLE DATA           }   COPY public.m_commodity (id, kode, nama, created_at, updated_at, created_by, updated_by, is_deleted, keterangan) FROM stdin;
    public          postgres    false    222   l�       �          0    23701    m_kebun 
   TABLE DATA           �   COPY public.m_kebun (id, kode, nama, regional_id, alamat, keterangan, created_at, updated_at, created_by, updated_by, is_deleted, active, kode_lama) FROM stdin;
    public          postgres    false    223   ��       �          0    23666 
   m_regional 
   TABLE DATA           �   COPY public.m_regional (id, nama, kode, alamat, created_at, updated_at, created_by, updated_by, is_deleted, active) FROM stdin;
    public          postgres    false    220   ��       �          0    23729    pabrik 
   TABLE DATA           �   COPY public.pabrik (id, nama, alamat, no_telp, comodity_id, created_at, updated_at, created_by, updated_by, is_deleted, regional_id, finish_good_id, iot_factory_id, kelompok_mutu) FROM stdin;
    public          postgres    false    225   ×       �          0    23678    person_data 
   TABLE DATA           �  COPY public.person_data (id, nik, nama, status, job_position_id, regional_id, kebun_id, afdeling_id, golongan_id, job_code, e_subgroup, cost_center, file_url, start_date, end_date, mandor_id, created_at, updated_at, created_by, updated_by, is_deleted, employee_type_id, person_type, companycode, register, personelsubarea, personelsubareanew, nama_kebun, payrollarea, positions, positionsdesc, afdeling, plant9050, totalemployee, send_date, send_time, kode, alamat, no_hp, nik_ktp) FROM stdin;
    public          postgres    false    221   ��                  2606    23607    auth_role auth_role_name_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.auth_role
    ADD CONSTRAINT auth_role_name_key UNIQUE (name);
 F   ALTER TABLE ONLY public.auth_role DROP CONSTRAINT auth_role_name_key;
       public            postgres    false    215                       2606    23605    auth_role auth_role_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.auth_role
    ADD CONSTRAINT auth_role_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.auth_role DROP CONSTRAINT auth_role_pkey;
       public            postgres    false    215            6           2606    23750 ,   auth_user_commodity auth_user_commodity_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.auth_user_commodity
    ADD CONSTRAINT auth_user_commodity_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.auth_user_commodity DROP CONSTRAINT auth_user_commodity_pkey;
       public            postgres    false    226                       2606    23620     auth_user auth_user_email_unique 
   CONSTRAINT     \   ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_email_unique UNIQUE (email);
 J   ALTER TABLE ONLY public.auth_user DROP CONSTRAINT auth_user_email_unique;
       public            postgres    false    216                       2606    23618    auth_user auth_user_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.auth_user DROP CONSTRAINT auth_user_pkey;
       public            postgres    false    216                        2606    23622 #   auth_user auth_user_username_unique 
   CONSTRAINT     b   ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_unique UNIQUE (username);
 M   ALTER TABLE ONLY public.auth_user DROP CONSTRAINT auth_user_username_unique;
       public            postgres    false    216            $           2606    23648    c_menu c_menu_pk 
   CONSTRAINT     N   ALTER TABLE ONLY public.c_menu
    ADD CONSTRAINT c_menu_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.c_menu DROP CONSTRAINT c_menu_pk;
       public            postgres    false    218            &           2606    23655    c_menu_role c_menu_role_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.c_menu_role
    ADD CONSTRAINT c_menu_role_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.c_menu_role DROP CONSTRAINT c_menu_role_pk;
       public            postgres    false    219            *           2606    23685    person_data hr_employee_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.person_data
    ADD CONSTRAINT hr_employee_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.person_data DROP CONSTRAINT hr_employee_pkey;
       public            postgres    false    221            "           2606    23639    log_activity log_activity_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.log_activity
    ADD CONSTRAINT log_activity_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.log_activity DROP CONSTRAINT log_activity_pkey;
       public            postgres    false    217            2           2606    23723    m_afdeling m_afdeling_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.m_afdeling
    ADD CONSTRAINT m_afdeling_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.m_afdeling DROP CONSTRAINT m_afdeling_pkey;
       public            postgres    false    224            .           2606    23700    m_commodity m_commodity_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.m_commodity
    ADD CONSTRAINT m_commodity_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.m_commodity DROP CONSTRAINT m_commodity_pkey;
       public            postgres    false    222            0           2606    23709    m_kebun m_kebun_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.m_kebun
    ADD CONSTRAINT m_kebun_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.m_kebun DROP CONSTRAINT m_kebun_pkey;
       public            postgres    false    223            (           2606    23674    m_regional m_regional_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.m_regional
    ADD CONSTRAINT m_regional_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.m_regional DROP CONSTRAINT m_regional_pkey;
       public            postgres    false    220            4           2606    23736    pabrik pabrik_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.pabrik
    ADD CONSTRAINT pabrik_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.pabrik DROP CONSTRAINT pabrik_pkey;
       public            postgres    false    225            ,           2606    23687 "   person_data person_data_nik_unique 
   CONSTRAINT     \   ALTER TABLE ONLY public.person_data
    ADD CONSTRAINT person_data_nik_unique UNIQUE (nik);
 L   ALTER TABLE ONLY public.person_data DROP CONSTRAINT person_data_nik_unique;
       public            postgres    false    221            >           2606    23751 ;   auth_user_commodity auth_user_commodity_id_comodity_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_user_commodity
    ADD CONSTRAINT auth_user_commodity_id_comodity_foreign FOREIGN KEY (comodity_id) REFERENCES public.m_commodity(id) ON DELETE CASCADE;
 e   ALTER TABLE ONLY public.auth_user_commodity DROP CONSTRAINT auth_user_commodity_id_comodity_foreign;
       public          postgres    false    3374    226    222            7           2606    23623     auth_user auth_user_role_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.auth_role(id);
 J   ALTER TABLE ONLY public.auth_user DROP CONSTRAINT auth_user_role_id_fkey;
       public          postgres    false    3354    215    216            8           2606    23656 $   c_menu_role c_menu_role_menu_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.c_menu_role
    ADD CONSTRAINT c_menu_role_menu_id_fkey FOREIGN KEY (menu_id) REFERENCES public.c_menu(id);
 N   ALTER TABLE ONLY public.c_menu_role DROP CONSTRAINT c_menu_role_menu_id_fkey;
       public          postgres    false    219    3364    218            9           2606    23661 $   c_menu_role c_menu_role_role_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.c_menu_role
    ADD CONSTRAINT c_menu_role_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.auth_role(id);
 N   ALTER TABLE ONLY public.c_menu_role DROP CONSTRAINT c_menu_role_role_id_fkey;
       public          postgres    false    219    3354    215            <           2606    23724    m_afdeling kebun_id_fk    FK CONSTRAINT     x   ALTER TABLE ONLY public.m_afdeling
    ADD CONSTRAINT kebun_id_fk FOREIGN KEY (kebun_id) REFERENCES public.m_kebun(id);
 @   ALTER TABLE ONLY public.m_afdeling DROP CONSTRAINT kebun_id_fk;
       public          postgres    false    223    3376    224            ;           2606    23710     m_kebun m_kebun_regional_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.m_kebun
    ADD CONSTRAINT m_kebun_regional_id_fkey FOREIGN KEY (regional_id) REFERENCES public.m_regional(id);
 J   ALTER TABLE ONLY public.m_kebun DROP CONSTRAINT m_kebun_regional_id_fkey;
       public          postgres    false    3368    220    223            =           2606    23737    pabrik pabrik_komoditas_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.pabrik
    ADD CONSTRAINT pabrik_komoditas_id_fkey FOREIGN KEY (comodity_id) REFERENCES public.m_commodity(id);
 I   ALTER TABLE ONLY public.pabrik DROP CONSTRAINT pabrik_komoditas_id_fkey;
       public          postgres    false    225    222    3374            :           2606    23688    person_data regional_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.person_data
    ADD CONSTRAINT regional_id_fk FOREIGN KEY (regional_id) REFERENCES public.m_regional(id);
 D   ALTER TABLE ONLY public.person_data DROP CONSTRAINT regional_id_fk;
       public          postgres    false    3368    221    220            �      x�uSˎ�@<_�i�\�������0�A<n�ЬL3D��a�&�^�LUu�k��0YV$NZ�>�c�]�V�Ǧ����R��y!K�S�Jq&xŊ�������������J�K#�8���.��+��l�.���	��ep�/}%u�u�ε<����;���=OY$���L>1��T��r��*���~�1�^{>*�w%��K��c��Y�L�*OѦ�l��v��9M�N
�_&N�~��ꄬ���UW7B��55.yH�!M	6�W�pB��46�N���vg��(���K�+bI�cYBd<@����&���hs���)s89���enA�m\'ǞE��U�!�\�k<���[� J�~
�|uǸ<��������O�����������x��d�kL �2�C��F���Vr'Hx�ߕ$�7��;���:����1������Z�H`>�����~#���o��N���y'K鈐p�A��;{!����7M���@v      �   �   x�}�O�0@��St����<%DE(B�5g��h��>�C���̔�5p&g��b	��\�(˥%�K~��)[���y�Ȳ&�s�l�6���GC[>�qJ�!��c|�:�N�.���f�,��S��Ř��j�V!e(ۡ������`�'�'p� ��^����bVF,�z��D      �      x������ � �      �      x��}�rG��3��8�'���A[�)�C�v�#9JlI$/����ߵ fR(�7,�@ef��=�����x�N��b�i��Z�Z��+ޢI�������;������������rz{}�x�ooG��i8�Γ�������~�y����;�_�����{����O���ZH�i�lU0�
gQz�l�UrQc�j ��LH��P�=!��	��[�7���Pp�Sj�����6�\��5g�{�tR�%��*���2�7Y+Q�+�ՀN���i��E�P�`��tʟ��@������ۈf�	��p�y�����������OW�� 9ŵ�3@䞶{:��7޸�����l�D>C9��,&Ȟ������oD��bX+Q3�2:�YP�;]�.����]��Bě�OtaEuNg�î����٫�#���pCa:�#�T��x?�aO�=aF�i0�Y�X|f!DôI�%��N�b���7��vL��)&��Zc�����%�~Ѕ�1���_���5�H�)=�FI��g��	��iK����Y�+��1���Cd�;u��i78�7��~慾޳�+0��ǳ������������ߨHJt>��)���ܨ�L8��
���ї�c`�7��@�b���&��>(2�u���f�WO����Q�:|������b|�*N��2@���>��2����j�=�jet����n�@���F�+~Lr2��ZjV+ռ��4G�[�m�	<��p��p�������%z�2˵Q+~���:۲�R������� �z�	<j��Q��-<�ga��LzLւy�П2�j�U�����[8�9B_�/lV��٠'�N�?�D�DOÓ�zOt�#j���=nF�N��%�O%	Â#�WĢ��n��Ġ��~���dw��$i�����������P�s#��$�ف%�=�F!H���XEP"[`�	x(aC���J�&�&7~z_�����:fpz}�a3�|z��|>����_"О#ť3;H��\a$�D�荀��9qVA�@ubA
Mi�P����c��^!�_qi��-��8>;�9Q����h��:��4cG��-�/�$n��H𝨘L�x�郀�(S}^�b��~�w׏O����p6�o烈��S;��i�"S�<�l�p|z��:��a�g�H	�<9c��h�C�p
`1x�� �h�	�!x�5>�~�s'�}�u.�������u��=�]Pl��V�]�?��'l�
)B,�0��<�U$O�B�D.��|�<��YH�� .��r�-�ڍ��6��~�Q�қ�>�[|
rk	�d������ۛ�}���6�Y���'��O�
���[�#��#�
}{�k�C=�p[����	��|vH"�bޖtB� �����m�~�s�6��o�����?����W��� ':��~{~�L����n�(�mY��bn�i��VT�E(܇��������G���R������u��ӉM3]�#ɕWs���Y��yM��a^����Y(�U��.�I~�׿4��~a�kK�b���ɇ��;���З@N\�č�U��t��ˈ}�q7�P�,`���s���!���Xn���Sj->��O�M���?����Q�<~?�8<������j��H1]�� ���qLG��Y"qRl�L86*]�c���+�,خS޺����׹m��i�~п+"0"d�p`�7=V�0Q]�"��~k����`��b~^6�=!eAn��;��`F}CMgƑn �����;B�n!G��섢��*���$xFq�)��II#����=q�۲�#�M��vv��:�:�j���� t���ϼ��l�d!�Z$����tB,�i�_0�]�<�r>ًO��q��=��v�''+^��r����r�W�h�cT<x�&�yf���JhI�B��"�G���o��.���U���
�Z�������o'��_�k�{=@��G����j�at����!����2ies���),��"T�x0r���$�0ڨIt��WO�����q+�;�b�Y|���
�l����������wD�z4��� ���]���zk����J�K��B�_I�#�+*� �����f�G����+ 1����,m���vX��D'��
��M��hMk�Vsݭ���N��Ilj��çF�DFY@Y������t���m�}��{�:�a�����㻓���W!����F�J�S	kv� �8�?JP�y�XjV�z2R!8�p��J�[�Z�&kAdD�W��}	��&�G�k�o;��㹧���qh�U�]�Z(ӕ%�`ᵅHYh�]�m�{��~��=^�g)��7]gqv}����}����j|xq�ϟ&tb{�<�@w0������/���ܜ+d.�&��Eh�T�[m1O�Xf�VY�D�	3_����,�k(Dg5Ҟ[�3%�l��n�G[�p�5'I����\��Nc����*\K)ф�uB2��uB(�|�p� 
w_Wm���l����\Hvx~pu8>ۿ�1+$A�%°඗�>�Y�
͈����� ��t�d��] ��P%�$ȍ,Ƹ7ե(uݕ���}��p�:MV����ãp���|���XG�Z�ԋ�����#/$��|ݔ�����Eڳ�I�w�յқ�Ρ=��C�,�3iB��[�Ѕ��u8��d��V�������s˪�K��.?�_�O1�����YϔD��j�<��[m���s��P�ƄH�a�8��s���]��7��P�w��#�ܞtM$�{�$~����P�n�,zj��5x������b�\�@�IO�7�Yi��){��Oހi���D0�[�Sh*I���A2���tetc9��H�1��Ta�}��czy���'l�gFF����%�l�]��,�T�ATJ"(Hs~�n�k�wr�1k�+�$��N�A��xs�v��6�1���0�q1>>x�6���44�-������gx�=�&����
2�� ����ș/63ÅEVՊ�R���C�_�w�a]�c�kZ�Ozq�r��z7>OW��UeKڶ�O�]X�p��%��K�U52�ZD�.2Z���5��*P�cR5�S))ĸ�snﮗ]�RӤ�j�����yQ���Hz��n�5�6�+��IH֔Fn�����d%�n�I[WU�dڬ@h���������`A{��*�
�-wE�imT�e���T�02VE�xx���eJ�fU��
���LL�Q�7 � �3���{aidYӖp���>u�Q��ס��-�#�S]��%��=E9`L�|���c�0�\3*"EuƋ�u�>֯k:��</�Ay��q��P��M���4f$�����$(�"(:M�hDrA�B!��ʉ\c.X�DD�t��6��N
x�Ƙ�y�{mV��$j��p��H�T���Ĥ�[���`Qr�ҒM
^��Th㌇��:+�e�+��͙��/熏uQ�6'��X��ZS��5A鞱#�=Gf�j0Rd�V�m�
�
�jaJe�MM�7��dc�^�"���)�|])��,aO��������zF~�w���,-K�`y�v5`Vv�v��H�2��2g��BjF2�e>KuSOVo����o��:C��5oݕ�o4�Z�v�WHc� k�v���P���^)m��J�M�?�,B����6����ku�Vyzrv�̾�%�V(: �����@u��#!8f⪐�[��b�S��L��ʠ�T�A��&����M׷^�����l媗G|3ݾ\�i�����~+��M!�����~�_��ns�����4�\^m?���t�~.!~a�`�
6�ȭXh#����$mr
�g�M�©���;nH�8t�GR(�����������TУkb�UMv`�ʃ�>�����?�,�;�܇���]�qB��7 �T![�[̑<'��b�-W�2�>9JDl�4K[�������Ս�T�x�:���Y,L4Y8#eϚ#�ϾqV��J⣩�re��"6�gOz:~�w�z=��"]Z��~g���W१���˝�ą�B\� �  �)�վ	�h��j�`���43^�䣐������gӲ��]��ʪ,-�P�y��ioX�=N�Jy��4`S��l5	:��[i^+��J�yӧ�|���Ƶ��y��?f�>��N>�?��8����m�L6ӵ���m| ��9�ۗ�k.J�61B�N��QŸ@��s�UO���-tk� m^�^���6��ջ��N��e(��>�;9��E��aV*�)j	��
�K�
�mR�Up-��s���s�;��%�WnUd���$��ͥ�Z��}l&|�jp�[<[	�aB���U���6��C4
d���M��:���nUE�B��As?__h���cWa����n��D��oǟ�̞�`���N����H�d�p�����S}����DDna��N�V=��~1y����^�7���7.�[�c ������ɯh_ǿ���m��m0z��5͘JE�BV�aɀ�o���'�4�k�T������Kv�H��#h�Z(��9�h�X'�<��(�W�hf/��LSɍ?~����ޣ*k��#9���^��FUQP�I�;bBl��T�q�����[U~��Ɵ���:~���k�5U�.�zon�+ցك�2o�c��Ry�VZ1�Xc��\?���|Y���������Ү22���
��[��y�OVK�G���3L잳\U���R�.������.�d<�;v�|y�5t5�K�.ƧW�����S[��`wRGc�B�����G��k�1��%��1D�y�78?8CH����?\S���}��	3�i^\�+c}�MH�ڒA�S�m|��[�T陥,��|�U�m�!8Ld�}]S�YpްIʅV�����t-�����w���8���'pP��I-k�sWT�cnC�Jx�������f��²������<lA`���I{;n5i6^��
o��-w�+r9O��*s�ƦkUF�����ł�	��k�.�8��(����BRa�����^8�1s�9tBŨ�_kk��58��[W�<����e���N���o����i�]��d���&�c��WU��HI=W��A��\����9xS\r��+��7��	v~r6��r�B�0�ީv����&�b�ݪ��yV�P���k 7y���!y�wK&�HM���6���6�������;�r>>�t�*����;N,�^�趒�Ne5g��Z0��YfT�%�d�I��R�,瘝�B���(�I��zj������	D�5���	<28�8�ӯ�rM���f8Y�[�����,�D^<���"���-���x��H$ ��4�$\R�cZ=-J8&_��_à��*�����&��Ŀ�)�n��)mCOay���dY�tOf1�ƾ��q�=zv�֛\�ED�O?����v�{�e�B��g����,8��(-⅑s�_��l8���Bv/�E�R8wfh�C'��XMc6)A�]��b]�HqEC�kֲ�d͚'�X����ѻ��Z��9A�pf7ĩ�{� ��B�\%G:XrB'X$K
�E�!J�e�<w9���6<�]�4<zz��L�_52����=Lz�����s�Ո�O��ǫ��������W��%ʠ=����gS�&�
��-�"��O��E�"�jj��gpwf� �
(S� p6a�0l&�K@�_�I]�'�pba1`+�]P�[h�ᕖF�W �b!AA�n&��	}�����/',+�fBω�/p���NW!B_�O����6�,E瑪�LQ��YW�4�h�]��&w����m}y�L�w������/� C���~�F%	�PYk�~�����'�[����F�_�|���2�����TmF�xV�~B7�P��h�t��:�-2v�*�ZmK�ٶ_1�5���5���Rr�����haɻF��s��D����;�{Pjav7z��x�޻�ೃ_�\�s����O�B+j�g�TL��5^��^֑��5�4|y|��%�6tI�U"�k�������^E�s��y�9��#O�3�=�(5V�KN$��z� ���F��m���Xs'�1#ǥ�=U�^��i�8hz�< K�&rn>�J�N��+b���3�FR}��L�Lݝٱ���X]��⪤�!
'[$��)�(�Jz�h"�e�?�5�����s��r���Y'��i��_�]W`6���G��ʫ����/��{ � 庅s'�B�6ob�ͪVXI���	&C�p�Șk��@|^�<i�t�R�=��x��=��������?/�N/�Ng����JP��7va�`+P
���P��M:!��]} HL6"�%�����QEh�~xAm��؏i�W�f���XԞi@�:�G�?8�5j�|w��mu?�Z�>U%�"Q��bQ�Ej��Ss��G��QoV(�3@m޸i�e�=���������"/���
���%B�4�P@zӊ�ø*�`^�bL.H_-of���&~�~�/��g8��+|��-���x���M<b��H��k���=����c�E�<8o:l���S��������s|���H>��I���K��r�e[��DE�W����lvʛt���8��~�X����G�X�T�t� j%mZ���&Z�&ZןYI�O�g��h���Sj�����ޣ������(8�3:Q�2nF]REmb� cKN֐�^��W��Ϛ��%��<_��;Mo����A��.�9!�p/	��T���I���Rq95����Cᅴki�\��k�S���Rjޓ��,U]1���?ut�47W�Oe^]�Ҽ�t�_��Mӽ!сf[8�R� ���d���P{m<���	V2`�NUc��������/�v3���0�ͪ?8>9;��y`��qKof��Ug�� >6רN����m�]H��N+(]�,k����}�U�D�?���*�NN�~`�����hG2xzj�79Eμ�ZLkA=R7���*���Sz�����,��A������Wn����,m�7͠���Hm���6��F�����AU�I&/��	S��?�:�
��a�a���G����U�ɋ����DOU�>WA�S���O�6�T2AKz��{ɟ�,��+�'+�d*;Qt���H�`xOe@�MA6�r����.�6<1��W|��n����ڠO7��_���>,������g�ZP��ܤ�Y|�S%�ZgG��}��L��,4�m��V��%�f��ä}���7�)��Fp�l�N���ؤ��3d�1z����7��I      �      x���[�&G����^E/`"��K�4f A���2/~�����"�dU��Nu�2+�/f��17����Φ�-��P{�j+��ֺX�k��WL#d�U�.W(n]-�u���vۺ����ՙ����_���/�.��n�g���|8_}�����f��s��,�
��&��핓����U}�=Ts͑�r��t��>�݃�1f,���e�߭���rL��$�6̱�OW�]�s1�|��Vj�����ŷs�-���1^~�x�X7[�F��g�c��lw����Q˸Z]��/v���"�Ŷ�cs��0��U\6W,�6�>O����,�˲3��|����u�&/��nSثK�s��6��5[+����h�ʶ6kR�_�E�Jفa��K�n�������_��?����?�M���_��/����'^5�XgXs�+��R�L-�\�z�7�ww<������Q�'+��fc|JW��o���N���V�f��zY����^��ͨ��Z��!�1c�=�?d��t�����#X����)�al�vu�o�~u���-;-_L�T\�)�۩/�7]u�vM�K�����j��Q�Ϙ?��(5�z/��fdB�*��>��g�l�Mn�_#x;{�W^�6��~w�!;jr�_F1����C̗ϊ"誶�k���ɦ�^~m�f�W�|+���şZQ����0n������z�5�!�J���)UE\].��y�C�C��1�ˆ��`5�p����w\ ��X>R�%��F7&�]����Z�,A1�tI���r���m�jnL�m��'���]ct��şN��~����x�ٕjn703ef믔��0��n�e؅ˇ>F~�RGٚ���`ϫ����G3L�N�ጆ��?���w�ڴ�nL/e�+�<cSL�/�j�b|l\6-RM�몬C0�����0�Ma��cS҇O��;6��̗��MA�4ѐ��M��V��/"�i�Z�,�s�H��.˓�f��G@��x^s� ǲ˲����̺��Ak }��"٫c1�8^����D%ts���� ?�"�8�1�q;#�0u�'g���h3�b�ԉ����i�{����=rd7���<+xH%�ל{��O��7�5����R@xx˔�`I�Y`xv�ڝ���)�
d��Ɍ��k���;���ng5
~E�A�7��;� >²��������^%��b�W���@�K�%�df�-�;�I7��O����sL�Y}(}��qaOh�@��Fd�2����̙՟A[��^��HP>�b1V��~����t�[rYX���R ��&6�Ϯ������~�����7�l\�fAx^%�p�e�櫸�<��9ڷ���W^�������<3��@U -q����]�؏s��7�4��/S	��Oi0cg��`�˽�å^��n�Nyȩ]�&� �	�ӥ?�P�Å��{9[�*���@,�K�[a�3��s}eqZ�a�䇠@W��Օ�������m1{�q��I�V�hA+<�Y�`�
7p���( )�5��~D���ہ;	/�IjȨ�Ff�l$���D��07�J��F��%��~�b���o�i����%<���x��y"�X���8���4�I��H;aM�9��WL�4�/Ft����]$���LĜ�h9�d{S��d���<+�v�.?�lr[`2�˶�z&A�,ԶM.��$)P�k9di�#|��叹�;�w��rd!�>6g�C~�%Krb�Y���P���>����c� ?�:�X���+A�u�N"SQ����X>O��i^6�9#��u����0@X,�d,�g�z!�Pǹ��`߲CP�
���;�O�ۺ#��E7�B�G����|us�A(��jU܉l�^kWؽL6��/�N��+j��`�A�9��G������|A�S
�K��5<ls���-�/�3�݁�T��>m!���8�3���d+?��(���6ƀ�Bw��G�W��;xA>�&�ێ>g����P��H���A��Ԗhf4���n�]Я`rGϑؽ8e�`e���LҌ�3�8N,�4&�1����5(F�G�!�r i�%�.\&D���VW���(����>�-%l '�h��H]����^(���e��͈�� ��^�a;�]	d��;�k��a�����Q�#�6b����T�
��ڌ}x^~�8>�6P�Jc@��e_V���Z�c>�#�7~��Rr�$��� |�oK�e�T^f��߀��6�^&��р����(��0H,�f���ܾ�2�Ck�ldRq�/��$��}����.����B����݀��������0�M��D7$�ڊ�v� 8 �
�@��j���M@�lb�x��x+����Z8r$�t�E6P��y��b%:��݊����#��_�9�FM�	���A
r��2`a�}���o&�ԗ��Z�~��w��k{�H�a�m��_��SMl{�b�0Ǯ|#a�]�O��n��A|����w"5�A#��#�WUf57[];��'
n�o ��u���:c�3�Z��/BN*��k��è�N��W��ˊ.�0�[t���_v�U;y0|�F�`�Iv�<'X�Ԏ@��B��<�����#{c�����";�k�$ٵwQ9�d1�'�1s�� }k�>]���?{��6�"�����vH��|]��R��%Q�ѐ.1wR�����ioBg�AqI�Fi8����E��YHiUa;���0�<S����g�U�g��{q�l��o���'?�sݤ����/�����'�A>wDGTy&H�اӉ7�����A�߅_�\�o&u5��W3y�D�Wu�%@s�dR�]2�O&~�>3�����T�' [&#�r^��keP*R������WN-=��%c�h�5�Q")^�?^i���'�߽�t�څF�C���Y|4kO����8LzN��H�p59{ox�P�t*�!���r�2 �gB���O���=�i�Gұ��D̲1��j�PhH�	�!SX+"�MU������ۂM�ndc���@�Z{��{���
&���>�>��=Ρ#�l,�"/�����.d#h����J�=C��>��$��Ms_���#��'�X/�$�!}�j�#VU���As��	Cj&.R���=Ǆ�J���"]����^/H՚����Uf�'�U*��=$cv���X��,5��:X���]T��A�Wǎ(F	�dWp��YP$5��!Z�=4|����x�ѷ^Q��ժ�" [W"bL6PX?O%��$'�?�3�Ǻp; m-�8�xCE��)ߦ��0���,t��fM��tN�����L͇/�>�hF�|٤C�(�	����Li���98���#6,%�)E�C�o�A�@<n�|%,0�������ԟ&�"�3��{|r���Py�2ժ:�Z3�Bx��b4c��:�q�2DB�CYE[r ��
߯�o+F?jI��sP��Hg�jT��P?V�u��B���(2��d�@ |N�c�0��U�Y����*�an�`;��� ��K-n��:��[��w�E��;}B�,j�lZĤS[y�Ͽ~�H��a�2ى7�bL@�س�Lۦ���+��|�5�**k��;�w���o���:���n���>WD>�`AQ�X�B�a��
- r�:���щ�}�QE���ჩ��]i�,������B�(�A�&-�M'��>�l�$�r���/#=��%�*6);lb�M���lNg8/�?z�oG�|��j}
|h��}�V��L1�	����}Wo����[�(,u�9
+��c����(?�޾��T��΂	&��p���3P�2�m_�����;��W�$�C�^)Hme�)��i�%Ȅ��ZwB2��`lW�	ea�S�b��˧���MdZ<�
a�ԏ�C)�]}N5{o���o&�t�D���$�tgu�>��b���CI���z��N�3�WܪҀ�$���qs������/�t�W�8��.�&�`3�����ƽr'�x��&Fz��u^�厾�dꏴ�w�s@�Ex��E���x��؅/���    �]��cNE��SC�ށ۝O)fT��@�l!ʖYԡ��8p�l��r0-�#�nZחE�@t�o�T�D	Y?���iྛ�N^L*�[,�{�����>��;�O=j/z�:h�}NX`h6�]c�:��
 �?T����ޕ8�N��W�_�p�d[����m1;$9nh�R��
�O�p!v3LIG��^dR�y����a�;�`v��@RW�f�J���#C��:7O��#(���_��\���U>��M�>���8DX�_�4�=�������!�	͉�*(���}/�'�*c�n���`q�ЄX�'�A.8ɋ�.ԟ&���a?MR����܎Ws_c��VW�������='X+%�f����a�-\�|��c�̅�(mΠ����/�a����=������o�����}|2<p�R��q�$X��!AO��#l|��*7щ�r���F�9A����+|;~c_l�����ʙ[�h�D�с�t �rͪ�A|�m�	�Z�lEW����^m���N��?�7��$ɛ�&��x�';(� g5��!�_*���3�\*x\v�]ZK˻���(

SL4��ǟ���rUL���r����m��˷T�;"'�$�,27��8�h��k�ULjk�u� �t���e���D����o��	������9�4��d�,~�5v��Qg�J��f�5�7B,U�!N��X$����O%N,�SdU�AV�[�zt���{�\� �1���mX�-��"u�-�3��<�/ڍ~7x�7�"���D�{���;�s�s%�^����`)L�*E��t9��A=��.�Q����4"�P��9�f2牢��e̝V	��h������ֿh������l��U5K���24�5������Q1KL�ߪ��I�MM�q�yb��p�P������R���k8�ncb���� �:Ĥ��ՠ�#LB��'������9�}��q�wF7�l�l�-�θ�c������	�*���t��ŧt	��/��neب��T�����-��ş-uY��P?�j t�q\���3�tE�VhL̅������򂕺Ċ#��&v�{o�w5���>�o�a��X�O��Qq;��J,՗�����BZ�������� h��jq��,�+�*��R��_]���ɥ4�è�9U�Z?C�x�o0Xm~z�$AT�Fwu�H �� ,�`Q�ߧŬ/������V�bp�	���Ԃ�e�nH"�w����i���T�F��2���_p]�"���3A��{X6�_��2<t@�.�J��R�5CuB��T�=�o�҉�3&��+�Q}iEE����������*	�{S\����&��������MS��~��X 4�ç�G�7�5�Ow�^�ΔI@#>k�W-b�m�jO.���طQ��4�ܧ'E�D֥�5�x#@�%�>���nz���q���̾�(uQ�vlx�����H�w�IE��S�#}�ao���Iۄ0�����#�j\E���x��yƅ�#�Sor�s�R���ַw_I�uJ&�(?˻´@�`K'�i����kG��~�6�?B�R�����S��72��F��nڙ\a�o��]��0� �$�x��Z���%tC�Y��rq��[��Z�tFn�����\�K��	+�-f��E�A�1�:�'�h�kw�,>��W��5;��_�K.ZVk��kw�,>��D���|}��;�Z���kw�,>�dl\U��%�	/�0�8`&�2�q����T���HZ���#�Mx�+r�!B"�o�������3�$�������2��ac���c�~g�۩�,�[1��hK�j�����j��c�~g�M:P���eݻ��uҋJjqNp#���R�;������tDMF��B�$@9$"BZ
{g�[�ODpI	ƻؠ���|���1�U�w�k��|'�r*8[�Y�a���R���w�Z�2���[Ƚ�:<��ݒ:��i�}g�i ���L 5��=j=�y42*��Յ���Ƣ{.���s�s��Mo�-�����i&}g�5�N1����'-4]9.v��r�q�|g�?�zݗ *��;��=�j,�&���������,���چk���Elk]�p�d�y~��ŧ��mP������\6�M��4�㸵��Ň����vu�8$�� sp�dῄ�<�)g�iu��� %�����Ec��ծ�����G_�n�>��邆�kT\i80Hg�Bt��΢{���6�iV�t��ak#@t��|����,QU1�Xf�Eۚ�ʗ���qt�����oo��>vω��y1��Φ^7Q'CJ0Zhy��qt5��zTa������8�˦�}Ǭ
r�VdNXm��̟5��&�M����<p�Z�vWU�#�J1���#:`�q�����tw��͍U{�}.���r]7�A�7iY��J"�%<}C�Ns��n�=���:A���1�5�K��Ņ�����⾟[D#v�T�N�k��XUO`�5��7�1�g�+��'�4�g:e��k�֋֋P���7��q�h[�u����y�o$�\$*C�ۧ9��_Y���6���4��n��>���������iO[����d��bZ��	 Rg�T���M�ӌ��]Q��l,-�+�&��P>�����`�k#�V��/��t���te�����`��9�">�w�����C$Ѝ��a/LF��{�^���W�8߼ڀj��JUE�Is?�ŐR^�(k������-D~�M�L�i��um�����9�n"QZ�:��|kH~�`I�)��"�x_���ߊ.�G_��p�?;0����y��{��];�X��M�����{�x,��#��O�N�ݮ6f�%����C�����qR}g�ۈ�Τ�k�$�AY��)<y{��Ӥ���z��G�Y�n]9S͑���"x�G��������jQ�9�d�ױ�eNll�����U�;�7��0ǹ/]:�sjz���A�_1y�Ҿ��ߎ�I[k-B�y�ӷ�R
�>�Z�����Сt��0����s��5}��d�u�Ɠ���`(<�˹/��Q�ۛ�G{.,��ӥ�K̥Baq�c5���Et�0W	 ��rҒ�M��7��x�F�4��;]�0��k�u7[�ֈ�z�9P���뗆�\|�ت��m�B�[t2k�	@�&�{|��Kè�~y�E�^�$��T��BY����8����a<U��̆Nv]��)����a-�%68��嗆�\r-�|AJcJS@��	�d� ���m��,�4��o�O4�G�ϻ���["���@!:�]����W��0`���	��"�����M���:m�Ec[Ai�xVP�1~Utٵ}��w�/wC�/|��itd������3t��P��u5��5�L䆒XǑ�'��sҝ�W�t��-!�����~��@9?N�N�o:���UMқ$5����(!HD���$��@�n���Hnl�*ǆ�|a�y��(���݇N�L�SO��[�G�AhaI�� H��)N�~R�R�g�m�b�E�X�]��;�B{xS�K�x�@��n!���n�U�<�F�r�J��J ��Fuc�(ӣ��нFF��b���Z�0 uȤ�?Gn=O1�!�-��(c�:u���E�c�<b )��o��bxJ�{����g_�\*��&<����}e;`x��%��Q8׿h>���s�`�>���W����\�6���RA4��n�WY��E7�G��~b1=j��A���nz�7F��������"��+3Q���3*�e*tZ�FA镵��ξ���G����̑���ﮑ`܅U��@��d�-٩�k:�nj��!n�k��F�������4�%�D�F���?:�����oh�S��a9'�2��u��ǣ�]��$�G{��[~%H�ʴե���l��ͫ�1�	G�p�����2�f�������׀j�\x=��Q�mY�;n\�~g�a�	�WQc�]'6W�WG���&�����$�v?wѽA���#_��/�'�y�`�d�B����/ �   �FG�:c�v@ޫ���Ԑ�:��ӧ�Y�	| Ii}D\e�L��zJͥ�|�g;@Ԥ�R=2��6һŚ�Qg=u��1����x��L:���B]��
L�#�Ԫ�^aV3ty�d�IR��#)�4���G>���(%苇In=�u�|�:�A��Τ^1L���U��i�x�9����>���������
ʁ      �     x���OK�@��ɧ�cn�����l�
mA�P��M^�%iS��O�b�)xr�4��ORbA����ʖ<nD '�8��d���1� �!g��&�
�)��_��6�����J��%�l�m�� �C|+��ΒdݾŦ��ɀ���f�x<_���g����tjhKa_&F�LY6Z�m֫+�Ě؂�����k4�4{�
�8L�*���rY��ڕ�Qz�-Z� Q�Tk���U��k#�{T�+�;e���76*�t����u{�c���$џO�ay���)K��2H�Y      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �     