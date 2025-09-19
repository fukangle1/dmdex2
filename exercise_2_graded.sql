/* Create a table medication_stock in your Smart Old Age Home database. The table must have the following attributes:
 1. medication_id (integer, primary key)
 2. medication_name (varchar, not null)
 3. quantity (integer, not null)
 Insert some values into the medication_stock table. 
 Practice SQL with the following:
 */

CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    specialization TEXT NOT NULL
);

INSERT INTO doctors (name, specialization) VALUES
('Dr. Smith', 'Geriatrics'),
('Dr. Johnson', 'Cardiology'),
('Dr. Lee', 'Neurology'),
('Dr. Patel', 'Endocrinology'),
('Dr. Adams', 'General Medicine');

CREATE TABLE nurses (
    nurse_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    shift TEXT NOT NULL
);

INSERT INTO nurses (name, shift) VALUES
('Nurse Ann', 'Morning'),
('Nurse Ben', 'Evening'),
('Nurse Eva', 'Night'),
('Nurse Kim', 'Morning'),
('Nurse Omar', 'Evening');

CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    age INT NOT NULL,
    room_no INT NOT NULL,
    doctor_id INT REFERENCES doctors(doctor_id)
);

INSERT INTO patients (name, age, room_no, doctor_id) VALUES
('Alice', 82, 101, 1),
('Bob', 79, 102, 2),
('Carol', 85, 103, 1),
('David', 88, 104, 3),
('Ella', 77, 105, 2),
('Frank', 91, 106, 4);

CREATE TABLE treatments (
    treatment_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    nurse_id INT REFERENCES nurses(nurse_id),
    treatment_type TEXT NOT NULL,
    treatment_time TIMESTAMP NOT NULL
);

INSERT INTO treatments (patient_id, nurse_id, treatment_type, treatment_time) VALUES
(1, 1, 'Physiotherapy', '2025-09-10 09:00:00'),
(2, 2, 'Medication', '2025-09-10 18:00:00'),
(1, 3, 'Medication', '2025-09-11 21:00:00'),
(3, 1, 'Checkup', '2025-09-12 10:00:00'),
(4, 2, 'Physiotherapy', '2025-09-12 17:00:00'),
(5, 5, 'Medication', '2025-09-12 18:00:00'),
(6, 4, 'Physiotherapy', '2025-09-13 09:00:00');

CREATE TABLE sensors (
    sensor_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    sensor_type TEXT NOT NULL,
    reading NUMERIC NOT NULL,
    reading_time TIMESTAMP NOT NULL
);

INSERT INTO sensors (patient_id, sensor_type, reading, reading_time) VALUES
(1, 'Heart Rate', 72, '2025-09-19 08:30:00'),
(1, 'Steps', 1250, '2025-09-19 08:30:00'),
(2, 'Heart Rate', 68, '2025-09-19 09:15:00'),
(3, 'Blood Pressure', 125, '2025-09-19 10:00:00'),
(4, 'Steps', 850, '2025-09-19 11:30:00'),
(5, 'Heart Rate', 75, '2025-09-19 12:45:00');

CREATE TABLE medication_stock (
    medication_id SERIAL PRIMARY KEY,
    medication_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL
);

INSERT INTO medication_stock (medication_name, quantity) VALUES
('Aspirin', 100),
('Metformin', 75),
('Lisinopril', 50),
('Atorvastatin', 60),
('Warfarin', 40);

 -- Q!: List all patients name and ages 
SELECT name, age FROM patients;

 -- Q2: List all doctors specializing in 'Cardiology'
SELECT * FROM doctors WHERE specialization = 'Cardiology';

 
 -- Q3: Find all patients that are older than 80
SELECT * FROM patients WHERE age > 80;



-- Q4: List all the patients ordered by their age (youngest first)
SELECT * FROM patients ORDER BY age ASC;




-- Q5: Count the number of doctors in each specialization
SELECT specialization, COUNT(*) as doctor_count 
FROM doctors 
GROUP BY specialization;



