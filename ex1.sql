CREATE TABLE Location( 
Pincode NUMBER(6), 
City VARCHAR2(20), 
CONSTRAINT loc_pk PRIMARY KEY(Pincode));


CREATE TABLE Employee( 
E_No VARCHAR2(4), 
Name VARCHAR2(20), 
Dob DATE, 
Pincode NUMBER(6), 
CONSTRAINT emp_pk PRIMARY KEY(E_No), 
CONSTRAINT emp_pin_fk FOREIGN KEY(Pincode) 
REFERENCES Location(Pincode), 
CONSTRAINT emp_eno CHECK(SUBSTR(E_No, 1, 1) = 'E'));


CREATE TABLE Customer( 
C_No VARCHAR2(4), 
Name VARCHAR2(20), 
Dob DATE, 
Street VARCHAR(20), 
Pincode NUMBER(6), 
Phone NUMBER(10), 
CONSTRAINT cust_pk PRIMARY KEY(C_No), 
CONSTRAINT cust_pin_fk FOREIGN KEY(Pincode) 
REFERENCES Location(Pincode), 
CONSTRAINT cust_phone UNIQUE(Phone), 
CONSTRAINT cust_cno CHECK(SUBSTR(C_No, 1, 1) = 'C'));


CREATE TABLE Parts( 
P_No VARCHAR2(4), 
Name VARCHAR2(20), 
Price NUMBER NOT NULL, 
Qty NUMBER, 
CONSTRAINT pt_pk PRIMARY KEY(P_No), 
CONSTRAINT pt_pno CHECK(SUBSTR(P_No, 1, 1) = 'P'), 
CONSTRAINT pt_qty CHECK(Qty > 0));


CREATE TABLE OrderDetails(  
O_No VARCHAR2(4),  
C_No VARCHAR2(4),  
E_No VARCHAR2(4),  
R_Date DATE,  
S_Date DATE,  
CONSTRAINT od_pk PRIMARY KEY(O_No),  
CONSTRAINT od_cno_fk FOREIGN KEY(C_No)  
REFERENCES Customer(C_No),  
CONSTRAINT od_eno_fk FOREIGN KEY(E_No) 
REFERENCES Employee(E_No),  
CONSTRAINT od_ono CHECK(SUBSTR(O_No, 1, 1) = 'O'),  
CONSTRAINT od_date CHECK(R_Date < S_Date));


CREATE TABLE OrderPurchase( 
O_No VARCHAR2(4), 
P_No VARCHAR2(4), 
Qty NUMBER, 
CONSTRAINT op_pk PRIMARY KEY(O_No, P_No), 
CONSTRAINT op_ono_fk FOREIGN KEY(O_No) 
REFERENCES OrderDetails(O_No), 
CONSTRAINT op_pno_fk FOREIGN KEY(P_No) 
REFERENCES Parts(P_No), 
CONSTRAINT op_qty CHECK(Qty > 0));


INSERT INTO Employee
    VALUES ('E1','Vishal','14-feb-2002',600004);


INSERT INTO Customer
    VALUES ('C1','Dan','09-oct-1989','Some Street',600001,9483728140);


INSERT INTO Customer
    VALUES ('C2','John','29-jan-1992','T-Nagar',600017,9983134240);


INSERT INTO Parts
    VALUES ('P1','Wire',50,5);


INSERT INTO Parts
    VALUES ('P2','Battery',69,10);


INSERT INTO OrderDetails
VALUES ('O1','C1','E1','15-mar-2022','17-mar-2022');


INSERT INTO OrderDetails
VALUES ('O2','C2','E2','9-mar-2022','17-apr-2022');


INSERT INTO OrderPurchase
  VALUES ('O1','P1',5);
INSERT INTO OrderPurchase
  VALUES ('O1','P2',1);
INSERT INTO OrderPurchase
  VALUES ('O2','P2',10);
INSERT INTO OrderPurchase
  VALUES ('O2','P2',3);

ALTER TABLE Parts
  ADD Reorder_lvl int;

SELECT * FROM Parts;

ALTER TABLE Employee
  ADD Hire_date date;

SELECT * FROM Employee;

ALTER TABLE Customer
  MODIFY C_Name varchar(50);

DESC Customer;

ALTER TABLE Customer
  DROP COLUMN C_Dob;

DESC Customer;

ALTER TABLE Order_Details
    MODIFY R_date date NOT NULL;

DESC Order_Details;

ALTER TABLE Order_Purchase
DROP CONSTRAINT op_ono_fk;


ALTER TABLE Order_Purchase
CONSTRAINT op_ono_fk FOREIGN KEY(O_No) 
REFERENCES OrderDetails(O_No)
ON DELETE CASCADE;
