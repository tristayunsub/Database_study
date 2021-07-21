//성능 문제 SQL SQL 튜닝의 시작은 SQL을 제대로 이해하는데 있다.

SELECT *
    FROM (
        SELECT /*+ INDEX_DESC(A IDX_MBOX_SENDDATE) */
              a.*,
              rownum as rnum
            FROM tbs_mbox a 
            WHERE userid = :b1
              AND status = :b2
              AND ROWNUM <= :b3

    )
where rnum >= :b4;

select statement - choose- cost estimate:3
  view
    count stopkey
     table access by index rowid  :imsi.tbs_mbox
        index range scan
  descending :imsi.IDX_MBOX_SENDDATE

  // idx_mbox_status 인덱스를 사용할경우 ? => SQL에 숨은 Order by가 존재한다. 

  INDEX 정보
  INDEX_NAME       COLUMN LIST
  idx_mbox_status      userid, status
  idx_mbox_senddate    userid, senddate


//  IDX_MBOX_SENDDATE INDEX가 INVALID 상태가 된다면? ORDER BY 절 추가. ORDER BY SENDDATE DESC

//조인 방법. Nested Loops Join 선행 테이블의 추출건수가 많으면 비효율적이다.
//후행 테이블에서 Join Key에 대한 조건을 활용할수 있다.

//Hash Join 선행테이블의 추출건수가 많아 후행 테이블을 반복적으로 탐색하며 발생하는
//비효율을 제거 할 때 유리하다. 
// 후행 테이블에서 Join key에 대한 조건을 활용할 수 없다.


//PLAN을 읽는 방법. 안에서 밖으로, 위에서 아래로, JOIN은 PAIR로, 각 OPERATION에 따라
SELECT c1, c2, c3
   FROM SUBQUERY_T2 SUBQUERY t2
   WHERE c1 >= :b1 AND c1 <= :b2
     AND EXISTS ( SELECT /*+ UNTEST HASH_SJ */
                         'x'
                    FROM  SUBQUERY_T1 t1
                    WHERE t1.c6 = t2.c3
                      AND t1.c6 >= :b1)
//PLAN
FILTER (cr=37422 pr=0 pw=0 time 1910470 us)      -> 1
HASH JOIN SEMI (cr=37422 pr=0 pw=0 time 1910470 us) -> 2
   TABLE ACCESS BY INDEX ROWID SUBQUERY_T2 (cr=5 pr=0 pw=0 time=42 us) =>3
    INDEX RANGE SCAN PK_SUBQUERY_2 (cr=3 pr=0 pw=0 time=31 us) => 4
   TABLE ACCESS FULL SUBQUERY_T1 (cr=37422 pr=0 pw=0 time 1910470 us) => 5


수행순서는? 4->3->5->2->1

//서브쿼리와 성능문제 이해하기. 동작 방식, 실행계획 제어, 비효율 MINUS대신 EXISTS, WHERE절의 서브쿼리를 조인으로 변경

서브쿼리란.WHERE절에 비교 조건으로 사용되는 SELECT 쿼리를 의미한다.
집합적인 사고를 필요로하는 조인 보다는 절차적이므로 사용하기 쉽지만
무분별하게 남용하여 사용할 경우 성능 문제가 발생할 확률이 높다.

사용패턴 1
SELECT *
  FROM emp
 WHERE sal > ( SELECT AVG(sal)
                      FROM emp)
서브쿼리 추출 결과는 반드시 1건
  서브쿼리 -> Main SQL

사용패턴 2

SELECT c1, c2, c3
  FROM SUBQUERY_T2 t2
  WHERE c2 = 'A'
  AND EXISTS (

      
  )
  서브쿼리 추출 결과가 여러건 추출 <> 성능문제가 주로 발생하게된다.
  
//  Filter 동작방식, 조인 동작방식

Filter 동작방식이란? 최대 Main SQL 에서 추출된 데이터 건수 만큼
서브쿼리가 반복적으로 수행되며 처리되는 방식 

Main SQL의 추출건수가 100만 건이면 서브쿼리는 최대 100만건 수행된다.

INPUT 값에 해당하는 값의 종류가 적은 경우에는 Filter Optimizaation 작업을 통해 오히려
조인 방식보다 효율적일수 있다.

연결 컬럼에 대한 INDEX는 반드시 존재해야한다.

한가지 처리 방법만을 고수한다.
추출 건수 만큼 반복 수행되어 비효율 발생

