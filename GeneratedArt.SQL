/*
Created: 10.05.2026
Modified: 10.05.2026
Model: Microsoft SQL Server 2019
Database: MS SQL Server 2019
*/
use master
go

if exists (select 1 from sys.databases where name = 'ArtGallery')
begin 
   alter database ArtGallery set single_user with rollback immediate; 
   drop database ArtGallery;

end

create database ArtGallery;
go

use ArtGallery;
go


-- Create tables section -------------------------------------------------

-- Table Artist

CREATE TABLE [Artist]
(
 [ArtistID] Int NOT NULL,
 [Name] Nvarchar(50) NOT NULL,
 [Country] Nvarchar(30) NOT NULL,
 CONSTRAINT [PK_Artist] PRIMARY KEY ([ArtistID])
)
AS NODE
go

-- Table Painting

CREATE TABLE [Painting]
(
 [PaintingID] Int NOT NULL,
 [Name] Nvarchar(50) NOT NULL,
 [Year] Date NULL,
 [Style] Nvarchar(30) NOT NULL,
 CONSTRAINT [PK_Painting] PRIMARY KEY ([PaintingID])
)
AS NODE
go

-- Table Exhibition

CREATE TABLE [Exhibition]
(
 [ExhibitionID] Int NOT NULL,
 [Name] Nvarchar(100) NOT NULL,
 [City] Nvarchar(50) NOT NULL,
 [Date] Date NOT NULL,
 CONSTRAINT [PK_Exhibition] PRIMARY KEY ([ExhibitionID])
)
AS NODE
go

-- Table CreatedBy

CREATE TABLE [CreatedBy]
(
 [Commission] Money DEFAULT 0 NOT NULL
)
AS EDGE
go

-- Add connection constraints for table CreatedBy

ALTER TABLE [CreatedBy] ADD CONSTRAINT [CBC_Artist_Painting] CONNECTION (
  [Artist] TO [Painting])
go

-- Table OwnedBy

CREATE TABLE [OwnedBy]
(
 [InsuranceValue] Money DEFAULT 0 NOT NULL
)
AS EDGE
go

-- Add connection constraints for table OwnedBy

ALTER TABLE [OwnedBy] ADD CONSTRAINT [OBC_Painting_Exhibition] CONNECTION (
  [Painting] TO [Exhibition])
go

-- Table OrganizedBy

CREATE TABLE [OrganizedBy]
(
 [Fee] Money DEFAULT 0 NOT NULL
)
AS EDGE
go

-- Add connection constraints for table OrganizedBy

ALTER TABLE [OrganizedBy] ADD CONSTRAINT [OBC_Artist_Exhibition] CONNECTION (
  [Artist] TO [Exhibition])
go


-- =============================================
-- ЗАПОЛНЯЕМ Artist (3 художника)
-- =============================================

INSERT INTO [Artist] ([ArtistID], [Name], [Country]) VALUES
(1, 'Винсент Ван Гог', 'Нидерланды'),
(2, 'Иван Айвазовский', 'Россия'),
(3, 'Пабло Пикассо', 'Испания');


-- =============================================
-- ЗАПОЛНЯЕМ Painting (17 картин)
-- =============================================

INSERT INTO [Painting] ([PaintingID], [Name], [Year], [Style]) VALUES
-- Ван Гог (7 картин)
(1, 'Звездная ночь', '1889-06-01', 'Постимпрессионизм'),
(2, 'Подсолнухи', '1888-08-01', 'Постимпрессионизм'),
(3, 'Ирисы', '1889-05-01', 'Постимпрессионизм'),
(4, 'Спальня в Арле', '1888-10-01', 'Постимпрессионизм'),
(5, 'Автопортрет с отрезанным ухом', '1889-01-01', 'Постимпрессионизм'),
(6, 'Ночная терраса кафе', '1888-09-01', 'Постимпрессионизм'),
(7, 'Едоки картофеля', '1885-04-01', 'Реализм'),

