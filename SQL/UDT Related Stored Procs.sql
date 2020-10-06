
-- Using UDTs --

-- INSERT batch to UDT and table --

ALTER PROC [dbo].[Skills_InsertBatch]
			@newSkills dbo.SkillsUDT READONLY

AS

/*
Select *
FROM dbo.Skills

Declare @newSkills dbo.SkillsUDT

INSERT INTO @newSkills 
				([Name])
VALUES ('SQL')

INSERT INTO @newSkills 
				([Name])
VALUES ('Javascript')

INSERT INTO @newSkills 
				([Name])
VALUES ('Chomp')

Execute dbo.Skills_InsertBatch @newSkills

Select *
FROM dbo.Skills
*/

BEGIN

	INSERT into dbo.Skills ([Name])

	SELECT n.[Name]
	FROM @newSkills as n
	WHERE NOT EXISTS (SELECT [Name]
						FROM dbo.Skills as s
						WHERE s.[Name] = n.[Name])

END


-- UPDATE batch to UDT and table --


ALTER PROC [dbo].[Skills_UpdateBatch]
		@newSkills dbo.SkillsUDT READONLY

AS

/*
Select *
From dbo.Skills

Declare @newSkills dbo.SkillsUDT

INSERT INTO @newSkills
			([Name])
VALUES ('SQL server')

INSERT INTO @newSkills
			([Name])
VALUES ('Google Suite, C#')

INSERT INTO @newSkills
			([Name])
VALUES ('Agile PM SCRUM')

Execute dbo.Skills_UpdateBatch

Select *
From dbo.Skills
*/

BEGIN

	UPDATE dbo.Skills
		set [Name] = ns.[Name]
	FROM @newSkills as ns inner join dbo.Skills as s
		on s.[Name] = ns.[Name]

END


-- Using Batch INSERT --


ALTER proc [dbo].[Friends_Insert]

	@Title NVARCHAR(120)
	,@Bio NVARCHAR(700)
	,@Summary NVARCHAR(255)
	,@Headline NVARCHAR(80)
	,@Slug NVARCHAR(100)
	,@StatusId NVARCHAR(200)
	,@PrimaryImage NVARCHAR(2083)
	,@Skills dbo.SkillsUDT READONLY
	,@Id int OUTPUT

AS

/*
Declare 
	@Id int = 0;

Declare 
	@Title nvarchar(120) = 'Mr.'
	,@Bio nvarchar(700) = 'Bio'
	,@Summary nvarchar(255) = 'Summary'
	,@Headline nvarchar(80) = 'Headline'
	,@Slug nvarchar(100) = 'a unique string to create a unique url based on the title of headline'
	,@StatusId nvarchar(200) = 'NotSet, Active, Deleted, Flagged'
	,@PrimaryImage nvarchar(2083) = 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80'
	,@Skills dbo.SkillsUDT
INSERT INTO @Skills ([Name])
VALUES ('Biology'), ('Physics')

Execute dbo.Friends_Insert
	@Title
	,@Bio
	,@Summary
	,@Headline
	,@Slug
	,@StatusId
	,@PrimaryImage
	,@Skills
	,@Id OUTPUT

SELECT @Id

Select *
from dbo.Friends
Where Id = @Id
*/

BEGIN

	INSERT INTO [dbo].[Friends]
           ([Title]
           ,[Bio]
           ,[Summary]
		   ,[Headline]
           ,[Slug]
           ,[StatusId]
           ,[PrimaryImage])

     VALUES
    (@Title
		,@Bio
		,@Summary
		,@Headline
		,@Slug
		,@StatusId
		,@PrimaryImage)

	SET @Id = SCOPE_IDENTITY()   

	EXECUTE dbo.Skills_InsertBatch
		@Skills

	INSERT INTO dbo.FriendsSkills (FriendId,
									SkillId)
	SELECT f.Id
			,s.Id
	FROM dbo.Friends as f, dbo.Skills as s
	INNER JOIN @Skills as su
	ON su.Name = s.Name
	WHERE f.Id = @Id

END


-- Using batch UPDATE --


ALTER PROC [dbo].[Friends_Update] 

	@Title nvarchar(120)
	, @Bio nvarchar(700)
	, @Summary nvarchar(255)
	, @Headline nvarchar(80)
	, @Slug nvarchar(100)
	, @StatusId nvarchar(200)
	, @PrimaryImage nvarchar(2083)
	, @Skills dbo.SkillsUDT READONLY
	, @Id int

AS

/*
	Declare 
	@Id int = 57;

	Declare 
	@Title nvarchar(120) = 'fgsdfn'
	,@Bio nvarchar(700) = 'Jvsfdgdfbn'
	,@Summary nvarchar(255) = 'sfbwegb'
	,@Headline nvarchar(80) = 'sdgngbsdf'
	,@Slug nvarchar(100) = 'BankersareAmerican'
	,@StatusId nvarchar(200) = 'Active'
	,@PrimaryImage nvarchar(2083) = 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80'
	,@Skills dbo.SkillsUDT
INSERT INTO @Skills ([Name])
VALUES ('QUAA'), ('ReBugging')

	Select *
	from dbo.Friends
	Where Id = @Id

	Execute dbo.Friends_Update
	@Title
	,@Bio
	,@Summary
	,@Headline
	,@Slug
	,@StatusId
	,@PrimaryImage
	,@Skills
	,@Id 

	Select *
	from dbo.Friends
	Where Id = @Id
*/

    BEGIN

        DECLARE @DateModified DATETIME2= GETUTCDATE();
        UPDATE [dbo].[Friends]
          SET 
              [Title] = @Title, 
              [Bio] = @Bio, 
              [Summary] = @Summary, 
              [Headline] = @Headline, 
              [Slug] = @Slug, 
              [StatusId] = @StatusId, 
              [PrimaryImage] = @PrimaryImage, 
              [DateModified] = @DateModified

        WHERE Id = @Id;

        DELETE dbo.FriendsSkills
        FROM dbo.FriendsSkills AS fs
             INNER JOIN dbo.Friends AS f ON fs.FriendId = f.Id
        WHERE f.Id = @Id;

        EXECUTE dbo.Skills_InsertBatch 
                @Skills;

        INSERT INTO dbo.FriendsSkills
        (FriendId, 
         SkillId
        )
               SELECT f.Id, 
                      s.Id
               FROM dbo.Friends AS f, 
                    dbo.Skills AS s
                    INNER JOIN @Skills AS su ON su.Name = s.Name
               WHERE f.Id = @Id;

    END