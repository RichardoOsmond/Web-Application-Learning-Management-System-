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
(3, 'English',        'Master English grammar and vocabulary.', CAST(GETDATE() AS DATE), '/Images/Course Icon/English icon.png', 'Languages'),
(3, 'Math',           'Introduction to algebra and geometry.', CAST(GETDATE() AS DATE), '/Images/Course Icon/Math icon.png',    'Mathematics'),
(3, 'Science',        'Exploring biology, chemistry, and physics.', CAST(GETDATE() AS DATE), '/Images/Course Icon/Science icon.png', 'Natural Sciences'),
(3, 'Social Science', 'Understanding human society and history.', CAST(GETDATE() AS DATE), '/Images/Course Icon/Social Science icon.png',  'Humanities');


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
DECLARE @LessonID INT;
DECLARE @ContentID INT;
DECLARE @QuizID INT;
DECLARE @QuestionID INT;
DECLARE @MaterialID INT;

SELECT @MathCourseID = CourseID FROM [dbo].[Course] WHERE CourseName = 'Math';

IF @MathCourseID IS NULL
BEGIN
    PRINT 'ERROR: Math course not found. Run the course insert script first.';
    RETURN;
END

PRINT 'Found Math course with CourseID = ' + CAST(@MathCourseID AS VARCHAR);



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
    (@MaterialID, '/Images/Math Image/Material/flash1.png', N'Natural Numbers: counting numbers starting from 1 (1, 2, 3, ...).', 1),
    (@MaterialID, '/Images/Math Image/Material/flash2.png', N'Whole Numbers: natural numbers plus zero (0, 1, 2, 3, ...).', 2),
    (@MaterialID, '/Images/Math Image/Material/flash3.png', N'Integers: whole numbers plus their negatives (..., -2, -1, 0, 1, 2, ...).', 3);

-- Lesson 1 / Content 3: MATERIAL - Place Value and Number Systems
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '3', 'Material');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[MaterialContent] ([ContentID], [Name], [Description])
VALUES (@ContentID, N'Place Value and Number Systems',
        N'Every digit in a number has a place value depending on its position. In the number 4,352, the digit 4 is in the thousands place, 3 in the hundreds, 5 in the tens, and 2 in the ones. Understanding place value is essential for addition, subtraction, and comparing numbers. Our number system is base-10, meaning each place is ten times the value of the place to its right.');
SET @MaterialID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Flashcard] ([MaterialID], [FrontImage], [BackText], [CardOrder])
VALUES
    (@MaterialID, '/Images/Math Image/Material/flash4.png', N'Place Value: the value of a digit based on its position in a number.', 1),
    (@MaterialID, '/Images/Math Image/Material/flash5.png', N'Base-10 System: each place value is ten times the one to its right.', 2),
    (@MaterialID, '/Images/Math Image/Material/flash6.png', N'In 4,352. Thousands: 4, Hundreds: 3, Tens: 5, Ones: 2.', 3);

-- Lesson 1 / Content 4: MATERIAL - Comparing and Ordering Numbers
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '4', 'Material');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[MaterialContent] ([ContentID], [Name], [Description])
VALUES (@ContentID, N'Comparing and Ordering Numbers',
        N'Numbers can be compared using three symbols: greater than (>), less than (<), and equal to (=). To compare two numbers, first look at the number of digits with more digits, this usually means a larger number. If the digit count is the same, compare digit by digit from left to right. A number line is a useful tool for visualizing order: numbers increase as you move right and decrease as you move left.');
SET @MaterialID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Flashcard] ([MaterialID], [FrontImage], [BackText], [CardOrder])
VALUES
    (@MaterialID, '/Images/Math Image/Material/flash7.png', N'Greater than (>): the left number is larger. Example: 8 > 5.', 1),
    (@MaterialID, '/Images/Math Image/Material/flash8.png', N'Less than (<): the left number is smaller. Example: 3 < 7.', 2),
    (@MaterialID, '/Images/Math Image/Material/flash9.png', N'Number Line: numbers increase moving right, decrease moving left.', 3);

