drop function checkNewEmpSal() cascade;
create function checkNewEmpSal() returns trigger as $$
begin
    update department 
    set totalsal = totalsal + new.salary
    where department.id = new.dept;
    return new;
end;
$$ language plpgsql;

create trigger checkNewEmpSal after insert 
on employee for each row execute procedure checkNewEmpSal();
