NOSQL 공부


https://spidyweb.tistory.com/163?category=833086




3.데이터베이스 생성,조회,사용

>show dbs

-데이터 베이스의 목록을 보여줍니다.(현재 testdb는 만들어둔 DB)

use <DB이름>

데이터베이스를 사용하려면 관계형 DB에서 DATABASE만ㄷ르고 TABLE 만들어주는거랑 비슷하게..

USE 명령어 사용해서 DB사용및 생성.

use testdb하면

switched to db testdb


>db 

현재 사용하고있는 데이터베이스를 보여준다.

>db.testcloolection.insertOne({키:값)}//

명시적인 collection 생셩
```

db.createCollection(<Collection 명칭>, { capped: <boolean>,

                              autoIndexId: <boolean>,

                              size: <number>,

                              max: <number>,

                              storageEngine: <document>,

                              validator: <document>,

                              validationLevel: <string>,

                              validationAction: <string>,

                              indexOptionDefaults: <document>,

                              viewOn: <string>,

                              pipeline: <pipeline>,

                              collation: <document> } 
   ```
   
   
 4.컬렉션 조회
 
> show collections

5.Document

>db.testcollection.insert({"key": "vlaue", "key2":"value2"})


>db.collection이름.find()

find를 이용해서. collection에 들어가있는 값들을 볼수있음.

find(query,projection) 메소드는 


#update

```
>db.컬렉션이름.update(<query>, <update>, 
   { upsert:<불리언>,
     multi:<boolean>,
     writeConcern:
     <document>
       }
      )
       
  ```
  
  parametertypedescription.
  
  db삭제
  
  db.dropDatabese()
  {"dropped" : "testdb", "ok" : 1}
  >show dbs
  >
       
       
 collection 삭제
 
 db.testdb2.drop()
 true

       


Mongos


mongos 인스턴스 이며 DB데이터는 가지고 있지 않으며 단순 query routing기능을 수행한다.
물리 서버가 여러대 이며 클러스터로 구성 되어져 있다면 각각의 물리 서버에 mongos인스턴스를 띄워서 분산 처리를 하는 것이 성능상의 이점을 가져올수 있다.



