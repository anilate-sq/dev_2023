// DataTable
using System.Data;

DataTable products = new DataTable("products");

products.Columns.Add("id", typeof(int));
products.Columns.Add("name", typeof(string));
products.Columns.Add("price", typeof(decimal));

products.Rows.Add(1, "Капучино", 210m);
products.Rows.Add(2, "Латте", 230m);

foreach (DataRow row in products.Rows)
{
    Console.WriteLine($"{row["id"]}. {row["name"]} — {row["price"]} руб.");
}