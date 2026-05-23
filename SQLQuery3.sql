ALTER TABLE [dbo].[Course] ADD ImageName VARCHAR(100) NULL;

UPDATE [dbo].[Course] SET ImageName = 'profile.png'    WHERE CourseName = 'Math';
UPDATE [dbo].[Course] SET ImageName = 'profile.png' WHERE CourseName = 'English';

select*from [dbo].[Course];