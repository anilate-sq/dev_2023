using Microsoft.Data.SqlClient;

// Сборка строки подключение
SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder
{
    DataSource = "localhost",
    InitialCatalog = "coffee_shop",
    IntegratedSecurity = true,
    TrustServerCertificate = true
};

string connectionString = builder.ConnectionString;

// Альтернативный способ работы