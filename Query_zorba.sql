-- CREATE VIEW vZorba_Leads
-- AS
SELECT pl.id
	, pl.customer_id AS cust_c_id
    , c.name AS c_name
    , c.phone AS c_phone
    , c.email AS c_email
    , c.gender AS c_gender
    , c.profile AS profile_score
    , pl.interest_level
    , c.added_by_id
    , a.full_name as added_by_name
    , c.created AS c_cd
    , c.modified AS c_md
    , c.source_thread_title AS actual_source_id
    , st.source_thread AS actual_source_name
    , pl.project_id AS program_p_id
    , p.name AS p_title
    , p.code AS p_code
    , p.category AS p_cat_ids
    , cat.name AS p_cat
    , p.ch_type AS p_type_id
    , ct.title AS p_type
    , p.start_date AS p_sd
    , p.end_date AS p_ed
    , p.created AS p_cd
    , p.modified AS p_md
    , p.supervisor_id AS p_sup_id
    , a1.full_name AS p_sup_name
    , p.admin_id AS p_el_ids
    , pl.adminstrator_id AS c_el_id
    , a2.full_name AS c_el_name
    , pl.assiged_date AS c_el_date
    , pl.last_assign AS reassign_flag
    , pl.campaign_name
    , pl.adset_name
    , pl.source AS system_source
FROM `project_leads` pl
LEFT JOIN customers c
	ON pl.customer_id = c.id
LEFT JOIN source_thread st
	ON c.source_thread_title = st.id
LEFT JOIN adminstrator a
	ON c.added_by_id = a.id
LEFT JOIN projects p
	ON pl.project_id = p.id
LEFT JOIN category cat
	ON p.category = cat.id
LEFT JOIN checklist_types ct
	ON p.ch_type = ct.id
LEFT JOIN adminstrator a1
	ON p.supervisor_id = a1.id
LEFT JOIN adminstrator a2
	ON pl.adminstrator_id = a2.id
HAVING NULL
ORDER BY pl.id;


SELECT
	*
FROM project_leads
WHERE adset_name = 'Facebook - A date with Pottery' AND source = 'Auto' AND campaign_name = 'A date with Pottery - 15th September 2019 LG Divya';

CREATE VIEW vZorba_Leads_by_interestScore
AS
SELECT 
	c.id,
    c.name,
    c.email,
    c.phone,
	COUNT(plm.id) AS number_of_calls,
    COUNT(DISTINCT pl.project_id) AS number_of_programs,
    AVG(plm.interest_level_log) AS avg_interest_score
FROM project_leads pl
JOIN customers c
	ON pl.customer_id=c.id
JOIN project_lead_messages plm
	ON pl.customer_id = plm.project_lead_id
GROUP BY pl.customer_id
ORDER BY number_of_programs DESC, number_of_calls DESC, name ASC;

SELECT *
FROM project_leads pl
JOIN project_lead_messages plm
	ON pl.customer_id = plm.project_lead_id;

SELECT 
	c.id,
    c.name,
    c.email,
    c.phone,
	COUNT(plm.id) AS number_of_calls,
    COUNT(DISTINCT pl.project_id) AS number_of_programs
FROM customers c
LEFT JOIN project_leads pl
	ON c.id=pl.customer_id
LEFT JOIN project_lead_messages plm
	ON pl.customer_id = plm.project_lead_id
GROUP BY c.id
ORDER BY number_of_programs DESC, number_of_calls DESC, name ASC;

SELECT
	 pl.project_lead_id,
    (SELECT COUNT(interest_level_log) FROM project_lead_messages WHERE project_lead_id = pl.project_lead_id AND interest_level_log >=9) AS number_of_paid
FROM project_lead_messages pl
GROUP BY pl.project_lead_id
LIMIT 2;


SELECT 
	p.id,
    p.name,
    p.start_date,
    p.end_date,
	COUNT(plm.id) AS number_of_calls,
    COUNT(DISTINCT pl.customer_id) AS number_of_customers,
    AVG(plm.interest_level_log) AS avg_interest_score
FROM project_leads pl
JOIN projects p
	ON pl.project_id=p.id
JOIN project_lead_messages plm
	ON pl.customer_id = plm.project_lead_id
GROUP BY pl.project_id
ORDER BY start_date DESC, number_of_customers DESC, number_of_calls DESC, name ASC;

SELECT 
	p.id AS project_id,
    c.id AS customer_id,
    p.name AS project,
    c.name AS customer,
    p.start_date,
	COUNT(plm.id) AS number_of_calls
    -- COUNT(DISTINCT pl.project_id) AS number_of_programs
FROM customers c
LEFT JOIN project_leads pl
	ON c.id=pl.customer_id
JOIN projects p
	ON pl.project_id=p.id
LEFT JOIN project_lead_messages plm
	ON pl.customer_id = plm.project_lead_id
GROUP BY p.id, c.id
LIMIT 10;
-- ORDER BY number_of_programs DESC, number_of_calls DESC, name ASC;

SELECT
	pl.project_id,
    pl.customer_id,
    COUNT(plm.id) AS number_of_calls
FROM project_leads pl
LEFT JOIN project_lead_messages plm
	ON pl.customer_id = plm.project_lead_id
GROUP BY pl.project_id, pl.customer_id
LIMIT 10;

SELECT COUNT(*)
FROM project_leads pl;

-- query to list those leads that were never contacted 
SELECT *
FROM project_leads pl
WHERE NOT EXISTS (
	SELECT project_lead_id
    FROM project_lead_messages
    WHERE project_lead_id = pl.id
);

SELECT COUNT(*)
FROM project_leads;

SELECT COUNT(*)
FROM (
	SELECT *
	FROM project_leads pl
	WHERE NOT EXISTS (
		SELECT project_lead_id
		FROM project_lead_messages
		WHERE project_lead_id = pl.id
)) AS missed
GROUP BY project_id;

-- above query can also be written as
SELECT 
	COUNT(DISTINCT id)
