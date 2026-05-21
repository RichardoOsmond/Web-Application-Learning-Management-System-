INSERT INTO [Role] (RoleID, RoleName) VALUES (1, 'Admin'), (2, 'Student'), (3, 'Teacher')

INSERT INTO [User] (RoleID, Username, Password, Email, [Last Login], [Last Logout]) 
VALUES (1, 'admin', 'admin123', 'admin@rcdl.com', GETDATE(), GETDATE())

INSERT INTO Course (UserID, CourseName, Description, CourseCreatedDate)
VALUES 
(1, 'Math', 'Learn the fundamentals of mathematics', GETDATE()),
(1, 'English', 'Explore grammar, writing and literature', GETDATE()),
(1, 'Science', 'Discover the world through science', GETDATE()),
(1, 'Art', 'Express yourself through art and creativity', GETDATE())

INSERT INTO Lesson (CourseID, LessonOrder, LessonName)
VALUES
(1, 1, 'Introduction to Math'),
(1, 2, 'Addition'),
(1, 3, 'Subtraction'),
(2, 1, 'Introduction to English'),
(2, 2, 'Grammar Basics'),
(2, 3, 'Creative Writing'),
(3, 1, 'Introduction to Science'),
(3, 2, 'Biology Basics'),
(3, 3, 'Chemistry Basics'),
(4, 1, 'Introduction to Art'),
(4, 2, 'Drawing Basics'),
(4, 3, 'Color Theory')

INSERT INTO Content (LessonID, Position, Type)
VALUES
(1, 1, 'Material'),
(1, 2, 'Quiz'),
(1, 3, 'Material'),
(1, 4, 'Quiz'),
(2, 1, 'Material'),
(2, 2, 'Quiz'),
(2, 3, 'Material'),
(2, 4, 'Quiz'),
(3, 1, 'Material'),
(3, 2, 'Quiz'),
(3, 3, 'Material'),
(3, 4, 'Quiz'),
(4, 1, 'Material'),
(4, 2, 'Quiz'),
(4, 3, 'Material'),
(4, 4, 'Quiz'),
(5, 1, 'Material'),
(5, 2, 'Quiz'),
(5, 3, 'Material'),
(5, 4, 'Quiz'),
(6, 1, 'Material'),
(6, 2, 'Quiz'),
(6, 3, 'Material'),
(6, 4, 'Quiz'),
(7, 1, 'Material'),
(7, 2, 'Quiz'),
(7, 3, 'Material'),
(7, 4, 'Quiz'),
(8, 1, 'Material'),
(8, 2, 'Quiz'),
(8, 3, 'Material'),
(8, 4, 'Quiz'),
(9, 1, 'Material'),
(9, 2, 'Quiz'),
(9, 3, 'Material'),
(9, 4, 'Quiz'),
(10, 1, 'Material'),
(10, 2, 'Quiz'),
(10, 3, 'Material'),
(10, 4, 'Quiz'),
(11, 1, 'Material'),
(11, 2, 'Quiz'),
(11, 3, 'Material'),
(11, 4, 'Quiz'),
(12, 1, 'Material'),
(12, 2, 'Quiz'),
(12, 3, 'Material'),
(12, 4, 'Quiz')

INSERT INTO MaterialContent (ContentID, Name, Description, ImageName)
VALUES
(1, 'Introduction to Math Notes', 'Basic math concepts overview', ''),
(3, 'Addition Worksheet', 'Practice addition problems', ''),
(5, 'Subtraction Worksheet', 'Practice subtraction problems', ''),
(7, 'Division Worksheet', 'Practice division problems', ''),
(9, 'Multiplication Worksheet', 'Practice multiplication problems', ''),
(11, 'Advanced Math Notes', 'Advanced math concepts', ''),
(13, 'English Overview', 'Introduction to English language', ''),
(15, 'Grammar Worksheet', 'Basic grammar exercises', ''),
(17, 'Writing Exercise', 'Creative writing prompts', ''),
(19, 'Literature Notes', 'Introduction to literature', ''),
(21, 'Comprehension Worksheet', 'Reading comprehension exercises', ''),
(23, 'Essay Writing Notes', 'Essay writing techniques', ''),
(25, 'Science Overview', 'Introduction to science concepts', ''),
(27, 'Biology Notes', 'Basic biology concepts', ''),
(29, 'Chemistry Notes', 'Basic chemistry concepts', ''),
(31, 'Physics Notes', 'Basic physics concepts', ''),
(33, 'Lab Exercise', 'Basic lab procedures', ''),
(35, 'Science Review', 'Science concepts review', ''),
(37, 'Art Overview', 'Introduction to art fundamentals', ''),
(39, 'Drawing Exercise', 'Basic drawing techniques', ''),
(41, 'Color Theory Notes', 'Understanding colors', ''),
(43, 'Painting Exercise', 'Basic painting techniques', ''),
(45, 'Sculpture Notes', 'Introduction to sculpture', ''),
(47, 'Art History Notes', 'Overview of art history', '')

INSERT INTO QuizContent (ContentID, Name, TimeLimit, PassingScores, MaxAttempts)
VALUES
(2, 'Math Intro Quiz', '30', 60, 3),
(4, 'Addition Quiz', '20', 60, 3),
(6, 'Subtraction Quiz', '20', 60, 3),
(8, 'Division Quiz', '20', 60, 3),
(10, 'Multiplication Quiz', '20', 60, 3),
(12, 'Advanced Math Quiz', '20', 60, 3),
(14, 'English Intro Quiz', '30', 60, 3),
(16, 'Grammar Quiz', '20', 60, 3),
(18, 'Writing Quiz', '20', 60, 3),
(20, 'Literature Quiz', '20', 60, 3),
(22, 'Comprehension Quiz', '20', 60, 3),
(24, 'Essay Quiz', '20', 60, 3),
(26, 'Science Intro Quiz', '30', 60, 3),
(28, 'Biology Quiz', '20', 60, 3),
(30, 'Chemistry Quiz', '20', 60, 3),
(32, 'Physics Quiz', '20', 60, 3),
(34, 'Lab Quiz', '20', 60, 3),
(36, 'Science Review Quiz', '20', 60, 3),
(38, 'Art Intro Quiz', '30', 60, 3),
(40, 'Drawing Quiz', '20', 60, 3),
(42, 'Color Theory Quiz', '20', 60, 3),
(44, 'Painting Quiz', '20', 60, 3),
(46, 'Sculpture Quiz', '20', 60, 3),
(48, 'Art History Quiz', '20', 60, 3)

select * from MaterialContent m join Content c on m.ContentID = c.ContentID;
Delete FROM [MaterialContent] where ImageName = 'materialName';

