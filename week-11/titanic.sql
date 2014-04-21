-- A good set of docs for SQL (for sqlite3) is:
-- https://www.sqlite.org/lang.html

-- Incidentally, comments start with --

-- Arithmetic is weird:
select 1 + 1;

-- Table describing passengers on the titanic
-- This is the training set for the Kaggle contest.

-- Note that the 'if not exists' is optional
create table if not exists passengers  (
    id integer primary key,
    survived integer not null,
    pclass integer,
    pname varchar(255) unique,
    sex varchar(6),
    age double not null,
    sibsp integer,
    parch integer,
    ticket varchar(255),
    fare double,
    cabin varchar(16),
    embarked varchar(16)
);

.separator ','
.import '/Users/richard/Desktop/titanic-train.csv' passengers

-- The syntax where commands start with a . is specific
-- to sqlite3.
-- The use of select here may seem weird, but it's correct...
select 'Here is the schema:';
.schema passengers

-- Get the number of passengers - should print 891
select '';
select 'There were this many passengers:';
select count(*) from passengers;

-- Basic select
select * from passengers;

-- Adding a where clause
select * from passengers where age < 10;

-- We can also select only parts of rows. This is called projection.
select pname from passengers where age < 10 and sex = 'female';

select pname, age from passengers where age < 10 and sex = 'female' and survived = 0;

-- Give me names and ages of girls less than 10 years old who died,
-- ordered from youngest to oldest
select pname, age from passengers where age < 10 and sex = 'female' and survived = 0 order by age;

-- How is this working?
explain query plan select * from passengers where age < 10;

-- Question: What's wrong with this?

-- Here's how we can fix it:

-- This is a quirk of sqlite3. We have to manually gather stats on
-- the tables.
analyze passengers;

-- This make things faster... How could it do that?
create index if not exists age_index on passengers ( age );

-- And let's see what changes:
explain query plan select * from passengers where age < 10;

-- Let's look at inserts and updates:
create table if not exists users (
  id integer primary key,
  first_name varchar(16),
  last_name varchar(16),
  age integer
);

-- We do inserts as follows:
-- Note that we can insert more than one thing at a time.
insert into users (id, first_name, last_name, age) values
  (0, 'richard', 'kelley', 30),
  (1, 'marcus', 'aurelius', 1893);

-- And let's do a simple update:
update users set age = age + 1 where age > 30;

-- Confirm that it worked
select * from users;

-- And deletion
delete from users where first_name = 'richard';

-- Let's delete all the things:
delete from users;

-- We can also group statements into transactions.
-- These are how databases deal with concurrency.
begin transaction;
  insert into users (id, first_name, last_name, age) values (2, 'richard', 'kelley', 30);
  update users set age = age + 1;
commit;

-- and then let's get rid of our tables...
drop table if exists passengers;
drop table if exists users;
