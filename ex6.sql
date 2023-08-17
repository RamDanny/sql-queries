REM ***Q1 For the given receipt number, calculate the Discount as follows:
REM For total amount > $10 and total amount < $25: Discount=5%
REM For total amount > $25 and total amount < $50: Discount=10%
REM For total amount > $50: Discount=20%
REM Calculate the amount (after the discount) and update the same in Receipts table.***
CREATE OR REPLACE PROCEDURE disccalc
  (rn IN receipts.rno%type) IS
    fname_c customers.fname%type;
    lname_c customers.lname%type;
    rdate_c receipts.rdate%type;
    total_amount number:=0;
    sno number:=0;
    disc number(2);
   disc_amount number;
    final_amount real;
    cursor c1 is
      SELECT food,flavor,price
      FROM item_list,products
      WHERE rno=rn and pid=item;
    record c1%rowtype;
  begin
    SELECT fname,lname,rdate into fname_c,lname_c,rdate_c
    FROM customers,receipts
    WHERE customers.cid=receipts.cid and receipts.rno=rn;
    dbms_output.put_line('************************************************************');
    dbms_output.put_line('Receipt Number :'||rn);
    dbms_output.put_line('Customer name :'||fname_c||' '||lname_c);
    dbms_output.put_line('Receipt date :'||rdate_c);
    dbms_output.put_line('************************************************************');
    open c1;
    dbms_output.put_line('Sno       Flavor       Food       Price');
    loop
      fetch c1 into record;
      if c1%notfound then
        exit;
      else
        sno:=sno+1;
        dbms_output.put_line(sno||'.      '||record.flavor||'      '||record.food||'      '||record.price);
        total_amount:=total_amount+record.price;
      end if;
    end loop;
    dbms_output.put_line(' ');
    dbms_output.put_line('   Total = $'||total_amount);
    dbms_output.put_line(' ');
    dbms_output.put_line('Total Amount  :$ '||total_amount);
    if (total_amount>10 and total_amount<=25) then
      disc:=5;
    elsif (total_amount>25 and total_amount<=50) then
      disc:=10;
    elsif (total_amount>50) then
      disc:=20;
    else
      disc:=0;
    end if;
    discount_amount:=total_amount*disc*0.01;
    dbms_output.put_line('Discount('||disc||'%)  :$ '||discount_amount);
    dbms_output.put_line(' ');
   final_amount:=total_amount-discount_amount;
    dbms_output.put_line('Amount to be paid :$ '||final_amount);
    dbms_output.put_line('************************************************************');
   dbms_output.put_line('Great Offers! Discount up to 25% on DIWALI Festival Day...');
    dbms_output.put_line('************************************************************');
    close c1;
    exception
      when no_data_found then
        dbms_output.put_line('Invalid order number');
  end;

declare
rn receipts.rno%type;
begin
rn:=&rno;
disccalc(rn);
end;

REM *******************************************************************************************

REM ***Q2
REM Ask the user for the budget and his/her preferred food type. You recommend the best
REM item(s) within the planned budget for the given food type. The best item is
REM determined by the maximum ordered product among many customers for the given
REM food type.***


CREATE OR REPLACE PROCEDURE recom(foodtype in products.food%type,budget in products.price%type)
IS 
   no_of_item int;
   maxPID products.pid%type;
   maxFlavor products.flavor%type;
   CURSOR ptr is SELECT p.pid as pid,p.flavor as flavor ,p.food as food,p.price as price FROM products p 
          WHERE p.pid in (SELECT p1.pid FROM products p1 inner join item_list i on (p1.pid=i.item));
   record ptr%rowtype;
   CURSOR ptr1 is  SELECT pid,flavor,price FROM products WHERE pid in (
     SELECT item FROM item_list  
     WHERE item IN (SELECT pid FROM products WHERE food=foodtype)
     GROUP BY item 
     HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM (SELECT * FROM item_list WHERE item IN (SELECT pid FROM products WHERE food=foodtype) ) group by item)); 
   record1 ptr1%rowtype;
  BEGIN
    
   dbms_output.put_line('***************************************************');
   dbms_output.put_line('Budget: '|| budget || ' Food type: '|| foodtype);
   dbms_output.put_line('***************************************************');
   dbms_output.put_line('Item ID         Flavor         Food         Price ');
   open ptr;
   loop
    fetch ptr into record;
    IF (ptr%notfound) THEN
     exit;
    ELSIF(ptr%found and record.price<=budget and record.food=foodtype) THEN
     dbms_output.put_line(record.pid||'    '||record.flavor||'   '||record.food ||'    '||record.price);  
     
    END IF;
   END LOOP;
   open ptr1;
   fetch ptr1 into record1;
   maxPID:= record1.pid;
   maxFlavor:= record1.flavor ;
   no_of_item := budget/record1.price;
   dbms_output.put_line(maxPId ||' with '|| maxFlavor||'flavor is the best item in '|| foodtype||'!');
   dbms_output.put_line('You are entitled to purchase '|| no_of_item ||' '|| foodtype || ' ' || maxFlavor || 'for the given budget !!!');
   dbms_output.put_line('***************************************************');
  END;

