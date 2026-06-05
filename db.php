<?php
function get_pdo(): PDO {
    // SQLite database file
    $db_file = __DIR__ . '/data.db';
    $dsn = "sqlite:$db_file";
    
    $options = [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ];
    
    return new PDO($dsn, null, null, $options);
}


try {
    $pdo = get_pdo();
} catch (PDOException $e) {
    http_response_code(500);
    die(json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]));
}
