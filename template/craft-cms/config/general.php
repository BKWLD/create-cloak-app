<?php
/**
 * General Configuration
 *
 * All of your system's general configuration settings go in here. You can see a
 * list of the available settings in vendor/craftcms/cms/src/config/GeneralConfig.php.
 *
 * @see \craft\config\GeneralConfig
 */

use craft\helpers\App;

$isDev = App::env('CRAFT_ENVIRONMENT') === 'dev';
$isProd = App::env('CRAFT_ENVIRONMENT') === 'prod';

return [

    // Default Week Start Day (0 = Sunday, 1 = Monday...)
    'defaultWeekStartDay' => 1,

    // Whether generated URLs should omit "index.php"
    'omitScriptNameInUrls' => true,

    // Whether Dev Mode should be enabled (see https://craftcms.com/guides/what-dev-mode-does)
    'devMode' => $isDev,

    // Whether crawlers should be allowed to index pages and following links
    'disallowRobots' => true,

    // Don't upscale images
    'upscaleImages' => false,

     // Enable headless mode (works in Craft 3.4 now for URLs)
    'headlessMode' => true,

    // Don't transform gifs, GD doesnt support gifs
    'transformGifs' => false,

    // No need to transform SVGs either
    'transformSvgs' => false,

    // Keep fewer database backups
    'maxBackups' => 5,

    // Preview tokens work for 3 months
    'defaultTokenDuration' => 'P3M',

    // Prevent the CMS from being able to be disabled from the dashboard.
    // We had a (unprovoked) occurance of the site disabling itself.
    'isSystemLive' => true,

    // Increase max upload size
    'maxUploadFileSize' => '256M',

    // Aliases config
    'aliases' => [

        // Support clearing caches from CLI
        // https://github.com/craftcms/cms/issues/3787#issuecomment-462971290
        '@webroot' => dirname(__DIR__) . '/web',

        // Form the Spaces Base URL from other vars
        '@spacesBaseUrl' => '//'.App::env('SPACES_BUCKET')
            .'.'.App::env('SPACES_REGION')
            .'.digitaloceanspaces.com',
    ],

    // Use Forge supervisor to run queue on prod
    'runQueueAutomatically' => !$isProd,
];
