// SqlDataAdapter - преобразование данных. С помощью него можем заполнить DataTable и DataSet данными из SQL-запроса

using System.Data;
using Microsoft.Data.SqlClient;

string connectionString =
    "Server=localhost;Database=coffee_shop;Trusted_Connection=True;TrustServerCertificate=True;";

string sql = "SELECT id, name, price, is_available FROM products";

using SqlConnection connection = new SqlConnection(connectionString);
using SqlDataAdapter adapter = new SqlDataAdapter(sql, connection);

DataTable products = new DataTable();
adapter.Fill(products); // заполняем DataTable данными из адаптера

Console.WriteLine($"Загружено товаров: {products.Rows.Count}");

// Вывод данных с DataTable
foreach (DataRow row in products.Rows)
{
    int id = row.Field<int>("id");
    string name = row.Field<string>("name")!;
    decimal price = row.Field<decimal>("price");
    bool isAvailable = row.Field<bool>("is_available");

    Console.WriteLine($"{id}. {name} — {price} руб.");
    Console.WriteLine(isAvailable ? "Доступен" : "Недоступен");
}

// Фильтрация данных и сортировка
DataRow[] available = products.Select("is_available = true", "price ASC"); // Получаем все товары, которые есть в наличии и сортируем их по цене

foreach (DataRow row in available)
{
    Console.WriteLine($"{row["name"]} — {row["price"]} руб.");
}

// Убираем дубликацию таблицы
products.DefaultView.Sort = "price DESC"; // Обратная сортировка и создание представления

// Создаем представление и выводим его содержание
foreach (DataRowView row in products.DefaultView)
{
    Console.WriteLine($"{row["name"]} — {row["price"]} руб.");
}