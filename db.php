<?php
// db.php - Database connection using Railway env vars

function get_pdo(): PDO {
    $database_url = getenv('DATABASE_URL');

    if ($database_url) {
        $url = parse_url($database_url);
        $host = $url['host'];
        $port = $url['port'] ?? 5432;
        $dbname = ltrim($url['path'], '/');
        $user = $url['user'];
        $pass = $url['pass'];
    } else {
        $host     = getenv('PGHOST')     ?: 'localhost';
        $port     = getenv('PGPORT')     ?: '5432';
        $dbname   = getenv('PGDATABASE') ?: 'northwind';
        $user     = getenv('PGUSER')     ?: 'postgres';
        $pass     = getenv('PGPASSWORD') ?: '';
    }

    $dsn = "pgsql:host=$host;port=$port;dbname=$dbname";
    return new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
}

try {
    $pdo = get_pdo();
} catch (PDOException $e) {
    http_response_code(500);
    die(json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]));
}
