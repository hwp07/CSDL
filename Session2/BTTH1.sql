CREATE TABLE Persons (
    personId INT NOT NULL,
    lastName VARCHAR(255) NOT NULL,
    firstName VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    address VARCHAR(255),
    city VARCHAR(255),
    
    CONSTRAINT pk_person PRIMARY KEY (personId)
);

CREATE TABLE hobbies (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    personId INT,
    
    CONSTRAINT chk_name_length CHECK (LENGTH(name) > 4),
    
    CONSTRAINT fk_person_hobby
        FOREIGN KEY (personId)
        REFERENCES Persons(personId)
);