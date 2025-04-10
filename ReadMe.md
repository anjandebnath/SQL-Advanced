### The below link will help to find solution and understand the basics 
https://github.com/SixPenny/leetcode/blob/master/problems/175.%20Combine%20Two%20Tables.md

https://github.com/keineahnung2345/leetcode-cpp-practices/blob/master/182.%20Duplicate%20Emails.sql


### Top 20 LeetCode Problems
https://www.linkedin.com/feed/update/urn:li:activity:7284845454234689536/


#### Problem 1
`Combine two tables`
https://leetcode.com/problems/combine-two-tables/description/

#### Solution:
##### use LEFT JOIN on 2 tables
    USE mydb;
    # Write your MySQL query statement below
    select p.FirstName, p.LastName, a.City, a.State from Person p
    left join Address a on p.personid = a.personid



#### Problem 2
`Duplicate emails`
https://leetcode.com/problems/duplicate-emails/description/

#### Solution:
##### Using GROUP BY and HAVING condition 
    USE mydb;
    # Write your MySQL query statement below 
    select Email
    from Person
    group by Email
    having count(Email) > 1;  


#### Problem 3
`Customers Who Never Order`
https://leetcode.com/problems/customers-who-never-order/description/    

#### Solution:
##### Using LEFT JOIN on 2 tables
    USE mydb;
    # Write your MySQL query statement below
    select Name as Customers from Customers 
    left join Orders on Customers.Id=Orders.CustomerId where Orders.CustomerId is NULL


#### Problem 4
`Employees Earning More Than Their Managers`
https://leetcode.com/problems/employees-earning-more-than-their-managers/description/ 

#### Solution:
##### Using SELF JOIN on 1 table
    USE mydb;
    select a.Name as `Employee`
    from `Employee` as a join `Employee` as b
    on a.ManagerId = b.Id
    and a.Salary > b.Salary


#### Problem 5
`Delete duplicate emails`
https://leetcode.com/problems/delete-duplicate-emails/ 

#### Solution:
##### Using SELF JOIN on 1 table
    USE mydb;
    DELETE P2
    FROM Person AS P1
    INNER JOIN Person AS P2
    ON (P1.email = P2.email)
    WHERE P1.id < P2.id;


#### Problem 6
`Rising temperature`
https://leetcode.com/problems/rising-temperature/description/

#### Solution:
##### Using SELF JOIN and DATEDIFF() clause on 1 table
    USE mydb;
    select wt.Id as `Id`
    from `Weather` as wt join `Weather` as w 
    on datediff(wt.RecordDate, w.RecordDate) = 1
    and wt.Temperature > w.Temperature


#### Problem 7
`Employee bonus`
https://leetcode.com/problems/employee-bonus/description/

#### Solution:
##### Using LEFT JOIN on 2 tables
    USE mydb;
    SELECT e.name, b.bonus FROM Employee e
    LEFT JOIN Bonus b ON e.empid = b.empid
    WHERE b.bonus < 1000 OR b.bonus IS NULL;



#### Problem 8
`Find customer referee`
https://leetcode.com/problems/find-customer-referee/description/

#### Solution:
    USE mydb;
    SELECT name
    FROM Customer
    WHERE referee_id IS NULL OR referee_id != 2; 


#### Problem 10
`Big countries`
https://leetcode.com/problems/big-countries/

#### Solution:
    USE mydb;
    SELECT name, population, area FROM World WHERE area > 3000000
    UNION
    SELECT name, population, area FROM World WHERE population > 25000000; 


#### Problem 11
`Classes more than 5 students`
https://leetcode.com/problems/classes-more-than-5-students/description/

#### Solution:
#### Using Sub-Query & Group by
    USE mydb;
    select `class` 
    from (select `class`, count(distinct `student`) as `num`
        from `Courses`
        group by `class`) as `tmp_table` 
    where `num` >= 5;

`tmp_table
class	num
Math	5
Science	1`

#### Problem 12
`Sales person`
https://leetcode.com/problems/sales-person/description/

#### Solution:
#### Using Join and Right Join on 3 tables
    USE mydb;
    select s.name
    from Orders o join Company c on (o.com_id = c.com_id and c.name = 'RED')
    right join SalesPerson s on s.sales_id = o.sales_id
    where o.sales_id is null;


#### Problem 13
`Triangle judgement`
https://leetcode.com/problems/triangle-judgement/description/

#### Solution:
#### Create a new column pn runtime with IF statment
    USE mydb;
    SELECT *,
    IF(x + y > z AND x + z > y AND y + z > x, 'Yes', 'No') AS triangle
    FROM Triangle;


#### Problem 14
`Biggest single number`
https://leetcode.com/problems/triangle-judgement/description/


#### Problem 15
`Not boring movies`
https://leetcode.com/problems/not-boring-movies/description/

#### Solution:
#### ORDER BY
    USE mydb;
    SELECT * FROM cinema
    WHERE MOD(id, 2) = 1 AND description != 'boring'
    ORDER BY rating DESC;


#### Problem 18
`Product sales analysis 1`
https://leetcode.com/problems/product-sales-analysis-i/description/

#### Solution:
#### Using Inner Join on 2 tables
    USE mydb;
    SELECT p.product_name, s.year, s.price
    FROM Sales as s
    INNER JOIN Product as p
    USING (product_id);


#### Problem 19
`Project employees 1`
https://leetcode.com/problems/project-employees-i/description/

#### Solution:
#### Using Inner Join on 2 tables and GROUP BY [In SQL, GROUP BY is used to group rows that have the same values in specified columns into #### summary rows, like finding the total or average for each group.]
    USE mydb;
    SELECT p.project_id, ROUND(AVG(e.experience_years), 2) AS average_years
    FROM Project as p
    INNER JOIN Employee as e
    USING (employee_id)
    GROUP BY 1; 

#### Problem 19
`Sales analysis III `
https://leetcode.com/problems/project-employees-i/description/


USE mydb;
SELECT p.product_id, p.product_name
FROM Product as p
INNER JOIN Sales as s USING (product_id)
GROUP BY 1, 2
HAVING SUM(
    s.sale_date < '2019-01-01'
    OR s.sale_date > '2019-03-31'
  ) = 0;