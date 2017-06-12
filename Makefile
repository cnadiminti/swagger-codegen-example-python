CODEGEN_VERSION := 2.2.2

all: codegen test run

clean:
	@echo "Cleaning ..."
	@for f in $(git ls-files --exclude='*file'); do rm $f ; done

# Generate source code
codegen: swagger-codegen-cli-$(CODEGEN_VERSION).jar
	@echo "Generating code ..."
	@java -jar ./swagger-codegen-cli-$(CODEGEN_VERSION).jar generate \
      -i http://petstore.swagger.io/v2/swagger.yaml \
      -l python-flask \
      -o .

# Download swagger-codegen-cli JAR
swagger-codegen-cli-$(CODEGEN_VERSION).jar:
	@if [ ! -f swagger-codegen-cli-$(CODEGEN_VERSION).jar ]; then \
		echo "Downloading swagger-codegen-cli-$(CODEGEN_VERSION).jar ..."; \
		curl --silent -O http://central.maven.org/maven2/io/swagger/swagger-codegen-cli/$(CODEGEN_VERSION)/swagger-codegen-cli-$(CODEGEN_VERSION).jar; \
	fi

# build the docker image
build:
	@docker build -t swagger-codegen-example-python .

# Run the web service in docker
run:
	@docker run --rm -p 8080:8080 swagger-codegen-example-python

# Test the running web service
test:
	@docker run -w /root -v `pwd`:/root python:3.5 bash -c "pip3 install tox && tox"
