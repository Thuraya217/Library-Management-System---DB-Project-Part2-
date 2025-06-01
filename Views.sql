use Library;

-- Views– Frontend Integration Support 
-- ViewPopularBooks Books with average rating > 4.5 + total loans 
create view ViewPopularBooks AS
select B.Book_ID, B.title, B.genre, B.price, AVG(R.rating) AS AverageRating, COUNT(DISTINCT L.loan_ID) AS TotalLoans
from Books B
left join Review R ON B.Book_ID = R.Book_ID
left join Loan L ON B.Book_ID = L.Book_ID
group by  B.Book_ID, B.title, B.genre, B.price
having  AVG(R.rating) > 4.5;

-- to use ViewPopularBooks
select * from ViewPopularBooks order by TotalLoans DESC;
--------------------------------------------------------------------------------

-- ViewMemberLoanSummary Member loan count + total fines paid 
create view ViewMemberLoanSummary AS
select M.members_ID, M.full_name, COUNT(DISTINCT L.loan_ID) AS LoanCount, ISNULL(SUM(P.amount), 0) AS TotalFinesPaid
from Members M
left join Loan L ON M.members_ID = L.members_ID
left join Payment P ON L.loan_ID = P.loan_ID
group by M.members_ID, M.full_name;

-- to use ViewMemberLoanSummary
select * from ViewMemberLoanSummary order by TotalFinesPaid DESC;
--------------------------------------------------------------------------------

-- ViewAvailableBooks Available books grouped by genre, ordered by price 
create view ViewAvailableBooks AS
select Book_ID, title, genre, price, availability_status
from Books
where availability_status = 'Available';

-- to use ViewAvailableBooks
select * from ViewAvailableBooks order by genre, price ASC;
-------------------------------------------------------------------------------

-- ViewLoanStatusSummary Loan stats (issued, returned, overdue) per library 
create view ViewLoanStatusSummary AS
select B.library_ID, COUNT(CASE WHEN L.status = 'Issued' THEN 1 END) AS IssuedCount, COUNT(CASE WHEN L.status = 'Returned' THEN 1 END) AS ReturnedCount, COUNT(CASE WHEN L.status = 'Overdue' THEN 1 END) AS OverdueCount
from Loan L
join Books B ON L.Book_ID = B.Book_ID
group by B.library_ID;

-- to use ViewLoanStatusSummary
select * from ViewLoanStatusSummary order by library_ID;
-------------------------------------------------------------------------------

-- ViewPaymentOverview Payment info with member, book, and status 
create view ViewPaymentOverview AS
select P.payment_ID, P.payment_date, P.amount, P.method, M.full_name AS MemberName, B.title AS BookTitle, L.status AS LoanStatus
from Payment P
join Loan L ON P.loan_ID = L.loan_ID
join Members M ON L.members_ID = M.members_ID
join Books B ON L.Book_ID = B.Book_ID;

-- to use ViewPaymentOverview
select * from ViewPaymentOverview order by payment_date DESC;


