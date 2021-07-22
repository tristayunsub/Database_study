With 절 설명
with절은 서브쿼리를 별도로 빼내서 이름을 지어주는 것이라고 생각하면된다.
보통 개발을 할때 여러번 쓰이는 모듈을 따로 빼내서 공통모듈로 만든다.
여러번 쓰이는 서브쿼리를 따로 빼서 with절로 정의한다. 쿼리의 라인수가 짧아지고
가독성이 높아짐. 

With JUNGMINA AS
( 
    SELECT'구독과 좋아요' as YOUTUBE
      FROM DUAL
)

SELECT * FROM JUNGMINA ;
=>구독과 좋아요
WITH절로 정의된 서브쿼리는 여러번 참조할 수록 성능에 유리하다?
경우에따라 틀릴수도있다. 두번 이상 사용되는 with절은
그 결과값이 TEMP영역에 따로 저장이 된다.

이건 경우에 따라서 좋을수도 나쁠 수도. 

복잡한 계산, 데이터양이 많을때 처음에 비용이들더라도 TEMP영역 사용.
비용이 적게드는경우 TEMP에 저장하는 비용이 커버릴 수 있다.
TEMP에 저장하기위해선 disk i/o가 발생한다. 그래서 오라클은 with절의 결과값을 바로 temp가아니라
PGA 영역에 한번올린다음 용량이 모자라할때만 TEMP영역을 쓰는 방식 도입. disk i/o가 발생하지 않을 수도있음.


데이터 마이그레이션
여러 타입으로 나뉠수도 있겠다. 같은 기종으로 의 마이그레이션, 같은 DBMS끼리
이기종 마이그레이션? 좀 더 세분화 할 수 가 있다. 온프레미스-> 온프레미스 , 온프레미스 -> 클라우드.
RDB-> RDB로 , RDB-> NOSQL. 온프레미스에있는 오라클을 DYNAMODB로 옮긴다.
스키마 구조가 달라서 어렵다 데이터를 정규화하지않고 attribute가고정적이지않고 가변적이기에
하나의 Item이 가질수있는 특성이 자유도가높다. 전략을 세워야하는데.
oracle 테이블을 dynamo 형태로 view로 한번만다음에 옮긴다.

선행되어야할 것 컬럼 매핑이다. Oracle 에있는 a테이블 컬럼1은 Dynamo F라는ㅌ ㅔ이블에 어떤 ATTRIBUTE로 매핑이되느냐

전체적인 비즈니스 로직을 어느정도 파악해야됨. 이 시스템이 어떤 데이터로 구성되어있는지


EXISTS, NOT EXISTS절.

SELECT A에 EXISTS B를 붙이면 A에서 B에존재하는 데이터와 가튼걸 골라 내겠따.
교집합 데이터 추출. 

NOT EXISTS B로하면 A에있는 데이터중에서 B에 존재하지 않는것들만.
차집합. 

SELECT * FROM 무한도전;
SELECT * FROM 런닝맨;

SELECT * FROM 런닝맨 A WHERE EXISTS ( SELECT 'X' FROM 무한도전 B WHERE A.NAME = B.NAME); //테이블에서 그값이 있는지 없는지 
한 로우씩 체크들어감. 

SELECT * FROM 런닝맨 A WHERE NOT EXISTS ( SELECT 1 FROM 무한도전 B WHERE A.NAME = B.NAME); //차집합



REDO LOG 공부.
데이터 베이스에서 발생하는 모든 변경사항을 기록한다.
DDL, DML . Redo Log 영역은 크게 Redo Log Buffer와
Redo Log File 로 나뉠수 있다. 메모리와 디스크의 개념. 그래서 변경사항생겼을때
Redo Log Buffer에 먼저 기록, 이후 LGWR REDO LOG FILE로 옮겨준다.

1. 3초마다한번씩, COMMIT 날릴때, BUFFER가 1/3이 찼거나 REDO RECORD 1MB가 넘었을떄
옮겨진다

Online Redo Log와 Offline Redo Log가 존재한다.
이 Online Redo Log는 최소 두개의 파일. 마지막 기록이찰때 다시 첫번째로 돌아감
Archived Redo Log로 백업

