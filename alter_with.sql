1.В таблице Customer создайте новый столбец, который будет содержать два значения:
-	если у пользователя есть компания, тогда «Юридическое лицо»
-	если у пользователя нет компании, то «Физическое лицо»

ALTER TABLE Customer 
ADD N varchar(60);
UPDATE Customer
SET N = CASE  
	WHEN Company IS NULL THEN "Физическое лицо"
	ELSE "Юридическое лицо"
END;
SELECT Company, N
FROM Customer

2. Сформируйте 6 групп пользователей по обороту (интервалы выберете на свое усмотрение)). Для каждой группы определите:
-	количество треков;
-	количество исполнителей;
-	количество покупателей;
-	общая сумма оборота всех треков, которые входят в группу.
Группы 
<=49,62
<=46,62
<=43,62
<=41,62
<=39,62
<=37,62

-	WITH t1 AS (SELECT
-		COUNT(DISTINCT il.TrackId) AS number_of_tracks,
-		COUNT(DISTINCT a.ArtistId) AS number_of_artists,
-		i.CustomerId AS customers,
-		SUM(il.UnitPrice*il.Quantity) AS s
-		   FROM Invoice i 
-		   LEFT JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId 
-		   LEFT JOIN Track t ON il.TrackId = t.TrackId 
-		   LEFT JOIN Album a ON t.AlbumId = a.AlbumId 
-		GROUP BY i.CustomerId 
-		),
-	t2 AS (SELECT SUM(number_of_tracks),
-		   SUM(number_of_artists),
-		   COUNT(customers),
-		   SUM(s)
-	FROM t1
-	WHERE s<=37.63),
-	t3 AS (SELECT SUM(number_of_tracks),
-		   SUM(number_of_artists),
-		   COUNT(customers),
-		   SUM(s)
-	FROM t1
-	WHERE s BETWEEN 37.63 AND 39.63),
-	t4 AS (SELECT SUM(number_of_tracks),
-		   SUM(number_of_artists),
-		   COUNT(customers),
-		   SUM(s)
-	FROM t1
-	WHERE s BETWEEN 39.63 AND 41.63), 
-	t5 AS (SELECT SUM(number_of_tracks),
-		   SUM(number_of_artists),
-		   COUNT(customers),
-		   SUM(s)
-	FROM t1
-	WHERE s BETWEEN 41.63 AND 43.63), 
-	t6 AS (SELECT SUM(number_of_tracks),
-		   SUM(number_of_artists),
-		   COUNT(customers),
-		   SUM(s)
-	FROM t1
-	WHERE s BETWEEN 43.63 AND 46.63),
-	t7 AS (SELECT SUM(number_of_tracks),
-		   SUM(number_of_artists),
-		   COUNT(customers),
-		   SUM(s)
-	FROM t1
-	WHERE s >46.63)
-	SELECT * FROM t2
-	UNION SELECT * FROM t3
-	UNION SELECT * FROM t4
-	UNION SELECT * FROM t5
-	UNION SELECT * FROM t6
-	UNION SELECT * FROM t7
-	

3. Рассчитайте те же самые метрики для покупателей из Франции, и отдельно для покупателей только из США. Все метрики должны быть представлены единой таблицей. Сделайте выводы об эффективности.

WITH t1 AS (SELECT
	COUNT(DISTINCT il.TrackId) AS number_of_tracks,
	COUNT(DISTINCT a.ArtistId) AS number_of_artists,
	i.CustomerId AS customers,
	SUM(il.UnitPrice*il.Quantity) AS s,
	i.BillingCountry AS country
	   FROM Invoice i 
	   LEFT JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId 
	   LEFT JOIN Track t ON il.TrackId = t.TrackId 
	   LEFT JOIN Album a ON t.AlbumId = a.AlbumId 
	GROUP BY i.CustomerId  
	),
france AS (
	SELECT country, 
		   SUM(number_of_tracks) AS number_of_tracks,
		   SUM(number_of_artists) AS number_of_artists,
		   COUNT(customers) AS customers,
		   SUM(s) AS 'сумма оборота всех треков'
 	FROM t1
	WHERE country == 'France' 
),
USA AS (
	SELECT country, 
		   SUM(number_of_tracks),
		   SUM(number_of_artists),
		   COUNT(customers),
		   SUM(s)
 	FROM t1
	WHERE country == 'USA' 
)
SELECT * FROM france
UNION SELECT * FROM USA

В США общая сумма оборота всех треков в 2,68 раза больше, чем во Франции. Количество клиентов и исполнителей в США примерно в два раза превышает значения этих показателей во Франции. 
