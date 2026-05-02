CREATE TABLE [dbo].[User]
(
	[UserID] INT NOT NULL PRIMARY KEY IDENTITY(1, 1), 
    [RoleID] INT NOT NULL, 
    [Username] NVARCHAR(50) NOT NULL, 
    [Password] VARCHAR(255) NOT NULL, 
    [Email] NVARCHAR(100) NOT NULL, 
    [Last Login] DATETIME NOT NULL, 
    [Last Logout] DATETIME NOT NULL, 
    CONSTRAINT [FK_User_Role] FOREIGN KEY ([RoleID]) REFERENCES [Role]([RoleID]) 
)

CREATE TABLE [dbo].[Role]
(
	[RoleID] INT NOT NULL PRIMARY KEY, 
    [RoleName] VARCHAR(50) NOT NULL
)

CREATE TABLE [dbo].[Question]
(
    [QuestionID] INT NOT NULL PRIMARY KEY, 
    [ContentID] INT NOT NULL, 
    [Question] VARCHAR(100) NOT NULL  , 
    [Description] VARCHAR(10) NULL, 
    [ImageName] VARCHAR(100) NULL, 
    [Point] INT NOT NULL, 
    [QuestionOrder] INT NULL, 
    [QuestionType] VARCHAR(50) NOT NULL
)

CREATE TABLE [dbo].[Course]
(
    [CourseID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [UserID] INT NOT NULL, 
    [CourseName] VARCHAR(10) NOT NULL, 
    [Description] VARCHAR(255) NOT NULL, 
    [CourseCreatedDate] DATE NOT NULL, 
    CONSTRAINT [FK_Course_User] FOREIGN KEY ([UserID]) REFERENCES [User]([UserID])
)

CREATE TABLE [dbo].[Lesson]
(
    [LessonID] INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    [CourseID] INT NOT NULL,
    [LessonOrder] INT NOT NULL,
    [LessonName] NVARCHAR(50) NOT NULL,
    CONSTRAINT [FK_Lesson_Course] FOREIGN KEY ([CourseID]) REFERENCES [Course]([CourseID])
)

CREATE TABLE [dbo].[Content]
(
    [ContentID] INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    [LessonID] INT NOT NULL,
    [Position] VARCHAR(50) NOT NULL,
    [Type] VARCHAR(50) NOT NULL,
    CONSTRAINT [FK_Content_Lesson] FOREIGN KEY ([LessonID]) REFERENCES [Lesson] ([LessonID])
)

CREATE TABLE [dbo].[QuizContent]
(
    [QuizID] INT NOT NULL PRIMARY KEY IDENTITY(1, 1), 
    [ContentID] INT NOT NULL, 
    [Name] VARCHAR(50) NOT NULL, 
    [TimeLimit] VARCHAR(255) NOT NULL, 
    [PassingScores] INT NOT NULL, 
    [MaxAttempts] INT NOT NULL, 
    CONSTRAINT [FK_QuizContent_Content] FOREIGN KEY ([ContentID]) REFERENCES [Content]([ContentID])
)

CREATE TABLE [dbo].[MaterialContent]
(
    [MaterialID] INT NOT NULL PRIMARY KEY IDENTITY(1, 1), 
    [ContentID] INT NOT NULL, 
    [Name] VARCHAR(50) NOT NULL, 
    [Description] VARCHAR(255) NOT NULL, 
    [ImageName] varchar(50) NOT NULL, 
    CONSTRAINT [FK_MaterialContent_Content] FOREIGN KEY ([ContentID]) REFERENCES [Content]([ContentID])
)

CREATE TABLE [dbo].[Question]
(
    [QuestionID] INT NOT NULL PRIMARY KEY, 
    [ContentID] INT NOT NULL, 
    [Question] VARCHAR(100) NOT NULL  , 
    [Description] VARCHAR(10) NULL, 
    [ImageName] VARCHAR(100) NULL, 
    [Point] INT NOT NULL, 
    [QuestionOrder] INT NULL, 
    [QuestionType] VARCHAR(50) NOT NULL
)

CREATE TABLE [dbo].[Registration]
(
    [RegistrationID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [UserID] INT NOT NULL, 
    [CourseID] INT NOT NULL, 
    [Result] VARCHAR(10) NOT NULL, 
    [RegistrationDate] DATE NOT NULL, 
    [Progress] INT NOT NULL, 
    CONSTRAINT [FK_Registration_User] FOREIGN KEY ([UserID]) REFERENCES [User]([UserID]), 
    CONSTRAINT [FK_Registration_Course] FOREIGN KEY ([CourseID]) REFERENCES [Course]([CourseID])
)

CREATE TABLE [dbo].[Answer]
(
    [AnswerID] INT NOT NULL PRIMARY KEY IDENTITY(1, 1), 
    [QuestionID] INT NOT NULL, 
    [Answers] NVARCHAR(100) NOT NULL, 
    CONSTRAINT [FK_Answer_Question] FOREIGN KEY ([QuestionID]) REFERENCES [Question]([QuestionID])
)