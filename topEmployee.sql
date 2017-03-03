create table topEmployees(
  employID varchar(10) primary key,
  employName varchar(30),
  voteID varchar(12),
  year int
);

create or replace function getDetails(out varchar, out varchar, out varchar, out int, out int) returns setof record as
$$
    select employID, employName, voteID, year, conTop.votes from topEmployees join conTop on employID=.conTop.employID;
$$
  language 'sql';

create or replace function getSpecDetails(in modYear INT, out varchar, out varchar, out varchar, out int, out int) returns setof record as
$$
    select employID, employName, voteID, year, conTop.votes from topEmployees join conTop on employID=.conTop.employID where year=modYear;
$$
  language 'sql';


create or replace function newTopEmployees(emp_id varchar, emp_Name varchar, emp_votersID varchar, emp_year int) returns text as
$$
  declare
    test_id text;
    re_res text;

  begin
     select into test_id id from topEmployees where year = employ_year and id=employ_id;
     if test_id isnull then

       insert into  topEmployees (employID, employName, voteID, year) values (employ_id, employ_Name, emp_votersID, emp_year);
       re_res = 'Entry Added';

     else
       re_res = 'Entry already EXISTED';
     end if;
     return re_res;
  end;
$$
 language 'plpgsql';

create or replace function updateTopEmp(emp_id VARCHAR, emp_Name VARCHAR, emp_year INT, emp_votersID VARCHAR) returns text as
 $$
   declare
     test_id text;
     re_res text;
   begin
      select into test_id id from topEmp where year = emp_year and id=emp_id;
      if test_id isnull then
        re_res = 'Entry does not EXIST';
      else
      update topEmp  set empID=emp_id, empName=emp_Name, voteID=emp_votersID, year=emp_year where empID=emp_id;
        re_res = 'Entry updated';
      end if;
      return re_res;
   end;
 $$
  language 'plpgsql';

  CREATE TABLE conTop(
    votes INT,
    empYear INT,
    empID references topEmp(empID)
  );

create or replace function conTop(emp_votes INT, emp_year INT, emp_id VARCHAR) returns text as
   $$
     declare
       test_id text;
       re_res text;
     begin
        select into test_id id from conTop where year = emp_year and id=emp_id;
        if test_id isnull then
          insert into  conTop (votes, empYear, empID) values (emp_votes, emp_year, emp_id);
          re_res = 'Entry added';
        else
          re_res = 'Entry already exist';
        end if;
        return re_res;
     end;
   $$
    language 'plpgsql';

create or replace function Add_votes(emp_votes INT, emp_year INT, emp_id VARCHAR) returns text as
$$
  update conTop set votes=votes+emp_votes where empID=emp_id and empYear=emp_year;
$$
  language 'plpgsql';

create or replace function Sub_votes(emp_votes INT, emp_year INT, emp_id VARCHAR) returns text as
$$
  update conTop set votes=votes-emp_votes where empID=emp_id and empYear=emp_year;
$$
  language 'plpgsql';

create table conEntryEach(
  year int,
  empID references topEmp(empID),
  voteID references topEmp(voteID)
);
