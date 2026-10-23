-- EventHub | Microsoft SQL Server 2022/2025 | UTF-8
-- Учебный набор данных для зачётного проекта МДК 01.11.
-- Безопасный повторный запуск: если база eventhub уже существует, скрипт останавливается.
USE [master];
GO
IF DB_ID(N'eventhub') IS NOT NULL
    THROW 50001, N'База eventhub уже существует. Для повторной установки используйте другое имя или сохраните и удалите учебную базу вручную.', 1;
GO
CREATE DATABASE [eventhub];
GO
USE [eventhub];
GO
CREATE TABLE dbo.events (
    id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_events PRIMARY KEY,
    name nvarchar(150) NOT NULL,
    description nvarchar(500) NOT NULL,
    category nvarchar(80) NOT NULL,
    status varchar(20) NOT NULL CONSTRAINT DF_events_status DEFAULT ('draft'),
    CONSTRAINT CK_events_status CHECK (status IN ('draft','published','cancelled'))
);
CREATE TABLE dbo.venues (
    id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_venues PRIMARY KEY,
    name nvarchar(150) NOT NULL,
    address nvarchar(200) NOT NULL,
    capacity int NOT NULL,
    CONSTRAINT CK_venues_capacity CHECK (capacity > 0)
);
CREATE TABLE dbo.sessions (
    id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_sessions PRIMARY KEY,
    event_id int NOT NULL,
    venue_id int NOT NULL,
    starts_at datetime2(0) NOT NULL,
    price decimal(10,2) NOT NULL,
    status varchar(20) NOT NULL CONSTRAINT DF_sessions_status DEFAULT ('scheduled'),
    CONSTRAINT FK_sessions_events FOREIGN KEY (event_id) REFERENCES dbo.events(id),
    CONSTRAINT FK_sessions_venues FOREIGN KEY (venue_id) REFERENCES dbo.venues(id),
    CONSTRAINT CK_sessions_price CHECK (price >= 0),
    CONSTRAINT CK_sessions_status CHECK (status IN ('scheduled','cancelled','finished')),
    CONSTRAINT UQ_sessions_venue_time UNIQUE (venue_id, starts_at)
);
CREATE TABLE dbo.customers (
    id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_customers PRIMARY KEY,
    full_name nvarchar(150) NOT NULL,
    phone varchar(25) NOT NULL,
    email varchar(150) NULL,
    CONSTRAINT UQ_customers_phone UNIQUE (phone)
);
CREATE TABLE dbo.bookings (
    id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_bookings PRIMARY KEY,
    customer_id int NOT NULL,
    session_id int NOT NULL,
    quantity int NOT NULL,
    unit_price decimal(10,2) NOT NULL,
    status varchar(20) NOT NULL CONSTRAINT DF_bookings_status DEFAULT ('confirmed'),
    created_at datetime2(0) NOT NULL CONSTRAINT DF_bookings_created DEFAULT (SYSDATETIME()),
    CONSTRAINT FK_bookings_customers FOREIGN KEY (customer_id) REFERENCES dbo.customers(id),
    CONSTRAINT FK_bookings_sessions FOREIGN KEY (session_id) REFERENCES dbo.sessions(id),
    CONSTRAINT CK_bookings_quantity CHECK (quantity BETWEEN 1 AND 20),
    CONSTRAINT CK_bookings_unit_price CHECK (unit_price >= 0),
    CONSTRAINT CK_bookings_status CHECK (status IN ('confirmed','cancelled'))
);
CREATE TABLE dbo.tickets (
    id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_tickets PRIMARY KEY,
    booking_id int NOT NULL,
    ticket_code varchar(40) NOT NULL,
    status varchar(20) NOT NULL CONSTRAINT DF_tickets_status DEFAULT ('valid'),
    CONSTRAINT FK_tickets_bookings FOREIGN KEY (booking_id) REFERENCES dbo.bookings(id),
    CONSTRAINT UQ_tickets_code UNIQUE (ticket_code),
    CONSTRAINT CK_tickets_status CHECK (status IN ('valid','cancelled','used'))
);
CREATE INDEX IX_sessions_event_date ON dbo.sessions (event_id, starts_at);
CREATE INDEX IX_bookings_session_status ON dbo.bookings (session_id, status);
CREATE INDEX IX_tickets_booking_status ON dbo.tickets (booking_id, status);
GO
-- Справочник событий
INSERT INTO dbo.events (name, description, category, status) VALUES
(N'Фестиваль фонарей', N'Фестиваль', N'Прогулка среди световых инсталляций', 'published'),
(N'Зимняя ярмарка', N'Ярмарка', N'Праздничные павильоны и ремесленные мастерские', 'published'),
(N'Ночь таинственных историй', N'Тематический вечер', N'Истории и квесты в костюмах', 'published'),
(N'Кинопоказ под звёздами', N'Кино', N'Вечерний показ под открытым небом', 'published'),
(N'Городской музыкальный фестиваль', N'Концерт', N'Выступления молодых исполнителей', 'published'),
(N'Марафон настольных игр', N'Игры', N'Турниры и свободные игровые столы', 'published'),
(N'Фестиваль осеннего кофе', N'Фестиваль', N'Дегустации и мастер-классы', 'published'),
(N'Вечер джаза', N'Концерт', N'Живой джаз в камерном формате', 'published'),
(N'День комиксов', N'Выставка', N'Выставка художников и встречи с авторами', 'published'),
(N'Световой лабиринт', N'Фестиваль', N'Интерактивный маршрут с инсталляциями', 'published'),
(N'Космический кинолекторий', N'Лекция', N'Кино и обсуждение космоса', 'published'),
(N'Ночь музеев', N'Выставка', N'Экскурсии и интерактивные зоны', 'published'),
(N'Весенний бал', N'Праздник', N'Танцевальная программа', 'published'),
(N'Гик-пикник', N'Игры', N'Игры и научные мастерские', 'published'),
(N'Театральные выходные', N'Театр', N'Мини-спектакли и читки', 'published'),
(N'Фестиваль уличной еды', N'Ярмарка', N'Локальная гастрономия', 'published'),
(N'Летний open-air', N'Концерт', N'Музыка на открытой площадке', 'draft'),
(N'Закрытая вечеринка', N'Тематический вечер', N'Мероприятие отменено организатором', 'cancelled'),
(N'Новогодний квест', N'Праздник', N'Праздничные испытания для команд', 'published'),
(N'Ретро-киноночь', N'Кино', N'Подборка культовых фильмов', 'published');
-- Площадки
INSERT INTO dbo.venues (name,address,capacity) VALUES
(N'Центральный парк', N'ул. Парковая, 1', 250),
(N'Культурный центр', N'пр-т Мира, 18', 120),
(N'Концертный зал «Ритм»', N'ул. Музыкальная, 7', 180),
(N'Кинодвор', N'ул. Садовая, 24', 90),
(N'Арт-пространство «Маяк»', N'наб. Светлая, 3', 65),
(N'Городской музей', N'ул. Историческая, 11', 75),
(N'Малая сцена', N'ул. Театральная, 5', 40);
-- Покупатели — вымышленные данные
INSERT INTO dbo.customers (full_name,phone,email) VALUES
(N'Мария Орлова', '79000000001', 'guest01@example.test'),
(N'Дмитрий Соколов', '79000000002', 'guest02@example.test'),
(N'Анна Белова', '79000000003', 'guest03@example.test'),
(N'Артём Лебедев', '79000000004', 'guest04@example.test'),
(N'Екатерина Миронова', '79000000005', 'guest05@example.test'),
(N'Максим Новиков', '79000000006', 'guest06@example.test'),
(N'София Волкова', '79000000007', 'guest07@example.test'),
(N'Илья Кузнецов', '79000000008', 'guest08@example.test'),
(N'Полина Фёдорова', '79000000009', 'guest09@example.test'),
(N'Никита Павлов', '79000000010', 'guest10@example.test'),
(N'Елизавета Семёнова', '79000000011', 'guest11@example.test'),
(N'Кирилл Морозов', '79000000012', 'guest12@example.test'),
(N'Виктория Жукова', '79000000013', 'guest13@example.test'),
(N'Александр Исаев', '79000000014', 'guest14@example.test'),
(N'Дарья Крылова', '79000000015', 'guest15@example.test'),
(N'Тимофей Назаров', '79000000016', 'guest16@example.test'),
(N'Алина Громова', '79000000017', 'guest17@example.test'),
(N'Денис Захаров', '79000000018', 'guest18@example.test'),
(N'Валерия Титова', '79000000019', 'guest19@example.test'),
(N'Роман Ковалёв', '79000000020', 'guest20@example.test'),
(N'Олеся Антонова', '79000000021', 'guest21@example.test'),
(N'Глеб Воробьёв', '79000000022', 'guest22@example.test'),
(N'Карина Фролова', '79000000023', 'guest23@example.test'),
(N'Матвей Богданов', '79000000024', 'guest24@example.test'),
(N'Милана Сергеева', '79000000025', 'guest25@example.test');
GO

