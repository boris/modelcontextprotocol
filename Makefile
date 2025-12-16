TAG ?= latest
PERPLEXITY_API_KEY ?= your_api_key_here

build-dev:
	docker build -t us-docker.pkg.dev/zetachain-dev/perplexity-mcp/perplexity-mcp:$(TAG) -f Dockerfile .

build-prod:
	docker build --no-cache -t us-docker.pkg.dev/zetachain-prod/perplexity-mcp/perplexity-mcp:$(TAG) -f Dockerfile .

push-dev:
	docker push us-docker.pkg.dev/zetachain-dev/perplexity-mcp/perplexity-mcp:$(TAG)

push-prod:
	docker push us-docker.pkg.dev/zetachain-prod/perplexity-mcp/perplexity-mcp:$(TAG)

run:
	docker run -d -p 8081:8081 --name perplexity-mcp --rm \
		-e PERPLEXITY_API_KEY=$(PERPLEXITY_API_KEY) \
		-e BIND_ADDRESS=0.0.0.0 -e PORT=8081 \
		us-docker.pkg.dev/zetachain-dev/perplexity-mcp/perplexity-mcp:$(TAG)

stop:
	docker stop perplexity-mcp

health:
	curl -s http://localhost:8081/health | jq || echo "Service is not healthy"

check:
	curl -X POST http://localhost:8081/mcp \
    -H 'Accept: application/json, text/event-stream' \
    -H 'Content-Type: application/json' \
    -d '{"jsonrpc": "2.0", "id": "1", "method": "tools/call", "params": { "name": "perplexity_ask", "arguments": { "messages": [ {"role": "user", "content": "What are the key takeaways from the latest AI safety report?"} ]}}}'
