-- =====================================================================================================================



-- BASE SCHEMA SECTION



-- CREATE SCHEMA
CREATE SCHEMA DATA_WAREHOUSE;


-- COMMENT SCHEMA:
COMMENT ON SCHEMA DATA_WAREHOUSE IS
'As a schema to hold dimension tables, fact tables, and data mart tables, 
totaling as many as each:

1. 13 dimension tables.

2. 3 fact tables.

3. 2 data mart tables.
';



-- =====================================================================================================================



-- DIMENSION TABLE SECTION



-- CREATE TABLE:
-- DIM_APP_ACTIVITY_TYPE
CREATE TABLE DATA_WAREHOUSE.DIM_APP_ACTIVITY_TYPE(
	APP_ACTIVITY_TYPE_ID SERIAL,
	APP_ACTIVITY_TYPE_NAME VARCHAR(50) NOT NULL,
	APP_ACTIVITY_TYPE_DESC TEXT,

	CONSTRAINT dim_app_activity_type_pkey PRIMARY KEY(APP_ACTIVITY_TYPE_ID),

	CONSTRAINT dim_app_activity_type_app_activity_type_name_unique UNIQUE(APP_ACTIVITY_TYPE_NAME)
);


-- COMMENT TABLE:
COMMENT ON TABLE DATA_WAREHOUSE.DIM_APP_ACTIVITY_TYPE IS
'As a place to store and define the attributes owned by the APPLICATION ACTIVITY TYPE''s dimension.
The list of attributes owned with each explanation, namely:

1. APP_ACTIVITY_TYPE_ID := "Has a Primary Key (PK) role that has the purpose of identifying each row in the table and has a unique value for each row."

2. APP_ACTIVITY_TYPE_NAME := "Stores the value of the ACTIVITY TYPE''s name data."

3. APP_ACTIVITY_TYPE_DESC := "To describe anything about the APPLICATION ACTIVITY TYPE."
';


-- INSERT TABLE's DATA:
INSERT INTO DATA_WAREHOUSE.DIM_APP_ACTIVITY_TYPE
	(
		APP_ACTIVITY_TYPE_NAME
	)
	(
		SELECT DISTINCT
			INITCAP(
				TRIM(EVE.event_type)
			)

		FROM
			EVENT.EVENTS AS EVE

		ORDER BY
			INITCAP(TRIM(EVE.event_type)) ASC
	);


-- SELECT TABLE:
SELECT * FROM DATA_WAREHOUSE.DIM_APP_ACTIVITY_TYPE;


-- ALTER TABLE's ID SEQUENCE:
-- ALTER SEQUENCE DATA_WAREHOUSE.DIM_APP_ACTIVITY_TYPE_APP_ACTIVITY_TYPE_ID_seq RESTART;


-- DELETE TABLE's DATA:
-- DELETE FROM DATA_WAREHOUSE.DIM_APP_ACTIVITY_TYPE;


-- DROP TABLE:
-- DROP TABLE IF EXISTS DATA_WAREHOUSE.DIM_APP_ACTIVITY_TYPE;



------------------------------------------------------------------------------------------------------------------------



-- CREATE TABLE:
-- DIM_ADS
CREATE TABLE DATA_WAREHOUSE.DIM_ADS(
	ADS_ID SERIAL,
	ADS_NAME VARCHAR(50),
	ADS_DESC TEXT,

	CONSTRAINT dim_ads_pkey PRIMARY KEY(ADS_ID)
);


-- COMMENT TABLE:
COMMENT ON TABLE DATA_WAREHOUSE.DIM_ADS IS
'As a place to store and define the attributes owned by the ADVERTISE''s dimension.
The list of attributes owned with each explanation, namely:

1. ADS_ID := "Has a Primary Key (PK) role that has the purpose of identifying each row in the table and has a unique value for each row."

2. ADS_NAME := "Stores the value of the ADVERTISE''s name data."

3. ADS_DESC := "To describe anything about the ADVERTISE."
';


-- INSERT TABLE's DATA:
INSERT INTO DATA_WAREHOUSE.DIM_ADS
	(
		ADS_NAME
	)
	(
		SELECT DISTINCT
			FB_ADS.ads_id AS "ADS_NAME"

		FROM
			SOCIAL_MEDIA_MARKETING.FACEBOOK_ADS AS FB_ADS

		UNION

		SELECT DISTINCT
			INST_ADS.ads_id AS "ADS_NAME"

		FROM
			SOCIAL_MEDIA_MARKETING.INSTAGRAM_ADS AS INST_ADS

		ORDER BY
			"ADS_NAME" ASC
	);


-- SELECT TABLE:
SELECT * FROM DATA_WAREHOUSE.DIM_ADS;


-- ALTER TABLE's ID SEQUENCE:
-- ALTER SEQUENCE DATA_WAREHOUSE.DIM_ADS_ADS_ID_seq RESTART;


-- DELETE TABLE's DATA:
-- DELETE FROM DATA_WAREHOUSE.DIM_ADS;


