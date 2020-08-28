FROM debian:buster-slim

WORKDIR /usr/src

RUN apt-get update && apt-get install -y build-essential libconfig-dev wget && rm -rf /var/lib/apt/lists/*
RUN wget https://archive.org/download/zeromq_3.2.5/zeromq-3.2.5.tar.gz && tar zxvf zeromq-3.2.5.tar.gz && cd zeromq-3.2.5 && ./configure && make && make install && cd ../ && rm -rf zeromq-3.2.* && ldconfig
RUN wget https://src.fedoraproject.org/repo/pkgs/json-c/json-c-0.9.tar.gz/3a13d264528dcbaf3931b0cede24abae/json-c-0.9.tar.gz && tar zxvf json-c-0.9.tar.gz && cd json-c-0.9 && ./configure && make && make install && cd .. && rm -rf json-c*
COPY . ./
RUN gcc -std=c99 -Wall -lm -o /usr/local/bin/scanner scanner.c -ljson -lzmq -pthread -I/usr/local/include/json/

RUN apt-get remove -y build-essential libconfig-dev wget && apt-get autoremove --yes && apt-get autoclean && rm -rf /var/lib/apt/lists/*

CMD ["scanner", "-d", "/dev/ttyUSB0"]
