
CREATE SEQUENCE Sequences.BuyingGroupID
AS INTEGER
START WITH 3
INCREMENT BY 1
MINVALUE 2147483648
MAXVALUE 2147483647
CACHE 1;

-- to see the next  values
select nextval('Sequences.BuyingGroupID');


CREATE SEQUENCE tbs_seq
START WITH 100
INCREMENT BY 1
MINVALUE 100
MAXVALUE 999;

-- to see the next  values
select nextval('tbs_seq');


--Now lets create table with the sequence and insert data
CREATE TABLE my_table_seq
   ( EMP_id INTEGER default nextval('tbs_seq'),
    name VARCHAR(255)
);


INSERT INTO my_table_seq (name) VALUES ('Alice');
INSERT INTO my_table_seq (name) VALUES ('Bob');
INSERT INTO my_table_seq (name) VALUES ('Charlie');

SELECT * FROM my_table_seq
