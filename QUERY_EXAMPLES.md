# Query Examples# ArcadeDB Query Examples

## Sample Queries for Data Loading and Manipulation

This document demonstrates ArcadeDB's multi-model querying capabilities using SQL, Cypher, and GraphQL.

This document contains example queries to create, read, and query data in ArcadeDB. These queries can be executed in the ArcadeDB Studio (http://localhost:2480) or via the REST API.

## Database Schema

---

The examples use three primary entity types:

- **User**: Represents individual users with properties (name, email, age, city)## 1. Database Setup

- **Product**: Represents items with properties (name, category, price, stock, rating)

- **FRIENDS/COLLEAGUES**: Relationships between users with strength property### Create a New Database

```sql

## SQL QueriesCREATE DATABASE SampleDB;

```

### Basic CRUD Operations

### Connect to Database (in Studio)

**Create a User:**```

```sqlUSE SampleDB;

INSERT INTO User SET name='Alice Johnson', email='alice@email.com', age=28, city='New York'```

```

---

**Read Users:**

```sql## 2. Schema Creation (Document & Graph Models)

SELECT * FROM User WHERE age > 25

```### Create Document Types (Tables)



**Update a User:**```sql

```sql-- Create User document type

UPDATE User SET city='San Francisco' WHERE name='Alice Johnson'CREATE DOCUMENT TYPE User;

```

-- Add properties to User

**Delete a User:**ALTER TYPE User CREATE PROPERTY name STRING;

```sqlALTER TYPE User CREATE PROPERTY email STRING;

DELETE FROM User WHERE name='Alice Johnson'ALTER TYPE User CREATE PROPERTY age INTEGER;

```ALTER TYPE User CREATE PROPERTY city STRING;

ALTER TYPE User CREATE PROPERTY occupation STRING;

### Aggregation QueriesALTER TYPE User CREATE PROPERTY interests LIST;

ALTER TYPE User CREATE PROPERTY joined_date DATE;

**Count users by city:**

```sql-- Create index on email for faster lookups

SELECT city, COUNT(*) as user_count FROM User GROUP BY city ORDER BY user_count DESCCREATE INDEX User_email ON User (email) UNIQUE;

``````



**Average product price by category:**```sql

```sql-- Create Product document type

SELECT category, AVG(price) as avg_price FROM Product GROUP BY categoryCREATE DOCUMENT TYPE Product;

```

-- Add properties to Product

**Find products with low stock:**ALTER TYPE Product CREATE PROPERTY product_name STRING;

```sqlALTER TYPE Product CREATE PROPERTY category STRING;

SELECT name, stock FROM Product WHERE stock < 50 ORDER BY stock ASCALTER TYPE Product CREATE PROPERTY price DECIMAL;

```ALTER TYPE Product CREATE PROPERTY stock INTEGER;

ALTER TYPE Product CREATE PROPERTY rating DECIMAL;

### Filtering and SortingALTER TYPE Product CREATE PROPERTY release_date DATE;



**High-rated products:**-- Create index on product_name

```sqlCREATE INDEX Product_name ON Product (product_name);

SELECT name, rating, price FROM Product WHERE rating >= 4.5 ORDER BY rating DESC```

```

### Create Vertex Types (for Graph Model)

**Users in specific age range:**

```sql```sql

SELECT name, age, city FROM User WHERE age BETWEEN 25 AND 35-- Create Person vertex type (graph model)

```CREATE VERTEX TYPE Person;



**Products in multiple categories:**ALTER TYPE Person CREATE PROPERTY name STRING;

```sqlALTER TYPE Person CREATE PROPERTY email STRING;

SELECT * FROM Product WHERE category IN ('Electronics', 'Furniture')ALTER TYPE Person CREATE PROPERTY age INTEGER;

```ALTER TYPE Person CREATE PROPERTY city STRING;

```

## Cypher Queries

### Create Edge Types (Relationships)

### Graph Traversal

```sql

**Find all friends of a user:**-- Create relationship edge types

```cypherCREATE EDGE TYPE FRIENDS;

MATCH (u:User {name: 'Alice Johnson'})-[:FRIENDS]->(friend:User)ALTER TYPE FRIENDS CREATE PROPERTY since DATE;

RETURN friend.name, friend.cityALTER TYPE FRIENDS CREATE PROPERTY strength DECIMAL;

```

CREATE EDGE TYPE COLLEAGUES;

**Find friends of friends:**ALTER TYPE COLLEAGUES CREATE PROPERTY since DATE;

```cypherALTER TYPE COLLEAGUES CREATE PROPERTY strength DECIMAL;

MATCH (u:User {name: 'Alice Johnson'})-[:FRIENDS]->()-[:FRIENDS]->(fof:User)

WHERE fof.name <> 'Alice Johnson'CREATE EDGE TYPE PURCHASED;

RETURN DISTINCT fof.name, fof.emailALTER TYPE PURCHASED CREATE PROPERTY purchase_date DATE;

```ALTER TYPE PURCHASED CREATE PROPERTY quantity INTEGER;

ALTER TYPE PURCHASED CREATE PROPERTY total_price DECIMAL;

**Find colleagues:**```

```cypher

MATCH (u:User {name: 'Bob Smith'})-[:COLLEAGUES]->(colleague:User)---

RETURN colleague.name, colleague.occupation

```## 3. INSERT Operations (CREATE)



### Path Queries### Insert Documents



**Shortest path between users:**```sql

```cypher-- Insert Users (Document Model)

MATCH path = shortestPath((u1:User {name: 'Alice Johnson'})-[*]-(u2:User {name: 'Jack Anderson'}))INSERT INTO User SET 

RETURN path  name = 'Alice Johnson', 

```  email = 'alice.johnson@email.com', 

  age = 28, 

**All paths up to 3 hops:**  city = 'San Francisco', 

```cypher  occupation = 'Software Engineer',

MATCH path = (u1:User {name: 'Alice Johnson'})-[*1..3]-(u2:User)  interests = ['coding', 'hiking', 'photography'],

RETURN u2.name, length(path) as distance  joined_date = date('2023-01-15');

```

INSERT INTO User SET 

### Pattern Matching  name = 'Bob Smith', 

  email = 'bob.smith@email.com', 

**Users with at least 2 friends:**  age = 35, 

```cypher  city = 'New York', 

MATCH (u:User)-[:FRIENDS]->(friend)  occupation = 'Data Scientist',

WITH u, COUNT(friend) as friend_count  interests = ['machine learning', 'reading', 'chess'],

WHERE friend_count >= 2  joined_date = date('2022-11-20');

RETURN u.name, friend_count

```INSERT INTO User SET 

  name = 'Carol Davis', 

**Mutual friends:**  email = 'carol.davis@email.com', 

```cypher  age = 42, 

MATCH (u1:User)-[:FRIENDS]->(mutual:User)<-[:FRIENDS]-(u2:User)  city = 'Seattle', 

WHERE u1.name = 'Alice Johnson' AND u2.name = 'Bob Smith'  occupation = 'Product Manager',

RETURN mutual.name  interests = ['product design', 'yoga', 'traveling'],

```  joined_date = date('2023-03-10');

```

## GraphQL Queries

```sql

### Basic Queries-- Insert Products

INSERT INTO Product SET 

**Fetch all users:**  product_name = 'Laptop Pro 15', 

```graphql  category = 'Electronics', 

{  price = 1299.99, 

  User {  stock = 45, 

    name  rating = 4.5,

    email  release_date = date('2023-01-15');

    age

    cityINSERT INTO Product SET 

  }  product_name = 'Wireless Mouse', 

}  category = 'Electronics', 

```  price = 29.99, 

  stock = 150, 

**Fetch products with filters:**  rating = 4.2,

```graphql  release_date = date('2023-02-20');

{

  Product(where: {category: "Electronics", price_lt: 500}) {INSERT INTO Product SET 

    name  product_name = 'Ergonomic Chair', 

    price  category = 'Furniture', 

    rating  price = 399.99, 

    stock  stock = 28, 

  }  rating = 4.4,

}  release_date = date('2023-03-22');

``````



### Nested Queries### Insert Vertices (Graph Model)



**Users with their friends:**```sql

```graphql-- Create Person vertices

{CREATE VERTEX Person SET 

  User {  name = 'Alice Johnson', 

    name  email = 'alice.johnson@email.com', 

    city  age = 28, 

    friends {  city = 'San Francisco';

      name

      emailCREATE VERTEX Person SET 

    }  name = 'Bob Smith', 

  }  email = 'bob.smith@email.com', 

}  age = 35, 

```  city = 'New York';



**Products with related information:**CREATE VERTEX Person SET 

```graphql  name = 'Carol Davis', 

{  email = 'carol.davis@email.com', 

  Product(orderBy: {rating: DESC}, limit: 10) {  age = 42, 

    name  city = 'Seattle';

    category```

    price

    rating### Create Edges (Relationships)

    description

  }```sql

}-- Create friendship between Alice and Bob

```CREATE EDGE FRIENDS 

FROM (SELECT FROM Person WHERE name = 'Alice Johnson') 

### MutationsTO (SELECT FROM Person WHERE name = 'Bob Smith') 

SET since = date('2023-02-01'), strength = 0.85;

**Create a new user:**

```graphql-- Create colleague relationship between Bob and Carol

mutation {CREATE EDGE COLLEAGUES 

  createUser(input: {FROM (SELECT FROM Person WHERE name = 'Bob Smith') 

    name: "New User"TO (SELECT FROM Person WHERE name = 'Carol Davis') 

    email: "newuser@email.com"SET since = date('2022-12-01'), strength = 0.68;

    age: 30

    city: "Boston"-- Create bidirectional friendship (mutual)

  }) {CREATE EDGE FRIENDS 

    nameFROM (SELECT FROM Person WHERE name = 'Carol Davis') 

    emailTO (SELECT FROM Person WHERE name = 'Alice Johnson') 

  }SET since = date('2023-03-15'), strength = 0.75;

}```

```

---

**Update product stock:**

```graphql## 4. SELECT Operations (READ)

mutation {

  updateProduct(### Basic Queries

    where: {name: "Laptop Pro"}

    input: {stock: 45}```sql

  ) {-- Get all users

    nameSELECT * FROM User;

    stock

  }-- Get all products

}SELECT * FROM Product;

