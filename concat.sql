Задание 1. Напишите SQL-запрос, который определит суммарную выручку всех заказов для каждого города, где находятся клиенты.
SELECT City, SUM(Total)
	FROM Customer c 
	LEFT JOIN Invoice i ON c.CustomerId = i.CustomerId 
GROUP BY City

Задание 2. Составить таблицу со следующими данными:
1. Фамилия, имя каждого работника (из таблицы Employee) в одном столбце;
2. Количество обслуживаемых им клиентов;
3. Прибыль, которую принесли клиенты (total).

SELECT CONCAT(e.LastName, ' ', e.FirstName) AS empl,
	   COUNT(c.CustomerId),
	   SUM(i.Total)
	FROM Employee e 
	LEFT JOIN Customer c ON e.EmployeeId = c.SupportRepId 
	LEFT JOIN Invoice i ON c.CustomerId = i.CustomerId 
GROUP BY empl

Задание 3. Для полученной из задания 2 таблицы вывести тех работников, у которых нет клиентов. Отсортируйте результат по алфавиту.

SELECT CONCAT(e.LastName, ' ', e.FirstName) AS empl,
	   COUNT(c.CustomerId),
	   SUM(i.Total)
	FROM Employee e 
	LEFT JOIN Customer c ON e.EmployeeId = c.SupportRepId 
	LEFT JOIN Invoice i ON c.CustomerId = i.CustomerId 	
GROUP BY empl
HAVING COUNT(c.CustomerId) = 0
ORDER BY empl 

Задание 4. Вывести имена и фамилии клиентов в одном столбце, а также столбец, содержащий 2 значения:
•	если клиент из Америки, тогда «1»
•	если клиент не из Америки, тогда «0»
 Для каждой из 2 групп пользователей найти суммарное количество купленных треков.

SELECT DISTINCT CONCAT(c.LastName, ' ', c.FirstName) AS 'Customer',
	   CASE 
	   		WHEN Country = 'USA' THEN 1
	   		WHEN Country <> 'USA' THEN 0
	   END AS USA,
	   SUM(il.Quantity) OVER (PARTITION BY CASE 
	   		WHEN Country = 'USA' THEN 1
	   		WHEN Country <> 'USA' THEN 0
	   END ) AS 'колво купленных треков'
	FROM Customer c 
	LEFT JOIN Invoice i ON c.CustomerId = i.CustomerId 
	LEFT JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId 

Задание 5. Определите, какова стоимость одной миллисекунды каждого трека (необходимо вывести НАЗВАНИЕ трека и стоимость в одной таблице). 

SELECT Name,
	   UnitPrice / Milliseconds AS 'стоимость одной милисекунды'
	FROM Track




