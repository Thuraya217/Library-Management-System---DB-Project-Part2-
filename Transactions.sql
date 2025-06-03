use Library;

-- Transactions – Ensuring Consistency 
-- Borrowing a book (loan insert + update availability)
DECLARE @loan_ID INT = 1;        
DECLARE @Book_ID INT = 2;       
DECLARE @members_ID INT = 3;

begin Transaction;
if EXISTS ( select 1 from Books where book_id = @Book_ID AND availability_status = 'available' )
begin
-- Insert the loan record
insert into Loan (loan_id, book_id, members_ID, loan_date, due_date, return_date, status)
values (@loan_ID, @Book_ID, @members_ID, GETDATE(), DATEADD(DAY, 10, GETDATE()), NULL, 'Issued');

-- Update book status to 'borrowed'
update Books
set availability_status = 'borrowed'
where book_id = @Book_ID;

-- If no errors, commit; otherwise, rollback
if @@ERROR = 0
begin
     COMMIT TRANSACTION;
     print 'Loan created and book status updated successfully.';
end
else
begin
     ROLLBACK TRANSACTION;
     print 'Error occurred. Transaction rolled back.';
end
end
else
begin
    ROLLBACK TRANSACTION;
    print 'The book is not available for borrowing.';
end
EXEC sp_helptext 'trg_LoanDateValidation';
------------------------------------------------------
-- Returning a book (update status, return date, availability) 
DECLARE @loanid INT = 5;        
DECLARE @Bookid INT = 6;   

BEGIN TRANSACTION;
-- Update the loan record
update Loan
set return_date = GETDATE(),
    status = 'Returned'
where loan_id = @loanid;

--  Update the book's availability to 'available'
update Books
set availability_status = 'available'
where book_id = @Bookid;

--  If no errors, commit the transaction; otherwise, roll back
if @@ERROR = 0
begin
    COMMIT TRANSACTION;
    print 'Book returned and status updated successfully.';
end
else
begin
    ROLLBACK TRANSACTION;
    print ' An error occurred during the return process. Transaction rolled back.';
end
 
------------------------------------------------------
-- Registering a payment (with validation)
DECLARE @payment_ID INT = 101;        
DECLARE @loans_id INT = 5;             
DECLARE @payment_amount DECIMAL(10,2) = 15.00;
DECLARE @payment_date DATETIME = GETDATE();
DECLARE @payment_method VARCHAR(50) = 'cash';
DECLARE @library_ID INT = 1;  

BEGIN TRANSACTION;
-- Check if loan exists
if EXISTS (SELECT 1 FROM Loan WHERE loan_id = @loans_id)
begin
-- Check if payment amount is positive
if @payment_amount > 0
begin
-- Insert payment record with all required columns
insert into Payment (payment_ID, payment_date, amount, method, loan_ID, library_ID)
values (@payment_ID, @payment_date, @payment_amount, @payment_method, @loans_id, @library_ID);

if @@ERROR = 0
begin
   COMMIT TRANSACTION;
   PRINT 'Payment registered successfully.';
end
else
begin
   ROLLBACK TRANSACTION;
   PRINT 'Error occurred during payment registration. Transaction rolled back.';
end
end
else
begin
   ROLLBACK TRANSACTION;
   PRINT 'Payment amount must be greater than zero.';
end
end
else
begin
   ROLLBACK TRANSACTION;
   PRINT 'Loan ID not found. Payment registration aborted.';
end
------------------------------------------------------
-- Batch loan insert with rollback on failure
begin TRANSACTION;
-- Insert multiple loan records in a batch
insert into Loan (loan_ID, Book_ID, members_ID, loan_date, due_date, return_date, status)
values
      (100, 1, 1001, GETDATE(), DATEADD(DAY, 14, GETDATE()), NULL, 'Issued'),
      (200, 2, 1002, GETDATE(), DATEADD(DAY, 14, GETDATE()), NULL, 'Issued'),
      (300, 3, 1003, GETDATE(), DATEADD(DAY, 14, GETDATE()), NULL, 'Issued');
-- Check for errors after the insert
if @@ERROR <> 0
begin
    ROLLBACK TRANSACTION;
    PRINT ' Error occurred during loan insertion. Transaction rolled back.';
    RETURN;
end
-- Update book status to 'borrowed'
update Books
set availability_status = 'borrowed'
where book_id IN (1, 2, 3);
-- Check for errors after the update
if @@ERROR <> 0
begin
    ROLLBACK TRANSACTION;
    PRINT ' Error occurred while updating book status. Transaction rolled back.';
    RETURN;
end
-- If all went well, commit the transaction
COMMIT TRANSACTION;
PRINT 'Batch loans inserted and book status updated successfully.';

-------------------------------------------------------------------
ALTER TABLE Loan ALTER COLUMN due_date DATETIME NULL;
ALTER TABLE Loan ALTER COLUMN members_ID INT NULL;

SELECT * from Loan