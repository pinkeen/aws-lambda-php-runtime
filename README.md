
```bash
docker build . -t aws-lambda-php
```

```bash
docker run -it --rm -v $(pwd)/app:/root/lambda-app aws-lambda-php
```

```bash
LAMBDA_TASK_ROOT="$(pwd)" _HANDLER="hello.helloAWS" /opt/lambda-runtime/bootstrap
```
