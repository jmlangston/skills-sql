sqlite> .schema Brands
CREATE TABLE Brands (
    id INTEGER PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    founded INT(4),
    headquarters VARCHAR(50),
    discontinued INT(4)
);

sqlite> .schema Models
CREATE TABLE Models (
    id INTEGER PRIMARY KEY,
    year INT(4) NOT NULL,
    brand_name VARCHAR(50) NULL,
    name VARCHAR(50) NOT NULL
);


-- 1. Select all columns for all brands in the Brands table.

SELECT * FROM Brands;

-- 2. Select all columns for all car models made by Pontiac in the Models table.

SELECT * FROM Models 
WHERE brand_name = 'Pontiac';

-- 3. Select the brand name and model 
--    name for all models made in 1964 from the Models table.

SELECT brand_name, name 
FROM Models 
WHERE year = '1964';

-- 4. Select the model name, brand name, and headquarters for the Ford Mustang 
--    from the Models and Brands tables.

SELECT m.name, b.name, b.headquarters 
FROM Models AS m 
JOIN Brands AS b ON b.name = m.brand_name 
WHERE m.brand_name = 'Ford' AND m.name='Mustang';

-- 5. Select all rows for the three oldest brands 
--    from the Brands table (Hint: you can use LIMIT and ORDER BY).

SELECT * FROM Brands ORDER BY founded LIMIT 3; 

-- 6. Count the Ford models in the database (output should be a **number**).

SELECT COUNT(*) FROM Models WHERE brand_name = 'Ford';

-- 7. Select the **name** of any and all car brands that are not discontinued.

SELECT name FROM Brands WHERE discontinued; 

-- 8. Select rows 15-25 of the DB in alphabetical order by model name.

SELECT * FROM Models 
JOIN Brands ON Brands.name = Models.brand_name 
ORDER BY Models.name 
LIMIT 11 OFFSET 14;

-- 9. Select the **brand, name, and year the model's brand was 
--    founded** for all of the models from 1960. Include row(s)
--    for model(s) even if its brand is not in the Brands table.
--    (The year the brand was founded should be ``null`` if 
--    the brand is not in the Brands table.)

SELECT m.brand_name, m.name, year 
FROM Models as m 
LEFT JOIN Brands as b ON m.brand_name = b.name 
WHERE year = 1960;

-- Part 2: Change the following queries according to the specifications. 
-- Include the answers to the follow up questions in a comment below your
-- query.

-- 1. Modify this query so it shows all **brands** that are not discontinued
-- regardless of whether they have any cars in the cars table.
-- before:  I.E. SHOULD SHOW TESLA

    -- SELECT b.name,
    --        b.founded,
    --        m.name
    -- FROM Model AS m
    --   LEFT JOIN brands AS b
    --     ON b.name = m.brand_name
    -- WHERE b.discontinued IS NULL;

    SELECT b.name
    FROM Brands AS b
      LEFT JOIN Models AS m
        ON b.name = m.brand_name
    WHERE b.discontinued IS NULL;


-- 2. Modify this left join so it only selects models that have brands in the Brands table.  I.E. WON'T SHOW FILLMORE
-- before: 
    -- SELECT m.name,
    --        m.brand_name,
    --        b.founded
    -- FROM Models AS m
    --   LEFT JOIN Brands AS b
    --     ON b.name = m.brand_name;

    SELECT m.name,
           m.brand_name,
           b.founded
    FROM Brands AS b
      LEFT JOIN Models AS m
        ON b.name = m.brand_name;

-- followup question: In your own words, describe the difference between 
-- left joins and inner joins.

-- ANSWER: If you picture two tables in a database as a Venn diagram, an inner join only includes the part of the diagram where the circles overlap and a left join will include that overlapping part plus the rest of one of the circles.  In other words, an inner join will only look at elements of the tables that are common between the two and a left join will incorporate all of the elements of whichever table is preceded by "From" in the Select statement. 

-- 3. Modify the query so that it only selects brands that don't have any car models in the cars table. 
-- (Hint: it should only show Tesla's row.)
-- before: 
    -- SELECT name,
    --        founded
    -- FROM Brands
    --   LEFT JOIN Models
    --     ON brands.name = Models.brand_name
    -- WHERE Models.year > 1940;

    SELECT Brands.name,
           founded
    FROM Brands
      LEFT JOIN Models
        ON Brands.name = Models.brand_name
    WHERE Models.name is NULL;

-- 4. Modify the query to add another column to the results to show 
-- the number of years from the year of the model *until* the brand becomes discontinued
-- Display this column with the name years_until_brand_discontinued.
-- before: 
    -- SELECT b.name,
    --        m.name,
    --        m.year,
    --        b.discontinued
    -- FROM Models AS m
    --   LEFT JOIN brands AS b
    --     ON m.brand_name = b.name
    -- WHERE b.discontinued NOT NULL;

    SELECT b.name,
           m.name,
           m.year,
           b.discontinued,
           (b.discontinued - m.year) AS years_until_brand_discontinued
    FROM Models AS m
      LEFT JOIN Brands AS b
        ON m.brand_name = b.name
    WHERE b.discontinued NOT NULL;


-- Part 3: Futher Study

-- 1. Select the **name** of any brand with more than 5 models in the database.

    SELECT brand_name
    FROM Models
    GROUP BY brand_name
    HAVING COUNT(*) > 5;

-- 2. Add the following rows to the Models table.

-- year    name       brand_name
-- ----    ----       ----------
-- 2015    Chevrolet  Malibu
-- 2015    Subaru     Outback

    BEGIN;
    INSERT INTO Models (year, brand_name, name) VALUES (2015, 'Chevrolet', 'Malibu');
    INSERT INTO Models (year, brand_name, name) VALUES (2015, 'Subaru', 'Outback');
    COMMIT; 

-- 3. Write a SQL statement to create a table called ``Awards`` 
--    with columns ``name``, ``year``, and ``winner``. Choose 
--    an appropriate datatype and nullability for each column.

    CREATE TABLE Awards (
        id INTEGER PRIMARY KEY,
        name VARCHAR(50) NOT NULL,
        year INT(4) NOT NULL,
        winner_model_id INT(2) NOT NULL
        );


-- 4. Write a SQL statement that adds the following rows to the Awards table:

--   name                 year      winner_model_id
--   ----                 ----      ---------------
--   IIHS Safety Award    2015      # get the ``id`` of the 2015 Chevrolet Malibu
--   IIHS Safety Award    2015      # get the ``id`` of the 2015 Subaru Outback

    BEGIN;
    INSERT INTO Awards (name, year, winner_model_id) VALUES ('IIHS Safety Award', 2015, 49);
    INSERT INTO Awards (name, year, winner_model_id) VALUES ('IIHS Safety Award'), 2015, 50);
    COMMIT;


-- 5. Using a subquery, select only the *name* of any model whose 
-- year is the same year that *any* brand was founded.

    SELECT name FROM Models
    WHERE year IN (SELECT founded FROM Brands);


