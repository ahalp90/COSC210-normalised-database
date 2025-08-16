-- COSC210 Practical Assignment Template

-- Please complete the assignment questions using the view templates
-- provided below.

-- *******************************************************************
--                           IMPORTANT
-- *******************************************************************

-- Make sure that you do not alter the names of the views or their 
-- attribute values. If you do your assignment will not work in the
-- auto-marking software and you may lose marks!

-- *******************************************************************

-- I have not ordered the output because it was not in instructions.


CREATE VIEW movie_summary(movie_title, release_date, media_type, retail_price)
AS ...

	SELECT 
		Movies.movie_title, 
		Movies.release_date, 
		Stock.media_type, 
		Stock.retail_price
	FROM 
		Movies
	INNER JOIN 
		Stock 
		ON Movies.movie_id = Stock.movie_id;



CREATE VIEW old_shipments(first_name, last_name, movie_id, shipment_id, shipment_date)
AS ...

	SELECT
		Customers.first_name, 
		Customers.last_name, 
		Shipments.movie_id, 
		Shipments.shipment_id, 
		Shipments.shipment_date
	FROM
		Shipments
	INNER JOIN
		Customers
		ON Shipments.customer_id = Customers.customer_id
	WHERE
		Shipments.shipment_date < '2010-01-01';

CREATE VIEW richie(movie_title)
AS ...
-- I haven't applied SELECT DISTINCT as this wasn't in the instructions, though I can see that it could be helpful.
-- Some movies might have multiple identical title listings but different movie_id unique id due to something like re-release.

	SELECT
		Movies.movie_title
	FROM
		Movies
	WHERE
		Movies.director_first_name = 'Ron' 
		AND	Movies.director_last_name = 'Howard';

CREATE VIEW retail_price_hike(movie_id , retail_price, new_price)
AS ...
-- Instructions were ambiguous as to whether new_price should be rounded.
-- I've just followed the instructions to the word, but I think new_price would be better as:
	-- <ROUND(Stock.retail_price * 1.25, 2) AS new_price>
	
	SELECT
		Stock.movie_id,
		Stock.retail_price,
		Stock.retail_price * 1.25 AS new_price
	FROM
		Stock;



CREATE VIEW profits_from_movie(movie_id, movie_title, total_profit)
AS ...
-- I found the instructions a bit ambiguous here. 
-- I've deliberately only included total_profit for movies that have shipped.
-- I've not rounded because we're not instructed. However, it would be more functional if total_profit was:
	-- <ROUND(SUM(Stock.retail_price) - SUM(Stock.cost_price), 2) AS total_profit>
	-- The rounding instruction would need to be modified to CAST to numeric if using REAL as the origin datatype, as I did.
-- Also, we're instructed to group "by movie_title", but GROUP BY must reference all non-aggregated selectors/their unique ID.

	SELECT
		Movies.movie_id,
		Movies.movie_title,
		SUM(Stock.retail_price) - SUM(Stock.cost_price) AS total_profit
	FROM
		Shipments
	INNER JOIN 
		Stock 
		ON Shipments.movie_id = Stock.movie_id 
		AND Shipments.media_type = Stock.media_type
	INNER JOIN 
		Movies 
		ON Stock.movie_id = Movies.movie_id
	GROUP BY
		Movies.movie_title,
		Movies.movie_id;

CREATE VIEW binge_watcher(first_name, last_name)
AS ...
-- Q1 implies you don't care about distinct values. I've just followed explicit instructions.
-- However, I think it would make sense to <SELECT DISTINCT> for this view;
-- otherwise a customer might show up multiple times if they binge on multiple days.
	-- In this SELECT DISTINCT scenario, I'd remove Shipments.shipment_date from the grouping.
-- But it might also be helpful to have potential duplicate names;
-- then you could quantify a customer's binge-watching occurences.

	SELECT
		Customers.first_name,
		Customers.last_name
	FROM
		Customers
	INNER JOIN
		Shipments 
		ON Customers.customer_id = Shipments.customer_id
	GROUP BY
		-- Customers.customer_id as primary key implies grouping by the first_name/last_name selectors,
		-- and is more specific as it's a unique identifier. 
		-- For example, a database might have two John Smiths whose rentals would be combined. 
		Customers.customer_id,
		Shipments.shipment_date 
		
	HAVING
		COUNT(Shipments.shipment_id) > 1;

CREATE VIEW the_sith(first_name, last_name)
AS ...

	SELECT
		Customers.first_name,
		Customers.last_name
	FROM
		Customers
		
	-- I've preserved all foreign relationships for referential integrity.
	-- However, this would currently work equally well just joining Shipments.movie_id to Movies.movie_id.
	WHERE NOT EXISTS (
		Select 
			* 
		FROM 
			Shipments
		INNER JOIN 
			Stock 
			ON Shipments.movie_id = Stock.movie_id 
			AND Shipments.media_type = Stock.media_type
		INNER JOIN 
			Movies 
			ON Stock.movie_id = Movies.movie_id
			
		-- Correlate the check results to customer IDs and continue to the check for all customers.
		-- Otherwise this would resolve as a simple <IF no SW-V shipments in the dataset, return all customers, ELSE return no items>
		WHERE 
			Customers.customer_id = Shipments.customer_id 
			AND	Movies.movie_title = 'Star Wars: Episode V - The Empire Strikes Back'
	);


                              
CREATE VIEW sole_angry_man(first_name, last_name)
AS ...                            

	WITH CTE_angry_men_shipment_customers AS (
		SELECT DISTINCT
			Shipments.customer_id
		FROM
			Shipments
		INNER JOIN
			Stock 
			ON Shipments.movie_id = Stock.movie_id 
			AND Shipments.media_type = Stock.media_type
		INNER JOIN
			Movies 
			ON Stock.movie_id = Movies.movie_id
		WHERE 
			Movies.movie_title = '12 Angry Men' 
	)


	SELECT
		Customers.first_name,
		Customers.last_name
	FROM
		Customers
	INNER JOIN
		CTE_angry_men_shipment_customers 
		ON Customers.customer_id = CTE_angry_men_shipment_customers.customer_id
	WHERE 
		(SELECT COUNT(CTE_angry_men_shipment_customers.customer_id) 
		FROM CTE_angry_men_shipment_customers) = 1
	;