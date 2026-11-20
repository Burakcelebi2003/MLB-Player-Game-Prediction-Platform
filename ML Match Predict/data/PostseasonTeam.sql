use Rays
select * from PostseasonTeam

select count(distinct team_id) as [Takým Sayýsý] from PostseasonTeam;

select team_id AS [Takým],
COUNT(*) AS [Playoff Katýlým Sayýsý]
FROM PostseasonTeam
WHERE postseasona_gidis = 1
GROUP BY team_id
ORDER BY [Playoff Katýlým Sayýsý] DESC;

select team_id AS [Takým],
COUNT(*) AS [Þampiyonluk Sayýsý]
FROM PostseasonTeam
WHERE ws_sampiyon = 1
GROUP BY team_id
ORDER BY [Þampiyonluk Sayýsý] DESC;

SELECT COUNT(*) AS [Þampiyon Sayýsý],
ROUND(AVG(postseaon_wrc_plus), 2) AS [Þampiyonlarýn wRC+ Ortalamasý],
MIN(postseaon_wrc_plus) AS [En Düþük wRC+],
MAX(postseaon_wrc_plus) AS [En Yüksek wRC+]
FROM PostseasonTeam
WHERE ws_sampiyon = 1;

SELECT * from PostseasonTeam
WHERE postseasona_gidis = 1 and ws_sampiyon = 1;

select sezon as [Sezon],
    team_id AS "Takým",
    postseaon_wrc_plus AS "wRC+",
    dereceler_toplami AS "Maç Sayýsý",
    ERA AS "ERA",
    FIP AS "FIP"
FROM PostseasonTeam
WHERE ws_sampiyon = 1
ORDER BY postseaon_wrc_plus DESC;

select sezon as [Sezon],
    team_id AS "Takým",
    postseaon_wrc_plus AS "wRC+",
    dereceler_toplami AS "Maç Sayýsý",
    ERA AS "ERA",
    FIP AS "FIP"
FROM PostseasonTeam
WHERE ws_sampiyon = 1
ORDER BY ERA asc;

SELECT team_id AS "Takým",
COUNT(*) AS "Þampiyon Sezon Sayýsý",
ROUND(AVG(postseaon_wrc_plus), 2) AS "wRC+ Ort.",
ROUND(AVG(ERA), 2) AS "ERA Ort."
FROM PostseasonTeam
WHERE ws_sampiyon = 1
GROUP BY team_id, ws_sampiyon
ORDER BY "ERA Ort." asc;

SELECT team_id AS "Takým",
COUNT(*) AS "Playoffa Gidiþ Sayýsý",
ROUND(AVG(postseaon_wrc_plus), 2) AS "wRC+ Ort.",
ROUND(AVG(ERA), 2) AS "ERA Ort.",
ROUND(AVG(FIP), 2) AS "FIP Ort."
FROM PostseasonTeam
WHERE postseasona_gidis = 1
GROUP BY team_id, postseasona_gidis
ORDER BY "wRC+ Ort." desc;

SELECT team_id AS "Takým",
COUNT(CASE WHEN postseasona_gidis = 1 THEN 1 END) AS "Postseasona Gidiþ Sayýsý",
COUNT(CASE WHEN ws_sampiyon = 1 THEN 1 END) AS "Þampiyonluk Sayýsý",
ROUND(AVG(dereceler_toplami), 1) AS "Ort. Maç Sayýsý",
ROUND(AVG(postseaon_wrc_plus), 2) AS "Ort. wRC+",
ROUND(AVG(ERA), 2) AS "Ort. ERA",
ROUND(AVG(FIP), 2) AS "Ort. FIP"
FROM PostseasonTeam
GROUP BY team_id
order by "Þampiyonluk Sayýsý" desc;

