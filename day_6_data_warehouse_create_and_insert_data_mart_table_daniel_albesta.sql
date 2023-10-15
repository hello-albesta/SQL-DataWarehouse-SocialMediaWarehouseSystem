-- =====================================================================================================================



-- DATA MART TABLE SECTION



-- CREATE TABLE:
-- DM_DAILY_EVENT_PERFORMANCE
CREATE TABLE DATA_WAREHOUSE.DM_DAILY_EVENT_PERFORMANCE(
	DAILY_EVENT_PERFORMANCE_DETAIL_ID SERIAL,
	DAILY_EVENT_DATE_ID DATE NOT NULL,
	USER_ACTIVITY_TYPE_ID INT NOT NULL,
	NUMBER_OF_USER_ACT INT DEFAULT 0,
	LIST_OF_USER_NAME VARCHAR,
	DEVICE_HARDWARE_USED VARCHAR,
	LIST_OF_USER_LOCATION VARCHAR,
	LIST_OF_SEARCH VARCHAR,
	TOTAL_SEARCH INT,
	DAILY_EVENT_PERFORMANCE_DESC TEXT,

	CONSTRAINT dm_daily_event_performance_pkey PRIMARY KEY(DAILY_EVENT_PERFORMANCE_DETAIL_ID),

	CONSTRAINT dm_daily_event_performance_daily_event_date_id_fkey FOREIGN KEY(DAILY_EVENT_DATE_ID)
		REFERENCES DATA_WAREHOUSE.DIM_DATE(DATE_ID),

	CONSTRAINT dm_daily_event_performance_user_activity_type_id_fkey FOREIGN KEY(USER_ACTIVITY_TYPE_ID)
		REFERENCES DATA_WAREHOUSE.DIM_APP_ACTIVITY_TYPE(APP_ACTIVITY_TYPE_ID)
);


-- COMMENT TABLE:
COMMENT ON TABLE DATA_WAREHOUSE.DM_DAILY_EVENT_PERFORMANCE IS
'As a place to store and define the attributes owned by the DAILY EVENT PERFORMANCE''s data mart.
The list of attributes owned with each explanation, namely:

1. DAILY_EVENT_PERFORMANCE_DETAIL_ID := "Has a Primary Key (PK) role that has the purpose of identifying each row in the table and has a unique value for each row."

2. DAILY_EVENT_DATE_ID := "Stores the value of the DAILY EVENT PERFORMANCE''s event date identification data that refers to the table "DIM_DATE" in schema "DATA_WAREHOUSE"."

3. USER_ACTIVITY_TYPE_ID := "Stores the value of the DAILY EVENT PERFORMANCE''s USER''s activity type identification data that refers to the table "DIM_APP_ACTIVITY_TYPE" in schema "DATA_WAREHOUSE"."

4. NUMBER_OF_USER_ACT := "Stores the value of the total number of activities done by a USER."

5. LIST_OF_USER_NAME := "Stores the value of all USER names who did the activity."

6. DEVICE_HARDWARE_USED := "Stores the value of all device hardware used by the USER who did the activity."

7. LIST_OF_USER_LOCATION := "Stores the value of all locations tracked by the USER''s device hardware.."

8. LIST_OF_SEARCH := "Stores the value of all keyword searches done by a USER."

9. TOTAL_SEARCH := "Stores the value of the total result generated by a keyword that the USER used to search."

10. DAILY_EVENT_PERFORMANCE_DESC := "To describe anything about the DAILY EVENT PERFORMANCE."
';