백업하는 목적? 복구. 데이터에 유실이 생겼을때 복구하기 위해. Redo log가 이런 역할.
어플리케이션의 입장에서보면 주 디스크에 저장후 로그를 저장한다?
데이터베이스에서는 로그 파일에 먼저 기록하고 그 다음에 데이터파일에 기록
Fast Commit? 우리가 Commit을 날렸을때 Commit을 날리는 시점에.

Redo Log File에 기록한다음에 사용자에게 완료됬다고 Response 날림.
Fast Commit이라고한다. Log file에 기록하는게 훨씬빠르다.





SQL INJECTION에 대하여 설명해보라
웹 해킹에 매우 대표적.
ID와 PASSWORD에 입력된 데이터들이
뒷단에는 데이터베이스와 연동되어 삽입이된다.
LOGIN 하기위해 생성해놓은 DATA들이있다. 
ID와 PASSWORD가 일치하는 회원이있으면
정보를 주어라. 라는 쿼리가 있다. 
이걸 이용해서 해커가 로그인 페이지에서 . 
ID: 1
PASSWORD: 1 or 1 =1 입력하니까 로그인이 ㅗ됨.

모든 회원 정보가 털림

WHERE ID =1
  AND PASSWORD = 1 OR 1=1
하면 모든 회원 정보가 출력.
무조건 TRUE가 된다.
모든 데이터가 나온다. 

마이바티스에서 PARAMETER 받는 구간이 #이었다.
#과 $의 차이가있다. #으로받으면 STRING처리가됌
$로 수정하고 로그인되면 '없이 데이터가 바로 SQL로 주입됌'
마이바티스에서 파라미터 바인딩할때 #기호로 해야함.

$기호는 파라미터를 먼저 적용하고 SQL 파싱
#기호는 SQL 파싱을 하고 파라미터 적용하기에 파라미터가 계속 바뀌어도 
SOFT 파싱하게됨. 하드파싱과 소프트 파싱?





UNDO와 TIMESTAMP
DELETE후 COMMIT때렸을때 복구하려면!
MD가 상품을 ㄷ등록하는데 판매가 잘못등록해서 100만원짜리가방이 10만원에 팔릴떄
변경 해줘야죠. 원칙적으로 운영데이터를 수기로 조작하지 않습니다 라는 사라믄 없을거다

예기치 못한 상황에서 수기로조작했는데 실수했다.

SELECT * FROM ORDER_HIST ORDER BY ORD_DT;

DELETE FROM ORDER_HIST WHERE ORD_DT = '20190801';
COMMIT; 해버렷다.

UNDO 영역을 이용한다. DML 작업할때 이전 데이터들을 담고있는 LOG 영역

SHOW PARAMETER UNDO_RETENTION;
900초 15분간에 DML 작업을한 내역이 UNDO에 담겨있따.

INSERT INTO ORDER_HIST
SELECT * FROM ORDER_HIST
    AS OF TIMESTAMP (SYSTEMSTAMP-INTERVAL '15' MINUTE);
    WHERE ORD_DT='20190801' 조회해보면 데이터들이 다나온다.

SELECT * FROM ORDER_HIST ORDER BY ORD_DT;


트리거?
INSERT, UPDATE, DELETE등의 이벤트 발생시 자동으로 실행되도록 사용자가 정의해놓은 프로지저
다이어트용 냉장고에 알림을 설정을 해놓는다. 문열리면 경고음 울리도록
냉장고가 테이블, 문 열리는게 이벤트, 경고음이 울리는게 바로 트리거

SELECT * FROM TRIGGER_TEST; --트리거가 생성할 테이블

SELECT * FROM TRIGGER_TEST_HISTORY; -- 생성된 트리거가 변경할 테이블
FOR EACH ROW
BEGIN
   IF INSERTING THEN
     INSERT INTO TRIGGER_TEST_HISTORY VALUES(:NEW.ID, :NEW.COL1, :NEW.COL2, SYSDATE);
    END IF;

    IF UPDATING THEN 
      -- :OLD.ID

    END IF;


    IF DELETING THEN
      -- :OLD.ID

    END IF;
END;

트리거 테스트 히스토리 테이블에 인서트 적용

INSERT INTO TRIGGER_TEST VALUE ('1', 'AAA', 'BBB');

같은 데이터가 들어와있다.

