CREATE TYPE website.order_line_list AS(
    order_reference INT,
    stock_item_id INT,
    description VARCHAR(100),
    quantity INT
);

CREATE TYPE website.order_list AS (
    order_reference INT,
    customer_id INT,
    contact_person_id INT,
    expected_delivery_date DATE,
    customer_purchase_order_number VARCHAR(20),
    is_undersupply_backordered BOOLEAN,
    comments TEXT,
    delivery_instructions TEXT
);

CREATE TYPE website.sensor_data_list AS (
    sensor_data_list_id int,  
    cold_room_sensor_number INT,
    recorded_when TIMESTAMP(6),
    temperature DECIMAL(18,2)
);


















