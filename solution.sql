-- Escribe una consulta para mostrar para cada tienda su ID de tienda, ciudad y país.
use sakila;

SELECT s.store_id,
	   ci.city,
	   co.country
FROM store as s
JOIN address as a
ON s.address_id = a.address_id
JOIN city as ci
ON a.city_id = ci.city_id
JOIN country as co
ON ci.country_id = co.country_id
ORDER BY s.store_id;

-- Escribe una consulta para mostrar cuánto negocio, en dólares, trajo cada tienda.

SELECT s.store_id,
	   sum(amount) as Monto_tienda
FROM store as s
JOIN customer as cu
ON s.store_id = cu.store_id
JOIN payment as p
ON cu.customer_id = p.customer_id
GROUP BY  s.store_id
ORDER BY s.store_id;

-- ¿Cuál es el tiempo de ejecución promedio de las películas por categoría?

SELECT c.name as Categoría,
	   avg(f.length) as Tiempo_promedio
FROM film as f
JOIN film_category as fc
ON f.film_id = fc.film_id
JOIN category as c
ON fc.category_id = c.category_id
GROUP BY  c.name
ORDER BY Tiempo_promedio desc;
    
 
-- ¿Qué categorías de películas son las más largas?
SELECT c.name as Categoría,
	   avg(f.length) as Tiempo_promedio
FROM film as f
JOIN film_category as fc
ON f.film_id = fc.film_id
JOIN category as c
ON fc.category_id = c.category_id
GROUP BY  c.name
ORDER BY Tiempo_promedio desc
LIMIT 3;

-- Muestra las películas más alquiladas en orden descendente.
SELECT f.title as Película,
	   count(r.rental_id) as Monto_alquiler
FROM film as f
JOIN inventory as i
ON f.film_id = i.film_id
JOIN rental as r
ON i.inventory_id = r.inventory_id
GROUP BY  f.title
ORDER BY Monto_alquiler desc;

-- Enumera los cinco principales géneros en ingresos brutos en orden descendente.

SELECT c.name as Categoría,
	   sum(sub.amount) as Ingresos
FROM film as f
JOIN film_category as fc
ON f.film_id = fc.film_id
JOIN category as c
ON fc.category_id = c.category_id
JOIN inventory as i
ON f.film_id = i.film_id
JOIN (
    SELECT
        r.inventory_id,
        p.amount
    FROM
        rental as r
    JOIN
        payment as p 
	ON r.rental_id = p.rental_id
) sub
ON
	i.inventory_id = sub.inventory_id
GROUP BY  Categoría
ORDER BY Ingresos DESC
LIMIT 3;

-- ¿Está "Academy Dinosaur" disponible para alquilar en la Tienda 1?

SELECT f.title as Película,
	   if(sub.inventory_id IS NOT NULL,"Disponible", "No disponible") as Disponibilidad
FROM film as f
JOIN (
    SELECT
        i.film_id,
        i.inventory_id
    FROM
        inventory as i
    LEFT JOIN
        rental as r 
	ON i.inventory_id = r.inventory_id AND r.return_date IS NULL
    WHERE i.store_id=1
) sub
ON
	f.film_id = sub.film_id
 WHERE f.title="Academy Dinosaur";


