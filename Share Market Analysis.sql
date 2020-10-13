-- Using MySQL 8
-- Using the assignment Schema and allowing updates
-- Assuming assignment is used by default else command below can be used
-- use assignment;

SET SQL_SAFE_UPDATES = 0;

/* Used for testing
Checking structure of created table
show tables;
desc `bajaj auto`;
desc `eicher motors`;
desc `hero motocorp`;
desc infosys;
desc tcs;
desc `tvs motors`;


Checking Data stored in table
select * from `bajaj auto`;
select * from `eicher motors`;
select * from `hero motocorp`;
select * from infosys;
select * from tcs;
select * from `tvs motors`;
*/

-- Drop functions if exists that we are going to create
drop function if exists get_date;
drop function if exists getmonth;
drop function if exists get_signal;

-- Function to get  date as number
DELIMITER $$
create function get_date(file_date varchar(20))
returns  varchar(2) deterministic
BEGIN 
declare format_date varchar(2);
if file_date='January' then
	set format_date= '1';
elseif  file_date='February' then
	set format_date= '2';
elseif file_date='March' then
	set format_date= '3';
elseif file_date='April' then
	set format_date= '4';
elseif  file_date='May' then
	set format_date= '5';
elseif file_date='June' then
	set format_date= '6';
elseif file_date='July' then
	set format_date= '7';
elseif  file_date='August' then
	set format_date= '8';
elseif file_date='September' then
	set format_date='9';
elseif file_date='October' then
	set format_date='10';
elseif  file_date='November' then
	set format_date= '11';
else
	set format_date= '12';
end if;
return format_date;
END $$


-- Function to get Month name from Date
DELIMITER $$
create function getmonth(date varchar(20))
returns varchar(20) deterministic
BEGIN
return (select SUBSTRING_INDEX(SUBSTRING_INDEX(Date,'-',2),'-',-1));
END $$
DELIMITER ;


-- Pre-processing data in tables. For better query performance afterwards
-- Updating Values of Dates according to given format 
 update `bajaj auto`
 set Date=(select replace(Date,getmonth(Date),get_date(getmonth(Date))));
 
 update `eicher motors`
 set Date=(select replace(Date,getmonth(Date),get_date(getmonth(Date))));
 
 update `hero motocorp`
 set Date=(select replace(Date,getmonth(Date),get_date(getmonth(Date))));
 
 update infosys
 set Date=(select replace(Date,getmonth(Date),get_date(getmonth(Date))));
 
 update tcs
 set Date=(select replace(Date,getmonth(Date),get_date(getmonth(Date))));
 
  update `tvs motors`
 set Date=(select replace(Date,getmonth(Date),get_date(getmonth(Date))));
 
 
-- Update Values of Dates to be taken with str_to_date function and convert to date 
update `bajaj auto`
set `Date`=  str_to_date(`Date`,'%d-%m-%Y');
alter table `bajaj auto`
modify `Date` date ;

update `eicher motors`
set `Date`=  str_to_date(`Date`,'%d-%m-%Y');
alter table `eicher motors`
modify `Date` date ;

update `hero motocorp`
set `Date`=  str_to_date(`Date`,'%d-%m-%Y');
alter table `hero motocorp`
modify `Date` date ;

update infosys
set `Date`=  str_to_date(`Date`,'%d-%m-%Y');
alter table infosys
modify `Date` date ;

update tcs
set `Date`=  str_to_date(`Date`,'%d-%m-%Y');
alter table tcs
modify `Date` date ;

update `tvs motors`
set `Date`=  str_to_date(`Date`,'%d-%m-%Y');
alter table `tvs motors`
modify `Date` date ;


-- TASK 1 :Start
/* 
if not exists is used to prevent error if table exists. 
(Assuming table will be as required, else drop table will be needed)
*/
-- Create table bajaj1
create table if not exists bajaj1 as
	select `Date`,`Close Price`,
avg(`Close Price`) over(order by `Date` rows between 19 preceding and current row) as '20 Day MA',
avg(`Close Price`) over(order by `Date` rows between 49 preceding and current row) as '50 Day MA'
 from `bajaj auto`;
 
 -- Create table eicher1
 create table  if not exists eicher1 as
	select `Date`,`Close Price`,
avg(`Close Price`) over(order by `Date` rows between 19 preceding and current row) as '20 Day MA',
avg(`Close Price`) over(order by `Date` rows between 49 preceding and current row) as '50 Day MA'
 from `eicher motors`;
 
 -- Create table hero1
 create table  if not exists hero1 as
	select `Date`,`Close Price`,
