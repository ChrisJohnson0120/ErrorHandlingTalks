CREATE PROCEDURE [Communications].[CreateWelcomeMailer]
      @CustomerID INT
    , @AccountID INT
AS
BEGIN TRY
    DECLARE
          @ErrorMessage AS NVARCHAR(2048)
        , @MailingID AS INT
        , @VoucherID AS INT
        , @DateToSend AS DATE = DATEADD(dd, 1, CAST(SYSDATETIME() AS DATE))

    BEGIN TRANSACTION
        
        EXEC Communications.CreateMailing
              @CustomerID = @CustomerID
            , @MailingID = @MailingID OUTPUT
            , @MailingContent = 'Welcome to your new account. Please find attached your welcome voucher.'
            , @DateToSend = @DateToSend;

        EXEC Communications.CreateVoucher
              @VoucherID = @VoucherID
            , @CustomerID = @CustomerID
            , @AccountID = @AccountID
            , @VoucherType = 'Welcome voucher'
            , @MailingID = @MailingID;  

    COMMIT TRANSACTION
END TRY

BEGIN CATCH

    ROLLBACK TRANSACTION

    THROW

END CATCH