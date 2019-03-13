/*
CREATE TABLE wos_core.btaa_new AS 
SELECT wos_reprint_addresses.id, wos_reprint_addresses.addr_id
		FROM wos_core.wos_reprint_addresses
			WHERE  wos_reprint_addresses.full_address ILIKE '%Univ Illin%' 			
			OR wos_reprint_addresses.full_address ILIKE '%Indiana Univ%'				
			OR wos_reprint_addresses.full_address ILIKE '%Univ Iowa%' 				
			OR wos_reprint_addresses.full_address ILIKE '%Univ Maryland%' 			
			OR wos_reprint_addresses.full_address ILIKE '%Univ Michigan%' 			
			OR wos_reprint_addresses.full_address ILIKE '%Michigan State Univ%' 	
			OR wos_reprint_addresses.full_address ILIKE '%Univ Minnesota%' 			
			OR wos_reprint_addresses.full_address ILIKE '%Univ Nebra%-Linc%' 		
			OR wos_reprint_addresses.full_address ILIKE '%Northwestern Univ%' 		
			OR wos_reprint_addresses.full_address ILIKE '%Ohio Univ%' 				
			OR wos_reprint_addresses.full_address ILIKE '%Penn State Univ%' 		
			OR wos_reprint_addresses.full_address ILIKE '%Purdue Univ%' 			
			OR wos_reprint_addresses.full_address ILIKE '%Rutgers% Brunswick%' 		
			OR wos_reprint_addresses.full_address ILIKE '%Univ Wisconsin% Madison%' 
			OR wos_reprint_addresses.full_address ILIKE '%Univ Chicago%'
			GROUP BY wos_reprint_addresses.id, wos_reprint_addresses.addr_id
		   ;

CREATE TABLE wos_core.btaa_new2 AS
	SELECT btaa_new.id, btaa_new.addr_id, wos_summary.pubtype, wos_summary.fund_ack, wos_summary.pubyear
		FROM wos_core.btaa_new
			LEFT JOIN wos_core.wos_summary
				ON btaa_new.id = wos_summary.id

CREATE TABLE wos_core.btaa_new3 AS 
	SELECT btaa_new2.id, 
	   btaa_new2.addr_id, 
	   btaa_new2.pubtype, 
	   btaa_new2.fund_ack, 
	   btaa_new2.pubyear,
	   b.eissn,
	   c.issn,
	   d.doi
FROM 
	wos_core.btaa_new2
LEFT JOIN  
	(SELECT id, string_agg(DISTINCT(identifier_value), '|') AS "eissn" FROM wos_core.wos_dynamic_identifiers WHERE identifier_type = 'eissn' GROUP BY id)b
	ON btaa_new2.id = b.id 
	LEFT JOIN  
	(SELECT id, string_agg(DISTINCT(identifier_value), '|') AS "issn" FROM wos_core.wos_dynamic_identifiers WHERE identifier_type = 'issn' GROUP BY id)c
	ON btaa_new2.id = c.id 
	LEFT JOIN  
	(SELECT id, string_agg(DISTINCT(identifier_value), '|') AS "doi" FROM wos_core.wos_dynamic_identifiers WHERE identifier_type = 'doi' GROUP BY id)d
	ON btaa_new2.id = d.id 
;

CREATE TABLE wos_core.btaa_new4 AS
	SELECT btaa_new3.id, 
	   	   btaa_new3.addr_id, 
		   btaa_new3.pubtype, 
		   btaa_new3.fund_ack, 
		   btaa_new3.pubyear, 
	       btaa_new3.eissn,
           btaa_new3.issn,
           btaa_new3.doi,
		   string_agg(DISTINCT(wos_reprint_address_names.full_name), '|')   AS "Reprint Author"
FROM wos_core.btaa_new3
LEFT JOIN wos_core.wos_reprint_address_names 
	ON btaa_new3.id = wos_reprint_address_names.id
GROUP BY btaa_new3.id, 
	   	   btaa_new3.addr_id, 
		   btaa_new3.pubtype, 
		   btaa_new3.fund_ack, 
		   btaa_new3.pubyear, 
	       btaa_new3.eissn,
           btaa_new3.issn,
           btaa_new3.doi
;

CREATE TABLE wos_core.btaa_new5 AS
	SELECT btaa_new4.id,
		   btaa_new4.addr_id, 
		   btaa_new4.pubtype, 
		   btaa_new4.fund_ack, 
		   btaa_new4.pubyear, 
		   btaa_new4.eissn, 
           btaa_new4.issn, 
           btaa_new4.doi,
		   btaa_new4."Reprint Author",
		   b.title AS title,
		   c.venue AS venue
FROM wos_core.btaa_new4
LEFT JOIN (SELECT id, string_agg(DISTINCT(title), '|') AS "title" FROM wos_core.wos_titles WHERE title_type = 'item' GROUP BY id)b
	ON btaa_new4.id = b.id
LEFT JOIN (SELECT id, string_agg(DISTINCT(title), '|') AS "venue" FROM wos_core.wos_titles WHERE title_type = 'source' GROUP BY id)c
	ON btaa_new4.id = c.id
;

CREATE TABLE wos_core.btaa_new6 AS
	SELECT btaa_new5.id,
           btaa_new5.pubtype,
           btaa_new5.fund_ack,
           btaa_new5.pubyear,
           btaa_new5.eissn,
           btaa_new5.issn, 
           btaa_new5.doi,
           btaa_new5."Reprint Author",
           btaa_new5.title,
           btaa_new5.venue,
           string_agg(DISTINCT(wos_summary_names.full_name), '|')   AS "Author"
FROM wos_core.btaa_new5
LEFT JOIN wos_core.wos_summary_names 
	ON btaa_new5.id = wos_summary_names.id
GROUP BY btaa_new5.id,
           btaa_new5.pubtype,
           btaa_new5.fund_ack,
           btaa_new5.pubyear,
           btaa_new5.eissn,
           btaa_new5.issn, 
           btaa_new5.doi,
           btaa_new5."Reprint Author",
           btaa_new5.title,
           btaa_new5.venue
;

CREATE TABLE wos_core.btaa_new7 AS
	SELECT btaa_new6.id,
           btaa_new6.pubtype,
           btaa_new6.fund_ack,
           btaa_new6.pubyear,
           btaa_new6.eissn,
           btaa_new6.issn, 
           btaa_new6.doi,
           btaa_new6."Reprint Author",
           btaa_new6.title,
           btaa_new6.venue,
           btaa_new6."Author",
           b.publisher
FROM wos_core.btaa_new6
LEFT JOIN (SELECT id, string_agg(DISTINCT(full_name), '|') AS "publisher" FROM wos_core.wos_publisher_names GROUP BY id) b
	ON btaa_new6.id = b.id
;

CREATE TABLE wos_core.btaa_new8 AS
	SELECT btaa_new7.id,
           btaa_new7.pubtype,
           btaa_new7.fund_ack,
           btaa_new7.pubyear,
           btaa_new7.eissn,
           btaa_new7.issn, 
           btaa_new7.doi,
           btaa_new7."Reprint Author",
           btaa_new7.title,
           btaa_new7.venue,
           btaa_new7."Author",
           btaa_new7.publisher,
           string_agg(DISTINCT(wos_reprint_addresses.city), '|')   AS "city",
 		   string_agg(DISTINCT(wos_reprint_addresses.full_address), '|')   AS "full_address"
FROM wos_core.btaa_new7
LEFT JOIN wos_core.wos_reprint_addresses
	ON btaa_new7.id = wos_reprint_addresses.id
GROUP BY btaa_new7.id,
           btaa_new7.pubtype,
           btaa_new7.fund_ack,
           btaa_new7.pubyear,
           btaa_new7.eissn,
           btaa_new7.issn, 
           btaa_new7.doi,
           btaa_new7."Reprint Author",
           btaa_new7.title,
           btaa_new7.venue,
           btaa_new7."Author",
           btaa_new7.publisher
;
*/

CREATE TABLE wos_core.btaa_new9 AS
	SELECT btaa_new8.id,
           btaa_new8.pubtype,
           btaa_new8.fund_ack,
           btaa_new8.pubyear,
           btaa_new8.eissn,
           btaa_new8.issn, 
           btaa_new8.doi,
           btaa_new8."Reprint Author",
           btaa_new8.title,
           btaa_new8.venue,
           btaa_new8."Author",
           btaa_new8.publisher,
           btaa_new8.city,
           btaa_new8.full_address,
		   b.grant_agency
FROM wos_core.btaa_new8
LEFT JOIN (SELECT id, string_agg(DISTINCT(grant_agency), '|') AS grant_agency FROM wos_core.wos_grants GROUP BY id) b
	ON btaa_new8.id = b.id
;


