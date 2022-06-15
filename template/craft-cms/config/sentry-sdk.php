<?php

return [
    'enabled'       => !empty(getenv('SENTRY_DSN')),
    'anonymous'     => false, // Determines to log user info or not
    'clientDsn'     => getenv('SENTRY_DSN'),
    'excludedCodes' => ['400', '404', '429'],
    'release'       => getenv('SENTRY_RELEASE') ?: null, // Release number/name used by sentry.
];
