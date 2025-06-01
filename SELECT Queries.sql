use Library; 

-- SELECT Queries
-- List all overdue loans with member name, book title, due date 
select L.loan_ID, M.full_name as MemberName, B.title as BookTitle, L.due_date
FROM Loan L 
join Members M ON L.members_ID = M.members_ID
join Books B ON L.Book_ID = B.Book_ID
where L.due_date <GETDATE() and  L.status!='Returned';

-- List books not available  
select B.Book_ID , B.title
from Books B
JOIN Loan L on B.Book_ID = L.Book_ID
where L.status IN ('Issued','Overdue') AND L.return_date IS NULL

-- Members who borrowed >2 books
select M.members_ID, M.full_name, COUNT (L.loan_ID) AS TotalLoan 
from Members M
join Loan L on M.members_ID = L.members_ID
group by M.members_ID, M.full_name
having count (L.loan_ID)>2;

-- Show average rating per book
select B.Book_ID, B.title, AVG (R.rating) as AverageRating
from Books B
join Review R on B.Book_ID = R.Book_ID
where B.Book_ID = 3
group by B.Book_ID, B.title

-- Count books by genre
select B.genre, count (*) as TotalBooks
from Books B
where B.library_ID = 2
group by B.genre

-- List members with no loans 
select M.members_ID, M.full_name
from Members M
left join Loan L on M.members_ID = L.members_ID
where L.loan_ID IS NULL

-- Total fine paid per member 
select M.members_ID, M.full_name,SUM(P.amount) AS totalFinesPaid
from Members M
join Loan L on M.members_ID = L.members_ID
join Payment P on L.loan_ID = P.loan_ID
group by M.members_ID, M.full_name;

-- Reviews with member and book info
select R.review_ID, M.members_ID, M.full_name AS MemberName, B.Book_ID, B.title AS BookTitle, R.rating, R.comments, R.review_date
from Review R
join Members M ON R.members_ID = M.members_ID
join Books B ON R.Book_ID = B.Book_ID;

-- List top 3 books by number of times they were loaned
select B.title, COUNT(*) as LoanCount
from Loan L
join Books B ON L.Book_ID = B.Book_ID
GROUP BY B.title
ORDER BY LoanCount DESC

-- Retrieve full loan history of a specific member including book title, loan & return dates 
select L.loan_ID, B.title, L.loan_date, L.due_date, L.return_date, L.status
from Loan L
join Books B ON L.Book_ID = B.Book_ID
where L.members_ID = 2
order by L.loan_date DESC;

-- Show all reviews for a book with member name and comments 
select R.review_ID, M.full_name AS MemberName, R.rating, R.comments, R.review_date
FROM Review R
JOIN Members M ON R.members_ID = M.members_ID
WHERE R.Book_ID = 3
ORDER BY R.review_date DESC;

-- List all staff working in a given library 
select S.staff_ID, S.FullName, S.position
FROM Staff S
WHERE S.library_ID = 2;

-- Show books whose prices fall within a given range 
select Book_ID, title, price
from Books
where price BETWEEN 10.00 AND 26.00;

-- List all currently active loans (not yet returned) with member and book info 
select L.loan_ID, M.full_name AS MemberName, B.title AS BookTitle, L.loan_date, L.due_date
from Loan L
join Members M ON L.members_ID = M.members_ID
join Books B ON L.Book_ID = B.Book_ID
where L.return_date IS NULL;

-- List members who have paid any fine 
SELECT M.members_ID, M.full_name
from Members M
join Loan L ON M.members_ID = L.members_ID
join Payment P ON L.loan_ID = P.loan_ID;

-- List books that have never been reviewed 
select B.Book_ID, B.title
from Books B
left join Review R ON B.Book_ID = R.Book_ID
where R.Book_ID IS NULL;

-- Show a member’s loan history with book titles and loan status. 
select L.loan_ID, B.title AS BookTitle, L.loan_date, L.due_date, L.return_date, L.status
from Loan L
join Books B ON L.Book_ID = B.Book_ID
where L.members_ID = 6
order by L.loan_date DESC;

-- List all members who have never borrowed any book. 
select M.members_ID, M.full_name
from Members M
left join Loan L ON M.members_ID = L.members_ID
where L.loan_ID IS NULL;

-- List books that were never loaned. 
select B.Book_ID, B.title, B.genre, B.price
from Books B
left join Loan L ON B.Book_ID = L.Book_ID
where L.loan_ID IS NULL;

-- List all payments with member name and book title. 
select P.payment_ID, P.payment_date, P.amount, M.full_name AS MemberName, B.title AS BookTitle
from Payment P
join Loan L ON P.loan_ID = L.loan_ID
join Members M ON L.members_ID = M.members_ID
join Books B ON L.Book_ID = B.Book_ID;

-- List all overdue loans with member and book details. 
select L.loan_ID, M.full_name AS MemberName, B.title AS BookTitle, L.due_date
from Loan L
join Members M ON L.members_ID = M.members_ID
join Books B ON L.Book_ID = B.Book_ID
where L.due_date < GETDATE() AND L.status != 'Returned';

-- Show how many times a book has been loaned. 
select B.Book_ID, B.title, COUNT(L.loan_ID) AS TimesLoaned
from Books B
left join Loan L ON B.Book_ID = L.Book_ID
group by B.Book_ID, B.title
order by TimesLoaned DESC;

-- Get total fines paid by a member across all loans. 
select  M.members_ID, M.full_name, SUM(P.amount) AS TotalFinesPaid
from Members M
join Loan L ON M.members_ID = L.members_ID
join Payment P ON L.loan_ID = P.loan_ID
group by M.members_ID, M.full_name;

-- Show count of available and unavailable books in a library.
select availability_status, COUNT(*) AS BookCount
from Books
where library_ID = 1
group by availability_status;

-- Return books with more than 5 reviews and average rating > 4.5. 
select  B.Book_ID, B.title, COUNT(R.review_ID) AS ReviewCount, AVG(R.rating) AS AverageRating
from Books B
join Review R ON B.Book_ID = R.Book_ID
group by B.Book_ID, B.title
having COUNT(R.review_ID) > 5 AND AVG(R.rating) > 4.5;

