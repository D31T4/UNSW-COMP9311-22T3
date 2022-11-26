drop type EmpInfo cascade;
create type EmpInfo as (
    name varchar(50),
    pay integer
);

drop function valuableEmployeeType(sal real);
create or replace function
   valuableEmployeeType(sal real) returns setof EmpInfo
as $$
declare
    e RECORD;
    inf EmpInfo%ROWTYPE;
begin
    For e in select * from employee where salary  > sal
    loop
        inf.name := e.name;
        inf.pay := e.salary;
        return next inf;
    end loop;
    return;
end;
$$ language plpgsql;
