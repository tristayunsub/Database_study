SELECT column_name1, column_name2,...
FROM table_name
WHERE condition
ORDER BY column_name ASC|DESC,... 
LIMIT offset, count; 몇번째 글부터 몇개 리미트안하면 글 1억개 셀렉트해오게된다.


UPDATE table_name
SET column1=value1, column2=value2,...
WHERE condition;

DELETE FROM table_name
WHERE condition;

1.회원목록 조회
select userId, email, name from user order by userId desc;
순차정렬과는 다른 큰 것부터.
5
4
2
1



select userId, email, name from user order by userId desc limit 0,2;
하면
5
4

select userId, email, name from user order by userId desc limit 2,2;
2
1

select userId, email, name from user order by userId desc limit 0,25;
뭐 한페이지에 25개의 아이디만

select userId, name, email from user wher userId=5;
5번 회원정보 가져오기

insert user(email, password, name) values('bts@naver.com', '1','BTS');

bts들어갔는데 비밀번호가 1로들어간다 안되다이럼

insert user(email, password, name) values('bts@naver.com', sha2('1',256),'BTS');

select userId, password, name, email from user where userId=8 \G;


select userId, name, email from where email ='bts@naver.com' and password=sha2('1',256);
userId가 선택된다. 아이디가나옴. sha2에 2 3 번 넣으면 안나옴

비밀번호 변경
update user set password=sha2('2',256) where userId=8 and password=sha2('1',256);

select * from user;
하면 값을 바꾼다.

해지
delete from user where userId= 8 and password=sha2('xxxx',256);
회원 해지할때 비밀번호입력하라고 해줘야되잖아. 그래서 뒤에 password삽입하는것

delete from user where userId= 8 and password=sha2('3',256);
Query OK, 1 row affected 뜨면 삭제된거


1.회원목록 조회
SELECT userId, name, email
FROM user
ORDER BY userId DESC
LIMIT 0, 25;

2.회원 1명 조회
SELECT userId, name, email
FROM user
WHERE userId=사용자번호;

3.회원가입
INSERT user(email, password, name)
VALUES ('이메일주소',sha2('비밀번호',256), '이름');

4.로그인
SELECT userId, name, email
FROM user
WHERE email = '이메일주소'
        AND password=sha2('비밀번호',256);


5. 비밀번호 변경
UPDATE user
SET password=sha2('새 비밀번호', 256)
WHERE userId= 사용자번호
     and password=sha2('현재 비밀번호',256);

6.해지
DELETE FROM user
WHERE userId=사용자번호;




