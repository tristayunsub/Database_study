*수행 SQL *

SELECT time_id,
       SUM( amount_sold)
FROM SALE_IN
WHERE time_id >= TO_DATE( :from_date, 'yyyy-mm-dd')
AND   time_id <= TO_DATE( :to_date, 'yyyy-mm-dd')
GROUP BY time_id;

* SQL BIND 값 *

From_date = '20110120'
To_date = '20110120'

STEP 1 - 실행정보 분석

SELECT /*+ gather_plan_statistc*/
       time_id,
       SUM( amount_sold)
WHERE time_id >= TO_DATE( :from_date, 'yyyy-mm-dd')
AND   time_id <= TO_DATE( :to_date, 'yyyy-mm-dd')
GROUP BY time_id;

SELECT *
FROM TABLE( dbms_xplan.display_cursor (NULL, NULL, 'Allstats last'));

테이블 풀스캔을 하고잇고, rows가 적기떄문에 타임id의 인덱스 생성해보고싶음

STEP 2- INDEX 구성정보 확인
SQL> SELECT CASE
            WHEN column_position -1
            THEN INDEX_NAME
            ELSE ''
        END index_name
        case when column_name like 'SYS%'
        then replace(sys.xm_fn_long_to_char(table_owner
                                            ,table_name
                                            ,index_name
                                            ,column_position),'','')
                    else column_name end column_name
from( select *
      FROM dba_ind_columns
      where table_name = upper(:v_tname)
      and   Index_owner = upper(:v_own)
      order by index_name, column_position);

STEP 3 - Where 절 조건 컬럼의 효율성 확인
select  
    column_name
   ,data_type
   ,data_length
   ,decode(data_precision || '/' || data_scale, 
   '/', null, data_precision || '/' || data_scale) dpds
   ,nullable
   ,num_distinct
   ,density
   ,num_nulls
   ,num_buckets
   ,sample_size
   ,to_Char(last_analyzed, 'yyyy-mm-dd') last_anal
   from all_tab_columns
   where owner    = upper(trim(':schname'))
   and table_name = upper(trim(':tname'));

쿼리의 조건이 범위로 들어갔으니까. bind에 하루가들어갔는데 항상 하루냐 일년이냐 에따라 인댁스 성능 차이남

STEP -4 Bind Pattern 분석
SELECT b.datatype_string,
       b.name,
       b.value_string,
       b.last_captured
FROM dba_hist_sqlbind,
     dba_hist_snapshot sn,
WHERE sn.snap_id = b.snap_id
AND sql_id = :sql_id
ORDER BY b. last_captured DESC


STEP 5 - 월 단위 조회의 FTS 효율성 확인
*Bind 값 *
From_date = '19980301'
To_date = '19980301'

SELECT count(*)

STEP 6 -TABLE 정보 확인

step 7 -access pattern 정보 확인
Partition 테이블로의 전환은 결국 Tim_id 칼럼이 partition key 컬럼이 되어야 하므로 해당 테이블에 대한 Access Pattern 조회가
필수,
앞서 소개한 스크립트를 통해 조회해 본 결과 Time_id 컬럼이 해당 테이블을 Access하는 모든 조건에서 필수 조건으로 사용됨을 확인.


STEP 8 - Partition 구성 및 index 생성

CREATE TABLE SALES_IN
(PROD_ID           NUMBER,
 CUST_ID           NUMBER,
 TIME
 CHANNEL
 PROMO
 QUANTITY_SOLD
 AMOUNT_SOLD
 )


PARTITION BY RANGE( timd_id) (

PARTITION sales_2011_1 VALUES less than (to_date('2011-02-01', 'YYYY-MM-DD'))

PARTITION sales_2011_1 VALUES less than (to_date('2011-02-01', 'YYYY-MM-DD')
PARTITION sales_2011_1 VALUES less than (to_date('2011-02-01', 'YYYY-MM-DD')
PARTITION sales_2011_1 VALUES less than (to_date('2011-02-01', 'YYYY-MM-DD')
PARTITION sales_2011_1 VALUES less than (to_date('2011-02-01', 'YYYY-MM-DD')
PARTITION sales_2011_1 VALUES less than (to_date('2011-02-01', 'YYYY-MM-DD')
PARTITION sales_2011_1 VALUES less than (to_date('2011-02-01', 'YYYY-MM-DD')




);


CREATE INDEX sales_time_idx01 ON SALES_IN (time_id) LOCAL;
CREATE INDEX sales_cust_idx01 ON SALES_IN (cust_id) LOCAL;
CREATE INDEX sales_prod_idx01 ON SALES_IN (prod_id) LOCAL;
생성한 이 인덱스를 스캔하고. 


STEP 9 - SQL 분기를 통한 해당 SQL 성능 개선

WHERE 28 < TO_DATE( :to_Date, yyyy-mm-dd) - TO_DATE( :from_date, 'yyyy-mm-dd')
조건문 삽입
--일단위 조회
UNION All
FROM (
     
)


WHERE 28 < TO_DATE( :to_Date, yyyy-mm-dd) - TO_DATE( :from_date, 'yyyy-mm-dd') 
--요거슨 월단위 조회
단위 sql을 찍는건 쉬우나 엄청 많은 부분을 고려해야한다.