-- Айвазовский (5 картин)
(8, 'Девятый вал', '1850-01-01', 'Романтизм'),
(9, 'Черное море', '1881-01-01', 'Романтизм'),
(10, 'Радуга', '1873-01-01', 'Романтизм'),
(11, 'Лунная ночь на Босфоре', '1894-01-01', 'Романтизм'),
(12, 'Буря', '1886-01-01', 'Романтизм'),

-- Пикассо (5 картин)
(13, 'Герника', '1937-01-01', 'Кубизм'),
(14, 'Авиньонские девицы', '1907-01-01', 'Кубизм'),
(15, 'Девочка на шаре', '1905-01-01', 'Розовый период'),
(16, 'Плачущая женщина', '1937-01-01', 'Кубизм'),
(17, 'Три музыканта', '1921-01-01', 'Кубизм');


-- =============================================
-- ЗАПОЛНЯЕМ Exhibition (5 выставок)
-- =============================================

INSERT INTO [Exhibition] ([ExhibitionID], [Name], [City], [Date]) VALUES
(1, 'Постимпрессионизм: Ван Гог и современники', 'Париж', '2024-06-01'),
(2, 'Маринисты: искусство моря', 'Санкт-Петербург', '2024-07-15'),
(3, 'Пикассо: от кубизма к сюрреализму', 'Барселона', '2024-08-10'),
(4, 'Шедевры мирового искусства', 'Лондон', '2024-09-20'),
(5, 'Золотая осень живописи', 'Москва', '2024-10-01');


-- =============================================
-- 1. ЗАПОЛНЯЕМ CreatedBy (Artist -> Painting)
-- =============================================

DECLARE @artist_node_id NVARCHAR(1000);
DECLARE @painting_node_id NVARCHAR(1000);

-- Ван Гог (ArtistID=1) -> его 7 картин
SET @artist_node_id = (SELECT $node_id FROM [Artist] WHERE ArtistID = 1);

SET @painting_node_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 1);
INSERT INTO [CreatedBy] ($from_id, $to_id, Commission) VALUES (@artist_node_id, @painting_node_id, 10000000);

SET @painting_node_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 2);
INSERT INTO [CreatedBy] ($from_id, $to_id, Commission) VALUES (@artist_node_id, @painting_node_id, 8500000);

SET @painting_node_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 3);
INSERT INTO [CreatedBy] ($from_id, $to_id, Commission) VALUES (@artist_node_id, @painting_node_id, 9000000);

SET @painting_node_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 4);
INSERT INTO [CreatedBy] ($from_id, $to_id, Commission) VALUES (@artist_node_id, @painting_node_id, 7000000);

SET @painting_node_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 5);
INSERT INTO [CreatedBy] ($from_id, $to_id, Commission) VALUES (@artist_node_id, @painting_node_id, 6000000);

SET @painting_node_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 6);
INSERT INTO [CreatedBy] ($from_id, $to_id, Commission) VALUES (@artist_node_id, @painting_node_id, 7500000);

SET @painting_node_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 7);
INSERT INTO [CreatedBy] ($from_id, $to_id, Commission) VALUES (@artist_node_id, @painting_node_id, 5000000);

-- Айвазовский (ArtistID=2) -> его 5 картин
SET @artist_node_id = (SELECT $node_id FROM [Artist] WHERE ArtistID = 2);

SET @painting_node_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 8);
INSERT INTO [CreatedBy] ($from_id, $to_id, Commission) VALUES (@artist_node_id, @painting_node_id, 12000000);

SET @painting_node_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 9);
INSERT INTO [CreatedBy] ($from_id, $to_id, Commission) VALUES (@artist_node_id, @painting_node_id, 8000000);

SET @painting_node_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 10);
INSERT INTO [CreatedBy] ($from_id, $to_id, Commission) VALUES (@artist_node_id, @painting_node_id, 6500000);

SET @painting_node_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 11);
INSERT INTO [CreatedBy] ($from_id, $to_id, Commission) VALUES (@artist_node_id, @painting_node_id, 7000000);

