
```bash
docker build . -t aws-lambda-php
```

```bash
docker run -it --rm -v $(pwd)/app-example:/root/lambda-app aws-lambda-php /opt/lambda-runtime/bootstrap
```

```bash
docker run -it --rm -v $(pwd)/app-example:/root/lambda-app -v $(pwd)/build:/var/lambda-build -e _HANDLER="hello.fromAWS" -e LAMBDA_PHP_DUMMY_BOOTSTRAP=1 aws-lambda-php /opt/lambda-runtime/bootstrap
```


```bash
docker build . -t amiphp && docker run -it --rm -v $(pwd)/app-example:/root/lambda-app -v $(pwd)/build:/var/lambda-build -v $HOME/.composer:/tmp/composer -e _HANDLER="hello.fromAWS" -e LAMBDA_PHP_DUMMY_BOOTSTRAP=1 amiphp /opt/lambda-runtime/bootstrap


docker build . -t amiphp && docker run -it --rm -v $(pwd)/app-example:/root/lambda-app -v $(pwd)/build:/var/lambda-build -v $HOME/.composer:/tmp/composer -e _HANDLER="hello.helloAWS" -e LAMBDA_PHP_DUMMY_BOOTSTRAP=1 amiphp /opt/lambda-runtime/bin/php-lambda-build
```