REM ***Q1: For the given receipt number, if there are no rows then display as 'No order with the given receipt <number>'. If the receipt contains more than one item, display as
REM 'The given receipt <number> contains more than one item'. If the receipt contains single item, display as 'The given receipt <number> contains exactly one item'. Use
REM predefined exception handling.***

DECLARE
    ct NUMBER;
    rno_in NUMBER(8);
  BEGIN
    rno_in := '&rno';
    SELECT rno INTO ct FROM item_list WHERE rno_in = rno;
    DBMS_OUTPUT.PUT_LINE('1 ORDERS FOUND FOR ' || rno_in || '!!!');
  EXCEPTION
    WHEN no_data_found THEN
      DBMS_OUTPUT.PUT_LINE('0 ORDERS FOUND FOR ' || rno_in || '!!!');
    WHEN too_many_rows THEN
      DBMS_OUTPUT.PUT_LINE('>1 ORDERS FOUND FOR ' || rno_in || '!!!');
  END;

  DECLARE
    ct NUMBER;
    rno_in NUMBER(8);
  BEGIN
    rno_in := '&rno';
    SELECT rno INTO ct FROM item_list WHERE rno_in = rno;
    DBMS_OUTPUT.PUT_LINE('1 ORDERS FOUND FOR ' || rno_in || '!!!');
  EXCEPTION
    WHEN no_data_found THEN
      DBMS_OUTPUT.PUT_LINE('0 ORDERS FOUND FOR ' || rno_in || '!!!');
    WHEN too_many_rows THEN
      DBMS_OUTPUT.PUT_LINE('>1 ORDERS FOUND FOR ' || rno_in || '!!!');
  END;

  DECLARE
    ct NUMBER;
    rno_in NUMBER(8);
  BEGIN
    rno_in := '&rno';
    SELECT rno INTO ct FROM item_list WHERE rno_in = rno;
    DBMS_OUTPUT.PUT_LINE('1 ORDERS FOUND FOR ' || rno_in || '!!!');
  EXCEPTION
    WHEN no_data_found THEN
      DBMS_OUTPUT.PUT_LINE('0 ORDERS FOUND FOR ' || rno_in || '!!!');
    WHEN too_many_rows THEN
      DBMS_OUTPUT.PUT_LINE('>1 ORDERS FOUND FOR ' || rno_in || '!!!');
 END;

REM ***Q2: While inserting the receipt details, raise an exception when the receipt date is greater than the current date.***
CREATE OR REPLACE TRIGGER check_date
  BEFORE INSERT ON receipts
  FOR EACH ROW
  DECLARE
      today DATE;
      E2 EXCEPTION;
  BEGIN
      SELECT CURRENT_DATE INTO today FROM DUAL;
      IF :NEW.rdate > today THEN
          RAISE E2;
      END IF;
  EXCEPTION
      WHEN E2 THEN
          RAISE_APPLICATION_ERROR(-20021,'RDATE CANNOT EXCEED CURRENT DATE!!!');
  END;

INSERT INTO receipts VALUES(12345, '1-JUL-2022', 1);
INSERT INTO receipts VALUES(12345, '1-JUL-2022', 1)
