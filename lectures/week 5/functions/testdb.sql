drop table AGGR;
create table AGGR (first integer, second integer);
insert into AGGR values (1,2);
insert into AGGR values (3,4);
insert into AGGR values (5,6);
insert into AGGR values (7,8);
insert into AGGR values (9,10);


drop table Department cascade;
create table Department (
    id          integer,
	name        varchar(30),
	manager     varchar(10),
    totalSal    float,
	primary key (id)
);

insert into Department values (1, 'Marketing', 'jas', 30000);
insert into Department values (2, 'IT', 'amy', 50000);

drop table Employee cascade;
create table Employee (
	userid      varchar(10),
	name        varchar(30),
	address    varchar(20),
	dept       integer references Department(id),
    salary      float,
	primary key (userid)
);

insert into Employee values ('jingling','Jingling Xue','Randwick',1, 10000);
insert into Employee values ('jas','John Shepherd','Kensington',2, 20000);
insert into Employee values ('andrewt','Andrew Taylor','Kensington',2, 10000);
insert into Employee values ('barty','Elsa Barty','Kingsford',1, 20000);
insert into Employee values ('amy','Amy Jones','Randwick',2, 20000);


drop table us_person;
create table us_person (name varchar(10), town varchar(20), state char(2));
insert into us_person values ('Dave', 'Beaconsfield', 'CA');
insert into us_person values ('Sarah', 'Houston', 'TX');
insert into us_person values ('Sue', 'Portland', 'OR');

drop table states;
create table states (name varchar(20), code char(2));
insert into states values ('California', 'CA');
insert into states values ('Texas', 'TX');
insert into states values ('Oregon', 'OR');

