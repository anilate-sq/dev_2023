// Количество товаров в наличии
int availableCount = await db.Products
    .CountAsync(p => p.IsAvailable);
Console.WriteLine("Общее число товаров: " + availableCount);

// Средняя стоимость товаров во всем заведении
decimal averagePrice = await db.Products
    .AverageAsync(p => p.Price);
Console.WriteLine("Средняя стоимость товаров: " + averagePrice);

// Группировка по категориям
var statistics = await db.Products
    .GroupBy(p => p.CategoryId)
    .Select(g => new
    {
        CategoryId = g.Key,
        ProductCount = g.Count()
    })
    .ToListAsync();

foreach (var item in statistics)
{
    Console.WriteLine($"{item.CategoryId} | {item.ProductCount}");
}
