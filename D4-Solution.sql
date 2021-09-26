CREATE TABLE HeadOffices
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(45) NOT NULL,
    address VARCHAR(100),
    phone_number VARCHAR(20) NOT NULL,
    director VARCHAR(40),
    city_id INT NOT NULL,
    CONSTRAINT fk_cities FOREIGN KEY (city_id)
    REFERENCES Cities(id),
);

CREATE TABLE Projects
(
    id INT PRIMARY KEY IDENTITY(1,1),
    project_code INT NOT NULL,
    project_title VARCHAR(40),
    starting_date DATETIME,
    end_date DATETIME,
    budget FLOAT,
    person_in_charge VARCHAR(40),
    office_id INT NOT NULL
    FOREIGN KEY Headoffices(id)
);

CREATE TABLE Cities
(
    id INT PRIMARY KEY IDENTITY(1,1),
    city VARCHAR(20) NOT NULL,
    country VARCHAR(20) NOT NULL,
    inhabitant_number INT
);

CREATE TABLE ProjectsInCities
(
    project_id INT NOT NULL
    FOREIGN KEY REFERENCES Projects.id,
    city_id INT NOT NULL
    FOREIGN KEY REFERENCES Cities.id,
    CONSTRAINT
    pk PRIMARY KEY(project_id, city_id)
);