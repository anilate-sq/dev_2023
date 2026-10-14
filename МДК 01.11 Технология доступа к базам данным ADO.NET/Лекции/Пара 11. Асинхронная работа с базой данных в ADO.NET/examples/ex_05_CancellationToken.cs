// Обработка ошибок и отмена операции

using Microsoft.Data.SqlClient;

string connectionString =
	"Server=localhost;Database=coffee_shop;Trusted_Connection=True;TrustServerCertificate=True;";
await using SqlConnection connection = new SqlConnection(connectionString);
await connection.OpenAsync();

using CancellationTokenSource cts = new CancellationTokenSource();
cts.CancelAfter(TimeSpan.FromSeconds(5)); // Если запрос не выполнился в течении 5 секунд, мы его отменяем
try
{
	await using SqlConnection connection =
		new SqlConnection(connectionString);
	await connection.OpenAsync(cts.Token);
	using SqlCommand command = new SqlCommand(
		"SELECT COUNT(*) FROM products", connection);
	int count = (int)(await command.ExecuteScalarAsync(cts.Token))!;
	Console.WriteLine(count);
}
catch (OperationCanceledException)
{
	Console.WriteLine("Операция отменена.");
}