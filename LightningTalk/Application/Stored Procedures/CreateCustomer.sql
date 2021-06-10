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
        , @TryCounter AS TINYINT = 0
        , @Success AS BIT = 0;

    BEGIN TRANSACTION;
        
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
            WHILE @TryCounter < 3 AND @Success = 0
            BEGIN
                BEGIN TRY
                    EXEC Communications.CreateWelcomeMailer
                          @CustomerID = @CustomerID
                        , @AccountID = @AccountID;
                        
                    UPDATE Cust
                    SET HasWelcomeVoucher = 'TRUE'
                    FROM Accounts.Customer AS Cust
                    WHERE 1 = 1
                        AND Cust.CustomerID = @CustomerID;

                    SET @Success = 1
                END TRY
                BEGIN CATCH
                    SET @TryCounter = @TryCounter + 1;
                END CATCH
            END
        
    COMMIT TRANSACTION;
END TRY

BEGIN CATCH

    ROLLBACK TRANSACTION;

    THROW;

END CATCH