FROM project_leads pl
WHERE NOT EXISTS (
	SELECT project_lead_id
	FROM project_lead_messages
	WHERE project_lead_id = pl.id)
GROUP BY project_id;

-- WHy does this query only return one result?
SELECT campaign_name, adset_name,cs.status, AVG(c.profile), AVG(interest_level),name, COUNT(plm.project_lead_id) AS no_of_calls 
FROM `project_leads`pl 
JOIN customers c 
	ON c.id = pl.customer_id 
JOIN project_lead_messages plm 
	ON pl.customer_id = plm.project_lead_id 
JOIN call_status cs 
	ON plm.status_id = cs.id 
WHERE campaign_name LIKE '%gypsy%' 
GROUP BY name 
ORDER BY campaign_name DESC, adset_name DESC ,cs.status ASC, c.profile DESC, interest_level DESC, name ASC;

-- query to count no of calls, profile score and interest score, but doest not work until you group by c.id - why?
-- also no need to find avg of profile score and interest score because one is stored for customer in master database 
-- and the other is stored for lead in project_lead database. No log is maintained for every call
-- so the right query is after this one
SELECT 
	name, 
    (SELECT AVG(c.profile)
     FROM customers
     WHERE id = c.id) AS avg_profile_score,
     (SELECT AVG(interest_level)
     FROM project_leads
     WHERE customer_id = c.id) AS avg_interest_score,
     (SELECT COUNT(project_lead_id)
     FROM project_lead_messages
     WHERE project_lead_id = c.id) AS no_of_calls
FROM `project_leads`pl 
JOIN customers c 
 ON c.id = pl.customer_id 
JOIN project_lead_messages plm
 ON pl.customer_id = plm.project_lead_id
JOIN call_status cs
	ON plm.status_id = cs.id
WHERE campaign_name LIKE '%gypsy%'
GROUP BY c.id;
-- ORDER BY campaign_name DESC, adset_name DESC ,cs.status ASC, c.profile DESC, interest_level_log DESC, name ASC

-- also notice that in the last query and this one, no of calls can be computed without even using the select clause
SELECT 
	name, 
    c.profile AS avg_profile_score,
    interest_level,
     (SELECT AVG(interest_level_log)
     FROM project_lead_messages
     WHERE project_lead_id = c.id) AS avg_interest_score,
     COUNT(project_lead_id) AS no_of_calls
FROM `project_leads`pl 
JOIN customers c 
 ON c.id = pl.customer_id 
JOIN project_lead_messages plm
 ON pl.customer_id = plm.project_lead_id
JOIN call_status cs
	ON plm.status_id = cs.id
WHERE campaign_name LIKE '%gypsy%'
GROUP BY c.id;
-- ORDER BY campaign_name DESC, adset_name DESC ,cs.status ASC, c.profile DESC, interest_level_log DESC, name ASC

-- total leads by project

SELECT
	DISTINCT pl.project_id,
    p.name,
    p.start_date,
    COUNT(DISTINCT customer_id) AS total_leads
    -- (SELECT COUNT(DISTINCT id) FROM project_leads pl WHERE EXISTS (SELECT project_lead_id FROM project_lead_messages WHERE project_lead_id = pl.id)) AS leads_attempted
    -- (SELECT COUNT(DISTINCT project_lead_id) FROM project_lead_messages WHERE EXISTS (SELECT project_lead_id FROM project_lead_messages WHERE project_lead_id = pl.id)) AS leads_attempted
	-- (SELECT COUNT(project_lead_id) FROM project_lead_messages WHERE project_lead_id = pl.id) AS no_of_calls
FROM project_leads pl
JOIN projects p
	ON pl.project_id = p.id
GROUP BY pl.project_id
ORDER BY start_date DESC, total_leads DESC;

-- total leads called by project
SELECT 
	DISTINCT project_id,
    COUNT(DISTINCT project_lead_id) AS total_leads_called
FROM project_lead_messages plm
JOIN project_leads pl
	ON project_lead_id = pl.id
GROUP BY project_id;

-- combining above two queries
SELECT
	t1.project_id,
    t1.name,
    t1.start_date,
	t1.total_leads,
    t2.total_leads_called
FROM
	(SELECT
		DISTINCT pl.project_id,
		p.name,
		p.start_date,
		COUNT(DISTINCT customer_id) AS total_leads
	FROM project_leads pl
	JOIN projects p
		ON pl.project_id = p.id
	GROUP BY pl.project_id) t1
LEFT JOIN
		(SELECT 
			DISTINCT project_id,
			COUNT(DISTINCT project_lead_id) AS total_leads_called
		FROM project_lead_messages plm
		JOIN project_leads pl
			ON project_lead_id = pl.id
		GROUP BY project_id) t2
	USING (project_id)
    ORDER BY start_date DESC, total_leads DESC;

-- improving old query to include counts of g_profile and h_interest
SELECT
	DISTINCT pl.project_id,
    p.name,
    p.code,
    p.start_date,
    COUNT(DISTINCT customer_id) AS total_leads,
    SUM(CASE 
			WHEN interest_level BETWEEN 7 AND 10 
            THEN 1 ELSE 0 
            END) AS h_interest,
	SUM(CASE 
			WHEN profile > 5
            THEN 1 ELSE 0 
            END) AS g_profile
    -- (SELECT COUNT(DISTINCT id) FROM project_leads pl WHERE EXISTS (SELECT project_lead_id FROM project_lead_messages WHERE project_lead_id = pl.id)) AS leads_attempted
    -- (SELECT COUNT(DISTINCT project_lead_id) FROM project_lead_messages WHERE EXISTS (SELECT project_lead_id FROM project_lead_messages WHERE project_lead_id = pl.id)) AS leads_attempted
	-- (SELECT COUNT(project_lead_id) FROM project_lead_messages WHERE project_lead_id = pl.id) AS no_of_calls
