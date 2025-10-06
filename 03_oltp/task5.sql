-- Customer's last 5 purchases with item count and paid amount
SELECT 
    c.CustomerID,
    yo.PurchaseDateTime,
    yo.PurchaseID,
    yo.itemCount,
    yo.priceSum
FROM Customers AS c
JOIN (
    SELECT 
        pur.CustomerID, 
        pur.PurchaseDateTime, 
        pur.PurchaseID, 
        item.Quantity AS itemCount, 
        item.Quantity*SUM(prod.Price) AS priceSum
    FROM Purchases AS pur
    JOIN Purchase_Items AS item ON item.PurchaseID = pur.PurchaseID
    JOIN Products AS prod ON prod.ProductID = item.ProductID
    GROUP BY pur.CustomerID, pur.PurchaseID, pur.PurchaseDateTime, item.Quantity
    having count(*) <= 5
    ORDER BY pur.PurchaseDateTime DESC
) AS yo
ON yo.CustomerID = c.CustomerID
ORDER BY c.CustomerID;


-- Revenue & transaction count per store in a date range
SELECT s.StoreID, s.StoreName, count(pur.PurchaseID) as transactionCount, sum(pay.Amount) as revenue 
FROM Stores as s
JOIN Purchases as pur ON pur.StoreID = s.StoreID
JOIN Payments as pay ON pay.PurchaseID = pur.PurchaseID
GROUP BY s.StoreID 

-- Top 5 products by revenue in the last N days
SELECT prod.ProductName, sum(purI.Quantity*prod.Price) as revenue
FROM Products as prod
JOIN Purchase_Items as purI ON purI.ProductID = prod.ProductID
JOIN Purchases as pur ON purI.PurchaseID = pur.PurchaseID
JOIN Payments as pay ON pay.PurchaseID = pur.PurchaseID
WHERE pur.PurchaseDateTime >= NOW() - INTERVAL '10 days'
GROUP BY prod.ProductID
ORDER BY revenue DESC
LIMIT 5

-- Suppliers for a given product (comma-separated)
SELECT prod.ProductName, STRING_AGG(sup.SupplierName, ', ') AS Suppliers
FROM Suppliers as sup
JOIN Product_Suppliers as ps ON ps.SupplierID = sup.SupplierID
JOIN Products as prod ON prod.ProductID = ps.ProductID
GROUP BY prod.ProductName

-- Monthly revenue by category and by store's location a. can you add the year-over-year growth
SELECT cat.CategoryName, store.Location, sum(prod.Price*pit.Quantity) as revenue, extract(MONTH FROM pur.PurchaseDateTime) as mth
FROM Categories as cat 
JOIN Products as prod ON prod.CategoryID = cat.CategoryID
JOIN Purchase_Items as pit ON pit.ProductID = prod.ProductID
JOIN Purchases as pur ON pur.PurchaseID = pit.PurchaseID
JOIN Stores as store ON store.StoreID = pur.StoreID
JOIN Payments as pay ON pay.PurchaseID = pur.PurchaseID
GROUP BY cat.CategoryName, store.Location, mth
