using System;
using System.Data;
using Microsoft.Data.SqlClient;

// Рассмотрим обновление данных товара.

string connectionString = "Server=localhost;Database=coffee_shop;Trusted_Connection=True;TrustServerCertificate=True;";

SqlConnection connection = new SqlConnection(connectionString);
connection.Open();

// Обновление цены товара.

using var command = new SqlCommand("UPDATE products SET price = @price WHERE name = @name", connection);
command.Parameters.AddWithValue("@name", "Капучино");
command.Parameters.AddWithValue("@price", 250);

int rowsAffected = command.ExecuteNonQuery();
Console.WriteLine($"Количество обновленных строк: {rowsAffected}");
connection.Close();