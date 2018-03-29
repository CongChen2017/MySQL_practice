-- initiate database and choose database
DROP DATABASE IF EXISTS books_db;
CREATE DATABASE books_db;
USE books_db;

-- create table 1 --
CREATE TABLE books(
  id INTEGER(11) AUTO_INCREMENT NOT NULL,
  authorId INTEGER(11),
  title VARCHAR(100),
  PRIMARY KEY (id)
);

-- create table 2 --
CREATE TABLE authors(
  id INTEGER(11) AUTO_INCREMENT NOT NULL,
  firstName VARCHAR(100),
  lastName VARCHAR(100),
  PRIMARY KEY (id)
);

-- input information to table --
INSERT INTO authors (firstName, lastName) 
values ('Jane', 'Austen'), ('Mark', 'Twain'), ('Lewis', 'Carroll'), ('Andre', 'Asselin');

-- input information to another table --
INSERT INTO books (title, authorId) 
values ('Pride and Prejudice', 1), ('Emma', 1), ('The Adventures of Tom Sawyer', 2),
	('Adventures of Huckleberry Finn', 2), ('Alice''s Adventures in Wonderland', 3), ('Dracula', null);

-- check both tables --
SELECT * FROM authors;
SELECT * FROM books;

-- show ALL books with authors
-- INNER JOIN will only return all matching values from both tables
SELECT title, firstName, lastName
FROM books
INNER JOIN authors ON books.authorId = authors.id;

-- show ALL books, even if we don't know the author
-- LEFT JOIN returns all of the values from the left table, and the matching ones from the right table
SELECT title, firstName, lastName
FROM books
LEFT JOIN authors ON books.authorId = authors.id;

-- show ALL authors, even if we don't know the book
-- RIGHT JOIN returns all of the values from the right table, and the matching ones from the left table
SELECT title, firstName, lastName
FROM books
RIGHT JOIN authors ON books.authorId = authors.id;