CREATE PROCEDURE [Accounts].[CreateOrUpdateCustomer]
      @Forename VARCHAR(50)
    , @Surname VARCHAR(50)
    , @Email VARCHAR(50)
    , @MiddleNames VARCHAR(200) NULL
    , @CustomerID INT NULL OUTPUT
AS
BEGIN TRY
    DECLARE @ErrorMessage AS NVARCHAR(2048)
    BEGIN TRANSACTION
        
        IF (@CustomerID IS NULL
            AND EXISTS
                (
                    SELECT
                          *
                    FROM Accounts.Customer AS Cust
                    WHERE 1 = 1
                        AND Cust.Email = @Email
                ))
        BEGIN
            SET @ErrorMessage = CONCAT(N'No CustomerID was supplied, but there is already a customer with an email address of: ''',
                                        @Email,
                                        N'''.');

            THROW 50000, @ErrorMessage, 1;
        END

        IF @Email NOT LIKE '%@%.%'
        BEGIN
            SET @ErrorMessage = CONCAT(N'Email ''',
                                        @Email,
                                        N''' is not correctly formatted');

            THROW 50000, @ErrorMessage, 1;
        END

        IF @CustomerID IS NOT NULL
            UPDATE Cust
            SET
                  Forename = @Forename
                , Surname = @Surname
                , @Email = @Email
                , @MiddleNames = @MiddleNames
            FROM Accounts.Customer AS Cust
            WHERE 1 = 1
                AND Cust.CustomerID = @CustomerID;

        IF @CustomerID IS NULL
        BEGIN
            SET @CustomerID = NEXT VALUE FOR Accounts.CustomerID;

            INSERT INTO Accounts.Customer
                (
                      CustomerID
                    , Forename
                    , Surname
                    , Email
                    , MiddleNames
                )
            VALUES
                  (@CustomerID, @Forename, @Surname, @Email, @MiddleNames);
        END

    COMMIT TRANSACTION
END TRY

BEGIN CATCH

    ROLLBACK TRANSACTION

    THROW

END CATCH