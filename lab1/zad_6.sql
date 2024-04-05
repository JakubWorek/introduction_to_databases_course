-- Wartosci NULL

--6.1
select OrderID, OrderDate, Customers.CustomerID
from Orders
inner join Customers on Orders.CustomerID=Customers.CustomerID
where ((ShippedDate is null) or (ShippedDate > GETDATE())) and ShipCountry ='argentina'