-- 37 сеансов (в том числе завершённый и отменённый); все времена локальные, для учебного сценария.
INSERT INTO dbo.sessions (event_id,venue_id,starts_at,price,status) VALUES
(1, 1, '2026-12-01T16:00:00', 450.00, 'scheduled'),
(1, 4, '2026-12-02T19:30:00', 450.00, 'scheduled'),
(2, 2, '2026-12-03T16:00:00', 600.00, 'finished'),
(2, 5, '2026-12-04T19:30:00', 600.00, 'scheduled'),
(3, 3, '2026-12-05T16:00:00', 750.00, 'scheduled'),
(3, 6, '2026-12-06T19:30:00', 750.00, 'scheduled'),
(4, 4, '2026-12-07T16:00:00', 900.00, 'scheduled'),
(4, 7, '2026-12-08T19:30:00', 900.00, 'scheduled'),
(5, 5, '2026-12-09T16:00:00', 350.00, 'scheduled'),
(5, 1, '2026-12-10T19:30:00', 350.00, 'scheduled'),
(6, 6, '2026-12-11T16:00:00', 500.00, 'scheduled'),
(6, 2, '2026-12-12T19:30:00', 500.00, 'scheduled'),
(7, 7, '2026-12-13T16:00:00', 1100.00, 'scheduled'),
(7, 3, '2026-12-14T19:30:00', 1100.00, 'scheduled'),
(8, 1, '2026-12-15T16:00:00', 450.00, 'scheduled'),
(8, 4, '2026-12-16T19:30:00', 450.00, 'scheduled'),
(9, 2, '2026-12-17T16:00:00', 600.00, 'scheduled'),
(9, 5, '2026-12-18T19:30:00', 600.00, 'scheduled'),
(10, 3, '2026-12-19T16:00:00', 750.00, 'scheduled'),
(10, 6, '2026-12-20T19:30:00', 750.00, 'scheduled'),
(11, 4, '2026-12-21T16:00:00', 900.00, 'scheduled'),
(11, 7, '2026-12-22T19:30:00', 900.00, 'scheduled'),
(12, 5, '2026-12-23T16:00:00', 350.00, 'scheduled'),
(12, 1, '2026-12-24T19:30:00', 350.00, 'scheduled'),
(13, 6, '2026-12-25T16:00:00', 500.00, 'scheduled'),
(13, 2, '2026-12-26T19:30:00', 500.00, 'scheduled'),
(14, 7, '2026-12-27T16:00:00', 1100.00, 'scheduled'),
(14, 3, '2026-12-01T19:30:00', 1100.00, 'scheduled'),
(15, 1, '2026-12-02T16:00:00', 450.00, 'scheduled'),
(15, 4, '2026-12-03T19:30:00', 450.00, 'scheduled'),
(16, 2, '2026-12-04T16:00:00', 600.00, 'scheduled'),
(16, 5, '2026-12-05T19:30:00', 600.00, 'scheduled'),
(18, 4, '2026-12-08T16:00:00', 900.00, 'cancelled'),
(19, 5, '2026-12-10T16:00:00', 350.00, 'scheduled'),
(19, 1, '2026-12-11T19:30:00', 350.00, 'scheduled'),
(20, 6, '2026-12-12T16:00:00', 500.00, 'scheduled'),
(20, 2, '2026-12-13T19:30:00', 500.00, 'scheduled');
GO

