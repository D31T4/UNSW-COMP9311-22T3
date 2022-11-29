-- COMP9311 Assignment 1 Schema
--
-- Written by: Chin Pok Leung, 07 10 2022 

-- Domains

-- Calendar access levels

create domain AccessLevel as text
	check (value in ('no-access','blocks-only','read-only','read-write'));

-- Email addresses are strings with a particular structure
-- * this regexp is approximate, but adequate for this assignment
-- * search on Google for "regular expression email address" for others
-- * \w represents that character class containing alphanumerics + underscore

create domain EmailAddress as text
	check (value ~ E'[a-zA-Z][\\w.-]*[\\w]?@[a-zA-Z][\\w-]*(\\.[a-zA-Z][\\w-]*)*');

create domain UnswId as varchar(8)
	check (value ~ '^[zZ][0-9]{7}$');

-- ... add other domain definitions as necessary ...

-- Tables

create table People (
	Email EmailAddress 	unique 
						not null,
	Name 				varchar(70)
						not null,
	primary key (Email)
);

create table Users (
	People 			EmailAddress,
	Username 		varchar(30) 
					unique 
					not null,
	Password 		varchar(20) 
					not null,
	UNSWid UnswId 	unique 
					not null,
	isActive 		boolean 
					not null 
					default false,
	primary key (People),
	foreign key (People) references People(Email) on delete cascade
);

create table Groups (
	GroupID 		serial 
					unique 
					not null,
	Name 			varchar(100)
					not null,
	Owner 			EmailAddress 
					not null,
	primary key (GroupID),
	foreign key (Owner) references Users(People) on delete set null
);

create table Calendars (
	CalenID 		serial 
					unique 
					not null,
	Name 			varchar(100)
					not null,
	DefaultAccess 	AccessLevel 
					not null,
	Owner			EmailAddress
					not null,
	primary key (CalenID),
	foreign key (Owner) references Users(People) on delete cascade
);

create table Events (
	eventID 	serial 
				unique 
				not null,
	title 		text
				not null,
	location 	text
				not null,
	notes 		text
				not null,
	Owner 		EmailAddress 
				not null,
	startTime 	time,
	endTime 	time,
	onDate		date,
	startDate	date,
	endDate		date,
	frequency 	integer,
	dayOfwk		varchar(3)
				check (dayOfWk in (NULL, 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun')),
	month		varchar(3)
				check (month in (NULL, 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dev')),
	dayOfMon	integer
				check (1 <= dayOfMon and dayOfMon <= 31),
	timeType	text
				not null
				check (timeType in ('OneDay', 'Deadline', 'Timeslot')),
	dateType 	text
				not null
				check (dateType in ('OneOff', 'Timespan')),
	isRecurring	boolean
				not null,
	primary key (eventID),
	foreign key (Owner) references Users(People) on delete cascade
);

-- ... add other table definitions as necessary ...
create table PeopleMemberOfGroups (
	People 	EmailAddress 
			not null,
	Groups  serial 
			not null,
	primary key (People, Groups),
	foreign key (People) references People(Email) on delete cascade,
	foreign key (Groups) references Groups(GroupID) on delete cascade
);

create table PeopleInvitedToEvents (
	Events  serial 
			not null,
	People 	EmailAddress 
			not null,
	RSVP 	varchar(3) 
			default NULL
			check (RSVP in (NULL, 'Yes', 'No')),
	primary key (Events, People),
	foreign key (People) references People(Email) on delete cascade,
	foreign key (Events) references Events(eventID) on delete cascade
);

create table CalendarsVisibleToUsers (
	Calendars   serial
			    not null,
	Users 		EmailAddress
		 	    not null,
	primary key (Calendars, Users),
	foreign key (Calendars) references Calendars(CalenID) on delete cascade,
	foreign key (Users) references Users(People) on delete cascade
);

create table UserAccessToCalendars (
	Calendars 	serial 
				not null,
	Users 		EmailAddress 
				not null,
	AccessLevel AccessLevel 
				not null,
	primary key (Calendars, Users),
	foreign key (Calendars) references Calendars(CalenID) on delete cascade,
	foreign key (Users) references Users(People) on delete cascade
);

create table GroupsAccessToCalendars (
	Calendars 	serial 
				not null,
	Groups		serial 
				not null,
	AccessLevel AccessLevel
				not null,
	primary key (Calendars, Groups),
	foreign key (Calendars) references Calendars(CalenID) on delete cascade,
	foreign key (Groups) references Groups(GroupID) on delete cascade
);

create table EventsAlarms (
	Events  serial
			not null,
	diff 	interval
			not null,
	primary key (Events, Diff),
	foreign key (Events) references Events(eventID) on delete cascade
);

create table EventsExceptions (
	eventID 	serial
				not null,
	exception 	date,
	primary key (eventID, exception),
	foreign key (eventID) references Events(eventID) on delete cascade
);
