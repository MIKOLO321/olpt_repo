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