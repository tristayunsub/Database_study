

sequelize는 기본적으로 transaction을 설정해주지않는다
2가지 방법
1. unmanaged transaction manually 해야됨
2. managed transactions. CLS transaction object라는게 있다.



// Unmanaged transactions
// 트랜잭션 옵션을줘서 create, addsibling 묶여서 커밋하게되고
// 에러나면 롤백하게되어있음. 
//requires 커밋이랑 롤백을 직접써주는게 unmanaged transaction이다.
const t = await sequelize.transaction();

try {
    //Then, we do some calls passing this transaction as an option



const user = await User.create({
    firstName: 'Bart',
    lastName: 'Simpson'
  }, { transaction: t });

  await user.addSibling({
    firstName: 'Lisa',
    lastName: 'Simpson'
  }, { transaction: t });

  // If the execution reaches this line, no errors were thrown.
  // We commit the transaction.
  await t.commit();

} catch (error) {

  // If the execution reaches this line, an error was thrown.
  // We rollback the transaction.
  await t.rollback();

}




// Managed transaction

// 커밋이나 롤백을 automatically 진행한다. try catch문으로 뭘하긴 귀찮으니까. 

// function 형태로 때려넣는다.
// 콜백을 실행시켜준다. 기본적으로 t라는 오브젝트를 받아서 옵션에 넣어준다.CLS
// 에러가 발생되면. throwed error 핸들링만 해주면된다.
//t를 받아서 콜백형태로 managed transaction 사용

try {

    const result = await sequelize.transaction(async (t) => {
  
      const user = await User.create({
        firstName: 'Abraham',
        lastName: 'Lincoln'
      }, { transaction: t });
  
      await user.setShooter({
        firstName: 'John',
        lastName: 'Boothe'
      }, { transaction: t });
  
      return user;
  
    });
  
    // If the execution reaches this line, the transaction has been committed successfully
    // `result` is whatever was returned from the transaction callback (the `user`, in this case)
  
  } catch (error) {
  
    // If the execution reaches this line, an error occurred.
    // The transaction has already been rolled back automatically by Sequelize!
  
  }

// throw errors to rollback
// 에러를 던지지 않을떄 석세스한거라 가정했고.
// but 어떤 에러를 발생했을때 정상으로한다해도 프로그래머가
// 에러를 수동으로 던지면 rollback 해준다.

await sequelize.transaction(async t => {
    const user = await User.create({
      firstName: 'Abraham',
      lastName: 'Lincoln'
    }, { transaction: t });
  
    // Woops, the query was successful but we still want to roll back!
    // We throw an error manually, so that Sequelize handles everything automatically.
    throw new Error();
  });

automatically pass transactions to all qeuries
트랜잭션을 쿼리로 보낸다. 트랜잭션이 수동으로 
you must install module 

To enable CLS you must tell sequelize which namespace to use by using a static method of the sequelize constructor:

config를 통해 자동으로 주입하게 할 수 있다.

const { createHook } = require('async_hooks')
const cls = require('cls-hooked');
const { urlToHttpOptions } = require('http')
const namespace = cls.createNamespace('my-very-own-namespace');


// all instance는 같은 namespace를 사용 CLS works like thread-local storage처럼 움직인다.CLS
// 일일히 주입안해도됌

const Sequelize = require('sequelize');
Sequelize.useCLS(namespace);

new Sequelize(....);
Notice, that the useCLS() method is on the constructor, 

// not on an instance of sequelize. This means that all instances
//  will share the same namespace, and that CLS is all-or-nothing -
//   you cannot enable it only for some instances.


  sequelize.transaction((t1) => {
    namespace.get('transaction') === t1; // true
  });
  
  sequelize.transaction((t2) => {
    namespace.get('transaction') === t2; // true
  });

//   In most case you won't need to access namespace.get('transaction') directly, since all queries will automatically look for a transaction on the namespace:

  sequelize.transaction((t1) => {
    // With CLS enabled, the user will be created inside the transaction
    return User.create({ name: 'Alice' });
  }); // t1이 자동으로 주입된다. 



// Concurrent/Partial transactions
// 트랜잭션이 여러개 일 수도 있다. 트랜잭션 안에있어서
// t2 트랜잭션에 null하면 독단적으로 움직일수도있고, 트랜잭션안에 또 트랜잭션이있네
// t2라는 트랜잭션에 걸리게된다? 안쓴 3번째줄은. 트랜잭선 2번째줄은 중첩도 가능하다. 


With CLS enabled

sequelize.transaction((t1) => {
  return sequelize.transaction((t2) => {
    // With CLS enabled, queries here will by default use t2.
    // Pass in the `transaction` option to define/alter the transaction they belong to.
    return Promise.all([
        User.create({ name: 'Bob' }, { transaction: null }),
        User.create({ name: 'Mallory' }, { transaction: t1 }),
        User.create({ name: 'John' }) // this would default to t2
    ]);
  });
});



Isolation levels
lock을 어느레벨까지할거냐, table단으로? 레코드단으로?
use when starting an transaction 정의
각각의 트랜잭션에서 정의할수도있고, global하게 한번에 정할수 있다.

const { Transaction } = require('sequelize');

// The following are valid isolation levels:
Transaction.ISOLATION_LEVELS.READ_UNCOMMITTED // "READ UNCOMMITTED"
Transaction.ISOLATION_LEVELS.READ_COMMITTED // "READ COMMITTED"
Transaction.ISOLATION_LEVELS.REPEATABLE_READ  // "REPEATABLE READ"
Transaction.ISOLATION_LEVELS.SERIALIZABLE // "SERIALIZABLE"

// By default, sequelize uses the isolation level of the database. If you want to use a different isolation level, pass in the desired level as the first argument:

const { Transaction } = require('sequelize');

await sequelize.transaction({
  isolationLevel: Transaction.ISOLATION_LEVELS.SERIALIZABLE
}, async (t) => {
  // Your code
});

// You can also overwrite the isolationLevel setting globally with an option in the Sequelize constructor:

const { Sequelize, Transaction } = require('sequelize');

const sequelize = new Sequelize('sqlite::memory:', {
  isolationLevel: Transaction.ISOLATION_LEVELS.SERIALIZABLE
});



// The afterCommit hook
// 커밋하고 뭔가 function 부를수 있게해준다.
// 커밋을 트랜잭션은 트래킹하기 때문에 커밋 완료 후에 callbackfunction을 
// 부를 수 있다.

// Managed transaction:
await sequelize.transaction(async (t) => {
    t.afterCommit(() => {
      // Your logic
    });
  });
  
  // Unmanaged transaction:
  const t = await sequelize.transaction();
  t.afterCommit(() => {
    // Your logic
  });
  await t.commit();