SELECT team_id AS "Takým",
COUNT(*) AS "Toplam Sezon Sayýsý",
COUNT(CASE WHEN postseasona_gidis = 1 THEN 1 END) AS "Postseasona Gidiþ Sayýsý",
COUNT(CASE WHEN ws_sampiyon = 1 THEN 1 END) AS "Þampiyonluk Sayýsý",
ROUND(AVG(dereceler_toplami), 1) AS "Ort. Maç Sayýsý",
ROUND(AVG(postseaon_wrc_plus), 2) AS "Ort. wRC+",
ROUND(AVG(ERA), 2) AS "Ort. ERA",
ROUND(AVG(FIP), 2) AS "Ort. FIP"
FROM PostseasonTeam
WHERE ERA < 4 and FIP < 4 and ws_sampiyon = 1
GROUP BY team_id
order by "Ort. wRC+" desc;

SELECT team_id AS "Takým",
COUNT(*) AS "Postseasona Gidiþ Sayýsý",
COUNT(CASE WHEN ws_sampiyon = 1 THEN 1 END) AS "Þampiyonluk Sayýsý",
ROUND(AVG(dereceler_toplami), 2) AS "Ortalama Maç Sayýsý",
ROUND(AVG(postseaon_wrc_plus), 2) AS "wRC+ Ort.",
ROUND(AVG(ERA), 2) AS "ERA",
ROUND(AVG(FIP), 2) AS "FIP"
FROM PostseasonTeam
WHERE team_id IN ('Rays', 'Brewers') and postseasona_gidis = 1
GROUP BY team_id
ORDER BY "Þampiyonluk Sayýsý" DESC;


WITH [Takým Çýktýlarý] AS (
SELECT team_id AS Takim,
COUNT(CASE WHEN postseasona_gidis = 1 THEN 1 END) AS Postseason_Sayisi,
SUM(CAST(ws_sampiyon AS INT)) AS Sampiyonluk_Sayisi,
AVG(CAST(dereceler_toplami AS FLOAT)) AS Ort_Mac,
AVG(CAST(postseaon_wrc_plus AS FLOAT)) AS Ort_WRC,
AVG(CAST(REPLACE(ERA, ',', '.') AS FLOAT)) AS Ort_ERA,
AVG(CAST(REPLACE(FIP, ',', '.') AS FLOAT)) AS Ort_FIP
FROM PostseasonTeam
WHERE team_id IN ('Rays', 'Brewers')
GROUP BY team_id
)
SELECT 
    Takim,
    Postseason_Sayisi,
    Sampiyonluk_Sayisi,
    ROUND(Ort_Mac, 2) AS Ort_Mac,
    ROUND(Ort_WRC, 2) AS Ort_WRC,
    ROUND(Ort_ERA, 2) AS Ort_ERA,
    ROUND(Ort_FIP, 2) AS Ort_FIP,
    RANK() OVER (ORDER BY Postseason_Sayisi DESC) AS Rank_Postseason,
    RANK() OVER (ORDER BY Sampiyonluk_Sayisi DESC) AS Rank_Sampiyonluk,
    RANK() OVER (ORDER BY Ort_Mac DESC) AS Rank_Mac,
    RANK() OVER (ORDER BY Ort_WRC DESC) AS Rank_WRC,
    RANK() OVER (ORDER BY Ort_ERA ASC) AS Rank_ERA,
    RANK() OVER (ORDER BY Ort_FIP ASC) AS Rank_FIP
FROM [Takým Çýktýlarý];


