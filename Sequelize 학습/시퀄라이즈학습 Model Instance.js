// // Model instances 
// // ES6 에서 나온 CLASS다.Instance는 class로부터 나온 object이다.
// 레코드에 대한 정보를 담고잇는 인스턴스, 단순히 컬럼값만 가지고있는게아니라
// static method라던가 instance method 등
// DAO:Data access object are model instances
// For this guide the following setup will be assumed

const { Sequelize, Model, DataTypes } = require("sequelize");
const sequelize = new Sequelize("sqlite::memory:");

const User = sequelize.define("user", {
    name: DataTypes.TEXT,
    favoriteColor : {
        type: Datatypes.TEXT,
        defaultValue: 'green'
    },
    age: DataTypes.INTEGER,
    cash: DataTypes.INTEGER
});

(async() => {
    await sequelize.sync({force:true});
})();

// Creating an Instance
// new라는 오퍼레이터를 통해 인스턴스를 만들면안됌
// 그 대신 데이터베이스에 꽂히는 것 같다. NEW대신 BUILD를 사용
// OBJECT 만들고 SAVE해야 async적으로 DATABASE에 꽂힌다.

const jane = User.build({ name: "Jane"});
console.log(jane instanceof User); //true
console.log(jane.name); //"Jane"

await jane.save();
console.log('Jane was saved to the database!');


// A very useful shortcut: create method

const jane = await User.create({name:"Jane"});
//Jane exists in the database now!
console.log(jane instanceof User); // true
console.log(jane.name); //"Jane"


// Note:logging instances
// jane ㅉ끼으면 너무 많은 정보가 많다.DataTypes
// tojson을 찎으면 적절하게 instancemethod나 이런거 뺴고 순수한 데이터만 전달
// Instead, you can use the .toJSON()

const jane = await User.create({name:"Jane"});
//console.log(jane); // Dont do this
console.log(jane.toJSON()); // This^^
console.log(JSON.stringify(jane, null, 4));// This is also good!


// Updating an instances
// 안의 내용을 바꾸고 그냥 다시 save해서
// save 메소드 이용해서 업데이트한다. 프로퍼티를 바꾼다음에 그냥 세이브하면 된다.

const jane = await User.create({ name: "Jane" });
console.log(jane.name); // "Jane"
jane.name = "Ada";
// the name is still "Jane" in the database
await jane.save();
// Now the name was updated to "Ada" in the database!


// Deleting an instances
// Destroy method 사용해서 지운다.

const jane = await User.create({ name: "Jane" });
console.log(jane.name); // "Jane"
await jane.destroy();
// Now this entry was removed from the database



// Reloading an instance
// await하면 데이터베이스에 꽂히고
// reload 하면 select 알아서 해준다.DataTypes
// 현재 데이터베이스에있는 state를 그대로 가져옴. select 쿼리를 돌린다.

const jane = await User.create({ name: "Jane" });
console.log(jane.name); // "Jane"
jane.name = "Ada";
// the name is still "Jane" in the database
await jane.reload();
console.log(jane.name); // "Jane"

// saving only some fields
// save할떄 fields의 name만 반영해서 할 수도 있음

// change-awareness of save 최적화를 위해 실제 변경이 안됫는데
// save를 하면 그냥 무시한다.



// incrementing and decrementing integer values
// 동시성 이슈? jane age는 age + 2 하고 save하면되는데
// 숫자는 integer value를 더하거나 뺼때 이런 메소드 사용 가능.
// concurrency 없이 await jane.increment

const jane = await User.create({ name: "Jane", age: 100 });
const incrementResult = await jane.increment('age', { by: 2 });
// Note: to increment by 1 you can omit the `by` option and just do `user.increment('age')`

// In PostgreSQL, `incrementResult` will be the updated user, unless the option
// `{ returning: false }` was set (and then it will be undefined).

// In other dialects, `incrementResult` will be undefined. If you need the updated instance, you will have to call `user.reload()`.


const jane = await User.create({ name: "Jane", age: 100, cash: 5000 });
await jane.increment({
  'age': 2,
  'cash': 100
});

// If the values are incremented by the same amount, you can use this other syntax as well:
await jane.increment(['age', 'cash'], { by: 2 });