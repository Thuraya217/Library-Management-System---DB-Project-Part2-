use Library;

-- Triggers – Real-Time Business Logic 
-- trg_UpdateBookAvailability After new loan → set book to unavailable
create trigger trg_UpdateBookAvailability
on Loan
after insert
as
begin
-- Update the Books table and set Available = 0 
update B
set B.availability_status = 0
from Books B
inner join inserted I ON B.Book_ID = B.Book_ID
end

--------------------------------------------------------------
-- trg_CalculateLibraryRevenue After new payment → update library revenue
-- add Revenue to Library table
alter table Library
add Revenue decimal(10, 2) default 0;

-- add FOREIGN KEY 
ALTER TABLE Payment
ADD CONSTRAINT FK_Payment_Library FOREIGN KEY (library_ID) REFERENCES library(library_ID);

create trigger trg_CalculateLibraryRevenue
on Payment
after insert
as
begin
update L
set L.Revenue = L.Revenue + I.amount
from Library L
join inserted I ON l.library_ID = I.library_ID;
end;
--------------------------------------------------------------
-- trg_LoanDateValidation Prevents invalid return dates on insert
create trigger trg_LoanDateValidation
on Loan
instead of insert
as 
begin
if exists ( 
select 1
from inserted
where return_date IS NOT NULL AND return_date < loan_date
)
begin
raiserror ('Error: Return date cannot be earlier than loan date.', 16, 1);
rollback transaction;
return;
end

insert into Loan (loan_ID, Book_ID, loan_date, return_date)
select loan_ID, Book_ID, loan_date, return_date
from inserted;
end


   