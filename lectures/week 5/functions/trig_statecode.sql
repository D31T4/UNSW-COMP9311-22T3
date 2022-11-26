drop function checkState() cascade;

create function checkState() returns trigger as $$
declare
  v char(5);
begin
   -- check the format of new.state
   if (new.state !~ '^[A-Z][A-Z]$') then
      raise exception 'State code must be two alpha chars';
   end if;
   -- implement referential integrity check
   select into v code from States where code=new.state;
   if (not found) then
      raise exception 'Invalid state code %',new.state;
   end if;
   return new;
end;
$$ language plpgsql;

create trigger checkState before insert or update
on us_person for each row execute procedure checkState();
