CREATE PROCEDURE [Communications].[CreateVoucher]
      @VoucherID INT OUTPUT
    , @CustomerID INT
    , @AccountID INT NULL
    , @VoucherType VARCHAR(50)
    , @MailingID INT NULL
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
        
        IF @AccountID IS NOT NULL
            AND NOT EXISTS
            (
                SELECT
                      *
                FROM Accounts.Account AS Acc
                WHERE 1 = 1
                    AND Acc.AccountID = @AccountID
            )
        BEGIN
            SET @ErrorMessage = CONCAT(N'An account where AccountID = ''',
                                        CAST(@AccountID AS NVARCHAR(20)),
                                        N''' does not exist.');

            THROW 50000, @ErrorMessage, 1;
        END

        IF @MailingID IS NOT NULL
            AND NOT EXISTS
            (
                SELECT
                      *
                FROM Communications.Mailing AS Mail
                WHERE 1 = 1
                    AND Mail.MailingID = @MailingID
            )
        BEGIN
            SET @ErrorMessage = CONCAT(N'A mailing where MailingID = ''',
                                        CAST(@MailingID AS NVARCHAR(20)),
                                        N''' does not exist.');

            THROW 50000, @ErrorMessage, 1;
        END

        SET @StatusID = (SELECT StatLst.StatusID FROM Config.StatusList AS StatLst WHERE StatLst.StatusDescription = 'Not sent');

        SET @VoucherID = NEXT VALUE FOR Communications.VoucherID;

        INSERT INTO Communications.Voucher
            (
                  VoucherID
                , CustomerID
                , AccountID
                , VoucherType
                , VoucherStatusID
                , MailingID
            )
        VALUES
              (@VoucherID, @CustomerID, @AccountID, @VoucherType, @StatusID, @MailingID);
        

    COMMIT TRANSACTION

END TRY

BEGIN CATCH

    ROLLBACK TRANSACTION

    THROW

END CATCH