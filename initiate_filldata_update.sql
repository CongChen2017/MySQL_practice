-- Drops the favorite_db if it exists currently --
DROP DATABASE IF EXISTS animals_db;

-- create database --

CREATE DATABASE animals_db;

-- choose the database need to use --

USE animals_db;

-- create table in the target database --

CREATE TABLE people (
  -- Creates a numeric column called "id" which will automatically increment its default value as we create new rows --
  id INTEGER(11) AUTO_INCREMENT NOT NULL,
  -- Makes a string column called "name" which cannot contain null --
  name VARCHAR(30) NOT NULL,
  -- Makes a boolean column called "has_pet" which cannot contain null --
  has_pet BOOLEAN NOT NULL,
  -- if set default value --
  -- has_pet BOOLEAN DEFAULT false,--
  -- Makes a sting column called "pet_name" --
  pet_name VARCHAR(30),
  -- Makes an numeric column called "pet_age" --
  pet_age INTEGER(10),
  -- Sets id as this table's primary key which means all data contained within it will be unique --
  PRIMARY KEY (id)
);

-- insert data into the table --

INSERT INTO people (name, has_pet, pet_name, pet_age)
VALUES ("Jacob", true, "Misty", 10), ("Ahmed", true, "Rockington", 100);

INSERT INTO people (name, has_pet)
VALUES ("Peter", false);

-- check the table --

SELECT * FROM people;

-- update information and check table again--

UPDATE people
SET has_pet = true
WHERE name = "Peter";

SELECT * FROM people;

-- Updates the row where the column name is peter --
UPDATE people
SET pet_name = "Franklin", pet_age = 2
WHERE id = 3;

SELECT * FROM people;