FROM project_leads pl
JOIN projects p
	ON pl.project_id = p.id
JOIN customers c
	ON pl.customer_id = c.id
GROUP BY pl.project_id
ORDER BY start_date DESC, total_leads DESC;

-- counting project lead messages by call_status
SELECT 
	cs.id,
    status,
    COUNT(*)
FROM call_status cs
LEFT JOIN project_lead_messages plm
	ON cs.id = plm.status_id
GROUP BY cs.id;


-- improving old queries by combining them
SELECT
	t1.project_id,
    t1.name,
    t1.code,
    DATE(t1.start_date) AS start_date,
    CONCAT(DAYNAME(t1.start_date),DAYNAME(t1.end_date)) AS daysOfWeek,
    t1.full_name AS EL,
	t1.total_leads,
    t2.total_leads_called,
    t2.total_calls_answered,
    t1.b_profile,
    t1.g_profile,
    t1.h_interest,
    t1.PIP,
    t1.PAID
FROM
	(SELECT
		DISTINCT pl.project_id,
		p.name,
        p.code,
		p.start_date,
        p.end_date,
        a.full_name,
		COUNT(DISTINCT customer_id) AS total_leads,
        SUM(CASE 
			WHEN interest_level BETWEEN 7 AND 10 
            THEN 1 ELSE 0 
            END) AS h_interest,
		SUM(CASE 
			WHEN interest_level = 9
            THEN 1 ELSE 0 
            END) AS PIP,
		SUM(CASE 
			WHEN interest_level = 10 
            THEN 1 ELSE 0 
            END) AS Paid,
		SUM(CASE 
			WHEN profile BETWEEN 1 and 5
            THEN 1 ELSE 0 
            END) AS b_profile,
		SUM(CASE 
			WHEN profile > 5
            THEN 1 ELSE 0 
            END) AS g_profile
	FROM project_leads pl
	JOIN projects p
		ON pl.project_id = p.id
	JOIN customers c
		ON pl.customer_id = c.id
	JOIN adminstrator a
		ON p.admin_id = a.id
	GROUP BY pl.project_id) t1
LEFT JOIN
		(SELECT 
			DISTINCT project_id,
			COUNT(DISTINCT project_lead_id) AS total_leads_called,
            SUM(CASE 
				WHEN status_id = 4 
				THEN 1 ELSE 0 
				END) AS total_calls_answered
		FROM project_lead_messages plm
		JOIN project_leads pl
			ON project_lead_id = pl.id
		GROUP BY project_id) t2
	USING (project_id)
    ORDER BY start_date DESC, total_leads DESC;
    
    -- calls by call-status
    SELECT 
	cs.id,
    status,
    COUNT(*)
FROM call_status cs
LEFT JOIN project_lead_messages plm
	ON cs.id = plm.status_id
GROUP BY cs.id;

-- leads by source
SELECT
	DISTINCT SOURCE,
    COUNT(*)
FROM zorbathe_zorbath.project_leads
GROUP BY sourceprojects;

-- leads by interest level, profile score and program category
SELECT
	DISTINCT customer_id,
    c.name,
    email,
    phone,
    profile,
    -- (Select MAX(interest_level) FROM project_leads WHERE customer_id = pl.customer_id) as interest_level,
    interest_level,
    Major_Category,
    Minor_Category
FROM project_leads pl
JOIN projects p
	ON pl.project_id = p.id
JOIN zorbathe_zorbath.program_grouping pg
	USING (code)
JOIN customers c
	ON pl.customer_id = c.id;
-- WHERE profile>5 OR interest_level>6;

-- program performance by campaign and adset
SELECT
	t1.project_id,
    t1.name,
    t1.code,
    DATE(t1.start_date) AS start_date,
    CONCAT(DAYNAME(t1.start_date),DAYNAME(t1.end_date)) AS daysOfWeek,
    t1.full_name AS EL,
    t1.campaign_name,
    t1.adset_name,
	t1.total_leads,
    t2.total_leads_called,
    t2.total_calls_answered,
    t1.b_profile,
    t1.g_profile,
    t1.h_interest,
    t1.PIP,
    t1.PAID
FROM
	(SELECT
		DISTINCT pl.project_id,
		p.name,
        p.code,
		p.start_date,
        p.end_date,
        pl.campaign_name,
        pl.adset_name,
        pl.source,
        a.full_name,
		COUNT(DISTINCT customer_id) AS total_leads,
        SUM(CASE 
			WHEN interest_level BETWEEN 7 AND 10 
            THEN 1 ELSE 0 
            END) AS h_interest,
		SUM(CASE 
			WHEN interest_level = 9
            THEN 1 ELSE 0 
            END) AS PIP,
		SUM(CASE 
			WHEN interest_level = 10 
            THEN 1 ELSE 0 
            END) AS Paid,
		SUM(CASE 
			WHEN profile BETWEEN 1 and 5
            THEN 1 ELSE 0 
            END) AS b_profile,
		SUM(CASE 
			WHEN profile > 5
            THEN 1 ELSE 0 
            END) AS g_profile
	FROM project_leads pl
    JOIN projects p
		ON pl.project_id = p.id
	JOIN customers c
		ON pl.customer_id = c.id
	JOIN adminstrator a
		ON p.admin_id = a.id
	GROUP BY pl.project_id,campaign_name,adset_name
    HAVING source = 'AUTO') t1