-- Lesson 1 / Content 5: MATERIAL - Odd and Even Numbers
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '5', 'Material');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[MaterialContent] ([ContentID], [Name], [Description])
VALUES (@ContentID, N'Odd and Even Numbers',
        N'Even numbers are divisible by 2 with no remainder. They end in 0, 2, 4, 6, or 8. Odd numbers leave a remainder of 1 when divided by 2. They end in 1, 3, 5, 7, or 9. Zero is considered even. Even and odd patterns appear everywhere in mathematics, from multiplication tables to algebra. Adding two even numbers always gives an even result; adding two odd numbers also gives an even result; but adding one even and one odd gives an odd result.');
SET @MaterialID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Flashcard] ([MaterialID], [FrontImage], [BackText], [CardOrder])
VALUES
    (@MaterialID, '/Images/Math Image/Material/flash10.png', N'Even Numbers: divisible by 2, end in 0, 2, 4, 6, or 8.', 1),
    (@MaterialID, '/Images/Math Image/Material/flash11.png', N'Odd Numbers: not divisible by 2, end in 1, 3, 5, 7, or 9.', 2),
    (@MaterialID, '/Images/Math Image/Material/flash12.png', N'Even + Even = Even. Odd + Odd = Even. Even + Odd = Odd.', 3);

-- Lesson 1 / Content 6: MATERIAL - Rounding Numbers
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '6', 'Material');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[MaterialContent] ([ContentID], [Name], [Description])
VALUES (@ContentID, N'Rounding Numbers',
        N'Rounding simplifies a number to a nearby value that is easier to work with. To round to the nearest ten, look at the ones digit, if it is 5 or more, round up; if it is 4 or less, round down. For example, 47 rounds up to 50, while 43 rounds down to 40. Rounding is used in everyday life for estimating costs, distances, and measurements. It is important to know which place value you are rounding to before starting.');
SET @MaterialID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Flashcard] ([MaterialID], [FrontImage], [BackText], [CardOrder])
VALUES
    (@MaterialID, '/Images/Math Image/Material/flash13.png', N'Rounding Up: if the digit to the right is 5 or more, increase the target digit by 1.', 1),
    (@MaterialID, '/Images/Math Image/Material/flash14.png', N'Rounding Down: if the digit to the right is 4 or less, keep the target digit the same.', 2),
    (@MaterialID, '/Images/Math Image/Material/flash15.png', N'Example: 47 rounded to nearest ten = 50. 43 rounded to nearest ten = 40.', 3);

-- Lesson 1 / Content 2: QUIZ
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '2', 'Quiz');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[QuizContent] ([ContentID], [Name], [TimeLimit], [PassingScores], [MaxAttempts])
VALUES (@ContentID, N'Number Types Quiz', '300', 70, 3);
SET @QuizID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'Which of these is a natural number?', N'Select the correct option.', 10, 1, 'MCQ');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers], [CorrectOrNot]) VALUES
    (@QuestionID, N'7', 1),
    (@QuestionID, N'-3', 0),
    (@QuestionID, N'0.5', 0),
    (@QuestionID, N'-1.2', 0);

-- Lesson 1 / Content 7: QUIZ - Introduction to Numbers Quiz 2
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '7', 'Quiz');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[QuizContent] ([ContentID], [Name], [TimeLimit], [PassingScores], [MaxAttempts])
VALUES (@ContentID, N'Introduction to Numbers Quiz 2', '600', 70, 3);
SET @QuizID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'What is the place value of 5 in the number 3,572?', N'Select the correct option.', 10, 1, 'MCQ');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers], [CorrectOrNot]) VALUES
    (@QuestionID, N'Hundreds', 1),
    (@QuestionID, N'Tens', 0),
    (@QuestionID, N'Thousands', 0),
    (@QuestionID, N'Ones', 0);

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'Which number is even?', N'Select the correct option.', 10, 2, 'MCQ');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers], [CorrectOrNot]) VALUES
    (@QuestionID, N'36', 1),
    (@QuestionID, N'17', 0),
    (@QuestionID, N'53', 0),
    (@QuestionID, N'99', 0);

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'What is 47 rounded to the nearest ten?', N'Select the correct option.', 10, 3, 'MCQ');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers], [CorrectOrNot]) VALUES
    (@QuestionID, N'50', 1),
    (@QuestionID, N'40', 0),
    (@QuestionID, N'45', 0),
    (@QuestionID, N'60', 0);

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'Explain the difference between odd and even numbers and give two examples of each.', N'Write your answer.', 10, 4, 'Essay');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers]) VALUES
    (@QuestionID, '');

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'Is -5 an integer? Explain why.', N'Write your answer.', 5, 2, 'Essay');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers]) VALUES 
    (@QuestionID, '');

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
    (@MaterialID, '/Images/Course Icon/Flash28.png', N'Sum: the result of adding numbers together.', 1),
    (@MaterialID, '/Images/Course Icon/Flash29.png', N'Difference: the result of subtracting one number from another.', 2),
    (@MaterialID, '/Images/Course Icon/Flash30.png', N'Commutative Property: order does not matter in addition (a + b = b + a).', 3);

