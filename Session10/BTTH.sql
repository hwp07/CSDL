-- Active: 1777294904821@@127.0.0.1@3306@er
CREATE DATABASE ER;

USE ER;

CREATE TABLE Patients (
    Patient_ID VARCHAR(5) PRIMARY KEY,
    Full_Name VARCHAR(100) NOT NULL,
    Admission_Time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Vitals_Logs (
    Log_ID INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID VARCHAR(5),
    Heart_Rate INT CHECK (Heart_Rate > 0),
    Blood_Pressure VARCHAR(10),
    Record_Time DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID)
);

INSERT INTO Patients (Patient_ID, Full_Name) 
VALUES
('P001', 'Nguyen Van A'),
('P002', 'Tran Thi B'),
('P003', 'Le Van C');

INSERT INTO Vitals_Logs (Patient_ID, Heart_Rate, Blood_Pressure) 
VALUES
('P001', 72, '120/80'),
('P001', 75, '118/79'),
('P002', 90, '130/85'),
('P002', 88, '128/84'),
('P003', 65, '110/70');

CREATE INDEX idx_patient_time
ON Vitals_Logs (Patient_ID, Record_Time);

CREATE VIEW ER_Dashboard_View AS
SELECT p.Patient_ID, p.Full_Name, p.Admission_Time,

    IFNULL(v.Heart_Rate, 'Pending') AS Heart_Rate,
    v.Blood_Pressure,
    v.Record_Time,

    CASE 
        WHEN v.Heart_Rate > 120 OR v.Heart_Rate < 50 THEN 'CRITICAL'
        WHEN v.Heart_Rate IS NULL THEN 'PENDING'
        ELSE 'STABLE'
    END AS Urgency_Level

FROM Patients p
LEFT JOIN Vitals_Logs v 
    ON p.Patient_ID = v.Patient_ID;

SELECT * FROM ER_Dashboard_View;