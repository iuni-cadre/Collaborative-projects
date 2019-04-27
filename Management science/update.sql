/*
update yangyangpapers
set abstract = query.abs
from
(SELECT a.id, string_agg('['||a.paragraph_id||']'|| a.paragraph_text, ';') as abs
from
dblink('dbname=core_data user=yan30 password=ins_type_mixed_tobacco', 'select id::text, paragraph_id::text, paragraph_text::text from wos_core.wos_abstract_paragraphs') as a (id text, paragraph_id text, paragraph_text text)
LEFT JOIN YangyangPapers as b
ON b.paperid=a.id
GROUP BY a.id) as query
where YangyangPapers.paperid = query.id

update yangyangpapers
set keywords = query.keywords
from
(SELECT k.id, string_agg('['||k.keyword_id||']'||k.keyword, ';') as keywords
from
dblink('dbname=core_data user=yan30 password=ins_type_mixed_tobacco', 'select id::text, keyword_id::text, keyword::text from wos_core.wos_keywords') as k (id text, keyword_id text, keyword text)
LEFT JOIN YangyangPapers as b
ON b.paperid=k.id
GROUP BY k.id) as query
where YangyangPapers.paperid = query.id

update YangyangPapers
set authornames = q.namelist,
    affiliations = q.affiliations,
	country = q.country
from 
(SELECT query.id, string_agg(query.affiliates, '|') as affiliations, string_agg(query.countries, '|') as country, string_agg(query.display_name, '|') as namelist from	
	(SELECT a.id, string_agg(a.full_address, ';') as affiliates, string_agg(a.country, ';') as countries, max(n.seq_no) as seq_no, n.display_name
	FROM YangyangPapers as p,
	dblink('dbname=core_data user=yan30 password=ins_type_mixed_tobacco', 'select id::text, addr_id::text, full_address::text, country::text from wos_core.wos_addresses') as a (id text, addr_id text, full_address text, country text),
	dblink('dbname=core_data user=yan30 password=ins_type_mixed_tobacco', 'select id::text, addr_id::text, seq_no::text, addr_no_raw::text, display_name::text from wos_core.wos_address_names ORDER BY addr_no_raw') as n (id text, addr_id text, seq_no text, addr_no_raw text, display_name text)
	where
	p.PaperID = a.id AND
	a.id=n.id AND a.addr_id=n.addr_id
	GROUP BY a.id, n.display_name
    ORDER BY seq_no)as query
	GROUP BY query.id) as q
where q.id = YangyangPapers.PaperID

update YangyangExtra
set authornames = q.namelist,
    affiliations = q.affiliations,
	country = q.country
from 
(SELECT query.id, string_agg(query.affiliates, '|') as affiliations, string_agg(query.countries, '|') as country, string_agg(query.display_name, '|') as namelist from	
	(SELECT a.id, string_agg(a.full_address, ';') as affiliates, string_agg(a.country, ';') as countries, max(n.seq_no) as seq_no, n.display_name
	FROM YangyangExtra as p,
	dblink('dbname=core_data user=yan30 password=ins_type_mixed_tobacco', 'select id::text, addr_id::text, full_address::text, country::text from wos_core.wos_addresses') as a (id text, addr_id text, full_address text, country text),
	dblink('dbname=core_data user=yan30 password=ins_type_mixed_tobacco', 'select id::text, addr_id::text, seq_no::text, addr_no_raw::text, display_name::text from wos_core.wos_address_names ORDER BY addr_no_raw') as n (id text, addr_id text, seq_no text, addr_no_raw text, display_name text)
	where
	p.PaperID = a.id AND
	a.id=n.id AND a.addr_id=n.addr_id
	GROUP BY a.id, n.display_name
    ORDER BY seq_no)as query
	GROUP BY query.id) as q
where q.id = YangyangExtra.PaperID

update YangyangExtra
set keywords = query.keywords
from
(SELECT k.id, string_agg('['||k.keyword_id||']'||k.keyword, ';') as keywords
from
dblink('dbname=core_data user=yan30 password=ins_type_mixed_tobacco', 'select id::text, keyword_id::text, keyword::text from wos_core.wos_keywords') as k (id text, keyword_id text, keyword text)
LEFT JOIN YangyangExtra as b
ON b.paperid=k.id
GROUP BY k.id) as query
where YangyangExtra.paperid = query.id
*/

update YangyangExtra
set abstract = query.abs
from
(SELECT a.id, string_agg('['||a.paragraph_id||']'|| a.paragraph_text, ';') as abs
from
dblink('dbname=core_data user=yan30 password=ins_type_mixed_tobacco', 'select id::text, paragraph_id::text, paragraph_text::text from wos_core.wos_abstract_paragraphs') as a (id text, paragraph_id text, paragraph_text text)
LEFT JOIN YangyangExtra as b
ON b.paperid=a.id
GROUP BY a.id) as query
where YangyangExtra.paperid = query.id
