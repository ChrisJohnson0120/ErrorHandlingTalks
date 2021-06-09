CREATE TABLE [Communications].[Mailing]
(
    [MailingID] INT NOT NULL , 
    [CustomerID] INT NOT NULL, 
    [MailingContent] NVARCHAR(MAX) NOT NULL, 
    [DateToSend] DATE NOT NULL, 
    [MailingStatusID] TINYINT NOT NULL, 
    CONSTRAINT [PK_Mailing] PRIMARY KEY ([MailingID]), 
    CONSTRAINT [CK_Mailing_MailingContent] CHECK (ISJSON(MailingContent) = 1), 
    CONSTRAINT [FK_Mailing_Customer] FOREIGN KEY (CustomerID) REFERENCES Accounts.Customer(CustomerID), 
    CONSTRAINT [FK_Mailing_StatusList] FOREIGN KEY (MailingStatusID) REFERENCES Config.StatusList(StatusID)
)
