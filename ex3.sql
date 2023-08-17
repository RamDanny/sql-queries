REM ***Q1 : Display the food details that is not purchased by any of customers. ***
SELECT flavor, food, price
FROM products
WHERE pid NOT IN (SELECT item FROM item_list GROUP BY item);

REM ***Q2 : Show the customer details who had placed more than 2 orders on the same date. ***
SELECT fname, lname
  FROM customers
  WHERE cid IN (SELECT cid FROM receipts GROUP BY rdate, cid HAVING COUNT(cid) > 2);

REM ***Q3 : Display the products details that has been ordered maximum by the customers. (use ALL) ***
SELECT flavor, food, price
FROM products
WHERE pid = (SELECT item FROM item_list GROUP BY item HAVING COUNT(*) = (SELECT MAX(y.num)
FROM (SELECT COUNT(item) AS num FROM item_list GROUP BY item) y)
);

REM ***Q4: Show the number of receipts that contain the product whose price is more than the average price of its food type.***

SELECT COUNT(UNIQUE(rno))
FROM item_list
WHERE item IN (SELECT pid FROM products p
WHERE price > (SELECT AVG(price) FROM products);

REM ***Q5: Display the customer details along with receipt number and date for the receipts that are dated on the last day of the receipt month.***

SELECT c.cid, fname, lname, rno, rdate
  FROM customers c, receipts r
  WHERE c.cid = r.cid AND rdate = LAST_DAY(rdate);

REM ***Q6: Display the receipt number(s) and its total price for the receipt(s) that contain Twist as one among five items. Include only the receipts with total price more than $25.***

SELECT i.rno, SUM(p.price) AS total 
 FROM item_list i, products p 
 WHERE i.item = p.pid AND p.food = 'Twist' 
 GROUP BY i.rno 
 HAVING COUNT(item) = 5 AND SUM(p.price) > 25;

REM ***Q7: Display the details (customer details, receipt number, item) for the product that was purchased by the least number of customers.***

SELECT c.fname, c.lname, r.rno, p.flavor, p.food 
FROM customers c, products p, receipts r, item_list i 
WHERE c.cid = r.cid AND p.pid = i.item AND r.rno = i.rno AND i.item  4  (SELECT i.item 
FROM customers c, products p, receipts r, item_list i 
WHERE c.cid = r.cid AND p.pid = i.item AND r.rno = i.rno 
GROUP BY i.item 
HAVING COUNT(c.cid) = (SELECT MIN(COUNT(c.cid)) 
FROM customers c, products p, receipts r, item_list i 
WHERE c.cid = r.cid AND p.pid = i.item AND r.rno = i.rno 
GROUP BY i.item));

REM ***Q8: Display the customer details along with the receipt number who ordered all the flavors of Meringue in the same receipt.***

SELECT c.cid, c.fname, c.lname, r.rno 
FROM customers c, products p, receipts r, item_list i 
WHERE c.cid = r.cid AND p.pid = i.item AND r.rno = i.rno AND r.rno IN 4 (SELECT i.rno 
FROM products p, item_list i 
WHERE p.pid = i.item AND p.food = 'Meringue' 
GROUP BY i.rno 
HAVING COUNT(i.rno) > 1);

REM ***Q9***

SELECT flavor, food, price FROM products WHERE products.food = 'Bear Claw'
  UNION
  SELECT flavor, food, price FROM products WHERE products.food = 'Pie'

REM ***Q10***

SELECT cid FROM customers
  MINUS
  SELECT DISTINCT(cid) FROM receipts

REM ***Q11***

SELECT food
  FROM products
  WHERE flavor = (SELECT flavor FROM products WHERE food = 'Meringue'
  INTERSECT
  SELECT flavor FROM products WHERE food = 'Tart')

