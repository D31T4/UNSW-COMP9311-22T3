drop function beerForManf(_manf varchar(30));
create or replace function
    beerForManf(_manf varchar(30)) returns setof beers 
as $$
declare
    e beers%ROWTYPE;
begin
    For e in select * from beers where manf  = _manf
    loop
        return next e;
    end loop;
    return;
end;
$$ language plpgsql;
