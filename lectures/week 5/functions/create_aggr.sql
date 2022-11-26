drop aggregate sum2 (int, int);
drop function AddPair(sum int, _x int, _y int);

create function
    AddPair(sum int, _x int, _y int) returns int
as $$
begin return _x+_y+sum; end;
$$ language plpgsql;

create aggregate sum2 (int, int) (
    stype     = int,
    initcond  = 0,
    sfunc     = AddPair
);
