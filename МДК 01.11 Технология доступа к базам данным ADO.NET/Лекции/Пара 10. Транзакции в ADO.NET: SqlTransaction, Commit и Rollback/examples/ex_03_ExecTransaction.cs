using SqlConnection connection = new SqlConnection(connectionString);
connection.Open();

using SqlTransaction transaction = connection.BeginTransaction();

try
{
    using SqlCommand command = new SqlCommand(
        "UPDATE products SET price = @price WHERE id = @id",
        connection,
        transaction);

    command.Parameters.AddWithValue("@price", 250m);
    command.Parameters.AddWithValue("@id", 1);

    command.ExecuteNonQuery();
    transaction.Commit(); // Коммитим транзакцию

    Console.WriteLine("Изменения сохранены.");
}
catch (Exception ex)
{
    try
    {
        transaction.Rollback(); // Откатывае изменения в случае ошибки
    }
    catch (Exception rollbackEx)
    {
        Console.WriteLine($"Не удалось выполнить откат: {rollbackEx.Message}"); // Если не получилось откат, просто отправляем Exception
    }

    Console.WriteLine($"Ошибка: {ex.Message}");
}