```

-- Get specific columns

## Complex Analytical QueriesSELECT name, email, age FROM User;



### SQL Analytics-- Count records

SELECT count(*) FROM User;

**User distribution by age groups:**SELECT count(*) FROM Product;

```sql```

SELECT 

  CASE ### Filtering Queries

    WHEN age < 30 THEN '20-29'

    WHEN age < 40 THEN '30-39'```sql

    ELSE '40+' -- Find users by age

  END as age_group,SELECT * FROM User WHERE age > 30;

  COUNT(*) as count

FROM User-- Find users by city

GROUP BY age_groupSELECT * FROM User WHERE city = 'San Francisco';

```

-- Find products by category

**Top products by revenue potential:**SELECT * FROM Product WHERE category = 'Electronics';

```sql

SELECT name, price, stock, (price * stock) as potential_revenue-- Find products under certain price

FROM ProductSELECT * FROM Product WHERE price < 100;

ORDER BY potential_revenue DESC

LIMIT 5-- Find highly rated products

```SELECT * FROM Product WHERE rating >= 4.5;



### Cypher Analytics-- Multiple conditions

SELECT * FROM User WHERE age >= 25 AND age <= 35;

**Social network centrality:**

```cypher-- Pattern matching

MATCH (u:User)-[r:FRIENDS|COLLEAGUES]-()SELECT * FROM User WHERE name LIKE '%Johnson%';

