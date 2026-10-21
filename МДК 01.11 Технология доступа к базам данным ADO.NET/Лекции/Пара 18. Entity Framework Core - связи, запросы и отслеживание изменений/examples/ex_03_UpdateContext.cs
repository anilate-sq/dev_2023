// Создание сущности

using System.Dynamic;
using System.Reflection.Metadata;
using System.Runtime.CompilerServices;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualBasic;
using Microsoft.Data.SqlClient;

string connectionString =
	"Server=localhost;Database=coffee_shop;Trusted_Connection=True;TrustServerCertificate=True;";

var options = new DbContextOptionsBuilder<CoffeeShopContext>()
    .UseSqlServer(connectionString)
    .Options;

await using CoffeeShopContext db = new CoffeeShopContext(options);

List<Product> products = await db.Products
    .Include(p => p.Category)
    .ToListAsync();

foreach (Product product in products)
{
    Console.WriteLine($"{product.Name} — {product.Category.Name}");
}

public class Category
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;

    public List<Product> Products { get; set; } = new();
}

public class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public int CategoryId { get; set; }
    public decimal Price { get; set; }
    public bool IsAvailable { get; set; }
    public Category Category { get; set; } = null;
}

public class CoffeeShopContext : DbContext
{
    public CoffeeShopContext(DbContextOptions<CoffeeShopContext> options)
        : base(options) { }

    public DbSet<Product> Products => Set<Product>();
    public DbSet<Category> Categories => Set<Category>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Product>(entity =>
        {
            entity.ToTable("products");
            entity.HasKey(p => p.Id);

            entity.Property(p => p.Id).HasColumnName("id");
            entity.Property(p => p.Name).HasColumnName("name");
            entity.Property(p => p.CategoryId).HasColumnName("category_id");
            entity.Property(p => p.Price)
                .HasColumnName("price")
                .HasColumnType("decimal(10,2)");
            entity.Property(p => p.IsAvailable)
                .HasColumnName("is_available");
        });

        modelBuilder.Entity<Category>(entity =>
        {
            entity.ToTable("categories");
            entity.HasKey(c => c.Id);
            entity.Property(c => c.Id).HasColumnName("id");
            entity.Property(c => c.Name).HasColumnName("name");
        });

        // Создаем связь
        modelBuilder.Entity<Product>(entity =>
        {
            entity.HasOne(p => p.Category)
                .WithMany(c => c.Products)
                .HasForeignKey(p => p.CategoryId);
        });
    }
}
