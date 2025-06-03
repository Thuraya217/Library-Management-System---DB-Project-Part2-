the part2 of project is contain file of ( SELECT Queries, Indexes.sql Index, Views.sql, Functions.sql, StoredProcedures.sql, Triggers.sql, Aggregations.sql, AdvancedAggregations.sql, Transactions.sql ) 

1- What part was hardest and why? 
The hardest part of this project was to use AdvancedA ggregations and Transactions
- Using AdvancedA is difficult because they involved combining multiple pieces of data using GROUP BY, HAVING, and subqueries to create reports
- Using transactions was challenging because they require handling multiple database operations as one unit

2- Which concept helped them think like a backend dev? 
The concept that helped me the most was writing SQL queries and using stored functions to solve complex logic problems.
For example, calculating a book’s average rating or listing members who haven’t borrowed anything required me to think
logically and structure my data carefully.

3- How would they test this if it were a live web app?
- Simulate actions like borrowing or returning a book and make sure the book's availability updates correctly.
- Test complex queries to ensure they return the right data quickly.
- Confirm that stored procedures and triggers run automatically and correctly (e.g., setting a book to unavailable after a loan is made).