Filter 동작방식에 대한 특징. 
수행 순서 Main SQL이 먼저 수행된다.
Main SQL 추출 건수 최대 Main SQL을 추출 건수 만큼 서브 쿼리가 수행된다.
Main SQL의 추출 건수가 적을 경우에는 Filter 동작 방식은 불리하지 않다.

Input 값의 종류. Unique 할 경우 Main SQL을 추출 건수 만큼 서브쿼리가 수행된다.
값의 종류가 적을 경우, 최소 값의 종류 만큼만 서브쿼리가 수행된다.

유연성 Main SQL을 먼저 수행해야만 하므로 다양한 상황에서 유연하게 대처하기는
어려운 동작 방식.


조인동작 방식
Filter 동작 방식에 비해 유연한 대처가 가능하다.
조인방법, 조인 순서 유리한 것을 선택 할 수 있다
Filter Optimization 효과를 이용할 수 없다. Input 이 동일한 값이 많다면
Fiter 동작 방식이 유리할 수 있다.
조인 동작방식은 조인방법, 조인순서의 선택 가능 -> 상황에 따른 유연한 처리가 가능함
-> 조인 동작 방식이 항상 유리하진 않다.


서브쿼리 동작방식을 제어하는 힌트?
NO_UNNEST 서브쿼리를 Filter 방식으로 유도하는 Hint
UNNEST 서브쿼리를 조인동작방식으로 유도하는 Hint
NL_SJ 조인동작방식 중 Nested Loops Join semi 로 유도하는 Hint
HASH_SJ 조인동작방식 중 hASH JOIN SEMI로 유도하는 Hint
NL_AJ 조인동작 방식 중 NESTED Loops Join Anti 로 유도하는 Hint
HASH_AJ 조인동작방식 중 HASH JOIN Anti로 유도하는 Hint
ORDERED FROM 절에 나열된 순서대로 조인 순서를 정하는 Hint(SUBQUERY가 존재하면 서브쿼리부터 수행하도록 유도함)
QB_NAME QUERY BLOCK의 이름을 지정하는 Hint
SWAP_JOIN_INPUTS HASH OUTER JOIN과 같이 순서가 고정된 상황에서 조인 순서를 바꾸도록 유도하는 Hint
NO_SWAP_JOIN_INPUTS HASH OUTER JOIN과 같이 순서가 고정된 상황에서 조인 순서를 바꾸지 못하도록 하는 힌트

SQL을 Filter 동작 방식으로 수행하도록 제어하려면
NO_UNNEST 사용해야함

예제 SQL을 조인동작 방식 Nested Loops Semi Join으로 수행하도록 제어하는
unnest, NL_SJ

Hash Semi Join으로 수행하되, 서브쿼리가 Main SQL 보다 먼저 수행하도록 제어하는
UNNEST, HASH_SJ, SWAP_JOIN_INPUTS 사용

Hash Semi join으로 수행하되 main sql이 먼저 수행하도록 제어하는
unnest, hash_sj, NO_SWAP_JOIN_INPUTS.

NOT EXISTS를 사용한 예제 SQL을 NESTED LOOPS ANTI JOIN으로 수행하도록 제어하는
UNNEST, NL_AJ

UNNEST, HASH_AJ 

SELECT *
FROM  emp a
WHERE empno IN ( SELECT max(empno)
                   FROM emp x
                   GROUP BY deptno);

//서브쿼리 실행게획 조절하기 심층학슴.
조인순서(LEADING), 조인방법(USE_NL), QUERY BLOCK명 지정 (QB_NAME) 힌트들을 사용하여
SQL의 실행계획을 제어하여 보자.
SELECT /*+ LEADING(X@SUB) QB_NAME(MAIN) USE_NL(A@MAIN) */
FROM emp a
WHERE empno IN ( SELECT /*+ UNNEST QB_NAME(SUB) */
                  max(empno)
                  FROM emp X
                  GROUP BY detpno);

무엇 때문에 실행계획이 의도한대로 제어되지 않았나

Optimizer가 서브쿼리를 Inline Veiw로 최적화 작업을 수행
-> View 의 이름이 VM_NS01이란 점에서 유추
-> QUERY BLOCK 명이 변경되고 이로 인해 힌트가 무시됨.