DECLARE 
   foodtype products.food%type;
   budget number(3);
  BEGIN
   foodtype:='&foodtype';
   budget:=&budget;
   recom(foodtype,budget);
  END;

DECLARE 
   foodtype products.food%type;
   budget number(3);
  BEGIN
   foodtype:='&foodtype';
   budget:=&budget;
   recom(foodtype,budget);
  END;

REM *******************************************************************************************


REM ***Q3: Take a receipt number and item as arguments, and insert this information into the
REM Item list. However, if there is already a receipt with that receipt number, then keep
REM adding 1 to the maximum ordinal number. Else before inserting into the Item list
REM with ordinal as 1, ask the user to give the customer name who placed the order and
REM insert this information into the Receipts.***


CREATE OR REPLACE PROCEDURE insertreceipts(rec IN receipts.rno%type, rdt IN receipts.rdate%type,
  rcid IN receipts.cid%type) IS
  BEGIN
   insert into receipts values(rec,rdt,rcid);
  END;

CREATE OR REPLACE PROCEDURE insertitem(rno IN receipts.rno%type, ordinal IN item_list.ordinal%t
ype,
  prodid IN item_list.item%type) IS
  BEGIN
   delete FROM item_list i WHERE i.rno=rno and i.item=prodid; 
   insert into item_list values(rno,ordinal,prodid);
  END;


CREATE OR REPLACE PROCEDURE findcid(cfname IN customers.fname%type, clname IN customers.lname%type,
  fcid OUT customers.cid%type) is
  BEGIN 
   SELECT c.cid into fcid
   FROM customers c
   WHERE c.fname=cfname and c.lname=clname;
  EXCEPTION
    WHEN no_data_found then
   DBMS_OUTPUT.PUT_LINE('Customer ID not found');
  
  fcid :=0;
  END;

DECLARE
  cfname customers.fname%type;
  clname customers.lname%type;
  fcid customers.cid%type;
  rec receipts.rno%type;
  ordi item_list.ordinal%type;
  prodid products.pid%type;
  rdt receipts.rdate%type;
  item_row item_list%rowtype;
  CURSOR c1 is SELECT * FROM item_list i
        WHERE i.rno = rec order by i.ordinal desc;
  maxordi item_list.ordinal%type;
  BEGIN
   rec :=&RECEIPT;
   prodid := '&product';
   open c1;
   fetch c1 into item_row;
   if (c1%rowcount>0) then
    begin
     dbms_output.put_line('the receipt number is present');
     ordi:= item_row.ordinal + 1;
     insertitem(rec,ordi,prodid);
     return;
    end;
   else
    begin
     dbms_output.put_line('Receipt number not found!!!');
     dbms_output.put_line('CREATE A RECEIPT: ');
     cfname := '&firstname';
     clname := '&lastname';
     rdt := '&date';
     findcid(cfname,clname,fcid);
    insertreceipts(rec,rdt,fcid);
     ordi := 1;
     insertitem(rec,ordi,prodid);
     return;
    end;
   end if;
  END;

DECLARE
  cfname customers.fname%type;
  clname customers.lname%type;
  fcid customers.cid%type;
  rec receipts.rno%type;
  ordi item_list.ordinal%type;
  prodid products.pid%type;
  rdt receipts.rdate%type;
  item_row item_list%rowtype;
  CURSOR c1 is SELECT * FROM item_list i
        WHERE i.rno = rec order by i.ordinal desc;
  maxordi item_list.ordinal%type;
  BEGIN
   rec :=&RECEIPT;
   prodid := '&product';
   open c1;
   fetch c1 into item_row;
   if (c1%rowcount>0) then
    begin
     dbms_output.put_line('the receipt number is present');
     ordi:= item_row.ordinal + 1;
     insertitem(rec,ordi,prodid);
     return;
    end;
   else
    begin
     dbms_output.put_line('Receipt number not found!!!');
     dbms_output.put_line('CREATE A RECEIPT: ');
     cfname := '&firstname';
     clname := '&lastname';
     rdt := '&date';
3     findcid(cfname,clname,fcid);
4     insertreceipts(rec,rdt,fcid);
     ordi := 1;
     insertitem(rec,ordi,prodid);
     return;
    end;
   end if;
  END;

SELECT * FROM item_list WHERE rno = 70796; 

DECLARE
  cfname customers.fname%type;
  clname customers.lname%type;
  fcid customers.cid%type;
  rec receipts.rno%type;
  ordi item_list.ordinal%type;
  prodid products.pid%type;
  rdt receipts.rdate%type;
  item_row item_list%rowtype;
  CURSOR c1 is SELECT * FROM item_list i
        WHERE i.rno = rec order by i.ordinal desc;
  maxordi item_list.ordinal%type;
  BEGIN
   rec :=&RECEIPT;
   prodid := '&product';
   open c1;
   fetch c1 into item_row;
   if (c1%rowcount>0) then
    begin
     dbms_output.put_line('the receipt number is present');
     ordi:= item_row.ordinal + 1;
     insertitem(rec,ordi,prodid);
     return;
    end;
   else
    begin
     dbms_output.put_line('Receipt number not found!!!');
     dbms_output.put_line('CREATE A RECEIPT: ');
     cfname := '&firstname';
     clname := '&lastname';
     rdt := '&date';
     findcid(cfname,clname,fcid);
     insertreceipts(rec,rdt,fcid);
     ordi := 1;
     insertitem(rec,ordi,prodid);
     return;
    end;
   end if;
  END;

