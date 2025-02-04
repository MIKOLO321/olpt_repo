CREATE TABLE IF NOT EXISTS warehouse.colors
(
    colorid integer NOT NULL,
    colorname character varying(20) COLLATE pg_catalog."default" NOT NULL,
    lasteditedby integer NOT NULL,
    validfrom timestamp with time zone NOT NULL DEFAULT now(),
    validto timestamp with time zone NOT NULL DEFAULT 'infinity'::timestamp with time zone,
    CONSTRAINT colors_pkey PRIMARY KEY (colorid),
    CONSTRAINT colors_colorname_key UNIQUE (colorname)
)

CREATE TABLE IF NOT EXISTS warehouse.colors_archive
(
    colorid integer NOT NULL,
    colorname character varying(20) COLLATE pg_catalog."default" NOT NULL,
    lasteditedby integer NOT NULL,
    validfrom timestamp with time zone NOT NULL,
    validto timestamp with time zone NOT NULL
)

CREATE TABLE IF NOT EXISTS warehouse.packagetypes
(
    packagetypeid integer NOT NULL,
    packagetypename character varying(50) COLLATE pg_catalog."default" NOT NULL,
    lasteditedby integer NOT NULL,
    validfrom timestamp with time zone NOT NULL DEFAULT now(),
    validto timestamp with time zone NOT NULL DEFAULT 'infinity'::timestamp with time zone,
    CONSTRAINT packagetypes_pkey PRIMARY KEY (packagetypeid),
    CONSTRAINT packagetypes_packagetypename_key UNIQUE (packagetypename)
)
CREATE TABLE IF NOT EXISTS warehouse.packagetypes_archive
(
    packagetypeid integer NOT NULL,
    packagetypename character varying(50) COLLATE pg_catalog."default" NOT NULL,
    lasteditedby integer NOT NULL,
    validfrom timestamp with time zone NOT NULL,
    validto timestamp with time zone NOT NULL
)
CREATE TABLE IF NOT EXISTS warehouse.stockgroups
(
    stockgroupid integer NOT NULL,
    stockgroupname character varying(50) COLLATE pg_catalog."default" NOT NULL,
    lasteditedby integer NOT NULL,
    validfrom timestamp with time zone NOT NULL DEFAULT now(),
    validto timestamp with time zone NOT NULL DEFAULT 'infinity'::timestamp with time zone,
    CONSTRAINT stockgroups_pkey PRIMARY KEY (stockgroupid),
    CONSTRAINT stockgroups_stockgroupname_key UNIQUE (stockgroupname)
)

CREATE TABLE IF NOT EXISTS warehouse.stockgroups_archive
(
    stockgroupid integer NOT NULL,
    stockgroupname character varying(50) COLLATE pg_catalog."default" NOT NULL,
    lasteditedby integer NOT NULL,
    validfrom timestamp with time zone NOT NULL,
    validto timestamp with time zone NOT NULL
)

