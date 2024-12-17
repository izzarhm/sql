CREATE INDEX idx_total_amount ON RESTAURANT.receipt (total_amount);

CREATE VIEW RESTAURANT.view_custfeedback AS
SELECT
    c.customer_id,
    c.customer_name,
    f.feedback_id,
    f.rating
FROM
    RESTAURANT.customer c
JOIN
    RESTAURANT.feedback f
ON
    c.customer_id = f.customer_id;

CREATE PROCEDURE GETEMPLOYEE(IN IN_EMPLOYEE_NAME VARCHAR(30)) 
DYNAMIC RESULT SETS 1
BEGIN
    DECLARE cursor1 CURSOR WITH RETURN FOR
        SELECT * FROM RESTAURANT.EMPLOYEE WHERE EMPLOYEE_NAME = IN_EMPLOYEE_NAME;

    OPEN cursor1;
END

SELECT * FROM RESTAURANT.EMPLOYEE e ;
CALL GETEMPLOYEE('Andi Manager');

CREATE TRIGGER RESTAURANT.insert_custfeedback
INSTEAD OF INSERT ON RESTAURANT.view_cust
FOR EACH ROW
BEGIN
    -- Insert ke tabel customer jika belum ada
    INSERT INTO RESTAURANT.customer (customer_id, customer_name)
    VALUES (:NEW.customer_id, :NEW.customer_name);

    -- Insert ke tabel feedback
    INSERT INTO RESTAURANT.feedback (feedback_id, customer_id, rating)
    VALUES (:NEW.feedback_id, :NEW.customer_id, :NEW.rating);
END;

CREATE PROCEDURE MYPROCEDURE(IN IN_EMPLOYEE_NAME VARCHAR(30)) 
DYNAMIC RESULT SETS 1
BEGIN
    DECLARE cursor1 CURSOR WITH RETURN FOR
        SELECT EMPLOYEE_NAME FROM RESTAURANT.EMPLOYEE WHERE EMPLOYEE_NAME = IN_EMPLOYEE_NAME;

    OPEN cursor1;
END;

CREATE FUNCTION get_sales( IN_MONTH INT,  IN_YEAR INT)
RETURNS INTEGER
LANGUAGE SQL
BEGIN
    DECLARE sales INT;

    SET sales = (SELECT SUM(total_amount)
                FROM RESTAURANT.RECEIPT
                WHERE MONTH(DATE) = IN_MONTH
                AND YEAR(DATE) = IN_YEAR);

    RETURN sales;
END;

CREATE TRIGGER Restaurant.CustomerFeedbackInsertTrigger
INSTEAD OF INSERT
ON Restaurant.CustomerFeedbackView
REFERENCING NEW AS new_row
FOR EACH ROW
MODE DB2SQL
BEGIN ATOMIC
    -- Insert ke tabel Customer
    INSERT INTO Restaurant.Customer (Customer_ID, Customer_Name, Phone_Number)
    VALUES (new_row.Customer_ID, new_row.Customer_Name, new_row.Phone_Number);

    -- Insert ke tabel Feedback
    INSERT INTO Restaurant.Feedback (Feedback_ID, Customer_ID, Rating, Description)
    VALUES (new_row.Feedback_ID, new_row.Customer_ID, new_row.Rating, new_row.Description);
END;

INSERT INTO Restaurant.CustomerFeedbackView (
    Customer_ID, Customer_Name, Phone_Number, Feedback_ID, Rating, Description
)
VALUES (
    'CUST102', -- Customer_ID
    'Alice', -- Customer_Name
    '081298765432', -- Phone_Number
    'FB102', -- Feedback_ID
    5, -- Rating
    'Excellent service!' -- Description
);

CREATE VIEW Restaurant.CustomerFeedbackView
AS
SELECT
    c.Customer_ID,
    c.Customer_Name,
    c.Phone_Number,
    f.Feedback_ID,
    f.Rating,
    f.Description
FROM
    Restaurant.Customer c
LEFT JOIN
    Restaurant.Feedback f
ON
    c.Customer_ID = f.Customer_ID;
 
CREATE TRIGGER Restaurant.SetDefault_CustomerName
    NO CASCADE BEFORE INSERT ON Restaurant.Customer
    REFERENCING NEW AS n
    FOR EACH ROW
    MODE DB2SQL
    WHEN (n.Customer_Name IS NULL)
    BEGIN ATOMIC
        SET n.Customer_Name = 'NAMA';
    END;
    
    CREATE TRIGGER Restaurant.SetDefault_CustomerName
    NO CASCADE BEFORE INSERT ON Restaurant.Customer
    REFERENCING NEW AS n
    FOR EACH ROW
    MODE DB2SQL
    WHEN (n.Customer_Name IS NULL)
    BEGIN ATOMIC
        SET n.Customer_Name = 'NAMA';
    END;

   
INSERT INTO Restaurant.Customer (Customer_ID, Customer_Name, Address, Phone_Number)
VALUES ('CUST001', NULL, '123 Main St', '123456789');

CREATE FUNCTION get_sales_total( IN_MONTH INT,  IN_YEAR INT)
RETURNS INTEGER
LANGUAGE SQL
BEGIN
    DECLARE sales INT;

    SET sales = (SELECT SUM(total_amount) FROM RESTAURANT.RECEIPT WHERE MONTH(DATE) = IN_MONTH AND YEAR(DATE) = IN_YEAR);

    RETURN sales;
END;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Restaurant.Menu TO ROLE Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Restaurant.Employee TO ROLE Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Restaurant.Positions TO ROLE Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Restaurant.Customer TO ROLE Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Restaurant.Feedback TO ROLE Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Restaurant.Receipt TO ROLE Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Restaurant.Receipt_Details TO ROLE Manager;

CREATE MASK MenuPriceMask 
    ON Restaurant.Menu 
    FOR COLUMN Menu_Price RETURN 
    CASE
	    WHEN verify_role_for_user(SESSION_USER, 'MANAGER') = 1
	    	THEN Menu_Price
            	ELSE 0.00
        		END
    
ENABLE;

alter table Restaurant.MENU activate column access control;



CREATE VIEW Restaurant.MenuPriceViewAgain AS
SELECT 
    MENU_NAME, MENU_ID,
    CASE 
        WHEN VERIFY_ROLE_FOR_USER(SESSION_USER, 'CUSTOMER') = 1 THEN MENU_PRICE
        ELSE 0 
    END AS MENU_PRICE
FROM Restaurant.Menu;

GRANT SELECT ON Restaurant.MenuPriceViewAgain TO PUBLIC;