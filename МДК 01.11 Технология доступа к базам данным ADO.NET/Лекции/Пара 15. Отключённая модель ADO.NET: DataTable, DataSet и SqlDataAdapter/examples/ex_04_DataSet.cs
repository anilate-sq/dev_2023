// DataSet - хранилище связанных таблиц

using System.Data;
using Microsoft.Data.SqlClient;

DataSet shopData = new DataSet("coffee_shop"); // Создание хранилища

using SqlConnection connection = new SqlConnection(connectionString);

using SqlDataAdapter productsAdapter = new SqlDataAdapter(
    "SELECT id, name, category_id, price, is_available FROM products",
    connection);

using SqlDataAdapter categoriesAdapter = new SqlDataAdapter(
    "SELECT id, name FROM categories", connection);

productsAdapter.Fill(shopData, "products"); // записываем в DataSet данные из productsAdapter
categoriesAdapter.Fill(shopData, "categories"); // записываем в DataSet данные из categoriesAdapter

Console.WriteLine($"Таблиц в DataSet: {shopData.Tables.Count}");
Console.WriteLine($"Товаров: {shopData.Tables["products"].Rows.Count}");

DataTable categories = shopData.Tables["categories"];
DataTable productsTable = shopData.Tables["products"];

// Создание отношения между таблицами
shopData.Relations.Add(
    "category_products",
    categories.Columns["id"],
    productsTable.Columns["category_id"]);

// Вывод данных
foreach (DataRow category in categories.Rows)
{
    Console.WriteLine($"Категория: {category["name"]}");

    foreach (DataRow product in category.GetChildRows("category_products"))
    {
        Console.WriteLine($"  {product["name"]}");
    }
}

DataRow product = products.Rows[0];
product["price"] = 250m; // Обновление цены

Console.WriteLine($"Новая цена в памяти: {product["price"]}");