create table int_usage (
user_id int primary key,
giv_date date,
age int,
age_group varchar(10),
social_media_hours decimal(5,2),
work_or_study_hours decimal(5,2),
entertainment_hours decimal(5,2),
total_screen_time decimal(5,2),
primary_device enum('Mobile','Tablet','Laptop'),
internet_type enum('WIFI','Mobile Data')
);

select * from int_usage;

-- avg hrs in prod, sm, ent for people betw 15 to 30
select round(avg(work_or_study_hours),2) as avg_sty_hours,
round(avg(social_media_hours),2) as avg_ss_hours,
round(avg(entertainment_hours),2) as avg_ent_hours 
 from int_usage
where age between 15 and 30;

-- mobile users where screen time is above 10 hr
select count(*) as total_user from int_usage
where total_screen_time > 10
and primary_device = 'Mobile';

-- top 5 month with most number of users with 5+ hr on work/study
select month(giv_date) as month_num, count(work_or_study_hours) as tot_hr from int_usage
where work_or_study_hours > 5
group by month(giv_date)
order by tot_hr desc
limit 5;

-- avg hours spent by people who uses laptop for work/study
select avg(work_or_study_hours) as avg_users from int_usage 
where work_or_study_hours > 5
and primary_device = 'Laptop';

-- age group with total sm , prod, ent hrs
select age_group, sum(social_media_hours) as sm_hr,
sum(work_or_study_hours) as ws_hr,
sum(entertainment_hours) e_hr from int_usage
group by age_group
order by sm_hr desc, ws_hr desc, e_hr desc;

-- internet type with most hours
select internet_type, sum(social_media_hours) as sm_hr,
sum(work_or_study_hours) as ws_hr,
sum(entertainment_hours) e_hr from int_usage
group by internet_type
order by sm_hr desc;

-- age group with the highest screentime
select age_group, sum(total_screen_time) as sc_time from int_usage
group by age_group
order by sc_time desc;

-- device type with highest screentime
select primary_device, sum(total_screen_time) as sc_time from int_usage
group by primary_device
order by sc_time desc;

-- which device has more screen_time with which purpose
select primary_device,
sum(work_or_study_hours) as work_or_study,
sum( social_media_hours + entertainment_hours ) as leisure_hr,
sum(total_screen_time) as screen_time
from int_usage
group by primary_device
order by total_screen_time desc;

-- which combination is best/preferred for being productive
select primary_device ,internet_type, 
round(sum(work_or_study_hours)/(sum(social_media_hours+entertainment_hours)),2)
as productive_rate from int_usage
group by primary_device, internet_type
order by productive_rate desc;

-- which age group excced healthy screentime threshold more frequently
select age_group,
count(*) as exceed_count,
round(count(*)/(select count(*) from int_usage),2) as exceed_ratio
from int_usage
where total_screen_time > 6
group by age_group
order by exceed_count desc;

