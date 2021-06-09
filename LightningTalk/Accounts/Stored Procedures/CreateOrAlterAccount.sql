CREATE PROCEDURE [Accounts].[CreateOrAlterAccount]
      @AccountID INT NULL OUTPUT
    , @CustomerID INT NULL
    , @AccountType VARCHAR(50)
AS
BEGIN TRY
    DECLARE @ErrorMessage AS NVARCHAR(2048)
    BEGIN TRANSACTION

        IF (@CustomerID IS NOT NULL
            AND NOT EXISTS
            (
                SELECT
                      *
                FROM Accounts.Customer AS Cust
                WHERE 1 = 1
                    AND Cust.CustomerID = @CustomerID
            ))
        BEGIN
            SET @ErrorMessage = CONCAT(N'CustomerID ''',
                                        @CustomerID,
                                        N''' does not exist.');

            THROW 50000, @ErrorMessage, 1;
        END

        IF @AccountID IS NOT NULL
            UPDATE Acc
            SET
                  @AccountType = @AccountType
            FROM Accounts.Account AS Acc
            WHERE 1 = 1
                AND Acc.AccountID = @AccountID;

        IF @AccountID IS NULL
        BEGIN
            SET @AccountID = NEXT VALUE FOR Accounts.AccountID;

            INSERT INTO Accounts.Account
                (
                      AccountID
                    , AccountType
                    , CustomerID
                )
            VALUES
                  (@AccountID, @AccountType, @CustomerID);
        END
            

    COMMIT TRANSACTION

END TRY

BEGIN CATCH

    ROLLBACK TRANSACTION

    THROW

END CATCH
