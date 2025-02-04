CREATE OR REPLACE FUNCTION website.calculate_customer_price(
    customer_id INT,
    stock_item_id INT,
    pricing_date DATE
) RETURNS DECIMAL(18,2) AS $$
DECLARE
    calculated_price DECIMAL(18,2);
    unit_price DECIMAL(18,2);
    lowest_unit_price DECIMAL(18,2);
    highest_discount_amount DECIMAL(18,2);
    highest_discount_percentage DECIMAL(18,3);
    buying_group_id INT;
    customer_category_id INT;
    discounted_unit_price DECIMAL(18,2);
BEGIN
    -- Get BuyingGroupID and CustomerCategoryID
    SELECT buyinggroupid, customercategoryid 
    INTO buying_group_id, customer_category_id
    FROM sales.customers 
    WHERE customerid = customer_id;

    -- Get Unit Price from StockItems
    SELECT unitprice 
    INTO unit_price
    FROM warehouse.stockitems 
    WHERE stockitemid = stock_item_id;

    calculated_price := unit_price;

    -- Get Lowest Unit Price from Special Deals
    SELECT MIN(sd.unitprice) 
    INTO lowest_unit_price
    FROM sales.specialdeals AS sd
    WHERE (sd.stockitemid = stock_item_id OR sd.stockitemid IS NULL)
      AND (sd.customerid = customer_id OR sd.customerid IS NULL)
      AND (sd.buyinggroupid = buying_group_id OR sd.buyinggroupid IS NULL)
      AND (sd.customercategoryid = customer_category_id OR sd.customercategoryid IS NULL)
      AND (sd.stockgroupid IS NULL OR EXISTS (
              SELECT 1 FROM warehouse.stockitemstockgroups AS sisg
              WHERE sisg.stockitemid = stock_item_id
                AND sisg.stockgroupid = sd.stockgroupid
          ))
      AND sd.unitprice IS NOT NULL
      AND pricing_date BETWEEN sd.startdate AND sd.enddate;

    -- Apply Lowest Unit Price if applicable
    IF lowest_unit_price IS NOT NULL AND lowest_unit_price < unit_price THEN
        calculated_price := lowest_unit_price;
    END IF;

    -- Get Highest Discount Amount
    SELECT MAX(sd.discountamount) 
    INTO highest_discount_amount
    FROM sales.specialdeals AS sd
    WHERE (sd.stockitemid = stock_item_id OR sd.stockitemid IS NULL)
      AND (sd.customerid = customer_id OR sd.customerid IS NULL)
      AND (sd.buyinggroupid = buying_group_id OR sd.buyinggroupid IS NULL)
      AND (sd.customercategoryid = customer_category_id OR sd.customercategoryid IS NULL)
      AND (sd.stockgroupid IS NULL OR EXISTS (
              SELECT 1 FROM warehouse.stockitemstockgroups AS sisg
              WHERE sisg.stockitemid = stock_item_id
                AND sisg.stockgroupid = sd.stockgroupid
          ))
      AND sd.discountamount IS NOT NULL
      AND pricing_date BETWEEN sd.startdate AND sd.enddate;

    -- Apply Discount Amount if it results in a lower price
    IF highest_discount_amount IS NOT NULL AND (unit_price - highest_discount_amount) < calculated_price THEN
        calculated_price := unit_price - highest_discount_amount;
    END IF;

    -- Get Highest Discount Percentage
    SELECT MAX(sd.discountpercentage) 
    INTO highest_discount_percentage
    FROM sales.specialdeals AS sd
    WHERE (sd.stockitemid = stock_item_id OR sd.stockitemid IS NULL)
      AND (sd.customerid = customer_id OR sd.customerid IS NULL)
      AND (sd.buyinggroupid = buying_group_id OR sd.buyinggroupid IS NULL)
      AND (sd.customercategoryid = customer_category_id OR sd.customercategoryid IS NULL)
      AND (sd.stockgroupid IS NULL OR EXISTS (
              SELECT 1 FROM warehouse.stockitemstockgroups AS sisg
              WHERE sisg.stockitemid = stock_item_id
                AND sisg.stockgroupid = sd.stockgroupid
          ))
      AND sd.discountpercentage IS NOT NULL
      AND pricing_date BETWEEN sd.startdate AND sd.enddate;

    -- Apply Discount Percentage if it results in a lower price
    IF highest_discount_percentage IS NOT NULL THEN
        discounted_unit_price := ROUND(unit_price * highest_discount_percentage / 100.0, 2);
        IF discounted_unit_price < calculated_price THEN
            calculated_price := discounted_unit_price;
        END IF;
    END IF;

    -- Return the final calculated price
    RETURN calculated_price;
END;
$$ LANGUAGE plpgsql;


CREATE function my_cal(quantity int, price decimal)
RETURNS decimal AS $$ 
BEGIN
    RETURN price * quantity;
END; 
$$
LANGUAGE plpgsql;

SELECT my_cal(6, 5.7) --output 34.2



CREATE OR REPLACE FUNCTION Application.DetermineCustomerAccess(CityID INT)
RETURNS TABLE (AccessResult INT)
AS $$
BEGIN
  RETURN QUERY
  SELECT 1 AS AccessResult
  WHERE current_user IN (
      -- Check for db_owner role
      'db_owner',
      
      -- Check for Sales Territory Role
      (SELECT sp.SalesTerritory || ' Sales'
       FROM Application.Cities AS c
       INNER JOIN Application.StateProvinces AS sp
       ON c.StateProvinceID = sp.StateProvinceID
       WHERE c.CityID = CityID)
  )
  OR (
      -- Check for Website user with Sales Territory restriction
      current_user = 'Website'
      AND EXISTS (
          SELECT 1
          FROM Application.Cities AS c
          INNER JOIN Application.StateProvinces AS sp
          ON c.StateProvinceID = sp.StateProvinceID
          WHERE c.CityID = CityID
          AND sp.SalesTerritory = current_setting('app.SalesTerritory', true)
      )
  );
END;
$$ LANGUAGE plpgsql STABLE;



CREATE OR REPLACE FUNCTION add_role_member_if_nonexistent(role_name text, user_name text)
RETURNS void AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_roles AS r
    JOIN pg_user AS u ON r.rolname = role_name AND u.usename = user_name
    WHERE r.rolcanlogin = TRUE -- Ensure it's a role that can have members
  ) THEN
    BEGIN
      EXECUTE format('GRANT %I TO %I', role_name, user_name); -- Use GRANT for roles
      RAISE NOTICE 'User %I added to role %I', user_name, role_name;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Unable to add user %I to role %I: %', user_name, role_name, SQLERRM;
      RAISE EXCEPTION USING ERRCODE = '22000', MESSAGE = 'Error adding role member'; -- Re-raise exception
    END;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION application.configuration_apply_auditing()
RETURNS void AS $$
DECLARE
    audit_exists BOOLEAN;
    audit_spec_exists BOOLEAN;