-- DROP TABLE:
-- DROP TABLE IF EXISTS DATA_WAREHOUSE.DIM_ADS;



------------------------------------------------------------------------------------------------------------------------



-- CREATE TABLE:
-- DIM_ADS_SOURCE
CREATE TABLE DATA_WAREHOUSE.DIM_ADS_SOURCE(
	ADS_SOURCE_ID SERIAL,
	ADS_SOURCE_NAME VARCHAR(50) NOT NULL,
	ADS_SOURCE_DESC TEXT,

	CONSTRAINT dim_ads_source_pkey PRIMARY KEY(ADS_SOURCE_ID),

	CONSTRAINT dim_ads_source_ads_source_name_unique UNIQUE(ADS_SOURCE_NAME)
);


-- COMMENT TABLE:
COMMENT ON TABLE DATA_WAREHOUSE.DIM_ADS_SOURCE IS
'As a place to store and define the attributes owned by the ADVERTISE SOURCE''s dimension.
The list of attributes owned with each explanation, namely:

1. ADS_SOURCE_ID := "Has a Primary Key (PK) role that has the purpose of identifying each row in the table and has a unique value for each row."

2. ADS_SOURCE_NAME := "Stores the value of the ADVERTISE SOURCE''s name data."

3. ADS_SOURCE_DESC := "To describe anything about the ADVERTISE SOURCE."
';


-- INSERT TABLE's DATA:
INSERT INTO DATA_WAREHOUSE.DIM_ADS_SOURCE
	(
		ADS_SOURCE_NAME
	)
	VALUES
		('Facebook'),
		('Instagram');


-- SELECT TABLE:
SELECT * FROM DATA_WAREHOUSE.DIM_ADS_SOURCE;


-- ALTER TABLE's ID SEQUENCE:
-- ALTER SEQUENCE DATA_WAREHOUSE.DIM_ADS_SOURCE_ADS_SOURCE_ID_seq RESTART;


-- DELETE TABLE's DATA:
-- DELETE FROM DATA_WAREHOUSE.DIM_ADS_SOURCE;


-- DROP TABLE:
-- DROP TABLE IF EXISTS DATA_WAREHOUSE.DIM_ADS_SOURCE;



------------------------------------------------------------------------------------------------------------------------



-- CREATE TABLE:
-- DIM_DEVICE_PLATFORM_TYPE
CREATE TABLE DATA_WAREHOUSE.DIM_DEVICE_PLATFORM_TYPE(
	DEVICE_PLATFORM_TYPE_ID SERIAL,
	DEVICE_PLATFORM_TYPE_NAME VARCHAR(50) NOT NULL,
	DEVICE_PLATFORM_TYPE_DESC TEXT,

	CONSTRAINT dim_device_platform_type_pkey PRIMARY KEY(DEVICE_PLATFORM_TYPE_ID),

	CONSTRAINT dim_device_platform_type_device_platform_type_name_unique UNIQUE(DEVICE_PLATFORM_TYPE_NAME)
);


-- COMMENT TABLE:
COMMENT ON TABLE DATA_WAREHOUSE.DIM_DEVICE_PLATFORM_TYPE IS
'As a place to store and define the attributes owned by the DEVICE PLATFORM TYPE''s dimension.
The list of attributes owned with each explanation, namely:

1. DEVICE_PLATFORM_TYPE_ID := "Has a Primary Key (PK) role that has the purpose of identifying each row in the table and has a unique value for each row."

2. DEVICE_PLATFORM_TYPE_NAME := "Stores the value of the DEVICE PLATFORM TYPE''s name data."

3. DEVICE_PLATFORM_TYPE_DESC := "To describe anything about the DEVICE PLATFORM TYPE."
';


-- INSERT TABLE's DATA:
INSERT INTO DATA_WAREHOUSE.DIM_DEVICE_PLATFORM_TYPE
	(
		DEVICE_PLATFORM_TYPE_NAME
	)
	(
		SELECT DISTINCT
			CASE
				WHEN TRIM(FB_ADS.DEVICE_TYPE) = 'IOS'
					THEN TRIM(FB_ADS.DEVICE_TYPE)

				ELSE
					INITCAP(
						TRIM(FB_ADS.DEVICE_TYPE)
					)
			END AS "Device_Type"

		FROM
			SOCIAL_MEDIA_MARKETING.FACEBOOK_ADS AS FB_ADS

		UNION

		SELECT DISTINCT
			CASE
				WHEN TRIM(INST_ADS.DEVICE_TYPE) = 'IOS'
					THEN TRIM(INST_ADS.DEVICE_TYPE)

				ELSE
					INITCAP(
						TRIM(INST_ADS.DEVICE_TYPE)
					)
			END AS "Device_Type"

		FROM
			SOCIAL_MEDIA_MARKETING.INSTAGRAM_ADS AS INST_ADS

		ORDER BY "Device_Type" ASC
	);


