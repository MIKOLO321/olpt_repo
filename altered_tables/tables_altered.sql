ALTER TABLE application.people
ALTER COLUMN personid SET DEFAULT nextval('sequences.personid');

ALTER TABLE application.stateprovinces
ALTER COLUMN stateprovinceid SET DEFAULT nextval('sequences.stateprovinceid');

ALTER TABLE Application.transactiontypes
ALTER COLUMN transactiontypeid SET DEFAULT nextval('application.transaction_type_id_seq');

ALTER TABLE purchasing.purchase_order_lines
ALTER COLUMN purchase_order_line_id SET DEFAULT nextval('purchasing.purchase_order_line_id_seq');


ALTER TABLE purchasing.supplier_transactions
ALTER COLUMN last_edited_when SET DEFAULT now();

ALTER TABLE sales.buyinggroups
ALTER COLUMN buyinggroupid SET DEFAULT nextval('sales.buyinggroupid_seq')

ALTER TABLE sales.customercategories
ALTER COLUMN customercategoryid SET DEFAULT nextval('sales.customer_category_id_seq');


ALTER TABLE sales.customers
ALTER COLUMN customerid SET DEFAULT nextval('sales.customer_id_seq');

ALTER TABLE sales.customertransactions
ALTER COLUMN customertransactionid SET DEFAULT nextval('sales.transaction_id_seq');

ALTER TABLE sales.invoicelines
ALTER COLUMN invoicelineid SET DEFAULT nextval('sales.invoice_line_id_seq');

ALTER TABLE sales.invoices
ALTER COLUMN invoiceid SET DEFAULT nextval('sales.invoice_id_seq');

ALTER TABLE sales.orderlines
ALTER COLUMN orderlineid SET DEFAULT nextval('sales.order_line_id_seq');

ALTER TABLE sales.orders
ALTER COLUMN orderid SET DEFAULT nextval('sales.order_id_seq');

ALTER TABLE sales.specialdeals
ALTER COLUMN specialdealid SET DEFAULT nextval('sales.special_deal_id_seq');

ALTER TABLE warehouse.colors
ALTER COLUMN colorid SET DEFAULT nextval('warehouse.color_id_seq');

ALTER TABLE warehouse.packagetypes
ALTER COLUMN packagetypeid SET DEFAULT nextval('warehouse.package_type_id_seq');

ALTER TABLE warehouse.stockgroups
ALTER COLUMN stockgroupid SET DEFAULT nextval('warehouse.stock_group_id_seq');

ALTER TABLE warehouse.stockitems
ALTER COLUMN stockitemid SET DEFAULT nextval('warehouse.stock_item_id_seq');

ALTER TABLE warehouse.stockitem_transactions
ALTER COLUMN stockitem_transactionid SET DEFAULT nextval('warehouse.stock_item_transaction_id_seq');

ALTER TABLE application.cities
ADD CONSTRAINT fk_application_cities_stateprovinceid_application_stateprovinces
FOREIGN KEY (stateprovinceid)
REFERENCES application.stateprovinces (stateprovinceid);



ALTER TABLE application.stateprovinces
ADD CONSTRAINT fk_application_stateprovinces_countryid_application_countries
FOREIGN KEY (countryid)
REFERENCES application.countries (countryid);


ALTER TABLE application.systemparameters
ADD CONSTRAINT fk_application_systemparameters_deliverycityid_application_cities
FOREIGN KEY (deliverycityid)
REFERENCES application.cities (cityid);

ALTER TABLE application.systemparameters
ADD CONSTRAINT fk_application_systemparameters_postalcityid_application_cities
FOREIGN KEY (postalcityid)
REFERENCES application.cities (cityid);

ALTER TABLE purchasing.purchaseorderlines
ADD CONSTRAINT fk_purchasing_purchaseorderlines_packagetypeid_warehouse_packagetypes
FOREIGN KEY (packagetypeid)
REFERENCES warehouse.packagetypes (packagetypeid);

ALTER TABLE purchasing.purchaseorderlines
ADD CONSTRAINT fk_purchasing_purchaseorderlines_stockitemid_warehouse_stockitems
FOREIGN KEY (stockitemid)
REFERENCES warehouse.stockitems (stockitemid);


ALTER TABLE purchasing.purchaseorders
ADD CONSTRAINT fk_purchasing_purchaseorders_contactpersonid_application_people
FOREIGN KEY (contactpersonid)
REFERENCES application.people (personid);


