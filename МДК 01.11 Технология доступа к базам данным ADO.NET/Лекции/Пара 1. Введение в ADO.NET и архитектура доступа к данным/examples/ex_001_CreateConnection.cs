using System.Data;
using System.Data.SqlTypes;
using Microsoft.Data.SqlClient;


// Строка подключения: Server=хост;Database=имя_бд;Trusted_Connection=True;TrustServerCertificate=True;
string connectionString = "Server=localhost;Database=college;Trusted_Connection=True;TrustServerCertificate=True;";

// Подключение к базе
using var connection = new SqlConnection(connectionString);
connection.Open(); // Открыть соединение с базой
Console.WriteLine($"Версия SQL Server:  {connection.ServerVersion}");

using var command = new SqlCommand("SELECT last_name, first_name, group_id FROM students", connection);
using var reader = command.ExecuteReader(); // Выполнить запрос + вписать полученные данные в переменную

// Чтение и вывод результатов запроса
while (reader.Read())
{    
    string lastName = reader.GetString(0); // Получить первую колонку с результата запроса
    string firstName = reader.GetString(1); // Получить вторую колонку с результата запроса
    int groupID = reader.GetInt32(2); // Получить третья колонку с результата запроса
    Console.WriteLine($"{lastName} | {firstName} | {groupID}");
}
reader.Close();
using var ins_command = new SqlCommand("insert into groups(name, date) values (@name, @date); select SCOPE_IDENTITY();", connection);
ins_command.Parameters.AddWithValue("@name", "9/3-РПО-24/1");
ins_command.Parameters.AddWithValue("@date", "2025-01-21");

// Можем вывести новое значение
int newID = Convert.ToInt32(ins_command.ExecuteScalar());
Console.WriteLine("Новый id = ", newID);

connection.Close();