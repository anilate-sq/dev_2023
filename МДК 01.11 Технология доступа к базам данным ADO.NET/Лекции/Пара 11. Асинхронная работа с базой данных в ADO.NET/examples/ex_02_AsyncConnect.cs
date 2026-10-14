using Microsoft.Data.SqlClient;
string connectionString =
	"Server=localhost;Database=coffee_shop;Trusted_Connection=True;TrustServerCertificate=True;";

await using SqlConnection connection = new SqlConnection(connectionString); // Мы не начнем работу пока не сработает это
await connection.OpenAsync(); // Ассинхронное подключение
Console.WriteLine("Подключение открыто.");

string sql = "SELECT COUNT(*) FROM products";
using SqlCommand command = new SqlCommand(sql, connection);
int count = (int)(await command.ExecuteScalarAsync())!;
Console.WriteLine($"Всего товаров: {count}");

