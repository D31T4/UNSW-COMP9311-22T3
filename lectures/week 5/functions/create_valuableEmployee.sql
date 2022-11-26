drop function valuableEmployee(sal real);
create or replace function
   valuableEmployee(sal real) returns setof employee
as $$
declare
    e RECORD;
begin
    For e in select * from employee where salary  > sal
    loop
        return next e;
    end loop;
    return;
end;
$$ language plpgsql;
