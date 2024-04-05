use library

--2.1
select title
from title
order by 1

--2.2.1
select member_no, isbn, fine_assessed
from loanhist
where isnull(fine_assessed,0)>0

--2.2.2
select member_no, isbn, fine_assessed, 2*fine_assessed as 'double fine'
from loanhist
where isnull(fine_assessed,0)>0

--2.3.1
select firstname + middleinitial + lastname
from member
where lastname='Anderson'

--2.3.2
select firstname + middleinitial + lastname as email_name
from member
where lastname='Anderson'

--2.3.4
select lower(firstname + middleinitial + substring(lastname, 1, 2))
from member
where lastname='Anderson'

--2.4
select 'The title is: '+ title + ', title number '+ str(title_no) as "Tytul i ilosc"
from title

-- mozna uzyc cast(title_no as varchar)
select 'The title is: '+ title + ', title number '+ cast(title_no as varchar) as "Tytul i ilosc"
from title

-- mozna tez convert(varchar, title_no)
select 'The title is: '+ title + ', title number '+ convert(varchar, title_no) as "Tytul i ilosc"
from title
