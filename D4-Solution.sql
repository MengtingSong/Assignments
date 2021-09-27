-- 1
USE [D4-Q1]
GO

CREATE TABLE HeadOffices
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(45) NOT NULL,
    address VARCHAR(100),
    phone_number VARCHAR(20) NOT NULL,
    director VARCHAR(40),
    city_id INT NOT NULL
);

CREATE TABLE Projects
(
    id INT PRIMARY KEY IDENTITY(1,1),
    project_code INT NOT NULL,
    project_title VARCHAR(40),
    starting_date DATETIME,
    end_date DATETIME,
    budget FLOAT CHECK(budget >= 0),
    person_in_charge VARCHAR(40),
    office_id INT NOT NULL FOREIGN KEY REFERENCES HeadOffices(id)
);

CREATE TABLE Cities
(
    id INT PRIMARY KEY IDENTITY(1,1),
    city VARCHAR(20) NOT NULL,
    country VARCHAR(20) NOT NULL,
    inhabitant_number INT CHECK(inhabitant_number >= 0)
);

CREATE TABLE ProjectsInCities
(
    project_id INT NOT NULL
    FOREIGN KEY REFERENCES Projects(id)
    ON DELETE CASCADE,
    city_id INT NOT NULL
    FOREIGN KEY REFERENCES Cities(id)
    ON DELETE CASCADE,
    CONSTRAINT
    pk PRIMARY KEY(project_id, city_id)
);

ALTER TABLE HeadOffices
ADD CONSTRAINT fk_cities 
FOREIGN KEY (city_id) REFERENCES Cities(id)
ON DELETE CASCADE

-- 2
USE [D4-Q2]
GO

CREATE TABLE lenders
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(40) NOT NULL,
    amount_of_money FLOAT NOT NULL CHECK(amount_of_money >= 0)
);
GO

CREATE TABLE borrowers
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(40) NOT NULL,
    risk INT
);
GO

CREATE TABLE loans
(
    code INT PRIMARY KEY IDENTITY(1,1),
    amount FLOAT NOT NULL CHECK(amount >= 0),
    refund_ddl DATETIME NOT NULL,
    interest FLOAT NOT NULL CHECK(interest >= 0),
    purpose VARCHAR(100),
    borrower_id INT NOT NULL FOREIGN KEY REFERENCES borrowers(id)
)
GO

CREATE TABLE loans_under_lenders
(
    lenders_id INT NOT NULL FOREIGN KEY REFERENCES lenders(id),
    loans_code INT NOT NULL FOREIGN KEY REFERENCES loans(code)
    CONSTRAINT com_pk
    PRIMARY KEY (lenders_id, loans_code)
);
GO

-- 3
USE [D4-Q3]
GO

CREATE TABLE courses
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(20) UNIQUE NOT NULL,
    description VARCHAR(100) NOT NULL,
    photo VARCHAR(100),
    price FLOAT NOT NULL CHECK(price > 0),
    employee_id INT NOT NULL
);
GO

CREATE TABLE categories
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(20) UNIQUE NOT NULL 
);
GO

CREATE TABLE employees
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(40) NOT NULL
);
GO

ALTER TABLE courses
ADD CONSTRAINT emp_fk FOREIGN KEY (employee_id) REFERENCES employees(id)
GO

CREATE TABLE course_category
(
    category_id INT NOT NULL 
    FOREIGN KEY REFERENCES categories(id)
    ON DELETE CASCADE,
    course_id INT NOT NULL 
    FOREIGN KEY REFERENCES courses(id)
    ON DELETE CASCADE,
    CONSTRAINT com_pk
    PRIMARY KEY (category_id, course_id)
);
GO

CREATE TABLE employee_category
(
    employee_id INT NOT NULL 
    FOREIGN KEY REFERENCES employees(id)
    ON DELETE CASCADE,
    category_id INT NOT NULL 
    FOREIGN KEY REFERENCES categories(id)
    ON DELETE CASCADE,
    CONSTRAINT comp_pk
    PRIMARY KEY (employee_id, category_id)
);
GO

CREATE TABLE ingredients
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(20) UNIQUE NOT NULL,
    units VARCHAR(20) NOT NULL,
    current_amount INT NOT NULL CHECK(current_amount >= 0)
);
GO

CREATE TABLE recipies
(
    course_id INT NOT NULL,
    ingredient_id INT NOT NULL,
    required_amount INT NOT NULL CHECK(required_amount >= 0),
    CONSTRAINT composite_pk
    PRIMARY KEY(course_id, ingredient_id)
);
GO