-- SELECT TABLE:
SELECT * FROM DATA_WAREHOUSE.DIM_DEVICE_PLATFORM_TYPE;


-- ALTER TABLE's ID SEQUENCE:
-- ALTER SEQUENCE DATA_WAREHOUSE.DIM_DEVICE_PLATFORM_TYPE_DEVICE_PLATFORM_TYPE_ID_seq RESTART;


-- DELETE TABLE's DATA:
-- DELETE FROM DATA_WAREHOUSE.DIM_DEVICE_PLATFORM_TYPE;


-- DROP TABLE:
-- DROP TABLE IF EXISTS DATA_WAREHOUSE.DIM_DEVICE_PLATFORM_TYPE;



------------------------------------------------------------------------------------------------------------------------



-- CREATE TABLE:
-- DIM_ADS_DEVICE
CREATE TABLE DATA_WAREHOUSE.DIM_ADS_DEVICE(
	ADS_DEVICE_ID SERIAL,
	ADS_DEVICE_PLATFORM_TYPE_ID INT NOT NULL,
	ADS_DEVICE_IP_ADDRESS VARCHAR(50),
	ADS_DEVICE_DESC TEXT,

	CONSTRAINT dim_ads_device_pkey PRIMARY KEY(ADS_DEVICE_ID),

	CONSTRAINT dim_ads_device_ads_device_platform_type_id_fkey FOREIGN KEY(ADS_DEVICE_PLATFORM_TYPE_ID)
		REFERENCES DATA_WAREHOUSE.DIM_DEVICE_PLATFORM_TYPE(DEVICE_PLATFORM_TYPE_ID)
);


-- COMMENT TABLE:
COMMENT ON TABLE DATA_WAREHOUSE.DIM_ADS_DEVICE IS
'As a place to store and define the attributes owned by the ADVERTISE DEVICE''s dimension.
The list of attributes owned with each explanation, namely:

1. ADS_DEVICE_ID := "Has a Primary Key (PK) role that has the purpose of identifying each row in the table and has a unique value for each row."

2. ADS_DEVICE_PLATFORM_TYPE_ID := "Stores the value of the ADVERTISE DEVICE''s platform type identification data that refers to the table "DIM_DEVICE_PLATFORM_TYPE" in schema "DATA_WAREHOUSE"."

3. ADS_DEVICE_IP_ADDRESS := "Stores the value of the ADVERTISE DEVICE''s IP address data."

4. ADS_DEVICE_DESC := "To describe anything about the ADVERTISE DEVICE."
';


-- INSERT TABLE's DATA:
INSERT INTO DATA_WAREHOUSE.DIM_ADS_DEVICE
	(
		ADS_DEVICE_PLATFORM_TYPE_ID,
		ADS_DEVICE_IP_ADDRESS
	)
	(
		SELECT
			(
				SELECT
					SUB_DEV_PLAT_TYPE.DEVICE_PLATFORM_TYPE_ID

				FROM
					DATA_WAREHOUSE.DIM_DEVICE_PLATFORM_TYPE AS SUB_DEV_PLAT_TYPE

				WHERE LOWER(SUB_DEV_PLAT_TYPE.DEVICE_PLATFORM_TYPE_NAME) = LOWER(TRIM(FB_ADS.DEVICE_TYPE))
			) AS "Device_Platform_ID",

			FB_ADS.device_id AS "Device_IP"

		FROM
			SOCIAL_MEDIA_MARKETING.FACEBOOK_ADS AS FB_ADS

			INNER JOIN DATA_WAREHOUSE.DIM_DEVICE_PLATFORM_TYPE AS DEV_PLAT_TYPE
				ON LOWER(FB_ADS.DEVICE_TYPE) = LOWER(DEV_PLAT_TYPE.DEVICE_PLATFORM_TYPE_NAME)

		UNION

		SELECT
			(
				SELECT
					SUB_DEV_PLAT_TYPE.DEVICE_PLATFORM_TYPE_ID

				FROM
					DATA_WAREHOUSE.DIM_DEVICE_PLATFORM_TYPE AS SUB_DEV_PLAT_TYPE

				WHERE LOWER(SUB_DEV_PLAT_TYPE.DEVICE_PLATFORM_TYPE_NAME) = LOWER(TRIM(INST_ADS.DEVICE_TYPE))
			) AS "Device_Platform_ID",

			INST_ADS.device_id AS "Device_IP"

		FROM
			SOCIAL_MEDIA_MARKETING.INSTAGRAM_ADS AS INST_ADS

			INNER JOIN DATA_WAREHOUSE.DIM_DEVICE_PLATFORM_TYPE AS DEV_PLAT_TYPE
				ON LOWER(INST_ADS.DEVICE_TYPE) = LOWER(DEV_PLAT_TYPE.DEVICE_PLATFORM_TYPE_NAME)

		ORDER BY
			"Device_Platform_ID" ASC
	);

-- SELECT TABLE:
SELECT * FROM DATA_WAREHOUSE.DIM_ADS_DEVICE;