-- Lesson 2 / Content 3: MATERIAL - Carrying and Borrowing
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '3', 'Material');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[MaterialContent] ([ContentID], [Name], [Description])
VALUES (@ContentID, N'Carrying and Borrowing',
        N'When adding large numbers, carrying (also called regrouping) is used when the sum of a column exceeds 9. For example, 47 + 35: the ones column gives 12, so we write 2 and carry 1 to the tens column. Borrowing works the opposite way in subtraction, when a digit is too small to subtract from, we borrow 1 from the next column to the left. These techniques are essential for solving multi-digit arithmetic problems accurately.');
SET @MaterialID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Flashcard] ([MaterialID], [FrontImage], [BackText], [CardOrder])
VALUES
    (@MaterialID, '/Images/Math Image/Material/flash16.png', N'Carrying: moving the extra value to the next column when a sum exceeds 9.', 1),
    (@MaterialID, '/Images/Math Image/Material/flash17.png', N'Borrowing: taking 1 from the next column left when subtracting a larger digit.', 2),
    (@MaterialID, '/Images/Math Image/Material/flash18.png', N'Example: 47 + 35 = 82 (carry 1 from ones to tens column).', 3);

-- Lesson 2 / Content 4: MATERIAL - Addition and Subtraction on a Number Line
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '4', 'Material');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[MaterialContent] ([ContentID], [Name], [Description])
VALUES (@ContentID, N'Addition and Subtraction on a Number Line',
        N'A number line is a straight line with numbers placed at equal intervals. To add on a number line, start at the first number and jump right by the amount being added. To subtract, jump left. For example, to solve 6 + 3, start at 6 and jump 3 spaces right to land on 9. For 8 - 5, start at 8 and jump 5 spaces left to land on 3. Number lines make abstract arithmetic visual and easier to understand.');
SET @MaterialID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Flashcard] ([MaterialID], [FrontImage], [BackText], [CardOrder])
VALUES
    (@MaterialID, '/Images/Math Image/Material/flash19.png', N'Adding on a number line: start at the first number, jump right.', 1),
    (@MaterialID, '/Images/Math Image/Material/flash20.png', N'Subtracting on a number line: start at the first number, jump left.', 2),
    (@MaterialID, '/Images/Math Image/Material/flash21.png', N'Example: 6 + 3 = 9 (jump 3 right from 6). 8 - 5 = 3 (jump 5 left from 8).', 3);

-- Lesson 2 / Content 5: MATERIAL - Word Problems with Addition and Subtraction
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '5', 'Material');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[MaterialContent] ([ContentID], [Name], [Description])
VALUES (@ContentID, N'Word Problems with Addition and Subtraction',
        N'Word problems describe real life situations using math. Key words help identify which operation to use. Addition keywords include: total, sum, altogether, combined, increased by. Subtraction keywords include: difference, left, remaining, decreased by, fewer than. For example: "John has 15 apples and gives away 6. How many are left?". The word "left" signals subtraction: 15 - 6 = 9. Always read carefully and identify what is being asked before solving.');
