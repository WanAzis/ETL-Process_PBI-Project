-- Create Table DWH_Project
CREATE TABLE DimCustomer (
	CustomerID INT,
	CustomerName VARCHAR(50) NOT NULL,
	Age INT NOT NULL,
	Gender VARCHAR(50) NOT NULL,
	City VARCHAR(50) NOT NULL,
	NoHP VARCHAR(50) NOT NULL,
	CONSTRAINT PK_DimCustomer PRIMARY KEY (CustomerID)
);

CREATE TABLE DimProduct (
	ProductID INT,
	ProductName VARCHAR(255) NOT NULL,
	ProductCategory VARCHAR(255) NOT NULL,
	ProductUnitPrice INT,
	CONSTRAINT PK_DimProduct PRIMARY KEY (ProductID)
);

CREATE TABLE DimStatusOrder (
	StatusID INT,
	StatusOrder VARCHAR(50) NOT NULL,
	StatusOrderDesc VARCHAR(50) NOT NULL,
	CONSTRAINT PK_DimStatusOrder PRIMARY KEY (StatusID)
);

CREATE TABLE FactSalesOrder (
	OrderID INT,
	CustomerID INT NOT NULL,
	ProductID INT NOT NULL,
	Quantity INT NOT NULL, 
	Amount INT NOT NULL,
	StatusID INT NOT NULL,
	OrderDate DATE NOT NULL,
	CONSTRAINT PK_FactSalesOrder PRIMARY KEY (OrderID),
	CONSTRAINT FK_CustomerOrder FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID),
	CONSTRAINT FK_ProductOrder FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductID),
	CONSTRAINT FK_StatusOrder FOREIGN KEY (StatusID) REFERENCES DimStatusOrder(StatusID)
);

-- PBI_Staging
SELECT * FROM customer;
SELECT * FROM product;
SELECT * FROM status_order;
SELECT * FROM sales_order;

-- DWH_Project
SELECT * FROM DimCustomer;
SELECT * FROM DimProduct;
SELECT * FROM DimStatusOrder;
SELECT * FROM FactSalesOrder;

-- Stored_Procedure
CREATE PROCEDURE summary_order_status
	@StatusID INT  --filter param
AS
BEGIN
	SELECT 
		OrderID,
		CustomerName,
		ProductName,
		Quantity,
		StatusOrder
	FROM FactSalesOrder fact
		JOIN DimCustomer cust ON fact.CustomerID=cust.CustomerID
		JOIN DimProduct prd ON fact.ProductID=prd.ProductID
		JOIN DimStatusOrder stat ON fact.StatusID=stat.StatusID
	WHERE fact.StatusID=@StatusID
END;

EXEC summary_order_status @StatusID=4;