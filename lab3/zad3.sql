use northwind

--3.1 pracownicy i ich podwładni
select e.firstname+' '+e.lastname as Pracownik, ee.firstname+' '+ee.lastname as Podwladny
from employees as e
inner join employees as ee on ee.reportsto=e.EmployeeID
group by e.firstname+' '+e.lastname, ee.firstname+' '+ee.lastname with rollup
having e.firstname+' '+e.lastname is not null and ee.firstname+' '+ee.lastname is not null

--3.1 better
select a. employeeid, a.FirstName + a. LastName as Szef ,
       b. EmployeeID, b. FirstName + b. LastName as Podwładny
from Employees as a
join Employees as b
on b. ReportsTo = a. EmployeeID

--3.2 pracownicy bez podwładnych
select e.firstname+' '+e.lastname as Pracownik
from employees as e
left join employees as ee on ee.reportsto=e.EmployeeID
group by e.firstname+' '+e.lastname
having count(ee.employeeid)=0

------------------------------------
use library

--3.3
select a.member_no, a.street+' '+a.city+ ' '+a.state as Address
from adult as a
inner join juvenile j on j.adult_member_no=a.member_no
where j.birth_date < '1996/01/01'

--3.4
select a.member_no, a.street+' '+a.city+ ' '+a.state as Address
from adult as a
inner join juvenile j on j.adult_member_no=a.member_no and j.birth_date < '1996/01/01'
left join loan l on l.member_no=a.member_no
group by a.member_no, a.street+' '+a.city+ ' '+a.state
having count(l.isbn)=0
