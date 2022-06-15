<?php
/**
 * Craft web bootstrap file
 */

// Redirect to /admin from root
if ($_SERVER['REQUEST_URI'] == '/') {
    header('Location: /admin');
    exit;
}
// Load shared bootstrap
require dirname(__DIR__) . '/bootstrap.php';

// Redirect requests to correct hostname
if (getenv('BASE_CP_URL') &&
    !str_contains(getenv('BASE_CP_URL'), $_SERVER['HTTP_HOST'])) {
    header('Location: '.getenv('BASE_CP_URL').$_SERVER['REQUEST_URI']);
    exit;
}

// Load and run Craft
/** @var craft\web\Application $app */
$app = require CRAFT_VENDOR_PATH . '/craftcms/cms/bootstrap/web.php';
$app->run();
