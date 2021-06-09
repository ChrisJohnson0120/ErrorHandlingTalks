CREATE TABLE [Communications].[Voucher]
(
    [VoucherID] INT NOT NULL PRIMARY KEY DEFAULT NEXT VALUE FOR Communications.VoucherID, 
    [CustomerID] INT NOT NULL, 
    [AccountID] INT NULL, 
    [VoucherType] VARCHAR(50) NOT NULL, 
    [VoucherStatusID] TINYINT NOT NULL, 
    [MailingID] INT NULL, 
    CONSTRAINT [FK_Voucher_Mailing] FOREIGN KEY (MailingID) REFERENCES Communications.Mailing(MailingID), 
    CONSTRAINT [FK_Voucher_Account] FOREIGN KEY (AccountID) REFERENCES Accounts.Account(AccountID), 
    CONSTRAINT [FK_Voucher_Customer] FOREIGN KEY (CustomerID) REFERENCES Accounts.Customer(CustomerID)
)
