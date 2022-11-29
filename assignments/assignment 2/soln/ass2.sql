-- COMP9311 Assignment 2
-- Written by Chin Pok LEUNG

-- Q1_a: get details of the current Heads of Schools

create or replace view Q1_a(name, school, starting)
as
	select people.name, orgunits.longname, affiliation.starting 
	from staffroles, affiliation, orgunits, orgunittypes, people
	where 
		staffroles.description = 'Head of School' and
		orgunittypes.name = 'School' and
		affiliation.role = staffroles.id and
		affiliation.isprimary = true and
		orgunits.id = affiliation.orgunit and
		orgunits.utype = orgunittypes.id and
		affiliation.staff = people.id and 
		affiliation.ending is null
;

-- Q1_b: longest-serving and most-recent current Heads of Schools

create or replace view Q1_b(status, name, school, starting)
as
	(select 'Longest serving'::text, name, school, starting
		from Q1_a where starting = (select min(starting) from Q1_a))
	union
	(select 'Most recent'::text, name, school, starting
		from Q1_a where starting = (select max(starting) from Q1_a))
;

-- Q2: the subjects that used the Central Lecture Block the most 

-- count of using CLB lecture theatres between 2007 and 2009
create or replace view Q2_clb(subject_code, use_rate) as
	select subjects.code, count(A.subject)
	from 
		subjects left outer join
			(
				select courses.subject as subject 
				from rooms, classes, courses, terms
				where
					rooms.name ~ '^CLB' and
					classes.room = rooms.id and
					classes.course = courses.id and
					courses.term = terms.id and
					terms.year between 2007 and 2009
			) as A
		on subjects.id = A.subject
	group by
		subjects.code
;

create or replace view Q2(subject_code, use_rate)
as
	select *
	from Q2_clb as stats
	where stats.use_rate >= (select max(use_rate) from Q2_clb)
;

-- Q3: all the students who has scored HD no less than 30 time

create or replace view Q3(unsw_id, student_name)
as
	select people.unswid, people.name
	from
		(
			select courseenrolments.student as id
			from courseenrolments
			where
				courseenrolments.grade = 'HD'
			group by courseenrolments.student
			having count(*) > 30
		) as S
		join people on S.id = people.id
;

-- Q4: max fail rate

-- courses in 2007 having >50 people pass
create or replace view Q4_validcourse(id)
as
	select E.course
	from courseenrolments E, courses C, terms T
	where
		E.course = C.id and
		C.term = T.id and
		E.mark is not null and
		E.mark >= 50 and 
		T.year = 2007
	group by E.course
	having count(*) > 50
;

-- fail rate of valid courses in 2007
create or replace view Q4_failrate(course_id, failrate)
as
	select 
		course, 
		(count(*) - count(*) filter (where mark >= 50))::float / count(*)
	from courseenrolments
	where
		mark is not null and
		course in (select id from Q4_validcourse)
	group by course
;

create or replace view Q4(course_id)
as
	select course_id
	from Q4_failrate
	where failrate >= (select max(failrate) from Q4_failrate)
;

-- Q5: total FTE students per term from 2001 S1 to 2010 S2

create or replace view Q5(term, nstudes, fte)
as
	select termname(T.id), count(distinct E.student), (sum(S.uoc)::float / 24)::numeric(6, 1)
	from terms T, courses C, courseenrolments E, subjects S
	where
		T.year between 2000 and 2010 and
		T.sess = any(array['S1', 'S2']) and
		C.term = T.id and
		C.subject = S.id and
		C.id = E.course
	group by T.id
;

-- Q6: subjects with > 30 course offerings and no staff recorded

create or replace view Q6(subject, nOfferings)
as
	select S.code || ' ' || S.name, count(*)
	from
		subjects S, courses C
	where
		S.id = C.subject and
		-- filter courses with staff
		not exists (
			select *
			from
				courses C join coursestaff CS on C.id = CS.course
			where S.id = C.subject
		)
	group by
		S.id, S.code, S.name
	having
		count(*) > 30
;

-- Q7:  which rooms have a given facility

create or replace function
	Q7(text) returns setof FacilityRecord
as $$
	select R.longname as room, F.description as facility
	from
		-- match facilities
		(
			select *
			from facilities
			where position(upper($1) in upper(description)) > 0
		) as F,
		roomfacilities RF,
		rooms R
	where
		R.id = RF.room and 
		RF.facility = F.id
$$ language sql
;

-- Q8: semester containing a particular day

create or replace function Q8(_day date) returns text 
as $$
declare
	-- left bound. ending date of previous sem
	lbound 		date 	:= null;
	-- right bound. starting date of next sem
	rbound 		date 	:= null;

	-- effective left bound
	eff_lbound	date 	:= null;
	-- effective right bound
	eff_rbound 	date 	:= null;

	-- term id
	tid			integer := null;