BEGIN
    -- Check if the audit extension exists
    SELECT EXISTS (SELECT 1 FROM pg_available_extensions WHERE name = 'pgaudit')
    INTO audit_exists;
    
    IF audit_exists THEN
        -- Enable pgaudit extension if not already enabled
        IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pgaudit') THEN
            CREATE EXTENSION pgaudit;
        END IF;
    ELSE
        RAISE NOTICE 'pgaudit extension is not available in this PostgreSQL instance.';
        RETURN;
    END IF;
    
    -- Configure PostgreSQL auditing settings (this is typically done in postgresql.conf)
    -- For demo purposes, we modify session-level parameters
    PERFORM set_config('pgaudit.log', 'read, write', false);
    PERFORM set_config('pgaudit.log_catalog', 'on', false);
    
    -- Check if audit settings exist in a hypothetical audit configuration table
    SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'audit_log')
    INTO audit_spec_exists;
    
    IF NOT audit_spec_exists THEN
        CREATE TABLE audit_log (
            id SERIAL PRIMARY KEY,
            event_time TIMESTAMP DEFAULT now(),
            user_name TEXT,
            operation TEXT,
            schema_name TEXT,
            object_name TEXT,
            query TEXT
        );
        
        -- Example: Create an event trigger for logging DDL changes
        CREATE OR REPLACE FUNCTION log_ddl_changes() RETURNS event_trigger AS $$
        BEGIN
            INSERT INTO audit_log (user_name, operation, schema_name, object_name, query)
            SELECT current_user, TG_TAG, schema_name, object_name, current_query()
            FROM pg_event_trigger_ddl_commands();
        END;
        $$ LANGUAGE plpgsql;
        
        CREATE EVENT TRIGGER ddl_audit_trigger
        ON ddl_command_end
        EXECUTE FUNCTION log_ddl_changes();
    END IF;
    
    RAISE NOTICE 'Audit configuration applied successfully.';
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION application.configuration_apply_columnstore_indexing()
RETURNS void AS $$
DECLARE
  sql_text TEXT;
BEGIN
  -- Check if TimescaleDB is installed (BRIN is always available)
  IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'timescaledb') THEN
    RAISE NOTICE 'Warning: TimescaleDB (for compression) is not installed.  BRIN indexes will be used.';
  END IF;

  -- Start transaction
  --BEGIN;

  -- Example: Using BRIN for large tables
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'nccx_sales_orderlines') THEN
    sql_text := 'CREATE INDEX nccx_sales_orderlines ON sales.orderlines USING BRIN (orderid, stockitemid, quantity, unitprice, pickedquantity)';
    EXECUTE sql_text;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'nccx_sales_invoicelines') THEN
    sql_text := 'CREATE INDEX nccx_sales_invoicelines ON sales.invoicelines USING BRIN (invoiceid, stockitemid, quantity, unitprice, lineprofit, lasteditedwhen)';
    EXECUTE sql_text;
  END IF;

  -- Using TimescaleDB compression (if installed)
  IF EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'timescaledb') THEN  -- Check if TimescaleDB is installed
    IF NOT EXISTS (SELECT 1 FROM timescaledb_information.compressed_hypertables WHERE hypertable_name = 'stockitemtransactions') THEN
      -- Create hypertable if it doesn't exist.  Assumes timestamp_column exists.
      IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'warehouse' AND tablename = 'stockitemtransactions') THEN
          RAISE NOTICE 'Table warehouse.stockitemtransactions does not exist. Skipping TimescaleDB setup.';
      ELSE
        sql_text := format('SELECT create_hypertable(''%I.%I'', ''timestamp_column'')', 'warehouse', 'stockitemtransactions');
        EXECUTE sql_text;

        sql_text := 'ALTER TABLE warehouse.stockitemtransactions SET (timescaledb.compress, timescaledb.compress_orderby = ''timestamp_column DESC'')';
        EXECUTE sql_text;

        -- Compress existing chunks (optional, you might want to do this later)
        sql_text := 'SELECT compress_chunk(c.schema_name || ''.'' || c.table_name) FROM timescaledb_information.chunks c WHERE c.table_name = ''stockitemtransactions''';
        EXECUTE sql_text;
      END IF;
    END IF;
  END IF;

  -- Commit transaction
  COMMIT;
  RAISE NOTICE 'Successfully applied indexing and compression.';

EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  RAISE NOTICE 'Unable to apply indexing and compression: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION website.search_for_people(search_text text, maximum_rows_to_return int)
RETURNS TABLE (personid int, fullname text, preferredname text, relationship text, company text) AS $$
BEGIN
  RETURN QUERY
  SELECT p.personid,
         p.fullname,
         p.preferredname,
         CASE
           WHEN p.issalesperson THEN 'Salesperson'
           WHEN p.isemployee THEN 'Employee'
           WHEN c.customerid IS NOT NULL THEN 'Customer'
           WHEN sp.supplierid IS NOT NULL THEN 'Supplier'
           WHEN sa.supplierid IS NOT NULL THEN 'Supplier'
           ELSE NULL  -- Important: Handle the case where no relationship is found
         END AS relationship,
         COALESCE(c.customername, sp.suppliername, sa.suppliername, 'WWI') AS company
  FROM application.people AS p
  LEFT JOIN sales.customers AS c ON c.primarycontactpersonid = p.personid
  LEFT JOIN purchasing.suppliers AS sp ON sp.primarycontactpersonid = p.personid
  LEFT JOIN purchasing.suppliers AS sa ON sa.alternatecontactpersonid = p.personid
  WHERE to_tsvector('english_search', p.searchname || ' ' || p.customfields || ' ' || p.otherlanguages) @@ to_tsquery('english_search', search_text) -- Use the same config name
  ORDER BY ts_rank(to_tsvector('english_search', p.searchname || ' ' || p.customfields || ' ' || p.otherlanguages), to_tsquery('english_search', search_text)) -- Rank results
  LIMIT maximum_rows_to_return;
END;
$$ LANGUAGE plpgsql;
  


CREATE OR REPLACE FUNCTION website.search_for_stockitems_by_tags(search_text text, maximum_rows_to_return int)
RETURNS TABLE (stockitemid int, stockitemname text) AS $$
BEGIN
  RETURN QUERY
  SELECT si.stockitemid,
         si.stockitemname
  FROM warehouse.stockitems AS si
  WHERE to_tsvector('english_search', si.tags) @@ to_tsquery('english_search', search_text)  -- Use the same config name
  ORDER BY ts_rank(to_tsvector('english_search', si.tags), to_tsquery('english_search', search_text))
  LIMIT maximum_rows_to_return;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION application.configuration_remove_row_level_security()
RETURNS void AS $$
BEGIN
  -- Drop the policy (if it exists)
  EXECUTE format('DROP POLICY IF EXISTS filter_customers_by_sales_territory ON sales.customers');

  -- Disable row level security on the table (if it's enabled)
    IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'customers' AND schemaname = 'sales') THEN
        EXECUTE format('ALTER TABLE sales.customers DISABLE ROW LEVEL SECURITY');
    END IF;

  -- Drop the function (if it exists)
  DROP FUNCTION IF EXISTS application.determine_customer_access(int);

  RAISE NOTICE 'Successfully removed row level security';

EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'Unable to remove row level security: %s', SQLERRM;
  RAISE EXCEPTION USING ERRCODE = SQLSTATE, MESSAGE = SQLERRM; -- Re-raise the exception
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION application.create_role_if_nonexistent(role_name text)
RETURNS void AS $$
BEGIN
  -- Check if the role exists
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = role_name) THEN
    BEGIN
      -- Create the role. Use quote_ident() for safety.
      EXECUTE format('CREATE ROLE %I', role_name);

      RAISE NOTICE 'Role % created', role_name;
    END;
  END IF;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'Unable to create role %: %', role_name, SQLERRM;
  RAISE EXCEPTION USING ERRCODE = SQLSTATE, MESSAGE = SQLERRM;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE application.configuration_configure_for_enterprise_edition()
AS $$
BEGIN
  CALL application.configuration_apply_columnstore_indexing();

  CALL application.configuration_apply_full_text_indexing();

  CALL application.configuration_enable_in_memory();

  CALL application.configuration_apply_partitioning();
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION dataloadsimulation.get_area_code(state_province_code TEXT)
RETURNS INTEGER AS $$
DECLARE
    area_code INTEGER;
BEGIN
    -- Use a VALUES table to map state/province codes to area codes
    SELECT ac.area_code 
    INTO area_code
    FROM (VALUES 
        ('NJ', 201), ('DC', 202), ('CT', 203), ('MB', 204), ('AL', 205),
        ('WA', 206), ('ME', 207), ('ID', 208), ('CA', 209), ('TX', 210),
        ('NY', 212), ('CA', 213), ('TX', 214), ('PA', 215), ('OH', 216),
        ('IL', 217), ('MN', 218), ('IN', 219), ('OH', 220), ('IL', 224),
        ('LA', 225), ('ON', 226), ('MS', 228), ('GA', 229), ('MI', 231),
        ('OH', 234), ('BC', 236), ('FL', 239), ('MD', 240), ('MI', 248),
        ('BC', 250), ('AL', 251), ('NC', 252), ('WA', 253), ('TX', 254),
        ('AL', 256), ('IN', 260), ('WI', 262), ('PA', 267), ('MI', 269),
        ('KY', 270), ('PA', 272), ('VA', 276), ('MI', 278), ('TX', 281),
        ('OH', 283), ('ON', 289), ('MD', 301), ('DE', 302), ('CO', 303),
        ('WV', 304), ('FL', 305), ('SK', 306), ('WY', 307), ('NE', 308),
        ('IL', 309), ('CA', 310), ('IL', 312), ('MI', 313), ('MO', 314),
        ('NY', 315), ('KS', 316), ('IN', 317), ('LA', 318), ('IA', 319),
        ('MN', 320), ('FL', 321), ('CA', 323), ('TX', 325), ('OH', 330),
        ('IL', 331), ('AL', 334), ('NC', 336), ('LA', 337), ('MA', 339)
    ) AS ac(state_province_code, area_code)
    WHERE ac.state_province_code = state_province_code
    LIMIT 1;

    RETURN area_code;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE dataloadsimulation.activate_website_logons(
    IN current_datetime TIMESTAMP(6),
    IN starting_when TIMESTAMP,
    IN end_of_time TIMESTAMP(6),
    IN is_silent_mode BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
    number_of_logons_to_activate INT;
BEGIN
    -- Approximately 1 in 8 days has a new website activation
    number_of_logons_to_activate := CASE WHEN (RANDOM() * 8) <= 1 THEN 1 ELSE 0 END;

    -- Display message if not in silent mode
    IF is_silent_mode = FALSE THEN
        RAISE NOTICE 'Activating % logons', number_of_logons_to_activate;
    END IF;

    -- Additional logic can be implemented here...
END;
$$;

CREATE OR REPLACE PROCEDURE dataloadsimulation.add_customers(
    IN current_datetime TIMESTAMP(7),
    IN starting_when TIMESTAMP,
    IN end_of_time TIMESTAMP(7),
    IN is_silent_mode BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
    number_of_customers_to_add INT;
    quantity_array INT[] := ARRAY[
        0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 
        0, 0, 0, 0, 1
    ]; -- 1 in 25 chance
BEGIN
    -- Select a random value from the array
    number_of_customers_to_add := quantity_array[ceil(random() * array_length(quantity_array, 1))];

    -- Display message if not in silent mode
    IF is_silent_mode = FALSE THEN
        RAISE NOTICE 'Adding % customers', number_of_customers_to_add;
    END IF;

    -- Additional logic for inserting customers can be implemented here...
END;
$$;

CREATE OR REPLACE PROCEDURE DataLoadSimulation.Configuration_RemoveDataLoadSimulationProcedures()
LANGUAGE plpgsql
AS $$
BEGIN
    DROP PROCEDURE IF EXISTS DataLoadSimulation.ActivateWebsiteLogins();
    DROP PROCEDURE IF EXISTS DataLoadSimulation.AddCustomers();
    DROP PROCEDURE IF EXISTS DataLoadSimulation.AddSpecialDeals();
    DROP PROCEDURE IF EXISTS DataLoadSimulation.AddStockItems();
    DROP PROCEDURE IF EXISTS DataLoadSimulation.ChangePasswords();
    DROP PROCEDURE IF EXISTS DataLoadSimulation.CreateCustomerOrders();
    DROP PROCEDURE IF EXISTS DataLoadSimulation.DailyProcessToCreateHistory();
    DROP PROCEDURE IF EXISTS DataLoadSimulation.InvoicePickedOrders();
    DROP PROCEDURE IF EXISTS DataLoadSimulation.MakeTemporalChanges();
    DROP PROCEDURE IF EXISTS DataLoadSimulation.PaySuppliers();
    DROP PROCEDURE IF EXISTS DataLoadSimulation.PerformStocktake();
    DROP PROCEDURE IF EXISTS DataLoadSimulation.PickStockForCustomerOrders();
    DROP PROCEDURE IF EXISTS DataLoadSimulation.PlaceSupplierOrders();
    DROP PROCEDURE IF EXISTS DataLoadSimulation.ProcessCustomerPayments();
    DROP PROCEDURE IF EXISTS DataLoadSimulation.ReceivePurchaseOrders();
    DROP PROCEDURE IF EXISTS DataLoadSimulation.RecordColdRoomTemperatures();
    DROP PROCEDURE IF EXISTS DataLoadSimulation.RecordDeliveryVanTemperatures();
    DROP PROCEDURE IF EXISTS DataLoadSimulation.RecordInvoiceDeliveries();
    DROP PROCEDURE IF EXISTS DataLoadSimulation.UpdateCustomFields();
    DROP FUNCTION IF EXISTS DataLoadSimulation.GetAreaCode(nvarchar(2)); -- Include argument types

END;
$$;

CREATE OR REPLACE PROCEDURE dataloadsimulation.populate_data_to_current_date(
    IN average_number_of_customer_orders_per_day INT,
    IN saturday_percentage_of_normal_work_day INT,
    IN sunday_percentage_of_normal_work_day INT,
    IN is_silent_mode BOOLEAN,
    IN are_dates_printed BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
    current_maximum_date DATE;
    starting_date DATE;
    ending_date DATE;
BEGIN
    -- Apply Data Load Simulation Procedures
    CALL dataloadsimulation.configuration_applydataloadsimulationprocedures();

    -- Get the current max date from Sales.Orders, default to '2012-12-31' if null
    SELECT COALESCE(MAX(orderdate), '2012-12-31') INTO current_maximum_date FROM sales.orders;

    -- Define the start and end dates
    starting_date := current_maximum_date + INTERVAL '1 day';
    ending_date := CURRENT_DATE - INTERVAL '1 day';

    -- Call the daily process procedure
    CALL dataloadsimulation.populate_data_to_current_date(
        average_number_of_customer_orders_per_day,
        saturday_percentage_of_normal_work_day,
        sunday_percentage_of_normal_work_day,
        0, -- UpdateCustomFields = 0 (already done in initial load)
        is_silent_mode,
        are_dates_printed
    );

    -- Remove Data Load Simulation Procedures
    CALL dataloadsimulation.configuration_removedataloadsimulationprocedures();
END;
$$;

CREATE OR REPLACE PROCEDURE dataloadsimulation.reactivate_temporal_tables_after_data_load()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Apply Row Level Security Configuration if Procedure Exists
    IF EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'configuration_applyrowlevelsecurity') THEN
        CALL application.configuration_applyrowlevelsecurity();
    END IF;

    -- Re-enabling temporal tables (Manually Managing History)

    -- Drop and recreate triggers for tracking historical changes
    DROP TRIGGER IF EXISTS tr_application_cities_dataload_modify ON application.cities;
    CREATE TRIGGER tr_application_cities_dataload_modify
    AFTER INSERT OR UPDATE OR DELETE ON application.cities
    FOR EACH ROW EXECUTE FUNCTION application.track_city_changes();

    -- Repeat for all other tables

    DROP TRIGGER IF EXISTS tr_application_countries_dataload_modify ON application.countries;
    CREATE TRIGGER tr_application_countries_dataload_modify
    AFTER INSERT OR UPDATE OR DELETE ON application.countries
    FOR EACH ROW EXECUTE FUNCTION application.track_country_changes();

    DROP TRIGGER IF EXISTS tr_application_deliverymethods_dataload_modify ON application.deliverymethods;
    CREATE TRIGGER tr_application_deliverymethods_dataload_modify
    AFTER INSERT OR UPDATE OR DELETE ON application.deliverymethods
    FOR EACH ROW EXECUTE FUNCTION application.track_deliverymethod_changes();

    DROP TRIGGER IF EXISTS tr_application_paymentmethods_dataload_modify ON application.paymentmethods;
    CREATE TRIGGER tr_application_paymentmethods_dataload_modify
    AFTER INSERT OR UPDATE OR DELETE ON application.paymentmethods
    FOR EACH ROW EXECUTE FUNCTION application.track_paymentmethod_changes();

    -- Add similar triggers for all other tables...

END;
$$;


CREATE OR REPLACE PROCEDURE integration.get_city_updates(
    IN last_cutoff TIMESTAMP,
    IN new_cutoff TIMESTAMP
)
LANGUAGE plpgsql
AS $$
DECLARE
    country_id INT;
    state_province_id INT;
    city_id INT;
    valid_from TIMESTAMP;
    end_of_time TIMESTAMP := '9999-12-31 23:59:59.999999';
    initial_load_date DATE := '2013-01-01';
BEGIN
    -- Create a temporary table to store city changes
    CREATE TEMP TABLE city_changes ON COMMIT DROP AS
    SELECT 
        NULL::INT AS wwi_city_id, NULL::TEXT AS city, NULL::TEXT AS state_province, 
        NULL::TEXT AS country, NULL::TEXT AS continent, NULL::TEXT AS sales_territory, 
        NULL::TEXT AS region, NULL::TEXT AS subregion, NULL::GEOGRAPHY AS location, 
        NULL::BIGINT AS latest_recorded_population, NULL::TIMESTAMP AS valid_from, 
        NULL::TIMESTAMP AS valid_to
    LIMIT 0;

    -- Process Country Changes
    FOR country_id, valid_from IN
        SELECT countryid, validfrom FROM application.countries_archive 
        WHERE validfrom > last_cutoff AND validfrom <= new_cutoff AND validfrom <> initial_load_date
        UNION ALL
        SELECT countryid, validfrom FROM application.countries
        WHERE validfrom > last_cutoff AND validfrom <= new_cutoff AND validfrom <> initial_load_date
        ORDER BY validfrom
    LOOP
        INSERT INTO city_changes
        SELECT 
            c.cityid, c.cityname, sp.stateprovincename, co.countryname, co.continent, sp.salesterritory,
            co.region, co.subregion, c.location, COALESCE(c.latestrecordedpopulation, 0), valid_from, NULL
        FROM application.cities_archive c
        JOIN application.stateprovinces_archive sp ON c.stateprovinceid = sp.stateprovinceid
        JOIN application.countries_archive co ON sp.countryid = co.countryid
        WHERE co.countryid = country_id;
    END LOOP;

    -- Process StateProvince Changes
    FOR state_province_id, valid_from IN
        SELECT stateprovinceid, validfrom FROM application.stateprovinces_archive 
        WHERE validfrom > last_cutoff AND validfrom <= new_cutoff AND validfrom <> initial_load_date
        UNION ALL
        SELECT stateprovinceid, validfrom FROM application.stateprovinces
        WHERE validfrom > last_cutoff AND validfrom <= new_cutoff AND validfrom <> initial_load_date
        ORDER BY validfrom
    LOOP
        INSERT INTO city_changes
        SELECT 
            c.cityid, c.cityname, sp.stateprovincename, co.countryname, co.continent, sp.salesterritory,
            co.region, co.subregion, c.location, COALESCE(c.latestrecordedpopulation, 0), valid_from, NULL
        FROM application.cities_archive c
        JOIN application.stateprovinces_archive sp ON c.stateprovinceid = sp.stateprovinceid
        JOIN application.countries_archive co ON sp.countryid = co.countryid
        WHERE sp.stateprovinceid = state_province_id;
    END LOOP;

    -- Process City Changes
    FOR city_id, valid_from IN
        SELECT cityid, validfrom FROM application.cities_archive 
        WHERE validfrom > last_cutoff AND validfrom <= new_cutoff
        UNION ALL
        SELECT cityid, validfrom FROM application.cities
        WHERE validfrom > last_cutoff AND validfrom <= new_cutoff
        ORDER BY validfrom
    LOOP
        INSERT INTO city_changes
        SELECT 
            c.cityid, c.cityname, sp.stateprovincename, co.countryname, co.continent, sp.salesterritory,
            co.region, co.subregion, c.location, COALESCE(c.latestrecordedpopulation, 0), valid_from, NULL
        FROM application.cities_archive c
        JOIN application.stateprovinces_archive sp ON c.stateprovinceid = sp.stateprovinceid
        JOIN application.countries_archive co ON sp.countryid = co.countryid
        WHERE c.cityid = city_id;
    END LOOP;

    -- Update valid_to for each record
    UPDATE city_changes cc
    SET valid_to = COALESCE(
        (SELECT MIN(valid_from) 
         FROM city_changes cc2 
         WHERE cc2.wwi_city_id = cc.wwi_city_id AND cc2.valid_from > cc.valid_from),
        end_of_time
    );

    -- Return results
  
    SELECT * FROM city_changes ORDER BY valid_from;

END;
$$;


CREATE OR REPLACE PROCEDURE integration.get_customer_updates(
    IN last_cutoff TIMESTAMP(7),
    IN new_cutoff TIMESTAMP(7)
)
LANGUAGE plpgsql
AS $$
DECLARE
    end_of_time TIMESTAMP(7) := '9999-12-31 23:59:59.999999';
    initial_load_date DATE := '2013-01-01';
    buying_group_id INT;
    customer_category_id INT;
    customer_id INT;
    valid_from TIMESTAMP(7);
BEGIN
    -- Create temporary table
    CREATE TEMP TABLE customer_changes ON COMMIT DROP AS
    SELECT 
        NULL::INT AS wwi_customer_id, NULL::TEXT AS customer, NULL::TEXT AS bill_to_customer, 
        NULL::TEXT AS category, NULL::TEXT AS buying_group, NULL::TEXT AS primary_contact, 
        NULL::TEXT AS postal_code, NULL::TIMESTAMP(7) AS valid_from, NULL::TIMESTAMP(7) AS valid_to
    LIMIT 0;

    -- Process Buying Group Changes
    FOR buying_group_id, valid_from IN
        SELECT buyinggroupid, validfrom FROM sales.buyinggroups_archive 
        WHERE validfrom > last_cutoff AND validfrom <= new_cutoff AND validfrom <> initial_load_date
        UNION ALL
        SELECT buyinggroupid, validfrom FROM sales.buyinggroups
        WHERE validfrom > last_cutoff AND validfrom <= new_cutoff AND validfrom <> initial_load_date
        ORDER BY validfrom
    LOOP
        INSERT INTO customer_changes
        SELECT c.customerid, c.customername, bt.customername, cc.customercategoryname,
               bg.buyinggroupname, p.fullname, c.deliverypostalcode, valid_from, NULL
        FROM sales.customers_archive c
        JOIN sales.buyinggroups_archive bg ON c.buyinggroupid = bg.buyinggroupid
        JOIN sales.customercategories_archive cc ON c.customercategoryid = cc.customercategoryid
        JOIN sales.customers_archive bt ON c.billtocustomerid = bt.customerid
        JOIN application.people_archive p ON c.primarycontactpersonid = p.personid
        WHERE c.buyinggroupid = buying_group_id;
    END LOOP;

    -- Process Customer Category Changes
    FOR customer_category_id, valid_from IN
        SELECT customercategoryid, validfrom FROM sales.customercategories_archive
        WHERE validfrom > last_cutoff AND validfrom <= new_cutoff AND validfrom <> initial_load_date
        UNION ALL
        SELECT customercategoryid, validfrom FROM sales.customercategories
        WHERE validfrom > last_cutoff AND validfrom <= new_cutoff AND validfrom <> initial_load_date
        ORDER BY validfrom
    LOOP
        INSERT INTO customer_changes
        SELECT c.customerid, c.customername, bt.customername, cc.customercategoryname,
               bg.buyinggroupname, p.fullname, c.deliverypostalcode, valid_from, NULL
        FROM sales.customers_archive c
        JOIN sales.buyinggroups_archive bg ON c.buyinggroupid = bg.buyinggroupid
        JOIN sales.customercategories_archive cc ON c.customercategoryid = cc.customercategoryid
        JOIN sales.customers_archive bt ON c.billtocustomerid = bt.customerid
        JOIN application.people_archive p ON c.primarycontactpersonid = p.personid
        WHERE cc.customercategoryid = customer_category_id;
    END LOOP;

    -- Process Customer Changes
    FOR customer_id, valid_from IN
        SELECT customerid, validfrom FROM sales.customers_archive
        WHERE validfrom > last_cutoff AND validfrom <= new_cutoff
        UNION ALL
        SELECT customerid, validfrom FROM sales.customers
        WHERE validfrom > last_cutoff AND validfrom <= new_cutoff
        ORDER BY validfrom
    LOOP
        INSERT INTO customer_changes
        SELECT c.customerid, c.customername, bt.customername, cc.customercategoryname,
               bg.buyinggroupname, p.fullname, c.deliverypostalcode, valid_from, NULL
        FROM sales.customers_archive c
        JOIN sales.buyinggroups_archive bg ON c.buyinggroupid = bg.buyinggroupid
        JOIN sales.customercategories_archive cc ON c.customercategoryid = cc.customercategoryid
        JOIN sales.customers_archive bt ON c.billtocustomerid = bt.customerid
        JOIN application.people_archive p ON c.primarycontactpersonid = p.personid
        WHERE c.customerid = customer_id;
    END LOOP;

    -- Update valid_to for each record
    UPDATE customer_changes cc
    SET valid_to = COALESCE(
        (SELECT MIN(valid_from) 
         FROM customer_changes cc2
         WHERE cc2.wwi_customer_id = cc.wwi_customer_id AND cc2.valid_from > cc.valid_from),
        end_of_time
    );

    -- Return results
    RETURN QUERY
    SELECT * FROM customer_changes ORDER BY valid_from;
END;
$$;


CREATE OR REPLACE FUNCTION Integration.GetEmployeeUpdates(
    last_cutoff TIMESTAMPTZ,
    new_cutoff TIMESTAMPTZ
) RETURNS TABLE (
    wwi_employee_id INT,
    employee TEXT,
    preferred_name TEXT,
    is_salesperson BOOLEAN,
    photo BYTEA,
    valid_from TIMESTAMPTZ,
    valid_to TIMESTAMPTZ
) AS $$
DECLARE
    end_of_time CONSTANT TIMESTAMPTZ := '9999-12-31 23:59:59.999999';
    person_id INT;
    valid_from TIMESTAMPTZ;
BEGIN
    -- Create a temporary table for storing employee changes
    CREATE TEMP TABLE employee_changes (
        wwi_employee_id INT,
        employee TEXT,
        preferred_name TEXT,
        is_salesperson BOOLEAN,
        photo BYTEA,
        valid_from TIMESTAMPTZ,
        valid_to TIMESTAMPTZ
    ) ON COMMIT DROP;

    -- Cursor to iterate through employee changes
    FOR person_id, valid_from IN
        (SELECT p.personid, p.validfrom FROM application.people_archive p
         WHERE p.validfrom > last_cutoff AND p.validfrom <= new_cutoff AND p.isemployee <> 0
         UNION ALL
         SELECT p.personid, p.validfrom FROM application.people p
         WHERE p.validfrom > last_cutoff AND p.validfrom <= new_cutoff AND p.isemployee <> 0
         ORDER BY validfrom)
    LOOP
        -- Insert into the temporary table
        INSERT INTO employee_changes (wwi_employee_id, employee, preferred_name, is_salesperson, photo, valid_from, valid_to)
        SELECT p.personid, p.fullname, p.preferredname, p.issalesperson, p.photo, p.validfrom, p.validto
        FROM application.people p
        WHERE p.personid = person_id AND p.validfrom = valid_from;
    END LOOP;

    -- Update the Valid To column
    UPDATE employee_changes cc
    SET valid_to = COALESCE(
        (SELECT MIN(valid_from) FROM employee_changes cc2
         WHERE cc2.wwi_employee_id = cc.wwi_employee_id AND cc2.valid_from > cc.valid_from), 
        end_of_time
    );

    -- Return the results
    RETURN QUERY
    SELECT * FROM employee_changes ORDER BY valid_from;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION Integration.GetMovementUpdates(
    LastCutoff timestamp,
    NewCutoff timestamp
)
RETURNS TABLE (
    DateKey date,
    WWI_Stock_Item_Transaction_ID int,
    WWI_Invoice_ID int,
    WWI_Purchase_Order_ID int,
    Quantity int,
    WWI_Stock_Item_ID int,
    WWI_Customer_ID int,
    WWI_Supplier_ID int,
    WWI_Transaction_Type_ID int,
    Transaction_Occurred_When timestamp
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        CAST(sit.TransactionOccurredWhen AS date) AS DateKey,
        sit.StockItemTransactionID AS WWI_Stock_Item_Transaction_ID,
        sit.InvoiceID AS WWI_Invoice_ID,
        sit.PurchaseOrderID AS WWI_Purchase_Order_ID,
        CAST(sit.Quantity AS int) AS Quantity,
        sit.StockItemID AS WWI_Stock_Item_ID,
        sit.CustomerID AS WWI_Customer_ID,
        sit.SupplierID AS WWI_Supplier_ID,
        sit.TransactionTypeID AS WWI_Transaction_Type_ID,
        sit.TransactionOccurredWhen AS Transaction_Occurred_When
    FROM Warehouse.StockItemTransactions sit
    WHERE sit.LastEditedWhen > LastCutoff
      AND sit.LastEditedWhen <= NewCutoff
    ORDER BY sit.StockItemTransactionID;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION Integration.GetOrderUpdates(
    LastCutoff timestamp,
    NewCutoff timestamp
)
RETURNS TABLE (
    Order_Date_Key date,
    Picked_Date_Key date,
    WWI_Order_ID int,
    WWI_Backorder_ID int,
    Description text,
    Package text,
    Quantity int,
    Unit_Price numeric,
    Tax_Rate numeric,
    Total_Excluding_Tax numeric,
    Tax_Amount numeric,
    Total_Including_Tax numeric,
    WWI_City_ID int,
    WWI_Customer_ID int,
    WWI_Stock_Item_ID int,
    WWI_Salesperson_ID int,
    WWI_Picker_ID int,
    Last_Modified_When timestamp
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        CAST(o.OrderDate AS date) AS Order_Date_Key,
        CAST(ol.PickingCompletedWhen AS date) AS Picked_Date_Key,
        o.OrderID AS WWI_Order_ID,
        o.BackorderOrderID AS WWI_Backorder_ID,
        ol.Description,
        pt.PackageTypeName AS Package,
        ol.Quantity,
        ol.UnitPrice AS Unit_Price,
        ol.TaxRate AS Tax_Rate,
        ROUND(ol.Quantity * ol.UnitPrice, 2) AS Total_Excluding_Tax,
        ROUND(ol.Quantity * ol.UnitPrice * ol.TaxRate / 100.0, 2) AS Tax_Amount,
        ROUND(ol.Quantity * ol.UnitPrice, 2) + ROUND(ol.Quantity * ol.UnitPrice * ol.TaxRate / 100.0, 2) AS Total_Including_Tax,
        c.DeliveryCityID AS WWI_City_ID,
        c.CustomerID AS WWI_Customer_ID,
        ol.StockItemID AS WWI_Stock_Item_ID,
        o.SalespersonPersonID AS WWI_Salesperson_ID,
        o.PickedByPersonID AS WWI_Picker_ID,
        CASE 
            WHEN ol.LastEditedWhen > o.LastEditedWhen THEN ol.LastEditedWhen
            ELSE o.LastEditedWhen
        END AS Last_Modified_When
    FROM Sales.Orders o
    INNER JOIN Sales.OrderLines ol ON o.OrderID = ol.OrderID
    INNER JOIN Warehouse.PackageTypes pt ON ol.PackageTypeID = pt.PackageTypeID
    INNER JOIN Sales.Customers c ON c.CustomerID = o.CustomerID
    WHERE 
        CASE 
            WHEN ol.LastEditedWhen > o.LastEditedWhen THEN ol.LastEditedWhen
            ELSE o.LastEditedWhen
        END > LastCutoff
    AND 
        CASE 
            WHEN ol.LastEditedWhen > o.LastEditedWhen THEN ol.LastEditedWhen
            ELSE o.LastEditedWhen
        END <= NewCutoff
    ORDER BY o.OrderID;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION Integration.GetPurchaseUpdates(
    LastCutoff timestamp,
    NewCutoff timestamp
)
RETURNS TABLE (
    Date_Key date,
    WWI_Purchase_Order_ID int,
    Ordered_Outers int,
    Ordered_Quantity int,
    Received_Outers int,
    Package text,
    Is_Order_Finalized boolean,
    WWI_Supplier_ID int,
    WWI_Stock_Item_ID int,
    Last_Modified_When timestamp
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        CAST(po.OrderDate AS date) AS Date_Key,
        po.PurchaseOrderID AS WWI_Purchase_Order_ID,
        pol.OrderedOuters AS Ordered_Outers,
        pol.OrderedOuters * si.QuantityPerOuter AS Ordered_Quantity,
        pol.ReceivedOuters AS Received_Outers,
        pt.PackageTypeName AS Package,
        pol.IsOrderLineFinalized AS Is_Order_Finalized,
        po.SupplierID AS WWI_Supplier_ID,
        pol.StockItemID AS WWI_Stock_Item_ID,
        CASE 
            WHEN pol.LastEditedWhen > po.LastEditedWhen THEN pol.LastEditedWhen 
            ELSE po.LastEditedWhen 
        END AS Last_Modified_When
    FROM Purchasing.PurchaseOrders AS po
    INNER JOIN Purchasing.PurchaseOrderLines AS pol
        ON po.PurchaseOrderID = pol.PurchaseOrderID
    INNER JOIN Warehouse.StockItems AS si
        ON pol.StockItemID = si.StockItemID
    INNER JOIN Warehouse.PackageTypes AS pt
        ON pol.PackageTypeID = pt.PackageTypeID
    WHERE 
        CASE 
            WHEN pol.LastEditedWhen > po.LastEditedWhen THEN pol.LastEditedWhen 
            ELSE po.LastEditedWhen 
        END > LastCutoff
    AND 
        CASE 
            WHEN pol.LastEditedWhen > po.LastEditedWhen THEN pol.LastEditedWhen 
            ELSE po.LastEditedWhen 
        END <= NewCutoff
    ORDER BY po.PurchaseOrderID;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION Integration.GetStockHoldingUpdates()
RETURNS TABLE (
    Quantity_On_Hand int,
    Bin_Location text,
    Last_Stocktake_Quantity int,
    Last_Cost_Price numeric,
    Reorder_Level int,
    Target_Stock_Level int,
    WWI_Stock_Item_ID int
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        sih.QuantityOnHand AS Quantity_On_Hand,
        sih.BinLocation AS Bin_Location,
        sih.LastStocktakeQuantity AS Last_Stocktake_Quantity,
        sih.LastCostPrice AS Last_Cost_Price,
        sih.ReorderLevel AS Reorder_Level,
        sih.TargetStockLevel AS Target_Stock_Level,
        sih.StockItemID AS WWI_Stock_Item_ID
    FROM Warehouse.StockItemHoldings AS sih
    ORDER BY sih.StockItemID;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION Integration.GetTransactionUpdates(
    LastCutoff timestamp,
    NewCutoff timestamp
)
RETURNS TABLE (
    Date_Key date,
    WWI_Customer_Transaction_ID int,
    WWI_Supplier_Transaction_ID int,
    WWI_Invoice_ID int,
    WWI_Purchase_Order_ID int,
    Supplier_Invoice_Number text,
    Total_Excluding_Tax numeric(18, 2),
    Tax_Amount numeric(18, 2),
    Total_Including_Tax numeric(18, 2),
    Outstanding_Balance numeric(18, 2),
    Is_Finalized boolean,
    WWI_Customer_ID int,
    WWI_Bill_To_Customer_ID int,
    WWI_Supplier_ID int,
    WWI_Transaction_Type_ID int,
    WWI_Payment_Method_ID int,
    Last_Modified_When timestamp
) AS $$
BEGIN
    RETURN QUERY
    -- First part: Customer Transactions
    SELECT 
        CAST(ct.TransactionDate AS date) AS Date_Key,
        ct.CustomerTransactionID AS WWI_Customer_Transaction_ID,
        NULL::int AS WWI_Supplier_Transaction_ID,
        ct.InvoiceID AS WWI_Invoice_ID,
        NULL::int AS WWI_Purchase_Order_ID,
        NULL::text AS Supplier_Invoice_Number,
        ct.AmountExcludingTax AS Total_Excluding_Tax,
        ct.TaxAmount AS Tax_Amount,
        ct.TransactionAmount AS Total_Including_Tax,
        ct.OutstandingBalance AS Outstanding_Balance,
        ct.IsFinalized AS Is_Finalized,
        COALESCE(i.CustomerID, ct.CustomerID) AS WWI_Customer_ID,
        ct.CustomerID AS WWI_Bill_To_Customer_ID,
        NULL::int AS WWI_Supplier_ID,
        ct.TransactionTypeID AS WWI_Transaction_Type_ID,
        ct.PaymentMethodID AS WWI_Payment_Method_ID,
        ct.LastEditedWhen AS Last_Modified_When
    FROM Sales.CustomerTransactions AS ct
    LEFT JOIN Sales.Invoices AS i
        ON ct.InvoiceID = i.InvoiceID
    WHERE ct.LastEditedWhen > LastCutoff
    AND ct.LastEditedWhen <= NewCutoff

    UNION ALL

    -- Second part: Supplier Transactions
    SELECT 
        CAST(st.TransactionDate AS date) AS Date_Key,
        NULL::int AS WWI_Customer_Transaction_ID,
        st.SupplierTransactionID AS WWI_Supplier_Transaction_ID,
        NULL::int AS WWI_Invoice_ID,
        st.PurchaseOrderID AS WWI_Purchase_Order_ID,
        st.SupplierInvoiceNumber AS Supplier_Invoice_Number,
        st.AmountExcludingTax AS Total_Excluding_Tax,
        st.TaxAmount AS Tax_Amount,
        st.TransactionAmount AS Total_Including_Tax,
        st.OutstandingBalance AS Outstanding_Balance,
        st.IsFinalized AS Is_Finalized,
        NULL::int AS WWI_Customer_ID,
        NULL::int AS WWI_Bill_To_Customer_ID,
        st.SupplierID AS WWI_Supplier_ID,
        st.TransactionTypeID AS WWI_Transaction_Type_ID,
        st.PaymentMethodID AS WWI_Payment_Method_ID,
        st.LastEditedWhen AS Last_Modified_When
    FROM Purchasing.SupplierTransactions AS st
    WHERE st.LastEditedWhen > LastCutoff
    AND st.LastEditedWhen <= NewCutoff;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE Sequences.ReseedAllSequences()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Ensures that the next sequence values are above the maximum value of the related table columns

    CALL Sequences.ReseedSequenceBeyondTableValues('BuyingGroupID', 'Sales', 'BuyingGroups', 'BuyingGroupID');
    CALL Sequences.ReseedSequenceBeyondTableValues('CityID', 'Application', 'Cities', 'CityID');
    CALL Sequences.ReseedSequenceBeyondTableValues('ColorID', 'Warehouse', 'Colors', 'ColorID');
    CALL Sequences.ReseedSequenceBeyondTableValues('CountryID', 'Application', 'Countries', 'CountryID');
    CALL Sequences.ReseedSequenceBeyondTableValues('CustomerCategoryID', 'Sales', 'CustomerCategories', 'CustomerCategoryID');
    CALL Sequences.ReseedSequenceBeyondTableValues('CustomerID', 'Sales', 'Customers', 'CustomerID');
    CALL Sequences.ReseedSequenceBeyondTableValues('DeliveryMethodID', 'Application', 'DeliveryMethods', 'DeliveryMethodID');
    CALL Sequences.ReseedSequenceBeyondTableValues('InvoiceID', 'Sales', 'Invoices', 'InvoiceID');
    CALL Sequences.ReseedSequenceBeyondTableValues('InvoiceLineID', 'Sales', 'InvoiceLines', 'InvoiceLineID');
    CALL Sequences.ReseedSequenceBeyondTableValues('OrderID', 'Sales', 'Orders', 'OrderID');
    CALL Sequences.ReseedSequenceBeyondTableValues('OrderLineID', 'Sales', 'OrderLines', 'OrderLineID');
    CALL Sequences.ReseedSequenceBeyondTableValues('PackageTypeID', 'Warehouse', 'PackageTypes', 'PackageTypeID');
    CALL Sequences.ReseedSequenceBeyondTableValues('PaymentMethodID', 'Application', 'PaymentMethods', 'PaymentMethodID');
    CALL Sequences.ReseedSequenceBeyondTableValues('PersonID', 'Application', 'People', 'PersonID');
    CALL Sequences.ReseedSequenceBeyondTableValues('PurchaseOrderID', 'Purchasing', 'PurchaseOrders', 'PurchaseOrderID');
    CALL Sequences.ReseedSequenceBeyondTableValues('PurchaseOrderLineID', 'Purchasing', 'PurchaseOrderLines', 'PurchaseOrderLineID');
    CALL Sequences.ReseedSequenceBeyondTableValues('SpecialDealID', 'Sales', 'SpecialDeals', 'SpecialDealID');
    CALL Sequences.ReseedSequenceBeyondTableValues('StateProvinceID', 'Application', 'StateProvinces', 'StateProvinceID');
    CALL Sequences.ReseedSequenceBeyondTableValues('StockGroupID', 'Warehouse', 'StockGroups', 'StockGroupID');
    CALL Sequences.ReseedSequenceBeyondTableValues('StockItemID', 'Warehouse', 'StockItems', 'StockItemID');
    CALL Sequences.ReseedSequenceBeyondTableValues('StockItemStockGroupID', 'Warehouse', 'StockItemStockGroups', 'StockItemStockGroupID');
    CALL Sequences.ReseedSequenceBeyondTableValues('SupplierCategoryID', 'Purchasing', 'SupplierCategories', 'SupplierCategoryID');
    CALL Sequences.ReseedSequenceBeyondTableValues('SupplierID', 'Purchasing', 'Suppliers', 'SupplierID');
    CALL Sequences.ReseedSequenceBeyondTableValues('SystemParameterID', 'Application', 'SystemParameters', 'SystemParameterID');
    CALL Sequences.ReseedSequenceBeyondTableValues('TransactionID', 'Purchasing', 'SupplierTransactions', 'SupplierTransactionID');
    CALL Sequences.ReseedSequenceBeyondTableValues('TransactionID', 'Sales', 'CustomerTransactions', 'CustomerTransactionID');
    CALL Sequences.ReseedSequenceBeyondTableValues('TransactionID', 'Warehouse', 'StockItemTransactions', 'StockItemTransactionID');
    CALL Sequences.ReseedSequenceBeyondTableValues('TransactionTypeID', 'Application', 'TransactionTypes', 'TransactionTypeID');
END;
$$;


CREATE OR REPLACE FUNCTION Website.ActivateWebsiteLogon(
    PersonID int,
    LogonName text,
    InitialPassword text
)
RETURNS void AS $$
BEGIN
    -- Update the person's logon information if valid
    UPDATE "Application".People
    SET IsPermittedToLogon = true,
        LogonName = LogonName,
        HashedPassword = encode(digest(InitialPassword || FullName, 'sha256'), 'hex'),
        UserPreferences = (SELECT UserPreferences FROM "Application".People WHERE PersonID = 1) -- Person 1 has User Preferences template
    WHERE PersonID = PersonID
    AND PersonID <> 1
    AND IsPermittedToLogon = false;

    -- Check if any row was updated
    IF NOT FOUND THEN
        RAISE NOTICE 'The PersonID must be valid, must not be person 1, and must not already be enabled';
        RAISE EXCEPTION 'Invalid PersonID';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION Website.ChangePassword(
    PersonID int,
    OldPassword text,
    NewPassword text
)
RETURNS void AS $$
BEGIN
    -- Update the person's password if the old password matches
    UPDATE "Application".People
    SET IsPermittedToLogon = true,
        HashedPassword = encode(digest(NewPassword || FullName, 'sha256'), 'hex')
    WHERE PersonID = PersonID
    AND PersonID <> 1
    AND HashedPassword = encode(digest(OldPassword || FullName, 'sha256'), 'hex');

    -- Check if any row was updated
    IF NOT FOUND THEN
        RAISE NOTICE 'The PersonID must be valid, and the old password must be valid.';
        RAISE NOTICE 'If the user has also changed name, please contact the IT staff to assist.';
        RAISE EXCEPTION 'Invalid Password Change';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION Website.SearchForCustomers(
    SearchText text,
    MaximumRowsToReturn int
)
RETURNS jsonb AS $$
DECLARE
    result jsonb;
BEGIN
    -- Construct and return the JSON response
    SELECT jsonb_agg(
               jsonb_build_object(
                   'CustomerID', c.CustomerID,
                   'CustomerName', c.CustomerName,
                   'CityName', ct.CityName,
                   'PhoneNumber', c.PhoneNumber,
                   'FaxNumber', c.FaxNumber,
                   'PrimaryContactFullName', p.FullName,
                   'PrimaryContactPreferredName', p.PreferredName
               )
           )
    INTO result
    FROM Sales.Customers AS c
    INNER JOIN Application.Cities AS ct
        ON c.DeliveryCityID = ct.CityID
    LEFT OUTER JOIN Application.People AS p
        ON c.PrimaryContactPersonID = p.PersonID
    WHERE CONCAT(c.CustomerName, ' ', p.FullName, ' ', p.PreferredName) ILIKE '%' || SearchText || '%'
    ORDER BY c.CustomerName
    LIMIT MaximumRowsToReturn;

    -- Return the JSON result
    RETURN result;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION Website.SearchForPeople(
    SearchText text,
    MaximumRowsToReturn int
)
RETURNS jsonb AS $$
DECLARE
    result jsonb;
BEGIN
    -- Construct and return the JSON response
    SELECT jsonb_agg(
               jsonb_build_object(
                   'PersonID', p.PersonID,
                   'FullName', p.FullName,
                   'PreferredName', p.PreferredName,
                   'Relationship', CASE 
                       WHEN p.IsSalesperson <> 0 THEN 'Salesperson'
                       WHEN p.IsEmployee <> 0 THEN 'Employee'
                       WHEN c.CustomerID IS NOT NULL THEN 'Customer'
                       WHEN sp.SupplierID IS NOT NULL THEN 'Supplier'
                       WHEN sa.SupplierID IS NOT NULL THEN 'Supplier'
                       ELSE NULL
                   END,
                   'Company', COALESCE(c.CustomerName, sp.SupplierName, sa.SupplierName, 'WWI')
               )
           )
    INTO result
    FROM Application.People AS p
    LEFT OUTER JOIN Sales.Customers AS c
        ON c.PrimaryContactPersonID = p.PersonID
    LEFT OUTER JOIN Purchasing.Suppliers AS sp
        ON sp.PrimaryContactPersonID = p.PersonID
    LEFT OUTER JOIN Purchasing.Suppliers AS sa
        ON sa.AlternateContactPersonID = p.PersonID
    WHERE p.SearchName ILIKE '%' || SearchText || '%'
    ORDER BY p.FullName
    LIMIT MaximumRowsToReturn;

    -- Return the JSON result
    RETURN result;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE Website.SearchForStockItems(
    SearchText text,  -- Use text, not nvarchar
    MaximumRowsToReturn int
)
LANGUAGE plpgsql
AS $$
DECLARE
    result jsonb;
BEGIN
    -- Constructing JSON manually using jsonb_agg and json_build_object
    SELECT jsonb_agg(
               jsonb_build_object(
                   'StockItemID', si.StockItemID,
                   'StockItemName', si.StockItemName
               )
           )
    INTO result
    FROM Warehouse.StockItems AS si
    WHERE si.StockItemName ILIKE '%' || SearchText || '%'
    LIMIT MaximumRowsToReturn;

    -- Return the result
    RAISE NOTICE 'Result: %', result;

END;
$$;


CREATE OR REPLACE PROCEDURE Website.SearchForSuppliers(
    SearchText text,  -- Use text instead of nvarchar
    MaximumRowsToReturn int
)
LANGUAGE plpgsql
AS $$
DECLARE
    result jsonb;
BEGIN
    -- Constructing JSON manually using jsonb_agg and jsonb_build_object
    SELECT jsonb_agg(
               jsonb_build_object(
                   'SupplierID', s.SupplierID,
                   'SupplierName', s.SupplierName,
                   'CityName', c.CityName,
                   'PhoneNumber', s.PhoneNumber,
                   'FaxNumber', s.FaxNumber,
                   'PrimaryContactFullName', p.FullName,
                   'PrimaryContactPreferredName', p.PreferredName
               )
           )
    INTO result
    FROM Purchasing.Suppliers AS s
    INNER JOIN Application.Cities AS c
    ON s.DeliveryCityID = c.CityID
    LEFT OUTER JOIN Application.People AS p
    ON s.PrimaryContactPersonID = p.PersonID
    WHERE CONCAT(s.SupplierName, ' ', p.FullName, ' ', p.PreferredName) ILIKE '%' || SearchText || '%'
    LIMIT MaximumRowsToReturn;

    -- Return the result
    RAISE NOTICE 'Result: %', result;

    
END;
$$;