-- INSERT TABLE's DATA:
INSERT INTO DATA_WAREHOUSE.DM_DAILY_EVENT_PERFORMANCE
	(
		DAILY_EVENT_DATE_ID,
		USER_ACTIVITY_TYPE_ID,
		NUMBER_OF_USER_ACT,
		LIST_OF_USER_NAME,
		DEVICE_HARDWARE_USED,
		LIST_OF_USER_LOCATION,
		LIST_OF_SEARCH,
		TOTAL_SEARCH
	)
	(
		SELECT
			DATE(EVE.timestamp),

			D_APP_ACT_TYPE.app_activity_type_id,

			COUNT(*),

			CAST(
				STRING_AGG(
					CONCAT(INITCAP(COALESCE(D_USR.user_first_name, '')), ' ', INITCAP(COALESCE(D_USR.user_last_name, '')), ' ', '(ID: ', D_USR.user_id, ')'),
					', '

					ORDER BY
						D_USR.user_id ASC
				) AS VARCHAR
			),

			CASE
				WHEN LOWER(TRIM(EVE.event_type)) = 'login' OR LOWER(TRIM(EVE.event_type)) = 'logout'
					THEN CAST(
							STRING_AGG(
								CONCAT(INITCAP(REPLACE(COALESCE(TRIM(CAST(EVE.event_data -> 'device_type' AS VARCHAR)), '-'), '"', '')), ' ', '(ID: ', D_USR.user_id, ')'),
								', '

								ORDER BY
									D_USR.user_id ASC
							) AS VARCHAR
						)
			END,

			CASE
				WHEN LOWER(TRIM(EVE.event_type)) = 'login' OR LOWER(TRIM(EVE.event_type)) = 'logout'
					THEN CAST(
							STRING_AGG(
								CONCAT(INITCAP(REPLACE(COALESCE(TRIM(CAST(EVE.event_data -> 'location' AS VARCHAR)), '-'), '"', '')), ' ', '(ID: ', D_USR.user_id, ')'),
								', '

								ORDER BY
									D_USR.user_id ASC
							) AS VARCHAR
						)
			END,

			CASE
				WHEN LOWER(TRIM(EVE.event_type)) = 'search'
					THEN CAST(
							STRING_AGG(
								CONCAT(INITCAP(REPLACE(COALESCE(TRIM(CAST(EVE.event_data -> 'search_terms' AS VARCHAR)), '-'), '"', '')), ' ', '(ID: ', D_USR.user_id, ')'),
								', '

								ORDER BY
									D_USR.user_id ASC
							) AS VARCHAR
						)
			END,

			CAST(TRIM(CAST(EVE.event_data -> 'total_result' AS VARCHAR)) AS INT)

		FROM
			DATA_WAREHOUSE.DIM_USERS AS D_USR

			INNER JOIN EVENT.EVENTS AS EVE
				ON D_USR.user_id = EVE.user_id

			INNER JOIN DATA_WAREHOUSE.DIM_APP_ACTIVITY_TYPE AS D_APP_ACT_TYPE
				ON INITCAP(EVE.event_type) = D_APP_ACT_TYPE.app_activity_type_name

		GROUP BY
			DATE(EVE.timestamp),
			D_APP_ACT_TYPE.app_activity_type_id,
			EVE.event_type,
			CAST(TRIM(CAST(EVE.event_data -> 'total_result' AS VARCHAR)) AS INT)

		ORDER BY
			DATE(EVE.timestamp) ASC
	);


-- SELECT TABLE:
SELECT * FROM DATA_WAREHOUSE.DM_DAILY_EVENT_PERFORMANCE;


-- ALTER TABLE's ID SEQUENCE:
-- ALTER SEQUENCE DATA_WAREHOUSE.DM_DAILY_EVENT_PERFORMANCE_DAILY_EVENT_DATE_ID_seq RESTART;


-- DELETE TABLE's DATA:
-- DELETE FROM DATA_WAREHOUSE.DM_DAILY_EVENT_PERFORMANCE;


-- DROP TABLE:
-- DROP TABLE IF EXISTS DATA_WAREHOUSE.DM_DAILY_EVENT_PERFORMANCE;



------------------------------------------------------------------------------------------------------------------------



