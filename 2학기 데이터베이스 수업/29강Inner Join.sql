#USING으로 조인(조인하는 컬럼명이 같은 경우)
SELECT empId, empName, deptId, deptName
FROM emp JOIN dept USING(deptId);
emp와 dept테이블을 옆으로 붙인다. 엑셀시트를 옆으로 붙임. 그 조건을 Using뒤에들어간다.


select *
from emp join dept;
// empId empName deptId deptId deptName
이런식으로 붙음 컬럼이

select * from emp join dept using(deptId);

select * from emp join dept on emp.deptId=dept.deptId;
이건
empId empName deptId deptId deptName


on 은 상위테이블의 PK하위의 FK로해서 뭐이것저것하는데 귀찮으며
그냥 using(deptId)로 해버린다. deptId 기준으로 잡고


SELECT empId, empName, deptId, deptName
FROM emp JOIN dept USING(deptId);

이러면
empId empName deptId deptName 으로 뜬다


from join using(조인할 컬럼); 두테이블이 합쳐지고 필요한 컬럼만 셀렉트

조인이란
1.테이블을 옆으로 붙인다.
2.컬럼이 확장된다.
3.일반적으로는 부모 테이블의 primary key와 자식 테이블의
foriegn key를 조인 조건으로 사용해서 부모 테이블과 자식테이블을 옆으로 붙인다.
USING: 조인하는 컬럼명이 같을 경우에 사용
ON: 조인하는 컬럼명이 다를 경우 사용

COLUMN SELECT 순서만 바꿔보자

SELECT deptId, deptName, empId, empName from emp join dept using(deptId);

하면 deptId | deptName | empId | empName 으로 뜬다


이번에는 deptId name,   empId name departmentId 테이블로해보자

desc emp;
desc dept;


name이 같을때는

emp.name, dept.name으로 명시적으로 작성

이름 길때 as 사용 emp as e, dept as d 이런식으로
d.deptId=e.departmentId;


