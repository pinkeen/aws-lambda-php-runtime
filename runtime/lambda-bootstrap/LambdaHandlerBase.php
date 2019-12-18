<?php

namespace Pinkeen\AWS\Lambda;

use GuzzleHttp\Client as HttpClient;

# TODO: Handle errors (handler and runtime init!) and push them to the proper endpoints.
# Vide: https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html#runtimes-api-invokeerror

class LambdaHandlerBase
{
    private $runtimeApiUrl;
    private $appDir;
    private $appHandlerName;
    private $appHandlerFilename;
    private $appHandlerFunction;
    private $httpClient;

    public function __construct(string $appDir, string $appHandlerName, string $runtimeApiUrl)
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

    protected function sendInvocationResponse(string $invocationId, string $invocationResponse)
    {
        $client->post($this->runtimeApiUrl . "/invocation/{$invocationId}/response", [
            'body' => $invocationResponse
        ]);
    }

    protected function handleInvocation(string $invocationId, array $payload): string
    {
        ($this->appHandlerFunction)($payload);
    }

    public function handle()
    {
        do {
            $invocationRequest = $this->getNextInvocationRequest();
            $invocationId = $invocationRequest['invocation_id'];
            $invocationPayload = $invocationRequest['payload'];

            $appHandlerResult = $this->handleInvocation($invocationId, $invocationPayload);

            $this->sendInvocationResponse($invocationId, $appHandlerResult);
        } while (true);
    }
}