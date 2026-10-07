using System;
using System.Data;
using Microsoft.Data.SqlClient;

// Рассмотрим поиск товара по названию.

string connectionString = "Server=localhost;Database=coffee_shop;Trusted_Connection=True;TrustServerCertificate=True;";

SqlConnection connection = new SqlConnection(connectionString);
connection.Open();

// Добавим новый товар в таблицу products.
string query = """DELETE FROM products WHERE name = @name""";
using var command = new SqlCommand(query, connection);
command.Parameters.AddWithValue("@name", "Мокка");

Console.WriteLine($"Удалено {command.ExecuteNonQuery()} строк");
connection.Close();