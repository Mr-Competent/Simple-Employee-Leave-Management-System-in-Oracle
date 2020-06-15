--Project by Mr-Competent
--to show leave remaining with employee name and full table 
select * from employeedb;

--showing particular employee leave remaining
select * from employeedb where empid=11111;

--to show leave application
select * from empleavedb;

--to show detail leave application including timestamp and updated_time stamp
select * from detailleave;

--to show recent application for leave
select * from detailleave order by lv_from_date desc;
