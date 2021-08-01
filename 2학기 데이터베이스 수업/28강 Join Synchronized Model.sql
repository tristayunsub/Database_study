dept
deptId deptName
1       Marketing
2       Finance
3       Development

emp
empId     empName deptId
1          Jacob    1
2          David    3
3          Rachel   1
4          Maria    3

deptId를 FK로 empId PK

mysql -ujacob -p 
스키마이름안쓰고 접속하고
show schemas; 확인

use jacobdb;

mysql -ujacob -p비밀번호입력 jacobdb
하면들어갈수도있긴함

mysql -hlocalhost -P3306 -ujacob -p jacobdb

Mysql Synchronized Model
1.모델에서 스키마 이름을 변경한다.

2.메뉴의 Database - Synchronized Model
Store connection: 커넥션 이름
계속 [Next]
Model and Database Differences에서 동기화할 테이블 선택
Update Model: 데이터베이스를 모델에 반영
Update Source: 모델을 데이터베이스에 반영
