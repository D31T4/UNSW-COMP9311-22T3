drop function checkUpdEmpSal() cascade;
create function checkUpdEmpSal() returns trigger as $$
declare
  v char(5);
begin
    if new.dept <> old.dept then -- moving department
      update department 
      set totalsal = totalsal + new.salary
      where department.id = new.dept;
      update department 
      set totalsal = totalsal - new.salary
      where department.id = old.dept;
    elsif (new.dept = old.dept) and  (new.salary <> old.salary) then
      update department 
      set totalsal = totalsal + new.salary - old.salary
      where department.id = new.dept;
    end if;
    return new;
end;
$$ language plpgsql;

create trigger checkNUpdEmpSal after update 
on employee for each row execute procedure checkUpdEmpSal();