트리거를 어떤상황에서 사용하나? 개별마다 차이가있다.
데이터의 무결성을 보장하기 위해서 굉장히 적절한 방식이었던걸로 말함
고객이 주문햇을때 테이블에 데이터가 인서트, 이 테이블에 트리거걸어
INSERT후에 재고 테이블에 이 고객이 상품의 수만큼 재고를 차감하는 방식
이런 식으로  ㅡ프로세스 흘러가도록. 비즈니스 로직을 트리거에 삽입하는것은 권장하진 않음.

트리거는 숨어있기에 문서화가 필수, 인수인계도 중요. 트리거가있다는걸 분명히 알려줘야함.

트랜잭션 관리가 어려운 부분, UTL_HTTP써서 API URL 호출하도록 해보면
테이블에 이벤트가 발생해서 트리거 발생. 호출된 API는 롤백이 불가능하지.
문제가 생김.
비즈니스 로직은 트리거에 안넣는다.


데이터 타입중 LOB 타입? LONG OBJECT 대형 데이터 타입.
굉장히 큰 이미지나 영상, 음성파일 담는 데이터 타입.
이런 파일을 어떻게 테이블 컬럼에 담는가? 파일이 직접 컬럼에저장되는게아니라
파일 저장 위치를 테이블 컬럼에 저장하는 포인트개념. CLOB이 대부분이다.
BLOB이나 NFILE은 파일을 NAS서버에 올리고 별도의 URL따서 URL을 컬럼에 저장하는 형식.

CREATE TABLE CLOB_TEST (
  COL CLOB
);

INSERT INTO CLOB_TEST VALUES (DBMS_RANDOM,STRING('U', 5000));

INSERT INTO CLOB_TEST VALUES (TO_CLOB DBMS_RANDOM.STRING('U',5000)) || DBMS_RANDOM.STRING('L',5000));

SELECT * FROM CLOB_TEST;

DBMS LOB? 제공되는 기능.

SELECT LENGTH(COL), DBMS_LOB.GETLENGTH(COL), SUBSTR(COL, 1, 10), DBMS_LOB.SUBSTR(COL,10,1) FROM  CLOB_TEST;


SELECT문의 수행 순서.
SELECT쿼리 작성할때
5.SELECT 내가 가져온 로우중에서 어떤 컬럼 출력할까? io비용이 같다. 컬럼이 하나있든 10개있든
1.FROM 테이블 확인, SELECT 권한 체크, semantic에러 권한에러
2.WHERE 테이블에서 이 조건에 맞는 로우
3.GROUP BY 내가 가져온 로우들을 어떻게 묶나
4.HAVING 버릴 데이터 체크
6.ORDER BY 필요한 모든 컬럼들까지 가져왔다할때 정렬. orderby 가 select절보다 늦게 수행되기때문에 집계함수 사용할때 alias 지정할때, 
group by는 select보다 먼저 수행하기때문에 alias쓸수없음
DB가 위에서부터 쭉 수행하는게아님.


SOFT PARSING과 HARD PARSING과
HARD PARSING이 성능에 좋지않다? 그게 뭔가?
오라클 구조. 메모리와 데이터베이스 메모리는 SGA, 그안에 SHARED POOL 그안에 LIBRARY CACHE존재
우리가 SQL을 날리고 실행하는 과정에서 LIB CACHE 사용. 최적화된 실행계획 저장.
SQL 파싱을 먼저하게됨. SYNTAX에러 체크, SEMANTIC 체크, 캐쉬에서 저장되있는 정보 찾는다.
거기에 최적화된 실행계획을 꺼내서 실행하고 끝남. 저장되어있는 정보가 없으면
OPTIMIZER가 최적화 거침. SQL 엔진이 해석할수있는 언어로 변환하는 ROW SOURCE GENERATION 과정거침
성능에 부하 걸림. JOIN 쿼리 SQL로 날림, 옵티마이저의 실행계획 도출. 실행게획 수가 너무 많다.
JOIN되는 테이블중에서 어떤 테이블을 드라이빙으로 할것인가 부터.. JOIN되는 방식
Hash Join, Nested Loop, 비용 계산도함. 이게 쌓이면 부담이된다. 
library cache에서 바로쓰는게 soft parsing. 아닌게 hard parsing. 
soft parsing SQL을 Hash 함수로 저장하는데. sql문장자체가 키가되는거라 같은 sql이지만 공백이들어갔다거나, 줄바꿈? , 대소문자바뀌면
모두 다른 sql로 간주. cache 탈수가없다. 완벽하게 똑같은 텍스트로 쿼리를 짜야만 한다.
동적인쿼리도 soft parsing쓴다. bind 변수.를 제외한 나머지 쿼리 파싱후에 마지막으로 바인드 변수 적용.