CREATE TABLE Application.StateProvinces_Archive (
    StateProvinceID INT NOT NULL,
    StateProvinceCode VARCHAR(5) NOT NULL,
    StateProvinceName VARCHAR(50) NOT NULL,
    CountryID INT NOT NULL,
    SalesTerritory VARCHAR(50) NOT NULL,
    Border polygon NULL,
    LatestRecordedPopulation BIGINT NULL,
    LastEditedBy INT NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE Application.Cities (
    CityID INT NOT NULL,
    CityName VARCHAR(50) NOT NULL,
    StateProvinceID INT NOT NULL,
    Location polygon NULL,
    LatestRecordedPopulation BIGINT NULL,
    LastEditedBy INT NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE GENERATED ALWAYS AS ROW START NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE GENERATED ALWAYS AS ROW END NOT NULL,
    CONSTRAINT PK_Application_Cities PRIMARY KEY (CityID)
);

CREATE TABLE purchasing.supplier_transactions (
    supplier_transaction_id SERIAL PRIMARY KEY,
    transaction_date DATE NOT NULL,
    transaction_type VARCHAR(50) NOT NULL,
    amount NUMERIC(15, 2) NOT NULL,
    description TEXT,
    last_edited_when TIMESTAMP WITH TIME ZONE DEFAULT now(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE,
    reference_number VARCHAR(255)
);

CREATE TABLE Purchasing.Suppliers_Archive (
    SupplierID INT NOT NULL,
    SupplierName VARCHAR(100) NOT NULL,
    SupplierCategoryID INT NOT NULL,
    PrimaryContactPersonID INT NOT NULL,
    AlternateContactPersonID INT NOT NULL,
    DeliveryMethodID INT NULL,
    DeliveryCityID INT NOT NULL,
    PostalCityID INT NOT NULL,
    SupplierReference VARCHAR(20) NULL,
    BankAccountName VARCHAR(50) NULL,  -- Masking handled differently (see below)
    BankAccountBranch VARCHAR(50) NULL,  -- Masking handled differently (see below)
    BankAccountCode VARCHAR(20) NULL,  -- Masking handled differently (see below)
    BankAccountNumber VARCHAR(20) NULL,  -- Masking handled differently (see below)
    BankInternationalCode VARCHAR(20) NULL,  -- Masking handled differently (see below)
    PaymentDays INT NOT NULL,
    InternalComments TEXT NULL,  -- Use TEXT for larger text fields
    PhoneNumber VARCHAR(20) NOT NULL,
    FaxNumber VARCHAR(20) NOT NULL,
    WebsiteURL VARCHAR(256) NOT NULL,
    DeliveryAddressLine1 VARCHAR(60) NOT NULL,
    DeliveryAddressLine2 VARCHAR(60) NULL,
    DeliveryPostalCode VARCHAR(10) NOT NULL,
    DeliveryLocation polygon NULL,
    PostalAddressLine1 VARCHAR(60) NOT NULL,
    PostalAddressLine2 VARCHAR(60) NULL,
    PostalPostalCode VARCHAR(10) NOT NULL,
    LastEditedBy INT NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE NOT NULL
);


CREATE TABLE Purchasing.Suppliers_Archive (
    SupplierID INT NOT NULL,
    SupplierName VARCHAR(100) NOT NULL,
    SupplierCategoryID INT NOT NULL,
    PrimaryContactPersonID INT NOT NULL,
    AlternateContactPersonID INT NOT NULL,
    DeliveryMethodID INT NULL,
    DeliveryCityID INT NOT NULL,
    PostalCityID INT NOT NULL,
    SupplierReference VARCHAR(20) NULL,
    BankAccountName VARCHAR(50) NULL,  -- Masking handled differently (see below)
    BankAccountBranch VARCHAR(50) NULL,  -- Masking handled differently (see below)
    BankAccountCode VARCHAR(20) NULL,  -- Masking handled differently (see below)
    BankAccountNumber VARCHAR(20) NULL,  -- Masking handled differently (see below)
    BankInternationalCode VARCHAR(20) NULL,  -- Masking handled differently (see below)
    PaymentDays INT NOT NULL,
    InternalComments TEXT NULL,  -- Use TEXT for larger text fields
    PhoneNumber VARCHAR(20) NOT NULL,
    FaxNumber VARCHAR(20) NOT NULL,
    WebsiteURL VARCHAR(256) NOT NULL,
    DeliveryAddressLine1 VARCHAR(60) NOT NULL,
    DeliveryAddressLine2 VARCHAR(60) NULL,
    DeliveryPostalCode VARCHAR(10) NOT NULL,
    DeliveryLocation polygon NULL,
    PostalAddressLine1 VARCHAR(60) NOT NULL,
    PostalAddressLine2 VARCHAR(60) NULL,
    PostalPostalCode VARCHAR(10) NOT NULL,
    LastEditedBy INT NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE NOT NULL
);


CREATE TABLE Sales.Customers (
    CustomerID INT NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    BillToCustomerID INT NOT NULL,
    CustomerCategoryID INT NOT NULL,
    BuyingGroupID INT NULL,
    PrimaryContactPersonID INT NOT NULL,
    AlternateContactPersonID INT NULL,
    DeliveryMethodID INT NOT NULL,
    DeliveryCityID INT NOT NULL,
    PostalCityID INT NOT NULL,
    CreditLimit NUMERIC(18, 2) NULL,
    AccountOpenedDate DATE NOT NULL,
    StandardDiscountPercentage NUMERIC(18, 3) NOT NULL,
    IsStatementSent BOOLEAN NOT NULL,
    IsOnCreditHold BOOLEAN NOT NULL,
    PaymentDays INT NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    FaxNumber VARCHAR(20) NOT NULL,
    DeliveryRun VARCHAR(5) NULL,
    RunPosition VARCHAR(5) NULL,
    WebsiteURL VARCHAR(256) NOT NULL,
    DeliveryAddressLine1 VARCHAR(60) NOT NULL,
    DeliveryAddressLine2 VARCHAR(60) NULL,
    DeliveryPostalCode VARCHAR(10) NOT NULL,
    DeliveryLocation POLYGON NULL,
    PostalAddressLine1 VARCHAR(60) NOT NULL,
    PostalAddressLine2 VARCHAR(60) NULL,
    PostalPostalCode VARCHAR(10) NOT NULL,
    LastEditedBy INT NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT PK_Sales_Customers PRIMARY KEY (CustomerID),
    CONSTRAINT UQ_Sales_Customers_CustomerName UNIQUE (CustomerName)
);

CREATE TABLE Sales.Customers_Archive (
    CustomerID INT NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    BillToCustomerID INT NOT NULL,
    CustomerCategoryID INT NOT NULL,
    BuyingGroupID INT NULL,
    PrimaryContactPersonID INT NOT NULL,
    AlternateContactPersonID INT NULL,
    DeliveryMethodID INT NOT NULL,
    DeliveryCityID INT NOT NULL,
    PostalCityID INT NOT NULL,
    CreditLimit NUMERIC(18, 2) NULL,  -- DECIMAL maps to NUMERIC in Postgres
    AccountOpenedDate DATE NOT NULL,
    StandardDiscountPercentage NUMERIC(18, 3) NOT NULL,
    IsStatementSent BOOLEAN NOT NULL,  -- BIT maps to BOOLEAN
    IsOnCreditHold BOOLEAN NOT NULL,  -- BIT maps to BOOLEAN
    PaymentDays INT NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    FaxNumber VARCHAR(20) NOT NULL,
    DeliveryRun VARCHAR(5) NULL,
    RunPosition VARCHAR(5) NULL,
    WebsiteURL VARCHAR(256) NOT NULL,
    DeliveryAddressLine1 VARCHAR(60) NOT NULL,
    DeliveryAddressLine2 VARCHAR(60) NULL,
    DeliveryPostalCode VARCHAR(10) NOT NULL,
    DeliveryLocation POLYGON NULL,
    PostalAddressLine1 VARCHAR(60) NOT NULL,
    PostalAddressLine2 VARCHAR(60) NULL,
    PostalPostalCode VARCHAR(10) NOT NULL,
    LastEditedBy INT NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE Warehouse.ColdRoomTemperatures_Archive (
    ColdRoomTemperatureID BIGINT NOT NULL,
    ColdRoomSensorNumber INT NOT NULL,
    RecordedWhen TIMESTAMP WITH TIME ZONE NOT NULL,
    Temperature NUMERIC(10, 2) NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE NOT NULL
);


CREATE TABLE Warehouse.ColdRoomTemperatures (
    ColdRoomTemperatureID BIGSERIAL PRIMARY KEY,  -- BIGSERIAL for auto-incrementing bigint
    ColdRoomSensorNumber INT NOT NULL,
    RecordedWhen TIMESTAMP WITH TIME ZONE NOT NULL,
    Temperature NUMERIC(10, 2) NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE  NOT NULL
);

CREATE SCHEMA IF NOT EXISTS Application;

CREATE TABLE Application.People_Archive (
    PersonID INT NOT NULL,
    FullName VARCHAR(50) NOT NULL,
    PreferredName VARCHAR(50) NOT NULL,
    SearchName VARCHAR(101) NOT NULL,
    IsPermittedToLogon BOOLEAN NOT NULL,
    LogonName VARCHAR(50) NULL,
    IsExternalLogonProvider BOOLEAN NOT NULL,
    HashedPassword BYTEA NULL,  -- Use BYTEA for varbinary(max)
    IsSystemUser BOOLEAN NOT NULL,
    IsEmployee BOOLEAN NOT NULL,
    IsSalesperson BOOLEAN NOT NULL,
    UserPreferences TEXT NULL,  -- Use TEXT for nvarchar(max)
    PhoneNumber VARCHAR(20) NULL,
    FaxNumber VARCHAR(20) NULL,
    EmailAddress VARCHAR(256) NULL,
    Photo BYTEA NULL,       -- Use BYTEA for varbinary(max)
    CustomFields TEXT NULL,   -- Use TEXT for nvarchar(max)
    OtherLanguages TEXT NULL, -- Use TEXT for nvarchar(max)
    LastEditedBy INT NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE Application.People_Archive (
    PersonID INT NOT NULL,
    FullName VARCHAR(50) NOT NULL,
    PreferredName VARCHAR(50) NOT NULL,
    SearchName VARCHAR(101) NOT NULL,
    IsPermittedToLogon BOOLEAN NOT NULL,
    LogonName VARCHAR(50) NULL,
    IsExternalLogonProvider BOOLEAN NOT NULL,
    HashedPassword BYTEA NULL,  -- Use BYTEA for varbinary(max)
    IsSystemUser BOOLEAN NOT NULL,
    IsEmployee BOOLEAN NOT NULL,
    IsSalesperson BOOLEAN NOT NULL,
    UserPreferences TEXT NULL,  -- Use TEXT for nvarchar(max)
    PhoneNumber VARCHAR(20) NULL,
    FaxNumber VARCHAR(20) NULL,
    EmailAddress VARCHAR(256) NULL,
    Photo BYTEA NULL,       -- Use BYTEA for varbinary(max)
    CustomFields TEXT NULL,   -- Use TEXT for nvarchar(max)
    OtherLanguages TEXT NULL, -- Use TEXT for nvarchar(max)
    LastEditedBy INT NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE NOT NULL
);
CREATE TABLE Application.People (
    PersonID INT NOT NULL,
    FullName VARCHAR(50) NOT NULL,
    PreferredName VARCHAR(50) NOT NULL,
    SearchName TEXT GENERATED ALWAYS AS (PreferredName || ' ' || FullName) STORED NOT NULL,  -- Generated and stored column
    IsPermittedToLogon BOOLEAN NOT NULL,
    LogonName VARCHAR(50) NULL,
    IsExternalLogonProvider BOOLEAN NOT NULL,
    HashedPassword BYTEA NULL,
    IsSystemUser BOOLEAN NOT NULL,
    IsEmployee BOOLEAN NOT NULL,
    IsSalesperson BOOLEAN NOT NULL,
    UserPreferences TEXT NULL,
    PhoneNumber VARCHAR(20) NULL,
    FaxNumber VARCHAR(20) NULL,
    EmailAddress VARCHAR(256) NULL,
    Photo BYTEA NULL,
    CustomFields JSONB NULL,  -- Use JSONB for JSON storage
    OtherLanguages TEXT GENERATED ALWAYS AS (CustomFields ->> 'OtherLanguages') STORED, -- Generated and stored from JSON
    LastEditedBy INT NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE  NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT PK_Application_People PRIMARY KEY (PersonID),
    CONSTRAINT UQ_Application_People_Email UNIQUE (EmailAddress) -- Add unique constraint if needed
);


CREATE TABLE Warehouse.StockItems_Archive (
    StockItemID INT NOT NULL,
    StockItemName VARCHAR(100) NOT NULL,
    SupplierID INT NOT NULL,
    ColorID INT NULL,
    UnitPackageID INT NOT NULL,
    OuterPackageID INT NOT NULL,
    Brand VARCHAR(50) NULL,
    Size VARCHAR(20) NULL,
    LeadTimeDays INT NOT NULL,
    QuantityPerOuter INT NOT NULL,
    IsChillerStock BOOLEAN NOT NULL,
    Barcode VARCHAR(50) NULL,
    TaxRate NUMERIC(18, 3) NOT NULL,
    UnitPrice NUMERIC(18, 2) NOT NULL,
    RecommendedRetailPrice NUMERIC(18, 2) NULL,
    TypicalWeightPerUnit NUMERIC(18, 3) NOT NULL,
    MarketingComments TEXT NULL,
    InternalComments TEXT NULL,
    Photo BYTEA NULL,
    CustomFields TEXT NULL,
    Tags TEXT NULL,
    SearchDetails TEXT NOT NULL,
    LastEditedBy INT NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE Warehouse.StockItems (
    StockItemID INT NOT NULL,
    StockItemName VARCHAR(100) NOT NULL,
    SupplierID INT NOT NULL,
    ColorID INT NULL,
    UnitPackageID INT NOT NULL,
    OuterPackageID INT NOT NULL,
    Brand VARCHAR(50) NULL,
    Size VARCHAR(20) NULL,
    LeadTimeDays INT NOT NULL,
    QuantityPerOuter INT NOT NULL,
    IsChillerStock BOOLEAN NOT NULL,
    Barcode VARCHAR(50) NULL,
    TaxRate NUMERIC(18, 3) NOT NULL,
    UnitPrice NUMERIC(18, 2) NOT NULL,
    RecommendedRetailPrice NUMERIC(18, 2) NULL,
    TypicalWeightPerUnit NUMERIC(18, 3) NOT NULL,
    MarketingComments TEXT NULL,
    InternalComments TEXT NULL,
    Photo BYTEA NULL,
    CustomFields JSONB NULL,  -- Use JSONB for JSON storage
    Tags TEXT GENERATED ALWAYS AS (CustomFields ->> 'Tags') STORED, -- Generated and stored from JSON
    SearchDetails TEXT GENERATED ALWAYS AS (StockItemName || ' ' || MarketingComments) STORED NOT NULL, -- Generated and stored
    LastEditedBy INT NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT PK_Warehouse_StockItems PRIMARY KEY (StockItemID),
    CONSTRAINT UQ_Warehouse_StockItems_StockItemName UNIQUE (StockItemName)
);

CREATE TABLE Application.Countries_Archive (
    CountryID INT NOT NULL,
    CountryName VARCHAR(60) NOT NULL,
    FormalName VARCHAR(60) NOT NULL,
    IsoAlpha3Code VARCHAR(3) NULL,
    IsoNumericCode INT NULL,
    CountryType VARCHAR(20) NULL,
    LatestRecordedPopulation BIGINT NULL,
    Continent VARCHAR(30) NOT NULL,
    Region VARCHAR(30) NOT NULL,
    Subregion VARCHAR(30) NOT NULL,
    Border POLYGON NULL,  
    LastEditedBy INT NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE Application.Countries (
    CountryID INT NOT NULL,
    CountryName VARCHAR(60) NOT NULL,
    FormalName VARCHAR(60) NOT NULL,
    IsoAlpha3Code VARCHAR(3) NULL,
    IsoNumericCode INT NULL,
    CountryType VARCHAR(20) NULL,
    LatestRecordedPopulation BIGINT NULL,
    Continent VARCHAR(30) NOT NULL,
    Region VARCHAR(30) NOT NULL,
    Subregion VARCHAR(30) NOT NULL,
    Border POLYGON NULL,  -- Spatial data type
    LastEditedBy INT NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT PK_Application_Countries PRIMARY KEY (CountryID),
    CONSTRAINT UQ_Application_Countries_CountryName UNIQUE (CountryName),
    CONSTRAINT UQ_Application_Countries_FormalName UNIQUE (FormalName)
);


CREATE TABLE Application.DeliveryMethods_Archive (
    DeliveryMethodID INT NOT NULL,
    DeliveryMethodName VARCHAR(50) NOT NULL,
    LastEditedBy INT NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE Application.DeliveryMethods (
    DeliveryMethodID INT NOT NULL,
    DeliveryMethodName VARCHAR(50) NOT NULL,
    LastEditedBy INT NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT PK_Application_DeliveryMethods PRIMARY KEY (DeliveryMethodID),
    CONSTRAINT UQ_Application_DeliveryMethods_DeliveryMethodName UNIQUE (DeliveryMethodName)
);

CREATE TABLE Application.PaymentMethods_Archive (
    PaymentMethodID INT NOT NULL,
    PaymentMethodName VARCHAR(50) NOT NULL,
    LastEditedBy INT NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE Application.PaymentMethods (
    PaymentMethodID INT NOT NULL,
    PaymentMethodName VARCHAR(50) NOT NULL,
    LastEditedBy INT NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT PK_Application_PaymentMethods PRIMARY KEY (PaymentMethodID),
    CONSTRAINT UQ_Application_PaymentMethods_PaymentMethodName UNIQUE (PaymentMethodName)
);

CREATE TABLE purchasing.supplier_categories (
    supplier_category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    parent_category_id INTEGER REFERENCES purchasing.supplier_categories(supplier_category_id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE Purchasing.SupplierCategories_Archive (
    SupplierCategoryID INT NOT NULL,
    SupplierCategoryName VARCHAR(50) NOT NULL,
    LastEditedBy INT NOT NULL,
    ValidFrom timestamptz NOT NULL,
    ValidTo timestamptz NOT NULL
);

CREATE TABLE Purchasing.SupplierCategories (
    SupplierCategoryID INT NOT NULL,
    SupplierCategoryName VARCHAR(50) NOT NULL,
    LastEditedBy INT NOT NULL,
    ValidFrom timestamptz NOT NULL,
    ValidTo timestamptz NOT NULL,
    CONSTRAINT PK_Purchasing_SupplierCategories PRIMARY KEY (SupplierCategoryID),
    CONSTRAINT UQ_Purchasing_SupplierCategories_SupplierCategoryName UNIQUE (SupplierCategoryName)
);

CREATE TABLE Application.StateProvinces (
    StateProvinceID INT NOT NULL,
    StateProvinceCode VARCHAR(5) NOT NULL,
    StateProvinceName VARCHAR(50) NOT NULL,
    CountryID INT NOT NULL,
    SalesTerritory VARCHAR(50) NOT NULL,
    Border Polygon, 
    LatestRecordedPopulation BIGINT,
    LastEditedBy INT NOT NULL,
    ValidFrom timestamptz NOT NULL,
    ValidTo timestamptz NOT NULL,
    CONSTRAINT PK_Application_StateProvinces PRIMARY KEY (StateProvinceID),
    CONSTRAINT UQ_Application_StateProvinces_StateProvinceName UNIQUE (StateProvinceName)
);


CREATE TABLE Application.Cities (
    CityID INT NOT NULL,
    CityName VARCHAR(50) NOT NULL,  -- Adjust size as needed
    StateProvinceID INT NOT NULL,
    LastEditedBy INT NOT NULL,
    ValidFrom timestamptz NOT NULL,
    ValidTo timestamptz NOT NULL,
    CONSTRAINT PK_Application_Cities PRIMARY KEY (CityID),
    CONSTRAINT UQ_Application_Cities_CityName UNIQUE (CityName),
    CONSTRAINT FK_Application_Cities_StateProvince FOREIGN KEY (StateProvinceID) REFERENCES Application.StateProvinces(StateProvinceID)
    
);

CREATE TABLE Purchasing.Suppliers (
    SupplierID INT NOT NULL,
    SupplierName VARCHAR(100) NOT NULL,  -- Adjust size as needed
    SupplierCategoryID INT,
    PrimaryContactPersonID INT,
    AlternateContactPersonID INT,
    PhoneNumber VARCHAR(50),  -- Adjust size as needed
    FaxNumber VARCHAR(50),      -- Adjust size as needed
    WebsiteURL VARCHAR(255),    -- Adjust size as needed
    DeliveryMethodID INT,
    DeliveryCityID INT,
    DeliveryLocation VARCHAR(255), -- Adjust size as needed
    SupplierReference VARCHAR(100), -- Adjust size as needed
    LastEditedBy INT NOT NULL,
    ValidFrom timestamptz NOT NULL,
    ValidTo timestamptz NOT NULL,
    CONSTRAINT PK_Purchasing_Suppliers PRIMARY KEY (SupplierID)


CREATE TABLE Sales.BuyingGroups_Archive (
    BuyingGroupID INT NOT NULL,
    BuyingGroupName VARCHAR(50) NOT NULL,
    LastEditedBy INT NOT NULL,
    ValidFrom timestamptz NOT NULL,
    ValidTo timestamptz NOT NULL
);

CREATE TABLE Sales.BuyingGroups (
    BuyingGroupID INT NOT NULL,
    BuyingGroupName VARCHAR(50) NOT NULL,
    LastEditedBy INT NOT NULL,
    ValidFrom timestamptz NOT NULL,
    ValidTo timestamptz NOT NULL,
    CONSTRAINT PK_Sales_BuyingGroups PRIMARY KEY (BuyingGroupID),
    CONSTRAINT UQ_Sales_BuyingGroups_BuyingGroupName UNIQUE (BuyingGroupName)
);


CREATE TABLE Sales.CustomerCategories_Archive (
    CustomerCategoryID INT NOT NULL,
    CustomerCategoryName VARCHAR(50) NOT NULL,
    LastEditedBy INT NOT NULL,
    ValidFrom timestamptz NOT NULL,
    ValidTo timestamptz NOT NULL
);

CREATE TABLE Sales.CustomerCategories (
    CustomerCategoryID INT NOT NULL,
    CustomerCategoryName VARCHAR(50) NOT NULL,
    LastEditedBy INT NOT NULL,
    ValidFrom timestamptz NOT NULL,
    ValidTo timestamptz NOT NULL,
    CONSTRAINT PK_Sales_CustomerCategories PRIMARY KEY (CustomerCategoryID),
    CONSTRAINT UQ_Sales_CustomerCategories_CustomerCategoryName UNIQUE (CustomerCategoryName)
);

CREATE TABLE Warehouse.VehicleTemperatures (
    VehicleTemperatureID BIGSERIAL PRIMARY KEY,  -- BIGSERIAL for auto-incrementing bigint
    VehicleRegistration VARCHAR(20) NOT NULL,
    ChillerSensorNumber INT NOT NULL,
    RecordedWhen timestamptz NOT NULL,
    Temperature NUMERIC(10, 2) NOT NULL,
    FullSensorData TEXT,  -- TEXT for longer strings
    IsCompressed BOOLEAN NOT NULL,
    CompressedSensorData BYTEA -- BYTEA for binary data
);

CREATE TABLE Website.VehicleTemperatures (
    VehicleTemperatureID BIGSERIAL PRIMARY KEY,
    VehicleRegistration VARCHAR(20) NOT NULL,
    ChillerSensorNumber INT NOT NULL,
    RecordedWhen timestamptz NOT NULL,
    Temperature NUMERIC(10, 2) NOT NULL,
    FullSensorData TEXT,
    IsCompressed BOOLEAN NOT NULL,
    CompressedSensorData BYTEA
);

CREATE TABLE Warehouse.VehicleTemperatures (
    VehicleTemperatureID BIGSERIAL PRIMARY KEY,  -- BIGSERIAL for auto-incrementing bigint
    VehicleRegistration VARCHAR(20) NOT NULL,
    ChillerSensorNumber INT NOT NULL,
    RecordedWhen timestamptz NOT NULL,
    Temperature NUMERIC(10, 2) NOT NULL,
    FullSensorData TEXT,  -- TEXT for longer strings
    IsCompressed BOOLEAN NOT NULL,
    CompressedSensorData BYTEA -- BYTEA for binary data
);

CREATE TABLE Website.VehicleTemperatures (
    VehicleTemperatureID BIGSERIAL PRIMARY KEY,
    VehicleRegistration VARCHAR(20) NOT NULL,
    ChillerSensorNumber INT NOT NULL,
    RecordedWhen timestamptz NOT NULL,
    Temperature NUMERIC(10, 2) NOT NULL,
    FullSensorData TEXT,
    IsCompressed BOOLEAN NOT NULL,
    CompressedSensorData BYTEA
);

CREATE TABLE Application.TransactionTypes_Archive (
    TransactionTypeID INTEGER NOT NULL,
    TransactionTypeName VARCHAR(50) NOT NULL,
    LastEditedBy INTEGER NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE NOT NULL
);
CREATE INDEX ix_TransactionTypes_Archive ON Application.TransactionTypes_Archive (ValidTo, ValidFrom);

CREATE TABLE Application.TransactionTypes (
    TransactionTypeID INTEGER PRIMARY KEY NOT NULL,
    TransactionTypeName VARCHAR(50) NOT NULL,
    LastEditedBy INTEGER NOT NULL,
    ValidFrom TIMESTAMP WITH TIME ZONE  NOT NULL,
    ValidTo TIMESTAMP WITH TIME ZONE  NOT NULL
   
);

CREATE TABLE Application.SystemParameters (
    SystemParameterID INTEGER NOT NULL,
    DeliveryAddressLine1 VARCHAR(60) NOT NULL,
    DeliveryAddressLine2 VARCHAR(60) NULL,
    DeliveryCityID INTEGER NOT NULL,
    DeliveryPostalCode VARCHAR(10) NOT NULL,
    DeliveryLocation POLYGON NOT NULL,  -- Geography type
    PostalAddressLine1 VARCHAR(60) NOT NULL,
    PostalAddressLine2 VARCHAR(60) NULL,
    PostalCityID INTEGER NOT NULL,
    PostalPostalCode VARCHAR(10) NOT NULL,
    ApplicationSettings TEXT NOT NULL,      -- nvarchar(max) equivalent
    LastEditedBy INTEGER NOT NULL,
    LastEditedWhen TIMESTAMP WITH TIME ZONE NOT NULL, -- datetime2 equivalent
    CONSTRAINT PK_Application_SystemParameters PRIMARY KEY (SystemParameterID) -- No CLUSTERED
);
CREATE TABLE Purchasing.PurchaseOrderLines (
    PurchaseOrderLineID INTEGER NOT NULL,
    PurchaseOrderID INTEGER NOT NULL,
    StockItemID INTEGER NOT NULL,
    OrderedOuters INTEGER NOT NULL,
    Description VARCHAR(100) NOT NULL,
    ReceivedOuters INTEGER NOT NULL,
    PackageTypeID INTEGER NOT NULL,
    ExpectedUnitPricePerOuter NUMERIC(18, 2) NULL,  -- Decimal equivalent
    LastReceiptDate DATE NULL,
    IsOrderLineFinalized BOOLEAN NOT NULL,        -- Bit equivalent
    LastEditedBy INTEGER NOT NULL,
    LastEditedWhen TIMESTAMP WITH TIME ZONE NOT NULL, -- Datetime2 equivalent
    CONSTRAINT PK_Purchasing_PurchaseOrderLines PRIMARY KEY (PurchaseOrderLineID) -- No CLUSTERED
);

CREATE TABLE Purchasing.PurchaseOrders (
    PurchaseOrderID INTEGER NOT NULL,
    SupplierID INTEGER NOT NULL,
    OrderDate DATE NOT NULL,
    DeliveryMethodID INTEGER NOT NULL,
    ContactPersonID INTEGER NOT NULL,
    ExpectedDeliveryDate DATE NULL,
    SupplierReference VARCHAR(20) NULL,
    IsOrderFinalized BOOLEAN NOT NULL,       -- Bit equivalent
    Comments TEXT NULL,                      -- nvarchar(max) equivalent
    InternalComments TEXT NULL,              -- nvarchar(max) equivalent
    LastEditedBy INTEGER NOT NULL,
    LastEditedWhen TIMESTAMP WITH TIME ZONE NOT NULL, -- datetime2 equivalent
    CONSTRAINT PK_Purchasing_PurchaseOrders PRIMARY KEY (PurchaseOrderID)  -- No CLUSTERED
);
CREATE TABLE Purchasing.SupplierTransactions (
    SupplierTransactionID INTEGER NOT NULL,
    SupplierID INTEGER NOT NULL,
    TransactionTypeID INTEGER NOT NULL,
    PurchaseOrderID INTEGER NULL,
    PaymentMethodID INTEGER NULL,
    SupplierInvoiceNumber VARCHAR(20) NULL,
    TransactionDate DATE NOT NULL,
    AmountExcludingTax NUMERIC(18, 2) NOT NULL,
    TaxAmount NUMERIC(18, 2) NOT NULL,
    TransactionAmount NUMERIC(18, 2) NOT NULL,
    OutstandingBalance NUMERIC(18, 2) NOT NULL,
    FinalizationDate DATE NULL,
    IsFinalized BOOLEAN GENERATED ALWAYS AS (CASE WHEN FinalizationDate IS NULL THEN FALSE ELSE TRUE END) STORED,  -- Computed/Generated column
    LastEditedBy INTEGER NOT NULL,
    LastEditedWhen TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT PK_Purchasing_SupplierTransactions PRIMARY KEY (SupplierTransactionID) -- No NONCLUSTERED
);

CREATE INDEX idx_SupplierTransactions_TransactionDate ON Purchasing.SupplierTransactions (TransactionDate);

CREATE TABLE Sales.CustomerTransactions (
    CustomerTransactionID INTEGER NOT NULL,
    CustomerID INTEGER NOT NULL,
    TransactionTypeID INTEGER NOT NULL,
    InvoiceID INTEGER NULL,
    PaymentMethodID INTEGER NULL,
    TransactionDate DATE NOT NULL,
    AmountExcludingTax NUMERIC(18, 2) NOT NULL,
    TaxAmount NUMERIC(18, 2) NOT NULL,
    TransactionAmount NUMERIC(18, 2) NOT NULL,
    OutstandingBalance NUMERIC(18, 2) NOT NULL,
    FinalizationDate DATE NULL,
    IsFinalized BOOLEAN GENERATED ALWAYS AS (CASE WHEN FinalizationDate IS NULL THEN FALSE ELSE TRUE END) STORED,  -- Computed column
    LastEditedBy INTEGER NOT NULL,
    LastEditedWhen TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT PK_Sales_CustomerTransactions PRIMARY KEY (CustomerTransactionID) -- No NONCLUSTERED
);

CREATE INDEX idx_CustomerTransactions_TransactionDate ON Sales.CustomerTransactions (TransactionDate);

CREATE TABLE Sales.InvoiceLines (
    InvoiceLineID INTEGER NOT NULL,
    InvoiceID INTEGER NOT NULL,
    StockItemID INTEGER NOT NULL,
    Description VARCHAR(100) NOT NULL,
    PackageTypeID INTEGER NOT NULL,
    Quantity INTEGER NOT NULL,
    UnitPrice NUMERIC(18, 2) NULL,
    TaxRate NUMERIC(18, 3) NOT NULL,
    TaxAmount NUMERIC(18, 2) NOT NULL,
    LineProfit NUMERIC(18, 2) NOT NULL,
    ExtendedPrice NUMERIC(18, 2) NOT NULL,
    LastEditedBy INTEGER NOT NULL,
    LastEditedWhen TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT PK_Sales_InvoiceLines PRIMARY KEY (InvoiceLineID)  -- No CLUSTERED
);


CREATE TABLE Sales.Invoices (
    InvoiceID INTEGER NOT NULL,
    CustomerID INTEGER NOT NULL,
    BillToCustomerID INTEGER NOT NULL,
    OrderID INTEGER NULL,
    DeliveryMethodID INTEGER NOT NULL,
    ContactPersonID INTEGER NOT NULL,
    AccountsPersonID INTEGER NOT NULL,
    SalespersonPersonID INTEGER NOT NULL,
    PackedByPersonID INTEGER NOT NULL,
    InvoiceDate DATE NOT NULL,
    CustomerPurchaseOrderNumber VARCHAR(20) NULL,
    IsCreditNote BOOLEAN NOT NULL,        -- Bit equivalent
    CreditNoteReason TEXT NULL,            -- nvarchar(max) equivalent
    Comments TEXT NULL,                    -- nvarchar(max) equivalent
    DeliveryInstructions TEXT NULL,        -- nvarchar(max) equivalent
    InternalComments TEXT NULL,            -- nvarchar(max) equivalent
    TotalDryItems INTEGER NOT NULL,
    TotalChillerItems INTEGER NOT NULL,
    DeliveryRun VARCHAR(5) NULL,
    RunPosition VARCHAR(5) NULL,
    ReturnedDeliveryData TEXT NULL,        -- nvarchar(max) equivalent
    ConfirmedDeliveryTime TIMESTAMP,
    ConfirmedReceivedBy TEXT,
    LastEditedBy INTEGER NOT NULL,
    LastEditedWhen TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT PK_Sales_Invoices PRIMARY KEY (InvoiceID)  -- No CLUSTERED
);

CREATE TABLE Sales.OrderLines (
    OrderLineID INTEGER NOT NULL,
    OrderID INTEGER NOT NULL,
    StockItemID INTEGER NOT NULL,
    Description VARCHAR(100) NOT NULL,
    PackageTypeID INTEGER NOT NULL,
    Quantity INTEGER NOT NULL,
    UnitPrice NUMERIC(18, 2) NULL,
    TaxRate NUMERIC(18, 3) NOT NULL,
    PickedQuantity INTEGER NOT NULL,
    PickingCompletedWhen TIMESTAMP WITH TIME ZONE NULL,
    LastEditedBy INTEGER NOT NULL,
    LastEditedWhen TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT PK_Sales_OrderLines PRIMARY KEY (OrderLineID)  -- No CLUSTERED
);

CREATE TABLE Sales.Orders (
    OrderID INTEGER NOT NULL,
    CustomerID INTEGER NOT NULL,
    SalespersonPersonID INTEGER NOT NULL,
    PickedByPersonID INTEGER NULL,
    ContactPersonID INTEGER NOT NULL,
    BackorderOrderID INTEGER NULL,
    OrderDate DATE NOT NULL,
    ExpectedDeliveryDate DATE NOT NULL,
    CustomerPurchaseOrderNumber VARCHAR(20) NULL,
    IsUndersupplyBackordered BOOLEAN NOT NULL,  -- Bit equivalent
    Comments TEXT NULL,                      -- nvarchar(max) equivalent
    DeliveryInstructions TEXT NULL,          -- nvarchar(max) equivalent
    InternalComments TEXT NULL,              -- nvarchar(max) equivalent
    PickingCompletedWhen TIMESTAMP WITH TIME ZONE NULL, -- datetime2 equivalent
    LastEditedBy INTEGER NOT NULL,
    LastEditedWhen TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT PK_Sales_Orders PRIMARY KEY (OrderID)  -- No CLUSTERED
);


CREATE TABLE Sales.SpecialDeals (
    SpecialDealID INTEGER NOT NULL,
    StockItemID INTEGER NULL,
    CustomerID INTEGER NULL,
    BuyingGroupID INTEGER NULL,
    CustomerCategoryID INTEGER NULL,
    StockGroupID INTEGER NULL,
    DealDescription VARCHAR(30) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    DiscountAmount NUMERIC(18, 2) NULL,
    DiscountPercentage NUMERIC(18, 3) NULL,
    UnitPrice NUMERIC(18, 2) NULL,
    LastEditedBy INTEGER NOT NULL,
    LastEditedWhen TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT PK_Sales_SpecialDeals PRIMARY KEY (SpecialDealID)  -- No CLUSTERED
);

CREATE TABLE Warehouse.StockItemHoldings (
    StockItemID INTEGER NOT NULL,
    QuantityOnHand INTEGER NOT NULL,
    BinLocation VARCHAR(20) NOT NULL,
    LastStocktakeQuantity INTEGER NOT NULL,
    LastCostPrice NUMERIC(18, 2) NOT NULL,
    ReorderLevel INTEGER NOT NULL,
    TargetStockLevel INTEGER NOT NULL,
    LastEditedBy INTEGER NOT NULL,
    LastEditedWhen TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT PK_Warehouse_StockItemHoldings PRIMARY KEY (StockItemID)  -- No CLUSTERED
);


CREATE TABLE Warehouse.StockItemStockGroups (
    StockItemStockGroupID INTEGER NOT NULL,
    StockItemID INTEGER NOT NULL,
    StockGroupID INTEGER NOT NULL,
    LastEditedBy INTEGER NOT NULL,
    LastEditedWhen TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT PK_Warehouse_StockItemStockGroups PRIMARY KEY (StockItemStockGroupID),  -- No CLUSTERED
    CONSTRAINT UQ_StockItemStockGroups_StockGroupID_Lookup UNIQUE (StockGroupID, StockItemID), -- No NONCLUSTERED
    CONSTRAINT UQ_StockItemStockGroups_StockItemID_Lookup UNIQUE (StockItemID, StockGroupID)  -- No NONCLUSTERED
);

CREATE TABLE Warehouse.StockItemTransactions (
    StockItemTransactionID INTEGER NOT NULL,
    StockItemID INTEGER NOT NULL,
    TransactionTypeID INTEGER NOT NULL,
    CustomerID INTEGER NULL,
    InvoiceID INTEGER NULL,
    SupplierID INTEGER NULL,
    PurchaseOrderID INTEGER NULL,
    TransactionOccurredWhen TIMESTAMP WITH TIME ZONE NOT NULL,
    Quantity NUMERIC(18, 3) NOT NULL,
    LastEditedBy INTEGER NOT NULL,
    LastEditedWhen TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT PK_Warehouse_StockItemTransactions PRIMARY KEY (StockItemTransactionID)  -- No NONCLUSTERED
);
CREATE TABLE application.system_parameters (
    system_parameter_id SERIAL PRIMARY KEY,
    parameter_name VARCHAR(255) NOT NULL,
    parameter_value TEXT,
    numeric_value NUMERIC(10, 2),  -- Example: a number with 10 digits, 2 after the decimal
    is_active BOOLEAN DEFAULT TRUE, -- Example: a boolean column with a default value
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE
);


CREATE TABLE purchasing.purchase_order_lines (
    purchase_order_line_id SERIAL PRIMARY KEY,
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(10, 2),
    line_total NUMERIC(10, 2),
    description TEXT,
    shipping_info JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE
);




