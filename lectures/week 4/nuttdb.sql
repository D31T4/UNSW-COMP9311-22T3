-- Prof. Werner Nutt example database
-- I've create these toy tables from the lecture notes so that
-- you can try some of the queries from the lecture notes yourself
-- Feel free to change and experiment with these.
-- Regards, Helen

create table Staff (
	lecturer      varchar(10),
	roomno        varchar(30),
	appraiser     varchar(10),
	primary key (lecturer),
	foreign key (appraiser) references Staff(lecturer)
);

insert into Staff values ('barringer','2.125',null);
insert into Staff values ('watson','IT212','barringer');
insert into Staff values ('capon','A14','watson');
insert into Staff values ('kahn','IT206','watson');
insert into Staff values ('bush','2.26','capon');
insert into Staff values ('goble','2.82','capon');
insert into Staff values ('zobel','2.34','watson');
insert into Staff values ('woods','IT204','barringer');
insert into Staff values ('lindsey','2.10','woods');


-- Table of data about students

create table Students (
	stuno       varchar(10),
	name        varchar(30),
	hons        varchar(10),
	tutor       varchar(10),
    year        integer,
	primary key (stuno),
	foreign key (tutor) references Staff(lecturer)
);

insert into Students values ('s1','jones','ac','bush', 2);
insert into Students values ('s2','brown','is','kahn', 2);
insert into Students values ('s3','smith','cs','goble', 2);
insert into Students values ('s4','bloggs','ca','goble', 1);
insert into Students values ('s5','jones','cs','zobel', 1);
insert into Students values ('s6','peters','ac','kahn', 3);
insert into Students values ('s7','peters','mi','kahn', 2);


-- Table of data about Teach

create table Teach (
	courseno    varchar(10),
	lecturer    varchar(10),
	primary key (courseno,lecturer),
	foreign key (lecturer) references Staff(lecturer)
);

insert into Teach values ('cs250','lindsey');
insert into Teach values ('cs250','capon');
insert into Teach values ('cs260','kahn');
insert into Teach values ('cs260','bush');
insert into Teach values ('cs270','zobel');
insert into Teach values ('cs270','woods');
insert into Teach values ('cs280','capon');


-- Table of data about Enrol

create table Enrol (
    stuno       varchar(10),
	courseno    varchar(10),
	labmark    integer,
    exammark    integer,
	primary key (stuno, courseno),
	foreign key (stuno) references Students(stuno)
);


insert into Enrol values ('s1', 'cs250', 65, 52);
insert into Enrol values ('s1', 'cs260', 80, 75);
insert into Enrol values ('s1', 'cs270', 47, 34);
insert into Enrol values ('s2', 'cs250', 67, 55);
insert into Enrol values ('s2', 'cs270', 65, 71);
insert into Enrol values ('s3', 'cs270', 49, 50);
insert into Enrol values ('s4', 'cs250', 50, 51);
insert into Enrol values ('s5', 'cs250', 0, 3);
insert into Enrol values ('s6', 'cs250', 2, 7);

-- School

create table Schools (
    hons       varchar(10),
	faculty    varchar(30),
	primary key (hons)
);

insert into Schools values ('ac', 'accountancy');
insert into Schools values ('is', 'information systems');
insert into Schools values ('cs', 'computer science');
insert into Schools values ('ce', 'computer engineering');
insert into Schools values ('mi', 'medicine');
insert into Schools values ('ma', 'mathematics');

create table CS_Student (
    studno       varchar(10),
	name    varchar(30),
    year    integer,
	primary key (studno)
);

insert into CS_Student values ('s1', 'Egger', 5);
insert into CS_Student values ('s3', 'Rossi', 4);
insert into CS_Student values ('s4', 'Maurer', 2);

create table Master_Student (
    studno       varchar(10),
	name    varchar(30),
    year    integer,
	primary key (studno)
);


insert into Master_Student values ('s1', 'Egger', 5);
insert into Master_Student values ('s2', 'Neri', 5);
insert into Master_Student values ('s3', 'Rossi', 4);

create table Person (
    name    varchar(10),
	age    integer,
    income    integer,
	primary key (name)
);

insert into Person values ('Andy', 27, 21);
insert into Person values ('Rob', 25, 15);
insert into Person values ('Mary', 55, 42);
insert into Person values ('Anne', 50, 35);
insert into Person values ('Phil', 26, 30);
insert into Person values ('Greg', 50, 40);
insert into Person values ('Frank', 60, 20);
insert into Person values ('Kim', 30, 41);
insert into Person values ('Mike', 85, 21);
insert into Person values ('Lisa', 75, 87);

create table MotherChild (
    mother  varchar(10),
    child varchar(10)
);

insert into MotherChild values ('Lisa','Mary');
insert into MotherChild values ('Lisa','Greg');
insert into MotherChild values ('Anne', 'Kim');
insert into MotherChild values ('Anne', 'Phil');
insert into MotherChild values ('Mary', 'Andy');
insert into MotherChild values ('Mary', 'Rob');

create table FatherChild (
    father  varchar(10),
    child varchar(10)
);

insert into FatherChild values ('Steve','Frank');
insert into FatherChild values ('Greg','Kim');
insert into FatherChild values ('Greg', 'Phil');
insert into FatherChild values ('Frank','Andy');
insert into FatherChild values ('Frank', 'Rob');
