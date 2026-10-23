USE [eventhub];
GO
-- 1. Контрольная статистика
SELECT N'events' AS table_name, COUNT(*) AS total FROM dbo.events
UNION ALL SELECT N'venues', COUNT(*) FROM dbo.venues
UNION ALL SELECT N'sessions', COUNT(*) FROM dbo.sessions
UNION ALL SELECT N'customers', COUNT(*) FROM dbo.customers
UNION ALL SELECT N'bookings', COUNT(*) FROM dbo.bookings
UNION ALL SELECT N'tickets', COUNT(*) FROM dbo.tickets;
GO
-- 2. Расписание
SELECT s.id, e.name AS event_name, v.name AS venue_name,
       s.starts_at, s.price, s.status
FROM dbo.sessions AS s
JOIN dbo.events AS e ON e.id = s.event_id
JOIN dbo.venues AS v ON v.id = s.venue_id
ORDER BY s.starts_at, e.name;
GO
-- 3. Вместимость и действующие брони по сеансам
SELECT s.id AS session_id, v.capacity,
       COALESCE(SUM(CASE WHEN b.status = 'confirmed' THEN b.quantity ELSE 0 END), 0) AS booked,
       v.capacity - COALESCE(SUM(CASE WHEN b.status = 'confirmed' THEN b.quantity ELSE 0 END), 0) AS free_seats
FROM dbo.sessions AS s
JOIN dbo.venues AS v ON v.id = s.venue_id
LEFT JOIN dbo.bookings AS b ON b.session_id = s.id
GROUP BY s.id, v.capacity
ORDER BY s.id;
GO
-- 4. Выявление расхождений между quantity и фактическим числом билетов.
SELECT b.id, b.quantity, COUNT(t.id) AS tickets_count
FROM dbo.bookings AS b
LEFT JOIN dbo.tickets AS t ON t.booking_id = b.id
GROUP BY b.id, b.quantity
HAVING b.quantity <> COUNT(t.id);
GO
-- 5. Выявление несогласованных статусов билетов и броней.
SELECT b.id AS booking_id, b.status AS booking_status, t.id AS ticket_id, t.status AS ticket_status
FROM dbo.bookings AS b
JOIN dbo.tickets AS t ON t.booking_id = b.id
WHERE (b.status = 'cancelled' AND t.status <> 'cancelled')
   OR (b.status = 'confirmed' AND t.status = 'cancelled');
GO
