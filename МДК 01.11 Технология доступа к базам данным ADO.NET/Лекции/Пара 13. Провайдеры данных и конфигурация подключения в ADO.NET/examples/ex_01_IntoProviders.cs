/*
    Провайдер - технология позволяющая реализовывать соединение и взаимодействие с конкретной СУБД.

    Базовые провайдеры:
    MS SQL Server - Mirosojt.Data.SqlClient
    PostgreSQL - Npgsql
    SQLite - Microsoft.Data.Sqlite
    MySQL / MariaDB - MySqlConnector

    Принципы адаптеров в ADO.NET идентичны
*/

using Microsoft.Data.SqlClient; // Подключаем провайдер

string connectionString =
    "Server=localhost;Database=coffee_shop;Trusted_Connection=True;TrustServerCertificate=True;"; // Строка подключения

using SqlConnection connection = new SqlConnection(connectionString); // Создаем соединение через провайдер
connection.Open(); // Открываем соединение