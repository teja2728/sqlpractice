/*1. SQL: The "Digital Library" Audit
Business Case: A local community college has a database of books and student borrows. They are struggling to track "Overdue" books and want to know which categories of books are most popular to decide what to buy next.
Problem Statement
Create a relational system to track book loans and generate a "Penalty Report" for books not returned within 14 days.
Student Tasks:
1.	Table Creation: Create Books, Students, and IssuedBooks (with IssueDate and ReturnDate).
2.	Overdue Logic: Write a query to find all students who haven't returned a book where the IssueDate was more than 14 days ago and ReturnDate is NULL.
3.	Popularity Index: Use COUNT and GROUP BY on the Category column to show which genre (e.g., Fiction, Science, History) is borrowed the most.
4.	Data Cleanup: Write a DELETE or UPDATE statement to remove student records who haven't borrowed a book in over 3 years (Inactive accounts).
*/

--1.	Table Creation: Create Books, Students, and IssuedBooks (with IssueDate and ReturnDate).
Create database Digital_Library;
use Digital_Library;
create table Books(bid int AUTO_INCREMENT PRIMARY KEY, title Varchar(199) NOT NULL, author Varchar(50) NOT NULL, category Varchar(130), publisher Varchar(40), isbn VARCHAR(24) UNIQUE);
INSERT INTO Books (title, author, category, publisher, isbn) VALUES
('Foundations of Indian Agriculture', 'Ravi Kiran', 'Agriculture', 'AgriTech Press', '9780000001001'),
('Modern Data Analytics', 'Sneha Reddy', 'Technology', 'TechLearn Publications', '9780000001002'),
('Stories from Deccan', 'Anil Varma', 'Fiction', 'South India Books', '9780000001003'),
('Basics of Cloud Computing', 'Karthik Sai', 'Technology', 'NextGen Publications', '9780000001004'),
('Indian Economy Simplified', 'Meera Joshi', 'Education', 'EduWorld India', '9780000001005'),
('Journey of a Developer', 'Arjun Teja', 'Motivation', 'CodeLife Press', '9780000001006'),
('History of South Kingdoms', 'Lakshmi Narayan', 'History', 'Heritage India', '9780000001007'),
('AI for Beginners', 'Rahul Dev', 'Technology', 'FutureTech Books', '9780000001008'),
('Village Life Chronicles', 'Sita Ramulu', 'Fiction', 'Rural Stories Press', '9780000001009'),
('Mathematics Made Easy', 'Priya Sharma', 'Education', 'SmartStudy Publications', '9780000001010'),
('Krishi Mitra Guide', 'Teja', 'Agriculture', 'Self Publish', '9780000002001'),
('Journey to Placement', 'Teja', 'Motivation', 'Self Publish', '9780000002003');


Create table Students (sid int AUTO_INCREMENT PRIMARY KEY, name VARCHAR(30) NOT NULL, email VARCHAR(40) UNIQUE, phone VARCHAR(15), join_date DATE NOT NULL);
INSERT INTO Students (name, email, phone, join_date) VALUES
('saiteja', 'saiteja01@gmail.com', '9000000001', '2021-06-15'),
('harshith', 'harshith02@gmail.com', '9000000002', '2020-08-10'),
('rishith', 'rishith03@gmail.com', '9000000003', '2022-01-20'),
('bhanu', 'bhanu04@gmail.com', '9000000004', '2019-12-05'),
('kumar', 'kumar05@gmail.com', '9000000005', '2018-07-18'),
('mani', 'mani06@gmail.com', '9000000006', '2023-03-12'),
('chiru', 'chiru07@gmail.com', '9000000007', '2021-11-25'),

('akhila', 'akhila08@gmail.com', '9000000008', '2020-04-30'),
('rajini', 'rajini09@gmail.com', '9000000009', '2019-09-14'),
('santhu', 'santhu10@gmail.com', '9000000010', '2022-06-01'),
('bhavya', 'bhavya11@gmail.com', '9000000011', '2021-02-17'),
('meghana', 'meghana12@gmail.com', '9000000012', '2023-01-05'),
('rachana', 'rachana13@gmail.com', '9000000013', '2018-10-22');


 Create table IssuedBooks(isid int AUTO_INCREMENT PRIMARY KEY, bid INT NOT NULL, sid INT NOT NULL, issued_date DATE NOT NULL, return_date DATE, FOREIGN KEY (bid) REFERENCES Books(bid), FOREIGN KEY (sid) REFERENCES Students(sid));
INSERT INTO IssuedBooks (bid, sid, issued_date, return_date) VALUES
(1, 1, '2026-03-10', '2026-03-20'),  -- returned (within time)
(2, 2, '2026-03-01', NULL),          -- overdue
(3, 3, '2026-03-25', NULL),          -- not overdue
(4, 4, '2026-02-15', NULL),          -- overdue
(5, 5, '2026-03-05', '2026-03-25'),  -- returned (late)
(6, 6, '2026-03-28', NULL),          -- recent
(7, 7, '2026-02-20', NULL),          -- overdue
(8, 8, '2026-03-12', '2026-03-18'),  -- returned (within time)
(9, 9, '2026-01-30', NULL),          -- overdue
(10, 10, '2026-03-30', NULL),        -- recent
(11, 11, '2026-03-02', NULL),        -- overdue
(12, 12, '2026-03-15', '2026-03-22'),-- returned
(1, 13, '2026-02-10', NULL);         -- overdue


--2.	Overdue Logic: Write a query to find all students who haven't returned a book where the IssueDate was more than 14 days ago and ReturnDate is NULL.
select * from students s join issuedBooks d on s.sid=d.sid where DATEDIFF(CURDATE(),d.issued_date)>14 and d.return_date is null;

--3.	Popularity Index: Use COUNT and GROUP BY on the Category column to show which genre (e.g., Fiction, Science, History) is borrowed the most.
select category, count(*) as popularity_index from issuedBooks b join Books s on b.bid = s.bid group by s.category order by popularity_index desc;

--4.	Data Cleanup: Write a DELETE or UPDATE statement to remove student records who haven't borrowed a book in over 3 years (Inactive accounts).
delete from students where sid not in(select distinct sid from issuedBooks where issued_Date>=(curdate()- Interval 3 year));
--5generate a "Penalty Report" for books not returned within 14 days.
select s.sid, s.name, b.title, DATEDIFF(CURDATE(),issued_date)-14 as penalty_days, (DATEDIFF(CURDATE(),issued_date)-14)*10 as penalty_amount from Students s  join issuedBooks ib on s.sid=ib.sid join Books b on b.bid=ib.bid where ib.return_date is null and DATEDIFF(CURDATE(),ib.issued_Date)>14;
