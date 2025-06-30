CREATE TABLE Users (
       UserId INT PRIMARY KEY AUTO_INCREMENT,
       Username VARCHAR(50) UNIQUE NOT NULL,
       Email VARCHAR(100) UNIQUE NOT NULL,
       PasswordHash VARCHAR(255) NOT NULL,
       Role ENUM('Admin', 'Author', 'Reader') DEFAULT 'Reader',
       Reputation INT DEFAULT 0,
       CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Categories (
       CategoryID INT PRIMARY KEY AUTO_INCREMENT,
       Name VARCHAR(50) UNIQUE NOT NULL,
       Description TEXT
);

CREATE TABLE Posts (
       PostID INT PRIMARY KEY AUTO_INCREMENT,
       UserID INT,
       CategoryID INT,
       Title VARCHAR(200) NOT NULL,
       Content TEXT NOT NULL,
       CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
       UpdatedAt DATETIME,
       Status ENUM('Published', 'Draft', 'Scheduled') DEFAULT 'Draft',
       ScheduledAt DATETIME,
       FOREIGN KEY (UserID) REFERENCES Users(UserID),
       FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
); 

CREATE TABLE PostHistory (
       HistoryID INT PRIMARY KEY AUTO_INCREMENT,
       PostID INT,
       EditedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
       OldContent TEXT,
       FOREIGN KEY (PostID) REFERENCES Posts(PostID)
);

CREATE TABLE Tags (
       TagID INT PRIMARY KEY AUTO_INCREMENT,
       Name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE PostTags (
       PostID INT,
       TagID INT,
       PRIMARY KEY (PostID, TagID),
       FOREIGN KEY (PostID) REFERENCES Posts(PostID),
       FOREIGN KEY (TagID) REFERENCES Tags(TagID)
);

CREATE TABLE Comments (
       CommentID INT PRIMARY KEY AUTO_INCREMENT,
       PostID INT,
       UserID INT,
       ParentCommentID INT DEFAULT NULL,
       Content TEXT NOT NULL,
       CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
       FOREIGN KEY (PostID) REFERENCES Posts(PostID),
       FOREIGN KEY (UserID) REFERENCES Users(UserID),
       FOREIGN KEY (ParentCommentID) REFERENCES Comments(CommentID)
);

CREATE TABLE Likes (
       LikeID INT PRIMARY KEY AUTO_INCREMENT,
       UserID INT,
       PostID INT DEFAULT NULL,
       CommentID INT DEFAULT NULL,
       CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
       FOREIGN KEY (UserID) REFERENCES Users(UserID),
       FOREIGN KEY (PostID) REFERENCES Posts(PostID),
       FOREIGN KEY (CommentID) REFERENCES Comments(CommentID)
);

CREATE TABLE Reports (
       ReportID INT PRIMARY KEY AUTO_INCREMENT,
       ReporterID INT,
       PostID INT DEFAULT NULL,
       CommentID INT DEFAULT NULL,
       Reason TEXT,
       CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
       FOREIGN KEY (ReporterID) REFERENCES Users(UserID),
       FOREIGN KEY (PostID) REFERENCES Posts(PostID),
       FOREIGN KEY (CommentID) REFERENCES Comments(CommentID)
);

-- Users
INSERT INTO Users(Username, Email, PasswordHash, Role, Reputation)
            VALUES('alice_admin','alice@example.com', 'hashed_pw1', 'Admin', 80);
INSERT INTO Users(Username, Email, PasswordHash, Role, Reputation)
            VALUES('bob_writer', 'bob@example.com', 'hashed_pw2', 'Author', 60);
INSERT INTO Users(Username, Email, PasswordHash, Role, Reputation)
            VALUES('charlie_reader','charlie@example.com','hashed_pw3', 'Reader', 10);
INSERT INTO Users(Username, Email, PasswordHash, Role, Reputation)
            VALUES('daisy_dev', 'daisy@example.com', 'hashed_pw4', 'Author', 45);
INSERT INTO Users(Username, Email, PasswordHash, Role, Reputation)
            VALUES('eve_moderator', 'eve@example.com', 'hashed_pw5', 'Admin', 100);

-- Categories
INSERT INTO Categories(Name, Description)
            VALUES('Technology', 'Posts related to software, gadgets, and development');
INSERT INTO Categories(Name, Description)
            VALUES('Health & Wellness', 'Topics on physical and mental health');
INSERT INTO Categories(Name, Description)
            VALUES('Lifestyle', 'Posts about daily routines, home, and fashion');
INSERT INTO Categories(Name, Description)
            VALUES('Education', 'Tutorials and learning resources');

-- Tags
INSERT INTO Tags(Name)
            VALUES('SQL');
INSERT INTO Tags(Name)
            VALUES('Python');
INSERT INTO Tags(Name)
            VALUES('Tutorial');
INSERT INTO Tags(Name)
            VALUES('Fitness');
INSERT INTO Tags(Name)
            VALUES('MentalHealth');
INSERT INTO Tags(Name)
            VALUES('Productivity');
INSERT INTO Tags(Name)
            VALUES('Career');
INSERT INTO Tags(Name)
            VALUES('DevOps');

-- Posts
INSERT INTO Posts(UserID, CategoryID, Title, Content, Status, CreatedAt)
            VALUES(2, 1, 'Getting Started with SQL', 'SQL is a powerful tool for data...', 'Published', NOW());
INSERT INTO Posts(UserID, CategoryID, Title, Content, Status, CreatedAt)
            VALUES(2, 2, 'Morning Meditation Routine', 'Starting your day with meditation...', 'Published', NOW());
INSERT INTO Posts(UserID, CategoryID, Title, Content, Status, CreatedAt)
            VALUES(4, 1, 'Top 5 VS Code Extensions', 'Make your coding faster...', 'Draft', NOW());
INSERT INTO Posts(UserID, CategoryID, Title, Content, Status, CreatedAt)
            VALUES(4, 3, 'How to Stay Productive at Home', 'Productivity tips for remote work...', 'Published', NOW());
INSERT INTO Posts(UserID, CategoryID, Title, Content, Status, CreatedAt)
            VALUES(2, 4, 'How to Learn Programming Fast', 'Tips and strategies...', 'Scheduled', DATE_ADD(NOW(), INTERVAL 3 DAY));

-- PostTags
INSERT INTO PostTags(PostID, TagID)
            VALUES(1, 1); -- SQL
INSERT INTO PostTags(PostID, TagID)
            VALUES(1, 3); -- Tutorial
INSERT INTO PostTags(PostID, TagID)
            VALUES(2, 4); -- Fitness
INSERT INTO PostTags(PostID, TagID)
            VALUES(2, 5); -- MentalHealth
INSERT INTO PostTags(PostID, TagID)
            VALUES(3, 2); -- Python
INSERT INTO PostTags(PostID, TagID)
            VALUES(4, 6); -- Productivity
INSERT INTO PostTags(PostID, TagID)
            VALUES(5, 7); -- Career
INSERT INTO PostTags(PostID, TagID)
            VALUES(5, 3); -- Tutorial

-- PostHistory
INSERT INTO PostHistory(PostID, EditedAt, OldContent)
            VALUES(1, DATE_SUB(NOW(), INTERVAL 2 DAY), 'Original SQL intro content...');
INSERT INTO PostHistory(PostID, EditedAt, OldContent)
            VALUES(1, DATE_SUB(NOW(), INTERVAL 1 DAY), 'Updated with JOIN examples...');

-- Comments
INSERT INTO Comments(PostID, UserID, ParentCommentID, Content, CreatedAt)
            VALUES(1, 3, NULL, 'This helped me understand SQL better. Thanks!', NOW());
INSERT INTO Comments(PostID, UserID, ParentCommentID, Content, CreatedAt)
            VALUES(1, 2, 1, 'Youre welcome! Glad it helped.', NOW());
INSERT INTO Comments(PostID, UserID, ParentCommentID, Content, CreatedAt)
            VALUES(2, 3, NULL, 'I also meditate every morning!', NOW());
INSERT INTO Comments(PostID, UserID, ParentCommentID, Content, CreatedAt)
            VALUES(4, 1, NULL, 'Great tips on working from home.', NOW());

-- Likes
-- Likes on posts
INSERT INTO Likes(UserID, PostID, CreatedAt)
            VALUES(3, 1, NOW());
INSERT INTO Likes(UserID, PostID, CreatedAt)
            VALUES(1, 2, NOW());
INSERT INTO Likes(UserID, PostID, CreatedAt)
            VALUES(3, 4, NOW());

-- Likes on comments
INSERT INTO Likes(UserID, CommentID, CreatedAt)
            VALUES(2, 1, NOW());
INSERT INTO Likes(UserID, CommentID, CreatedAt)
            VALUES(4, 3, NOW());

-- Reports
INSERT INTO Reports(ReporterID, PostID, Reason, CreatedAt)
            VALUES(3, 3, 'Spam or misleading content', NOW());
INSERT INTO Reports(ReporterID, PostID, Reason, CreatedAt)
            VALUES(1, 1, 'Inappropriate language', NOW());