SET @painting_node_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 12);
INSERT INTO [CreatedBy] ($from_id, $to_id, Commission) VALUES (@artist_node_id, @painting_node_id, 5500000);

-- Пикассо (ArtistID=3) -> его 5 картин
SET @artist_node_id = (SELECT $node_id FROM [Artist] WHERE ArtistID = 3);

SET @painting_node_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 13);
INSERT INTO [CreatedBy] ($from_id, $to_id, Commission) VALUES (@artist_node_id, @painting_node_id, 25000000);

SET @painting_node_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 14);
INSERT INTO [CreatedBy] ($from_id, $to_id, Commission) VALUES (@artist_node_id, @painting_node_id, 20000000);

SET @painting_node_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 15);
INSERT INTO [CreatedBy] ($from_id, $to_id, Commission) VALUES (@artist_node_id, @painting_node_id, 15000000);

SET @painting_node_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 16);
INSERT INTO [CreatedBy] ($from_id, $to_id, Commission) VALUES (@artist_node_id, @painting_node_id, 18000000);

SET @painting_node_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 17);
INSERT INTO [CreatedBy] ($from_id, $to_id, Commission) VALUES (@artist_node_id, @painting_node_id, 16000000);


-- =============================================
-- 2. ЗАПОЛНЯЕМ OwnedBy (Painting -> Exhibition)
-- =============================================

DECLARE @painting_id NVARCHAR(1000);
DECLARE @exhibition_id NVARCHAR(1000);

-- Выставка 1 (Постимпрессионизм) -> картины Ван Гога
SET @exhibition_id = (SELECT $node_id FROM [Exhibition] WHERE ExhibitionID = 1);

SET @painting_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 1);
INSERT INTO [OwnedBy] ($from_id, $to_id, InsuranceValue) VALUES (@painting_id, @exhibition_id, 50000000);

SET @painting_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 2);
INSERT INTO [OwnedBy] ($from_id, $to_id, InsuranceValue) VALUES (@painting_id, @exhibition_id, 45000000);

SET @painting_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 3);
INSERT INTO [OwnedBy] ($from_id, $to_id, InsuranceValue) VALUES (@painting_id, @exhibition_id, 48000000);

SET @painting_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 6);
INSERT INTO [OwnedBy] ($from_id, $to_id, InsuranceValue) VALUES (@painting_id, @exhibition_id, 40000000);

-- Выставка 2 (Маринисты) -> картины Айвазовского
SET @exhibition_id = (SELECT $node_id FROM [Exhibition] WHERE ExhibitionID = 2);

SET @painting_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 8);
INSERT INTO [OwnedBy] ($from_id, $to_id, InsuranceValue) VALUES (@painting_id, @exhibition_id, 60000000);

SET @painting_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 9);
INSERT INTO [OwnedBy] ($from_id, $to_id, InsuranceValue) VALUES (@painting_id, @exhibition_id, 40000000);

SET @painting_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 11);
INSERT INTO [OwnedBy] ($from_id, $to_id, InsuranceValue) VALUES (@painting_id, @exhibition_id, 35000000);

-- Выставка 3 (Пикассо) -> картины Пикассо
SET @exhibition_id = (SELECT $node_id FROM [Exhibition] WHERE ExhibitionID = 3);

SET @painting_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 13);
INSERT INTO [OwnedBy] ($from_id, $to_id, InsuranceValue) VALUES (@painting_id, @exhibition_id, 120000000);

SET @painting_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 14);
INSERT INTO [OwnedBy] ($from_id, $to_id, InsuranceValue) VALUES (@painting_id, @exhibition_id, 100000000);

SET @painting_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 16);
INSERT INTO [OwnedBy] ($from_id, $to_id, InsuranceValue) VALUES (@painting_id, @exhibition_id, 90000000);

-- Выставка 4 (Шедевры мирового искусства) -> сборная
SET @exhibition_id = (SELECT $node_id FROM [Exhibition] WHERE ExhibitionID = 4);

SET @painting_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 1);
INSERT INTO [OwnedBy] ($from_id, $to_id, InsuranceValue) VALUES (@painting_id, @exhibition_id, 55000000);

