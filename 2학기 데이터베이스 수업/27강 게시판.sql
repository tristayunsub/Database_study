select userId, title, name, wdate from article order by desc \G;

최신번호부터 뒤에 \G; 치면 게시글이 이제 컬럼별로나와준다
데이터 테이블처럼 나오면 불편하니까

select articleId, title, userId, name, wdate, udate
from user
//가장 중요한건 content를 select하냐 안하냐이다
-> where articleId=4;


글쓰기

select articleId, title, userId,content, name, wdate, udate
from article where articleId=6 \G;
하면 일단 조회

글삽입
insert into article(title,content,userId,name) values('w제목2',
'내용2',4,'이병헌');

글 수정
update article set title='제목을 수정했습니다.' where articleId=7;

글 삭제
delete from article where articleId=7;


1.글목록 (1PAGE)
SELECT articleId, title, userId, name, wdate
FROM article
ORDER BY articleId DESC
LIMIT 0, 25;

2.글 상세보기
SELECT articleId, title, content, userId, name, wdate, udate
FROM article
WHERE articleId=글번호;

3.글쓰기
INSERT article(title, content, userId, name)
VALUES('제목', '내용', 사용자번호,'이름');

4.글 수정
UPDATE article SET title='제목', content='내용'
WHERE articleId=글번호;

5.글 삭제
DELETE FROM article
WHERE article=글번호;

