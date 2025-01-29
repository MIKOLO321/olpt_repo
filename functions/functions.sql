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





