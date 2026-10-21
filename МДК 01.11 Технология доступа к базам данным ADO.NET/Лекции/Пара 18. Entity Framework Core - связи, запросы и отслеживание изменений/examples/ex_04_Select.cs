// Использование связи

List<Product> products = await db.Products
    .Include(p => p.Category)
    .ToListAsync();

foreach (Product product in products)
{
    Console.WriteLine($"{product.Name} — {product.Category.Name}");
}

// Обратная связь
List<Category> categories = await db.Categories
    .Include(c => c.Products)
    .ToListAsync();

foreach (Category category in categories)
{
    Console.WriteLine($"Категория: {category.Name}");

    foreach (Product product in category.Products)
    {
        Console.WriteLine($"  {product.Name} — {product.Price} руб.");
    }
}

// Использование проекций
var catalog = await db.Products
    .Where(p => p.IsAvailable)
    .OrderBy(p => p.Price)
    .Select(p => new
    {
        p.Name,
        p.Price,
        CategoryName = p.Category.Name
    })
    .ToListAsync();

foreach (var item in catalog)
{
    Console.WriteLine($"{item.Name} | {item.CategoryName} | {item.Price}");
}
