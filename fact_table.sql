-- =====================================================================================================================



-- FACT TABLE SECTION



-- CREATE TABLE:
-- FACT_USER_PERFORMANCE
CREATE TABLE DATA_WAREHOUSE.FACT_USER_PERFORMANCE(
	USER_ID SERIAL,
	USER_ACCOUNT_DAYS_OLD INT DEFAULT 0,
	USER_ACCOUNT_MONTH_OLD INT DEFAULT 0,
	USER_RECENT_ACTIVITY_TYPE_ID INT NOT NULL,
	USER_RECENT_ACTIVITY_DATE_ID DATE NOT NULL,
	USER_RECENT_ACTIVITY_USAGE_HOUR_TIME INT,

	CONSTRAINT fact_user_performance_pkey PRIMARY KEY(USER_ID),

	CONSTRAINT fact_user_performance_user_id_fkey FOREIGN KEY(USER_ID)
		REFERENCES DATA_WAREHOUSE.DIM_USERS(USER_ID),

	CONSTRAINT fact_user_performance_user_recent_activity_type_id_fkey FOREIGN KEY(USER_RECENT_ACTIVITY_TYPE_ID)
		REFERENCES DATA_WAREHOUSE.DIM_APP_ACTIVITY_TYPE(APP_ACTIVITY_TYPE_ID),

	CONSTRAINT fact_user_performance_user_recent_activity_date_id_fkey FOREIGN KEY(USER_RECENT_ACTIVITY_DATE_ID)
		REFERENCES DATA_WAREHOUSE.DIM_DATE(DATE_ID)
);


-- COMMENT TABLE:
COMMENT ON TABLE DATA_WAREHOUSE.FACT_USER_PERFORMANCE IS
'As a place to store and define the attributes owned by the USER PERFORMANCE''s fact.
The list of attributes owned with each explanation, namely:

1. USER_ID := "Has a Primary Key (PK) role that has the purpose of identifying each row in the table and has a unique value for each row.
Also, acts as the user identification data that refers to the table "DIM_USERS" in schema "DATA_WAREHOUSE"."

2. USER_ACCOUNT_DAYS_OLD := "Stores the value of user account in format of day old data, which is counted from the user registration date up to now."

3. USER_ACCOUNT_MONTH_OLD := "Stores the value of user account in format of month old data, which is counted from the user registration date up to now."

4. USER_RECENT_ACTIVITY_TYPE_ID := "Stores the value of the USER PERFORMANCE''s recent user activity based on the time identification data that refers to the table "DIM_APP_ACTIVITY_TYPE" in schema "DATA_WAREHOUSE"."

5. USER_RECENT_ACTIVITY_DATE_ID := "Stores the value of the USER PERFORMANCE''s recent user activity based on the date identification data that refers to the table "DIM_DATE" in schema "DATA_WAREHOUSE"."

6. USER_RECENT_ACTIVITY_USAGE_HOUR_TIME := "Stores the value of the USER PERFORMANCE''s recent user activity usage in the hour format data."
';


-- INSERT TABLE's DATA:
INSERT INTO DATA_WAREHOUSE.FACT_USER_PERFORMANCE
	(
		WITH RECENT_USER_EVENT AS (
			SELECT
				EVE.user_id AS user_id,

				MAX(EVE.timestamp) AS recent_event_timestamp

			FROM
				EVENT.EVENTS AS EVE

			GROUP BY EVE.user_id
		),
		
		RECENT_USER_LOGIN_EVENT AS (
			SELECT
				EVE.user_id AS user_id,

				MAX(EVE.timestamp) AS recent_login_event_timestamp

			FROM
				EVENT.EVENTS AS EVE

			WHERE LOWER(EVE.event_type) = 'login'

			GROUP BY EVE.user_id
		)

		SELECT
			USR.user_id AS USER_ID,

			CAST(EXTRACT(DAY FROM AGE(USR.register_date)) AS INT),

			CAST(EXTRACT(MONTH FROM AGE(USR.register_date)) AS INT),

			APP_ACT_TYPE.app_activity_type_id AS USER_RECENT_ACTIVITY_TYPE_ID,

			DT.date_id AS USER_RECENT_ACTIVITY_DATE_ID,

			COALESCE(CAST(ROUND(EXTRACT(EPOCH FROM (EVE.timestamp - REC_USR_LOG.recent_login_event_timestamp)) / 3600) AS INT), 0)

		FROM
			USERS.USERS AS USR

			INNER JOIN EVENT.EVENTS AS EVE
				ON USR.user_id = EVE.user_id

			INNER JOIN RECENT_USER_EVENT AS REC_USR
				ON USR.user_id = REC_USR.user_id
					AND EVE.timestamp = REC_USR.recent_event_timestamp

			LEFT JOIN RECENT_USER_LOGIN_EVENT AS REC_USR_LOG
				ON USR.user_id = REC_USR_LOG.user_id

			INNER JOIN DATA_WAREHOUSE.DIM_APP_ACTIVITY_TYPE AS APP_ACT_TYPE
				ON INITCAP(EVE.event_type) = APP_ACT_TYPE.app_activity_type_name

			INNER JOIN DATA_WAREHOUSE.DIM_DATE AS DT
				ON DATE(EVE.timestamp) = DT.date_id

		ORDER BY
			USR.user_id
	);