LEFT JOIN
		(SELECT 
			DISTINCT project_id,
            pl.campaign_name,
            pl.adset_name,
            pl.source,
			COUNT(DISTINCT project_lead_id) AS total_leads_called,
            SUM(CASE 
				WHEN status_id = 4 
				THEN 1 ELSE 0 
				END) AS total_calls_answered
		FROM project_lead_messages plm
		JOIN project_leads pl
			ON project_lead_id = pl.id
		GROUP BY project_id,campaign_name,adset_name
        HAVING source='AUTO') t2
	USING (project_id,campaign_name,adset_name)
    ORDER BY start_date DESC, total_leads DESC;
    
    
    
    SELECT
		DISTINCT pl.project_id,
		p.name,
        p.code,
		p.start_date,
        p.end_date,
        pl.campaign_name,
        pl.adset_name,
        pl.source,
        a.full_name,
		COUNT(DISTINCT customer_id) AS total_leads,
        SUM(CASE 
			WHEN interest_level BETWEEN 7 AND 10 
            THEN 1 ELSE 0 
            END) AS h_interest,
		SUM(CASE 
			WHEN interest_level = 9
            THEN 1 ELSE 0 
            END) AS PIP,
		SUM(CASE 
			WHEN interest_level = 10 
            THEN 1 ELSE 0 
            END) AS Paid,
		SUM(CASE 
			WHEN profile > 5
            THEN 1 ELSE 0 
            END) AS g_profile
	FROM project_leads pl
    JOIN projects p
		ON pl.project_id = p.id
	JOIN customers c
		ON pl.customer_id = c.id
	JOIN adminstrator a
		ON p.admin_id = a.id
	GROUP BY pl.project_id,campaign_name,adset_name WITH ROLLUP;
    -- HAVING source = 'AUTO';
    
    SELECT 
			DISTINCT project_id,
            pl.campaign_name,
            pl.adset_name,
            pl.source,
			COUNT(DISTINCT project_lead_id) AS total_leads_called,
            SUM(CASE 
				WHEN status_id = 4 
				THEN 1 ELSE 0 
				END) AS total_calls_answered
		FROM project_lead_messages plm
		JOIN project_leads pl
			ON project_lead_id = pl.id
		GROUP BY project_id,campaign_name,adset_name
        HAVING source='AUTO';
   
   -- program perfomance by source
   SELECT
	t1.project_id,
    t1.name,
    t1.code,
    DATE(t1.start_date) AS start_date,
    CONCAT(DAYNAME(t1.start_date),DAYNAME(t1.end_date)) AS daysOfWeek,
    t1.full_name AS EL,
    t1.source,
	t1.total_leads,
    t2.total_leads_called,
    t2.total_calls_answered,
    t1.b_profile,
    t1.g_profile,
    t1.h_interest,
    t1.PIP,
    t1.PAID
FROM
	(SELECT
		DISTINCT pl.project_id,
		p.name,
        p.code,
		p.start_date,
        p.end_date,
        pl.source,
        a.full_name,
		COUNT(DISTINCT customer_id) AS total_leads,
        SUM(CASE 
			WHEN interest_level BETWEEN 7 AND 10 
            THEN 1 ELSE 0 
            END) AS h_interest,
		SUM(CASE 
			WHEN interest_level = 9
            THEN 1 ELSE 0 
            END) AS PIP,
		SUM(CASE 
			WHEN interest_level = 10 
            THEN 1 ELSE 0 
            END) AS Paid,
		SUM(CASE 
			WHEN profile BETWEEN 1 and 5
            THEN 1 ELSE 0 
            END) AS b_profile,
		SUM(CASE 
			WHEN profile > 5
            THEN 1 ELSE 0 
            END) AS g_profile
	FROM project_leads pl
    JOIN projects p
		ON pl.project_id = p.id
	JOIN customers c
		ON pl.customer_id = c.id
	JOIN adminstrator a
		ON p.admin_id = a.id
	GROUP BY pl.project_id,source) t1
LEFT JOIN
		(SELECT 
			DISTINCT project_id,
            pl.source,
			COUNT(DISTINCT project_lead_id) AS total_leads_called,
            SUM(CASE 
				WHEN status_id = 4 
				THEN 1 ELSE 0 
				END) AS total_calls_answered
		FROM project_lead_messages plm
		JOIN project_leads pl
			ON project_lead_id = pl.id
		GROUP BY project_id,source) t2
	USING (project_id, source)
    ORDER BY start_date DESC, total_leads DESC;
    
-- query to track lead call messages
    SELECT 
	p.name,
	p.code,
	p.start_date,
    pl.campaign_name,
    pl.adset_name,
    pl.source,
    c.name,
    c.id,
    cs.status,
    (SELECT AVG(c.profile)
     FROM customers
     WHERE id = c.id) AS avg_profile_score,
     (SELECT AVG(interest_level)
     FROM project_leads
     WHERE customer_id = c.id) AS avg_interest_score,
     (SELECT COUNT(project_lead_id)
     FROM project_lead_messages
     WHERE project_lead_id = c.id) AS no_of_calls
FROM `project_leads` pl
JOIN projects p
		ON pl.project_id = p.id 
JOIN customers c 
 ON c.id = pl.customer_id 
LEFT JOIN project_lead_messages plm
 ON pl.customer_id = plm.project_lead_id
JOIN call_status cs
	ON plm.status_id = cs.id
WHERE campaign_name LIKE '%Elemental Dance%'
GROUP BY c.id
HAVING pl.source = 'Auto'
ORDER BY p.start_date, campaign_name DESC, adset_name DESC ,cs.status ASC, c.profile DESC, interest_level_log DESC, c.name ASC;

-- query to count manual leads in a month
SELECT
	COUNT(*) AS no
FROM project_leads
WHERE source = 'Manually' AND DATE(created) BETWEEN '2020-02-01' AND '2020-02-31' ;

-- query to display manual leads across months in a particular year
SELECT
	COUNT(*) AS no
FROM project_leads
WHERE source = 'Manually' AND YEAR(created) = '2020'
GROUP BY MONTH(created);

-- query to display incoming calls by month year
SELECT 
	CONCAT(MONTH(created),YEAR(created)) AS MMYY
    , COUNT(*) AS Incoming 
FROM project_leads 
WHERE source = 'Manually' 
GROUP BY MONTH(created), YEAR(created);

