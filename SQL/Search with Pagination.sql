
-- SEARCH w/ Pagination--

ALTER PROC [dbo].[Notes_SearchBySeekerNameV2]
	@ProviderId INT,
	@SearchQ NVARCHAR(100),
	@PageIndex INT,
	@PageSize INT

AS

/*
DECLARE @ProviderId INT = 2,
		@SearchQ NVARCHAR(100) = 'a',
		@PageIndex INT = 0,
		@PageSize INT = 10

EXECUTE [dbo].[Notes_SearchBySeekerNameV2] @ProviderId,
	@SearchQ,
	@PageIndex,
	@PageSize
*/

BEGIN 

	DECLARE @Offset INT = @PageIndex * @PageSize

	SELECT   N.Id
			, [SeekerFirstName] = Upr.[FirstName]
			, [SeekerLastName] = Upr.[LastName]
			, N.CreatedBy
			, N.Notes
			, N.TagId
			, N.DateCreated
			, [TotalCount] = COUNT(1) OVER()

	FROM dbo.Notes AS N
	INNER JOIN dbo.UserProfiles AS Upr
	ON N.SeekerId = Upr.UserId
	
	WHERE CreatedBy = @ProviderId
	AND (Upr.[FirstName] Like '%' + @SearchQ + '%'
		OR Upr.[LastName] LIKE '%' +  @SearchQ + '%')

	ORDER BY N.DateCreated

	OFFSET @Offset ROWS
	FETCH NEXT @PageSize ROWS ONLY


END