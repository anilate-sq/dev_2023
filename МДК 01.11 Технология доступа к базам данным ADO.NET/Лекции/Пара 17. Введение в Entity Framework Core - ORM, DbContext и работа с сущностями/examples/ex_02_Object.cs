// Создание сущности

using Microsoft.EntityFrameworkCore;

/*
    Таблица `products`:
    - id;
    - name;
    - category_id;
    - price;
    - is_available
*/

// Создадим сущность
public class Product
{
    public int Id { get; set; }
    public int Name { get; set; } = string.Empty;
    public int CategoryId { get; set; }
    public decimal Price { get; set; }
    public bool IsAvailable { get; set; }
}

