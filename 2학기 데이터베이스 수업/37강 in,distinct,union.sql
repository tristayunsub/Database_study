#IN
#이정재(peopleId='10057315') 또는
#전지현(peopleId='10061467')이 출연한 영화


select distinct movieCd, role, title, productYear
from people_filmo join movie using(movieCd)
where peopleCd='10057315' or peopleCd='10061467';
--or를 in으로 바꿔보자


select movieCd, role, title
from people_filmo join movie using(movieCd)
 join people using(peopleCd)
where peopleCd in('10057315','10061467'); -- 이제 조건이 여러개되면 in이 편하지




#이정재와 전지현이 동시에 출연한 영화
#이정재가 출연한 영화에서 전지현이 출연한 영화
select movieCd, title, productYear
from people_filmo join movie using(movieCd)
where peopleCd='10057315' and movieCd in 
  (select movieCd from people_filmo where peopleCd='10061467');


# 테이블 세개 조인해보자.
select movieCd, title, productYear
from people_filmo f1 join movie using(movieCd)
   join people_filmo f2 using(movieCd)
where f1.peopleCd='10057315' and f2.peopleCd='10061467';

   movie 양옆에 people_filmo가 2개있다.
   한쪽에서는 이정재, 또다른곳에선 전지현가지고온다음에 조인해버리면됌



--Distinct 공부
in으로만 하면 문제점이. 우리가 원하지 않는 결과가 가끔안나옴
항상 중복이되서 나타난다. 도둑들이 두번씩나옴
그걸 한번만 나오게하려면
select distinct 사용한다.


#UNION:서로 다른 테이블에서 SELECT 후에 합친다. 중복 제거
#이와이 슌지(peopleCd='10056764')가 참여한 영화와
#제이앤씨미디어그룹(compnayCd='20161101')이 참여한 영화

select movieCd, title, ProductYear 
from people_filmo join movie using(movieCd)
where peopleCd='10057674'
union
select movieCd, title, productYear
from company_filmo join movie using(movieCd)
where companyCd='20161101';
한번에 다나오게됌  기본으로 중복을 제거함.

