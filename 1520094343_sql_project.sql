/* Querying information to answer questions using tables in "country_club" database

The data is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */
select distinct name from Facilities where membercost > 0
/* Answer:
Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court
*/

/* Q2: How many facilities do not charge a fee to members? */
select count(distinct name) from Facilities where membercost = 0
/* Answer: 4

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
select facid,name,membercost,monthlymaintenance from Facilities where membercost > 0 and membercost < 0.2*monthlymaintenance


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
select * from Facilities where facid = 1 and facid = 5

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */
select
name,
case when monthlymaintenance > 100 then 'expensive'
else 'cheap' end as label
from Facilities

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */
SELECT firstname,surname FROM Members ORDER BY memid DESC

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
select distinct
concat(f.name, m.firstname) as list
from country_club.Bookings b
join country_club.Members m
on b.memid = m.memid
join country_club.Facilities f
on b.facid = f.facid
order by m.firstname

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
select 
sub.name,
concat(sub.firstname, sub.surname) as namelist,
case when f.membercost > 30 then f.membercost
when f.guestcost > 30 then f.guestcost 
end as cost
from country_club.Bookings b
join country_club.Members m
on b.memid = m.memid
join country_club.Facilities f
on b.facid = f.facid
where b.starttime like '2012-09-14%'
and f.membercost > 30
or f.guestcost > 30
order by cost desc

/* Q9: This time, produce the same result as in Q8, but using a subquery. */
select
sub.name,
concat(sub.firstname, sub.surname) as namelist,
case when sub.membercost > 30 then sub.membercost
when sub.guestcost > 30 then sub.guestcost 
end as cost
from
	(select b.starttime, f.*, m.firstname, m.surname
     from country_club.Bookings b
	 join country_club.Members m
	 on b.memid = m.memid
	 join country_club.Facilities f
	 on b.facid = f.facid
	 where b.starttime like '2012-09-14%') sub
where sub.membercost > 30
or sub.guestcost > 30
order by cost desc


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
select 
f.name,
(f.guestcost + f.membercost) as tot_rev
from country_club.Facilities f
join country_club.Bookings b
on f.facid = b.facid
where (f.guestcost + f.membercost) < 1000
group by f.name
order by (f.guestcost + f.membercost)