drop aggregate concatstr (text);
drop function AddStrName (_t1 text, _t2 text) cascade;

create or replace function
    AddStrName (_t1 text, _t2 text) returns text
as $$
begin 

    return _t1||','||_t2;

end;
$$ language plpgsql;

create or replace function
    finalReturnName(_t1 text) returns text
as $$
begin
return substr(_t1,2);
end;
$$ language plpgsql;

create aggregate concatstr (text) (
    stype     = text,
    initcond  = '', 
    sfunc     = AddStrName,
    finalfunc     = finalReturnName
);
