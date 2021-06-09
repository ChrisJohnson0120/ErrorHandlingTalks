CREATE TABLE [Accounts].[Account]
(
    [AccountID] INT NOT NULL  DEFAULT NEXT VALUE FOR Accounts.AccountID, 
    [CustomerID] INT NOT NULL, 
    [AccountType] VARCHAR(50) NOT NULL, 
    CONSTRAINT [PK_Account] PRIMARY KEY ([AccountID]), 
    CONSTRAINT [FK_Account_Customer] FOREIGN KEY (CustomerID) REFERENCES Accounts.Customer(CustomerID), 
    CONSTRAINT [CK_Account_AccountType] CHECK (AccountType = 'Basic' OR AccountType = 'Premium')
)
