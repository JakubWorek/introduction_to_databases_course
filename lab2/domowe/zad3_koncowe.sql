--3.1
use Northwind
select employeeid, count(*)
from Orders
group by employeeid
order by 2 desc

--3.2
use Northwind
select ShipVia, SUM(Freight)
from Orders
group by ShipVia

--3.3
use Northwind
select ShipVia, SUM(Freight)
from Orders
where YEAR(ShippedDate) = 1996 or YEAR(ShippedDate) = 1997
group by ShipVia