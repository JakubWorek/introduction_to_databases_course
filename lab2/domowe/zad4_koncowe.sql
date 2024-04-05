--4.1
use Northwind
select EmployeeID, MONTH(OrderDate) as Month, YEAR(OrderDate) as Year, COUNT(*) as Qtty
from Orders
group by EmployeeID, YEAR(OrderDate), MONTH(OrderDate)
order by EmployeeID, YEAR(OrderDate), MONTH(OrderDate)

--4.2
use Northwind
select CategoryID, MIN(UnitPrice) as minPrice, MAX(UnitPrice) as maxPrice
from Products
group by CategoryID