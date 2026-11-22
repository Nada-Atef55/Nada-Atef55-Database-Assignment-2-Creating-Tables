CREATE DATABASE BidNileDB
GO

CREATE SCHEMA Members
GO

CREATE TABLE Members.City
(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	Name NVARCHAR(60) NOT NULL,
	Code CHAR(2) NOT NULL,

	CONSTRAINT UQ_City_Name_Code UNIQUE(Name, Code)
)


CREATE TABLE Members.Member
(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	MemberID UNIQUEIDENTIFIER NOT NULL
		CONSTRAINT DF_Member_MemberID DEFAULT NEWID(),
	FullName NVARCHAR(100) NOT NULL,
	Email VARCHAR(254) NOT NULL
		CONSTRAINT UQ_Member_Email UNIQUE,
	Phone VARCHAR(16) NOT NULL,
	NationalID VARCHAR(20) NULL
		CONSTRAINT UQ_Member_NationalID UNIQUE,
	PassportNumber VARCHAR(20) NULL
		CONSTRAINT UQ_Member_PassportNumber UNIQUE,
	Age INT NOT NULL 
		CONSTRAINT CK_Member_Age CHECK(Age >= 18),
	BirthDate DATE NOT NULL,
	IsVerified BIT NOT NULL
		CONSTRAINT DF_Member_IsVerified DEFAULT 0,
	RegisterdAt DATETIME2(3) NOT NULL,
	CityId INT NOT NULL,  -- FK to City
	WarehouseId INT NOT NULL -- FK to Warehouse

)


CREATE TABLE Members.Invitation
(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	InvitationFrom INT NOT NULL, -- FK to Member
	InvitationTo INT NOT NULL  -- FK to Member
		CONSTRAINT UQ_Invitation_InvitationTo UNIQUE
)


CREATE TABLE Members.Wallet
(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	Balance DECIMAL(12, 2) NOT NULL
		CONSTRAINT DF_Wallet_Balance DEFAULT 0
		CONSTRAINT CK_Wallet_Balance CHECK(Balance >= 0),
	liveBidsAmount DECIMAL (12, 2),
	Currency CHAR(3) NOT NULL
		CONSTRAINT DF_Wallet_Currency DEFAULT 'EGY',
	UpdatedAt DATETIME2(0) NULL,
	MemberId INT NOT NULL  -- FK to Member
		CONSTRAINT UQ_Wallet_MemberId UNIQUE,
		
	CONSTRAINT CK_Wallet_liveBidsAmount CHECK(liveBidsAmount >= 0 AND liveBidsAmount <= Balance)

)

GO
CREATE SCHEMA WarehousesAndStaff

CREATE TABLE WarehousesAndStaff.Warehouse
(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	Name NVARCHAR(80) NOT NULL
		CONSTRAINT UQ_Warehouse_Name UNIQUE,
	Capacity INT NOT NULL
		CONSTRAINT CK_Warehouse_Capacity CHECK(Capacity > 0),
	CityId INT NOT NULL,  -- FK to City
	GPS FLOAT NOT NULL, 
	Latitude REAL NOT NULL
		CONSTRAINT CK_Warehouse_Latitude CHECK(Latitude >= -90 AND Latitude <= 90),
	Longitude REAL NOT NULL
		CONSTRAINT CK_Warehouse_Longitude CHECK(Longitude >= -180 AND Longitude <= 180),
	ManagerId INT NOT NULL  -- FK to Member
		CONSTRAINT UQ_Warehouse_ManagerId UNIQUE,
	StartedManagingAt DATETIME2 NOT NULL 
)

GO
CREATE SCHEMA Catalogue

CREATE TABLE Catalogue.Category
(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	Code INT NOT NULL,
	EnglishName VARCHAR(50) NOT NULL
		CONSTRAINT UQ_Category_EnglishName UNIQUE,
	ArabicName NVARCHAR(50) NOT NULL
		CONSTRAINT UQ_Category_ArabicName UNIQUE,
	Commission DECIMAL(4, 2) NOT NULL
		CONSTRAINT CK_Category_Commission CHECK(Commission >= 0 AND Commission <= 30)
)


CREATE TABLE Catalogue.Item
(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	Title NVARCHAR(150) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	Score INT NOT NULL
		CONSTRAINT CK_Item_Score CHECK(Score >= 0 AND Score <= 10),
	Specifications NVARCHAR(MAX) NOT NULL, 
		CONSTRAINT CK_Item_Specifications CHECK(ISJSON(Specifications) = 1), 
	CreatedAt DATETIME2 NOT NULL,
	WarehouseId INT NULL,  -- FK to Warehouse
	SellerId INT NOT NULL,  -- FK to Member
	InspectorId INT NOT NULL,  -- FK to Member
	CategoryId INT NOT NULL,  -- FK to Category

	CONSTRAINT CK_Item_SellerId_InspectorId CHECK(SellerId != InspectorId)
)


CREATE TABLE Catalogue.ItemPhotos
(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	ItemId INT NOT NULL,  -- FK to Item
	Position INT NOT NULL
		CONSTRAINT CK_ItemPhotos_Position CHECK(Position >= 1 AND Position <= 20),
	URL VARCHAR(500) NOT NULL,
	IsMain BIT NOT NULL
		CONSTRAINT DF_ItemPhotos_IsMain DEFAULT 0,

	CONSTRAINT UQ_ItemPhotos_ItemId_Position UNIQUE(ItemId, Position)
)


