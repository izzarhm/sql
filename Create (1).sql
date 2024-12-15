

CREATE SCHEMA Restaurant;


CREATE TABLE Restaurant.Menu (
    Menu_ID SMALLINT NOT NULL PRIMARY KEY,
    Menu_Name VARCHAR(30),
    Menu_Price INT
);

CREATE TABLE Restaurant.Employee (
    Employee_ID VARCHAR(10) NOT NULL PRIMARY KEY,
    Position_ID VARCHAR(10) NOT NULL,
    Employee_Name VARCHAR(30),
    Phone_Number VARCHAR(15),
    FOREIGN KEY (Position_ID)
        REFERENCES Restaurant.Positions(Position_ID)
);

CREATE TABLE Restaurant.Positions (
    Position_ID VARCHAR(10) NOT NULL PRIMARY KEY,
    Position_Name VARCHAR(30),
      Salary INT
);



CREATE TABLE Restaurant.Customer (
    Customer_ID VARCHAR(10) NOT NULL PRIMARY KEY,
    Customer_Name VARCHAR(50),
    Address VARCHAR(100),
    Subdistrict VARCHAR(20),
    City VARCHAR(20),
    Province VARCHAR(20),
    Phone_Number VARCHAR(15)
);

CREATE TABLE Restaurant.Feedback (
    Feedback_ID VARCHAR(10) NOT NULL PRIMARY KEY,
    Customer_ID VARCHAR(10) NOT NULL,
    Rating INT,
    Description VARCHAR(100),
   FOREIGN KEY (Customer_ID)
        REFERENCES Restaurant.Customer(Customer_ID)
);

CREATE TABLE Restaurant.Receipt (
    Receipt_ID SMALLINT NOT NULL PRIMARY KEY,
    Employee_ID VARCHAR(10),
    Customer_ID VARCHAR(10),
    Total_Amount INT,
    Payment INT,
    Change_Amount INT,
    Date DATE,
    Time TIME,
    FOREIGN KEY (Employee_ID)
        REFERENCES Restaurant.Employee(Employee_ID),
    FOREIGN KEY (Customer_ID)
        REFERENCES Restaurant.Customer(Customer_ID)
);

CREATE TABLE Restaurant.Receipt_Details (
	
    Receipt_ID SMALLINT,
    Customer_ID VARCHAR(10),
    Menu_ID SMALLINT,
    Quantity SMALLINT,
    Total_Price INT,
    FOREIGN KEY (Receipt_ID)
        REFERENCES Restaurant.Receipt(Receipt_ID),
    FOREIGN KEY (Customer_ID)
        REFERENCES Restaurant.Customer(Customer_ID),
    FOREIGN KEY (Menu_ID)
        REFERENCES Restaurant.Menu(Menu_ID)
);



