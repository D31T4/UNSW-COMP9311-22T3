create or replace function add (x int, y int) returns int
as $add$
declare
    sum integer;
begin
    sum := x + y;
    return sum;
end;
$add$ language plpgsql;
