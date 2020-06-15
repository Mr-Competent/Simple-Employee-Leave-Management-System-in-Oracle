--Project by Mr-Competent
--creating user rohit ,granting privilege is done in sys as sysdba 
create user rohit identified by rohit300;

--granting create session to rohit
grant create session to rohit;

--granting create synonym
grant create synonym to rohit;

--granting create procedure
grant create procedure to rohit;

--creating view employee_db in scott schema
CREATE VIEW employee_db AS
SELECT * FROM employeedb WHERE empid=11130;

--creating view emp_leave_db in scott schema
CREATE VIEW emp_leave_db AS
SELECT empid,lv_from_date,lv_to_date,l_category,l_description FROM empleavedb;

--creating view detail_leave in scott schema
CREATE VIEW detail_leave AS 
SELECT * FROM detailleave WHERE empid=11130 AND lv_from_date+1>sysdate;

--creating role and assigning role to user rohit done in scott schema
create role employeerole;
grant insert on empleavedb to employeerole;
grant select on detail_leave to employeerole;
grant select on employee_db to employeerole;
grant employeerole to rohit;


--creating procedure leaveapply to insert leave application for employee id 11300 in rohit schema
CREATE PROCEDURE leaveapply(lv_from_date1 DATE,lv_to_date1 DATE,l_category1 VARCHAR2,l_description1 VARCHAR2)
 IS 
   BEGIN
     INSERT INTO scott.empleavedb (empid,lv_from_date,lv_to_date,l_category,l_description) 
		VALUES(11130,lv_from_date1,lv_to_date1,l_category1,l_description1);
       dbms_output.put_line('Leave Application Raised Successfully');
   END;
/


--creating procedure leaveapply_help to get syntax to be used in leaveapply procedure(rohit schema)
  create procedure leaveapply_help
     IS
        BEGIN
          dbms_output.put_line('----------------------------------------------------------------------');
          dbms_output.put_line('To Execute procedure leaveapply follow the syntax below:');
          dbms_output.put_line('EXECUTE leaveapply(from_date,to_date,leave_type,leave_description);');
          dbms_output.put_line('leave_type can be either C for casual or S for sick leave');
          dbms_output.put_line('use single quote in parameters from_date,to_date,leave_type,leave_description');
          dbms_output.put_line('----------------------------------------------------------------------');
  END;
   /


--revoking permission from rohit schema
revoke create synonym from rohit;

revoke create procedure from rohit;


--executing leaveapply_help to get syntax to be used in leaveapply procedure
EXECUTE leaveapply_help;

--executing leaveapply to raise leave application
EXECUTE leaveapply('18-apr-2020','19-apr-2020','C','Casual work'); --dates will not work



--exiting so that exitcommit feature work
exit


--Project by Mr-Competent
