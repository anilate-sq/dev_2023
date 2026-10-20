// SqlDataAdapter - преобразование данных. С помощью него можем заполнить DataTable и DataSet данными из SQL-запроса

using System.Data;
using Microsoft.Data.SqlClient;

string connectionString =
    "Server=localhost;Database=coffee_shop;Trusted_Connection=True;TrustServerCertificate=True;";

string sql = "SELECT id, name, price, is_available FROM products";

using SqlConnection connection = new SqlConnection(connectionString);
using SqlDataAdapter adapter = new SqlDataAdapter(sql, connection);

DataTable products = new DataTable();
adapter.Fill(products);

Console.WriteLine($"Загружено товаров: {products.Rows.Count}");