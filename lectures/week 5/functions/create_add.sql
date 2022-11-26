create or replace function
    add (x text, y text) returns text
as $$
declare
    result text;
begin
    result := x||''''||y;
    return result;
end;
$$ language plpgsql;

