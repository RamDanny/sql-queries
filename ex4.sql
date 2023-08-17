REM ***Q1: Create a view named Blue_Flavor, which display the product details (product id,  food, price) of Blueberry flavor.***

CREATE OR REPLACE VIEW Blue_Flavor AS
  SELECT pid, food, price
  FROM products
  WHERE flavor LIKE 'Blueberry';

SELECT * FROM Blue_Flavor;

UPDATE Blue_Flavor SET food = 'Chicken' WHERE pid = '51-BLU';

SELECT * from Blue_Flavor;

REM ***Q2: Create a view named Cheap_Food, which display the details (product id, flavor,  food, price) of products with price lesser than $1. Ensure that, the price of these  food(s) should never rise above $1 through view.***

SELECT * FROM Cheap_Food;

UPDATE Cheap_Food SET flavor = 'Cream' WHERE pid = '70-W'; 

SELECT * FROM Cheap_Food; 

REM ***Q3: Create a view called Hot_Food that show the product id and its quantity where the same product is ordered more than once in the same receipt.***

SELECT * FROM Hot_Food;

REM ***Q4: Create a view named Pie_Food that will display the details (customer lname, flavor,  receipt number and date, ordinal) who had ordered the Pie food with receipt details.***

SELECT * FROM Pie_Food;

REM ***Q5: Create a view Cheap_View from Cheap_Food that shows only the product id, flavor  and food.***

SELECT * FROM Cheap_View;

UPDATE Cheap_View SET flavor = 'Walnut' where pid = '70-W'; 

REM ***Q6: Create a sequence named Ordinal_No_Seq which generates the ordinal number  starting from 1, increment by 1, to a maximum of 10. Include the options of cycle,  cache and order. Use this sequence to populate the item_list table for a new order.***

CREATE SEQUENCE ono_seq
 START WITH 0
 INCREMENT BY 1
 MINVALUE 0
 MAXVALUE 10
 NOCACHE
 NOCYCLE;

INSERT INTO item_list VALUES(99999, ono_seq.nextval, '45-VA');

INSERT INTO item_list VALUES(99999, ono_seq.nextval, '45-VA');

REM ***Q7: Create a synonym named Product_details for the item_list relation. Perform the DML operations on it.***

CREATE SYNONYM Product_details
 FOR item_list;

INSERT INTO Product_details VALUES(9999, 1, '45-CO');

DROP SYNONYM Product_details;

DROP SEQUENCE ono_seq;

DROP VIEW Cheap_View;

DROP VIEW Cheap_Food;

DROP VIEW Hot_Food;
