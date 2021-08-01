Transaction이란
모두 실행되거나 취소되어야하는 일련의 실행들

예.
이체: 보내는 계좌에서 차감 -> 받는 계좌에서 증액
영화 예매: 좌석 점유 -> 포인트 사용 -> 신용카드 결제

실생활에서는 단일한걸로 만들어진 행동이아니라
여러개가 합쳐져서 단위를 이룬다.

start Transaction 하면 트랜잭션 시작
commit 또는 rollback 할 때 트랜잭션을 종료한다.

START TRANSACTION | BEGIN;

COMMIT | ROLLBACK;

CREATE TABLE film as select movieCd, title, productYear from movie
limit 10;

alter table film add primary key(movieCd);

delete from film where movieCd='19190007';

show variables like 'auto_commit';

show variables like 'autocommit';

start transaction;

delete from film where movieCd='19200004';

delete from film where movieCd='19240008';

update film set title='쌍옥루입니다.' where movieCd=''

rollback;
원복

roll back 하기전에

commit할때 다른 세션에서도 적용

Set Autocommit=0: 항상 트랜잭션 모드

show variables like 'autocommit';

set autocommit=on;
set autocommit=off;

데이터 제어하다가
db가 끊겨도 autocommit이 꺼져있으면
sql문 반영ㅇ안됨

autocommit이 on이되면 적용됨






