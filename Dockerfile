FROM python:3.8-alpine

ARG kubectl_version=v1.11.5

RUN apk --no-cache add bash ca-certificates curl

# install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$kubectl_version/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# install  aws-iam-authenticator
RUN curl -LO https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x ./aws-iam-authenticator && \
    mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

# install aws cli
RUN pip3 install --upgrade awscli

# kustomize
ADD ./kustomize /usr/local/bin/kustomize

# create user
RUN mkdir -p /kubectl && \
    chmod -R 777 /kubectl

RUN addgroup -S kubectl && \
    adduser -S kubectl -G kubectl -h /kubectl

USER kubectl
WORKDIR /kubectl

CMD [ "kubectl" ]