SET @painting_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 8);
INSERT INTO [OwnedBy] ($from_id, $to_id, InsuranceValue) VALUES (@painting_id, @exhibition_id, 65000000);

SET @painting_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 13);
INSERT INTO [OwnedBy] ($from_id, $to_id, InsuranceValue) VALUES (@painting_id, @exhibition_id, 130000000);

SET @painting_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 15);
INSERT INTO [OwnedBy] ($from_id, $to_id, InsuranceValue) VALUES (@painting_id, @exhibition_id, 80000000);

-- Выставка 5 (Золотая осень живописи) -> сборная
SET @exhibition_id = (SELECT $node_id FROM [Exhibition] WHERE ExhibitionID = 5);

SET @painting_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 4);
INSERT INTO [OwnedBy] ($from_id, $to_id, InsuranceValue) VALUES (@painting_id, @exhibition_id, 38000000);

SET @painting_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 10);
INSERT INTO [OwnedBy] ($from_id, $to_id, InsuranceValue) VALUES (@painting_id, @exhibition_id, 35000000);

SET @painting_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 17);
INSERT INTO [OwnedBy] ($from_id, $to_id, InsuranceValue) VALUES (@painting_id, @exhibition_id, 85000000);

SET @painting_id = (SELECT $node_id FROM [Painting] WHERE PaintingID = 5);
INSERT INTO [OwnedBy] ($from_id, $to_id, InsuranceValue) VALUES (@painting_id, @exhibition_id, 30000000);


-- =============================================
-- 3. ЗАПОЛНЯЕМ OrganizedBy (Artist -> Exhibition)
-- =============================================

DECLARE @artist_id NVARCHAR(1000);
DECLARE @exhibit_id NVARCHAR(1000);

-- Ван Гог организовал выставку 1
SET @artist_id = (SELECT $node_id FROM [Artist] WHERE ArtistID = 1);
SET @exhibit_id = (SELECT $node_id FROM [Exhibition] WHERE ExhibitionID = 1);
INSERT INTO [OrganizedBy] ($from_id, $to_id, Fee) VALUES (@artist_id, @exhibit_id, 500000);

-- Айвазовский организовал выставку 2
SET @artist_id = (SELECT $node_id FROM [Artist] WHERE ArtistID = 2);
SET @exhibit_id = (SELECT $node_id FROM [Exhibition] WHERE ExhibitionID = 2);
INSERT INTO [OrganizedBy] ($from_id, $to_id, Fee) VALUES (@artist_id, @exhibit_id, 450000);

-- Пикассо организовал выставку 3
SET @artist_id = (SELECT $node_id FROM [Artist] WHERE ArtistID = 3);
SET @exhibit_id = (SELECT $node_id FROM [Exhibition] WHERE ExhibitionID = 3);
INSERT INTO [OrganizedBy] ($from_id, $to_id, Fee) VALUES (@artist_id, @exhibit_id, 700000);

-- Все три художника организовали выставку 4
SET @artist_id = (SELECT $node_id FROM [Artist] WHERE ArtistID = 1);
SET @exhibit_id = (SELECT $node_id FROM [Exhibition] WHERE ExhibitionID = 4);
INSERT INTO [OrganizedBy] ($from_id, $to_id, Fee) VALUES (@artist_id, @exhibit_id, 200000);

SET @artist_id = (SELECT $node_id FROM [Artist] WHERE ArtistID = 2);
SET @exhibit_id = (SELECT $node_id FROM [Exhibition] WHERE ExhibitionID = 4);
INSERT INTO [OrganizedBy] ($from_id, $to_id, Fee) VALUES (@artist_id, @exhibit_id, 200000);

SET @artist_id = (SELECT $node_id FROM [Artist] WHERE ArtistID = 3);
SET @exhibit_id = (SELECT $node_id FROM [Exhibition] WHERE ExhibitionID = 4);
INSERT INTO [OrganizedBy] ($from_id, $to_id, Fee) VALUES (@artist_id, @exhibit_id, 200000);

