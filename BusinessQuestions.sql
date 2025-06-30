-- Business Question
-- 1. Top 5 most liked posts.
SELECT Posts.Title, COUNT(Likes.LikeID) AS LikeCount
FROM Posts JOIN Likes ON Posts.PostID = Likes.PostID
GROUP BY Posts.PostID
ORDER BY LikeCount DESC
LIMIT 5;

-- 2. Number of posts per category.
SELECT Categories.Name, COUNT(Posts.PostID) AS PostCount
FROM Categories LEFT JOIN Posts ON Categories.CategoryID = Posts.CategoryID
GROUP BY Categories.CategoryID;

-- 3. Find all comments for a post.
SELECT Comments.Content, Users.Username, Comments.CreatedAt
FROM Comments JOIN Users ON Comments.UserID = Users.UserID
WHERE Comments.PostID = 1;

-- 4. User with the most posts.
SELECT Users.Username, COUNT(Posts.PostID) AS TotalPosts
FROM Users JOIN Posts ON Users.UserID = Posts.UserID
GROUP BY Users.UserID
ORDER BY TotalPosts DESC
LIMIT 1;

-- 5. Get posts scheduled for publishing.
SELECT Title, ScheduledAt
FROM Posts
WHERE Status = 'Scheduled' AND ScheduledAt > NOW();

-- 6. Most active commenters.
SELECT Users.Username, COUNT(Comments.CommentID) AS TotalComments
FROM Comments JOIN Users ON Comments.UserID = Users.UserID
GROUP BY Users.UserID
ORDER BY TotalComments DESC
LIMIT 5;

-- 7. Most popular tags.
SELECT Tags.Name, COUNT(*) AS UsageCount
FROM PostTags JOIN Tags ON PostTags.TagID = Tags.TagID
GROUP BY Tags.TagID
ORDER BY UsageCount DESC
LIMIT 10;

-- 8. Most reported posts. 
SELECT Posts.Title, COUNT(Reports.ReportID) AS ReportCount
FROM Reports JOIN Posts ON Reports.PostID = Posts.PostID
GROUP BY Posts.PostID
ORDER BY ReportCount DESC
LIMIT 5;

-- 9. Posts without any likes. 
SELECT Posts.Title
FROM Posts LEFT JOIN Likes ON Posts.PostID = Likes.PostID
WHERE Likes.LikeID IS NULL;

-- 10. Percentage of posts per category. 
SELECT Categories.Name, COUNT(Posts.PostID) * 100.0 / (SELECT COUNT(*) FROM Posts) AS CategoryPercentage
FROM Categories JOIN Posts ON Categories.CategoryID = Posts.CategoryID
GROUP BY Categories.CategoryID;

-- 11. Comments with the most likes.
SELECT Comments.Content, Users.Username, COUNT(Likes.LikeID) AS Likes
FROM Comments JOIN Likes ON Comments.CommentID = Likes.CommentID
              JOIN Users ON Comments.UserID = Users.UserID
GROUP BY Comments.CommentID
ORDER BY Likes DESC
LIMIT 5;

-- 12. Average number of tags per post.
SELECT AVG(TagCount) AS AvgTagsPerPost
FROM (SELECT COUNT(TagID) AS TagCount
      FROM PostTags
      GROUP BY PostID
      ) AS TagStats;
      
-- 13. Users with the highest reputation.
SELECT Username, Reputation
FROM Users
ORDER BY Reputation DESC
LIMIT 5;

-- 14. Authors with the most scheduled posts.
SELECT Users.Username, COUNT(*) AS ScheduledCount
FROM Posts JOIN Users ON Posts.UserID = Users.UserID
WHERE Posts.Status = 'Scheduled'
GROUP BY Users.UserID
ORDER BY ScheduledCount DESC;