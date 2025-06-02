use Library;

-- Aggregation Functions – Dashboard Reports 
-- Total fines per member 
select M.members_ID,M.full_name,
SUM(DATEDIFF(DAY, L.due_date, L.return_date) * 0.5) as TotalFines
from Members M
join Loan L on M.members_ID = l.members_ID
where L.return_date > l.due_date
group by M.members_ID, M.full_name;

---------------------------------------------------------------
-- Most active libraries (by loan count)
select L.library_ID, L.name, COUNT(LO.loan_ID) AS TotalLoans
from Library L
Join Books B on L.library_ID = B.library_ID
Join Loan LO ON LO.Book_ID = B.Book_ID
group by L.library_ID, L.name
order by TotalLoans DESC;

--------------------------------------------------------------
-- Avg book price per genre
select genre, AVG(price) AS AvgBookPrice
from Books
group by genre
order by AvgBookPrice DESC;

--------------------------------------------------------------
-- Top 3 most reviewed books
select top 3 B.Book_ID, B.title, COUNT(r.review_ID) AS TotalReviews
from Books B
join Review R ON b.Book_ID = R.Book_ID
Group by B.Book_ID, B.title
Order by TotalReviews DESC;

--------------------------------------------------------------
-- Library revenue report 
select L.library_ID, L.name, SUM(P.amount) AS TotalRevenue
from Library L
join Books B on L.library_ID = B.library_ID
join Loan LO on B.Book_ID = LO.Book_ID
join  Payment P on LO.loan_ID = P.loan_ID
group by L.library_ID, L.name
order by TotalRevenue DESC;

--------------------------------------------------------------
-- Member activity summary (loan + fines)
select M.members_ID, M.full_name, COUNT(LO.loan_date) AS LoanCount, ISNULL(SUM(P.amount), 0) as TotalFineAmount
from Members M
left join Loan lO ON M.members_ID = LO.members_ID
left join Payment P ON LO.loan_ID = P.loan_ID  
group by M.members_ID, M.full_name
order by LoanCount DESC, TotalFineAmount DESC;






