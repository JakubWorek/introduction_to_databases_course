use library

--1.1
select title, title_no
from title

--1.2
select title, title_no
from title
where title_no=10

--1.3
select member_no, isnull(fine_assessed,0)-isnull(fine_waived,0)-isnull(fine_paid,0) as fine
from loanhist
where isnull(fine_assessed,0)-isnull(fine_waived,0)-isnull(fine_paid,0) between 8 and 9

--1.4
select title, title_no, author
from title
where author in  ('Charles Dickens', 'Jane Austen')

--1.5
select title, title_no
from title
where title like '%adventures%'

--1.6
select member_no, isnull(fine_paid,0) as finePaid
from loanhist
where isnull(fine_paid,0)=0 and isnull(fine_assessed,0)>0

--1.6 v2
select member_no, isnull(fine_paid,0) as finePaid, isnull(fine_assessed,0), isnull(fine_waived,0)
from loanhist
where isnull(fine_assessed,0) - isnull(fine_paid,0) - isnull(fine_waived,0) > 0

--1.7
select distinct city, state
from adult