힌트로 실행 계획 유도할 방법?
Optimizer 는 서브쿼리를 Inline View 로 변경할 경우 FROM 절의 앞에 위치 시킨다.
ORDERED 힌트는 QUERY BLOCK NAME과 상관 없이 FROM 절에 나열된 순서대로 수행한다는 특징이 있음.
d


SELECT /*+ ORDERED USE_NL */
FROM emp a
WHERE empno IN ( SELECT /*+ UNNEST */
                  max(empno)
                  FROM emp X
                  GROUP BY detpno);

//02 서브쿼리와 성능문제 이해하기

MINUS의 수행방식
SELECT 
FROM A
MINUS
SELECT 
FROM B 
1) 테이블 A에서 데이터 추출
2) 추출된 데이터 SORT 연산
3) 테이블 B에서 데이터 추출
4) 추출된 데이터 SORT 연산
5) 2번과 4번 데이터 비교후 최종 데이터 추출

테이블 수행방식: 테이블 A와 상관없이 별도로 데이터 추출후 SORT 연산 수행

SQL 성능: 분리: 1) 테이블 A,B에서 추출한 데이터를 SORT 연산시 성능 저하
2) 테이블 A에서 추출한 데이터가 적고, 테이블B에서 아무런 조건이 없는 경우
FULL TABLE SACN으로 처리하여야 하고, 추출된 데이터를 SORT 연산을 수행함

NOT EXISTS
SELECT ...
FROM A
WHERE NOT EXISTS (
     SELECT ...
     FROM B
     WHERE B.XX
)

테이블 A에서 데이터 추출, 1번에서 추출한 데이터와 서브쿼리 테이블 B 데이터와 비교후 최종 데이터추출

테이블 A의 추출 데이터를 이용한 인덱스 스캔 가능. 및 별도 수행도 가능

SUBQUERY를 INLINE VIEW로 바꾸어 SQL을 작성한 후 
LEADING HINT를 사용하여 실행계획을 제어한다.

SUBQUERY의 특성이 M집합을 1집합으로 바꾸는 특성이 있기에 INLINE VEIW로 사용해야함
내가 원하는 서브쿼리를 먼저 사용하고싶다면 LEADING이라는 HINT 사용

// 스칼라 서브쿼리의 이해와 특성

스칼라 서브쿼리란 Select Column List 절에 사용된 서브쿼리
최대 결과 건수 만큼 반복적으로 수행된다.
추출되는 데이터는 항상 1건만 유효하다.
데이터가 추출되지 않아도 된다.

SELECT c1, c2, c3
      (SELECT t2.c1
         FROM SCALAR_T2 t2
        WHERE t2.c2 =t1.c2
          AND ROWNUM <= 1) AS t2_c1
 FROM SCALAR_T1 t1
 WHERE c2 = 'A'
   AND ROWNUM <= 1
스칼라 서브쿼리 추출 결과는 1건을 초과하면 안된다.

스칼라 서브쿼리는 SQL의 추출 건수에는 영향을 주지 않음
(Outer Join)

수행위치와 조인 관계에 따라 성능문제가 발생한다.

스칼라 서브쿼리는 최종 결과 만큼 수행하자
scalar_t1 테이블 전체 데이터 대상으로, C1, C2 컬럼으로 오름 차순 정렬후 10건만 가져오는 SQL을
작성하고자 한다. 이때 추출한 데이터는 SCALAR_T1의 C1,C2,C3와 SCARRAR_T2 의 C3 컬럼 값이다.

// Summary 스칼라 서브쿼리란?
select list 절에 위치한 sql을 스칼라 서브쿼리
특징은 추출건수가 항상 한건, 결과가 null이어도 전체 sql에 영향미치지않음
outer join과 비교해보면 최종 추출결과건이 적으면 스칼라 서브쿼리가 좋다


WITH절에 대한 기본 내용 이해.
SQL내에 동일한 데이터가 반복적으로 사용되는경우 WITH절 사용한다.
Materialize 동작 방식( Global Temporary Table에 저장)
Inline 동작 방식

Materialize 동작 방식.

WITH T_T1 AS (
           SELECT *
           FROM T1
           WHERE c2 IN ('A', 'B', 'C')
           ). T_T2 AS (
                    SELECT *
                    FROM t2
                    WHERE c2 IN ('A', 'B', 'C')
                      AND c3 <= 10
           )
           SELECT t1.*.
           t2.*
           FROM T_T1 T1.
           T_T2 t2
            WHERE t1.c1 =T2.c1
              AND t1.c2 = 'A':

              