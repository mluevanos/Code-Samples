

-- CRUD Examples --


-- CREATE --


ALTER PROC [dbo].[Venues_Insert]
			@Name NVARCHAR(255)
           , @Description NVARCHAR(4000)
           , @LocationId INT
           , @Url NVARCHAR(255)
           , @CreatedBy INT
           , @ModifiedBy INT
		   , @Id INT OUTPUT
AS

/*
	DECLARE @Id int = 0

	DECLARE 
		@Name NVARCHAR(255) = 'Disneyland'
		,@Description NVARCHAR(4000) = 'Happiest place on earth'
		,@LocationId INT = 5
		,@Url NVARCHAR(255) = 'https://disneyland.disney.go.com/'
		,@CreatedBy INT = '1'
		,@ModifiedBy INT = '1'


	EXECUTE dbo.Venues_Insert
		@Name
		,@Description
		,@LocationId
		,@Url
		,@CreatedBy
		,@ModifiedBy
		,@Id OUTPUT

Select *
	From dbo.Venues
	Where Id = @Id
*/

BEGIN

	INSERT INTO [dbo].[Venues]
			   ([Name]
			   ,[Description]
			   ,[LocationId]
			   ,[Url]
			   ,[CreatedBy]
			   ,[ModifiedBy])
     VALUES
           (@Name
           , @Description
           , @LocationId
           , @Url
           , @CreatedBy
           , @ModifiedBy)

	SET @Id = SCOPE_IDENTITY()
	  
END


-- READ by ID --


ALTER PROC [dbo].[Venues_Select_ById]
		@Id INT
as

/*
	DECLARE @Id int = 1

	EXECUTE dbo.Venues_Select_ById @Id
*/

BEGIN

SELECT [Id]
		, [Name]
		, [Description]
		, [LocationId]
		, [Url]
		, [CreatedBy]
		, [ModifiedBy]
		, [DateCreated]
		, [DateModified]

FROM dbo.Venues

WHERE Id = @Id

END


-- READ All w/ Pagination --


ALTER PROC [dbo].[Venues_SelectAll_V2]
			@pageIndex INT
			,@pageSize INT

as

/*
	DECLARE
		@_PageIndex int = 0
		,@_PageSize int = 10

	EXECUTE dbo.Venues_SelectAllPaginated 
		@_pageIndex
		,@_pageSize
*/

BEGIN

	DECLARE @Offset int = @pageIndex * @pageSize

	SELECT	[Id]
			,[Name]
			,[Description]
			,[LocationId]
			,[Url]
			,[CreatedBy]
			,[ModifiedBy]
			,[DateCreated]
			,[DateModified]
			,[TotalCount] = COUNT(1) OVER()
	  FROM	[dbo].[Venues]

	  ORDER BY Id
	  OFFSET @Offset ROWS
	  FETCH NEXT @pageSize ROWS only

END


-- UPDATE --


ALTER PROC [dbo].[Venues_Update]

			@Name NVARCHAR(255)
           , @Description NVARCHAR(4000)
           , @LocationId INT
           , @Url NVARCHAR(255)
           , @ModifiedBy INT
		   , @Id INT 

AS

/* 
	DECLARE @Id int = 4

	DECLARE
			@Name NVARCHAR(255) = 'Mall of America'
           , @Description NVARCHAR(4000) = 'The largest shopping mall in north america'
           , @LocationId INT = 10
           , @Url NVARCHAR(255) = 'https://www.mallofamerica.com/'
           , @ModifiedBy INT = 456

	Execute dbo.Venues_Select_ById @Id

	EXECUTE dbo.Venues_Update
				@Name
			   , @Description
			   , @LocationId
			   , @Url
			   , @ModifiedBy
			   , @Id

	Execute dbo.Venues_Select_ById @Id
*/

BEGIN

	DECLARE @DateNow datetime2 = GETUTCDATE()

	UPDATE [dbo].[Venues]
	   SET [Name] = @Name
		  ,[Description] = @Description
		  ,[LocationId] = @LocationId
		  ,[Url] = @Url
		  ,[ModifiedBy] = @ModifiedBy
		  ,[DateModified] = @DateNow

	 WHERE Id = @Id

END


-- DELETE --


ALTER PROC [dbo].[Venues_Delete_ById]
			@Id INT
AS

/*
Declare @Id int = 10

SELECT *
FROM dbo.Venues
WHERE Id = @Id

EXECUTE dbo.Venues_Delete_ById @Id

SELECT *
FROM dbo.Venues
WHERE Id = @Id
*/

BEGIN 

DELETE FROM dbo.Venues
WHERE Id = @Id

END