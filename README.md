# Self-Signed Certificate generator

## Prerequisites
* Docker version > 19.03.6
* GNU Make > 4.2.1

## Setup (build image)
```bash
make build
```

## Generate certificates
```bash
DOMAIN="<my.domain.com>" make generate
```
* Generated certificates will be in `cert` folder

## Clean
```bash
make clean
```

## Publish image (if you want, only AWS ECR)
```bash
export TARGET_DOCKER_REGISTRY="<aws_docker_registry>" AWS_ACCESS_KEY_ID=<aws_access_key_id> AWS_SECRET_ACCESS_KEY=<aws_secret_access_key> AWS_DEFAULT_REGION=<aws_default_region> AWS_ACCOUNT_ID=<aws_account_id>; make build && make publish
```

## Licence

```text
Copyright (C) 2020 - Gamaliel SICK, IDEACLOUD.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
