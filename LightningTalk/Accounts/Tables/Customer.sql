CREATE TABLE [Accounts].[Customer]
(
    [CustomerID] INT NOT NULL  DEFAULT NEXT VALUE FOR Accounts.CustomerID, 
    [Forename] VARCHAR(50) NOT NULL, 
    [Surname] VARCHAR(50) NOT NULL, 
    [Email] VARCHAR(50) NOT NULL, 
    [MiddleNames] VARCHAR(200) NULL, 
    [HasWelcomeVoucher] BIT NOT NULL DEFAULT 'FALSE', 
    CONSTRAINT [PK_Customer] PRIMARY KEY ([CustomerID])
)
