// Отключение отслеживания изменения данных, можно использовать, когда
// требуется исключительно получать данные 
List<Product> products = await db.Products
    .AsNoTracking()
    .Where(p => p.IsAvailable)
    .ToListAsync();

// Опционально