-- ALTER TABLE's ID SEQUENCE:
-- ALTER SEQUENCE DATA_WAREHOUSE.DIM_ADS_DEVICE_ADS_DEVICE_ID_seq RESTART;


-- DELETE TABLE's DATA:
-- DELETE FROM DATA_WAREHOUSE.DIM_ADS_DEVICE;


-- DROP TABLE:
-- DROP TABLE IF EXISTS DATA_WAREHOUSE.DIM_ADS_DEVICE;



------------------------------------------------------------------------------------------------------------------------



-- CREATE TABLE:
-- DIM_ADS_CLIENT
CREATE TABLE DATA_WAREHOUSE.DIM_ADS_CLIENT(
	ADS_CLIENT_ID INT,
    ADS_ID INT NOT NULL,
	ADS_SOURCE_ID INT NOT NULL,
	ADS_DEVICE_ID INT NOT NULL,
    ADS_RELEASE_TIMESTAMP TIMESTAMP,
	ADS_CLIENT_DESC TEXT,

	CONSTRAINT dim_ads_client_pkey PRIMARY KEY(ADS_CLIENT_ID),

	CONSTRAINT dim_ads_client_add_id_fkey FOREIGN KEY(ADS_ID)
		REFERENCES DATA_WAREHOUSE.DIM_ADS(ADS_ID),

	CONSTRAINT dim_ads_client_add_source_id_fkey FOREIGN KEY(ADS_SOURCE_ID)
		REFERENCES DATA_WAREHOUSE.DIM_ADS_SOURCE(ADS_SOURCE_ID),

	CONSTRAINT dim_ads_client_ads_device_id_fkey FOREIGN KEY(ADS_DEVICE_ID)
		REFERENCES DATA_WAREHOUSE.DIM_ADS_DEVICE(ADS_DEVICE_ID)
);


-- COMMENT TABLE:
COMMENT ON TABLE DATA_WAREHOUSE.DIM_ADS_CLIENT IS
'As a place to store and define the attributes owned by the ADVERTISE''s dimension.
The list of attributes owned with each explanation, namely:

1. ADS_CLIENT_ID := "Has a Primary Key (PK) role that has the purpose of identifying each row in the table and has a unique value for each row."

2. ADS_ID := "Stores the value of the ADVERTISE CLIENT''s advertise identification data that refers to the table "DIM_ADS" in schema "DATA_WAREHOUSE"."

3. ADS_SOURCE_ID := "Stores the value of the ADVERTISE''s source identification data that refers to the table "DIM_ADS_SOURCE" in schema "DATA_WAREHOUSE"."

4. ADS_DEVICE_ID := "Stores the value of the ADVERTISE CLIENT''s device identification data that refers to the table "DIM_ADS_DEVICE" in schema "DATA_WAREHOUSE"."

5. ADS_RELEASE_TIMESTAMP := "Stores the value of the ADVERTISE CLIENT''s release data in the format of date and time."

6. ADS_CLIENT_DESC := "To describe anything about the ADVERTISE CLIENT."
';


-- INSERT TABLE's DATA:
INSERT INTO DATA_WAREHOUSE.DIM_ADS_CLIENT
	(
		ADS_CLIENT_ID,
		ADS_ID,
		ADS_SOURCE_ID,
		ADS_DEVICE_ID,
		ADS_RELEASE_TIMESTAMP
	)
	(
		SELECT
			FB_ADS.client_id AS "ADS_CLIENT_ID",

			D_ADS.ads_id AS "ADS_ID",

			(
				SELECT
					ADS_SRC.ads_source_id

				FROM
					DATA_WAREHOUSE.DIM_ADS_SOURCE AS ADS_SRC

				WHERE
					ADS_SRC.ads_source_name = 'Facebook'
			),

			(
				SELECT
					ADS_DEV.ads_device_id

				FROM
					DATA_WAREHOUSE.DIM_ADS_DEVICE AS ADS_DEV

					INNER JOIN DATA_WAREHOUSE.DIM_DEVICE_PLATFORM_TYPE AS DEV_PLAT_TYPE
						ON ADS_DEV.ads_device_platform_type_id = DEV_PLAT_TYPE.device_platform_type_id

				WHERE
					LOWER(DEV_PLAT_TYPE.device_platform_type_name) = LOWER(FB_ADS.device_type)
					AND ADS_DEV.ads_device_ip_address = FB_ADS.device_id
			) AS "ADS_DEVICE_ID",

			FB_ADS.timestamp AS "ADS_RELEASE_TIMESTAMP"

		FROM
			SOCIAL_MEDIA_MARKETING.FACEBOOK_ADS AS FB_ADS

			INNER JOIN DATA_WAREHOUSE.DIM_ADS AS D_ADS
				ON FB_ADS.ads_id = D_ADS.ads_name

		UNION

		SELECT
			INST_ADS.client_id AS "ADS_CLIENT_ID",

			D_ADS.ads_id AS "ADS_ID",

			(
				SELECT
					ADS_SRC.ads_source_id

				FROM
					DATA_WAREHOUSE.DIM_ADS_SOURCE AS ADS_SRC

				WHERE
					ADS_SRC.ads_source_name = 'Instagram'
			),

			(
				SELECT
					ADS_DEV.ADS_DEVICE_ID

				FROM
					DATA_WAREHOUSE.DIM_ADS_DEVICE AS ADS_DEV

					INNER JOIN DATA_WAREHOUSE.DIM_DEVICE_PLATFORM_TYPE AS DEV_PLAT_TYPE
						ON ADS_DEV.ADS_DEVICE_PLATFORM_TYPE_ID = DEV_PLAT_TYPE.DEVICE_PLATFORM_TYPE_ID

				WHERE
					LOWER(DEV_PLAT_TYPE.DEVICE_PLATFORM_TYPE_NAME) = LOWER(INST_ADS.DEVICE_TYPE)
					AND ADS_DEV.ADS_DEVICE_IP_ADDRESS = INST_ADS.DEVICE_ID
			) AS "ADS_DEVICE_ID",

			INST_ADS.timestamp AS "ADS_RELEASE_TIMESTAMP"

		FROM
			SOCIAL_MEDIA_MARKETING.INSTAGRAM_ADS AS INST_ADS

			INNER JOIN DATA_WAREHOUSE.DIM_ADS AS D_ADS
				ON INST_ADS.ads_id = D_ADS.ads_name

		ORDER BY
			"ADS_CLIENT_ID" ASC
	);


