create DATABASE Restaurant_Management_System
USE Restaurant_Management_System


CREATE TABLE Customer(

	customer_id INT IDENTITY(1,1) PRIMARY KEY,
	customer_name VARCHAR(255) NOT NULL,
	customer_type VARCHAR(255) NOT NULL,
	customer_address VARCHAR(255) DEFAULT 'NULL',
	contact_no INT NOT NULL
);

create table Manager(

	manager_id INT  PRIMARY key,
	name varchar(255) not null,
	email varchar(255) not null,
	contact_no int not null,
	shift_start TIME NOT NULL,
	shift_end TIME NOT NULL,
	salary int default '80000',
	CHECK (manager_id >=1 AND manager_id <=100)
);

create table waiter(

	waiter_id int primary key,
	CHECK (waiter_id >=1 AND waiter_id <1000),
	name varchar(255) not null,
	contact_no int not null,
	shift_start TIME NOT NULL,
	shift_end TIME NOT NULL,
	salary int default '25000'
);	
DROP TABLE dbo.waiter
create table chef(

	chef_id int primary key,
	CHECK (chef_id >=1 AND chef_id <=1000),
	name varchar(255) not null,
	contact_no int not null,
	shift_start TIME NOT NULL,
	shift_end TIME NOT NULL,
	salary int default '50000',
	
);
DROP TABLE chef
create table rider(

	rider_id int primary key,
	CHECK (rider_id >=1 AND rider_id <=1000),
	name varchar(255) not null,
	contact_no int not null,
	shift_start TIME NOT NULL,
	shift_end TIME NOT NULL,
	salary int not null default '20000',
	
);
DROP TABLE chef
DROP TABLE rider

create table Items(

	item_id int  IDENTITY(1,1) PRIMARY key,
	item_name varchar(255) not null,
	item_quantity int NOT null ,
	CHECK (item_id >=0 AND item_id <=1000)

);
CREATE TABLE item_price(

	 price_id INT IDENTITY(1,1) PRIMARY KEY,
     item_Id INT FOREIGN KEY REFERENCES Items(item_id) NOT null,
	 price int  NOT null,
	 CHECK (price >0),
	 price_date date NOT null
);
CREATE TABLE Customer_order(

	customer_id INT FOREIGN KEY REFERENCES dbo.customer(customer_id),
	customer_name VARCHAR(255) NOT NULL,
	item_id INT FOREIGN KEY REFERENCES dbo.Items(item_id),
	price_id INT FOREIGN KEY  REFERENCES dbo.item_price(price_id),
	item_quantity INT NOT NULL,
	Order_time DATETIME NOT NULL

);

create table reservation(

	reservation_id INT IDENTITY(1,1),
	customer_name VARCHAR(255),
	customer_contact INT NOT NULL,
	table_no INT UNIQUE,
	date_time DATETIME
);
CREATE TABLE employee(

	managerid INT FOREIGN KEY REFERENCES dbo.Manager(manager_id),
	waiterid INT FOREIGN KEY REFERENCES dbo.waiter(waiter_id),
	riderid INT FOREIGN KEY REFERENCES dbo.rider(rider_id),
	chefid INT FOREIGN KEY REFERENCES dbo.chef(chef_id),
	employee_type VARCHAR(255),
	employye_salary INT

);


select * from customer
select * from Manager
select * FROM chef
select * from waiter
select * from rider
select * from Items
select * from item_price
select * from Customer_order
select * from reservation



-- creating trigger deleted reservation

CREATE TABLE cancelled_reservation(
	
	reservation_id INT ,
	customer_name VARCHAR(255),
	custome_contact INT,
	datetime DATETIME

	);

DROP TABLE dbo.cancelled_reservation

CREATE TRIGGER delete_reservation
ON reservation
AFTER delete
AS 
BEGIN

	 SET NOCOUNT ON
	 DECLARE @id INT , @name VARCHAR(255), @contact INT, @table_no int ,@dateTime Datetime

	 SELECT @id= i.reservation_id FROM deleted AS i
	 SELECT @name=i.customer_name FROM deleted AS i
	 SELECT @contact= i.customer_contact FROM deleted AS i
	 SELECT @dateTime =GETDATE()

	 INSERT INTO dbo.cancelled_reservation VALUES(@id,@name,@contact,@dateTime)

END


DELETE dbo.reservation
WHERE customer_name='Billy544'

SELECT * FROM dbo.reservation
SELECT * FROM dbo.cancelled_reservation

DROP TABLE dbo.cancelled_reservation

SELECT * FROM dbo.reservation
SELECT * FROM dbo.active_reservation
DROP TABLE dbo.active_reservation

--update salary trigger

CREATE TABLE chef_salary_audit(
	
	chef_id INT,
	chef_name VARCHAR(255),
	contact INT,
	salary INT ,
	);

DROP TABLE dbo.chef_salary_audit

