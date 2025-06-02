use Library;
-- Functions – Reusable Logic
-- GetBookAverageRating(BookID): Returns average rating of a book 
create function GetBookAverageRating
( @Book_ID INT ) --Input parameter Book_ID
returns decimal(3, 2)
as
begin
declare @AverageRating decimal(3, 2);
select  @AverageRating = AVG(CAST(rating AS decimal(3, 2)))
from Review
where Book_ID = @Book_ID;
return @AverageRating;
end;

---------------------------------------------------------------------

-- GetNextAvailableBook(Genre, Title, LibraryID): Fetches the next available book
create function GetNextAvailableBook
( @genre nvarchar(50), @title nvarchar(50), @LibraryID INT)
returns INT
as
begin
declare @NextBookID INT;
select top 1 @NextBookID = Book_ID
from Books
where genre = @genre AND title = @title AND library_ID = @libraryID AND availability_status = 'Available'
order by Book_ID ASC;
return @NextBookID;
end;

---------------------------------------------------------------------

-- CalculateLibraryOccupancyRate(LibraryID): Returns % of books currently issued
create function CalculateLibraryOccupancyRate
( @LibraryID INT ) --Input parameter Book_ID
returns decimal(5, 2)
as
begin declare @TotalBooks INT; declare @IssuedBooks INT; declare @OccupancyRate decimal(5, 2);
-- Count total books in the library
select @TotalBooks = COUNT(*)
from Books 
where Library_ID = @LibraryID;

-- Count how many of those books are currently issued
select @IssuedBooks = COUNT(*)
from Books B
join Loan L on L.Book_ID = B.Book_ID

where B.Library_ID = @LibraryID AND L.status = 'Issued';
IF @TotalBooks = 0
SET @OccupancyRate = 0; else
SET @OccupancyRate = (CAST(@IssuedBooks AS DECIMAL(5,2)) / @TotalBooks) * 100;

return @OccupancyRate;
end;

---------------------------------------------------------------------

-- fn_GetMemberLoanCount: Return the total number of loans made by a given member
create function fn_GetMemberLoanCount
( @MemberID INT )
returns INT
as
begin
declare @LoanCount INT;
select @LoanCount = COUNT(*)
from Loan 
where members_ID = @MemberID;
return @LoanCount;
end;

---------------------------------------------------------------------

-- fn_GetLateReturnDays: Return the number of late days for a loan (0 if not late)
create function fn_GetLateReturnDays
( @LoanID INT )
returns INT
as
begin
declare @LateDays INT;
select @LateDays = 
case 
when ReturnDate IS NULL THEN 0
when ReturnDate > DueDate THEN DATEDIFF(DAY, DueDate, ReturnDate)
else 0
end
from Loan
where loan_ID = @LoanID;
return ISNULL(@LateDays, 0);
end;

---------------------------------------------------------------------
-- fn_ListAvailableBooksByLibrary Returns a table of available books from a specific library
create function fn_ListAvailableBooksByLibrary
( @libraryID INT )
returns table
as
return
( select Book_ID, title, ISBN, genre, library_ID 
from Books
where library_ID = @libraryID AND availability_status = 'Available');

---------------------------------------------------------------------
-- fn_GetTopRatedBooks: Returns books with average rating ≥ 4.5
create function fn_GetTopRatedBooks ()
returns table
as
return (
select B.Book_ID, B.title, B.ISBN, B.genre, library_ID, AVG(CAST(R.rating as decimal(3, 2))) as AverageRating 
from Books B
join Review R on B.Book_ID = R.Book_ID
group by B.Book_ID, B.title, B.ISBN, B.genre, B.library_ID
having AVG(CAST(R.Rating as decimal(3, 2))) >= 4.5
);

---------------------------------------------------------------------
-- fn_FormatMemberName: Returns  the  full  name  formatted  as  "LastName, FirstName" 
create function fn_FormatMemberName
( @members_ID INT )
returns NVARCHAR(100)
as
begin
declare @full_name NVARCHAR(200);
select @full_name = full_name
from Members
where members_ID = @members_ID;
return @full_name;
end;