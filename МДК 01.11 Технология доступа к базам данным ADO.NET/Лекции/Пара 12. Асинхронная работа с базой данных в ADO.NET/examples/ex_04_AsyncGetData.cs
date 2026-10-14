// Получение набора данных

using Microsoft.Data.SqlClient;

string connectionString =
	"Server=localhost;Database=coffee_shop;Trusted_Connection=True;TrustServerCertificate=True;";
await using SqlConnection connection = new SqlConnection(connectionString);
await connection.OpenAsync();

string sql = "SELECT id, name, price FROM products ORDER BY id";
using SqlCommand command = new SqlCommand(sql, connection);
await using SqlDataReader reader = await command.ExecuteReaderAsync();
while (await reader.ReadAsync())
{
	int id = reader.GetInt32(0);
	string name = reader.GetString(1);
	decimal price = reader.GetDecimal(2);
	Console.WriteLine($"{id}. {name} — {price} руб.");
}