RETURN u.name, COUNT(r) as connectionsSELECT * FROM Product WHERE product_name LIKE '%Pro%';

ORDER BY connections DESC

```-- Check if value in list

SELECT * FROM User WHERE city IN ['San Francisco', 'New York', 'Seattle'];

**Relationship strength analysis:**```

```cypher

MATCH (u1:User)-[r:FRIENDS]->(u2:User)### Sorting and Limiting

RETURN u1.name, u2.name, r.strength

ORDER BY r.strength DESC```sql

```-- Order by age (ascending)

SELECT * FROM User ORDER BY age ASC;

## Multi-Model Query Combination

-- Order by age (descending)

ArcadeDB allows combining different query languages in a single application:SELECT * FROM User ORDER BY age DESC;



1. Use **SQL** for transactional operations and aggregations-- Order by price

2. Use **Cypher** for graph traversal and relationship analysisSELECT * FROM Product ORDER BY price DESC;

3. Use **GraphQL** for API endpoints and nested data fetching

-- Get top 5 highest rated products

This flexibility enables optimal query selection based on specific use cases.SELECT * FROM Product ORDER BY rating DESC LIMIT 5;


-- Skip first 2 and get next 3
SELECT * FROM User ORDER BY age SKIP 2 LIMIT 3;
```

### Aggregation Queries