-- SELECT TABLE:
SELECT * FROM DATA_WAREHOUSE.DIM_ADS_CLIENT;


-- DELETE TABLE's DATA:
-- DELETE FROM DATA_WAREHOUSE.DIM_ADS_CLIENT;


-- DROP TABLE:
-- DROP TABLE IF EXISTS DATA_WAREHOUSE.DIM_ADS_CLIENT;



------------------------------------------------------------------------------------------------------------------------



-- CREATE TABLE:
-- DIM_USERS
CREATE TABLE DATA_WAREHOUSE.DIM_USERS(
	USER_ID INT,
    USER_FIRST_NAME VARCHAR(50) NOT NULL,
    USER_LAST_NAME VARCHAR(50),
    USER_EMAIL VARCHAR(100) NOT NULL,
    USER_DOB DATE NOT NULL,
	USER_AGE INT NOT NULL,
	USER_ELIGIBLE_STAT VARCHAR(12) NOT NULL,
    USER_GENDER VARCHAR(10) DEFAULT 'Unknown',
	USER_DESC TEXT,
	ADS_CLIENT_ID INT,

	CONSTRAINT dim_users_pkey PRIMARY KEY(USER_ID),

	CONSTRAINT dim_users_ads_client_id_fkey FOREIGN KEY(ADS_CLIENT_ID)
		REFERENCES DATA_WAREHOUSE.DIM_ADS_CLIENT(ADS_CLIENT_ID),

	CONSTRAINT dim_users_user_age_check CHECK(USER_AGE >= 10),
	
	CONSTRAINT dim_users_user_eligible_stat_check CHECK(USER_ELIGIBLE_STAT IN ('Eligible', 'Not Eligible')),

	CONSTRAINT dim_users_user_gender_check CHECK(USER_GENDER IN ('Unknown', 'Male', 'Female'))
);


-- COMMENT TABLE:
COMMENT ON TABLE DATA_WAREHOUSE.DIM_USERS IS
'As a place to store and define the attributes owned by the USER''s dimension.
The list of attributes owned with each explanation, namely:

1. USER_ID := "Has a Primary Key (PK) role that has the purpose of identifying each row in the table and has a unique value for each row."

2. USER_FIRST_NAME := "Stores the value of the USER''s first name data."

3. USER_LAST_NAME := "Stores the value of the USER''s last name data."

4. USER_EMAIL := "Stores the value of the USER''s email data."

5. USER_DOB := "Stores the value of the USER''s date of birth data."

6. USER_AGE := "Stores the value of the USER''s age data (in YEARS measurement). The application requires the user''s age at least 10 years old."

7. USER_ELIGIBLE_STAT := "Stores the value of the USER''s eligible status data based on the restricted age which must be at least 18 years old.
If below that, then it will appear as a friendly-content advertisement."

8. USER_GENDER := "Stores the value of the USER''s gender data. In general, gender is divided into two categories, namely ''Male'' and ''Female''. 
However, if the USER does not want to know his gender (privacy concerns), then it is categorized as ''Unknown''."

9. USER_DESC := "To describe anything about the USER."

10. ADS_CLIENT_ID := "Stores the value of the USER''s chosen advertising identification data that refers to the table "DIM_ADS" in schema "DATA_WAREHOUSE"."
';


