CREATE TABLE [Config].[StatusList]
(
    [StatusID] TINYINT NOT NULL DEFAULT NEXT VALUE FOR Config.StatusID , 
    [StatusDescription] VARCHAR(50) NOT NULL, 
    CONSTRAINT [PK_StatusList] PRIMARY KEY ([StatusID]), 
    CONSTRAINT [CK_StatusList_StatusDescription] CHECK
        (
               StatusDescription = 'Not sent'
            OR StatusDescription = 'Sent'
            OR StatusDescription = 'Error'
        )
)
