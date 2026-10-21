
// Чтение данных
List<Product> products = await db.Products.ToListAsync();

foreach (Product product in products)
{
    Console.WriteLine($"{product.Id}. {product.Name} — {product.Price} руб.");
}

// Фильтрация
List<Product> availableProducts = await db.Products
    .Where(p => p.IsAvailable)
    .OrderBy(p => p.Price)
    .ToListAsync();
foreach (Product product in availableProducts)
{
    Console.WriteLine($"{product.Id}. {product.Name} — {product.Price} руб.");
}

// Поиск
Product? product = await db.Products.FindAsync(1);

if (product is null)
{
    Console.WriteLine("Товар не найден.");
}
else
{
    Console.WriteLine($"{product.Name} — {product.Price}");
}