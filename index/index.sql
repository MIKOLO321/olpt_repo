CREATE INDEX IX_Application_People_FullName ON Application.People (FullName);

CREATE INDEX IX_Application_People_IsEmployee ON Application.People (IsEmployee);

CREATE INDEX IX_Application_People_IsSalesperson ON Application.People (IsSalesperson);

CREATE INDEX IX_Application_People_Perf_20160301_05 ON Application.People (IsPermittedToLogon, PersonID);

CREATE INDEX FK_Application_StateProvinces_CountryID ON Application.StateProvinces (CountryID);

CREATE INDEX IX_Application_StateProvinces_SalesTerritory ON Application.StateProvinces (SalesTerritory);

CREATE INDEX FK_Application_SystemParameters_DeliveryCityID ON Application.SystemParameters (DeliveryCityID);

CREATE INDEX FK_Application_SystemParameters_PostalCityID ON Application.SystemParameters (PostalCityID);


CREATE INDEX FK_Purchasing_PurchaseOrderLines_PackageTypeID ON Purchasing.PurchaseOrderLines (PackageTypeID);

CREATE INDEX FK_Purchasing_PurchaseOrderLines_PurchaseOrderID ON Purchasing.PurchaseOrderLines (PurchaseOrderID);

CREATE INDEX FK_Purchasing_PurchaseOrderLines_StockItemID ON Purchasing.PurchaseOrderLines (StockItemID);

CREATE INDEX IX_Purchasing_PurchaseOrderLines_Perf_20160301_4 ON Purchasing.PurchaseOrderLines (IsOrderLineFinalized, StockItemID, OrderedOuters, ReceivedOuters);

CREATE INDEX FK_Purchasing_PurchaseOrders_ContactPersonID ON Purchasing.PurchaseOrders (ContactPersonID);

CREATE INDEX FK_Purchasing_PurchaseOrders_DeliveryMethodID ON Purchasing.PurchaseOrders (DeliveryMethodID);

CREATE INDEX FK_Purchasing_PurchaseOrders_SupplierID ON Purchasing.PurchaseOrders (SupplierID);

CREATE INDEX FK_Purchasing_Suppliers_AlternateContactPersonID ON Purchasing.Suppliers (AlternateContactPersonID);

CREATE INDEX FK_Purchasing_Suppliers_DeliveryCityID ON Purchasing.Suppliers (DeliveryCityID);

CREATE INDEX FK_Purchasing_Suppliers_DeliveryMethodID ON Purchasing.Suppliers (DeliveryMethodID);

CREATE INDEX FK_Purchasing_Suppliers_PrimaryContactPersonID ON Purchasing.Suppliers (PrimaryContactPersonID);

CREATE INDEX FK_Purchasing_Suppliers_SupplierCategoryID ON Purchasing.Suppliers (SupplierCategoryID);

CREATE INDEX FK_Purchasing_SupplierTransactions_PaymentMethodID ON Purchasing.SupplierTransactions (PaymentMethodID);

-- Create a separate index on TransactionDate if needed:
CREATE INDEX IX_SupplierTransactions_TransactionDate ON Purchasing.SupplierTransactions (TransactionDate);

CREATE INDEX FK_Purchasing_SupplierTransactions_PurchaseOrderID ON Purchasing.SupplierTransactions (PurchaseOrderID);

CREATE INDEX FK_Purchasing_SupplierTransactions_SupplierID ON Purchasing.SupplierTransactions (SupplierID);

CREATE INDEX FK_Purchasing_SupplierTransactions_TransactionTypeID ON Purchasing.SupplierTransactions (TransactionTypeID);

CREATE INDEX IX_Purchasing_SupplierTransactions_IsFinalized ON Purchasing.SupplierTransactions (IsFinalized);

CREATE INDEX FK_Sales_Customers_AlternateContactPersonID ON Sales.Customers (AlternateContactPersonID);

CREATE INDEX FK_Sales_Customers_BuyingGroupID ON Sales.Customers (BuyingGroupID);

CREATE INDEX FK_Sales_Customers_CustomerCategoryID ON Sales.Customers (CustomerCategoryID);

CREATE INDEX FK_Sales_Customers_DeliveryCityID ON Sales.Customers (DeliveryCityID);

CREATE INDEX FK_Sales_Customers_DeliveryMethodID ON Sales.Customers (DeliveryMethodID);

CREATE INDEX FK_Sales_Customers_PostalCityID ON Sales.Customers (PostalCityID);

CREATE INDEX FK_Sales_Customers_PrimaryContactPersonID ON Sales.Customers (PrimaryContactPersonID);

CREATE INDEX IX_Sales_Customers_Perf_20160301_06 ON Sales.Customers (IsOnCreditHold, CustomerID, BillToCustomerID, PrimaryContactPersonID);

CREATE INDEX FK_Sales_CustomerTransactions_CustomerID ON Sales.CustomerTransactions (CustomerID);

CREATE INDEX FK_Sales_CustomerTransactions_InvoiceID ON Sales.CustomerTransactions (InvoiceID);

