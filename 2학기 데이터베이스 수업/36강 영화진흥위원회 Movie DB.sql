view movie.sql

source movie.sql

show tables;

--영화목록(개봉일 최신순, 1 page)
select movieCd, title, productYear
from movie
order by openDate desc
limit 0,25;

-- 영화정보 화면
-- 영화상세정보(참여 역할순,이름순)
select movieCd, title, titleEn, productYear, openDate, nation, genre
from movie
where movieCd='2015002';
order by role, name;//같은 역할

--참여 영화인
select peopleCd, name, role
from people_filmo join people using(peopleCd)
where movieCd='20150025';
order by role, name;

--참여 영화사(영화사 이름순)
select companyCd, name, part
from company_filmo join company using(companyCd)
where movieCd='20150025';
order by name;

--영화인 목록(영화인 번호순, 1 page)
select peopleCd, name, repRole
from people
limit 0, 25;

--영화인 상세정보(peopleCd='1005526',이병헌)
select peopleCd, name, nameEn, repRole
from people
where peopleCd='10055626';

--영화인 필모그래피(참여영화들. 영화번호 역순)
select movieCd, title, productYear, role
from people_filmo join movie using(movieCd)
where peopleCd='10055626'
order by movieCd desc;


--영화사 목록(영화사 번호순, 1 page)
select companyCd, name, ceo
from company
limit 0,25;


--영화사 상세정보(쇼박스)
select companyCd, name, nameEn, ceo, parts
from company 
where companyCd='20100103';

--영화사 필모그래피(참여 영화들,영화번호 역순, 1 page)
select movieCd, title, productYear, part
from company_filmo join movie using(movieCd)
where companyCd='20100103'
order by movieCd desc
limit 0, 25;






