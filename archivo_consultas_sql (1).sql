- =================================================================
-- TAREA KODIGO: Script SQL con consultas CRUD y consultas JOIN
-- Base de datos: accommodations_tourism
-- Presentado por: Roxana Elizabeth Carrillos Rubio
-- =================================================================

-- 01. INSERT: Agregar filas a propietarios y huéspedes
INSERT INTO owners (first_name, last_name, email, phone) 
VALUES ('Carlos', 'Mendoza', 'carlos.mendoza.nuevo@mail.com', '7788-9900');

INSERT INTO guests (first_name, last_name, email, phone, date_of_birth, nationality) 
VALUES ('Ana', 'Martínez', 'ana.martinez.unica@mail.com', '+503 7111-1111', '1995-05-15', 'Salvadoreña');


-- 02. INSERT: Agregar ubicaciones y tipos
INSERT INTO locations (country, state, city, district, address_line1) 
VALUES ('El Salvador', 'La Libertad', 'Playa El Tunco', 'Chiltiupán', 'Calle Principal Km 42');

INSERT INTO accommodation_types (name, description) 
VALUES ('Hotel Boutique', 'Alojamientos elegantes con servicios personalizados.');

-- 03. INSERT: Vincular la reserva del huésped al alojamiento
-- Nota: Usamos las llaves generadas para evitar conflictos de integridad
INSERT INTO bookings (guest_id, accommodation_id, booking_status_id, check_in_date, check_out_date)
VALUES (1, 1, 1, '2026-07-10', '2026-07-15');


-- 04. INSERT: Registrar pago de la reserva
INSERT INTO payments (booking_id, amount, payment_method, payment_status)
VALUES (1, 476.00, 'CreditCard', 'Completed');



-- 05. SELECT: Alojamientos activos
SELECT * FROM accommodations WHERE is_active = true;


-- 06. SELECT: Huéspedes por país (Filtrar por nacionalidad)
-- Nota: Esta consulta te mostrará todos los huéspedes organizados por su origen.
SELECT first_name, last_name, email, nationality 
FROM guests 
ORDER BY nationality;


-- 07. SELECT: Reservas por fechas (Uso de BETWEEN)
SELECT booking_id, guest_id, accommodation_id, check_in_date, check_out_date
FROM bookings
WHERE check_in_date BETWEEN '2026-07-01' AND '2026-07-31';


-- 08. UPDATE: Actualizar precio (Modificar precio)
-- SELECT * FROM accommodations LIMIT 1;
UPDATE accommodations
SET base_price_per_night = 95.00
WHERE accommodation_id = 21;


-- 09. UPDATE: Estado reserva (Actualizar estado)
UPDATE bookings
SET booking_status_id = 2
WHERE booking_id = 101;


-- 10. DELETE: Eliminar pago (Borrar registro)
DELETE FROM payments
WHERE payment_id = 91;


-- 11. SELECT: Reservas + huésped (INNER JOIN)
SELECT 
    b.booking_id, 
    b.check_in_date, 
    b.check_out_date, 
    g.first_name, 
    g.last_name, 
    g.email
FROM bookings b
INNER JOIN guests g ON b.guest_id = g.guest_id;



-- 12. SELECT: Alojamiento completo (INNER JOIN múltiple)
SELECT 
    a.accommodation_id,
    a.name AS alojamiento,
    a.base_price_per_night AS precio,
    o.first_name || ' ' || o.last_name AS propietario,
    loc.city AS ubicacion
FROM accommodations a
INNER JOIN owners o ON a.owner_id = o.owner_id
INNER JOIN locations loc ON a.location_id = loc.location_id;




-- 13. SELECT: Pagos + reservas (JOIN combinado)
SELECT 
    p.payment_id,
    p.booking_id,
    p.amount AS monto_pagado,
    p.payment_status AS estado_pago,
    g.first_name || ' ' || g.last_name AS huesped,
    b.check_in_date AS fecha_entrada
FROM payments p
INNER JOIN bookings b ON p.booking_id = b.booking_id
INNER JOIN guests g ON b.guest_id = g.guest_id;




-- 14. SELECT: Alojamientos sin reseñas (LEFT JOIN incluye NULLs)
SELECT 
    a.accommodation_id,
    a.name AS alojamiento,
    a.base_price_per_night AS precio,
    r.review_id
FROM accommodations a
LEFT JOIN reviews r ON a.accommodation_id = r.accommodation_id
WHERE r.review_id IS NULL;




-- 15. SELECT: Alojamientos sin reservas (LEFT JOIN filtrar NULL)
SELECT 
    a.accommodation_id,
    a.name AS alojamiento,
    a.base_price_per_night AS precio,
    b.booking_id
FROM accommodations a
LEFT JOIN bookings b ON a.accommodation_id = b.accommodation_id
WHERE b.booking_id IS NULL;



-- 16. AGG: Total ingresos (SUM)
SELECT SUM(amount) AS total_ingresos
FROM payments;



-- 17. AGG: Promedio rating (AVG)
SELECT AVG(rating) AS promedio_rating
FROM reviews;



-- 18. AGG: Top alojamientos (COUNT + LIMIT)
SELECT 
    a.accommodation_id, 
    a.name AS alojamiento,
    COUNT(b.booking_id) AS total_reservas
FROM accommodations a
INNER JOIN bookings b ON a.accommodation_id = b.accommodation_id
GROUP BY a.accommodation_id, a.name
ORDER BY total_reservas DESC
LIMIT 3;




-- 19. HAVING: Propietarios con más de 3 reservas (GROUP BY + HAVING)
SELECT 
    o.owner_id,
    o.first_name || ' ' || o.last_name AS propietario,
    COUNT(a.accommodation_id) AS cantidad_alojamientos
FROM owners o
INNER JOIN accommodations a ON o.owner_id = a.owner_id
GROUP BY o.owner_id, o.first_name, o.last_name
HAVING COUNT(a.accommodation_id) > 1;




-- 20. SUBCONSULTA: Alojamiento más caro (Subquery)
SELECT 
    accommodation_id,
    name AS alojamiento,
    base_price_per_night AS precio
FROM accommodations
WHERE base_price_per_night = (
    SELECT MAX(base_price_per_night) 
    FROM accommodations
);