-- CREATE TABLE:
-- DM_WEEKLY_ADS_PERFORMANCE
CREATE TABLE DATA_WAREHOUSE.DM_WEEKLY_ADS_PERFORMANCE(
	WEEKLY_ADS_PERFORMANCE_DETAIL_ID SERIAL,
	WEEKLY_DATE_RANGE VARCHAR(30) NOT NULL,
	ADS_ID INT NOT NULL,
	ADS_SOURCE_ID INT NOT NULL,
	WEEKLY_ADS_TOTAL_VIEW INT DEFAULT 0,
	WEEKLY_ADS_TOTAL_USER_REGISTERED INT DEFAULT 0,
	WEEKLY_ADS_TOTAL_USER_TRANSACTION INT DEFAULT 0,
	WEEKLY_ADS_TOTAL_PROFIT_AMOUNT NUMERIC(14, 2) DEFAULT 0.0000,
	WEEKLY_ADS_AVG_PROFIT_AMOUNT NUMERIC(14, 2) DEFAULT 0.0000,
	SALES_WEEKLY_ADS_PERFORMANCE_DESC TEXT,

	CONSTRAINT dm_sales_weekly_ads_performance_pkey PRIMARY KEY(WEEKLY_ADS_PERFORMANCE_DETAIL_ID),

	CONSTRAINT dm_sales_weekly_ads_performance_ads_id_fkey FOREIGN KEY(ADS_ID)
		REFERENCES DATA_WAREHOUSE.DIM_ADS(ADS_ID),

	CONSTRAINT dm_sales_weekly_ads_performance_ads_source_id_fkey FOREIGN KEY(ADS_SOURCE_ID)
		REFERENCES DATA_WAREHOUSE.DIM_ADS_SOURCE(ADS_SOURCE_ID)
);


-- COMMENT TABLE:
COMMENT ON TABLE DATA_WAREHOUSE.DM_WEEKLY_ADS_PERFORMANCE IS
'As a place to store and define the attributes owned by the WEEKLY ADVERTISE PERFORMANCE''s data mart.
The list of attributes owned with each explanation, namely:

1. WEEKLY_ADS_PERFORMANCE_DETAIL_ID := "Has a Primary Key (PK) role that has the purpose of identifying each row in the table and has a unique value for each row."

2. WEEKLY_DATE_RANGE := "Stores the value of weekly date ranges from all of the TRANSACTION''s date periods."

3. ADS_ID := "Stores the value of the WEEKLY ADVERTISE PERFORMANCE''s advertise identification data that refers to the table "DIM_ADS" in schema "DATA_WAREHOUSE"."

4. ADS_SOURCE_ID := "Stores the value of the WEEKLY ADVERTISE PERFORMANCE''s source identification data that refers to the table "DIM_ADS_SOURCE" in schema "DATA_WAREHOUSE"."

5. WEEKLY_ADS_TOTAL_VIEW := "Stores the value of the total advertising viewed by the user in a single week."

6. WEEKLY_ADS_TOTAL_USER_REGISTERED := "Stores the value of the total registered user because of advertiser''s influence in a single week."

7. WEEKLY_ADS_TOTAL_USER_TRANSACTION := "Stores the value of the total transactions done by the user because of the advertiser''s influence in a single week."

8. WEEKLY_ADS_TOTAL_PROFIT_AMOUNT := "Stores the value of the total profit gained during all transaction processes done by the user in a single week."

9. WEEKLY_ADS_AVG_PROFIT_AMOUNT := "Stores the value of the average count of profit gained during all transaction processes done by the user in a single week."

10. SALES_WEEKLY_ADS_PERFORMANCE_DESC := "To describe anything about the WEEKLY ADVERTISE PERFORMANCE."
';


