CODEGEN_VERSION := 2.2.2

all: clean codegen run

clean:
	@echo "Cleaning ..."
	@find . -not -name 'Makefile' -delete

# Generate source code
codegen: swagger-codegen-cli-$(CODEGEN_VERSION).jar
	@echo "Generating code ..."
	@java -jar ./swagger-codegen-cli-$(CODEGEN_VERSION).jar generate \
      -i http://petstore.swagger.io/v2/swagger.yaml \
      -l python-flask -DsupportPython2=true \
      -o .

# Download swagger-codegen-cli JAR
swagger-codegen-cli-$(CODEGEN_VERSION).jar:
	@if [ ! -f swagger-codegen-cli-$(CODEGEN_VERSION).jar ]; then \
		echo "Downloading swagger-codegen-cli-$(CODEGEN_VERSION).jar ..."; \
		curl --silent -O http://central.maven.org/maven2/io/swagger/swagger-codegen-cli/$(CODEGEN_VERSION)/swagger-codegen-cli-$(CODEGEN_VERSION).jar; \
	fi

# Run the web service
run:
	@pip install -r requirements.txt
	python -m swagger_server

# Test the running web service
test:
	@echo Health ...
	curl -sv -H "Content-Type: application/json" http://0.0.0.0:8080/v2/pet/findByStatus?status=pending