-- Исходные бронирования создаются вместе с билетами.
-- Назначенные цены — снимок стоимости на момент бронирования.
INSERT INTO dbo.bookings (customer_id,session_id,quantity,unit_price,status,created_at) VALUES
(1, 1, 1, 450.00, 'cancelled', DATEADD(day,-1,CAST('2026-12-01T10:00:00' AS datetime2))),
(2, 5, 2, 750.00, 'confirmed', DATEADD(day,-2,CAST('2026-12-01T10:00:00' AS datetime2))),
(3, 8, 3, 900.00, 'confirmed', DATEADD(day,-3,CAST('2026-12-01T10:00:00' AS datetime2))),
(4, 11, 1, 500.00, 'confirmed', DATEADD(day,-4,CAST('2026-12-01T10:00:00' AS datetime2))),
(5, 14, 2, 1100.00, 'confirmed', DATEADD(day,-5,CAST('2026-12-01T10:00:00' AS datetime2))),
(6, 17, 3, 600.00, 'confirmed', DATEADD(day,-6,CAST('2026-12-01T10:00:00' AS datetime2))),
(7, 20, 1, 750.00, 'confirmed', DATEADD(day,-7,CAST('2026-12-01T10:00:00' AS datetime2))),
(8, 23, 2, 350.00, 'confirmed', DATEADD(day,-8,CAST('2026-12-01T10:00:00' AS datetime2))),
(9, 26, 3, 500.00, 'confirmed', DATEADD(day,-9,CAST('2026-12-01T10:00:00' AS datetime2))),
(10, 29, 1, 450.00, 'cancelled', DATEADD(day,-10,CAST('2026-12-01T10:00:00' AS datetime2))),
(11, 32, 2, 600.00, 'confirmed', DATEADD(day,-11,CAST('2026-12-01T10:00:00' AS datetime2))),
(12, 36, 3, 500.00, 'confirmed', DATEADD(day,-12,CAST('2026-12-01T10:00:00' AS datetime2))),
(13, 2, 1, 450.00, 'confirmed', DATEADD(day,-1,CAST('2026-12-01T10:00:00' AS datetime2))),
(14, 6, 2, 750.00, 'confirmed', DATEADD(day,-2,CAST('2026-12-01T10:00:00' AS datetime2))),
(15, 9, 3, 350.00, 'confirmed', DATEADD(day,-3,CAST('2026-12-01T10:00:00' AS datetime2))),
(16, 12, 1, 500.00, 'confirmed', DATEADD(day,-4,CAST('2026-12-01T10:00:00' AS datetime2))),
(17, 15, 2, 450.00, 'confirmed', DATEADD(day,-5,CAST('2026-12-01T10:00:00' AS datetime2))),
(18, 18, 3, 600.00, 'confirmed', DATEADD(day,-6,CAST('2026-12-01T10:00:00' AS datetime2))),
(19, 21, 1, 900.00, 'cancelled', DATEADD(day,-7,CAST('2026-12-01T10:00:00' AS datetime2))),
(20, 24, 2, 350.00, 'confirmed', DATEADD(day,-8,CAST('2026-12-01T10:00:00' AS datetime2))),
(21, 27, 3, 1100.00, 'confirmed', DATEADD(day,-9,CAST('2026-12-01T10:00:00' AS datetime2))),
(22, 30, 1, 450.00, 'confirmed', DATEADD(day,-10,CAST('2026-12-01T10:00:00' AS datetime2))),
(23, 34, 2, 350.00, 'confirmed', DATEADD(day,-11,CAST('2026-12-01T10:00:00' AS datetime2))),
(24, 37, 3, 500.00, 'confirmed', DATEADD(day,-12,CAST('2026-12-01T10:00:00' AS datetime2)));
GO
INSERT INTO dbo.tickets (booking_id,ticket_code,status) VALUES
(1, 'EVH-0001-01', 'cancelled'),
(2, 'EVH-0002-01', 'valid'),
(2, 'EVH-0002-02', 'valid'),
(3, 'EVH-0003-01', 'valid'),
(3, 'EVH-0003-02', 'valid'),
(3, 'EVH-0003-03', 'valid'),
(4, 'EVH-0004-01', 'valid'),
(5, 'EVH-0005-01', 'valid'),
(5, 'EVH-0005-02', 'valid'),
(6, 'EVH-0006-01', 'valid'),
(6, 'EVH-0006-02', 'valid'),
(6, 'EVH-0006-03', 'valid'),
(7, 'EVH-0007-01', 'valid'),
(8, 'EVH-0008-01', 'valid'),
(8, 'EVH-0008-02', 'valid'),
(9, 'EVH-0009-01', 'valid'),
(9, 'EVH-0009-02', 'valid'),
(9, 'EVH-0009-03', 'valid'),
(10, 'EVH-0010-01', 'cancelled'),
(11, 'EVH-0011-01', 'valid'),
(11, 'EVH-0011-02', 'valid'),
(12, 'EVH-0012-01', 'valid'),
(12, 'EVH-0012-02', 'valid'),
(12, 'EVH-0012-03', 'valid'),
(13, 'EVH-0013-01', 'valid'),
(14, 'EVH-0014-01', 'valid'),
(14, 'EVH-0014-02', 'valid'),
(15, 'EVH-0015-01', 'valid'),
(15, 'EVH-0015-02', 'valid'),
(15, 'EVH-0015-03', 'valid'),
(16, 'EVH-0016-01', 'valid'),
(17, 'EVH-0017-01', 'valid'),
(17, 'EVH-0017-02', 'valid'),
(18, 'EVH-0018-01', 'valid'),
(18, 'EVH-0018-02', 'valid'),
(18, 'EVH-0018-03', 'valid'),
(19, 'EVH-0019-01', 'cancelled'),
(20, 'EVH-0020-01', 'valid'),
(20, 'EVH-0020-02', 'valid'),
(21, 'EVH-0021-01', 'valid'),
(21, 'EVH-0021-02', 'valid'),
(21, 'EVH-0021-03', 'valid'),
(22, 'EVH-0022-01', 'valid'),
(23, 'EVH-0023-01', 'valid'),
(23, 'EVH-0023-02', 'valid'),
(24, 'EVH-0024-01', 'valid'),
(24, 'EVH-0024-02', 'valid'),
(24, 'EVH-0024-03', 'valid');
GO
-- Диагностические запросы. Должны вернуться: 20 событий, 7 площадок,
-- 25 покупателей, 37 сеансов, 24 бронирования; билеты = SUM(quantity).
SELECT 'events' AS entity, COUNT(*) AS total FROM dbo.events
UNION ALL SELECT 'venues', COUNT(*) FROM dbo.venues
UNION ALL SELECT 'sessions', COUNT(*) FROM dbo.sessions
UNION ALL SELECT 'customers', COUNT(*) FROM dbo.customers
UNION ALL SELECT 'bookings', COUNT(*) FROM dbo.bookings
UNION ALL SELECT 'tickets', COUNT(*) FROM dbo.tickets;
GO
