https://www.youtube.com/watch?v=lls3t7Y1Xsk&list=PL3036mp45iYybV1UzXvnuE4CtlgX6_hHx&ab_channel=IT%EB%8A%A6%EA%B3%B5%EA%B9%80%EB%B6%80%EC%9E%A5

인덱스란 무엇인가?~

도서관의 색인표. 데이터를 찾아가는 아주 효율적인 방법.

튜닝, 성능향상이랑도 맞닿게됨. 초보자가 하기엔 약간 어렵지만. 그래도 오라클 공부하면서 결국 만나게되는 구간이다.





 create table library (

       seq number(10),      --책번호
       seq number(10),      --
       seq varchar2(10),      --책번호
       reg_day date default sysdate, --등록일
       
       constraint pk_library primary key (seq)
       );
       
number를 프라이머리 키로 잡음. 

데이터를 많이 만들어야된다 인덱스 만들려면


PL/SQL사용 인덱스

declare 

      fi number;
      v_book library.ebook%type; 변수선언
      
 begin 
 
     for fi in 0 .. 100 loop
           /*ebook 여부, 50개중 1개로 ebook*/
           if(mod(fi, 50)=) then v_book := 'Y';
      
          /*국내 해외 여부, 10개중 1개로 해외 */
          if(mod(fi,10)=0) then v_domestic :='N';
          else v_domestic :='Y';
          end if;


 commmit해서 pl sql 테이블 생성
 
 select count(*)
 from library;
 
 delete library where seq=0;
 
 
 101개 넣은거. 
 
 우리가 확인할수있는거. primary key로 seq 잡음과 동시에 unique 인덱스, seq로 인덱스 생성 이미 primary key 잡음으로써 인덱스가 생성된다
 
 100개중에  인덱스로 찾을수있는거
 
 from user_indexes 
 where tabe_name='LIBRARY'
 
 정보값. 
 
 인덱스 컬럼 별 정보 normal = b-tree가 디폴트로 생성된다.
 
 대부분의 인덱스 
 
 다 null로되어있는데.
 
 anaylze index PK_LIBRAY COMPUTE STATISTICS;
 
 인덱스에 이름, 타입, 테이블이름, BLEVEL, DISTICNTKEY, NUMROWS, LAST ANAYLZED=시간
 
 BLEVEL? 상당히 중요 
 
 BLEVEL이 0이네?
 
 이 비트리는 항상 하나 둘 세개 구조? 아니다. 인덱스는 0레벨 하나만있는거
 
 리프만 있는거다 0이면. 하나이고. 하나가 한 블록. 시퀀스가 1234 인덱스는 ROWID를 가지고있음. 
 
 각 ROW마다 rowid,seq를 가지고 만든게 인덱스다.
 
 rowid보니까 막 AAAV5YAAAHAAY1OAAB이렇게써있네
 
 B-LEVEL의 DEPTH는 그 ROOT BLOCK 부터 LEAF BLOCKS까지다.
 
 
 그럼 blevel은 어느순간에 증가할까?
 
 101에서 만개까지 넣어보자. level이 1이됨
 
 상위 포지션이 생기게됨. 
 
 
 만개에서 10만개 하면 blevel2
 
 인덱스에서 num_rows 가 같다. 
 
 프로시저를 잘알아야 튜닝도 잘하지.
 
 오라클 index 의 관계도
 
 SELECT 무조건 좋다
 
 INSERT 좋은게없다 인서트할때마다 인덱스 생성해야됨.
 
 UPDATE 냉탕 온탕(사용자는 좋은데 서버는 힘듬) 
 
 DELETE (나쁘지 않아)
 
 인덱스는 UPDATE하면  딜리트한 후 하나 추가함. INSERT를 같이함 이건 첨알았네
 
 UPDATE는 INSERT와 DELETE 같이하기에 인덱스에는 부하가 많이걸림..
 
 INSERT해볼떄.  어짜피 인덱스를 다시 만들어야되니까 별로 좋은적이없다
 
 
 

