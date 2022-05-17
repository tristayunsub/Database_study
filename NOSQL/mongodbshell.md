https://spidyweb.tistory.com/167?category=833086

NOSQL] MongoDB Shell(명령어)로 CSV, JSON import


shell을 통해 csv, json 파일 import하는 방법~



https://riptutorial.com/mongodb/example/21736/mongoimport-with-csv


mongoimport --db 데이터베이스이름 --collection 콜렉션이름 --host "연결될 호스트주소" --file "파일의 위치\파일이름.확장자"


jsonarray?

--jsonarray 추가.


mongoimport --db 데이터베이스이름 --collection 콜렉션이름 --host "연결될 호스트주소" --jsonArray --file "파일의 위치\파일이름.확장자"

 
