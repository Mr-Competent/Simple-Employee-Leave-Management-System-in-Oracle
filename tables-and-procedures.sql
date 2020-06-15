--EMPLOYEE LEAVE MANAGEMENT SYSTEM PROJECT
  --Project by Mr-Competent

--table created in higher privileged schema
--creating table empdb (you can take more number of columns but for simplicity i'm taking only 4)
CREATE TABLE empdb   --To manage employee list and their leave remaining 
   (id NUMBER(5) NOT NULL PRIMARY KEY CHECK(id > 9999),  --id a primary key >9999 and id <100000 
    ename VARCHAR2(30) NOT NULL,  --name of the employee
    sick_lr NUMBER(2) DEFAULT 7,  --sick leave remaining by default there will be 7 sick leave
    casual_lr NUMBER(2) DEFAULT 12);  --casual leave remaining by default there will be 12 casual leave

--creating table leavedb to manage leave applications
CREATE TABLE leavedb
   (id NUMBER(5) NOT NULL REFERENCES empdb(id) on delete cascade, --id a foreign key from empdb
    input_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   --time of raising application
    from_date DATE NOT NULL,   --leave from date
    to_date DATE NOT NULL,     --leave to date
    updated_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  --time of updation means rejection and acceptance time
    days NUMBER(2) AS (to_date - from_date + 1),  --leave days
    category VARCHAR2(1) CHECK(category IN ('C','S')),  --category whether belong to 'C' for casual or 'S' for sick 
    status VARCHAR2(1) DEFAULT 'P' CHECK(status IN ('A','P','C')), --status of application, 'P' for pending, 'A' for approved,'C' for cancelled
    description VARCHAR2(40),  --cause of leave in detail not neccessary 
   CHECK(to_date>=from_date and from_date+1>input_time and from_date+1>updated_time), --checking for input
   UNIQUE(id,from_date), --no two application will be raised on a single day
   UNIQUE(id,to_date));


--Creating trigger emp_leave for auto update 
   --of remaining leavesin empdb 
CREATE TRIGGER emp_leave
AFTER UPDATE OF status
ON leavedb
DECLARE
    r_leave leavedb%ROWTYPE;  --taking the whole row for changing from leavedb table
    r_emp    empdb%ROWTYPE;   --taking the whole row for changing from empdb table 
BEGIN
    SELECT * INTO r_leave FROM leavedb WHERE updated_time=(SELECT MAX(updated_time) FROM leavedb); --
    SELECT * INTO r_emp FROM empdb WHERE id=r_leave.id;
CASE
    WHEN r_leave.status='A' AND r_leave.category='S' THEN  --when status is accepted and leave category is sick
      r_emp.sick_lr := r_emp.sick_lr - r_leave.days;
      UPDATE empdb
        SET row=r_emp WHERE id=r_emp.id;
    WHEN r_leave.status='A' AND r_leave.category='C' THEN  --when status is accepted and leave category is casual
      r_emp.casual_lr := r_emp.casual_lr -r_leave.days;
      UPDATE empdb
        SET row=r_emp WHERE id=r_emp.id;
    WHEN r_leave.status='C' THEN  --when status is cancelled
        dbms_output.put_line('Rejected or Cancelled');
END CASE;
END;
/

--creating trigger updated_time to 
  --auto update time for accepted or rejected leave application 
CREATE TRIGGER updated_time 
BEFORE UPDATE OF status
ON leavedb
FOR EACH ROW
BEGIN
   :new.updated_time :=current_timestamp;
END;
/


--creating view to insert value in leavedb easily 
CREATE VIEW empleavedb AS
SELECT id AS empid,from_date AS lv_from_date,to_date AS lv_to_date,category AS l_category,description AS l_description FROM leavedb;


--creating view to select value in empdb 
CREATE VIEW employeedb AS
SELECT id AS empid,ename AS empname,sick_lr AS sick_l_r,casual_lr AS casual_l_r FROM empdb;


--creating view detailleave to update application 
  --and select  the whole leavedb table 
CREATE VIEW detailleave AS
SELECT id AS empid,input_time AS raised_time,from_date AS lv_from_date,to_date AS lv_to_date,updated_time AS updated_on, days AS l_days,category AS l_category,status AS l_status,description AS l_description FROM leavedb;


--creating procedure to run on first day of year 
  --to reset the value of leave remaining 
CREATE PROCEDURE yearchange
 IS 
   BEGIN
     UPDATE employeedb
        SET sick_l_r=7 , casual_l_r=12;
     dbms_output.put_line('Default Set Successfully');
   END;
/


--executing command for procedure yearchange --use it with precautions --use it when year changes
EXECUTE yearchange;