SET @MaterialID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Flashcard] ([MaterialID], [FrontImage], [BackText], [CardOrder])
VALUES
    (@MaterialID, '/Images/Math Image/Material/flash22.png', N'Addition keywords: total, sum, altogether, combined, increased by.', 1),
    (@MaterialID, '/Images/Math Image/Material/flash23.png', N'Subtraction keywords: difference, left, remaining, decreased by, fewer than.', 2),
    (@MaterialID, '/Images/Math Image/Material/flash24.png', N'Example: "15 apples, gives away 6, how many left?" → 15 - 6 = 9.', 3);

-- Lesson 2 / Content 6: MATERIAL - Mental Math Strategies
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '6', 'Material');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[MaterialContent] ([ContentID], [Name], [Description])
VALUES (@ContentID, N'Mental Math Strategies',
        N'Mental math allows you to calculate quickly without writing anything down. For addition, try breaking numbers into tens and ones: 37 + 25 = 30 + 20 + 7 + 5 = 62. Another trick is rounding up then adjusting: 49 + 36 = 50 + 36 - 1 = 85. For subtraction, count up from the smaller number to the larger: 72 - 48 means count from 48 to 72, which is 24. Practicing these strategies builds speed and confidence in everyday calculations.');
SET @MaterialID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Flashcard] ([MaterialID], [FrontImage], [BackText], [CardOrder])
VALUES
    (@MaterialID, '/Images/Math Image/Material/flash25.png', N'Break apart strategy: split numbers into tens and ones before adding.', 1),
    (@MaterialID, '/Images/Math Image/Material/flash26.png', N'Round and adjust: round to nearest ten, add, then subtract the difference.', 2),
    (@MaterialID, '/Images/Math Image/Material/flash27.png', N'Count up strategy for subtraction: count from smaller to larger number.', 3);

-- Lesson 2 / Content 2: QUIZ Introduction to Numbers Quiz 1
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '2', 'Quiz');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[QuizContent] ([ContentID], [Name], [TimeLimit], [PassingScores], [MaxAttempts])
VALUES (@ContentID, N'Addition and Subtraction Quiz', '600', 80, 2);
SET @QuizID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'What is 24 + 18?', N'Select the sum.', 10, 1, 'MCQ');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers], [CorrectOrNot]) VALUES
    (@QuestionID, N'42', 1),
    (@QuestionID, N'40', 0),
    (@QuestionID, N'32', 0),
    (@QuestionID, N'44', 0);

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'What is 50 - 27?', N'Select the difference.', 10, 2, 'MCQ');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers], [CorrectOrNot]) VALUES
    (@QuestionID, N'23', 1),
    (@QuestionID, N'33', 0),
    (@QuestionID, N'27', 0),
    (@QuestionID, N'13', 0);

-- Lesson 2 / Content 7: QUIZ - Addition and Subtraction Quiz 2
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '7', 'Quiz');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[QuizContent] ([ContentID], [Name], [TimeLimit], [PassingScores], [MaxAttempts])
VALUES (@ContentID, N'Addition and Subtraction Quiz 2', '600', 80, 2);
SET @QuizID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'What is 47 + 35?', N'Select the correct answer.', 10, 1, 'MCQ');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers], [CorrectOrNot]) VALUES
    (@QuestionID, N'82', 1),
    (@QuestionID, N'72', 0),
    (@QuestionID, N'91', 0),
    (@QuestionID, N'78', 0);

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'What is 83 - 47?', N'Select the correct answer.', 10, 2, 'MCQ');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers], [CorrectOrNot]) VALUES
    (@QuestionID, N'36', 1),
    (@QuestionID, N'46', 0),
    (@QuestionID, N'34', 0),
    (@QuestionID, N'44', 0);

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'John has 52 marbles and gives away 19. How many does he have left?', N'Select the correct answer.', 10, 3, 'MCQ');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers], [CorrectOrNot]) VALUES
    (@QuestionID, N'33', 1),
    (@QuestionID, N'43', 0),
    (@QuestionID, N'31', 0),
    (@QuestionID, N'37', 0);

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'Which keyword signals addition in a word problem?', N'Select the correct answer.', 10, 4, 'MCQ');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers], [CorrectOrNot]) VALUES
    (@QuestionID, N'Altogether', 1),
    (@QuestionID, N'Remaining', 0),
    (@QuestionID, N'Fewer than', 0),
    (@QuestionID, N'Difference', 0);

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'Explain what carrying means in addition and give an example using two 2-digit numbers.', N'Write your answer.', 10, 5, 'Essay');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers]) VALUES
    (@QuestionID, '');



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