GO
CREATE SCHEMA AuctionsAndBidding

CREATE TABLE AuctionsAndBidding.Auction
(
	Id INT IDENTITY PRIMARY KEY,
	ItemId INT NOT NULL,  -- FK to Item
	StartPrice DECIMAL NOT NULL,
	ReservePrice DECIMAL NOT NULL,
	BidIncrement DECIMAL(4, 2) NOT NULL
		CONSTRAINT DF_Auction_BidIncrement DEFAULT 50.00,
	StartDate DATETIMEOFFSET NOT NULL,
	EndDate DATETIMEOFFSET NOT NULL,
	Status VARCHAR(10) NOT NULL
		CONSTRAINT DF_Auction_Status DEFAULT 'Draft',


	CONSTRAINT CK_Auction_StartPrice CHECK(StartPrice >= 0 AND ReservePrice >= StartPrice),
	CONSTRAINT CK_Auction_StartDate_EndDate CHECK(StartDate < EndDate)
)

GO

CREATE TABLE AuctionsAndBidding.Bid
(
	Id BIGINT IDENTITY PRIMARY KEY,
	MemberId INT NOT NULL, -- FK to Member
	AuctionId INT NOT NULL,  -- FK to Auction
	Amount DECIMAL NOT NULL
		CONSTRAINT CK_Bid_Amount CHECK(Amount >= 0),
	CreatedAt DATETIME2(3) NOT NULL,
	IPAddress VARCHAR(45) NOT NULL,

	CONSTRAINT UQ_Bid_AuctionId_Amount UNIQUE(Amount, AuctionId)
)


CREATE TABLE AuctionsAndBidding.AuctionFollower
(
	Id BIGINT IDENTITY PRIMARY KEY,
	MemberId INT NOT NULL,  -- FK to Member
	AuctionId INT NOT NULL,  -- FK to Auction
	StartFollowingAt DATETIME2(3) NOT NULL,
	
	CONSTRAINT UQ_AuctionFollower_AuctionId_MemberId UNIQUE(MemberId, AuctionId)
)


-- Task 3.1
ALTER TABLE Members.Member
ADD CONSTRAINT FK_Member_CityId 
FOREIGN KEY (CityId) REFERENCES Members.City(Id)


ALTER TABLE Members.Member
ADD CONSTRAINT FK_Member_WarehouseId
FOREIGN KEY (WarehouseId) REFERENCES WarehousesAndStaff.Warehouse(Id)


ALTER TABLE Members.Invitation
ADD CONSTRAINT FK_Invitation_InvitationFrom
FOREIGN KEY (InvitationFrom) REFERENCES Members.Member(Id)


ALTER TABLE Members.Invitation
ADD CONSTRAINT FK_Invitation_InvitationTo
FOREIGN KEY (InvitationTo) REFERENCES Members.Member(Id)


ALTER TABLE Members.Wallet
ADD CONSTRAINT FK_Wallet_MemberId
FOREIGN KEY (MemberId) REFERENCES Members.Member(Id)


ALTER TABLE WarehousesAndStaff.Warehouse
ADD CONSTRAINT FK_Warehouse_ManagerId
FOREIGN KEY (ManagerId) REFERENCES Members.Member(Id)


ALTER TABLE WarehousesAndStaff.Warehouse
ADD CONSTRAINT FK_Warehouse_CityId
FOREIGN KEY (CityId) REFERENCES Members.City(Id)


ALTER TABLE Catalogue.Item
ADD CONSTRAINT FK_Item_WarehouseId
FOREIGN KEY (WarehouseId) REFERENCES WarehousesAndStaff.Warehouse(Id)


ALTER TABLE Catalogue.Item
ADD CONSTRAINT FK_Item_SellerId
FOREIGN KEY (SellerId) REFERENCES Members.Member(Id)


ALTER TABLE Catalogue.Item
ADD CONSTRAINT FK_Item_InspectorId
FOREIGN KEY (InspectorId) REFERENCES Members.Member(Id)


ALTER TABLE Catalogue.Item
ADD CONSTRAINT FK_Item_CategoryId
FOREIGN KEY (CategoryId) REFERENCES Catalogue.Category(Id)


ALTER TABLE Catalogue.ItemPhotos
ADD CONSTRAINT FK_ItemPhotos_ItemId
FOREIGN KEY (ItemId) REFERENCES Catalogue.Item(Id)
ON DELETE CASCADE


ALTER TABLE AuctionsAndBidding.Auction
ADD CONSTRAINT FK_Auction_ItemId
FOREIGN KEY (ItemId) REFERENCES Catalogue.Item(Id)


ALTER TABLE AuctionsAndBidding.Bid
ADD CONSTRAINT FK_Bid_MemberId
FOREIGN KEY (MemberId) REFERENCES Members.Member(Id)


ALTER TABLE AuctionsAndBidding.Bid
ADD CONSTRAINT FK_Bid_AuctionId
FOREIGN KEY (AuctionId) REFERENCES AuctionsAndBidding.Auction(Id)


ALTER TABLE AuctionsAndBidding.AuctionFollower
ADD CONSTRAINT FK_AuctionFollower_MemberId
FOREIGN KEY (MemberId) REFERENCES Members.Member(Id)


ALTER TABLE AuctionsAndBidding.AuctionFollower
ADD CONSTRAINT FK_AuctionFollower_AuctionId
FOREIGN KEY (AuctionId) REFERENCES AuctionsAndBidding.Auction(Id)