-- query to get list of programs by day, month, year for gate entry sheet
SELECT 
	CONCAT(MONTH(start_date),YEAR(start_date)) AS MMYY,
    day(start_date) AS day,
	CONCAT('|',name,'|',code) AS program
    FROM projects p
    ORDER BY YEAR(start_date) ASC,MONTH(start_date) ASC;
  
  -- unsuccessful attempt to formulate query to get EL calling and tool usage statistics by joining data on project id and source as primary keys on the two tables
   SELECT
   	t1.full_name AS EL,
    CONCAT(MONTH(start_date),YEAR(start_date)) AS MMYY,
    COUNT(DISTINCT t1.code) NoOFPrograms,
	t1.total_leads,
    t2.total_leads_called,
    t2.total_calls_answered,
    t1.pro_up,
    t1.int_up,
    t1.pip_up,
    t1.paid_up
FROM
	(SELECT
		DISTINCT pl.project_id,
		p.name,
        p.code,
		p.start_date,
        p.end_date,
        pl.source,
        a.full_name,
		COUNT(DISTINCT customer_id) AS total_leads,
        SUM(CASE 
			WHEN interest_level > 0 
            THEN 1 ELSE 0 
            END) AS int_up,
		SUM(CASE 
			WHEN interest_level = 9
            THEN 1 ELSE 0 
            END) AS pip_up,
		SUM(CASE 
			WHEN interest_level = 10 
            THEN 1 ELSE 0 
            END) AS paid_up,
		SUM(CASE 
			WHEN profile > 0
            THEN 1 ELSE 0 
            END) pro_up
	FROM project_leads pl
    JOIN projects p
		ON pl.project_id = p.id
	JOIN customers c
		ON pl.customer_id = c.id
	JOIN adminstrator a
		ON p.admin_id = a.id
	GROUP BY pl.project_id,source) t1
LEFT JOIN
		(SELECT 
			DISTINCT project_id,
            pl.source,
			COUNT(DISTINCT project_lead_id) AS total_leads_called,
            SUM(CASE 
				WHEN status_id = 4 
				THEN 1 ELSE 0 
				END) AS total_calls_answered
		FROM project_lead_messages plm
		JOIN project_leads pl
			ON project_lead_id = pl.id
		GROUP BY project_id,source) t2
	USING (project_id, source)
    GROUP BY EL, MMYY
    ORDER BY  EL ASC, YEAR(start_date) ASC,MONTH(start_date) ASC;
    
    SELECT
   	t1.full_name AS EL,
    CONCAT(MONTH(start_date),YEAR(start_date)) AS MMYY,
    t1.NoOFPrograms,
	t1.total_leads,
    t2.total_leads_called,
    t2.total_calls_answered,
    t1.pro_up,
    t1.int_up,
    t1.pip_up,
    t1.paid_up
FROM
	(SELECT
		pl.adminstrator_id,
        a.full_name,
        COUNT(DISTINCT p.code) NoOFPrograms,
		COUNT(DISTINCT customer_id) AS total_leads,
        SUM(CASE 
			WHEN interest_level > 0 
            THEN 1 ELSE 0 
            END) AS int_up,
		SUM(CASE 
			WHEN interest_level = 9
            THEN 1 ELSE 0 
            END) AS pip_up,
		SUM(CASE 
			WHEN interest_level = 10 
            THEN 1 ELSE 0 
            END) AS paid_up,
		SUM(CASE 
			WHEN profile > 0
            THEN 1 ELSE 0 
            END) pro_up
	FROM project_leads pl
    JOIN projects p
		ON pl.project_id = p.id
	JOIN customers c
		ON pl.customer_id = c.id
	JOIN adminstrator a
		ON p.admin_id = a.id
	GROUP BY pl.adminstrator_id) t1
LEFT JOIN
		(SELECT 
			plm.adminstrator_id,
			COUNT(DISTINCT project_lead_id) AS total_leads_called,
            SUM(CASE 
				WHEN status_id = 4 
				THEN 1 ELSE 0 
				END) AS total_calls_answered
		FROM project_lead_messages plm
		JOIN project_leads pl
			ON project_lead_id = pl.id
		GROUP BY plm.adminstrator_id) t2
	USING (administrator_id)
    GROUP BY EL, MMYY
    ORDER BY  EL ASC, YEAR(start_date) ASC,MONTH(start_date) ASC;
    
    -- interim query to display EL calling  statistics 
    SELECT 
			plm.adminstrator_id,
            weekofyear(plm.modified) AS WW,
            -- CONCAT(MONTH(plm.modified),YEAR(plm.modified)) AS MMYY,
			COUNT(DISTINCT project_lead_id) AS total_leads_called,
            SUM(CASE 
				WHEN status_id = 4 
				THEN 1 ELSE 0 
				END) AS total_calls_answered
		FROM project_lead_messages plm
		JOIN project_leads pl
			ON project_lead_id = pl.id
		WHERE YEAR(pl.created) = '2020' AND plm.modified>pl.created
		GROUP BY plm.adminstrator_id, WW;

