desc employees;

Feild             Type 
emp_no            int(11)
birth_date        date
first_name        varchar
last_name         varchar
gender            enum('M','F')
hire_date          date

select emp_no, first_name, last_name from employees where fisrt name='Tommaso'

select count(*) from employees;

count 
30만건
30만건을 처음부터 다본거다 first name이 뭔지.

explain 명령어
table full scan



alter table employees add key(first_name);
키를 준다

다시 수행해보면 select해보면 0.003초 속도가 10분의일정도로 빨라짐

type이
all과 
ref로 나오는데. index사용해서 검사했다.

select distinct first_name from employees order by first_name;


