.DEFAULT_GOAL := build

# Build app
build:
	@go build -v -o ./build/riffraff github.com/mre/riffraff/cmd/riffraff
.PHONY: build

# Clean up
clean:
	@rm -fR ./build/ ./cover*
.PHONY: clean

# Creates folders
configure:
	@mkdir -p ./build
.PHONY: configure

# Run tests and generates html coverage file
cover: test
	@go tool cover -html=./coverage.text -o ./coverage.html
.PHONY: cover

# Download dependencies
depend:
	@go get -u gopkg.in/alecthomas/gometalinter.v2
	@gometalinter.v2 --install
.PHONY: depend

# Install app
install:
	go install
.PHONY: install

# Run linters
lint:
	gometalinter.v2 \
		--disable-all \
		--exclude=vendor \
		--deadline=180s \
		--enable=gofmt \
		--linter='errch:errcheck {path}:PATH:LINE:MESSAGE' \
		--enable=errch \
		--enable=vet \
		--enable=gocyclo \
		--cyclo-over=15 \
		--enable=golint \
		--min-confidence=0.85 \
		--enable=ineffassign \
		--enable=misspell \
		./..
.PHONY: lint

# Run tests
test:
	@go test -v -race -coverprofile=./coverage.text -covermode=atomic $(shell go list ./...)
.PHONY: test
