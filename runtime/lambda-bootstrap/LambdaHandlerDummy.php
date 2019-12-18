<?php

namespace Pinkeen\AWS\Lambda;

class LambdaHandlerDummy extends LambdaHandlerBase
{
    protected function getNextInvocationRequest(): array
    {
        return [
            'invocation_id' => 'dummy-' . uniqid(),
            'payload' => [
                'dummy' => 'payload',
                'uniqid' => uniqid()
            ]
        ];
    }

    protected function sendInvocationResponse(string $invocationId, string $invocationResponse)
    {
        echo "[Invocation:$invocationId] Would send response: \n$invocationResponse\n\n";
    }

    public function handle()
    {
        $this->handleInvocation($this->getNextInvocationRequest());
    }
}