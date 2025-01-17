FROM golang:alpine AS builder
WORKDIR /root/app
COPY go.mod .
COPY go.sum .
RUN go mod download
COPY *.go .
COPY . .
RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o ./build/app
RUN echo "Size of binary = $(echo "$(stat -c%s '/root/app/build/app')/1000000" | bc -l) MB."

FROM scratch
COPY static /static
COPY --from=builder /root/app/build /
EXPOSE 3000
ENTRYPOINT ["/app"]