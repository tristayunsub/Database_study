string functions
date & time functions
numeric functions
control flow functions
group functions가 있다.


한번씩은 알아볼필요가 있다.

String Functions

--concat, left, substr, length, char_length
concat은 문자열 합치기.

select movieCd, title, titleEn from movie
limit 10;
select movieCd, concat(title,'(',titleEn,')') as fullTitle from movie
limit 10;


use employees;
select emp_no, concat(fisrt_name,' ',last_name)emp_name
from employees;
limit 10;

first와 lastname을 공백으로

Aamer Anger
Aamer Armand 이런식으로

함수를 썻을땐 항상 재정리해서 컬럼명쓴다.

left는 왼쪽에서 7글자

substr은 몇번째 글자에서 몇 개.

use jacobdb;
select movieCd, title, left(openDate,7) yearMonth
from movie limit 10;

select movieCd,title,length(title) leng_title
        , char_length(title)charlength_title
from movie
limit 10;
의적 2글자지만 한글은 3바이트니까 6바이트

장화홍련전 leng_title 15, charleng_Title 5


select curdate(), curtime(), now;

현재날짜, 현재시간, 현재 날짜시간

select adddate(curdate(), 100);
현재 날짜에 100일더함

select addtime(now(),'24:00')
24시간 더한 값

select datediff('2020-12-25',curdate());
뺄샘 

select timediff('2020-11-24 18:00', now());
18시간16분 24초 시간 뺄샘

select date_Format(curdate(), %a, %d %b %Y);
Mon, 23 Nov 2020


select last_day('2021-02-01');
달의 마지막일
2021-02-28일

select last_day('2020--11-24')
2020-11-30


--Numeric functions

select floor(5.6);

select round(5.4);

select abs(-34);

select pi();
3.141593

select rand();

select floor (rand()*6+1);

select floor(rand()*6+1);

Control Flow functions


SELECT movieCd, title, openDate,
 조건    if(openDate>='2020-01-01','올해 영화','지난 영화') category
FROM movie ORDER BY title LIMIT 100;
2020-01-01 지나면 지난영화가 되는것.



alter table people modify nameEn varchar(100) null;
nameEn 필드에 null이 yes가 됨


update people set nameEn=null where nameEn='';
데이터가 없는 값은 NULL로뜬다.
숫자는 값이없으면 null로 써야될 경우가있다.

마리아디비에서 null은 특별하다.

select null=null;

select * from people where name=null;
empty set
null은 애초에 비교 자체가 안됨

select peopleCd, name, nameEn is null from people limit 10;

이면 null이면 1 아니면 0

영문이름이 없는사람 출력

select peopleCd, name, nameEn from people where nameEn is not null limit 10;


select peopleCd, name, if(nameEn is null, '', nameEn) nameEn from
people limit 10;



select peopleCd, name, ifnull(nameEn, '') nameEn from
people limit 10;




