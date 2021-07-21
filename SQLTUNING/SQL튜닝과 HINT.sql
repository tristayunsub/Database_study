HINT란? ,HINT의 사용 규칙등

HINT란? SQL 실행계획을 변경하는 방법중 하나
실행계획을 변경하는 방법 중 가장 능동적이며 강력한 방법.
HINT만을 적용한다면, SQL에 변경을 주는 것이 아니므로 데이터 무결성의 오류가 발생하지 않음.

HINT란 무엇인가?

SQL 블록 첫 키워드 SELECT 
                  insert
                  UPDATE
                  DELETE
                  MERGE
테이블에 ALIAS사용되면 힌트부분에 ALIAS사용되면

HINT의 사용목적.
잘못된 통계정보에 의한 실행계획 이상.
Optimizing 시 참조되는 데이터가 변경되거나 실제 테이블과 맞지 않게
수집된 경우, 비효율적인 실행계획을 수립하는데 악영향.

통계정보의 갱신이 필요

이미 수립되어있는 수많은 sql plan의 변경 불가피

이 과정에서 효율적으로 수행되던 sql 문제 발생

이 경우 문제되는 SQL 선별하여 HINT로 문제 해결

Bind Peeking이란?
오라클은 실행계획이 생성되는시점에 bind변수값 참조 X
최적 실행계획 수립어려움. 이를 보완하기위해 만듬.
hardparsing시점에 bind값을 옆보게함으로써 .

Bind peeking 기능의 함정 # 수행빈도 99%!

index scan이 성능상 유리!

HINT의 종류와 사용방법.

FROM 절에 나열된 테이블 순서대로 조인 수행
ORDERED HINT

LEADING HINT 조인 순서를 명시적으로 지정할 수  있음.
10G 이후 DRIVING TABLE만을 지정하던 것이 모든 테이블의 순서의 지정이 가능.

ORDERED HINT도 가능하지만 조인하려는 순서에 맞게 FROM절 테이블 순서를 조정해야 하는 불편함.

전체 테이블 조인 순서를 조정.

테이블 JOIN방법 결정 HINT

일반적으로 조인 대상 건수가 적을때 유리한 조인 방식
조인 연결 컬럼에 반드시 인덱스가 존재
USE_NL로 표현하며, 테이블 명이나 ALIAS 적지
NESTED LOOP JOIN 유도 힌트 적용

SELECT /* leading(t2 t3) use_nl(t3) */ --조인 순서 결정 힌트와같이 사용


선행 테이블에서 많은 건수가 추출되고, 후행 테이블에 Access량이 많은 경우 성능상 유리하겟네
USE_hASH로 표ㅛ현하며, 테이블 명이나 Alias를 적지하여야함
HASH JOIN


조인 방식의특성상 추가적인 SORTING이 발생하여 거의 사용되지 않음.
USER_MERGE로표현하며, 테이블
MERGE JOIN


DATA ACCESS 관련 HINT

TABLE FULL SCAN 이 사용되는 경우

조인 컬럼에 인덱스가 없고, 상수 조건도 없는 Hash Join으로 수행되는경우
Index Scan이 비효율이 클 경우
Parallel Query로 Index Fast Full Scan으로 수행이 불가능한 경우

Exadata의 Smart Scan으로 수행할 경우

사용하지 말아야하는 경우
SELECT COLUMN 절에 있는 SCALAR SUBQUERY
Nested Loops Join으로 수행되는 경우

SELECT /*+ FULL(T1)*/
        COUNT( *)
FROM hint_t1 t1
WHERE cust_id = 'ID_1';

INDEX RANGE SCAN descending

힌트에 기재된 Index를 내림차순 정렬을 처리하여 수행하도록 유도하는 힌트

인덱스 스캔 방식은 기본적으로 정렬을 보장하므로 사용가능.

index_DESC로 표현하며 대개, Paging 처리나, MIN/MAX값을 구하는데 SQL에 주로 사용됨.

INDEX FAST FULL SCAN

인덱스 SEGMENT 전체를 읽는데 사용함. 가장 빠른방법.
INDEX_FFS로 표현되며, Parrall 방식 수행도 가능.
정렬을 보장하지 않으며, SQL에 사용되는 모든 컬럼이 인덱스 구성 컬럼이어야함.

INDEX SKIP SCAN 
조건절에 인덱스 선두 컬럼이 사용되지 않더라도 Index Scan을 가능하게 해주는 방법
인덱스 선두 컬럼의 NDV(Number of Distinct Value)가 낮아야 유리.
Index_ss 로 표현하며, INDEX SKIP_SCAN으로 유도하는 힌트

VIEW 제어 힌트

View 란 FROM 절의 또 다른 SQL BLOCK(IN-LINE view)과 사용자에 의해 생성된 View를 모두 포함함.
View가 어떻게 수행되느냐에 따라 sql의 성능에 영향을 줌.
MERGE, NO_MERGE로 제어할 수 있음.

In-Line View 또는 View 를 View 외부 테이블과 Merging되지 않고, 독립적으로 수행하고자 할 때 사용되는 힌트,

일반적으로 실행계획 상에 View라는 operation 을 목격할 수 있음.


SELECT t1.*, t2.cost
FROM t1,
    (
        SELECT ---> 추출 건수: 100건 (그룹핑 후)
                   id, SUM( cost) AS cost
        FROM t2
        GROUP BY id
    ) id
WHERE t1.id = t2.id;

조인 순서는 T2-> T1, 조인 방법은 Nested LOOPS jOIN으로 수행

인라인 뷰 T2는 GROUP BY를 수행한 후 100건 추출하고, 이후 T1테이블은 T2.ID_1
컬럼에 생성된 인덱스로 100회 수행 후 최종 데이터를 추출해야 성능상 문제없음

만약 인라인 뷰 T2가 T1과 VIEW MERGING이 되면, T2 구문 내의 GROUP BY 절이
T1 테이블과 조인을 수행 후 최종 데이터 추출 시점에 처리되어 성능문제 유발

이 경우 NO_MERGE 힌트가 필요.

HINT 사용시 주의사항

의도와 다르게 실행계획이 변경되지 않아야 한다

INDEX NAMING RULE

데이터 변경이 심한 경우 힌트 사용에 주의해야 한다.

힌트가 적용된 프로그램 유지보수에 각별한 주의가 필요하다.

Dynamic SQL인 경우, 힌트 사용을 보다 효율적으로 적용해야 한다.








