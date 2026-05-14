BEGIN;

-- =============================================================================
-- TASK 1 & 2: Adding films and actors
-- =============================================================================
WITH fav_films AS (
    SELECT 'BULLET TRAIN' AS title, 7 AS dur, 4.99 AS rate UNION ALL
    SELECT 'THE AMAZING SPIDER-MAN 2', 14, 9.99 UNION ALL
    SELECT 'MICHAEL', 21, 19.99
),
inserted_films AS (
    INSERT INTO film (title, language_id, rental_duration, rental_rate, last_update)
    SELECT ff.title, (SELECT language_id FROM language WHERE name = 'English'), ff.dur, ff.rate, CURRENT_DATE
    FROM fav_films ff
    WHERE NOT EXISTS (SELECT 1 FROM film f WHERE f.title = ff.title)
    RETURNING film_id, title
),
new_actors AS (
    SELECT 'BRAD' AS fn, 'PITT' AS ln UNION ALL
    SELECT 'JOEY', 'KING' UNION ALL
    SELECT 'EMMA', 'STONE' UNION ALL
    SELECT 'JAMIE', 'FOXX' UNION ALL
    SELECT 'JAAFAR', 'JACKSON' UNION ALL
    SELECT 'MILES', 'TELLER'
)
INSERT INTO actor (first_name, last_name, last_update)
SELECT na.fn, na.ln, CURRENT_DATE
FROM new_actors na
WHERE NOT EXISTS (SELECT 1 FROM actor a WHERE a.first_name = na.fn AND a.last_name = na.ln);

-- Linking actors to films
INSERT INTO film_actor (actor_id, film_id, last_update)
SELECT (SELECT actor_id FROM actor WHERE first_name = 'BRAD' AND last_name = 'PITT'), (SELECT film_id FROM film WHERE title = 'BULLET TRAIN'), CURRENT_DATE UNION ALL
SELECT (SELECT actor_id FROM actor WHERE first_name = 'JOEY' AND last_name = 'KING'), (SELECT film_id FROM film WHERE title = 'BULLET TRAIN'), CURRENT_DATE UNION ALL
SELECT (SELECT actor_id FROM actor WHERE first_name = 'EMMA' AND last_name = 'STONE'), (SELECT film_id FROM film WHERE title = 'THE AMAZING SPIDER-MAN 2'), CURRENT_DATE UNION ALL
SELECT (SELECT actor_id FROM actor WHERE first_name = 'JAMIE' AND last_name = 'FOXX'), (SELECT film_id FROM film WHERE title = 'THE AMAZING SPIDER-MAN 2'), CURRENT_DATE UNION ALL
SELECT (SELECT actor_id FROM actor WHERE first_name = 'JAAFAR' AND last_name = 'JACKSON'), (SELECT film_id FROM film WHERE title = 'MICHAEL'), CURRENT_DATE UNION ALL
SELECT (SELECT actor_id FROM actor WHERE first_name = 'MILES' AND last_name = 'TELLER'), (SELECT film_id FROM film WHERE title = 'MICHAEL'), CURRENT_DATE
ON CONFLICT DO NOTHING;

-- =============================================================================
-- TASK 3: Adding to inventory
-- =============================================================================
INSERT INTO inventory (film_id, store_id, last_update)
SELECT f.film_id, 1, CURRENT_DATE
FROM film f
WHERE f.title IN ('BULLET TRAIN', 'THE AMAZING SPIDER-MAN 2', 'MICHAEL')
  AND NOT EXISTS (SELECT 1 FROM inventory i WHERE i.film_id = f.film_id AND i.store_id = 1);

-- =============================================================================
-- TASK 4: Updating customer data
-- =============================================================================
UPDATE customer
SET first_name = 'KURMANGAZY',
    last_name = 'SAGYNGALI',
    email = 'ksagyngali@gmail.com', 
    address_id = (SELECT address_id FROM address LIMIT 1),
    last_update = CURRENT_DATE
WHERE customer_id = (
    SELECT c.customer_id
    FROM customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id
    HAVING COUNT(DISTINCT r.rental_id) >= 43
       AND COUNT(DISTINCT p.payment_id) >= 43
    LIMIT 1
)
OR email = 'ksagyngali@gmail.com';

-- =============================================================================
-- TASK 5: Cleaning up old records
-- =============================================================================
-- Check and delete payments
SELECT * FROM payment WHERE customer_id = (SELECT customer_id FROM customer WHERE email = 'ksagyngali@gmail.com');
DELETE FROM payment WHERE customer_id = (SELECT customer_id FROM customer WHERE email = 'ksagyngali@gmail.com');

-- Check and delete rentals
SELECT * FROM rental WHERE customer_id = (SELECT customer_id FROM customer WHERE email = 'ksagyngali@gmail.com');
DELETE FROM rental WHERE customer_id = (SELECT customer_id FROM customer WHERE email = 'ksagyngali@gmail.com');

-- =============================================================================
-- TASK 6: New rental and payment
-- =============================================================================
WITH new_rentals AS (
    INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
    SELECT 
        '2017-02-01 10:00:00'::timestamp,
        i.inventory_id,
        c.customer_id,
        '2017-02-01 10:00:00'::timestamp + (f.rental_duration * INTERVAL '1 day'),
        (SELECT staff_id FROM staff LIMIT 1),
        CURRENT_DATE
    FROM inventory i
    JOIN film f ON i.film_id = f.film_id
    CROSS JOIN customer c
    WHERE f.title IN ('BULLET TRAIN', 'THE AMAZING SPIDER-MAN 2', 'MICHAEL')
      AND c.email = 'ksagyngali@gmail.com'
    RETURNING rental_id, customer_id, inventory_id
)
INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
SELECT 
    nr.customer_id,
    (SELECT staff_id FROM staff LIMIT 1),
    nr.rental_id,
    f.rental_rate,
    '2017-02-15 14:30:00'::timestamp
FROM new_rentals nr
JOIN inventory i ON nr.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id;

COMMIT;




--SELECT title, rental_rate, rental_duration 
--FROM film 
--WHERE title IN ('BULLET TRAIN', 'THE AMAZING SPIDER-MAN 2', 'MICHAEL');
--
--
--
--SELECT c.first_name, c.last_name, f.title, p.payment_date 
--FROM customer c
--JOIN payment p ON c.customer_id = p.customer_id
--JOIN rental r ON p.rental_id = r.rental_id
--JOIN inventory i ON r.inventory_id = i.inventory_id
--JOIN film f ON i.film_id = f.film_id
--WHERE c.first_name = 'KURMANGAZY';