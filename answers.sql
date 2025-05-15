

SELECT 
  OrderID,
  CustomerName,
  TRIM(product) AS Product
FROM 
  ProductDetail,
  JSON_TABLE(
    JSON_ARRAYAGG(JSON_QUOTE(REPLACE(Products, ', ', '","'))),
    "$[*]" COLUMNS(product VARCHAR(100) PATH "$")
  ) AS products_split;

QUESTION 2:
-- Step 1: Create the Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Step 2: Insert distinct orders into Orders table
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 3: Create the OrderItems table
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 4: Insert data into OrderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
