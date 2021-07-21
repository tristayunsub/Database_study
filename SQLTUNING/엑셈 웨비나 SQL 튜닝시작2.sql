대상선정 중요성.

튜닝 대상 선정이되어야함.
특별한 상황에 대처하기 위해 성능개선 작업을 수행하는 경우
SQL 튜닝 대상 선정은 마땅히 그 요구 사항과 상황에 맞게 선정하낟.
EX)CPU, IO, LITERL, 특정업무, 장애 상황등, IO양 많은경우, LITERAL SQL이 많은경우

DB서버 전반의 성능개선을 목표로.

잘못된 대상 선정의 예

고객 요구사항 DB서버의 CPU 사용률이 높다.

PROD DATABASE 시간 별 CPU 사용률 추이
ELAPSED TIME이 높은 SQL 추출?
IO가 높은 SQL 추출?
TABLE FULL SCAN을 발생 시키는 SQL 추출?
DISK IO가 높은 SQL 추출?

CPU 사용률이 낮아지지않음 왜 이럴까?
COLUMN에 EXCUTION 컬럼을보자.
하루동안 수행횟수가 1개정도인 SQL이 대부분임.
SQL에 문제가 별로 없다. 튜닝 한다해도 CPU사용률 낮추기힘듬.

업무 담당자의 요구사항 및 조언을 활용하는 방법
Oracle 의 Dictionary View를 활용하는 방법
성능 관리 솔루션을 활용하는 방법

CASE LIST

IO/ CPU Top SQL 관련 성능 개선 대상 선정

Table Full Scan 관련 성능 개선 대상 선정

배치프로그램 관련 성능 개선 대상 선정

실행계획이 변경된 SQL 추출

ASH를 활용한 성능 개선 대상 선정은

Top Table 개념을 활용한 성능 개선 대상 선정


Literal SQL이란? IO가 많거나 CPU점유시간길거나 ,TABLE 풀스캔이랑은다름
라이브러리 캐시쪽 메모리에 경합을 준다.


SELECT * FROM EMP WHERE EMPNO = 1234
SELECT * FROM EMP WHERE EMPNO = 1235
SELECT * FROM EMP WHERE EMPNO = :b1
의미는 같다. 주어지는 상수값만 바뀌어서 HARD PARSING을 여러번 해야되기떄문

상수조건만 바뀌는 SQL을 같은하나의 SQL로보고 BINDING 처리하도록 하는 SCRIPT

특정 프로시져 내에 수행한 SQL 배치프로그래밍



//테스트 프로시져 생성하기

create or replace procedure plsql_batch_1 as
begin
         delete /*+ BatchTest_plsql_batch_1 */ from plsql_t1 ---> SQL에 식별자 부여
where c2 = 'aa';
           commit;
end;
/

create or replace procedure plsql_batch_2 as
begin 
      dbms_application_info.set_module('BatchTest', ''); ---> Module Name 설정

      insert into plsql_t1
      select plsql_t1
         from plsql_t1
      where c2 = 'A';
      commit;

      update plsql_t1
set c2 ='aa'
      where c2 = 'a';
commit;

plsql_batch_1; ---> 데이터 delete
end;
/

실행계획이 변경된다해도 별 문제가 없지만 가끔가다 성능이 안좋아지는 경우가 꽤 있다.
변경이 의심되는 SQL 추출 스크립트.

optim_peek_user_binds, _optimizer_use_feedback 등 플랜변경에 영향줄수있는 파라미터 off 고려
통계 정보 생성시 sql plan 변경으로 인한 장애예방 방안 마련 필요

wait event 유발하는거 검출

Top table 활용의 유용성.

1.업무적인 성격을 파악

2. Access가 많은 테이블 즉, 활용도가 높은 테이블 기반으로 관련 정보를 파악 가능.

3.업무적 중요도 측면에서 우선시 되는 테이블을 인지하여 성능 개선 작업을 진행가능

4. 성능 개선 대상 테이블의 관련 정보와 인덱스 개수, 통계정보 생성 일자 등을 한눈에 파악 가능.


//SQL 튜닝을 위한 정보 분석 방법
SQL 튜닝 접근방법, SQL Trace이해, SQL 이해와

나쁜습관: SQL을 보면 SQL Trace를 먼저 수행하고 SQL Trace에서 비효율을 찾으려고한다.
이것저것 힌트를 적용해본 후 성능을 개선한다.
복잡한 sql은 능력 밖이라 생각한다.

좋은습관.
오라클은 어찌풀었나 생각해보자.

select e.ename
      ,e.empno
      ,d.deptno
from emp e, dept d
where e.deptno =
d.deptno
and e.salary >=100;

=> 월급이 100 이상인 사람의 이름, 사번, 부서번호를 추출하는 SQL

> 아하... 월급이 100 이상인 사람이 많으면 Hash Join이 유리하고

100 이상인 사람이 적으면 NL JOin이 유리하겟네

SQL을 이해하고 집합적인 분석이 끝난 후 알아야하는ㄴ 전문지식

Create index idx1_emp on emp(Salary);

[힌트 적용]
select /*+ leading(e) use_n1(e d) index(e idx1_emp)*/
       e.ename
      ,e.empno
      ,d.deptno
from emp e, dept d
where e.deptno = d.detpno
and e.salary >= 100;


JPPD,OPT_PARAM 등의 지식은 어렵다.

10046 Trace? 와 DBMS_XPLAN이있다. 
10046 Trace는 가독성이 좀 떨어진다.

STEP1. DISPLAY_CURSOR 수행 원리
계단식 
select /*+ gather_plan_statistics*/
"plan의 statistics를 gather 해 주세요"=> v$sql_plan_statistics_all 테이블에 plan의 statistics 수집
=> DBMS_XPLAN Package의 Display_CURSOR Subprogram을 이용해
데이터 출력(v$sql_plan_statistics_all, v$sql_plan 사용)

출력 내용 이해.

Query Blcok Name

PREDICATE INFORMATION


Object 정보 분석 및 활용

"단위 sql 성능 개선은 할만하지만
해당 sql을 실무에 적용하는것은 생각보다 어렵다."

얼마나 자주 사용하는 SQL인가

인덱스는 꼭 만들어야ㅎ 하는가
업무적으로 중요도가 노픈가
인덱스를 만들 공간은 충분한가

컬럼의 데이터 분포는 인덱스를 생성하기에 적합한가
바인드 변수 조회 패턴은 어떤가
인덱스를 생성했을 때, 다른 SQL의 실행계획에 영향을 주지않는가.

수치화된 명확한 근거를 제시할 수 있어야한다.


//업무 정보 분석 활용.
튜닝이 어려운 쿼리는?
KEY 조건이 두 개 이상의 테이블에 분리되어 있는 경우
테이블 자체가 Filter 성격의 집합으로 구성된 경우

Top table로 업무 정보 분석한다.

신규 인덱스 생성해놓고 ACCESS PATTERN을 사전에 파악하지않음













