// База

Console.Write("Введите параметр: ");
string param = Console.ReadLine();

string connectionString = "Server=localhost;Database=college;Trusted_Connection=True;TrustServerCertificate=True;";

// string sql = "SELECT * FROM Users WHERE Name = " + param;

// Но нам эт не особо интересно
// У нас есть SqlParameter, который позволяет нам безопасно передавать параметры в SQL-запросы, предотвращая SQL-инъекции.

string sqlSafe = "SELECT * FROM Users WHERE Name = @name"; // @name - это параметр, который мы будем передавать в запрос

// Параметризованный запрос — это SQL-запрос, в котором значения передаются отдельно от самого текста SQL.

// Создаем SqlCommand и SqlParameter
SqlCommand cmd = new SqlCommand(sqlSafe, connection);
cmd.Parameters.AddWithValue("@name", param);
