-- ===================================================================
-- 1. INSERT ROLES
-- ===================================================================
-- Explicitly setting RoleIDs since they aren't IDENTITY columns
INSERT INTO [dbo].[Role] ([RoleID], [RoleName])
VALUES 
(1, 'Student'),
(2, 'Admin');


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
(2, 'admin_user',    '123qwe', '3@a.com', GETDATE(), GETDATE(), 'System Administrator Account.');


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