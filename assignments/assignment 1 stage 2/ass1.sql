-- COMP9311 Assignment 1 Schema
--
-- Written by: YOUR NAME, DAY MONTH YEAR 

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

... add other domain definitions as necessary ...

-- Tables

create table People (
	... replace by attribute and constraint definitions ...
);

create table Users (
	... replace by attribute and constraint definitions ...
);

create table Groups (
	... replace by attribute and constraint definitions ...
);

create table Calendars (
	... replace by attribute and constraint definitions ...
);

create table Events (
	... replace by attribute and constraint definitions ...
);

... add other table definitions as necessary ...
