FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o invoicer .

FROM scratch AS final

COPY --from=builder /app/invoicer /invoicer
COPY --from=builder /etc/passwd /etc/passwd

USER 10001:10001

EXPOSE 8080

ENTRYPOINT ["/invoicer"]