drop function ManfBeer(_beer varchar(30));
create or replace function
    ManfBeer(_beer varchar(30)) 
returns beers as $$
declare 
    one_beer beers%ROWTYPE;
begin
    select * into one_beer from beers where name = _beer;
    return one_beer;
end;
$$ language plpgsql;