-- INSERT TABLE's DATA:
INSERT INTO DATA_WAREHOUSE.DIM_USERS
	(
		USER_ID,
		USER_FIRST_NAME,
		USER_LAST_NAME,
		USER_EMAIL,
		USER_DOB,
		USER_AGE,
		USER_ELIGIBLE_STAT,
		USER_GENDER,
		ADS_CLIENT_ID
	)
	(
		SELECT
			USR.user_id,

			INITCAP(
				TRIM(USR.first_name)
			),

			INITCAP(
				TRIM(USR.last_name)
			),

			TRIM(USR.email),

			USR.DOB,

			CAST(EXTRACT(YEARS FROM AGE(dob)) AS INT),

			CASE
				WHEN CAST(EXTRACT(YEARS FROM AGE(dob)) AS INT) < 18
					THEN 'Not Eligible'

				ELSE
					'Eligible'
			END,

			CASE
				WHEN INITCAP(TRIM(USR.gender)) IN ('Male', 'Female')
					THEN INITCAP(USR.gender)

				ELSE
					'Unknown'
			END,

			USR.client_id

		FROM
			USERS.USERS AS USR

		WHERE
			CAST(EXTRACT(YEARS FROM AGE(dob)) AS INT) >= 10

		ORDER BY
			INITCAP(TRIM(USR.first_name)) ASC
	);


-- SELECT TABLE:
SELECT * FROM DATA_WAREHOUSE.DIM_USERS;


-- DELETE TABLE's DATA:
-- DELETE FROM DATA_WAREHOUSE.DIM_USERS;


-- DROP TABLE:
-- DROP TABLE IF EXISTS DATA_WAREHOUSE.DIM_USERS;



------------------------------------------------------------------------------------------------------------------------



-- CREATE TABLE:
-- DIM_DATE_QUARTER
CREATE TABLE DATA_WAREHOUSE.DIM_DATE_QUARTER(
	DATE_QUARTER_ID NUMERIC(1,0),
	DATE_QUARTER_ABBREVIATION_NAME VARCHAR(10),
	DATE_QUARTER_FULL_NAME VARCHAR(20),
	DATE_QUARTER_DESC TEXT,

	CONSTRAINT dim_date_quarter_pkey PRIMARY KEY(DATE_QUARTER_ID)
);


-- COMMENT TABLE:
COMMENT ON TABLE DATA_WAREHOUSE.DIM_DATE_QUARTER IS
'As a place to store and define the attributes owned by the DATE QUARTER''s dimension.
The list of attributes owned with each explanation, namely:

1. DATE_QUARTER_ID := "Has a Primary Key (PK) role that has the purpose of identifying each row in the table and has a unique value for each row."

2. DATE_QUARTER_ABBREVIATION_NAME := "Stores the value of the DATE QUARTER''s abbreviated name data."

3. DATE_QUARTER_FULL_NAME := "Stores the value of the DATE QUARTER''s full name data."

4. DATE_QUARTER_DESC := "To describe anything about the DATE QUARTER."
';


-- INSERT TABLE's DATA:
INSERT INTO DATA_WAREHOUSE.DIM_DATE_QUARTER
	(
		DATE_QUARTER_ID,
		DATE_QUARTER_ABBREVIATION_NAME,
		DATE_QUARTER_FULL_NAME
	)
	(
		SELECT DISTINCT
			EXTRACT(QUARTER FROM FB_ADS.TIMESTAMP) AS "DATE_QUARTER",

			TO_CHAR(FB_ADS.TIMESTAMP, '"Q"Q') AS "DATE_QUARTER_ABBREVIATION_NAME",

			TO_CHAR(FB_ADS.TIMESTAMP, '"Quarter" Q') AS "DATE_QUARTER_FULL_NAME"

		FROM
			SOCIAL_MEDIA_MARKETING.FACEBOOK_ADS AS FB_ADS

		UNION

		SELECT DISTINCT
			EXTRACT(QUARTER FROM INST_ADS.TIMESTAMP) AS "DATE_QUARTER",

			TO_CHAR(INST_ADS.TIMESTAMP, '"Q"Q') AS "DATE_QUARTER_ABBREVIATION_NAME",

			TO_CHAR(INST_ADS.TIMESTAMP, '"Quarter" Q') AS "DATE_QUARTER_FULL_NAME"

		FROM
			SOCIAL_MEDIA_MARKETING.INSTAGRAM_ADS AS INST_ADS

		UNION

		SELECT DISTINCT
			EXTRACT(QUARTER FROM EVE.TIMESTAMP) AS "DATE_QUARTER",

			TO_CHAR(EVE.TIMESTAMP, '"Q"Q') AS "DATE_QUARTER_ABBREVIATION_NAME",

			TO_CHAR(EVE.TIMESTAMP, '"Quarter" Q') AS "DATE_QUARTER_FULL_NAME"

		FROM
			EVENT.EVENTS AS EVE

		UNION

		SELECT DISTINCT
			EXTRACT(QUARTER FROM USR_TRANS.TRANSACTION_DATE) AS "DATE_QUARTER",

			TO_CHAR(USR_TRANS.TRANSACTION_DATE, '"Q"Q') AS "DATE_QUARTER_ABBREVIATION_NAME",

			TO_CHAR(USR_TRANS.TRANSACTION_DATE, '"Quarter" Q') AS "DATE_QUARTER_FULL_NAME"

		FROM
			USERS.USER_TRANSACTIONS AS USR_TRANS

		ORDER BY
			"DATE_QUARTER" ASC
	);