TOP-N 쿼리, ROWNUM, STOPKEY, 페이징쿼리, TOP-N 알고리즘
TOP-N 쿼리? 음악 방송 TOP10 , 어떤 특정 컬럼으로 소팅후 1등부터 N등까지 뽑아내는 쿼리.
ROWNUM 슈도컬럼, 쿼리작성. ROWNUM은 일종의 시퀀스가튼 컬럼.

ALTER SESSION SET STATISTICS_LEVEL = ALL;

SELECT EMPOLYEE_ID, FIRST_NAME, LAST_NAME, SALARY FROM (
SELECT EMPOLYEE_ID, FIRST_NAME, LAST_NAME, SALARY, ROWNUM RN  FROM(
  SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY;
  FROM EMPLOYEES
  ORDER BY SALARY DESC;
  )
)
WHERE ROWNUM <= 10;
SELECT * FROM TABLE (DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST -ROWS + PREDICTE'));







인라인 View  from 절에쓰이는 subquery이다. 
View는 object로 생성되고 sql에다 불러쓰는 구조. inline view는 일회성 view이다.


ALTER SESSION SET STATISTICS_LEVE=ALL;

SELECT DEPARTMENT_NAME,
               B.AVG_SAL
               
      FROM DEPARTMENTS A,

        (SELECT  /*+MERGE*/ /머지힌트 주면 
                DEPARTMENT_ID,
                AVGI(SALARY) AVG_SAL
              FROM EMPLOYYES
            GROUP BY DEPARTMENT_ID) B
WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID;

SELECT * FROM (DBMS_XPLAN.DISPLAY_CURSOR(null,null, 'ALLSTATS LAST'));


//파티션 테이블 물리적으로는 데이터들이 파티션으로 나뉘어 저장된다.
논리적으로 하나의 테이블이다. 일반 테이블처럼 똑같이 기술,
파티션 키 컬럼을 어떤식으로 지정하냐에다라서 RANGE파티션: 키컬럼을 범위로 나누는것.
주문 테이블 2019년 1월부터 2019년 12월까지 주문 데이터를 하나의 파티션에 담는다.

상품테이블을 LIST 파티션, 상품 카테고리에따라 1번카테고리,2번카테고리 각각 파티션 별로

Hash 파티션. 이 데이터가 저장될파티션을 랜덤으로 지정하는 방식.
파티션 pruning 이라는 기능. 특정한 데이터 조회할때 그 데이터가 포함된 파티션만 뒤지는 기능 제공.
2019년 5월 주문데이터만 뒤지고 싶어. 2019 파티션만 뒤진다. select할때 서버 부하나 속도 빨라짐.
테이블들은 1~2년 지나면 불필요한 데이터가 많아짐. 특정 파티션만 날리면되니까 간단하게 운영가능.
파티션 테이블에 인덱스 생성할때 타입나뉨, 로컬파티션인덱스/비파티션인덱스 등. 로컬 파티션 인덱스
이 테이블에 파티션이 5개야 할때 인덱스도 5개 똑같이. 나뉘는 기준도 테이블과 동일.
테이블의 파티션 구조가 바뀐다거나 파티션이 삭제가된다거나 해도 인덱스 재생성이 필요없다.


비파티션 인덱스. 인덱스는 통째로 하나로 관리. 글로벌 파티션 인덱스. 테이블의 파티션과는 따로논다. 잘안씀

각 파티션에 데이터들이 고르게 분산될수있도록 키컬럼과 타입 설정. 쿼리 날려서 어떤 작업할때
특정 파티션에만 부하가 생기는일을 막는다.


Partition outer join?
아우터조인은 드라이빙 테이블있을때 드라이븐 테이블을 조인
드라이빙테이블에있는 모든 데이터가 출력. 아우터조인.
기본적인 원리는 가져가면서 하나의 테이블을 그룹핑해서 파티션한거처럼 나누는 조인.

--날짜별 매체별 주문 금액

--주문 테이블
SELECT A.OR_DT, A.MEDIA_CD, MVL(SUM(A.ORD_AMT),0) ATM
  FROM ORDER_HIST A
  LEFT OUTER JOIN ORDER_HIST A PARTITION BY (A.ORD_DT)
    ON B.MEDIA_CD = A.MEDIA_CD
GROUP BY ROLLUP(A.ORD_DT, B.MEDIA_NM)
ORDER BY A.ORD_DT
;

--매체 테이블
SELECT * FROM MEDIA;

날짜, 부서별 OR 카테고리별로 그룹핑해서 아우터 조인하는것이 필요함.

오라클 데이터베이스 저장 논리적인 구조.
가장 작은 공간부터~ block, extent, segment, tablespace순으로 간다.
MSSM 방식이라고해서 공간에 대한 사이즈 할당을 거의 수동으로 관리했었지만
10G로넘어오면서 ASSM으로 자동으로 알아서 사이즈 할당해주는 방식.

가장 작은 공간인 BLOCK은 어떤 데이터를 SELECT를할때 IO를 해야하는 가장 기본적인 단위
ROW 단위로 들어있다. 컬럼수가 많으면 적은 수의 ROW가 한 BLOCK에 저장되고
테이블의 컬럼이 적으면 많은 수의 ROW가 한 BLOCK에 저장된다.

데이터 하나 꺼낼때 하나의 BLOCK IO한다. 컬럼하나 SELEECT하든 ,IO하는 BLOCK은 같다.
DB_BLOCK_SIZE라는 파라미터로 사이즈 지정. 2의 N승으로 지정 가능.
BLCOK이 8K면 EXTENT는 64K 할당이 되었다고 하면. 8X8=64 BLOCK 8개가 하나의 EXTENT는
데이터 베이스가 공간을 할당하는 가장 작은 단위. 저장 단위랑은 조금 다른 개념.
테이블에서 데이터를 막 쌓다가 공간이 부족해졌다 하면

데이터베이스에서 이렇게 하나의 EXTENT를 더 할당해준다. 

EXTENT가 모여 SEGMENT를 이룬다. = OBJECT이다. 테이블이나 인덱스가 들어있고. 저장 공간 사용하는 OBJECT이다
VIEW나 SYNONYM은 OBJECT이지만 저장 구조를 가지고있지않다.

HWM?- HIGH WATER MARK 책갈피이다. 이 BLOCK까지 썼다고 표시하는.
SGEMENT에서 할당받은 공간 중에 여기까지 썼다. HWM으로 표시한다. 데이터가 DELETE가 되어 지워졌다 하면
FREE LIST로 구멍이 뚫리지만 TABLE FULL SCAN할때는 HWM 아래에 있는 BLOCK들을 다 SCAN한다.
HWM 도 ASSM 구조로 올라오면서. 하위 HWM가 따로 생기는 그런 개념들이 생기긴 했는데. 그렇게 디테일하게 까지는 알필요없고
책갈피 개념 정도이다.
TRUNACTE같은 명령어들로 HWM 초기화가능. SEGMENT => TABLESPACE 


CASE WHEN이랑 decode문.

SELECT GROUP_NAME,
       
       CASE GENDER WHEN 'boy' THEN '남' WHEN 'girl' THEN '여' ELSE '혼성' END GENDER_KO
       CASE WHEN GENDER = "boy" THEN "남"
            WHEN GENDER = "girl" THEN '여'
            ELSE '혼성'
       END GENDER_KO2 ,
       DECODE(GENDER, 'boy','남','girl','여','혼성') GENDER_KO3
FROM IDOL_GROUP;

옵티마이저란?
옵티마이징 해주는 녀석. DBMS에도 이런 옵티마이저가있다.
우리가 짜놓은 쿼리를 성능에 가장 유리한 방향으로 이끌어주는 역할.
로지컬 옵티마이저와 피지컬 옵티마이저. Query transformation수행. 여러가지 형태의 쿼리로 변환 .
쿼리의 결과는 똑같음.
피지컬 옵티마이저는 여러가지 쿼리들의 비용을 계산해서 가장 저렴한 쿼리를 고름
Cost Estimator, Plan Generator. 