REM *******************************************************************************************


REM ***Q4: Write a stored function to display the customer name who ordered maximum for the
REM given food and flavor.***

CREATE OR REPLACE FUNCTION maxcustomer(p IN products.pid%type) return varchar2 as
  c customers.cid%type;
  m int;
  n1 customers.fname%type;
  n2 customers.lname%type;
  name varchar2(40);
  BEGIN 
   SELECT max(count(*)) into m FROM receipts r inner join item_list i on (i.rno=r.rno)
   WHERE i.item = p
   group by r.cid;
   SELECT r.cid into c FROM receipts r join item_list i on (i.rno=r.rno)
   WHERE i.item = p
   group by r.cid
   having count(*) = m;
   
   SELECT c1.fname into n1 FROM customers c1 WHERE c1.cid=c;
   SELECT c1.lname into n2 FROM customers c1 WHERE c1.cid=c;
   
   name := n1|| n2;
   return name;
  END maxcustomer;

DECLARE
   name varchar2(40);
   p products.pid%type;
   fo products.food%type;
   fl products.flavor%type;
  BEGIN 
   fo:='&food';
   fl:='&flavor';
   SELECT p1.pid into p FROM products p1 WHERE p1.food = fo and p1.flavor =fl;
   name:=maxcustomer(p);
   dbms_output.put_line('Name: '|| name);
  END;

SELECT fname,lname FROM customers WHERE cid = (
  SELECT r.cid  FROM receipts r join item_list i on (i.rno=r.rno)
   WHERE i.item = '51-APR' and cid = 14 
   group by r.cid
   having count(*) = (SELECT max(count(*)) FROM receipts r inner join item_list i on (i.rno=r.rno)
   WHERE i.item = '51-APR'
   group by r.cid));


REM *******************************************************************************************


REM Implement Question (2) using stored function to return the amount to be paid and
REM update the same, for the given receipt number.


CREATE or REPLACE function discountamt(cp IN products.price%type, dis OUT products.price%type, 
dp OUT products.price%type) return products.price%type is
   sp products.price%type;
   begin
    dis:=0;
    dp:=0;
    if cp>0 and cp<25 then
     dis:=(5*cp)/100.00;
     dp:=5;
    else
     if cp>25 and cp<50 then
      dis:= (10*cp)/100.00;
      dp:=10;
     else
      if cp>50 then
       dis := (20*cp)/100.00;
       dp := 20;
      end if;
     end if;
    end if;
    sp := cp-dis;
    return sp;
   end;

declare
   sel receipts.rno%type;
   billdate receipts.rdate%type;
   custlname customers.lname%type;
   custfname customers.fname%type;
   cursor c1 is SELECT p.food, p.flavor, sum(p.price) 
         FROM products p join item_list i on i.item = p.pid
         WHERE i.rno = sel
         group by p.food,p.flavor;
   cp products.price%type;
   d products.price%type;
   dp products.price%type;
   sp products.price%type;
   counts integer;
   foodtype products.food%type;
   flavortype products.food%type;
   lprice products.price%type;
  begin
   sel := &receipt;
   SELECT sum(p.price) into cp FROM products p join item_list i on p.pid=i.item WHERE i.rno = sel;
   SELECT count(count(*)) into counts FROM products p join item_list i on p.pid = i.item
   WHERE i.rno = sel
   group by p.food, p.flavor;
   open c1;
   SELECT c.lname, c.fname, r.rdate into custlname, custfname, billdate FROM receipts r join customers c on c.cid = r.cid
   WHERE r.rno = sel;
  
   dbms_output.put_line('Customer name:'||custfname||' '||custlname);
   dbms_output.put_line('Receipt no:'||sel);
   dbms_output.put_line('Receipt date:'||billdate);
   dbms_output.put_line('-------------------------------------------------');
   dbms_output.put_line('RecNo Food     Flavor      Price');
   for a in 1..counts loop
    fetch c1 into foodtype,flavortype,lprice;
    dbms_output.put_line('    '||a||'     '||flavortype||'    '||foodtype||'     '||lprice);
   end loop;
   sp :=discountamt(cp,d,dp);
   dbms_output.put_line('---------------------------------------------------');
   dbms_output.put_line('Total = $'||cp);
   dbms_output.put_line('Discount ('||dp||'%) = $'||d);
   dbms_output.put_line('Grand total = $ '||sp);
   dbms_output.put_line('----------------------------------------------------');
   dbms_output.put_line('Upto 20% discount available!!!');
   dbms_output.put_line('----------------------------------------------------');
  end;
