# Etapa 1: Compila o binário a partir do código original
FROM golang:1.24-bullseye AS builder

WORKDIR /app
COPY . .

RUN apt-get update && \
    apt-get install -y git && \
    go mod tidy && \
    go build -o github-mcp-server ./cmd/github-mcp-server

# Etapa 2: Executa o binário com variável de ambiente
FROM debian:bullseye-slim

WORKDIR /app

# Copia o binário compilado
COPY --from=builder /app/github-mcp-server ./github-mcp-server

# Adiciona shell para testes básicos
RUN apt-get update && apt-get install -y ca-certificates curl && rm -rf /var/lib/apt/lists/*

# Define variável de ambiente esperada pelo binário
ENV GITHUB_PERSONAL_ACCESS_TOKEN=changeme

# Executa o servidor no modo stdio (entrada padrão)
CMD /bin/sh -c 'echo "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"get_me\",\"params\":{}}" | ./github-mcp-server stdio'