WITH [Takým Çýktýlarý] AS (
SELECT team_id,
COUNT(CASE WHEN postseasona_gidis = 1 THEN 1 END) AS postseason_sayisi,
SUM(CAST(ws_sampiyon AS INT)) AS sampiyonluk_sayisi,
AVG(CAST(dereceler_toplami AS FLOAT)) AS ort_mac,
AVG(CAST(postseaon_wrc_plus AS FLOAT)) AS ort_wrc,
AVG(CAST(REPLACE(ERA, ',', '.') AS FLOAT)) AS ort_era,
AVG(CAST(REPLACE(FIP, ',', '.') AS FLOAT)) AS ort_fip
FROM PostseasonTeam
WHERE team_id IN ('Rays', 'Brewers')
GROUP BY team_id
),
Pivoted AS (
SELECT 
MAX(CASE WHEN team_id = 'Rays' THEN postseason_sayisi END) AS Rays_PS,
MAX(CASE WHEN team_id = 'Brewers' THEN postseason_sayisi END) AS Brewers_PS,
MAX(CASE WHEN team_id = 'Rays' THEN sampiyonluk_sayisi END) AS Rays_WS,
MAX(CASE WHEN team_id = 'Brewers' THEN sampiyonluk_sayisi END) AS Brewers_WS,     
MAX(CASE WHEN team_id = 'Rays' THEN ort_mac END) AS Rays_Mac,
MAX(CASE WHEN team_id = 'Brewers' THEN ort_mac END) AS Brewers_Mac,
MAX(CASE WHEN team_id = 'Rays' THEN ort_wrc END) AS Rays_WRC,
MAX(CASE WHEN team_id = 'Brewers' THEN ort_wrc END) AS Brewers_WRC,
MAX(CASE WHEN team_id = 'Rays' THEN ort_era END) AS Rays_ERA,
MAX(CASE WHEN team_id = 'Brewers' THEN ort_era END) AS Brewers_ERA,
MAX(CASE WHEN team_id = 'Rays' THEN ort_fip END) AS Rays_FIP,
MAX(CASE WHEN team_id = 'Brewers' THEN ort_fip END) AS Brewers_FIP
FROM [Takým Çýktýlarý])
SELECT 'Postseason Katýlýmý' AS Metrik, Rays_PS AS Rays, Brewers_PS AS Brewers,
CASE 
WHEN Rays_PS > Brewers_PS THEN 'Rays'
WHEN Brewers_PS > Rays_PS THEN 'Brewers'
ELSE 'Eþit'
END AS Üstünlük
FROM Pivoted

UNION ALL

SELECT 'Þampiyonluk Sayýsý', Rays_WS, Brewers_WS,
       CASE 
           WHEN Rays_WS > Brewers_WS THEN 'Rays'
           WHEN Brewers_WS > Rays_WS THEN 'Brewers'
           ELSE 'Eþit'
       END
FROM Pivoted

UNION ALL

SELECT 'Ortalama Maç Sayýsý', ROUND(Rays_Mac, 2), ROUND(Brewers_Mac, 2),
       CASE 
           WHEN Rays_Mac > Brewers_Mac THEN 'Rays'
           WHEN Brewers_Mac > Rays_Mac THEN 'Brewers'
           ELSE 'Eþit'
       END
FROM Pivoted

UNION ALL

SELECT 'wRC+ Ort.', ROUND(Rays_WRC, 2), ROUND(Brewers_WRC, 2),
       CASE 
           WHEN Rays_WRC > Brewers_WRC THEN 'Rays'
           WHEN Brewers_WRC > Rays_WRC THEN 'Brewers'
           ELSE 'Eþit'
       END
FROM Pivoted

UNION ALL

SELECT 'ERA Ort.', ROUND(Rays_ERA, 2), ROUND(Brewers_ERA, 2),
       CASE 
           WHEN Rays_ERA < Brewers_ERA THEN 'Rays' -- ERA'da düþük olan iyidir
           WHEN Brewers_ERA < Rays_ERA THEN 'Brewers'
           ELSE 'Eþit'
       END
FROM Pivoted

UNION ALL

SELECT 'FIP Ort.', ROUND(Rays_FIP, 2), ROUND(Brewers_FIP, 2),
       CASE 
           WHEN Rays_FIP < Brewers_FIP THEN 'Rays' -- FIP'te düþük olan iyidir
           WHEN Brewers_FIP < Rays_FIP THEN 'Brewers'
           ELSE 'Eþit'
       END
FROM Pivoted;