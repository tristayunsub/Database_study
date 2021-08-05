// Model querying이란? 데이터베이스를 manipulate하는 method 제공
// 비즈니스 로직이 한번 수행이될떄 모든 쿼리가 통과되던 안되던해야지
// Crud 하는 방법에 대해서 배우자

const { FORMERR } = require("dns");




// Simple INSERT queries
// create method는 build랑 같다, 모든 프로퍼티들을 저장하는게 아니라. 일부만 정해서
// 데이터베이스에 insert할 수 있다.


// Create a new user
const jane = await User.create({ firstName: "Jane", lastName: "Doe" });
console.log("Jane's auto-generated ID:", jane.id);

// It is also possible to define which attributes can be set in the create method.
//  This can be especially useful 
// if you create database entries based on a form which can be filled by a user. 


const user = await User.create({
    username: 'alice123',
    isAdmin: true
  }, { fields: ['username'] });
  // let's assume the default of isAdmin is false
  console.log(user.username); // 'alice123'
  console.log(user.isAdmin); // false



// Simple Select quries
// findall method 사용한다.Select

//Find all users
const users = await User.findAll();
console.log(users.every(user => user instanceof User)); //true array method고 user instance 고
console.log("All users:", JSON.stringify(users, null, 2)); // stringfy 객체를 문자화. 몽구스랑 비슷하다

=

SELCT * FROM...


// Specifying attributes for select queries

Model.findAll({
    attributes: ['foo', 'bar']
  });
  SELECT foo, bar FROM ...

//   Attributes can be renamed using a nested array:

  Model.findAll({
    attributes: ['foo', ['bar', 'baz'], 'qux']
  });
  SELECT foo, bar AS baz, qux FROM ...


//다른 함수 aggregation(집합 min,max,count) 함수 쓸때 sequelize.fn를 쓴다.

// You can use sequelize.fn to do aggregations:

Model.findAll({
  attributes: [
    'foo',
    [sequelize.fn('COUNT', sequelize.col('hats')), 'n_hats'],
    'bar'
  ]
});
SELECT foo, COUNT(hats) AS n_hats, bar FROM ...


// exclude 메소드도있다 특정 컬럼만 빼고 싶으면 
Model.findAll({
    attributes: { exclude: ['baz'] }
  });
  -- Assuming all columns are 'id', 'foo', 'bar', 'baz' and 'qux'
  SELECT id, foo, bar, qux FROM ...



//Applying WHERE clauses 
where에는 굉장히 많은.. 오퍼레이터들이있다. 작다 같지않다, 포함된다 포함되지않는다 등.
Op라는 operator를 제공. op.eq op equal

Post.findAll({
    where: {
      authorId: 2
    }
  });
  // SELECT * FROM post WHERE authorId = 2

  또는

  const { Op } = require("sequelize");
  Post.findAll({
    where: {
      authorId: {
        [Op.eq]: 2
      }
    }
  });
  // SELECT * FROM post WHERE authorId = 2

//   Multiple checks can be passed:

  Post.findAll({
    where: {
      authorId: 12
      status: 'active'
    }
  });
  // SELECT * FROM post WHERE authorId = 12 AND status = 'active';

//   Sequelize provides several operators.

  const { Op } = require("sequelize");
  Post.findAll({
    where: {
      [Op.and]: [{ a: 5 }, { b: 6 }],            // (a = 5) AND (b = 6)
      [Op.or]: [{ a: 5 }, { b: 6 }],             // (a = 5) OR (b = 6)
      someAttribute: {
        // Basics
        [Op.eq]: 3,                              // = 3
        [Op.ne]: 20,                             // != 20
        [Op.is]: null,                           // IS NULL
        [Op.not]: true,                          // IS NOT TRUE
        [Op.or]: [5, 6],                         // (someAttribute = 5) OR (someAttribute = 6)
  
        // Using dialect specific column identifiers (PG in the following example):
        [Op.col]: 'user.organization_id',        // = "user"."organization_id"
  
        // Number comparisons
        [Op.gt]: 6,                              // > 6
        [Op.gte]: 6,                             // >= 6
        [Op.lt]: 10,                             // < 10
        [Op.lte]: 10,                            // <= 10
        [Op.between]: [6, 10],                   // BETWEEN 6 AND 10
        [Op.notBetween]: [11, 15],               // NOT BETWEEN 11 AND 15
  

// Operator Combination
그때 그떄마다 찾아서본다.

// Examples with Op.not


Project.findAll({
  where: {
    name: 'Some Project',
    [Op.not]: [
      { id: [1,2,3] },
      {
        description: {
          [Op.like]: 'Hello%'
        }
      }
    ]
  }
});
The above will generate:

SELECT *
FROM `Projects`
WHERE (
  `Projects`.`name` = 'a project'
  AND NOT (
    `Projects`.`id` IN (1,2,3)
    OR
    `Projects`.`description` LIKE 'Hello%'
  )
)


// Simple UPDATE queries
// Update queries also accept the where option, just like the read queries shown above.

// Change everyone without a last name to "Doe"
await User.update({ lastName: "Doe" }, {
  where: {
    lastName: null
  }
});


// Simple DELETE queries
// Delete queries also accept the where option, just like the read queries shown above.

// Delete everyone named "Jane"
await User.destroy({
  where: {
    firstName: "Jane"
  }
});
To destroy everything the TRUNCATE SQL can be used:

// Truncate the table
await User.destroy({
  truncate: true
});


// Creating in bulk
// 한번에 쿼리넣었을때 bulk로하자 쿼리날리는 수자체가 줄어드니까 훨씬 더 최적화 된다.
// 어레이를 받아서 어레이를 준다.

// Sequelize provides the Model.bulkCreate method to allow creating multiple records at once,
// with only one query.

// The usage of Model.bulkCreate is very similar to Model.create, 
// by receiving an array of objects instead of a single object

const captains = await Captain.bulkCreate([
    { name: 'Jack Sparrow' },
    { name: 'Davy Jones' }
  ]);
  console.log(captains.length); // 2
  console.log(captains[0] instanceof Captain); // true
  console.log(captains[0].name); // 'Jack Sparrow'
  console.log(captains[0].id); // 1 // (or another auto-generated value)



// Ordering 과 Grouping
// 그루핑 잘쓰지마라.


// Limits and Pagination

// Fetch 10 instances/rows
Project.findAll({ limit: 10 });

// Skip 8 instances/rows
Project.findAll({ offset: 8 });

// Skip 5 instances and fetch the 5 after that 5번쨰부터 5개를 가져온다.
Project.findAll({ offset: 5, limit: 5 }); 



//Utility method 데이터베이스에서 제공하는 count나 max, min, sum 같은 기능을
//시퀄라이즈에서도 제공한다.
console.log(`There are ${await Project.count()} projects`);

const amount = await Project.count({
  where: {
    id: {
      [Op.gt]: 25
    }
  }
});
console.log(`There are ${amount} projects with an id greater than 25`);

await User.max('age'); // 40
await User.max('age', { where: { age: { [Op.lt]: 20 } } }); // 10
await User.min('age'); // 5