-- Айвазовский и Пикассо организовали выставку 5
SET @artist_id = (SELECT $node_id FROM [Artist] WHERE ArtistID = 2);
SET @exhibit_id = (SELECT $node_id FROM [Exhibition] WHERE ExhibitionID = 5);
INSERT INTO [OrganizedBy] ($from_id, $to_id, Fee) VALUES (@artist_id, @exhibit_id, 150000);

SET @artist_id = (SELECT $node_id FROM [Artist] WHERE ArtistID = 3);
SET @exhibit_id = (SELECT $node_id FROM [Exhibition] WHERE ExhibitionID = 5);
INSERT INTO [OrganizedBy] ($from_id, $to_id, Fee) VALUES (@artist_id, @exhibit_id, 250000);


-- 5 MATCH запросов

-- Художник создал картину, картина выставлена на выставке, выставку организовал другой художник
SELECT 
    a1.Name AS artist_name,
    p.Name AS painting_name,
    e.Name AS exhibition_name,
    a2.Name AS organized_by_artist,
    cb.Commission AS commission,
    ob.InsuranceValue AS insurance_value,
    org.Fee AS organizer_fee
FROM 
    [Artist] a1,
    [CreatedBy] cb,
    [Painting] p,
    [OwnedBy] ob,
    [Exhibition] e,
    [OrganizedBy] org,
    [Artist] a2
WHERE MATCH( a1-(cb)->p-(ob)->e<-(org)-a2 )
AND a1.ArtistID != a2.ArtistID  -- чтобы исключить самого себя
ORDER BY a1.Name, e.Name;

-- Художник создал картину, картина выставлена на выставке, и этот же художник организовал выставку
SELECT 
    a.Name AS artist_name,
    p.Name AS painting_name,
    e.Name AS exhibition_name,
    cb.Commission AS commission,
    org.Fee AS organizer_fee
FROM 
    [Artist] a,
    [CreatedBy] cb,
    [Painting] p,
    [OwnedBy] ob,
    [Exhibition] e,
    [OrganizedBy] org
WHERE MATCH( a-(cb)->p-(ob)->e<-(org)-a )
ORDER BY a.Name, e.Name;

-- Полная информация: какой художник создал какую картину, и на какой выставке она представлена
SELECT 
    art.Name AS artist_name,
    art.Country AS artist_country,
    p.Name AS painting_name,
    p.Style AS painting_style,
    p.Year AS painting_year,
    e.Name AS exhibition_name,
    e.City AS exhibition_city,
    e.Date AS exhibition_date,
    cb.Commission AS artist_commission,
    ob.InsuranceValue AS insurance_value
FROM 
    [Artist] art,
    [CreatedBy] cb,
    [Painting] p,
    [OwnedBy] ob,
    [Exhibition] e
WHERE MATCH( art-(cb)->p-(ob)->e )
ORDER BY e.Name, art.Name;

-- Выставки, на которых представлены картины в стиле Кубизм и Романтизм
SELECT 
    e.Name AS exhibition_name,
    e.City AS exhibition_city,
    art.Name AS artist_name,
    p.Name AS painting_name,
    p.Style AS painting_style,
    ob.InsuranceValue AS insurance_value
FROM 
    [Artist] art,
    [CreatedBy] cb,
    [Painting] p,
    [OwnedBy] ob,
    [Exhibition] e
WHERE MATCH( art-(cb)->p-(ob)->e )
AND p.Style IN ('Кубизм', 'Романтизм')
ORDER BY e.Name, p.Style;

-- Художники и их картины, которые участвуют в нескольких выставках
SELECT 
    art.Name AS artist_name,
    p.Name AS painting_name,
    COUNT(DISTINCT e.ExhibitionID) AS exhibition_count,
    SUM(ob.InsuranceValue) AS total_insurance_value,
    AVG(cb.Commission) AS avg_commission
FROM 
    [Artist] art,
    [CreatedBy] cb,
    [Painting] p,
    [OwnedBy] ob,
    [Exhibition] e
