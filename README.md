
```bash
docker build . -t aws-lambda-php && docker run -it --rm -v $(pwd)/app:/lambda/app aws-lambda-php
```