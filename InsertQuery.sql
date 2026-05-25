-- ===================================================================
-- 1. INSERT ROLES
-- ===================================================================
-- Explicitly setting RoleIDs since they aren't IDENTITY columns
INSERT INTO [dbo].[Role] ([RoleID], [RoleName])
VALUES 
(1, 'Student'),
(2, 'Admin'),
(3, 'SuperAdmin');


-- ===================================================================
-- 2. INSERT USERS
-- ===================================================================
-- Note: UserID is IDENTITY(1,1), so SQL Server handles the keys.
-- Creating 3 users total to match your specified emails (1@a.com to 3@a.com).
INSERT INTO [dbo].[User] 
(
    [RoleID], [Username], [Password], [Email], 
    [Last Login], [Last Logout], [About Me]
)
VALUES 
(1, 'student_user1', '123qwe', '1@a.com', GETDATE(), GETDATE(), 'Hi, I am a regular student.'),
(1, 'student_user2', '123qwe', '2@a.com', GETDATE(), GETDATE(), 'Looking forward to learning!'),
(2, 'admin_user',    '123qwe', '3@a.com', GETDATE(), GETDATE(), 'System Administrator Account.'),
(3, 'super_admin',    '123qwe', '4@a.com', GETDATE(), GETDATE(), 'Super Administrator Account.'),
(1, 'student_user3', '123qwe', '5@a.com', GETDATE(), GETDATE(), 'Interested in AI and programming.'),
(1, 'student_user4', '123qwe', '6@a.com', GETDATE(), GETDATE(), 'Excited to join new courses and improve skills.'),
(1, 'student_user5', '123qwe', '7@a.com', GETDATE(), GETDATE(), 'Passionate about technology and databases.');


-- ===================================================================
-- 3. INSERT COURSES
-- ===================================================================
-- CourseID is IDENTITY. Assigning them to our Admin user (UserID = 3).
-- Note: [CourseName] has a VARCHAR(15) limit in your schema, 
-- so "Social Science" fits exactly at 14 characters.
INSERT INTO [dbo].[Course] 
(
    [UserID], [CourseName], [Description], 
    [CourseCreatedDate], [CourseImage], [CourseCategory]
)
VALUES 
(3, 'English',        'Master English grammar and vocabulary.', CAST(GETDATE() AS DATE), 'english_thumb.jpg', 'Languages'),
(3, 'Math',           'Introduction to algebra and geometry.', CAST(GETDATE() AS DATE), 'math_thumb.jpg',    'Mathematics'),
(3, 'Science',        'Exploring biology, chemistry, and physics.', CAST(GETDATE() AS DATE), 'science_thumb.jpg', 'Natural Sciences'),
(3, 'Social Science', 'Understanding human society and history.', CAST(GETDATE() AS DATE), 'social_thumb.jpg',  'Humanities');


-- ===================================================================
-- 4. ENROLL THE STUDENT (REGISTRATIONS)
-- ===================================================================
-- RegistrationID is IDENTITY. 
-- Enrolling our first student (UserID = 1) into all 4 created courses (CourseIDs 1 through 4).
INSERT INTO [dbo].[Registration] 
(
    [UserID], [CourseID], [Result], [RegistrationDate], [Progress]
)
VALUES 
(1, 1, 'In Progress', CAST(GETDATE() AS DATE), 45), -- Random progress: 45%
(1, 2, 'In Progress', CAST(GETDATE() AS DATE), 12), -- Random progress: 12%
(1, 3, 'In Progress', CAST(GETDATE() AS DATE), 88), -- Random progress: 88%
(1, 4, 'In Progress', CAST(GETDATE() AS DATE), 0),  -- Random progress: 0%
(2, 1, 'In Progress', CAST(GETDATE() AS DATE), 45), -- Random progress: 45%
(2, 2, 'In Progress', CAST(GETDATE() AS DATE), 12), -- Random progress: 12%
(2, 3, 'In Progress', CAST(GETDATE() AS DATE), 88), -- Random progress: 88%
(2, 4, 'In Progress', CAST(GETDATE() AS DATE), 0);  -- Random progress: 0%

SELECT LessonID, CourseID, LessonName FROM [dbo].[Lesson];
SELECT * FROM Lesson WHERE LessonID = 2



