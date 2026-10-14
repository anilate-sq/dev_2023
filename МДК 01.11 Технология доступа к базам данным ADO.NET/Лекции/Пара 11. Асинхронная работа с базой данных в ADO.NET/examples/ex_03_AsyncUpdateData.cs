// Обновление данных

using Microsoft.Data.SqlClient;

string connectionString =
	"Server=localhost;Database=coffee_shop;Trusted_Connection=True;TrustServerCertificate=True;";
await using SqlConnection connection = new SqlConnection(connectionString);
await connection.OpenAsync();
string sql = "UPDATE products SET price = @price WHERE id = @id";
using SqlCommand command = new SqlCommand(sql, connection);
command.Parameters.AddWithValue("@price", 230m);
command.Parameters.AddWithValue("@id", 1);
int changed = await command.ExecuteNonQueryAsync();
Console.WriteLine($"Изменено строк: {changed}");