// Использование конфига

// Если исполняемый файл .csprof - В нем нужно будет указать конфиг, пример взять из лекции

using Microsoft.Extensions.Configuration;

IConfiguration configuration = new ConfigurationBuilder()
    .SetBasePath(AppContext.BaseDirectory)
    .AddJsonFile("appsettings.json", optional: false)
    .AddEnvironmentVariables()
    .Build();

string connectionString = configuration.GetConnectionString("CoffeeShop")
    ?? throw new InvalidOperationException(
        "Строка подключения CoffeeShop не найдена.");