Like
#이름이 '이병'으로 시작하는 사람 (좋은쿼리)
SELECT peopleCd, name FROM people WHERE name LIKE '이병%';

#이름이 '병헌'으로 끝나는 사람(나쁜 쿼리)
SELECT peopleCd, name FROM people WHERE name LIKE '%병헌';
범위 검색이 불가능함. 2번째이름으로해벌면
type이 index와 all은 같은거다. 사실상 풀스캔한거임

#이름이 중간에 '병'이 들어가는 사람(나쁜 쿼리)
SELECT peopleCd, name FROM people WHERE name LIKE '%병%';

# %로 시작하는 Like 검색은 인덱스를 사용하지 않으므로 쓰지 않는다.


show create table people;

explain select peopleCd, name from people where name like '이병%'

alter table people add key (name);

name 컬럼에 name_2 라는 일반키가 생성.

select peopleCd, name from people where name like '이병%'
하니까 이번에는 0.001 초만에 검색 완료

explain 해보면 type이 range가 나온다.

실행 계획(Explain)
range 인덱스를 범위로 검색
ALL 테이블 full scan
fulltext 전문검색 인덱스를 사용
ref 인덱스에 equal 검색
eq-ref 조인에서 두번째 이후에 읽는 테이블의 프라이머리 키로 조인
const primary key나 unique key를 사용해서 1건을 가져오는 쿼리



select peopleCd, name from people where name >='이병' and <'이볒';
하면 0.00sec만에 검색이가능

use employees;

desc employees;

employee에 first name last name

select emp_no, last_name from employees where last_name like 'Fa'
fa로 시작하는 이름이나옴 3108

show variables like 'collation%';
case insensitive 대소문자 설정. insensitive는 대소문자 구분안함

select emp_no, last_name from employees where last_name>= 'faa' and last_name<='faz'


Full-Text Search(전문 검색)
1.설정 확인
>show variables like 'innodb_ft_%';

2.설정을 변경하고 MariaDB 재시작
sudo vi /etc/mysql/mariadb.conf.d/50-server.cnf

[mysqldb]
innodb_ft_min_token_size =2 최소글자수 2글자검색. 1글자로는 잘안하고

sudo service mariadb restart


3. 설정을 변경한 후에는 fulltext index를 다시 만든다.

sudo service mariadb restart

mysql -ujacob -p

show variables like 'innodb_ft_%';

alter table movie add fulltext key(title);

select movieCd, title from movie where match(title) 
against('열정*, 파리' in boolean mode);
이게 먹는다.

게시글 이런데는 제목이나 내용ㅇ은 fulltext index를 만들어놔야함

select * form people where name like '김%';
이건 왜 all 김씨가 너무많아 전체의 20퍼센트가까이 된다.

select count(*) from people where name like '김%';

select count(*) from people;

옵티마이저가 인덱스를 만들었다고해서 무조건 인덱스를 사용하진않다.

김씨나 이씨는 너무 사람이많고, 박씨는 사람이적으니까

select title from movie limit 100;
제목들이 단어별로 seperator로 다자른다.
쪼개서 인덱스 만들어놓는다.
full-text index를 사용해서 검색


select * from movie where match(title) against('휴일');

로마의 휴일

select movieCd, title from movie where match(title) against('로마');




