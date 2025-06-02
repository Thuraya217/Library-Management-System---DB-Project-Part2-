use Library;

-- Stored Procedures – Backend Automation 
-- sp_MarkBookUnavailable(BookID) Updates availability after issuing 
create Procedure sp_MarkBookUnavailable
@Book_ID INT
as
begin
update Books
set availability_status = 'Unavailable'
where Book_ID = @Book_ID;
end;

-------------------------------------------------------------------------
-- sp_UpdateLoanStatus() Checks dates and updates loan statuses 
create Procedure sp_UpdateLoanStatus
as
begin
-- Update loans that are overdue and not yet returned and use Late
update Loan
set status = 'Late'
where return_date IS NULL AND due_date < CAST(GETDATE() AS DATE) AND Status <> 'Late';
-- Update loans that have been returned by use Returned
update Loan
set status = 'Returned'
where return_date IS NOT NULL AND Status <> 'Returned';
end;

-------------------------------------------------------------------------
-- sp_RankMembersByFines() Ranks members by total fines paid
create Procedure sp_RankMembersByFines
as
begin
select M.members_ID, M.full_name, SUM(P.amount) as TotalFines,
RANK() over (order by SUM(P.amount) DESC) AS FineRank
from Members M
join Loan L ON M.members_ID = L.members_ID
JOIN Payment P ON L.Loan_ID = P.Loan_ID
group by M.members_ID, M.full_name
order by TotalFines DESC;
end;

EXEC sp_RankMembersByFines;