VERSION=1.0-RC1
ORGANIZATION=crunchydata

SOURCES:=$(shell find . -name '*.go'  | grep -v './vendor')

TARGET:=postgresql-prometheus-adapter

.PHONY: all clean build docker-image docker-push test prepare-for-docker-build

all: $(TARGET) 

build: $(TARGET)

$(TARGET): main.go $(SOURCES)
	go build -o $(TARGET)

container: $(TARGET) Dockerfile
	@#podman rmi $(ORGANIZATION)/$(TARGET):latest $(ORGANIZATION)/$(TARGET):$(VERSION)
	podman build -t $(ORGANIZATION)/$(TARGET):latest .
	podman tag $(ORGANIZATION)/$(TARGET):latest $(ORGANIZATION)/$(TARGET):$(VERSION)

container-save: container
	rm -f $(TARGET)-$(VERSION).tar
	podman save --output=$(TARGET)-$(VERSION).tar $(ORGANIZATION)/$(TARGET):$(VERSION)

clean:
	rm -f *~ $(TARGET)

