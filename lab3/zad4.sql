use library

--4.1
select firstname+' '+lastname as name,  a.street+' '+a.city+ ' '+a.state+' ' +a.zip as adress
from member as m
inner join adult as a on a.member_no=m.member_no

--4.2
select l.isbn, l.copy_no, on_loan, title, translation, cover
from loan as l
inner join copy as c on c.isbn=l.isbn
inner join title as t on l.title_no = t.title_no
inner join item as i on i.isbn = c.isbn
where l.isbn = 1 or l.isbn=500 or l.isbn=1000
group by l.isbn, l.copy_no, on_loan, title, translation, cover
order by l.isbn


--4.3
select m.member_no, firstname, lastname, r.isbn, r.log_date
from member m
left join reservation r on r.member_no=m.member_no
where m.member_no=250 or m.member_no=342 or m.member_no=1675
group by m.member_no, firstname, lastname, r.isbn, r.log_date

--4.4
use library
select m.member_no, m.firstname+m.lastname as ImieINazwisko, count(j.adult_member_no) as LiczbaDzieci
from member m
inner join adult a on a.member_no=m.member_no and a.state='AZ'
left join juvenile j on j.adult_member_no=a.member_no
group by m.member_no, m.firstname+m.lastname
having count(j.adult_member_no)>2

--4.5
select m.member_no, m.firstname+' '+m.lastname as name, count(j.adult_member_no) as liczbaDzieci
from member m
inner join adult a on a.member_no=m.member_no and a.state='AZ'
left join juvenile j on j.adult_member_no=a.member_no
group by m.member_no, m.firstname+' '+m.lastname, a.state
having count(j.adult_member_no)>2
UNION
select m.member_no, m.firstname+' '+m.lastname as name, count(j.adult_member_no) as liczbaDzieci
from member m
inner join adult a on a.member_no=m.member_no and a.state='CA'
left join juvenile j on j.adult_member_no=a.member_no
group by m.member_no, m.firstname+' '+m.lastname, a.state
having count(j.adult_member_no)>3

-- zrobić bez union
SELECT member_no, name, SUM(count_child) as liczbaDzieci, state
FROM
(
    SELECT
        m.member_no,
        m.firstname+' '+m.lastname as name,
        count(j.adult_member_no) as count_child,
        a.state as state
    FROM member m
    INNER JOIN adult a ON a.member_no=m.member_no
    LEFT JOIN juvenile j ON j.adult_member_no=a.member_no
    WHERE a.state IN ('AZ', 'CA')
    GROUP BY m.member_no, m.firstname+' '+m.lastname, a.state
    HAVING
        (a.state = 'AZ' AND count(j.adult_member_no)>2) OR
        (a.state = 'CA' AND count(j.adult_member_no)>3)
) as t
GROUP BY member_no, name, state
ORDER BY 4, 1