WHERE MATCH( art-(cb)->p-(ob)->e )
GROUP BY art.Name, p.Name, p.PaintingID
HAVING COUNT(DISTINCT e.ExhibitionID) >= 2
ORDER BY exhibition_count DESC;


--2 запроса с SHORTEST_PATH

-- Кратчайший путь от Ван Гога (ArtistID=1) до всех выставок
-- Путь: Artist → (CreatedBy) → Painting → (OwnedBy) → Exhibition
SELECT 
    STRING_AGG(p.Name, ' → ') WITHIN GROUP (GRAPH PATH) AS paintings_path,
    STRING_AGG(e.Name, ' → ') WITHIN GROUP (GRAPH PATH) AS exhibitions_path,
    COUNT(p.Name) WITHIN GROUP (GRAPH PATH) AS paintings_count,
    COUNT(e.Name) WITHIN GROUP (GRAPH PATH) AS exhibitions_count
FROM 
    [Artist] AS start_node,
    [Painting] FOR PATH AS p,
    [Exhibition] FOR PATH AS e,
    [CreatedBy] FOR PATH AS cb,
    [OwnedBy] FOR PATH AS ob
WHERE 
    MATCH( SHORTEST_PATH( start_node(-(cb)->p-(ob)->e)+ ) )
    AND start_node.ArtistID = 1;

-- Кратчайший путь от Пикассо (ArtistID=3) до всех выставок за 1-3 шага
SELECT 
    STRING_AGG(p.Name, ' → ') WITHIN GROUP (GRAPH PATH) AS paintings_path,
    STRING_AGG(e.Name, ' → ') WITHIN GROUP (GRAPH PATH) AS exhibitions_path,
    COUNT(p.Name) WITHIN GROUP (GRAPH PATH) AS paintings_count,
    COUNT(e.Name) WITHIN GROUP (GRAPH PATH) AS exhibitions_count
FROM 
    [Artist] AS start_node,
    [Painting] FOR PATH AS p,
    [Exhibition] FOR PATH AS e,
    [CreatedBy] FOR PATH AS cb,
    [OwnedBy] FOR PATH AS ob
WHERE 
    MATCH( SHORTEST_PATH( start_node(-(cb)->p-(ob)->e){1,3} ) )
    AND start_node.ArtistID = 3;



-- Power BI

-- Ребра CreatedBy: какие картины создал каждый художник
SELECT 
    art.Name AS Source,
    p.Name AS Target,
    CONCAT('artist', art.ArtistID) AS [Source image name],
    CONCAT('painting', p.PaintingID) AS [Target image name],
    cb.Commission AS Commission,
    CONCAT('Commission: ', CAST(cb.Commission AS NVARCHAR(20))) AS [Label]
FROM [Artist] art, [CreatedBy] cb, [Painting] p
WHERE MATCH(art-(cb)->p)
ORDER BY art.Name

-- Ребра OwnedBy: какие картины участвуют в выставках
SELECT 
    p.Name AS Source,
    e.Name AS Target,
    CONCAT('painting', p.PaintingID) AS [Source image name],
    CONCAT('exhibition', e.ExhibitionID) AS [Target image name],
    ob.InsuranceValue AS InsuranceValue,
    CONCAT('Insurance: ', CAST(ob.InsuranceValue AS NVARCHAR(20))) AS [Label]
FROM [Painting] p, [OwnedBy] ob, [Exhibition] e
WHERE MATCH(p-(ob)->e)
ORDER BY p.Name

-- Ребра OrganizedBy: какие выставки организовал каждый художник
SELECT 
    art.Name AS Source,
    e.Name AS Target,
    CONCAT('artist', art.ArtistID) AS [Source image name],
    CONCAT('exhibition', e.ExhibitionID) AS [Target image name],
    org.Fee AS Fee,
    CONCAT('Fee: ', CAST(org.Fee AS NVARCHAR(20))) AS [Label]
FROM [Artist] art, [OrganizedBy] org, [Exhibition] e
WHERE MATCH(art-(org)->e)
ORDER BY art.Name