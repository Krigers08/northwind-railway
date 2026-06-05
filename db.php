<?php
function get_pdo(): PDO {
    $options = [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ];
    
    // Check for Wasmer MySQL environment variables
    $db_host = getenv('DB_HOST');
    if ($db_host) {
        $db_name = getenv('DB_NAME') ?: 'northwind';
        $db_user = getenv('DB_USERNAME') ?: 'root';
        $db_pass = getenv('DB_PASSWORD') ?: '';
        $db_port = getenv('DB_PORT') ?: 3306;
        
        $dsn = "mysql:host=$db_host;port=$db_port;dbname=$db_name;charset=utf8mb4";
        return new PDO($dsn, $db_user, $db_pass, array_merge($options, [
            PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false,
        ]));
    }
    
    // Check for DATABASE_URL (PostgreSQL/Railway)
    $database_url = getenv('DATABASE_URL');
    if ($database_url) {
        $url = parse_url($database_url);
        $db_host = $url['host'] ?? 'localhost';
        $db_port = $url['port'] ?? 5432;
        $db_name = ltrim($url['path'] ?? '', '/');
        $db_user = $url['user'] ?? '';
        $db_pass = $url['pass'] ?? '';
        
        $dsn = "pgsql:host=$db_host;port=$db_port;dbname=$db_name";
        return new PDO($dsn, $db_user, $db_pass, $options);
    }
    
    // Default to SQLite for local development
    $db_file = __DIR__ . '/data.db';
    $dsn = "sqlite:$db_file";
    
    return new PDO($dsn, null, null, $options);
}


try {
    $pdo = get_pdo();
} catch (PDOException $e) {
    http_response_code(500);
    die(json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]));
}
