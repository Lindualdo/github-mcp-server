#!/bin/sh
echo '{"jsonrpc":"2.0","id":1,"method":"get_me","params":{}}' | ./github-mcp-server stdio
