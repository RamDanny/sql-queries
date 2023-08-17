REM ***Q1: The combination of Flavor and Food determines the product id. Hence, while inserting a new instance into the Products relation, ensure that the same combination of Flavor and Food is not already available.***

  CREATE OR REPLACE TRIGGER check_already
  BEFORE INSERT ON products
  FOR EACH ROW
  DECLARE
    ct number;
  BEGIN
    SELECT COUNT(*) INTO ct
    FROM products p
    WHERE :NEW.flavor = p.flavor AND :NEW.food = p.food;
    IF ct > 0 THEN
      RAISE_APPLICATION_ERROR(-20011, 'FOOD AND FLAVOR ALREADY EXIST!!!');
    END IF;
  END;

INSERT INTO products VALUES('20-CHOC-CAKE-10', 'Chocolate', 'Cake', 10);
INSERT INTO products VALUES('20-CHOC-CAKE-10', 'Chocolate', 'Cake', 10)

REM ***Q2: While entering an item into the item_list relation, update the amount in Receipts with the total amount for that receipt number.***
CREATE OR REPLACE TRIGGER update_amt
  AFTER INSERT ON item_list
  FOR EACH ROW
  DECLARE
    newamt number;
  BEGIN
    SELECT price INTO newamt FROM products WHERE :NEW.item = pid;
    UPDATE receipts SET amt = amt + newamt WHERE :NEW.rno = rno;
  END;

INSERT INTO receipts VALUES(12346, '27-MAY-2022', 20, 0);

INSERT INTO item_list VALUES(12346, 1, '20-BC-C-10');

INSERT INTO item_list VALUES(12346, 2, '25-STR-9');

REM ***Q3: Implement the following constraints for Item_list relation:
REM a. A receipt can contain a maximum of five items only.
REM b. A receipt should not allow an item to be purchased more than thrice.***
CREATE OR REPLACE TRIGGER check_item_list
  BEFORE INSERT ON item_list
  FOR EACH ROW
  DECLARE
    ct number;
  BEGIN
    SELECT COUNT(*) INTO ct FROM item_list WHERE rno = :NEW.rno;
    IF ct >= 5 THEN
      RAISE_APPLICATION_ERROR(-20032, 'RECEIPT CAN HAVE MAX 5 ITEMS!!!');
    END IF;
    SELECT COUNT(*) INTO ct FROM item_list WHERE rno = :NEW.rno AND item = :NEW.item;
    IF ct >= 3 THEN
      RAISE_APPLICATION_ERROR(-20031, 'ITEM CAN BE PURCHASED MAX THRICE PER ORDER!!!');
    END IF;
  END;

INSERT INTO item_list VALUES(18129, 2, '70-TU');

INSERT INTO item_list VALUES(18129, 3, '70-TU');

INSERT INTO item_list VALUES(18129, 4, '70-TU');
INSERT INTO item_list VALUES(18129, 4, '70-TU')

INSERT INTO ITEM_LIST VALUES(55944, 6, '50-CHS');
INSERT INTO ITEM_LIST VALUES(55944, 6, '50-CHS')