-- =====================================================================
-- DETAILED CONTENT DATA FOR THE "MATH" COURSE
-- =====================================================================
-- Run AFTER your existing insert script (Roles, Users, Courses,
-- Registrations must already exist).
--
-- KEY DESIGN POINTS:
--   * We find the Math course by NAME, not a hardcoded ID — safer.
--   * All child IDs (LessonID, ContentID, QuizID, QuestionID, MaterialID)
--     are IDENTITY columns, so we capture each with SCOPE_IDENTITY()
--     immediately after inserting its parent. NEVER hardcode these IDs.
--   * Image placeholders use '/Images/Course Icon/profile.png' as requested.
--   * Content.Type is either 'Material' or 'Quiz'; that determines whether
--     it links to MaterialContent or QuizContent.
-- =====================================================================

DECLARE @MathCourseID INT;
SELECT @MathCourseID = CourseID FROM [dbo].[Course] WHERE CourseName = 'Math';

IF @MathCourseID IS NULL
BEGIN
    PRINT 'ERROR: Math course not found. Run the course insert script first.';
    RETURN;
END

PRINT 'Found Math course with CourseID = ' + CAST(@MathCourseID AS VARCHAR);

DECLARE @LessonID INT;
DECLARE @ContentID INT;
DECLARE @QuizID INT;
DECLARE @QuestionID INT;
DECLARE @MaterialID INT;

-- =====================================================================
-- LESSON 1: Introduction to Numbers
-- =====================================================================
INSERT INTO [dbo].[Lesson] ([CourseID], [LessonOrder], [LessonName])
VALUES (@MathCourseID, 1, N'Introduction to Numbers');
SET @LessonID = SCOPE_IDENTITY();

-- Lesson 1 / Content 1: MATERIAL
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '1', 'Material');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[MaterialContent] ([ContentID], [Name], [Description])
VALUES (@ContentID, N'Understanding Number Types',
        N'Numbers come in several families. Natural numbers (1, 2, 3, ...) are the counting numbers. Whole numbers add zero to that set. Integers extend further to include negatives (-3, -2, -1, 0, 1, 2, 3). Rational numbers can be written as fractions, while irrational numbers like pi cannot. Understanding these categories is the foundation for all of mathematics.');
SET @MaterialID = SCOPE_IDENTITY();   -- capture BEFORE inserting flashcards

INSERT INTO [dbo].[Flashcard] ([MaterialID], [FrontImage], [BackText], [CardOrder])
VALUES
    (@MaterialID, '/Images/Course Icon/profile.png', N'Natural Numbers: counting numbers starting from 1 (1, 2, 3, ...).', 1),
    (@MaterialID, '/Images/Course Icon/profile.png', N'Whole Numbers: natural numbers plus zero (0, 1, 2, 3, ...).', 2),
    (@MaterialID, '/Images/Course Icon/profile.png', N'Integers: whole numbers plus their negatives (..., -2, -1, 0, 1, 2, ...).', 3);

-- Lesson 1 / Content 2: QUIZ
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '2', 'Quiz');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[QuizContent] ([ContentID], [Name], [TimeLimit], [PassingScores], [MaxAttempts])
VALUES (@ContentID, N'Number Types Quiz', '300', 70, 3);
SET @QuizID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [ImageName], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'Which of these is a natural number?', N'Select the correct option.', '/Images/Course Icon/profile.png', 10, 1, 'MultipleChoice');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers]) VALUES
    (@QuestionID, N'7'),
    (@QuestionID, N'-3'),
    (@QuestionID, N'0.5'),
    (@QuestionID, N'-1.2');

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [ImageName], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'Is -5 an integer?', N'True or False.', NULL, 5, 2, 'TrueFalse');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers]) VALUES
    (@QuestionID, N'True'),
    (@QuestionID, N'False');

-- =====================================================================
-- LESSON 2: Addition and Subtraction
-- =====================================================================
INSERT INTO [dbo].[Lesson] ([CourseID], [LessonOrder], [LessonName])
VALUES (@MathCourseID, 2, N'Addition and Subtraction');
SET @LessonID = SCOPE_IDENTITY();

