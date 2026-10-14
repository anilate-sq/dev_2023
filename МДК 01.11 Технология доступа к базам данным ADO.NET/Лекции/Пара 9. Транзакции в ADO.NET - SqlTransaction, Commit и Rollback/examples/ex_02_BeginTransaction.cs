
// Создаем подключение и транзакцию
using SqlConnection connection = new SqlConnection(connectionString);
connection.Open();

using SqlTransaction transaction = connection.BeginTransaction(); // Создали транзакцию

// Делаем запрос и добавляем его в транзакцию
string sql = "UPDATE products SET price = @price WHERE id = @id"; // Обновление цены продукта

using SqlCommand command = new SqlCommand(sql, connection, transaction); // Создаем параметризированный запрос и добавляем в транзакцию
command.Parameters.AddWithValue("@price", 250m);
command.Parameters.AddWithValue("@id", 1);

int changedRows = command.ExecuteNonQuery(); // Выполняем запросы
