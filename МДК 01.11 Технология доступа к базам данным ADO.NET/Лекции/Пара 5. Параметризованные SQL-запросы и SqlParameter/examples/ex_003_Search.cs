using System;
using System.Data;
using Microsoft.Data.SqlClient;

// Рассмотрим поиск товара по названию.

string connectionString = "Server=localhost;Database=coffee_shop;Trusted_Connection=True;TrustServerCertificate=True;";

SqlConnection connection = new SqlConnection(connectionString);
connection.Open();

string name = "Капучино";

string query = "SELECT id, name, price FROM products WHERE name = @name";

using var command = new SqlCommand(query, connection);
command.Parameters.Add("@name", SqlDbType.NVarChar, 100).Value = name;

using var reader = command.ExecuteReader();
while (reader.Read()){
    Console.WriteLine($"id: {reader["id"]}, name: {reader["name"]}, price: {reader["price"]}");
}
connection.Close();