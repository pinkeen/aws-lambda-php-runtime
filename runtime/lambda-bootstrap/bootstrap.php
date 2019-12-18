<?php

require __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/LambdaHandlerBase.php';
require_once __DIR__ . '/LambdaHandlerDummy.php';

$appDir = getEnv('LAMBDA_TASK_ROOT');
$appHandlerName = getenv('_HANDLER');
$runtimeApiUrl = 'http://' . getenv('AWS_LAMBDA_RUNTIME_API') . '/2018-06-01/runtime';

if (getenv('LAMBDA_PHP_DUMMY_BOOTSTRAP')) {
    $handler = new Pinkeen\AWS\Lambda\LambdaHandlerDummy($appDir, $appHandlerName, $runtimeApiUrl);
} else {
    $handler = new Pinkeen\AWS\Lambda\LambdaHandlerBase($appDir, $appHandlerName, $runtimeApiUrl);
}

$handler->handle();