-- SELECT TABLE:
SELECT * FROM DATA_WAREHOUSE.DIM_DATE_QUARTER;


-- DELETE TABLE's DATA:
-- DELETE FROM DATA_WAREHOUSE.DIM_DATE_QUARTER;


-- DROP TABLE:
-- DROP TABLE IF EXISTS DATA_WAREHOUSE.DIM_DATE_QUARTER;



------------------------------------------------------------------------------------------------------------------------



-- CREATE TABLE:
-- DIM_DATE
CREATE TABLE DATA_WAREHOUSE.DIM_DATE(
	DATE_ID DATE,
	DATE_DAY_NAME VARCHAR(20),
	DATE_MONTH_ABBREVIATION_NAME VARCHAR(10),
	DATE_MONTH_FULL_NAME VARCHAR(20),
	DATE_YEAR NUMERIC(4,0),
	DATE_QUARTER_ID NUMERIC(1,0) NOT NULL,
	DATE_DAY_OF_WEEK INT,
	DATE_DAY_OF_MONTH INT,
	DATE_DAY_OF_YEAR INT,
	DATE_DESC TEXT,

	CONSTRAINT dim_date_pkey PRIMARY KEY(DATE_ID),

	CONSTRAINT dim_date_date_quarter_id_fkey FOREIGN KEY(DATE_QUARTER_ID)
		REFERENCES DATA_WAREHOUSE.DIM_DATE_QUARTER(DATE_QUARTER_ID)
);


-- COMMENT TABLE:
COMMENT ON TABLE DATA_WAREHOUSE.DIM_DATE IS
'As a place to store and define the attributes owned by the DATE''s dimension.
The list of attributes owned with each explanation, namely:

1. DATE_ID := "Has a Primary Key (PK) role that has the purpose of identifying each row in the table and has a unique value for each row."

2. DATE_DAY_NAME := "Stores the value of the DATE''s day name data."

3. DATE_MONTH_ABBREVIATION_NAME := "Stores the value of the DATE''s abbreviated name of month data."

4. DATE_MONTH_FULL_NAME := "Stores the value of the DATE''s full name of month data."

5. DATE_YEAR := "Stores the value of the DATE''s year data."

6. DATE_QUARTER_ID := "Stores the value of the DATE''s quarter identification data that refers to the table "DIM_DATE_QUARTER" in schema "DATA_WAREHOUSE"."

7. DATE_DAY_OF_WEEK := "Stores the value of the DATE''s day of week data."

8. DATE_DAY_OF_MONTH := "Stores the value of the DATE''s day of month data."

9. DATE_DAY_OF_YEAR := "Stores the value of the DATE''s day of year data."

10. DATE_DESC := "To describe anything about the DATE."
';


