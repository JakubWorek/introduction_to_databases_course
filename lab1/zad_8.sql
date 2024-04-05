--Eliminacja duplikatow i łączenie isnulli

--8.1
select distinct Country
from Customers

--8.2
select concat(Phone, ', ', Fax) as "Kontakt"
from Suppliers

select isnull(Phone, '') + ', ' + isnull(Fax, '') as "Kontakt"
from Suppliers
