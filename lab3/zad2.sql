use Northwind

--2.1
select productname, unitprice, address
from products
inner join suppliers s on s.supplierid =products.SupplierID
inner join Categories c on c.CategoryID=products.CategoryID
where unitprice between 20 and 30 and categoryname like 'Meat/Poultry'

--2.2
select productname, unitprice, CompanyName
from products
inner join suppliers s on s.supplierid =products.SupplierID
inner join Categories c on c.CategoryID=products.CategoryID
where categoryname like 'Confections'


--2.3
select distinct customers.CompanyName, customers.Phone
from Customers
inner join orders o on o.CustomerID=customers.CustomerID
inner join shippers s on s.ShipperID=o.ShipVia
where s.CompanyName='United Package' and year(o.shippeddate)=1997

--2.4
select distinct c.CompanyName, c.Phone
from Customers c
inner join orders o on o.CustomerID=c.CustomerID
inner join [Order Details] od on od.OrderID=o.OrderID
inner join products p on p.ProductID=od.ProductID
inner join categories cc on cc.CategoryID=p.CategoryID and categoryname='Confections'

-----------------------------------
use library

--2.5
select m.firstname,m.lastname,j.birth_date,
       a.street+' '+a.city+ ' '+a.state as Address
from member as m
inner join juvenile j on j.member_no=m.member_no
inner join adult a on a.member_no=j.adult_member_no

--2.6
select m.firstname as imieDziecka ,m.lastname as nazwiskoDziecka,
       j.birth_date,a.street+' '+a.city+ ' '+a.state as Address,
       ma.firstname as imieRodzica, ma.lastname as nazwiskoRodzica
from member as m
inner join juvenile j on j.member_no=m.member_no
inner join adult a on a.member_no=j.adult_member_no
inner join member ma on ma.member_no=a.member_no
order by nazwiskoRodzica