ALTER TABLE purchasing.purchaseorders
ADD CONSTRAINT fk_purchasing_purchaseorders_deliverymethodid_application_deliverymethods
FOREIGN KEY (deliverymethodid)
REFERENCES application.deliverymethods (deliverymethodid);

ALTER TABLE purchasing.purchaseorders
ADD CONSTRAINT fk_purchasing_purchaseorders_supplierid_purchasing_suppliers
FOREIGN KEY (supplierid)
REFERENCES purchasing.suppliers (supplierid);


ALTER TABLE purchasing.suppliercategories
ADD CONSTRAINT fk_purchasing_suppliercategories_application_people
FOREIGN KEY (lasteditedby)
REFERENCES application.people (personid);


ALTER TABLE purchasing.suppliers
ADD CONSTRAINT fk_purchasing_suppliers_alternatecontactpersonid_application_people
FOREIGN KEY (alternatecontactpersonid)
REFERENCES application.people (personid);


ALTER TABLE purchasing.suppliers
ADD CONSTRAINT fk_suppliers_last_edited_by_people  
FOREIGN KEY (lasteditedby)
REFERENCES application.people (personid);

ALTER TABLE purchasing.suppliers
ADD CONSTRAINT fk_suppliers_delivery_city  
FOREIGN KEY (deliverycityid)
REFERENCES application.cities (cityid);

ALTER TABLE purchasing.suppliers
ADD CONSTRAINT fk_suppliers_primary_contact  
FOREIGN KEY (primarycontactpersonid)
REFERENCES application.people (personid);


ALTER TABLE purchasing.suppliers
ADD CONSTRAINT fk_suppliers_supplier_category  
FOREIGN KEY (suppliercategoryid)
REFERENCES purchasing.suppliercategories (suppliercategoryid);


ALTER TABLE purchasing.suppliertransactions
ADD CONSTRAINT fk_supplier_transactions_people  
FOREIGN KEY (lasteditedby)
REFERENCES application.people (personid);

ALTER TABLE purchasing.suppliertransactions
ADD CONSTRAINT fk_supplier_transactions_payment_method  
FOREIGN KEY (paymentmethodid)
REFERENCES application.paymentmethods (paymentmethodid);

ALTER TABLE purchasing.suppliertransactions
ADD CONSTRAINT fk_supplier_transactions_purchase_order
FOREIGN KEY (purchaseorderid)
REFERENCES purchasing.purchaseorders (purchaseorderid);

ALTER TABLE purchasing.suppliertransactions
ADD CONSTRAINT fk_supplier_transactions_transaction_type 
FOREIGN KEY (transactiontypeid)
REFERENCES application.transactiontypes (transactiontypeid);
ALTER TABLE sales.buyinggroups
ADD CONSTRAINT fk_buying_groups_people  
FOREIGN KEY (lasteditedby)
REFERENCES application.people (personid);


ALTER TABLE sales.customercategories
ADD CONSTRAINT fk_customer_categories_people  
FOREIGN KEY (lasteditedby)
REFERENCES application.people (personid);

ALTER TABLE sales.customers
ADD CONSTRAINT fk_customers_alternate_contact1  
FOREIGN KEY (alternate_contact_person_id)
REFERENCES application.people (person_id);

ALTER TABLE sales.customers
ADD CONSTRAINT fk_customers_last_edited_by_people  
FOREIGN KEY (lasteditedby)
REFERENCES application.people (personid);
ALTER TABLE sales.customers
ADD CONSTRAINT fk_customers_buying_group  
FOREIGN KEY (buyinggroupid)
REFERENCES sales.buyinggroups (buyinggroupid);

ALTER TABLE sales.customers
ADD CONSTRAINT fk_customers_delivery_city  
FOREIGN KEY (deliverycityid)
REFERENCES application.cities (cityid);

ALTER TABLE sales.customers
ADD CONSTRAINT fk_customers_delivery_method 
FOREIGN KEY (deliverymethodid)
REFERENCES application.deliverymethods (deliverymethodid);
ALTER TABLE sales.customers
ADD CONSTRAINT fk_customers_postal_city 
FOREIGN KEY (postalcityid)
REFERENCES application.cities (cityid);
ALTER TABLE sales.customers
ADD CONSTRAINT fk_customers_primary_contact  
FOREIGN KEY (primarycontactpersonid)
REFERENCES application.people (personid);
ALTER TABLE sales.customertransactions
ADD CONSTRAINT fk_customer_transactions_people  
FOREIGN KEY (lasteditedby)
REFERENCES application.people (personid);
ALTER TABLE sales.customertransactions
ADD CONSTRAINT fk_customer_transactions_customer
FOREIGN KEY (customerid)
REFERENCES sales.customers (customerid);

