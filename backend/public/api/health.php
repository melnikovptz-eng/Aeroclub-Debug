<?php
declare(strict_types=1);

require_once __DIR__ . '/../../src/bootstrap.php';

try {
    database()->query('SELECT 1');
    jsonResponse([
        'ok' => true,
        'service' => 'kd-pilot-api',
        'database' => 'connected',
        'time' => date(DATE_ATOM),
    ]);
} catch (Throwable $error) {
    error_log('[KD-PILOT] Health check failed: ' . $error->getMessage());
    jsonResponse([
        'ok' => false,
        'service' => 'kd-pilot-api',
        'database' => 'unavailable',
    ], 503);
}
