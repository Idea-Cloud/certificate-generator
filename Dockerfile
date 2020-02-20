################################################################################
# This file is part of the "ssc-generator" project.
#
# Copyright (C) 2020 - Gamaliel SICK, IDEACLOUD.
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
################################################################################

FROM alpine:3.11

ENV PASSWORD="sscpwd"
ENV DEST_DIR="/data/cert"
ENV DOMAIN="custom.foo"

RUN apk add --no-cache openssl

COPY src/generate.sh /generate.sh
RUN chmod +x /generate.sh

CMD ["/generate.sh"]