ALTER TABLE sales.customertransactions
ADD CONSTRAINT fk_customer_transactions_transaction_type 
FOREIGN KEY (transactiontypeid)
REFERENCES application.transactiontypes (transactiontypeid);

ALTER TABLE sales.invoicelines
ADD CONSTRAINT fk_invoice_lines_people 
FOREIGN KEY (lasteditedby)
REFERENCES application.people (personid);
ALTER TABLE sales.invoicelines
ADD CONSTRAINT fk_invoice_lines_invoice 
FOREIGN KEY (invoiceid)
REFERENCES sales.invoices (invoiceid);
ALTER TABLE sales.invoicelines
ADD CONSTRAINT fk_invoice_lines_package_type  
FOREIGN KEY (packagetypeid)
REFERENCES warehouse.packagetypes (packagetypeid);
ALTER TABLE sales.invoice_lines
ADD CONSTRAINT fk_invoice_lines_stock_item 
FOREIGN KEY (stock_item_id)
REFERENCES warehouse.stock_items (stock_item_id);


ALTER TABLE sales.invoices
ADD CONSTRAINT fk_invoices_last_edited_by  
FOREIGN KEY (lasteditedby)
REFERENCES application.people (personid);

ALTER TABLE sales.invoices
ADD CONSTRAINT fk_invoices_bill_to_customer  
FOREIGN KEY (billtocustomerid)
REFERENCES sales.customers (customerid);
ALTER TABLE sales.invoices
ADD CONSTRAINT fk_invoices_contact_person  
FOREIGN KEY (contactpersonid)
REFERENCES application.people (personid);

ALTER TABLE sales.invoices
ADD CONSTRAINT fk_invoices_delivery_method  
FOREIGN KEY (deliverymethodid)
REFERENCES application.deliverymethods (deliverymethodid);
ALTER TABLE sales.invoices
ADD CONSTRAINT fk_invoices_order  
FOREIGN KEY (orderid)
REFERENCES sales.orders (orderid);
ALTER TABLE sales.invoices
ADD CONSTRAINT fk_invoices_packed_by 
FOREIGN KEY (packedbypersonid)
REFERENCES application.people (personid);
ALTER TABLE sales.invoices
ADD CONSTRAINT fk_invoices_salesperson  
FOREIGN KEY (salespersonpersonid)
REFERENCES application.people (personid);
ALTER TABLE sales.orderlines
ADD CONSTRAINT fk_order_lines_people  
FOREIGN KEY (lasteditedby)
REFERENCES application.people (personid);
ALTER TABLE sales.orderlines
ADD CONSTRAINT fk_order_lines_order  
FOREIGN KEY (orderid)
REFERENCES sales.orders (orderid);
ALTER TABLE sales.orderlines
ADD CONSTRAINT fk_order_lines_package_type  
FOREIGN KEY (packagetypeid)
REFERENCES warehouse.packagetypes (packagetypeid);
ALTER TABLE sales.orderlines
ADD CONSTRAINT fk_order_lines_stock_item  
FOREIGN KEY (stockitemid)
REFERENCES warehouse.stockitems (stockitemid);
ALTER TABLE sales.orders
ADD CONSTRAINT fk_orders_people
FOREIGN KEY (lasteditedby)
REFERENCES application.people (personid);


ALTER TABLE sales.orders
ADD CONSTRAINT fk_orders_last_edited_by
FOREIGN KEY (lasteditedby)
REFERENCES application.people (personid);
ALTER TABLE sales.orders
ADD CONSTRAINT fk_orders_picked_by  
FOREIGN KEY (pickedbypersonid)
REFERENCES application.people (personid); 
ALTER TABLE sales.orders
ADD CONSTRAINT fk_orders_salesperson  
FOREIGN KEY (salespersonpersonid)
REFERENCES application.people (personid);


ALTER TABLE sales.specialdeals
ADD CONSTRAINT fk_special_deals_customer_category  
FOREIGN KEY (customercategoryid)
REFERENCES sales.customercategories (customercategoryid);

ALTER TABLE Sales.SpecialDeals
ADD CONSTRAINT FK_Sales_SpecialDeals_StockGroupID_Warehouse_StockGroups
FOREIGN KEY (StockGroupID)
REFERENCES Warehouse.StockGroups (StockGroupID);