-- Lesson 3 / Content 3: MATERIAL - Times Tables 1 to 5
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '3', 'Material');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[MaterialContent] ([ContentID], [Name], [Description])
VALUES (@ContentID, N'Times Tables 1 to 5',
        N'A times table shows what happens when we multiply a number by 1, 2, 3, and so on. Let us look at the 2 times table: 2x1=2, 2x2=4, 2x3=6, 2x4=8, 2x5=10. See the pattern? The answers go up by 2 each time! The 5 times table is easy too! The answers always end in 0 or 5. Knowing your times tables by heart makes math much faster and easier. Try saying them out loud every day until you remember them!');
SET @MaterialID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Flashcard] ([MaterialID], [FrontImage], [BackText], [CardOrder])
VALUES
    (@MaterialID, '/Images/Math Image/Material/flash31.png', N'2 times table: 2, 4, 6, 8, 10 — goes up by 2 each time.', 1),
    (@MaterialID, '/Images/Math Image/Material/flash32.png', N'5 times table: 5, 10, 15, 20, 25 — answers always end in 0 or 5.', 2),
    (@MaterialID, '/Images/Math Image/Material/flash33.png', N'1 times table: any number times 1 equals itself. Example: 7 x 1 = 7.', 3);

-- Lesson 3 / Content 4: MATERIAL - Multiplication as Groups
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '4', 'Material');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[MaterialContent] ([ContentID], [Name], [Description])
VALUES (@ContentID, N'Multiplication as Groups',
        N'Multiplication is a quick way to count equal groups. If you have 3 bags with 4 apples in each bag, you can count them one by one — or just multiply! 3 x 4 = 12. The first number tells you how many groups there are. The second number tells you how many are in each group. So 5 x 2 means 5 groups of 2, which equals 10. Think of multiplication as a shortcut for adding the same number over and over again.');
SET @MaterialID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Flashcard] ([MaterialID], [FrontImage], [BackText], [CardOrder])
VALUES
    (@MaterialID, '/Images/Math Image/Material/flash34.png', N'3 x 4 means 3 groups of 4. Count them: 4, 8, 12. The answer is 12.', 1),
    (@MaterialID, '/Images/Math Image/Material/flash35.png', N'First number = number of groups. Second number = items in each group.', 2),
    (@MaterialID, '/Images/Math Image/Material/flash36.png', N'5 x 2 = 5 groups of 2 = 2 + 2 + 2 + 2 + 2 = 10.', 3);

-- Lesson 3 / Content 5: MATERIAL - Multiplication on a Number Line
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '5', 'Material');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[MaterialContent] ([ContentID], [Name], [Description])
VALUES (@ContentID, N'Multiplication on a Number Line',
        N'You can use a number line to solve multiplication problems. Start at 0 and make equal jumps. To solve 3 x 4, start at 0 and jump 4 spaces, three times. First jump lands on 4, second on 8, third on 12. So 3 x 4 = 12! Each jump is the same size. The number of jumps is the first number. The size of each jump is the second number. Number lines help you see multiplication as a pattern of equal steps.');
SET @MaterialID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Flashcard] ([MaterialID], [FrontImage], [BackText], [CardOrder])
VALUES
    (@MaterialID, '/Images/Math Image/Material/flash37.png', N'To multiply on a number line: start at 0 and make equal jumps.', 1),
    (@MaterialID, '/Images/Math Image/Material/flash38.png', N'3 x 4: jump 4 spaces, 3 times. Land on 4, 8, 12. Answer = 12.', 2),
    (@MaterialID, '/Images/Math Image/Material/flash39.png', N'Number of jumps = first number. Size of each jump = second number.', 3);

