# Wapping Time

An ASP.NET Web Forms learning management system that lets students browse courses, view learning materials, take quizzes, track progress, and communicate with admins through a built-in chat and notification system.

> **Note:** This was a group assignment, originally developed in a private repository. It is published here with permission from my fellow group members.

## Tech Stack

- **Backend:** C# / ASP.NET Web Forms (.NET Framework 4.7.2)
- **Frontend:** HTML, CSS, JavaScript
- **Database:** SQL Server (see `Database Query.sql` / `InsertQuery.sql` for schema and seed data)

## Features

### Student Side
- **Dashboard** — Welcome panel, enrolled course carousel, and overall course-completion progress bar
- **Course Pages** — Browse enrolled/available courses, view course details and materials
- **Quizzes** — Take quizzes tied to course content
- **Materials Viewer** — View uploaded learning materials (images, flashcards, documents)
- **Notifications** — Real-time-style notification feed for course/admin updates
- **Chat** — Direct messaging between students and admins

### Admin Side
- **Admin Dashboard** — Manage courses and view student activity
- **Course Editor** — Create/edit courses and upload materials
- **Quiz Creator** — Build quizzes for any course
- **AdminChat** — Respond to student messages from a dedicated admin chat interface

### Account & Auth
- Registration, login, logout
- Forgot password / set username flows
- Session-based authentication with role-based redirects (Student vs Admin)

## Project Structure

```
Wapp/
├── CSS/                  # Page-specific stylesheets
├── Scripts/              # Page-specific JavaScript
├── Images/               # Course icons, UI assets, uploaded materials
├── *.aspx / *.aspx.cs     # Web Forms pages + code-behind
├── *.Master               # Shared master/layout pages
├── DataServices.cs        # Data access layer
├── Notifications.cs        # Notification model
├── ChatMessages.cs          # Chat message model
├── Student.cs / User.cs      # Domain models
├── Database Query.sql         # Database schema
└── InsertQuery.sql              # Seed data
```

## Getting Started

1. Clone the repository
2. Open `Wapping time.sln` in Visual Studio (2019+ recommended)
3. Restore NuGet packages
4. Set up the SQL Server database using `Database Query.sql`, then seed it with `InsertQuery.sql`
5. Update the connection string in `Web.config` to point to your local database
6. Build and run (IIS Express)

## About This Project

This was a group assignment for a Web Applications course at university, built collaboratively by our team.

### My Contribution
- Student Dashboard and Student Course pages — full functionality and CSS
- Notifications system
- Chat system, including the Admin Chat UI and functionality