ALTER TABLE Sales.SpecialDeals
ADD CONSTRAINT FK_Sales_SpecialDeals_StockItemID_Warehouse_StockItems
FOREIGN KEY (StockItemID)
REFERENCES Warehouse.StockItems (StockItemID);
ALTER TABLE Warehouse.Colors
ADD CONSTRAINT FK_Warehouse_Colors_Application_People
FOREIGN KEY (LastEditedBy)
REFERENCES Application.People (PersonID);
ALTER TABLE Warehouse.PackageTypes
ADD CONSTRAINT FK_Warehouse_PackageTypes_Application_People
FOREIGN KEY (LastEditedBy)
REFERENCES Application.People (PersonID);
ALTER TABLE Warehouse.StockItemHoldings
ADD CONSTRAINT FK_Warehouse_StockItemHoldings_Application_People
FOREIGN KEY (LastEditedBy)
REFERENCES Application.People (PersonID);


ALTER TABLE Warehouse.StockItemHoldings
ADD CONSTRAINT PKFK_Warehouse_StockItemHoldings_StockItemID_Warehouse_StockItems
FOREIGN KEY (StockItemID)
REFERENCES Warehouse.StockItems (StockItemID); 

ALTER TABLE Warehouse.StockItems
ADD CONSTRAINT FK_Warehouse_StockItems_Application_People
FOREIGN KEY (LastEditedBy)
REFERENCES Application.People (PersonID);
ALTER TABLE Warehouse.StockItems
ADD CONSTRAINT FK_Warehouse_StockItems_OuterPackageID_Warehouse_PackageTypes
FOREIGN KEY (OuterPackageID)
REFERENCES Warehouse.PackageTypes (PackageTypeID);
ALTER TABLE Warehouse.StockItemStockGroups
ADD CONSTRAINT FK_Warehouse_StockItemStockGroups_Application_People
FOREIGN KEY (LastEditedBy)
REFERENCES Application.People (PersonID);
ALTER TABLE Warehouse.StockItemStockGroups
ADD CONSTRAINT FK_Warehouse_StockItemStockGroups_StockGroupID_Warehouse_StockGroups
FOREIGN KEY (StockGroupID)
REFERENCES Warehouse.StockGroups (StockGroupID);
ALTER TABLE Warehouse.StockItemTransactions
ADD CONSTRAINT FK_Warehouse_StockItemTransactions_Application_People
FOREIGN KEY (LastEditedBy)
REFERENCES Application.People (PersonID);
ALTER TABLE Warehouse.StockItemTransactions
ADD CONSTRAINT FK_Warehouse_StockItemTransactions_InvoiceID_Sales_Invoices
FOREIGN KEY (InvoiceID)
REFERENCES Sales.Invoices (InvoiceID);
ALTER TABLE Warehouse.StockItemTransactions
ADD CONSTRAINT FK_Warehouse_StockItemTransactions_PurchaseOrderID_Purchasing_PurchaseOrders
FOREIGN KEY (PurchaseOrderID)
REFERENCES Purchasing.PurchaseOrders (PurchaseOrderID);
ALTER TABLE Warehouse.StockItemTransactions
ADD CONSTRAINT FK_Warehouse_StockItemTransactions_StockItemID_Warehouse_StockItems
FOREIGN KEY (StockItemID)
REFERENCES Warehouse.StockItems (StockItemID);
ALTER TABLE Sales.Invoices
ADD CONSTRAINT CK_Sales_Invoices_ReturnedDeliveryData_Must_Be_Valid_JSON
CHECK (ReturnedDeliveryData IS NULL OR ReturnedDeliveryData::jsonb IS NOT NULL);
ALTER TABLE Sales.SpecialDeals
ADD CONSTRAINT CK_Sales_SpecialDeals_Exactly_One_NOT_NULL_Pricing_Option_Is_Required
CHECK (
    (CASE WHEN DiscountAmount IS NULL THEN 0 ELSE 1 END +
     CASE WHEN DiscountPercentage IS NULL THEN 0 ELSE 1 END +
     CASE WHEN UnitPrice IS NULL THEN 0 ELSE 1 END) = 1
);
ALTER TABLE Sales.SpecialDeals
ADD CONSTRAINT CK_Sales_SpecialDeals_Unit_Price_Deal_Requires_Special_StockItem
CHECK (UnitPrice IS NULL OR StockItemID IS NOT NULL);