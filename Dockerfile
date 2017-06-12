FROM python:3.5-alpine

COPY . /root/swagger-codegen-example-python

WORKDIR /root/swagger-codegen-example-python

RUN pip3 install -r requirements.txt

EXPOSE 8080

ENTRYPOINT ["python3", "-m", "swagger_server"]
