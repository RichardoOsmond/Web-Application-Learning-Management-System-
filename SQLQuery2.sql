-- ============================================================
-- DUMMY DATA for ReadCardDoLearn
-- Run this AFTER all tables are created.
-- Insertion order respects foreign keys (parents before children).
-- ============================================================

-- ---- Roles (no IDENTITY — you supply the ID) ----
INSERT INTO [Role] ([RoleName]) VALUES
    ('Student'),
    ('Teacher'),
    ('Admin');
GO

-- ---- Users (UserID is IDENTITY, auto 1,2,3...) ----
-- Order of insertion determines UserID:
--   1 = student1 (the main test student)
--   2 = teacher_julian
--   3 = teacher_yumnu
--   4 = teacher_richardo
--   5 = teacher_dane
--   6 = Sarah Miller (student, messages teachers)
--   7 = David Chen (student)
-- NOTE: passwords are plain placeholders — hash before any real use.
INSERT INTO [User] ([RoleID], [Username], [Password], [Email], [Last Login], [Last Logout], [About Me]) VALUES
    (1, 'student1',         'changeme', 'student1@example.com',  GETDATE(), GETDATE(), 'I love learning new things!'),
    (2, 'teacher_julian',   'changeme', 'julian@example.com',    GETDATE(), GETDATE(), 'Mathematics professor.'),
    (2, 'teacher_yumnu',    'changeme', 'yumnu@example.com',     GETDATE(), GETDATE(), 'English teacher.'),
    (2, 'teacher_richardo', 'changeme', 'richardo@example.com',  GETDATE(), GETDATE(), NULL),
    (2, 'teacher_dane',     'changeme', 'dane@example.com',      GETDATE(), GETDATE(), NULL),
    (1, 'Sarah Miller',     'changeme', 'sarah@example.com',     GETDATE(), GETDATE(), NULL),
    (1, 'David Chen',       'changeme', 'david@example.com',     GETDATE(), GETDATE(), NULL);
GO

-- ---- Courses (CourseID is IDENTITY) ----
-- Created by teacher_julian (UserID = 2).
-- CourseName is VARCHAR(10) so keep names <= 10 chars!
--   1 = Math
--   2 = English
INSERT INTO [Course] ([UserID], [CourseName], [Description], [CourseCreatedDate]) VALUES
    (2, 'Math',    'Basic math course for young learners.',    GETDATE()),
    (2, 'English', 'Basic English course for young learners.', GETDATE());
GO

-- ---- Registrations (RegistrationID is IDENTITY) ----
-- student1 (UserID=1) enrolled in both courses.
-- Progress 60 + 40 = average 50 (matches the "50% Complete" mockup).
INSERT INTO [Registration] ([UserID], [CourseID], [Result], [RegistrationDate], [Progress]) VALUES
    (1, 1, 'InProgress', GETDATE(), 60),   -- Math 60%
    (1, 2, 'InProgress', GETDATE(), 40);   -- English 40%
GO

-- ---- Notifications (NotificationID is IDENTITY) ----
-- For student1 (UserID=1). One unread (matches the "1" bell badge).
INSERT INTO [Notifications] ([UserID], [Title], [Content], [CreatedTime], [IsRead]) VALUES
    (1, 'New Homework',     'A new English homework has been posted.', GETDATE(),                0),
    (1, 'Quiz Reminder',    'Your math quiz is due tomorrow.',         DATEADD(DAY, -1, GETDATE()), 1),
    (1, 'Welcome!',         'Welcome to ReadCardDoLearn!',             DATEADD(DAY, -3, GETDATE()), 1);
GO

-- ---- ChatMessages (ChatMessageID is IDENTITY) ----
-- Messages sent TO student1 (ToUserID=1) from the three teachers.
-- Matches the "3" chat badge and the three teacher messages in the mockup.
INSERT INTO [ChatMessages] ([FromUserID], [ToUserID], [Content], [SentTime], [IsRead]) VALUES
    (3, 1, 'Your homework is wonderful! keep up the good work!',               DATEADD(DAY,  -1, GETDATE()), 0),  -- Teacher Yumnu
    (4, 1, 'You have forgotten to do your homework, please submit them today.', DATEADD(HOUR, -5, GETDATE()), 0),  -- Teacher Richardo
    (5, 1, 'Excellent drawing in homework 4, do paint more drawings!',          DATEADD(HOUR, -1, GETDATE()), 0);  -- Teacher Dane
GO

-- ---- Extra messages TO teacher_julian (ToUserID=2) for the teacher dashboard ----
-- Students messaging the teacher (matches the teacher mockup's message list).
INSERT INTO [ChatMessages] ([FromUserID], [ToUserID], [Content], [SentTime], [IsRead]) VALUES
    (6, 2, 'Thank you for the clarification on todays lecture!', DATEADD(HOUR, -2,  GETDATE()), 0),  -- Sarah Miller
    (7, 2, 'Ive submitted my thesis draft for review.',          DATEADD(HOUR, -6,  GETDATE()), 0),  -- David Chen
    (1, 2, 'When is the next math class?',                       DATEADD(DAY,  -1,  GETDATE()), 1);  -- student1
GO

-- ============================================================
-- VERIFY (optional — run these SELECTs to confirm the data)
-- ============================================================
-- SELECT * FROM [User];
-- SELECT * FROM [Course];
-- SELECT * FROM [Registration] WHERE UserID = 1;
-- SELECT * FROM [Notifications] WHERE UserID = 1;
-- SELECT * FROM [ChatMessages] WHERE ToUserID = 1;