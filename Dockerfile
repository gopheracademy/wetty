FROM node:0.10.38
MAINTAINER Brian Ketelsen <me@brianketelsen.com>

ADD . /app
WORKDIR /app
RUN npm install

RUN apt-get update
RUN apt-get install -y vim
RUN apt-get update && apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
		make \
		pkg-config \
	&& rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.7.1
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 43ad621c9b014cde8db17393dc108378d37bc853aa351a6c74bf6432c1bbd182

RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz

ARG USERNAME
ARG PASSWORD
RUN useradd -d /home/$USERNAME -m -s /bin/bash $USERNAME
RUN echo "$USERNAME:$PASSWORD" | chpasswd

ADD scripts /home/$USERNAME/bin
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/bin

ENV GOPATH /home/$USERNAME
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
EXPOSE 3000

ENTRYPOINT ["node"]
CMD ["app.js", "-p", "3000"]
