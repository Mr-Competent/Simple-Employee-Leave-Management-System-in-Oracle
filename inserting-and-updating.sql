--Project by Mr-Competent
--inserting values in empdb using view employeedb
insert into employeedb(empid,empname) values (11111,'KING');
insert into employeedb(empid,empname) values (11115,'KOHLI');
insert into employeedb(empid,empname) values (11120,'DHONI');
insert into employeedb(empid,empname) values (11125,'RAINA');
insert into employeedb(empid,empname) values (11130,'ROHIT');
commit;   --committing the inserted rows

--inserting values in leavedb using view empleavedb  (the following can't be inserted as dates will not be considered to make the date to be considered change corresponding dates)
insert into empleavedb(empid,lv_from_date,lv_to_date,l_category,l_description) values (11111,'8-apr-2020','9-apr-2020','C','Friend Marriage');
insert into empleavedb(empid,lv_from_date,lv_to_date,l_category,l_description) values (11115,'8-apr-2020','9-apr-2020','C','Janta Curfew');
insert into empleavedb(empid,lv_from_date,lv_to_date,l_category,l_description) values (11120,'7-apr-2020','7-apr-2020','S','Fever');
insert into empleavedb(empid,lv_from_date,lv_to_date,l_category,l_description) values (11125,'7-apr-2020','9-apr-2020','S','Operation');
insert into empleavedb(empid,lv_from_date,lv_to_date,l_category,l_description) values (11130,'10-apr-2020','10-apr-2020','C','Wedding Anniversary');
COMMIT;

--accepting the leave application
UPDATE detailleave 
  SET l_status='A' 
    WHERE empid=11130 AND 
        lv_from_date=(SELECT MIN(lv_from_date) FROM detailleave WHERE lv_from_date+1>sysdate);

--rejecting or cancelling the leave application
UPDATE detailleave 
  SET l_status='C' 
    WHERE empid=11130 AND 
      lv_from_date=(SELECT MIN(lv_from_date) FROM detailleave WHERE lv_from_date+1>sysdate);
	  
--rejecting leave for particular date	  
UPDATE detailleave 
  SET l_status='C' 
    WHERE empid=11130 AND 
      lv_from_date='18-apr-2020';
