<?php
/**
 * Craft web bootstrap file
 */

// Redirect to /admin from root
if ($_SERVER['REQUEST_URI'] == '/') {
    header('Location: /admin');
    exit;
}

// Define path constants
define('CRAFT_BASE_PATH', dirname(__DIR__));
define('CRAFT_VENDOR_PATH', CRAFT_BASE_PATH . '/vendor');

// Load Composer's autoloader
require_once CRAFT_VENDOR_PATH . '/autoload.php';

// Load dotenv?
if (class_exists('Dotenv\Dotenv') && file_exists(CRAFT_BASE_PATH . '/.env')) {
    Dotenv\Dotenv::create(CRAFT_BASE_PATH)->load();
}

// Redirect requests to correct hostname
if (getenv('BASE_CP_URL') &&
    !str_contains(getenv('BASE_CP_URL'), $_SERVER['HTTP_HOST'])) {
    header('Location: '.getenv('BASE_CP_URL').$_SERVER['REQUEST_URI']);
    exit;
}

// Define additional PHP constants
// (see https://craftcms.com/docs/3.x/config/#php-constants)
define('CRAFT_ENVIRONMENT', getenv('ENVIRONMENT') ?: 'prod');
// ...

// Load and run Craft
/** @var craft\web\Application $app */
$app = require CRAFT_VENDOR_PATH . '/craftcms/cms/bootstrap/web.php';
$app->run();
