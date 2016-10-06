FROM node:0.10.38
MAINTAINER Brian Ketelsen <me@brianketelsen.com>

ADD . /app
WORKDIR /app
RUN npm install
RUN apt-get update
RUN apt-get install -y vim

ARG USERNAME
ARG PASSWORD
RUN useradd -d /home/$USERNAME -m -s /bin/bash $USERNAME
RUN echo "$USERNAME:$PASSWORD" | chpasswd

ADD scripts /home/$USERNAME/bin
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/bin
EXPOSE 3000

ENTRYPOINT ["node"]
CMD ["app.js", "-p", "3000"]