-- practise query to display EL calling and tool usage statistics        
SELECT
		pl.adminstrator_id,
        weekofyear(pl.modified) AS WW,
        COUNT(DISTINCT p.code) NoOFPrograms,
		COUNT(DISTINCT customer_id) AS total_leads,
        SUM(CASE 
			WHEN interest_level > 0 
            THEN 1 ELSE 0 
            END) AS int_up,
		SUM(CASE 
			WHEN interest_level = 9
            THEN 1 ELSE 0 
            END) AS pip_up,
		SUM(CASE 
			WHEN interest_level = 10 
            THEN 1 ELSE 0 
            END) AS paid_up,
		SUM(CASE 
			WHEN profile > 0
            THEN 1 ELSE 0 
            END) pro_up
	FROM project_leads pl
    LEFT JOIN projects p
		ON pl.project_id = p.id
	LEFT JOIN customers c
		ON pl.customer_id = c.id
	LEFT JOIN adminstrator a
		ON p.admin_id = a.id
	WHERE YEAR(p.start_date) = '2020'  AND pl.modified>pl.created
	GROUP BY pl.adminstrator_id, WW;
    
    SELECT
		adminstrator_id,
		COUNT(DISTINCT customer_id) AS leads_assigned,
        SUM(CASE WHEN pl.modified>pl.created AND interest_level>0 THEN 1 ELSE 0 END) AS int_up
        -- ,SUM(CASE WHEN c.modified>pl.created AND interest_level>0 THEN 1 ELSE 0 END) AS pro_up
	FROM project_leads pl
    -- LEFT JOIN customers c
		-- ON pl.customer_id = c.id
    WHERE YEAR(pl.created)='2020'
    GROUP BY adminstrator_id;
    
    -- deprecated query query to display date of first call and last call by EL to a project lead, used to capture calling compliance of ELs
    SELECT
		DISTINCT plm.project_lead_id,
        COUNT(project_lead_id) AS noOfCalls,
        adminstrator_id,
        (SELECT MIN(date(call_date_time)) FROM project_lead_messages WHERE project_lead_id = plm.project_lead_id) AS first_call,
        (SELECT MAX(date(call_date_time)) FROM project_lead_messages WHERE project_lead_id = plm.project_lead_id) AS last_call
	FROM project_lead_messages plm;
    -- WHERE id>47880;
    
    -- query to display date of first call and last call by EL to a project lead, used to capture calling compliance of ELs
    SELECT
		project_lead_id,
        adminstrator_id,
		MIN(date(call_date_time)) AS first_call,
        MAX(date(call_date_time)) AS last_call
	FROM project_lead_messages
    GROUP BY project_lead_id;
    
    -- query to find tool usage by EL
SELECT			
	WEEKOFYEAR(p.start_date) AS WW,	
	pl.adminstrator_id,	
	a.full_name,			
	COUNT(DISTINCT p.code) AS noOfPrograms,			
	COUNT(*) AS total_leads,			
	SUM(CASE WHEN lfc.adminstrator_id IS NOT NULL THEN 1 ELSE 0 END) leads_called,	
    -- (SELECT COUNT(*) FROM project_lead_messages WHERE project_lead_id = pl.id AND adminstrator_id = pl.adminstrator_id AND status = '4') AS leads_answered,
	SUM(CASE WHEN lfc.NoOfCallsAnswered>0 THEN 1 ELSE 0 END) leads_answered,	
    SUM(CASE WHEN source_thread_title IS NOT NULL THEN 1 ELSE 0 END) AS src_up,
	SUM(CASE WHEN profile>0 THEN 1 ELSE 0 END) AS pro_up,			
	SUM(CASE WHEN interest_level>0 THEN 1 ELSE 0 END) AS int_up,			
	-- SUM(CASE WHEN DATE(c.modified)>lfc.first_call OR DATE(c.created)>lfc.first_call AND profile>0 THEN 1 ELSE 0 END) AS pro_up,			
	-- SUM(CASE WHEN DATE(pl.created)>lfc.first_call OR DATE(pl.modified)>lfc.first_call AND interest_level>0 THEN 1 ELSE 0 END) AS int_up,			
	SUM(CASE WHEN interest_level = 9 THEN 1 ELSE 0 END) AS pip_up,			
	SUM(CASE WHEN interest_level = 10 THEN 1 ELSE 0	END) AS paid_up			
FROM project_leads pl
LEFT JOIN
	(SELECT 
		DISTINCT project_lead_id,
		adminstrator_id,
		(SELECT COUNT(*)
		FROM project_lead_messages
		WHERE project_lead_id = plm.project_lead_id AND project_lead_messages.status_id = 4) AS NoOfCallsAnswered
		-- ,(SELECT MIN(DATE(call_date_time)) FROM project_lead_messages WHERE project_lead_id = plm.project_lead_id) AS first_call
	FROM project_lead_messages plm
	WHERE YEAR(call_date_time) = '2020') lfc
    ON pl.id = project_lead_id			
LEFT JOIN customers c
	ON pl.customer_id = c.id
LEFT JOIN projects p
	ON pl.project_id = p.id
LEFT JOIN adminstrator a
	ON pl.adminstrator_id = a.id
WHERE YEAR(p.start_date)='2020'
GROUP BY WW, pl.adminstrator_id
HAVING WW > WEEKOFYEAR(NOW())-3
ORDER BY WW ASC, full_name ASC;

-- SELECT * FROM project_leads pl
-- LEFT JOIN (
	SELECT 
		DISTINCT project_lead_id,
		adminstrator_id,
		(SELECT COUNT(*)
		FROM project_lead_messages
		WHERE project_lead_id = plm.project_lead_id AND project_lead_messages.status_id = 4) AS NoOfCallsAnswered
		-- ,(SELECT MIN(DATE(call_date_time)) FROM project_lead_messages WHERE project_lead_id = plm.project_lead_id) AS first_call
	FROM project_lead_messages plm
	WHERE YEAR(call_date_time) = '2020';
    -- ) plm ON pl.id= project_lead_id;

-- query to get table values where created date higher than modified date
	SELECT *
	FROM project_leads
	WHERE created > modified;

-- query to get lead details by program category
SELECT
	DISTINCT customer_id,
    c.name,
    email,
    phone,
    profile,
    interest_level,
    Major_Category,
    Minor_Category
FROM project_leads pl
JOIN projects p
	ON pl.project_id = p.id
JOIN zorbathe_zorbath.program_grouping pg
	USING (code)
JOIN customers c
	ON pl.customer_id = c.id
WHERE start_date BETWEEN '2019-12-25' AND '2020-02-05'

-- unsuccessful query to match leads with gate visitor data using partial email match
UPDATE customers
SET customers.email_check = zorba_visitors.EMAIL
FROM customers
INNER JOIN zorba_visitors 
	ON zorba_visitors.EMAIL LIKE CONCAT('%',customers.email,'%');