-- INSERT TABLE's DATA:
INSERT INTO DATA_WAREHOUSE.DIM_DATE
	(
		DATE_ID,
		DATE_DAY_NAME,
		DATE_MONTH_ABBREVIATION_NAME,
		DATE_MONTH_FULL_NAME,
		DATE_YEAR,
		DATE_QUARTER_ID,
		DATE_DAY_OF_WEEK,
		DATE_DAY_OF_MONTH,
		DATE_DAY_OF_YEAR
	)
	(
		SELECT DISTINCT
			CAST(FB_ADS.TIMESTAMP AS DATE) AS "DATE_ID",

			CAST(TO_CHAR(FB_ADS.TIMESTAMP, 'DD') AS VARCHAR) AS "DATE_DAY_NAME",

			CAST(TO_CHAR(FB_ADS.TIMESTAMP, 'Mon') AS VARCHAR) AS DATE_MONTH_ABBREVIATION_NAME,

			CAST(TO_CHAR(FB_ADS.TIMESTAMP, 'Month') AS VARCHAR) AS DATE_MONTH_FULL_NAME,

			CAST(EXTRACT(YEAR FROM FB_ADS.TIMESTAMP) AS INT) AS "DATE_YEAR",

			EXTRACT(QUARTER FROM FB_ADS.TIMESTAMP) AS "DATE_QUARTER",

			CAST(EXTRACT(DOW FROM FB_ADS.TIMESTAMP) AS INT) AS "DATE_DAY_OF_WEEK",

			CAST(date_part('days', (date_trunc('month', FB_ADS.TIMESTAMP) + interval '1 month - 1 day')) AS INT) AS "DATE_DAY_OF_MONTH",

			CAST(EXTRACT(DOY FROM FB_ADS.TIMESTAMP) AS INT) AS "DATE_DAY_OF_YEAR"

		FROM
			SOCIAL_MEDIA_MARKETING.FACEBOOK_ADS AS FB_ADS

		UNION

		SELECT DISTINCT
			CAST(INST_ADS.TIMESTAMP AS DATE) AS "DATE_ID",

			CAST(TO_CHAR(INST_ADS.TIMESTAMP, 'DD') AS VARCHAR) AS "DATE_DAY_NAME",

			CAST(TO_CHAR(INST_ADS.TIMESTAMP, 'Mon') AS VARCHAR) AS DATE_MONTH_ABBREVIATION_NAME,

			CAST(TO_CHAR(INST_ADS.TIMESTAMP, 'Month') AS VARCHAR) AS DATE_MONTH_FULL_NAME,

			CAST(EXTRACT(YEAR FROM INST_ADS.TIMESTAMP) AS INT) AS "DATE_YEAR",

			EXTRACT(QUARTER FROM INST_ADS.TIMESTAMP) AS "DATE_QUARTER",

			CAST(EXTRACT(DOW FROM INST_ADS.TIMESTAMP) AS INT) AS "DATE_DAY_OF_WEEK",

			CAST(date_part('days', (date_trunc('month', INST_ADS.TIMESTAMP) + interval '1 month - 1 day')) AS INT) AS "DATE_DAY_OF_MONTH",

			CAST(EXTRACT(DOY FROM INST_ADS.TIMESTAMP) AS INT) AS "DATE_DAY_OF_YEAR"

		FROM
			SOCIAL_MEDIA_MARKETING.INSTAGRAM_ADS AS INST_ADS

		UNION

		SELECT DISTINCT
			CAST(EVE.TIMESTAMP AS DATE) AS "DATE_ID",

			CAST(TO_CHAR(EVE.TIMESTAMP, 'DD') AS VARCHAR) AS "DATE_DAY_NAME",

			CAST(TO_CHAR(EVE.TIMESTAMP, 'Mon') AS VARCHAR) AS DATE_MONTH_ABBREVIATION_NAME,

			CAST(TO_CHAR(EVE.TIMESTAMP, 'Month') AS VARCHAR) AS DATE_MONTH_FULL_NAME,

			CAST(EXTRACT(YEAR FROM EVE.TIMESTAMP) AS INT) AS "DATE_YEAR",

			EXTRACT(QUARTER FROM EVE.TIMESTAMP) AS "DATE_QUARTER",

			CAST(EXTRACT(DOW FROM EVE.TIMESTAMP) AS INT) AS "DATE_DAY_OF_WEEK",

			CAST(date_part('days', (date_trunc('month', EVE.TIMESTAMP) + interval '1 month - 1 day')) AS INT) AS "DATE_DAY_OF_MONTH",

			CAST(EXTRACT(DOY FROM EVE.TIMESTAMP) AS INT) AS "DATE_DAY_OF_YEAR"

		FROM
			EVENT.EVENTS AS EVE

		UNION

		SELECT DISTINCT
			CAST(USR_TRANS.TRANSACTION_DATE AS DATE) AS "DATE_ID",

			CAST(TO_CHAR(USR_TRANS.TRANSACTION_DATE, 'DD') AS VARCHAR) AS "DATE_DAY_NAME",

			CAST(TO_CHAR(USR_TRANS.TRANSACTION_DATE, 'Mon') AS VARCHAR) AS DATE_MONTH_ABBREVIATION_NAME,

			CAST(TO_CHAR(USR_TRANS.TRANSACTION_DATE, 'Month') AS VARCHAR) AS DATE_MONTH_FULL_NAME,

			CAST(EXTRACT(YEAR FROM USR_TRANS.TRANSACTION_DATE) AS INT) AS "DATE_YEAR",

			EXTRACT(QUARTER FROM USR_TRANS.TRANSACTION_DATE) AS "DATE_QUARTER",

			CAST(EXTRACT(DOW FROM USR_TRANS.TRANSACTION_DATE) AS INT) AS "DATE_DAY_OF_WEEK",

			CAST(date_part('days', (date_trunc('month', USR_TRANS.TRANSACTION_DATE) + interval '1 month - 1 day')) AS INT) AS "DATE_DAY_OF_MONTH",

			CAST(EXTRACT(DOY FROM USR_TRANS.TRANSACTION_DATE) AS INT) AS "DATE_DAY_OF_YEAR"

		FROM
			USERS.USER_TRANSACTIONS AS USR_TRANS

		ORDER BY
			"DATE_ID" ASC
	);


-- SELECT TABLE:
SELECT * FROM DATA_WAREHOUSE.DIM_DATE;


-- DELETE TABLE's DATA:
-- DELETE FROM DATA_WAREHOUSE.DIM_DATE;


-- DROP TABLE:
-- DROP TABLE IF EXISTS DATA_WAREHOUSE.DIM_DATE;



-- =====================================================================================================================