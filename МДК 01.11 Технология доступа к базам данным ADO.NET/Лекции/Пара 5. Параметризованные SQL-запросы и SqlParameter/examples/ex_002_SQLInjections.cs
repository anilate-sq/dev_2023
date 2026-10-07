using Microsoft.Data.SqlClient;
using System;
using System.Data;

string connectionString = "Server=localhost;Database=college;Trusted_Connection=True;TrustServerCertificate=True;";

int productId = 3;

string query = "SELECT * FROM Products WHERE id = @id";
using var command = new SqlCommand(query, new SqlConnection(connectionString));
command.Parameters.Add("@id", SqlDbType.Int).Value = productId; // @id - имя параметра, SqlDbType.Int - тип данных параметра, Value - значение параметра

// Параметры впервую очередь нужны для предотвращения SQL-инъекций, а также для удобства передачи значений в запросы.
// SQL-инъекция - это когда злоумышленник может вставить в запрос свой SQL-код, который будет выполнен на сервере. Например, если бы мы использовали строку запроса без параметров, то можно было бы передать значение "3 OR 1=1", и тогда запрос вернул бы все записи из таблицы Products. Использование параметров предотвращает такие атаки, так как значение параметра не интерпретируется как часть SQL-кода.