-- another query to match leads with gate visitor data using partial email match
SELECT
	c.name,
    c.email,
    c.phone,
    zv.EMAIL,
    zv.NAME,
    zv.PHONENUMBER
FROM customers c
INNER JOIN zorba_visitors zv
	ON zv.EMAIL LIKE CONCAT('%',c.email,'%');

-- testing sub queries to get aggregated details of EL calling performance
-- 1
SELECT 
	adminstrator_id,
    project_lead_id,
	COUNT(*) AS NoOfCalls	
FROM zorbathe_zorbath2.project_lead_messages
GROUP BY adminstrator_id,project_lead_id;

-- 2 
SELECT 
	date(call_date_time) AS date,
	adminstrator_id,
	COUNT(*) AS NoOfCalls,
	COUNT(DISTINCT project_lead_id) AS NoOfLeadsAttempted,
    SUM(CASE 
				WHEN status_id = 4 
				THEN 1 ELSE 0 
				END) AS total_calls_answered,
FROM zorbathe_zorbath2.project_lead_messages
GROUP BY date,adminstrator_id;

-- query to aggregate lead quality by month
SELECT	
		monthname(start_date) AS month,
		SUM(CASE 
			WHEN interest_level BETWEEN 7 AND 10 
            THEN 1 ELSE 0 
            END) AS h_interest,
		SUM(CASE 
			WHEN interest_level = 9
            THEN 1 ELSE 0 
            END) AS PIP,
		SUM(CASE 
			WHEN interest_level = 10 
            THEN 1 ELSE 0 
            END) AS Paid
FROM zorbathe_zorbath2.project_leads pl
join projects p
	ON pl.project_id = p.id
where start_date between '2019-2-1' AND '2020-2-28'
group by month;

-- query to get program details concatenated for NAZIA's file
SELECT 
	CONCAT(MONTH(start_date),YEAR(start_date)) AS MMYY,
    day(start_date) AS day,
	CONCAT('|',name,'|',code) AS program
    FROM projects p
    ORDER BY YEAR(start_date) ASC,MONTH(start_date) ASC;

-- query to check if same leads are being called by multiple ELs
SELECT 
	DISTINCT project_lead_id,
    COUNT(DISTINCT adminstrator_id) AS cnt
    FROM zorbathe_zorbath2.project_lead_messages
    GROUP BY project_lead_id
    ORDER BY cnt DESC;

SELECT *
FROM project_leads pl
JOIN customers c
	ON pl.customer_id = c.id
LEFT JOIN source_thread st
	ON c.source_thread_title = st.id
WHERE 
	(adminstrator_id = 246 OR adminstrator_id = 267)  
    AND source_thread_title IS NOT NULL 
    AND (pl.source = 'Organic' or pl.source = 'Manually') 
    AND(date(pl.created)>'2020-02-25' OR date(pl.modified)>'2020-02-25') ;
    
    
-- I Dashboard
-- a Unassigned Leads
CREATE OR REPLACE VIEW display_programs_with_unassigned_leads AS
SELECT 
	pl.project_id
	, name
    , code
    , start_date
    , end_date
    , COUNT(*) AS total_leads
    , SUM(CASE 
		WHEN assiged_date IS NULL
		THEN 1 ELSE 0 
		END) AS Unassigned
FROM project_leads pl
JOIN projects p
	ON pl.project_id = p.id
GROUP BY project_id
HAVING YEAR(start_date)>=2019 AND Unassigned>0;

-- II Manage Team
-- a fetch team member list
-- can be packaged as a view
CREATE OR REPLACE VIEW manage_team AS
SELECT 
		full_name AS name
        , email
        , role
        , status
        , created
FROM adminstrator;

-- b team member details edit
-- b.1 get specific team-member details:
DROP PROCEDURE IF EXISTS get_team_member_details;
DELIMITER $$
	CREATE PROCEDURE get_team_member_details
    (
		id INT(11)
    )
    BEGIN
		SELECT
			full_name AS name
			, email
            , status
            , password
        FROM adminstrator a
        WHERE a.id = id;
	END$$
DELIMITER ;

-- to check above procedure
CALL get_team_member_details(264); 

-- b.2 to update team_member_details
DROP PROCEDURE IF EXISTS update_team_member_details;
DELIMITER $$
CREATE PROCEDURE update_team_member_details
(
	id INT(11)
	, name VARCHAR(50)
    , email VARCHAR(255)
    , status VARCHAR(50)
    , password VARCHAR(50)
    
)
BEGIN
    UPDATE	adminstrator a
	SET a.full_name = IFNULL(name,a.full_name), 
		a.email = IFNULL(email,a.email),
        a.status = IFNULL(status, a.status),
        a.password = IFNULL(password, a.password)
	WHERE a.id = id;
END$$
DELIMITER ;

-- b.3 to add new team_member_details
DROP PROCEDURE IF EXISTS add_new_team_member;
DELIMITER $$
CREATE PROCEDURE add_new_team_member
(
	name VARCHAR(50)
    , email VARCHAR(255)
    , password VARCHAR(50)
    , status ENUM('Active','Inactive')
    
)
BEGIN
    INSERT INTO	adminstrator (full_name, email, status, password)
	VALUES (name, email, status, password);
END$$
DELIMITER ;


-- to check above procedures
CALL update_team_member_details(264, NULL, 'agent2.soulilution@gmail.com', NULL, NULL);
CALL add_new_team_member('Barkha2', 'barkha2@gmail.com', 'pass123', 'Inactive');

-- b.4 to delete a team member
-- better to delete from view or mark as inactive?
DELETE FROM administrator
WHERE id = $;


-- III Manage Program
-- a program list
CREATE OR REPLACE VIEW manage_program AS
SELECT 
		p.id
		, p.name
        , code
        , p.category
        , auto_assign
        , a.full_name as supervisor
        , admin_id AS Enrollment_leads 
        , checklist_is_done
        , ch_t.title AS type
        , start_date
        , end_date
FROM projects p
JOIN category c
	ON p.category = c.id
