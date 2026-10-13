// Транзакция на создание заказа и добавление товара в него
using SqlConnection connection = new SqlConnection(connectionString);
connection.Open();

using SqlTransaction transaction = connection.BeginTransaction();

try
{
    // Добавляем заказ
    string orderSql = @"
        INSERT INTO orders (customer_id, order_date, status)
        VALUES (@customer_id, SYSDATETIME(), N'Новый');
        SELECT CAST(SCOPE_IDENTITY() AS int);";

    using SqlCommand orderCommand =
        new SqlCommand(orderSql, connection, transaction);

    orderCommand.Parameters.AddWithValue("@customer_id", 1);
    int orderId = (int)orderCommand.ExecuteScalar()!;

    // Добавляем товар к заказу
    string itemSql = @"
        INSERT INTO order_items (order_id, product_id, quantity, unit_price)
        VALUES (@order_id, @product_id, @quantity, @unit_price)";

    using SqlCommand itemCommand =
        new SqlCommand(itemSql, connection, transaction);

    itemCommand.Parameters.AddWithValue("@order_id", orderId);
    itemCommand.Parameters.AddWithValue("@product_id", 1);
    itemCommand.Parameters.AddWithValue("@quantity", 2);
    itemCommand.Parameters.AddWithValue("@unit_price", 180m);

    itemCommand.ExecuteNonQuery();
    transaction.Commit();

    Console.WriteLine($"Заказ №{orderId} создан.");
}
catch (Exception ex)
{
    try { transaction.Rollback(); }
    catch (Exception rollbackEx)
    {
        Console.WriteLine($"Ошибка отката: {rollbackEx.Message}");
    }
    Console.WriteLine($"Не удалось создать заказ: {ex.Message}");
}