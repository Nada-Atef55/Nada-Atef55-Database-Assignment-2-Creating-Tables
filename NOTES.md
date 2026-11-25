1. i created a schema for each business section depending on the SRS
        Members : City, Member, Invitation, Wallet
        WarehousesAndStaff : Warehouse
        Catalogue : Category, Item, ItemPhotos
        AuctionsAndBidding : Auction, Bid, AuctionFollower

2.  GUID for member because business asked for a globally unique id.
    BIGINT for Bida because it is able to grow till billions.
    FLOAT for GPS because it is measurement so the small fractions don't matter.
    DECIMAL for money because it should be accurate.
    DATETIMEOFFSET for auctions because the business needs keeping time zone offset

3.  Warehouse & Member : circular 1:1 for Manager role and 1:M for Employee role
    Member & City : 1:M
    Member & Invitation : 1:M
    Member & Wallet : 1:1
    Warehouse & City : 1:M assumed 
    Item & Category : 1:M 
    Item & Warehouse : 1:M
    Item & Member : 1:1
    Item & Item Photos : 1:M
    Auction & Item : 1:M
    Bid & Member : 1:M
    Bid & Auction : 1:M
    Auction & Member : M:N (followers) 


4. because each table needs the other so i have to create the two tables then add FKs using ALTER

5. sorry i didn't do the bonus task 

6. the error is "the column has enforced dependencies"
   so i dropped the constraints first before anything
   
7. 
    - at index 0 : no prefix , suffix => 24 so the result is 24
    - at index 1 : prefix => 1, suffix => 12 so the result is 12*1 = 12
    - at index 2 : prefix => 2, suffix => 4 so the result is 4*2 = 8
    - at index 3 : prefix => 6, no suffix so the result is 6