-- INSERT TABLE's DATA:
INSERT INTO DATA_WAREHOUSE.DM_WEEKLY_ADS_PERFORMANCE
	(
		WEEKLY_DATE_RANGE,
		ADS_ID,
		ADS_SOURCE_ID,
		WEEKLY_ADS_TOTAL_VIEW,
		WEEKLY_ADS_TOTAL_USER_REGISTERED,
		WEEKLY_ADS_TOTAL_USER_TRANSACTION,
		WEEKLY_ADS_TOTAL_PROFIT_AMOUNT,
		WEEKLY_ADS_AVG_PROFIT_AMOUNT
	)
	(
		WITH ADS_VIEWS AS (
			SELECT
				D_ADS.ads_id AS ads_id,

				CONCAT(
					DATE_TRUNC('week', USR_TRANS.transaction_date :: DATE) :: DATE,
					' - ',
					(DATE_TRUNC('week', USR_TRANS.transaction_date :: DATE) :: DATE + '1 week' :: INTERVAL) :: DATE
				) AS WEEKLY,

				D_ADS_SRC.ads_source_id AS ads_source_id,

				COUNT(*) AS total_view

			FROM
				EVENT.EVENTS AS EVE

				INNER JOIN DATA_WAREHOUSE.DIM_USERS AS D_USER
					ON EVE.user_id = D_USER.user_id

				INNER JOIN USERS.USER_TRANSACTIONS AS USR_TRANS
					ON D_USER.user_id = USR_TRANS.user_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS_CLIENT AS D_ADS_CLI
					ON D_USER.ads_client_id = D_ADS_CLI.ads_client_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS AS D_ADS
					ON D_ADS_CLI.ads_id = D_ADS.ads_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS_SOURCE AS D_ADS_SRC
					ON D_ADS_CLI.ads_source_id = D_ADS_SRC.ads_source_id

			WHERE
				EVE.event_type = 'search'

			GROUP BY
				D_ADS.ads_id,
				WEEKLY,
				D_ADS_SRC.ads_source_id

			ORDER BY
				D_ADS.ads_id ASC
		),

		ADS_REGISTERED AS (
			SELECT
				D_ADS.ads_id AS ads_id,

				CONCAT(
					DATE_TRUNC('week', USR_TRANS.transaction_date :: DATE) :: DATE,
					' - ',
					(DATE_TRUNC('week', USR_TRANS.transaction_date :: DATE) :: DATE + '1 week' :: INTERVAL) :: DATE
				) AS WEEKLY,

				D_ADS_SRC.ads_source_id AS ads_source_id,

				COUNT(*) AS total_user

			FROM
				DATA_WAREHOUSE.DIM_USERS AS D_USER

				INNER JOIN USERS.USER_TRANSACTIONS AS USR_TRANS
					ON D_USER.user_id = USR_TRANS.user_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS_CLIENT AS D_ADS_CLI
					ON D_USER.ads_client_id = D_ADS_CLI.ads_client_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS AS D_ADS
					ON D_ADS_CLI.ads_id = D_ADS.ads_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS_SOURCE AS D_ADS_SRC
					ON D_ADS_CLI.ads_source_id = D_ADS_SRC.ads_source_id

			GROUP BY
				D_ADS.ads_id,
				WEEKLY,
				D_ADS_SRC.ads_source_id

			ORDER BY
				D_ADS.ads_id ASC
		),

		ADS_TRANSACTION AS (
			SELECT
				D_ADS.ads_id AS ads_id,

				CONCAT(
					DATE_TRUNC('week', USR_TRANS.transaction_date :: DATE) :: DATE,
					' - ',
					(DATE_TRUNC('week', USR_TRANS.transaction_date :: DATE) :: DATE + '1 week' :: INTERVAL) :: DATE
				) AS WEEKLY,

				D_ADS_SRC.ads_source_id AS ads_source_id,

				COUNT(*) AS total_transaction

			FROM
				DATA_WAREHOUSE.DIM_USERS AS D_USER

				INNER JOIN USERS.USER_TRANSACTIONS AS USR_TRANS
					ON D_USER.user_id = USR_TRANS.user_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS_CLIENT AS D_ADS_CLI
					ON D_USER.ads_client_id = D_ADS_CLI.ads_client_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS AS D_ADS
					ON D_ADS_CLI.ads_id = D_ADS.ads_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS_SOURCE AS D_ADS_SRC
					ON D_ADS_CLI.ads_source_id = D_ADS_SRC.ads_source_id

			GROUP BY
				D_ADS.ads_id,
				WEEKLY,
				D_ADS_SRC.ads_source_id

			ORDER BY
				D_ADS.ads_id ASC
		),

		ADS_PROFIT AS (
			SELECT
				D_ADS.ads_id AS ads_id,

				CONCAT(
					DATE_TRUNC('week', USR_TRANS.transaction_date :: DATE) :: DATE,
					' - ',
					(DATE_TRUNC('week', USR_TRANS.transaction_date :: DATE) :: DATE + '1 week' :: INTERVAL) :: DATE
				) AS WEEKLY,

				D_ADS_SRC.ads_source_id AS ads_source_id,

				SUM(USR_TRANS.amount) :: NUMERIC(12,2) AS total_profit,

				AVG(USR_TRANS.amount) :: NUMERIC(12,2) AS avg_profit

			FROM
				DATA_WAREHOUSE.DIM_USERS AS D_USER

				INNER JOIN USERS.USER_TRANSACTIONS AS USR_TRANS
					ON D_USER.user_id = USR_TRANS.user_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS_CLIENT AS D_ADS_CLI
					ON D_USER.ads_client_id = D_ADS_CLI.ads_client_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS AS D_ADS
					ON D_ADS_CLI.ads_id = D_ADS.ads_id

				INNER JOIN DATA_WAREHOUSE.DIM_ADS_SOURCE AS D_ADS_SRC
					ON D_ADS_CLI.ads_source_id = D_ADS_SRC.ads_source_id

			GROUP BY
				D_ADS.ads_id,
				WEEKLY,
				D_ADS_SRC.ads_source_id

			ORDER BY
				D_ADS.ads_id ASC
		)

		SELECT
			CAST(ADS_REGISTERED.WEEKLY AS VARCHAR),

			ADS_REGISTERED.ads_id,

			ADS_REGISTERED.ads_source_id,

			COALESCE(ADS_VIEWS.total_view :: INT, 0),

			COALESCE(ADS_REGISTERED.total_user :: INT, 0),

			COALESCE(ADS_TRANSACTION.total_transaction :: INT, 0),

			COALESCE(ADS_PROFIT.total_profit :: NUMERIC(14, 2), 0),

			COALESCE(ADS_PROFIT.avg_profit :: NUMERIC(14, 2), 0)

		FROM
			ADS_REGISTERED

			LEFT JOIN ADS_VIEWS
				ON ADS_REGISTERED.ads_id = ADS_VIEWS.ads_id
					AND ADS_REGISTERED.ads_source_id = ADS_VIEWS.ads_source_id
					AND ADS_REGISTERED.WEEKLY = ADS_VIEWS.WEEKLY

			INNER JOIN ADS_TRANSACTION
				ON ADS_REGISTERED.ads_id = ADS_TRANSACTION.ads_id
					AND ADS_REGISTERED.ads_source_id = ADS_TRANSACTION.ads_source_id
					AND ADS_REGISTERED.WEEKLY = ADS_TRANSACTION.WEEKLY

			INNER JOIN ADS_PROFIT
				ON ADS_REGISTERED.ads_id = ADS_PROFIT.ads_id
					AND ADS_REGISTERED.ads_source_id = ADS_PROFIT.ads_source_id
					AND ADS_REGISTERED.WEEKLY = ADS_PROFIT.WEEKLY

		ORDER BY
			CAST(ADS_REGISTERED.WEEKLY AS VARCHAR) ASC,
			ADS_REGISTERED.ads_source_id ASC
	);


-- SELECT TABLE:
SELECT * FROM DATA_WAREHOUSE.DM_WEEKLY_ADS_PERFORMANCE;


-- ALTER TABLE's ID SEQUENCE:
-- ALTER SEQUENCE DATA_WAREHOUSE.DM_WEEKLY_ADS_PERFORMANCE_WEEKLY_DATE_ID_seq RESTART;


-- DELETE TABLE's DATA:
-- DELETE FROM DATA_WAREHOUSE.DM_WEEKLY_ADS_PERFORMANCE;


-- DROP TABLE:
-- DROP TABLE IF EXISTS DATA_WAREHOUSE.DM_WEEKLY_ADS_PERFORMANCE;



-- =====================================================================================================================