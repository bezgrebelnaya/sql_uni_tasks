17	Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК.Вывести: type, model, speed	
WITH t1 AS (SELECT pr.type, pr.model, l.speed AS speed
FROM Product pr
RIGHT JOIN Laptop l ON pr.model = l.model
UNION 
SELECT pr.type, pr.model, p.speed AS speed
FROM Product pr
RIGHT JOIN PC p ON pr.model = p.model)
SELECT t1.type, t1.model, t1.speed
FROM t1
WHERE type = 'Laptop' AND speed < (SELECT min(speed) FROM t1 WHERE type = 'PC')


18	Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price	
SELECT DISTINCT maker, price
FROM Printer 
LEFT JOIN Product ON printer.model = product.model
WHERE color = 'y' AND price = 
(SELECT min(price)
FROM Printer 
WHERE color = 'y' 
)

19	Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов.
Вывести: maker, средний размер экрана.
SELECT DISTINCT maker, AVG(screen)
FROM Product p
JOIN Laptop l ON p.model = l.model
WHERE type = 'laptop'
GROUP BY maker

20	Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.	
SELECT maker, count(distinct product.model) as num
FROM Product
WHERE type = 'PC'
GROUP BY maker
HAVING num >= 3

21	Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC. Вывести: maker, максимальная цена.
SELECT DISTINCT maker, max(price)
FROM PC
LEFT JOIN Product on PC.model = Product.model
WHERE type ='PC'
GROUP BY product.maker

22	Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью. Вывести: speed, средняя цена.	
SELECT speed, AVG(price)
FROM PC
WHERE speed > 600
GROUP BY speed

23	Найдите производителей, которые производили бы как ПК со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц. Вывести: Maker	
WITH t1 AS (
SELECT DISTINCT maker
FROM product p
LEFT JOIN PC on p.model = pc.model
WHERE p.type = 'PC' and pc.speed >= 750),
t2 AS (
SELECT DISTINCT maker
FROM product p
LEFT JOIN laptop on p.model = laptop.model
WHERE p.type = 'Laptop' and laptop.speed >= 750
)
SELECT * FROM t1
INTERSECT
SELECT * FROM t2

24	Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции.
WITH t1 AS (SELECT DISTINCT product.model, Product.type, pc.price as 'price'
FROM Product
RIGHT JOIN PC ON Product.model = PC.model
UNION 
SELECT DISTINCT product.model, Product.type,laptop.price as 'price'
FROM Product
RIGHT JOIN Laptop ON Product.model = Laptop.model
UNION 
SELECT DISTINCT product.model, Product.type, printer.price as 'price'
FROM Product
RIGHT JOIN Printer ON Product.model = Printer.model)
SELECT model
FROM t1
WHERE price = (
SELECT max(price)
FROM t1)
