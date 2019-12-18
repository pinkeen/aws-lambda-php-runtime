<?php

require __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/LambdaHandler.php';

$appDir = getEnv('LAMBDA_TASK_ROOT');
$appHandlerName = getenv('_HANDLER');
$runtimeApiUrl = 'http://' . getenv('AWS_LAMBDA_RUNTIME_API') . '/2018-06-01/runtime';

$handler = new Pinkeen\AWS\Lambda\LambdaHandler($appDir, $appHandlerName, $runtimeApiUrl);
$handler->handle();