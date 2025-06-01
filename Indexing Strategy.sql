use Library

-- Indexing Strategy
-- Library Table 
-- Non-clustered on Name → Search by name 
create nonclustered index IX_Library_name
ON Library(name);

select * from Library where Name = 'Central City Library';

-- Non-clustered on Location → Filter by location
create nonclustered index IX_Library_Location
ON Library(location);

select * from Library where location = 'Northside';
--------------------------------------------------------------------
-- Book Table 
-- Clustered on LibraryID, ISBN → Lookup by book in specific library
create nonclustered index IX_Books_Library_ID_ISBN
ON Books(library_ID, ISBN)

select * from Books where library_ID = 1 AND ISBN = '978-0140449136';

-- Non-clustered on Genre → Filter by genre 
create nonclustered index IX_Library_genre
ON Books(genre);

select * from Books where genre = 'Fiction';
--------------------------------------------------------------------
-- Loan Table 
-- Non-clustered on MemberID → Loan history 
create nonclustered index IX_Loan_MembersID
ON Loan(members_ID);

select * from Loan where members_ID = 3;

-- Non-clustered on Status → Filter by status
create nonclustered index IX_Loan_Status
ON Loan(status);

select * from Loan where status = 'Overdue';

-- Composite index on BookID, LoanDate, ReturnDate → Optimize overdue checks
create nonclustered index IX_Loan_Book_LoanDate_ReturnDate
ON Loan(Book_ID, loan_date, return_date);
