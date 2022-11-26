drop function fbeerforManf(_manf varchar(30));
create or replace function
    fbeerForManf(varchar(30)) returns setof beers
as $$
    select * from beers where manf  = $1;
$$ language sql;