avg(`Close Price`) over(order by `Date` rows between 19 preceding and current row) as '20 Day MA',
avg(`Close Price`) over(order by `Date` rows between 49 preceding and current row) as '50 Day MA'
 from `hero motocorp`;
 
 -- Create table infosys1
 Create table  if not exists infosys1
 select `Date`,`Close price`,
 avg(`Close price`) over(order by `Date` rows  between 19 preceding and current row) as '20 Day MA',
 avg(`Close price`) over(order by `Date` rows  between 49 preceding and current row) as '50 Day MA'
 from infosys;
 
 -- Create table tcs1
 Create table  if not exists tcs1
 select `Date`,`Close price`,
 avg(`Close price`) over(order by `Date` rows  between 19 preceding and current row) as '20 Day MA',
 avg(`Close price`) over(order by `Date` rows  between 49 preceding and current row) as '50 Day MA'
 from tcs;
 
 -- Create table tvs1
 Create table  if not exists tvs1
 select `Date`,`Close price`,
 avg(`Close price`) over(order by `Date` rows  between 19 preceding and current row) as '20 Day MA',
 avg(`Close price`) over(order by `Date` rows  between 49 preceding and current row) as '50 Day MA'
 from `tvs motors`;
 
 -- Making first 19 rows NULL as moving average can't be calculated
 update bajaj1
 set `20 Day MA` = NULL limit 19;
 
 update eicher1
 set `20 Day MA` = NULL limit 19;
 
 update hero1
 set `20 Day MA` = NULL limit 19;
 
 update infosys1
 set `20 Day MA` = NULL limit 19;
 
 update tcs1
 set `20 Day MA` = NULL limit 19;
 
 update tvs1
 set `20 Day MA` = NULL limit 19;
 
 -- Making first 49 rows NULL as moving average can't be calculated
 update bajaj1
 set `50 Day MA` = NULL limit 49;
 
 update eicher1
 set `50 Day MA` = NULL limit 49;
 
 update hero1
 set `50 Day MA` = NULL limit 49;
    
 update infosys1
 set `50 Day MA` = NULL limit 49;
 
 update tcs1
 set `50 Day MA` = NULL limit 49;
 
 update tvs1
 set `50 Day MA` = NULL limit 49;
 
 /* Testing
 -- Checking Data
 select * from bajaj1;
 select * from eicher1;
 select * from hero1;
 select * from infosys1;
 select * from tcs1;
 select * from tvs1;
*/
 -- Task 1 :End
 
 
 -- Task 2 :Start
 -- Create master_stock_info table
 
 create table  if not exists master_stock_info
 select tcs.`Date`,b.`Close price` as 'Bajaj',
 tcs.`Close price` as 'TCS' ,tvs.`Close price` as 'TVS',
 i.`Close price` as 'Infosys',e.`Close price` as 'Eicher',
 h.`Close price` as 'Hero'
 from tcs  inner join `eicher motors` e on e.`Date`=tcs.`Date`
 inner join  `tvs motors` tvs on tvs.`Date`= tcs.`Date`
 inner join  `hero motocorp` h on h.`Date` = tcs.`Date`
 inner join  `bajaj auto` b on b.`Date`=tcs.`Date`
 inner join  infosys i on i.`Date`=tcs.`Date` order by tcs.`Date`;
 
 -- Display data from master_stock_info
 select * from master_stock_info;
 -- Task 2 :End 
 
 
 
 -- Task 3 : Start
 -- create table bajaj2