CREATE INDEX FK_Sales_CustomerTransactions_PaymentMethodID ON Sales.CustomerTransactions (PaymentMethodID);

CREATE INDEX FK_Sales_CustomerTransactions_TransactionTypeID ON Sales.CustomerTransactions (TransactionTypeID);

CREATE INDEX IX_Sales_CustomerTransactions_IsFinalized ON Sales.CustomerTransactions (IsFinalized);


CREATE INDEX FK_Sales_InvoiceLines_InvoiceID ON Sales.InvoiceLines (InvoiceID);

CREATE INDEX FK_Sales_InvoiceLines_PackageTypeID ON Sales.InvoiceLines (PackageTypeID);

CREATE INDEX FK_Sales_InvoiceLines_StockItemID ON Sales.InvoiceLines (StockItemID);

CREATE INDEX FK_Sales_Invoices_AccountsPersonID ON Sales.Invoices (AccountsPersonID);

CREATE INDEX FK_Sales_Invoices_BillToCustomerID ON Sales.Invoices (BillToCustomerID);

CREATE INDEX FK_Sales_Invoices_ContactPersonID ON Sales.Invoices (ContactPersonID);

CREATE INDEX FK_Sales_Invoices_CustomerID ON Sales.Invoices (CustomerID);

CREATE INDEX FK_Sales_Invoices_DeliveryMethodID ON Sales.Invoices (DeliveryMethodID);

CREATE INDEX FK_Sales_Invoices_OrderID ON Sales.Invoices (OrderID);

CREATE INDEX FK_Sales_Invoices_PackedByPersonID ON Sales.Invoices (PackedByPersonID);

CREATE INDEX FK_Sales_Invoices_SalespersonPersonID ON Sales.Invoices (SalespersonPersonID);


CREATE INDEX IX_Sales_Invoices_ConfirmedDeliveryTime ON Sales.Invoices (ConfirmedDeliveryTime, ConfirmedReceivedBy);

CREATE INDEX FK_Sales_OrderLines_OrderID ON Sales.OrderLines (OrderID);

CREATE INDEX IX_Sales_OrderLines_AllocatedStockItems ON Sales.OrderLines (StockItemID, PickedQuantity);

CREATE INDEX IX_Sales_OrderLines_Perf_20160301_01 ON Sales.OrderLines (PickingCompletedWhen, OrderID, OrderLineID, Quantity, StockItemID);

CREATE INDEX IX_Sales_OrderLines_Perf_20160301_02 ON Sales.OrderLines (StockItemID, PickingCompletedWhen, OrderID, PickedQuantity);

CREATE INDEX FK_Sales_Orders_ContactPersonID ON Sales.Orders (ContactPersonID);

CREATE INDEX FK_Sales_Orders_CustomerID ON Sales.Orders (CustomerID);

CREATE INDEX FK_Sales_Orders_PickedByPersonID ON Sales.Orders (PickedByPersonID);

CREATE INDEX FK_Sales_Orders_SalespersonPersonID ON Sales.Orders (SalespersonPersonID);

CREATE INDEX FK_Sales_SpecialDeals_BuyingGroupID ON Sales.SpecialDeals (BuyingGroupID);

CREATE INDEX FK_Sales_SpecialDeals_CustomerCategoryID ON Sales.SpecialDeals (CustomerCategoryID);

CREATE INDEX FK_Sales_SpecialDeals_StockGroupID ON Sales.SpecialDeals (StockGroupID);

CREATE INDEX FK_Warehouse_StockItems_ColorID ON Warehouse.StockItems (ColorID);

CREATE INDEX FK_Warehouse_StockItems_SupplierID ON Warehouse.StockItems (SupplierID);

CREATE INDEX FK_Warehouse_StockItems_UnitPackageID ON Warehouse.StockItems (UnitPackageID);

CREATE INDEX FK_Warehouse_StockItemTransactions_CustomerID ON Warehouse.StockItemTransactions (CustomerID);

CREATE INDEX FK_Warehouse_StockItemTransactions_PurchaseOrderID ON Warehouse.StockItemTransactions (PurchaseOrderID);

CREATE INDEX FK_Warehouse_StockItemTransactions_InvoiceID ON Warehouse.StockItemTransactions (InvoiceID);

CREATE INDEX FK_Warehouse_StockItemTransactions_StockItemID ON Warehouse.StockItemTransactions (StockItemID);

CREATE INDEX FK_Warehouse_StockItemTransactions_SupplierID ON Warehouse.StockItemTransactions (SupplierID);

CREATE INDEX FK_Warehouse_StockItemTransactions_TransactionTypeID ON Warehouse.StockItemTransactions (TransactionTypeID);

CREATE INDEX NCCX_Sales_InvoiceLines
ON Sales.InvoiceLines
USING brin  -- or btree, depending on your workload (see explanation below)
(
    InvoiceID,
    StockItemID,
    Quantity,
    UnitPrice,
    LineProfit,
    LastEditedWhen
);
