CREATE TRIGGER update_salary
ON chef
FOR UPDATE
AS 
BEGIN
	SET NOCOUNT on

	DECLARE @chef_id INT , @chef_name VARCHAR(255), @contact INT , @salary INT
    
	SELECT @chef_id= i.chef_id FROM inserted AS i
	SELECT @chef_name= i.name FROM inserted AS i
	SELECT @contact= i.contact_no FROM inserted AS i
	SELECT @salary= i.salary FROM deleted AS i

	INSERT INTO chef_salary_audit VALUES(@chef_id, @chef_name,@contact,@salary)
END 



INSERT INTO chef VALUES(202,'abc',13231313,'12/2/2021','11/4/2022',50000)

SELECT * FROM chef
SELECT * FROM dbo.chef_salary_audit

DROP TABLE dbo.chef_salary_audit
--creating trigger for waiter delete

CREATE TABLE waiter_left(
	
	waiter_id int,
	waiter_name varchar(255) ,
	contact_no int,
	shift_start TIME,
	shift_end TIME ,
	salary INT,

	);

	DROP TABLE waiter_left

	CREATE TRIGGER delete_waiter
	ON waiter
	FOR DELETE
    AS 
	BEGIN
		
		SET NOCOUNT ON
		 DECLARE @id INT, @name VARCHAR(255), @contact INT , @shift_start_time time , @shift_end_time time,@salary INT
         
		 SELECT @id=i.waiter_id FROM deleted AS i
		 SELECT @name=i.name FROM deleted AS i
		 SELECT @contact =i.contact_no FROM deleted AS i
		 SELECT @shift_start_time=i.shift_start FROM deleted AS i
		 SELECT @shift_end_time=i.shift_end FROM deleted AS i
		 SELECT @salary=i.salary FROM deleted AS i

		 INSERT INTO waiter_left VALUES(@id,@name,@contact,@shift_start_time,@shift_end_time,@salary)

		END


INSERT INTO waiter VALUES(199,'arer',1323313,'9/4/2020','11/2/2022',25000)


DROP TABLE dbo.waiter_left
SELECT * FROM dbo.waiter
SELECT * FROM dbo.waiter_left



UPDATE item_price 
SET price=2750 WHERE item_id=27

SELECT * FROM dbo.item_price_history
SELECT * FROM dbo.item_price

DELETE FROM dbo.Items
WHERE item_name='Patty burger'

SELECT * FROM dbo.Items
SELECT * FROM dbo.items_deleted


DELETE dbo.reservation 
WHERE reservation_id=1

SELECT * FROM dbo.cancelled_reservation
SELECT * FROM dbo.reservation



--Procedure 1
CREATE PROCEDURE no_of_customers
AS
SELECT COUNT(customer_name) FROM dbo.Customer_order WHERE Order_time BETWEEN '2022-01-01' AND '2022-12-12' 
GO
EXEC no_of_customers
DROP PROCEDURE no_of_customers


--procedure 2

CREATE PROCEDURE count_customer_type
@customer_type varchar(255)
AS
begin
SELECT count (customer_type) FROM customer WHERE customer_type=@customer_type
end
GO
EXEC count_customer_type 'reservation customer'
DROP PROCEDURE count_customer_type


--procedure 3

CREATE PROCEDURE incrementSalary_manager @incrementPercent FLOAT
AS
BEGIN 
UPDATE dbo.Manager SET salary = salary + (salary * @incrementPercent) WHERE manager_id = 3
END
EXEC incrementSalary_manager @incrementPercent = 0.10

DROP PROCEDURE incrementSalary_manager
SELECT * FROM dbo.Manager;

--procedure 4

CREATE PROCEDURE COUNT_employee
AS
BEGIN
SELECT  COUNT(waiter_id) FROM waiter
END

EXEC count_employee
DROP PROCEDURE count_employee
 
 --insert for reservation trigger
INSERT INTO dbo.reservation
VALUES('abdullah',12324124,99,112/7/2021)


--update chef update trigger
UPDATE dbo.chef
SET salary=31000 WHERE chef_id=202


--delete waiter left trigger
DELETE dbo.waiter WHERE waiter_id=199

SELECT customer.customer_name FROM dbo.Customer INNER JOIN dbo.Customer_order ON dbo.Customer_order.customer_id =customer.customer_id;

SELECT dbo.waiter.name , rider.name FROM waiter LEFT JOIN rider ON waiter.name=rider.name;

SELECT dbo.waiter.name , rider.name FROM waiter right JOIN rider ON waiter.name=rider.name;

SELECT dbo.waiter.name , rider.name FROM waiter FULL outer JOIN rider ON waiter.name=rider.name;

SELECT waiter.name FROM waiter UNION  SELECT rider.name FROM rider

SELECT  COUNT(item_quantity), item_name FROM dbo.items GROUP BY item_name HAVING COUNT(item_quantity)> 2

CREATE VIEW [customer view] 
AS SELECT customer_name , customer_id FROM dbo.Customer WHERE customer_id<9

SELECT * FROM [customer view]

CREATE INDEX rider_detail ON rider (rider_id,name,contact_no)

SELECT * FROM  rider_detail