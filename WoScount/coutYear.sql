/*
drop table country_list;
drop table country_info;
--temporary table to store country_list of each article
create temporary table country_list(id varchar(19) primary key, cu_list varchar(100000));

-- temporary table to store country and cu pairs (because the 'character varying' issue is not resolved, this is an optional way)

-- extract distinct id and country pairs to country_info table (country was converted to varchar)

create temporary table country_info(id varchar(19), cu varchar(30));

insert into country_info(id, cu)
select distinct a.id, cast(country as varchar(30)) 
from wos_core.wos_addresses a 
     inner join (select id from wos_core.interface_table where year ='2017' or year = '2016') b on a.id=b.id
order by a.id, country;


-- concat countries of an article to a country_list
insert into country_list(id,cu_list)
select id, array_to_string(array_agg(cu),',') as cu_list
from country_info
where cu<>'*'
group by id;

select a.id, count(*) from (select * from wos_core.interface_table where year ='2017') a 
     inner join (select Id 
				 from wos_core.wos_doctypes 
				 where doctype in ('Article', 'Review')) b on a.Id=b.Id
	 group by a.id
	 having count(*) >1
*/

-- this is the query to extract country collaboration pairs for 2017 for every subject
select d.cu, count(a.id) n, year
from (select * from wos_core.interface_table where year ='2017' or year = '2016') a 
     inner join (select distinct Id from wos_core.wos_doctypes where doctype in ('Article', 'Review')) b on a.Id=b.Id
-- 	 inner join (select Id,subject from wos_core.wos_subjects where ascatype='traditional' and subject like 'Agricultur%') c on a.Id =c.Id
-- 	 inner join (select Id from wos_core.wos_subjects where ascatype='extended' and subject='Chemistry') c on a.Id =b.Id
     inner join country_info d on a.Id=d.Id
group by d.cu, year
order by year, n desc;