-- Lesson 2 / Content 1: MATERIAL
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '1', 'Material');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[MaterialContent] ([ContentID], [Name], [Description])
VALUES (@ContentID, N'The Basics of Adding and Subtracting',
        N'Addition combines two or more numbers into a sum. Subtraction finds the difference between numbers. When adding, the order does not matter (3 + 5 = 5 + 3), a property called commutativity. Subtraction is NOT commutative: 5 - 3 is not the same as 3 - 5. Always line up place values when working with larger numbers.');
SET @MaterialID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Flashcard] ([MaterialID], [FrontImage], [BackText], [CardOrder])
VALUES
    (@MaterialID, '/Images/Course Icon/profile.png', N'Sum: the result of adding numbers together.', 1),
    (@MaterialID, '/Images/Course Icon/profile.png', N'Difference: the result of subtracting one number from another.', 2),
    (@MaterialID, '/Images/Course Icon/profile.png', N'Commutative Property: order does not matter in addition (a + b = b + a).', 3);

-- Lesson 2 / Content 2: QUIZ
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '2', 'Quiz');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[QuizContent] ([ContentID], [Name], [TimeLimit], [PassingScores], [MaxAttempts])
VALUES (@ContentID, N'Addition and Subtraction Quiz', '600', 80, 2);
SET @QuizID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [ImageName], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'What is 24 + 18?', N'Select the sum.', NULL, 10, 1, 'MultipleChoice');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers]) VALUES
    (@QuestionID, N'42'),
    (@QuestionID, N'40'),
    (@QuestionID, N'32'),
    (@QuestionID, N'44');

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [ImageName], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'What is 50 - 27?', N'Select the difference.', NULL, 10, 2, 'MultipleChoice');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers]) VALUES
    (@QuestionID, N'23'),
    (@QuestionID, N'33'),
    (@QuestionID, N'27'),
    (@QuestionID, N'13');

-- =====================================================================
-- LESSON 3: Introduction to Multiplication
-- =====================================================================
INSERT INTO [dbo].[Lesson] ([CourseID], [LessonOrder], [LessonName])
VALUES (@MathCourseID, 3, N'Introduction to Multiplication');
SET @LessonID = SCOPE_IDENTITY();

-- Lesson 3 / Content 1: MATERIAL
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '1', 'Material');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[MaterialContent] ([ContentID], [Name], [Description])
VALUES (@ContentID, N'Multiplication as Repeated Addition',
        N'Multiplication is a shortcut for repeated addition. For example, 4 x 3 means adding 4 three times: 4 + 4 + 4 = 12. The numbers being multiplied are called factors, and the result is the product. Learning the times tables from 1 to 12 builds a strong foundation for division, fractions, and algebra later on.');
SET @MaterialID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Flashcard] ([MaterialID], [FrontImage], [BackText], [CardOrder])
VALUES
    (@MaterialID, '/Images/Course Icon/profile.png', N'Factor: a number being multiplied.', 1),
    (@MaterialID, '/Images/Course Icon/profile.png', N'Product: the result of multiplication.', 2),
    (@MaterialID, '/Images/Course Icon/profile.png', N'4 x 3 = 12, because 4 + 4 + 4 = 12.', 3);

-- Lesson 3 / Content 2: QUIZ
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '2', 'Quiz');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[QuizContent] ([ContentID], [Name], [TimeLimit], [PassingScores], [MaxAttempts])
VALUES (@ContentID, N'Multiplication Basics Quiz', '450', 75, 3);
SET @QuizID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [ImageName], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'What is 6 x 7?', N'Select the product.', NULL, 10, 1, 'MultipleChoice');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers]) VALUES
    (@QuestionID, N'42'),
    (@QuestionID, N'36'),
    (@QuestionID, N'48'),
    (@QuestionID, N'40');

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [ImageName], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'Multiplication is the same as repeated addition.', N'True or False.', NULL, 5, 2, 'TrueFalse');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers]) VALUES
    (@QuestionID, N'True'),
    (@QuestionID, N'False');

PRINT 'Math course content inserted successfully.';

-- =====================================================================
-- VERIFICATION (uncomment to run)
-- =====================================================================
-- SELECT l.LessonOrder, l.LessonName, c.Position, c.Type
-- FROM Lesson l INNER JOIN Content c ON l.LessonID = c.LessonID
-- WHERE l.CourseID = (SELECT CourseID FROM Course WHERE CourseName = 'Math')
-- ORDER BY l.LessonOrder, c.Position;