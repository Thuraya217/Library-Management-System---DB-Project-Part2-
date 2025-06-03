use Library;

-- Advanced Aggregations – Analytical Insight 
-- HAVING for filtering aggregates   
select genre,
AVG(price) AS AvgPrice
from Books 
group by genre
having AVG(price) > 20;
-----------------------------------------------------------------
-- Subqueries for complex logic (e.g., max price per genre) 
select book_ID, title, genre, price
from Books B
where price = (
select MAX(price)
from Books
where genre = B.genre
);

-----------------------------------------------------------------
-- Occupancy rate calculations
select L.library_ID, L.name as LibraryName, COUNT(B.Book_ID) as TotalBooks,
SUM(CASE when LO.status = 'Issued' AND LO.return_date IS NULL then 1 ELSE 0 END) as IssuedBooks,
CAST( SUM(CASE WHEN LO.status = 'Issued' AND LO.return_date IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(B.Book_ID) as DECIMAL(5,2)) AS OccupancyRate
from Library L
join Books B ON L.library_ID = B.library_ID
left join Loan LO ON LO.Book_ID = B.Book_ID
group by L.library_ID, L.name;

-----------------------------------------------------------------
-- Members with loans but no fine 
select M.members_ID, M.full_name
from Members M
join loan L on M.members_ID = L.members_ID
left join Payment P on L.loan_ID = P.loan_ID
where P.amount IS NULL
group by M.members_ID, M.full_name;

-----------------------------------------------------------------
-- Genres with high average ratings 
select B.genre,AVG(R.rating) as AverageRating
from Books B
join  Review R on B.Book_ID = R.Book_ID
group by B.genre
having AVG(R.rating) >= 5;
