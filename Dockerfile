FROM golang:1.24-bullseye AS builder

WORKDIR /app
COPY . .

RUN apt-get update && apt-get install -y git && \
    go mod tidy && \
    go build -o github-mcp-server ./cmd/github-mcp-server

FROM debian:bullseye-slim

WORKDIR /app

# Copia o binário e o script
COPY --from=builder /app/github-mcp-server ./github-mcp-server
COPY entrypoint.sh /app/entrypoint.sh

# Torna o script executável
RUN chmod +x /app/entrypoint.sh && apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Variável de ambiente obrigatória para o GitHub MCP
ENV GITHUB_PERSONAL_ACCESS_TOKEN=changeme

# Executa o script que envia o JSON para o binário
CMD ["/app/entrypoint.sh"]