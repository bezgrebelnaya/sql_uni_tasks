Задание 1. Пронумеруйте все проданные треки в каждом заказе в зависимости от порядка расположения в чеке.

SELECT InvoiceId, TrackId,
	DENSE_RANK()
	OVER (PARTITION BY InvoiceId ORDER BY TrackId )   AS rnk 
	FROM InvoiceLine il

Задание 2. Пронумеруйте заказы каждого отдельного покупателя в зависимости от даты совершения заказа, начиная от первого (т.е. самого раннего) до последнего. Для каждого последующего заказа рассчитайте время в днях(месяцах) между текущим заказом и первым. Какое среднее время необходимо покупателю, чтобы принять решение об оформлении второго заказа?

WITH t1 AS (
SELECT CustomerId, InvoiceDate,
	   DENSE_RANK ()
	   OVER (PARTITION BY CustomerId ORDER BY InvoiceDate) AS rnk,
	   JULIANDAY(InvoiceDate) AS date1,
	   JULIANDAY( 
	  		FIRST_VALUE(InvoiceDate)	
	  		OVER (PARTITION BY CustomerId  ORDER BY InvoiceDate)) AS date2
	   FROM Invoice i 
	   )
SELECT *, date1-date2, AVG(date1-date2) OVER (PARTITION BY CustomerId) AS avg_time
	FROM t1
	ORDER BY CustomerId, InvoiceDate



Задание 3.  За каждый месяц проранжируйте музыкальные жанры в зависимости от объема вырученных с них денег от наибольшего к наименьшему.

SELECT STRFTIME('%m', i.InvoiceDate) AS 'Месяц',
	   g.Name AS 'Жанр', 
	   SUM(il.UnitPrice * il.Quantity) AS 'Объем вырученных денег',
	   DENSE_RANK() 
	   OVER (PARTITION BY STRFTIME('%m', i.InvoiceDate) ORDER BY SUM(il.UnitPrice * il.Quantity) DESC) AS rnk
	FROM Invoice i 
	LEFT JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId 
	LEFT JOIN Track t ON il.TrackId = t.TrackId 
	LEFT JOIN Genre g ON t.GenreId = g.GenreId 
	GROUP BY STRFTIME('%m', i.InvoiceDate), g.GenreId

