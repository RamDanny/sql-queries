REM ***Q1: Check whether the given combination of food and flavor is available. If any one or both are not available, display the relevant message.***

DECLARE
CURSOR prod1 IS SELECT flavor, food FROM products;
food_in VARCHAR(20);
flavor_in VARCHAR(20);
fo VARCHAR(20);
fl VARCHAR(20);
rowct NUMBER;
foodfound NUMBER;
flavfound NUMBER;
BEGIN
flavor_in := '&flavor';
food_in := '&food';
SELECT COUNT(*) INTO rowct
FROM products;
OPEN prod1;
FOR counter IN 1 .. rowct LOOP
FETCH prod1 INTO fl, fo;
IF fo = food_in THEN
foodfound := 1; 
ELSE
foodfound := 0;
END IF;
IF fl = flavor_in THEN
flavfound := 1;
ELSE
flavfound := 0;
END IF;
IF foodfound = 1 AND flavfound = 1 THEN
EXIT;
END IF;
END LOOP;
IF foodfound = 1 THEN
DBMS_OUTPUT.PUT_LINE(food_in || ' Found');
ELSE
DBMS_OUTPUT.PUT_LINE(food_in || ' Not Found');
END IF;
IF flavfound = 1 THEN
DBMS_OUTPUT.PUT_LINE(flavor_in || ' Found');
ELSE
DBMS_OUTPUT.PUT_LINE(flavor_in || ' Not Found');
END IF;
CLOSE prod1;
END;

DECLARE
   CURSOR prod1 IS SELECT flavor, food FROM products;
     food_in VARCHAR(20);
     flavor_in VARCHAR(20);
     fo VARCHAR(20);
     fl VARCHAR(20);
     rowct NUMBER;
     foodfound NUMBER;
     flavfound NUMBER;
  BEGIN
     flavor_in := '&flavor';
     food_in := '&food';
     SELECT COUNT(*) INTO rowct
     FROM products;
     OPEN prod1;
     FOR counter IN 1 .. rowct LOOP
             FETCH prod1 INTO fl, fo;
             IF fo = food_in THEN
                     foodfound := 1; 
             ELSE
                     foodfound := 0;
             END IF;
             IF fl = flavor_in THEN
                     flavfound := 1;
             ELSE
                     flavfound := 0;
             END IF;
             IF foodfound = 1 AND flavfound = 1 THEN
                     EXIT;
             END IF;
     END LOOP;
     IF foodfound = 1 THEN
             DBMS_OUTPUT.PUT_LINE(food_in || ' Found');
     ELSE
             DBMS_OUTPUT.PUT_LINE(food_in || ' Not Found');
    END IF;
     IF flavfound = 1 THEN
             DBMS_OUTPUT.PUT_LINE(flavor_in || ' Found');
     ELSE
             DBMS_OUTPUT.PUT_LINE(flavor_in || ' Not Found');
     END IF;
     CLOSE prod1;
END;

REM ***Q2: On a given date, find the number of items sold (Use Implicit cursor).***

DECLARE
     date_in DATE;
     rowct NUMBER;
     itemct NUMBER;
  BEGIN
     date_in := '&date';
     itemct := 0;
     FOR rec IN (SELECT * FROM receipts) LOOP
             IF rec.rdate = date_in THEN
                     FOR it_rec in (SELECT * FROM item_list) LOOP
                             IF rec.rno = it_rec.rno THEN
                                     itemct := itemct + 1;
                             END IF;
                     END LOOP;
             END IF;
     END LOOP;
     DBMS_OUTPUT.PUT_LINE(itemct || ' items sold');
  END;

REM ***Q3: An user desired to buy the product with the specific price. Ask the user for a price, find the food item(s) that is equal or closest to the desired price. Print the product
SQL> REM number, food type, flavor and price. Also print the number of items that is equal or closest to the desired price.***

DECLARE
     price_in NUMBER;
     CURSOR pr1 IS SELECT pid, flavor, food, price, ABS(price-price_in) diff
     FROM products
     ORDER BY diff;
     nearest NUMBER;
     rownum NUMBER;
     recct NUMBER;
  BEGIN
     price_in := '&price';
     nearest := 0;
     rownum := 1;
     recct := 0;
     FOR rec IN pr1 LOOP
             IF rownum = 1 THEN
                     nearest := rec.price;
                     DBMS_OUTPUT.PUT_LINE(rec.pid || ' ' || rec.flavor || ' ' || rec.food || ' ' || rec.price);
                     recct := recct + 1;
             ELSIF nearest = rec.price THEN
                     DBMS_OUTPUT.PUT_LINE(rec.pid || ' ' || rec.flavor || ' ' || rec.food || ' ' || rec.price);
                     recct := recct + 1;
             END IF;
             rownum := rownum + 1;
     END LOOP;
     DBMS_OUTPUT.PUT_LINE(recct || ' items are equal/closest to given price');
  END;

REM ***Q4: Display the customer name along with the details of item and its quantity ordered for the given order number. Also calculate the total quantity ordered.***

DECLARE
     rid_in NUMBER;
     CURSOR db1 IS SELECT p.flavor, p.food, COUNT(*) qty
     FROM products p, item_list i, receipts r
     WHERE r.rno = i.rno AND i.item = p.pid AND r.rno = rid_in
     GROUP BY p.flavor, p.food;
     CURSOR db2 IS SELECT r.rno, c.cid, c.lname, c.fname
     FROM customers c, receipts r
     WHERE c.cid = r.cid;
     tempct NUMBER;
  BEGIN
     rid_in := '&rid';
     tempct := 0;
     FOR rec2 IN db2 LOOP
             IF rid_in = rec2.rno THEN
                     DBMS_OUTPUT.PUT_LINE('Customer Name: ' || rec2.lname || ' ' || rec2.fname);
                     EXIT;
             END IF;
     END LOOP;
     DBMS_OUTPUT.PUT_LINE('Ordered the following items:');
     DBMS_OUTPUT.PUT_LINE('Flavor         Food          Qty');
     FOR rec IN db1 LOOP
             tempct := tempct + rec.qty;
             DBMS_OUTPUT.PUT_LINE(rec.flavor || '   ' || rec.food || '   ' || rec.qty);
     END LOOP;
     DBMS_OUTPUT.PUT_LINE('Total Qty: ' || tempct);
  END;
