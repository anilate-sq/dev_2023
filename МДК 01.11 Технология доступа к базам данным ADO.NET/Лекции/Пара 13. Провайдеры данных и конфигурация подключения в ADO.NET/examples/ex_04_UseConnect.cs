// При условии, что конфиг создан

using Microsoft.Data.SqlClient;

await using SqlConnection connection = new SqlConnection(connectionString);
await connection.OpenAsync();

using SqlCommand command =
    new SqlCommand("SELECT COUNT(*) FROM products", connection);

int count = (int)(await command.ExecuteScalarAsync())!;
Console.WriteLine($"Товаров в кофейне: {count}");