begin
	select id into tid 
	from terms 
	where _day between starting and ending;
	
	if tid is null then
		select max(ending) into lbound 
		from terms 
		where ending < _day;
		
		select min(starting) into rbound 
		from terms 
		where starting > _day;

		if lbound is not null and rbound is not null then
			eff_lbound := lbound;
			eff_rbound := rbound;

			if rbound - lbound <= 7 then
				-- extend rbound until lbound
				eff_rbound := lbound + 1;
			else
				-- extend rbound to 1 week before
				eff_rbound := eff_rbound - 7;
				-- extend lbound until rbound
				eff_lbound := eff_rbound - 1;
			end if;

			if _day >= eff_rbound then
				select id into tid
				from terms
				where starting = rbound;
			else
				select id into tid
				from terms
				where ending = lbound;
			end if;
		end if;
	end if;

	if tid is not null then
		return termname(tid);
	else
		return null;
	end if;
end;
$$ language plpgsql
;

-- Q9: transcript with variations

create or replace function
	q9(_sid integer) returns setof TranscriptRecord
as $$
declare
	tr TranscriptRecord;
	-- variation record
	vr record;

	-- institution for external subjects
	ext_it text;
	-- equivalent internal subject code
	eq_code text;

	-- weighted mark sum
	wsum integer := 0;
	-- uoc from enrolled courses with mark
	uoc_total integer := 0;
	-- uoc taken
	uoc_passed integer := 0;

	-- internal student id
	stid integer := null;
begin
	select students.id into stid
	from students, people
	where 
		students.id = people.id and
		people.unswid = _sid;

	if not found then
		raise exception 'Invalid student %', _sid;
	end if;

	-- logic for calculating uoc, wam from enrolled courses is same as function transcript
	for tr in
		select s.code, termname(t.id), s.name, e.mark, e.grade, s.uoc
		from courseenrolments e, courses c, subjects s, terms t
		where
			e.student = stid and
			e.course = c.id and
			c.subject = s.id and
			c.term = t.id
		order by t.starting, s.code
	loop
		if tr.grade = 'SY' then
			uoc_passed := uoc_passed + tr.uoc;
		elsif tr.mark is not null then
			if tr.grade in ('PT', 'PC', 'PS', 'CR', 'DN', 'HD') then
				-- only counts towards creditted uoc if they passed the course
				uoc_passed := uoc_passed + tr.uoc;
			end if;

			-- we count fail towards the WAM calculation
			uoc_total := uoc_total + tr.uoc;

			-- weighted sum based on mark and uoc for course
			wsum := wsum + tr.mark * tr.uoc;
		end if;

		return next tr;
	end loop;

	-- logic for handling variations
	for vr in
		select v.intequiv, v.extequiv, v.vtype, s.code, s.uoc
		from variations v, subjects s
		where
			v.student = stid and
			v.subject = s.id
		order by s.code
	loop
		-- 1st tuple
		tr := (vr.code, null, null, null, null, null);

		if vr.vtype = 'substitution' then
			tr.name := 'Substitution, based on ...';
		elsif vr.vtype = 'advstanding' then
			tr.name := 'Advanced standing, based on ...';
			tr.uoc := vr.uoc;
			uoc_passed := uoc_passed + vr.uoc;
		elsif vr.vtype = 'exemption' then
			tr.name := 'Exemption, based on ...';
		else
			raise exception 'Unrecognized vtype';
		end if;

		return next tr;

		-- 2nd tuple: reason for the variation
		tr := (null, null, null, null, null, null);

		if vr.intequiv is null and vr.extequiv is not null then
			-- find institution
			select institution into ext_it
			from externalsubjects
			where id = vr.extequiv;

			if not found then
				raise exception 'Invalid subject reference at Variations';
			end if;

			tr.name := format('study at %s', ext_it);
		elsif vr.intequiv is not null and vr.extequiv is null then
			-- find equivalent subject
			select code into eq_code
			from subjects
			where id = vr.intequiv;

			if not found then
				raise exception 'Invalid subject reference at Variations';
			end if;

			tr.name := format('studying %s at UNSW', eq_code);
		else
			raise exception 'Invalid subject reference at Variations';
		end if;

		return next tr;
	end loop;

	-- calculate overall WAM, UOC
	if uoc_total = 0 then
		tr := (null, null, 'No WAM available', null, null, uoc_passed);
	else
		tr := (null, null, 'Overall WAM', (wsum / uoc_total)::integer, null, uoc_passed);
	end if; 

	-- append last record to transcript
	return next tr;
	return;
end;
$$ language plpgsql
;