-- Q6: List patients and their doctors' names
SELECT p.name AS patient_name, d.name AS doctor_name
FROM patients p
JOIN doctors d ON p.doctor_id = d.doctor_id;



-- Q7: Show treatments along with patient names and doctor names
SELECT t.treatment_type, t.treatment_time, 
       p.name AS patient_name, 
       d.name AS doctor_name
FROM treatments t
JOIN patients p ON t.patient_id = p.patient_id
JOIN doctors d ON p.doctor_id = d.doctor_id;


-- Q8: Count how many patients each doctor supervises
SELECT d.name as doctor_name, 
       COUNT(p.patient_id) as patient_count
FROM doctors d
LEFT JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name
ORDER BY patient_count DESC;


-- Q9: List the average age of patients and display it as average_age
SELECT AVG(age) as average_age FROM patients;



-- Q10: Find the most common treatment type, and display only that
SELECT treatment_type, COUNT(*) as count
FROM treatments
GROUP BY treatment_type
ORDER BY count DESC
LIMIT 1;


-- Q11: List patients who are older than the average age of all patients
SELECT name, age
FROM patients
WHERE age > (SELECT AVG(age) FROM patients);


-- Q12: List all the doctors who have more than 5 patients
SELECT d.name as doctor_name, 
       COUNT(p.patient_id) as patient_count
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name
HAVING COUNT(p.patient_id) > 5;



-- Q13: List all the treatments that are provided by nurses that work in the morning shift. List patient name as well. 
SELECT t.treatment_type, t.treatment_time, 
       p.name as patient_name, 
       n.name as nurse_name
FROM treatments t
JOIN patients p ON t.patient_id = p.patient_id
JOIN nurses n ON t.nurse_id = n.nurse_id
WHERE n.shift = 'Morning';



-- Q14: Find the latest treatment for each patient
SELECT p.name as patient_name, 
       t.treatment_type, 
       MAX(t.treatment_time) as latest_treatment
FROM patients p
LEFT JOIN treatments t ON p.patient_id = t.patient_id
GROUP BY p.name, t.treatment_type
ORDER BY p.name;


-- Q15: List all the doctors and average age of their patients
SELECT d.name as doctor_name, 
       AVG(p.age) as average_patient_age
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name;



-- Q16: List the names of the doctors who supervise more than 3 patients
SELECT d.name as doctor_name, 
       COUNT(p.patient_id) as patient_count
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name
HAVING COUNT(p.patient_id) > 3;



-- Q17: List all the patients who have not received any treatments (HINT: Use NOT IN)
SELECT p.name as patient_name
FROM patients p
WHERE p.patient_id NOT IN (SELECT DISTINCT patient_id FROM treatments);




-- Q18: List all the medicines whose stock (quantity) is less than the average stock
SELECT medication_name, quantity
FROM medication_stock
WHERE quantity < (SELECT AVG(quantity) FROM medication_stock);




-- Q19: For each doctor, rank their patients by age
SELECT d.name AS doctor_name, 
       p.name AS patient_name, 
       p.age AS age,
       RANK() OVER (PARTITION BY d.doctor_id ORDER BY p.age ASC) AS age_rank
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
ORDER BY d.name, age_rank;


-- Q20: For each specialization, find the doctor with the oldest patient
WITH DoctorPatientAges AS (
    SELECT d.specialization,
           d.name as doctor_name,
           MAX(p.age) as max_patient_age
    FROM doctors d
    JOIN patients p ON d.doctor_id = p.doctor_id
    GROUP BY d.specialization, d.name
),
RankedDoctors AS (
    SELECT specialization,
           doctor_name,
           max_patient_age,
           RANK() OVER (PARTITION BY specialization ORDER BY max_patient_age DESC) as rank
    FROM DoctorPatientAges
)
SELECT specialization, doctor_name, max_patient_age
FROM RankedDoctors
WHERE rank = 1;
