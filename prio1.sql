create table employees(
    id int8 primary key,
    name text,
    vote_id int,
    emp_yr int;
);

create or replace function topemployee(par_id int8, par_title text, par_vote_id int, par_emp_yr int) returns text as
$$
    declare
        loc_id text;
        loc_res text;
    begin
        select into loc_id id from employees where id = par_id;
        if loc_id isnull then

            insert into employees(id, name, vote_id, emp_yr) values (par_id, par_name, par_vote_id, par_emp_yr);
            loc_res= "SUCCESS";
        else
            loc_res= "ALREADY EXISTED";
        end if;
        return loc_res;
    end;
$$
 language 'plpgsql';

create or replace function updatetop(par_id int, par_name text, par_vote_id int, par_emp_yr boolean) returns text as
$$
   declare
    loc_id text;
    loc_res text;
   begin
    select into loc_id id from employees where id = par_id;
    if loc_id isnull then

        loc_res= 'DOES NOT EXIST.';
    else
        update employees set id=par_id, name=par_name, vote_id=par_vote_id, emp_yr=par_emp_yr;
        loc_res= 'SUCCESS';
    end if;
        return loc_res;
   end;
$$
 language 'plpgsql';

create table employee_votes(
    votes int;
    year int;
    id references employees(id)
);

create or replace function employee_votes(par_votes int, par_year int, id int8) returns text as
$$
    declare
        loc_id text;
        loc_res text;
    begin
        select into loc_id id from employee_votes where id = par_id;
        if loc_id isnull then
            insert into employees(id, name, vote_id, emp_yr) values (par_id, par_name, par_vote_id, par_emp_yr);
            loc_res= "SUCCESS";
        else
            loc_res= 'ALREADY EXISTED';
        end if;
            return loc_res;
    end;
$$
    language 'plpgsql';

create or replace function addvote(par_votes int, par_year int, par_id int8) returns text as
$$
  update employee_votes set votes=votes+emp_votes where id=par_id and emp_yr=par_emp_yr;
$$
  language 'plpgsql';

-- continueeeeeeee!!!!

create or replace function subvote(par_votes int, emp_year INT, emp_id VARCHAR) returns text as
$$
  update conTop set votes=votes-emp_votes where empID=emp_id and empYear=emp_year;
$$
  language 'plpgsql';

create table conEntryEach(
  year int,
  empID references topEmp(empID),
  voteID references topEmp(voteID)
);