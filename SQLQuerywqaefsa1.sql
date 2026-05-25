UPDATE Role Set RoleName = 'Admin' where RoleID = 2
UPDATE Role Set RoleName = 'Student' where RoleID = 1
EXEC sp_rename 'dbo.User.AboutMe', 'About Me', 'COLUMN'
select * from [User]
select * from [Role]

UPDATE [User] set RoleID = 2 where UserID = 1
UPDATE [User] set RoleID = 1 where UserID = 4
UPDATE [User] set RoleID = 2 where UserID = 3