```sql
-- Average age of users
SELECT avg(age) as average_age FROM User;

-- Min and max age
SELECT min(age) as youngest, max(age) as oldest FROM User;

-- Total stock and average price by category
SELECT category, sum(stock) as total_stock, avg(price) as avg_price 
FROM Product 
GROUP BY category;

-- Count users by city
SELECT city, count(*) as user_count 
FROM User 
GROUP BY city 
ORDER BY user_count DESC;

-- Average rating by category
SELECT category, avg(rating) as avg_rating 
FROM Product 
GROUP BY category 
HAVING avg_rating >= 4.0;
```

### Array/List Queries

```sql
-- Find users with specific interest
SELECT * FROM User WHERE 'coding' IN interests;

-- Find users with multiple interests
SELECT * FROM User WHERE interests CONTAINS 'hiking' OR interests CONTAINS 'yoga';

-- Count interests
SELECT name, interests.size() as interest_count FROM User;
```

---

## 5. Graph Traversal Queries

### Basic Traversal

```sql
-- Get all friends of Alice
SELECT expand(out('FRIENDS')) FROM Person WHERE name = 'Alice Johnson';

-- Get all people Alice is friends with
SELECT expand(outE('FRIENDS').inV()) FROM Person WHERE name = 'Alice Johnson';

-- Get all incoming friendships to Bob
SELECT expand(in('FRIENDS')) FROM Person WHERE name = 'Bob Smith';

-- Get all colleagues
SELECT expand(out('COLLEAGUES')) FROM Person WHERE name = 'Bob Smith';
```

### Advanced Graph Queries

```sql
-- Friends of friends (2 hops)
SELECT expand(out('FRIENDS').out('FRIENDS')) 
FROM Person 
WHERE name = 'Alice Johnson';

-- Find mutual friends
SELECT expand(out('FRIENDS')) as friends1
FROM Person 
WHERE name = 'Alice Johnson'
AND out('FRIENDS').name IN (
  SELECT out('FRIENDS').name FROM Person WHERE name = 'Bob Smith'
);

-- Get all connections (friends and colleagues)
SELECT expand(out('FRIENDS', 'COLLEAGUES')) 
FROM Person 
WHERE name = 'Bob Smith';

-- Shortest path between two people
SELECT shortestPath($a, $b, 'BOTH') 
LET $a = (SELECT FROM Person WHERE name = 'Alice Johnson'),
    $b = (SELECT FROM Person WHERE name = 'Carol Davis');

-- Count connections
SELECT name, out('FRIENDS').size() as friend_count, 
       out('COLLEAGUES').size() as colleague_count 
FROM Person;
```

### Match Patterns (Cypher-like)

```sql
-- Find people and their friends
MATCH {type: Person, as: p}-FRIENDS->{as: friend}
RETURN p.name, friend.name;

-- Find friends of friends
MATCH {type: Person, as: p, where: (name = 'Alice Johnson')}
  -FRIENDS->{as: friend1}
  -FRIENDS->{as: friend2}
RETURN p.name, friend1.name, friend2.name;

-- Find colleague networks
MATCH {type: Person, as: p1}-COLLEAGUES->{as: p2}-COLLEAGUES->{as: p3}
RETURN p1.name, p2.name, p3.name;
```

---

## 6. UPDATE Operations

### Update Documents

```sql
-- Update single record
UPDATE User SET age = 29 WHERE name = 'Alice Johnson';

-- Update multiple fields
UPDATE User SET 
  city = 'Los Angeles', 
  occupation = 'Senior Software Engineer' 
WHERE email = 'alice.johnson@email.com';

-- Add to list/array
UPDATE User SET interests = interests.append('gaming') 
WHERE name = 'Bob Smith';

-- Update product price (discount)
UPDATE Product SET price = price * 0.9 WHERE category = 'Electronics';

-- Increase stock
UPDATE Product SET stock = stock + 50 WHERE product_name = 'Wireless Mouse';
```

### Update with Return

```sql
-- Update and return the modified record
UPDATE User SET age = age + 1 
WHERE name = 'Alice Johnson' 
RETURN AFTER;
```

---

## 7. DELETE Operations

```sql
-- Delete specific user
DELETE FROM User WHERE email = 'test@example.com';

-- Delete products with zero stock
DELETE FROM Product WHERE stock = 0;

-- Delete old records
DELETE FROM User WHERE joined_date < date('2022-01-01');

-- Delete vertex (also removes connected edges)
DELETE VERTEX Person WHERE name = 'Test User';

-- Delete edge
DELETE EDGE FRIENDS WHERE since < date('2022-01-01');
```

