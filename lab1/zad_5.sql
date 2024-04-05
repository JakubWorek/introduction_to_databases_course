-- Warunki logiczne

--5.1
select Customers.CompanyName, Customers.Country
from Customers
where Customers.Country = 'Japan'
    or Customers.Country = 'Italy'

select CompanyName, Country
from Customers
where Country IN ('Japan', 'Italy')