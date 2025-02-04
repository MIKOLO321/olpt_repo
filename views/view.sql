CREATE VIEW Website.Suppliers AS
SELECT s.SupplierID,
       s.SupplierName,
       sc.SupplierCategoryName,
       pp.FullName AS PrimaryContact,
       ap.FullName AS AlternateContact,
       s.PhoneNumber,
       s.FaxNumber,
       s.WebsiteURL,
       dm.DeliveryMethodName AS DeliveryMethod,
       c.CityName,  -- Alias not strictly necessary if column name is the same
       s.DeliveryLocation,
       s.SupplierReference
FROM Purchasing.Suppliers AS s
LEFT OUTER JOIN Purchasing.SupplierCategories AS sc ON s.SupplierCategoryID = sc.SupplierCategoryID
LEFT OUTER JOIN Application.People AS pp ON s.PrimaryContactPersonID = pp.PersonID
LEFT OUTER JOIN Application.People AS ap ON s.AlternateContactPersonID = ap.PersonID
LEFT OUTER JOIN Application.DeliveryMethods AS dm ON s.DeliveryMethodID = dm.DeliveryMethodID
LEFT OUTER JOIN Application.Cities AS c ON s.DeliveryCityID = c.CityID;



CREATE VIEW Website.Customers AS
SELECT s.CustomerID,
       s.CustomerName,
       sc.CustomerCategoryName,
       pp.FullName AS PrimaryContact,
       ap.FullName AS AlternateContact,
       s.PhoneNumber,
       s.FaxNumber,
       bg.BuyingGroupName,
       s.WebsiteURL,
       dm.DeliveryMethodName AS DeliveryMethod,
       c.CityName,  -- Alias not necessary if column name is the same
       s.DeliveryLocation,
       s.DeliveryRun,
       s.RunPosition
FROM Sales.Customers AS s
LEFT OUTER JOIN Sales.CustomerCategories AS sc ON s.CustomerCategoryID = sc.CustomerCategoryID
LEFT OUTER JOIN Application.People AS pp ON s.PrimaryContactPersonID = pp.PersonID
LEFT OUTER JOIN Application.People AS ap ON s.AlternateContactPersonID = ap.PersonID
LEFT OUTER JOIN Sales.BuyingGroups AS bg ON s.BuyingGroupID = bg.BuyingGroupID
LEFT OUTER JOIN Application.DeliveryMethods AS dm ON s.DeliveryMethodID = dm.DeliveryMethodID
LEFT OUTER JOIN Application.Cities AS c ON s.DeliveryCityID = c.CityID

select * from Website.Customers
