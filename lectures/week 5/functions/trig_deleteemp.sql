drop function checkDelEmpSal() cascade;
create function checkDelEmpSal() returns trigger as $$
declare
  v char(5);
begin
      update department 
      set totalsal = totalsal - old.salary
      where department.id = old.dept;
      return old;
end;
$$ language plpgsql;

create trigger checkNDelEmpSal after delete 
on employee for each row execute procedure checkDelEmpSal();
