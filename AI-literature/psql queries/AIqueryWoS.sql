/* 
CREATE TABLE wos_core.XuliJournalAI(
Name 	TEXT PRIMARY KEY 	NOT NULL
);

The following command only works from the terminal
\copy wos_core.XuliJournalAI FROM '/home/yan30/workingdir/YingDing/Xuli/AIjournalList.csv' DELIMITER ',' CSV

CREATE TABLE wos_core.XuliPapersWoS(
AuthorNames TEXT,
Affiliations TEXT,
Country TEXT,
JournalName TEXT,
PaperID TEXT PRIMARY KEY NOT NULL,
DOI TEXT,
DocType TEXT,
Title 	TEXT,
Year	TEXT, 
Abstract TEXT,
Keywords TEXT,
Refs TEXT,
AddressVerified TEXT DEFAULT 'false'
);

INSERT INTO wos_core.XuliPapersWoS(PaperID, year, Title, JournalName)
(SELECT DISTINCT on (a.id) a.id,  CAST (a.pubyear AS INTEGER), b.title, c.title as journal
FROM wos_core.wos_summary as a, 
wos_core.wos_titles as b,
wos_core.wos_titles as c,
wos_core.Xuli as d
WHERE 
a.id = b.id AND
b.title_type = 'item' AND
a.id = c.id AND
c.title_type = 'source' AND
lower(c.title) = lower(d.Name)
);

update wos_core.XuliPapersWoS
set doctype = query.pubtype,
    refs = query.cites,
	abstract = query.abs,
    doi = query.identifier_value,
	keywords = query.keywords
from 
(SELECT b.id, b.pubtype, string_agg(d.ref_id, ';') as cites, c.identifier_value, 
 string_agg('['||a.paragraph_id||']'|| a.paragraph_text, ';') as abs, string_agg('['||k.keyword_id||']'||k.keyword, ';') as keywords
FROM wos_core.XuliPapersWoS
LEFT JOIN wos_core.wos_summary as b
ON wos_core.XuliPapersWoS.paperid=b.id 
LEFT JOIN wos_core.wos_dynamic_identifiers as c 
ON b.id=c.id AND c.identifier_type='doi'
LEFT JOIN wos_core.wos_references as d
ON b.id=d.id
LEFT JOIN wos_core.wos_abstract_paragraphs as a
ON b.id=a.id
LEFT JOIN wos_core.wos_keywords as k
ON b.id=k.id
GROUP BY b.id, b.pubtype, c.identifier_value) as query
where wos_core.XuliPapersWoS.paperid = query.id

update wos_core.XuliPapersWoS
set authornames = q.namelist,
	country = q.country
from 
(SELECT b.id, string_agg(c.display_name, '|') as namelist, b.country
	FROM wos_core.XuliPapersWoS
	LEFT JOIN wos_core.wos_summary as b
	ON wos_core.XuliPapersWoS.PaperID = b.id
	LEFT JOIN wos_core.wos_summary_names as c
	ON b.id=c.id
	GROUP BY b.id, b.country) as q
where q.id = wos_core.XuliPapersWoS.PaperID
*/
update wos_core.XuliPapersWoS
set authornames = q.namelist,
    affiliations = q.affiliations,
	country = q.country,
	addressverified = 'true'
from 
(select query.id, string_agg(query.affiliates, '|') as affiliations, string_agg(query.countries, '|') as country, string_agg(query.display_name, '|') as namelist from
	(SELECT b.id, string_agg(b.full_address, ';') as affiliates, string_agg(b.country, ';') as countries, c.display_name
	FROM wos_core.XuliPapersWoS
	INNER JOIN wos_core.wos_addresses as b
	ON wos_core.XuliPapersWoS.PaperID = b.id
	INNER JOIN wos_core.wos_address_names as c
	ON b.id=c.id AND b.addr_id=c.addr_id
	GROUP BY b.id, c.display_name) as query
GROUP BY query.id) as q
where q.id = wos_core.XuliPapersWoS.PaperID