JOIN checklist_types ch_t
	ON p.ch_type = ch_t.id
JOIN adminstrator a
	ON p.supervisor_id = a.id;

-- b new program
DROP PROCEDURE IF EXISTS add_new_program;
DELIMITER $$
CREATE PROCEDURE add_new_program(
	name VARCHAR(50)
    , code VARCHAR(50)
    , auto_assign ENUM('Yes','No')
    , type_id INT(2)
    , category_id INT(2)
    , el_ids VARCHAR(50)
    , start_date DATE
    , end_date DATE
    , patra_link TEXT
    , added_by_id INT
	)
BEGIN
	INSERT INTO projects (name, code, auto_assign, ch_type, category, admin_id, start_date, end_date, patra, added_by_id)
    VALUES (name, code, auto_assign, type_id, category_id, el_ids, start_date, end_date, patra_link, added_by_id);
END$$

DELIMITER ;

-- check procedure
CALL  add_new_program('abc', 'abc123', 'No', 3, 4, '224,334', '2021-02-28', '2021-03-29', 'http://www.xyz.com', 223);

-- c edit program

-- IV Manage customer
-- a customer list : with  name, email, phone, gender, banned, profile, source thread, project

-- b new customer: with name, email, phone, gender selector , profile score selection and source thread selection
			-- use last 10 digits of phone no. to check if record exists, if it does, update same record, else insert new record
DROP PROCEDURE IF EXISTS add_new_customer;
DELIMITER $$
CREATE PROCEDURE add_new_customer(
	name VARCHAR(50)
    , email VARCHAR(255)
    , phone VARCHAR(255)
    , gender ENUM('Male','Female')
    , profile_score INT
    , source_thread_id INT
    -- , OUT id_checker INT
	)
BEGIN
	DECLARE id_check INT;
    
    SELECT DISTINCT c.id INTO id_check FROM customers c WHERE c.phone LIKE CONCAT('%', RIGHT(phone,10), '%');
    
    IF id_check IS NULL
    THEN
		INSERT INTO customers (name, email, gender, phone,profile,source_thread_title)
		VALUES (name, email, gender, phone,profile_score,source_thread_id);
	ELSE
		UPDATE customers c
        SET  c.name = name, c.email = email, c.gender=gender, c.phone = CONCAT(c.phone,',',phone),c.profile=profile,c.source_thread_title=source_thread_id
        WHERE c.id = id_check;
	END IF;
END$$
DELIMITER ;

-- check procedures
CALL add_new_customer('Neeti2', 'chanananeeti@gmail.com', '919599620671', 'Female', 0, '1');
CALL add_new_customer('Jeeti', 'chananajeeti@gmail.com', '919599699971', 'Male', 0, '1');
CALL add_new_customer('Mitu mani', 'mitumani8@gmail.com', '919582299449', 'Male', 8, '1');
-- test value id = 17598 phones = 9582299449,919582299449
CALL add_new_customer('Shankar', 'shankar040996@gmail.com', '918851589463', 'Male', 0, '1');
-- test value id = 11558 phones = 8851589463

SET @id_checker = 0;
CALL add_new_customer('Neeti2', 'chanananeeti@gmail.com', '919599620671', 'Female', 0, '1', @id_checker);
SELECT @id_checker;

SET @phone = '919599620671';
SELECT c.id FROM customers c WHERE c.phone LIKE CONCAT('%', @phone, '%');

SET @phone = '919582299449';
SELECT * FROM customers c WHERE c.phone LIKE CONCAT('%', RIGHT(@phone,10), '%');


SELECT * FROM customers c WHERE c.name LIKE CONCAT('%', 'shankar');

-- c add as lead: with select program (list) and assign to (el) and interest level and campaign name and adset name
				-- depending on where this procedure is called from, the campaign, source etc will be set accordingly
DROP PROCEDURE IF EXISTS add_customer_as_lead;

DELIMITER $$
CREATE PROCEDURE add_customer_as_lead(
	cust_id INT(11)
    , proj_id INT(11)
    , source VARCHAR(50)
    , camp_name VARCHAR(50)
    , ad_name VARCHAR(50)
    , platform VARCHAR(50)
    , create_date DATE
	, mod_date DATE
)
BEGIN
	INSERT INTO project_leads(customer_id , project_id, source, campaign_name, ad_name, platform, created, modified)
    VALUES (cust_id, proj_id, source, camp_name, ad_name, platform, create_date, mod_date );
END$$
DELIMITER ;

-- test procedure
CALL add_customer_as_lead(66698, 18, 'Manually', 'Test', 'Test', 'None', '2020-05-29', '0000-00-00'); 

-- V Manage Leads
-- a records: interest score, profile score, cutomer details (n,e, gender, ph no,lead datetime), 
				-- program name, assigned el name and assigned date, source,
				-- campaign name, adset name, source thread
                -- call logs, call status, call date and time, followup date and time, interest level, called by
                -- material sent
-- b add program lead: call new customer and add as lead
-- c assign and unassign leads
				-- call manage program view and change or assign enrollment lead
DELIMITER $$
CREATE PROCEDURE assign_lead_to_el(
	cust_id INT(11)
    , prog_id INT
    , el_id INT(11)
    , assigned_date DATE
    , mod_date DATETIME
)
BEGIN
	UPDATE project_leads pl
    SET pl.adminstrator_id = el_id, pl.assiged_date = assigned_date, pl.modified = mod_date
    WHERE pl.customer_id = cust_id and pl.project_id = prog_id;
END$$
DELIMITER ;

-- test procedure
CALL assign_lead_to_el(66698, 18, '234', '2020-05-29', '0000-00-00 00:00:00'); 
                
-- V Reports:
	-- Program report by program name, enrolment lead, from date and to date, paginated by source
			-- total leads, not called, called once, called more than once, follow-up, officng, hi, pip, paid
    -- EL report by program name, el name and from date and to date
			-- for different call status