---

## 8. Complex Queries

### Subqueries

```sql
-- Find users older than average
SELECT * FROM User 
WHERE age > (SELECT avg(age) FROM User);

-- Find products more expensive than category average
SELECT p.* FROM Product p
WHERE p.price > (
  SELECT avg(price) FROM Product WHERE category = p.category
);
```

### Joins (Document Model)

```sql
-- Manual join using WHERE
SELECT user.name, product.product_name 
FROM User user, Product product
WHERE user.city = 'San Francisco' AND product.category = 'Electronics';
```

### Batch Insert

```sql
-- Insert multiple records at once
BEGIN;
INSERT INTO User SET name = 'User1', email = 'user1@test.com', age = 25;
INSERT INTO User SET name = 'User2', email = 'user2@test.com', age = 30;
INSERT INTO User SET name = 'User3', email = 'user3@test.com', age = 35;
COMMIT;
```

---

## 9. Transaction Examples

```sql
-- Start transaction
BEGIN;

-- Multiple operations
CREATE VERTEX Person SET name = 'David Martinez', age = 31;
CREATE VERTEX Person SET name = 'Emma Wilson', age = 26;
CREATE EDGE FRIENDS 
FROM (SELECT FROM Person WHERE name = 'David Martinez') 
TO (SELECT FROM Person WHERE name = 'Emma Wilson')
SET since = date('2023-05-22');

-- Commit transaction
COMMIT;

-- Or rollback if error
-- ROLLBACK;
```

---

## 10. Utility Queries

```sql
-- Show all types (schemas)
SELECT expand(classes) FROM metadata:schema;

-- Show properties of a type
SELECT expand(properties) FROM (SELECT FROM metadata:schema WHERE name = 'User');

-- Count records by type
SELECT '@type' as type, count(*) as count FROM V GROUP BY @type;

-- Database info
SELECT * FROM metadata:database;

-- Show indexes
SELECT * FROM metadata:indexes;
```

---

## 11. API Examples (REST)

### Query via REST API

```bash
# Execute SQL query via REST
curl -X POST "http://localhost:2480/api/v1/query/SampleDB" \
  -H "Content-Type: application/json" \
  -u "root:arcadedb" \
  -d '{
    "language": "sql",
    "command": "SELECT * FROM User WHERE age > 30"
  }'
```

```bash
# Insert via REST
curl -X POST "http://localhost:2480/api/v1/command/SampleDB" \
  -H "Content-Type: application/json" \
  -u "root:arcadedb" \
  -d '{
    "language": "sql",
    "command": "INSERT INTO User SET name=\"Test User\", email=\"test@test.com\", age=25"
  }'
```

---

## 12. Import Data from JSON

```sql
-- Import users from JSON
IMPORT DATABASE file:///home/arcadedb/sample-data/users.json
WITH users AS User;
```

For CSV import, you can use the REST API or convert to JSON first.

---

## Performance Tips

1. **Use Indexes**: Create indexes on frequently queried fields
   ```sql
   CREATE INDEX User_city ON User (city);
   ```

2. **Limit Results**: Always use LIMIT for large datasets
   ```sql
   SELECT * FROM User LIMIT 100;
   ```

3. **Use Projections**: Select only needed fields
   ```sql
   SELECT name, email FROM User;
   ```

4. **Batch Operations**: Use transactions for multiple inserts
   ```sql
   BEGIN;
   -- multiple inserts
   COMMIT;
   ```

5. **Optimize Traversals**: Use depth limits
   ```sql
   SELECT expand(out('FRIENDS', 0, 2)) FROM Person;  -- max 2 hops
   ```

---

## Screenshots Checklist

For your assignment submission, take screenshots of:
1.  Successful database creation
2.  Schema creation (types and properties)
3.  Data insertion confirmation
4.  SELECT query results (showing all users)
5.  Filtered query results (WHERE clause)
6.  Graph traversal results (friends query)
7.  Aggregation query results (COUNT, AVG)
8.  ArcadeDB Studio interface with query editor
9.  GCP Kubernetes dashboard showing pods
10. External IP access to ArcadeDB Studio from browser
---

**Note**: Replace `root:arcadedb` with your actual credentials if you changed the default password.
