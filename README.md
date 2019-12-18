
```bash
docker build . -t aws-lambda-php
```

```bash
docker run -it --rm -v $(pwd)/app-example:/root/lambda-app aws-lambda-php /opt/lambda-runtime/bootstrap
```

```bash
docker run -it --rm -v $(pwd)/app-example:/root/lambda-app -v $(pwd)/app-build:/root/lambda-build -e _HANDLER="hello.helloAWS" -e LAMBDA_PHP_DUMMY_BOOTSTRAP=1 aws-lambda-php /opt/lambda-runtime/bootstrap
```


