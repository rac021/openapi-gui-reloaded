FROM node:dubnium-alpine

WORKDIR /usr/src/app

# install dependencies
COPY package.json .
RUN npm install

# install the app
COPY . .

RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

COPY starter.sh .

RUN chmod +x starter.sh

EXPOSE 3000

ENTRYPOINT sh starter.sh
