CREATE PROCEDURE [Application].[CreateCustomer]
      @Forename VARCHAR(50)
    , @Surname VARCHAR(50)
    , @Email VARCHAR(50)
    , @MiddleNames VARCHAR(200) NULL
    , @AccountType VARCHAR(50) NULL
AS
BEGIN TRY
    DECLARE
          @ErrorMessage AS NVARCHAR(2048)
        , @CustomerID AS INT
        , @AccountID AS INT
    BEGIN TRANSACTION
        
        EXEC Accounts.CreateOrUpdateCustomer
              @Forename = @Forename
            , @Surname = @Surname
            , @Email = @Email
            , @MiddleNames = @MiddleNames
            , @CustomerID = @CustomerID OUTPUT;

        IF @AccountType IS NOT NULL
            EXEC Accounts.CreateOrAlterAccount
                  @AccountID = @AccountID OUTPUT
                , @CustomerID = @CustomerID
                , @AccountType = @AccountType;

        IF @AccountType IN ('Standard', 'Premium')
            EXEC Communications.CreateWelcomeMailer
                  @CustomerID = @CustomerID
                , @AccountID = @AccountID;
        

    COMMIT TRANSACTION
END TRY

BEGIN CATCH

    ROLLBACK TRANSACTION

    THROW

END CATCH