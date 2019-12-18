<?php

namespace Pinkeen\AWS\Lambda;

use GuzzleHttp\Client as HttpClient;

# Handle errors
# https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html#runtimes-api-invokeerror

class LambdaHandler
{
    private $runtimeApiUrl;
    private $appDir;
    private $appHandlerName;
    private $appHandlerFilename;
    private $appHandlerFunction;
    private $httpClient;

    private function __construct(string $appDir, string $appHandlerName, string $runtimeApiUrl)
    {
        $this->appDir = $appDir;
        $this->appHandlerName = $appHandlerName;
        $this->runtimeApiUrl = $runtimeApiUrl;

        $appHandlerParts = explode('.', $appHandlerName);

        $this->appHandlerFilename = $appDir . '/' . implode('.', (array_slice($appHandlerParts, 0, -1))) . '.php';
        $this->appHandlerFunction = current(array_slice($appHandlerParts, -1));

        require_once $this->appHandlerFilename;

        $this->httpClient = new HttpClient();
    }

    protected function getNextInvocationRequest()
    {
        $response = $this->httpClient->get($this->runtimeApiUrl . '/invocation/next');

        return [
            'invocation_id' => $response->getHeader('Lambda-Runtime-Aws-Request-Id')[0],
            'payload' => json_decode((string)$response->getBody(), true)
        ];
    }

    protected function sendInvocationResponse(string $invocationId, string $response)
    {
        $client->post($this->runtimeApiUrl . "/invocation/{$invocationId}/response", [
            'body' => $response
        ]);
    }

    protected function handle()
    {
        do {
            // $invocationRequest = $this->getNextInvocationRequest();
            // $invocationId = $invocationRequest['invocationId'];
            // $invocationPayload = $invocationRequest['payload'];
            $invocationId = 'eloziomalu';
            $invocationPayload = ['this' => 'is just a test'];

            $appHandlerResult = $this->handleInvocation($invocationId, $invocationPayload);

            var_dump($appHandlerResult);

            // $this->sendInvocationResponse($invocationId, $appHandlerResult);
        } while (true);
    }

    protected function handleInvocation(array $invocationId, array $payload): string
    {
        ($this->appHandlerFunction)($payload);
    }
}