-- Lesson 3 / Content 6: MATERIAL - Multiplication Word Problems
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '6', 'Material');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[MaterialContent] ([ContentID], [Name], [Description])
VALUES (@ContentID, N'Multiplication Word Problems',
        N'Word problems tell a story and ask you to find an answer using math. For multiplication, look for words like: each, every, groups of, times, rows of, sets of. For example: "There are 4 boxes. Each box has 6 crayons. How many crayons in total?" This means 4 groups of 6, so 4 x 6 = 24 crayons. Always read the problem carefully, find the numbers, spot the keyword, and then multiply. Practice makes it easier!');
SET @MaterialID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Flashcard] ([MaterialID], [FrontImage], [BackText], [CardOrder])
VALUES
    (@MaterialID, '/Images/Math Image/Material/flash40.png', N'Multiplication keywords: each, every, groups of, times, rows of, sets of.', 1),
    (@MaterialID, '/Images/Math Image/Material/flash41.png', N'4 boxes, 6 crayons each: 4 x 6 = 24 crayons total.', 2),
    (@MaterialID, '/Images/Math Image/Material/flash42.png', N'Steps: read carefully, find the numbers, spot the keyword, then multiply.', 3);

-- Lesson 3 / Content 2: QUIZ
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '2', 'Quiz');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[QuizContent] ([ContentID], [Name], [TimeLimit], [PassingScores], [MaxAttempts])
VALUES (@ContentID, N'Multiplication Basics Quiz', '450', 75, 3);
SET @QuizID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'What is 6 x 7?', N'Select the product.', 10, 1, 'MCQ');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers], [CorrectOrNot]) VALUES
    (@QuestionID, N'42', 1),
    (@QuestionID, N'36', 0),
    (@QuestionID, N'48', 0),
    (@QuestionID, N'40', 0);

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'Multiplication is the same as repeated addition.', N'True or False.', 5, 2, 'Essay');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers]) VALUES
    (@QuestionID, '');

PRINT 'Math course content inserted successfully.';

-- Lesson 3 / Content 7: QUIZ - Introduction to Multiplication Quiz 2
INSERT INTO [dbo].[Content] ([LessonID], [Position], [Type])
VALUES (@LessonID, '7', 'Quiz');
SET @ContentID = SCOPE_IDENTITY();

INSERT INTO [dbo].[QuizContent] ([ContentID], [Name], [TimeLimit], [PassingScores], [MaxAttempts])
VALUES (@ContentID, N'Introduction to Multiplication Quiz 2', '600', 60, 3);
SET @QuizID = SCOPE_IDENTITY();

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'What is 3 x 5?', N'Pick the correct answer.', 10, 1, 'MCQ');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers], [CorrectOrNot]) VALUES
    (@QuestionID, N'15', 1),
    (@QuestionID, N'8', 0),
    (@QuestionID, N'12', 0),
    (@QuestionID, N'20', 0);

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'There are 4 boxes. Each box has 3 balls. How many balls in total?', N'Pick the correct answer.', 10, 2, 'MCQ');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers], [CorrectOrNot]) VALUES
    (@QuestionID, N'12', 1),
    (@QuestionID, N'7', 0),
    (@QuestionID, N'16', 0),
    (@QuestionID, N'9', 0);

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'What does 2 x 6 mean? Draw it using groups and explain your answer.', N'Write your answer.', 10, 3, 'Essay');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers]) VALUES
    (@QuestionID, '');

INSERT INTO [dbo].[Question] ([QuizID], [Question], [Description], [Point], [QuestionOrder], [QuestionType])
VALUES (@QuizID, N'Write your own multiplication word problem and solve it.', N'Write your answer.', 10, 4, 'Essay');
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO [dbo].[Answer] ([QuestionID], [Answers]) VALUES
    (@QuestionID, '');

-- =====================================================================
-- VERIFICATION (uncomment to run)
-- =====================================================================
-- SELECT l.LessonOrder, l.LessonName, c.Position, c.Type
-- FROM Lesson l INNER JOIN Content c ON l.LessonID = c.LessonID
-- WHERE l.CourseID = (SELECT CourseID FROM Course WHERE CourseName = 'Math')
-- ORDER BY l.LessonOrder, c.Position;