-- SELECT TABLE:
SELECT * FROM DATA_WAREHOUSE.FACT_USER_PERFORMANCE;


-- DELETE TABLE's DATA:
-- DELETE FROM DATA_WAREHOUSE.FACT_USER_PERFORMANCE;


-- DROP TABLE:
-- DROP TABLE IF EXISTS DATA_WAREHOUSE.FACT_USER_PERFORMANCE;



------------------------------------------------------------------------------------------------------------------------



-- CREATE TABLE:
-- FACT_ADS_PERFORMANCE
CREATE TABLE DATA_WAREHOUSE.FACT_ADS_PERFORMANCE(
	ADS_PERFORMANCE_DETAIL_ID SERIAL,
	ADS_ID INT NOT NULL,
	ADS_SOURCE_ID INT NOT NULL,
	ADS_TOTAL_VIEW INT DEFAULT 0,
	ADS_TOTAL_USER_REGISTERED INT DEFAULT 0,
	ADS_TOTAL_USER_TRANSACTION INT DEFAULT 0,
	ADS_TOTAL_PROFIT_AMOUNT NUMERIC(12,2) DEFAULT 0.00,

	CONSTRAINT fact_ads_performance_pkey PRIMARY KEY(ADS_PERFORMANCE_DETAIL_ID),

	CONSTRAINT fact_ads_performance_ads_id_fkey FOREIGN KEY(ADS_ID)
		REFERENCES DATA_WAREHOUSE.DIM_ADS(ADS_ID),

	CONSTRAINT fact_ads_performance_ads_source_id_fkey FOREIGN KEY(ADS_SOURCE_ID)
		REFERENCES DATA_WAREHOUSE.DIM_ADS_SOURCE(ADS_SOURCE_ID)
);


-- COMMENT TABLE:
COMMENT ON TABLE DATA_WAREHOUSE.FACT_ADS_PERFORMANCE IS
'As a place to store and define the attributes owned by the ADS PERFORMANCE''s fact.
The list of attributes owned with each explanation, namely:

1. ADS_PERFORMANCE_DETAIL_ID := "Has a Primary Key (PK) role that has the purpose of identifying each row in the table and has a unique value for each row."

2. ADS_ID := "Stores the value of the ADVERTISE PERFORMANCE''s advertise identification data that refers to the table "DIM_ADS" in schema "DATA_WAREHOUSE"."

3. ADS_SOURCE_ID := "Stores the value of the ADVERTISE PERFORMANCE''s advertise source identification data that refers to the table "DIM_ADS_SOURCE" in schema "DATA_WAREHOUSE"."

4. ADS_TOTAL_VIEW := "Based on the available advertising, this attribute stores the total number of view user."

5. ADS_TOTAL_USER_REGISTERED := "Based on the available advertising, this attribute stores the total number of registered user."

6. ADS_TOTAL_USER_TRANSACTION := "Based on the available advertising, this attribute stores the total number of transactions done by the user."

7. ADS_TOTAL_PROFIT_AMOUNT := "Based on the available advertising, this attribute stores the total profit gained during all transaction processes done by the user."
';


