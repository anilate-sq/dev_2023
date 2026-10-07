using System;
using System.Data;
using Microsoft.Data.SqlClient;

// Рассмотрим добавление нового товара.

string connectionString = "Server=localhost;Database=coffee_shop;Trusted_Connection=True;TrustServerCertificate=True;";

SqlConnection connection = new SqlConnection(connectionString);
connection.Open();

// Добавим новый товар в таблицу products.
string query = """INSERT INTO products (name, category_id, price) VALUES (@name, @category_id, @price);""";
using var command = new SqlCommand(query, connection);
command.Parameters.AddWithValue("@name", "Мокка");
command.Parameters.AddWithValue("@category_id", 1);
command.Parameters.AddWithValue("@price", 240);

int rowsAffected = command.ExecuteNonQuery();
Console.WriteLine($"Добавлено {rowsAffected} строк(и) в таблицу products.");
connection.Close();