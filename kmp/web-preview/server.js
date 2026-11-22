const http = require("node:http");
const fs = require("node:fs");
const path = require("node:path");

const previewFile = path.join(__dirname, "index.html");
const html = fs.readFileSync(previewFile);
const server = http.createServer((request, response) => {
  if (request.url !== "/" && request.url !== "/index.html") {
    response.writeHead(404).end("Not found");
    return;
  }
  response.writeHead(200, {
    "Content-Type": "text/html; charset=utf-8",
    "Cache-Control": "no-store",
    "Content-Security-Policy": "default-src 'self' 'unsafe-inline'; img-src 'self' data:; connect-src 'self'",
  });
  response.end(html);
});

server.listen(8765, "127.0.0.1", () => {
  process.stdout.write("Voltavia vehicle preview: http://127.0.0.1:8765\n");
});