-- INSERT TABLE's DATA:
INSERT INTO DATA_WAREHOUSE.FACT_ADS_PERFORMANCE
	(
		ADS_ID,
		ADS_SOURCE_ID,
		ADS_TOTAL_VIEW,
		ADS_TOTAL_USER_REGISTERED,
		ADS_TOTAL_USER_TRANSACTION,
		ADS_TOTAL_PROFIT_AMOUNT
	)
	(
		WITH ADS_VIEWS AS (
			SELECT
				D_ADS.ads_id AS ads_id,

				D_ADS_SRC.ads_source_id AS ads_source_id,

				COUNT(*) OVER (PARTITION BY D_ADS.ads_id,
							   				D_ADS_SRC.ads_source_id) AS total_view

			FROM
				EVENT.EVENTS AS EVE

				INNER JOIN DATA_WAREHOUSE.DIM_USERS AS D_USER
					ON EVE.user_id = D_USER.user_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS_CLIENT AS D_ADS_CLI
					ON D_USER.ads_client_id = D_ADS_CLI.ads_client_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS AS D_ADS
					ON D_ADS_CLI.ads_id = D_ADS.ads_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS_SOURCE AS D_ADS_SRC
					ON D_ADS_CLI.ads_source_id = D_ADS_SRC.ads_source_id

			WHERE
				EVE.event_type = 'search'
			
			ORDER BY D_ADS.ads_id
		),

		ADS_REGISTERED AS (
			SELECT
				D_ADS.ads_id AS ads_id,

				D_ADS_SRC.ads_source_id AS ads_source_id,

				COUNT(*) OVER (PARTITION BY D_ADS.ads_id,
							  				D_ADS_SRC.ads_source_id) AS total_user

			FROM
				DATA_WAREHOUSE.DIM_USERS AS D_USER

				INNER JOIN DATA_WAREHOUSE.DIM_ADS_CLIENT AS D_ADS_CLI
					ON D_USER.ads_client_id = D_ADS_CLI.ads_client_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS AS D_ADS
					ON D_ADS_CLI.ads_id = D_ADS.ads_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS_SOURCE AS D_ADS_SRC
					ON D_ADS_CLI.ads_source_id = D_ADS_SRC.ads_source_id
			
			ORDER BY D_ADS.ads_id
		),

		ADS_TRANSACTION AS (
			SELECT
				D_ADS.ads_id AS ads_id,

				D_ADS_SRC.ads_source_id AS ads_source_id,

				COUNT(*) OVER (PARTITION BY D_ADS.ads_id,
							  				D_ADS_SRC.ads_source_id) AS total_transaction

			FROM
				DATA_WAREHOUSE.DIM_USERS AS D_USER

				INNER JOIN USERS.USER_TRANSACTIONS AS USR_TRANSACT
					ON D_USER.user_id = USR_TRANSACT.user_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS_CLIENT AS D_ADS_CLI
					ON D_USER.ads_client_id = D_ADS_CLI.ads_client_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS AS D_ADS
					ON D_ADS_CLI.ads_id = D_ADS.ads_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS_SOURCE AS D_ADS_SRC
					ON D_ADS_CLI.ads_source_id = D_ADS_SRC.ads_source_id
		),

		ADS_PROFIT AS (
			SELECT
				D_ADS.ads_id AS ads_id,

				D_ADS_SRC.ads_source_id AS ads_source_id,

				CAST(SUM(USR_TRANSACT.amount) OVER (PARTITION BY D_ADS.ads_id,
												   				 D_ADS_SRC.ads_source_id) AS NUMERIC(12,2)) AS total_profit

			FROM
				DATA_WAREHOUSE.DIM_USERS AS D_USER

				INNER JOIN USERS.USER_TRANSACTIONS AS USR_TRANSACT
					ON D_USER.user_id = USR_TRANSACT.user_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS_CLIENT AS D_ADS_CLI
					ON D_USER.ads_client_id = D_ADS_CLI.ads_client_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS AS D_ADS
					ON D_ADS_CLI.ads_id = D_ADS.ads_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS_SOURCE AS D_ADS_SRC
					ON D_ADS_CLI.ads_source_id = D_ADS_SRC.ads_source_id
		)

		SELECT DISTINCT
			ADS_REGISTERED.ads_id,

			ADS_REGISTERED.ads_source_id,

			COALESCE(ADS_VIEWS.total_view :: INT, 0),

			COALESCE(ADS_REGISTERED.total_user :: INT, 0),

			COALESCE(ADS_TRANSACTION.total_transaction :: INT, 0),

			COALESCE(ADS_PROFIT.total_profit :: NUMERIC(14, 2), 0)

		FROM
			ADS_REGISTERED

			LEFT OUTER JOIN ADS_VIEWS
				ON ADS_REGISTERED.ads_id = ADS_VIEWS.ads_id
					AND ADS_REGISTERED.ads_source_id = ADS_VIEWS.ads_source_id

			INNER JOIN ADS_TRANSACTION
				ON ADS_REGISTERED.ads_id = ADS_TRANSACTION.ads_id
					AND ADS_REGISTERED.ads_source_id = ADS_TRANSACTION.ads_source_id

			INNER JOIN ADS_PROFIT
				ON ADS_REGISTERED.ads_id = ADS_PROFIT.ads_id
					AND ADS_REGISTERED.ads_source_id = ADS_PROFIT.ads_source_id

		ORDER BY
			ADS_REGISTERED.ads_source_id ASC
	);


-- SELECT TABLE:
SELECT * FROM DATA_WAREHOUSE.FACT_ADS_PERFORMANCE;


-- DELETE TABLE's DATA:
-- DELETE FROM DATA_WAREHOUSE.FACT_ADS_PERFORMANCE;


-- DROP TABLE:
-- DROP TABLE IF EXISTS DATA_WAREHOUSE.FACT_ADS_PERFORMANCE;



-- =====================================================================================================================
