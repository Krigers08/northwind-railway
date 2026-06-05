<?php
function get_pdo(): PDO {
    // Try DATABASE_PUBLIC_URL first, then DATABASE_URL, then individual vars
    $url = getenv('DATABASE_PUBLIC_URL') ?: getenv('DATABASE_URL');

    if ($url) {
        $parts = parse_url($url);
        $host   = $parts['host'];
        $port   = $parts['port'] ?? 3306;
        $dbname = ltrim($parts['path'], '/');
        $user   = $parts['user'];
        $pass   = $parts['pass'];
    } else {
        $host   = getenv('DB_HOST')     ?: 'localhost';
        $port   = getenv('DB_PORT')     ?: '3306';
        $dbname = getenv('DB_NAME')     ?: 'railway';
        $user   = getenv('DB_USER')     ?: 'root';
        $pass   = getenv('DB_PASSWORD') ?: '';
    }

    $dsn = "mysql:host=$host;port=$port;dbname=$dbname;charset=utf8mb4;ssl=0";
    $options = [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ];
    
    return new PDO($dsn, $user, $pass, $options);
}

try {
    $pdo = get_pdo();
} catch (PDOException $e) {
    http_response_code(500);
    die(json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]));
}
