use employees;

-- 1 This stored procedure finds out how many years someone was employed with the company
delimiter $$
drop procedure if exists years_employed$$
create procedure years_employed(in empno int, out years int)
begin
	declare year_started int;
    declare year_left int;
    
    select year(d.from_date), year (d.to_date)
    into year_started, year_left
    from dept_emp d
    where d.emp_no = empno
    limit 10;
    
    if year_left = 9999 then
		set year_left = year(now());
        end if;
	select year_left - year_started into years;
end $$
delimiter ;
-- stored procedure 2 is for inserting new data into the database
-- it work by you inserting the data in the correct spots to get a new employee entry
delimiter $$
drop procedure if exists add_emp $$
create procedure add_emp( in emp_no int, in birth_date date, in first_name varchar(14), in last_name varchar(16), in gender enum('m','f'), in hire_date date )
	begin
		INSERT INTO employees VALUES
		( emp_no, birth_date, first_name, last_name, gender, hire_date );
	end 
    $$
delimiter ;

-- stored procedure 3 This stored procedure concats the name of employees as there full name
delimiter $$
drop procedure if exists nameconcat $$
create procedure nameconcat( out name_concat varchar(50))
begin
	select first_name, last_name 
    from employees e
    limit 1;
    set name_concat = concat(firstname, ' ', lastname);
    select name_concat;
end $$
delimiter ;

-- 4
-- This stored procedure takes an employees first and last name and returns the titles they have held while with this company.
delimiter $$
drop procedure if exists emp_titles;
create procedure emp_titles(in empfn varchar(20),in empLN varchar(20))
begin
	select t.title, e.emp_no from employees e
    inner join titles t on e.emp_no = t.emp_no
	WHERE first_name = empfn
		AND last_name = empln;
END $$
DELIMITER ;
call emp_titles("georgi", "facello");
    
-- 5 This procedure takes three variables two dates and one department name to find the amount of many was spent on salaries between the specified dates in a department.
delimiter $$
drop procedure department_cost $$
create procedure department_cost( in date1 year, in date2 year, in dept varchar(20)) 
begin
	
    select sum( s.salary ), d.dept_name
	from salaries s
	inner join dept_emp de on s.emp_no = de.emp_no
	inner join departments d on d.dept_no = de.dept_no
	where d.dept_name = dept
	and year(s.from_date ) >= date1 and year( s.to_date )  <= date2;
end $$
delimiter ;

call department_cost( 2008, 2009, 'Marketing' );
call department_cost(2000, 2002, 'Marketing' );
call department_cost(1999, 2006, 'Sales' );