create table  if not exists bajaj2
 select `Date`,`Close price`,
 case 
 when `50 Day MA` is NULL then 'NA'
 when `20 Day MA`>`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))<(lag(`50 Day MA`,1) over(order by `Date`))) then 'BUY'
 when `20 Day MA`<`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))>(lag(`50 Day MA`,1) over(order by `Date`))) then 'SELL'
 else 'HOLD' 
 end as `Signal`
 from bajaj1 ;
 
 -- create table eicher2 
 create table  if not exists eicher2
 select `Date`,`Close price`,
 case 
 when `50 Day MA` is NULL then 'NA'
 when `20 Day MA`>`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))<(lag(`50 Day MA`,1) over(order by `Date`))) then 'BUY'
 when `20 Day MA`<`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))>(lag(`50 Day MA`,1) over(order by `Date`))) then 'SELL'
 else 'HOLD' 
 end as `Signal`
 from eicher1;
 
 -- create table tcs2
 create table  if not exists tcs2
 select `Date`,`Close price`,
 case 
 when `50 Day MA` is NULL then 'NA'
 when `20 Day MA`>`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))<(lag(`50 Day MA`,1) over(order by `Date`))) then 'BUY'
 when `20 Day MA`<`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))>(lag(`50 Day MA`,1) over(order by `Date`))) then 'SELL'
 else 'HOLD' 
 end as `Signal`
 from tcs1 ;
 
 -- create table tvs2
 create table  if not exists tvs2
 select `Date`,`Close price`,
 case 
 when `50 Day MA` is NULL then 'NA'
 when `20 Day MA`>`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))<(lag(`50 Day MA`,1) over(order by `Date`))) then 'BUY'
 when `20 Day MA`<`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))>(lag(`50 Day MA`,1) over(order by `Date`))) then 'SELL'
 else 'HOLD' 
 end as `Signal`
 from tvs1 ;
 
 -- create table hero2
 create table  if not exists hero2
 select `Date`,`Close price`,
 case 
 when `50 Day MA` is NULL then 'NA'
 when `20 Day MA`>`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))<(lag(`50 Day MA`,1) over(order by `Date`))) then 'BUY'
 when `20 Day MA`<`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))>(lag(`50 Day MA`,1) over(order by `Date`))) then 'SELL'
 else 'HOLD' 
 end as `Signal`
 from hero1 ;
 
 -- create  table infosys2
 create table  if not exists infosys2
 select `Date`,`Close price`,
 case 
 when `50 Day MA` is NULL then 'NA'
 when `20 Day MA`>`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))<(lag(`50 Day MA`,1) over(order by `Date`))) then 'BUY'
 when `20 Day MA`<`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))>(lag(`50 Day MA`,1) over(order by `Date`))) then 'SELL'
 else 'HOLD' 
 end as `Signal`
 from infosys1 ;
 
 -- Checking Data
 
 select * from bajaj2;
 select * from eicher2;
 select * from hero2;
 select * from infosys2;
 select * from tcs2;
 select * from tvs2;
 
 -- Task 3 :End
 
 
 -- Task 4 Start
 DELIMITER $$
 create function get_signal(signal_date date)
 returns varchar(20) deterministic
 BEGIN
 return (select `Signal` from bajaj2 where bajaj2.`Date` = signal_date);
 END $$
 
 -- testing of function 
  DELIMITER ;
 select get_signal(`Date`),`Date` as 'Signal' from `bajaj auto`;
 select get_signal('2018-06-21');
 -- Expected output  BUY , actual output BUY ->Pass 
 select get_signal('2018-05-29');
 -- Expected output SELL, actual output SELL ->Pass
 select get_signal('2018-05-30');
 -- Expected output HOLD, actual output HOLD ->Pass
 select get_signal('2015-01-01');
 -- Expected output NA, actual output NA ->Pass
 
 -- Task 4 End 
 
 -- Task 5 analysis
 -- Getting the number of times bought and sold
 
 select count(*) from bajaj2 where `Signal`='SELL';
 select count(*) from bajaj2 where `Signal`='BUY';
 
 select * from bajaj2 where `Signal`='BUY' or `Signal`='SELL';
 
 select * from tcs2 where `Signal`='BUY' or `Signal`='SELL';
 select count(*) from tcs2 where `Signal`='SELL';
 
 select * from eicher2 where `Signal`='BUY' or `Signal`='SELL';
 select count(*) from eicher2 where `Signal`='SELL';
  select count(*) from eicher2 where `Signal`='BUY';
  
   select * from tvs2 where `Signal`='BUY' or `Signal`='SELL';
 select count(*) from tvs2 where `Signal`='SELL';
  select count(*) from tvs2 where `Signal`='BUY';
  
     select * from hero2 where `Signal`='BUY' or `Signal`='SELL';
 select count(*) from hero2 where `Signal`='SELL';
  select count(*) from hero2 where `Signal`='BUY';
  
    select * from infosys2 where `Signal`='BUY' or `Signal`='SELL';
 select count(*) from infosys2 where `Signal`='SELL';
  select count(*) from infosys2 where `Signal`='BUY';
 
 -- Getting the trend
 select (select `Close price` from `bajaj auto`  order by `Date` desc limit 1) - (select `Open price` from `bajaj auto`  order by `Date`  limit 1) as 'Trend';
 
 select (select `Close price` from tcs  order by `Date` desc limit 1) - (select `Open price` from tcs  order by `Date`  limit 1) as 'Trend';
 
 select (select `Close price` from `eicher motors`  order by `Date` desc limit 1) - (select `Open price` from `eicher motors`  order by `Date`  limit 1) as 'Trend';
 
 select (select `Close price` from `tvs motors`  order by `Date` desc limit 1) - (select `Open price` from `tvs motors`  order by `Date`  limit 1) as 'Trend';
 
 select (select `Close price` from infosys  order by `Date` desc limit 1) - (select `Open price` from infosys  order by `Date`  limit 1) as 'Trend';
 
 
 
