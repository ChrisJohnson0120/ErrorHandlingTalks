CREATE PROCEDURE [Communications].[CreateMailing]
      @CustomerID INT
    , @MailingID INT OUTPUT
    , @MailingContent NVARCHAR(MAX)
    , @DateToSend DATE
AS
BEGIN TRY
    DECLARE
          @ErrorMessage AS NVARCHAR(2048)
        , @StatusID TINYINT;
    BEGIN TRANSACTION

        IF NOT EXISTS
            (
                SELECT
                      *
                FROM Accounts.Customer AS Cust
                WHERE 1 = 1
                    AND Cust.CustomerID = @CustomerID
            )
        BEGIN
            SET @ErrorMessage = CONCAT(N'A customer record where CustomerID = ''',
                                        CAST(@CustomerID AS NVARCHAR(20)),
                                        N''' does not exist.');

            THROW 50000, @ErrorMessage, 1;
        END

        IF ISJSON(@MailingCOntent) <> 1
        BEGIN
            SET @ErrorMessage = CONCAT(N'Mailing content ''',
                                        CASE
                                            WHEN LEN(@MailingContent) > 2011
                                            THEN CONCAT(LEFT(@MailingContent, 2008), N'...')
                                            ELSE @MailingContent
                                        END,
                                        N''' is not valid JSON.');

            THROW 50000, @ErrorMessage, 1;
        END

        IF @DateToSend < SYSDATETIME()
        BEGIN
            SET @ErrorMessage = CONCAT(N'Mail send date ''',
                                        CAST(@DateToSend AS NVARCHAR(20)),
                                        N''' is in the past.');

            THROW 50000, @ErrorMessage, 1;
        END

        SET @StatusID = (SELECT StatLst.StatusID FROM Config.StatusList AS StatLst WHERE StatLst.StatusDescription = 'Not sent');

        SET @MailingID = NEXT VALUE FOR Communications.MailingID;

        INSERT INTO Communications.Mailing
            (
                  MailingID
                , CustomerID
                , MailingContent
                , DateToSend
                , MailingStatusID
            )
        VALUES
              (@MailingID, @CustomerID, @MailingContent, @DateToSend, @StatusID);
        

    COMMIT TRANSACTION

END TRY

BEGIN CATCH

    ROLLBACK TRANSACTION

    THROW

END CATCH