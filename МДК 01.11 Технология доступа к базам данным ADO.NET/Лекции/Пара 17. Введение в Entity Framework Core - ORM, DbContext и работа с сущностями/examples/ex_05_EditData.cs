// Добавление
Product product = new Product
{
    Name = "Тестовый напиток",
    CategoryId = 1,
    Price = 150m,
    IsAvailable = true
};

db.Products.Add(product);
await db.SaveChangesAsync();
Console.WriteLine($"Создан товар с ID {product.Id}");

// Изменение
Product product = await db.Products.FindAsync(1);

if (product is not null)
{
    product.Price = 240m;
    await db.SaveChangesAsync();
}

// Удаление
Product product = await db.Products.FindAsync(1);

if (product is not null)
{
    db.Products.Remove(product);
    await db.SaveChangesAsync();
}