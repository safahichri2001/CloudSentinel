from http.server import BaseHTTPRequestHandler, HTTPServer
import json


class CloudSentinelHandler(BaseHTTPRequestHandler):

    def do_GET(self):

        if self.path == "/health":
            self.send_json(200, {
                "status": "healthy",
                "service": "cloudsentinel-backend"
            })

        elif self.path == "/api/exams":
            self.send_json(200, {
                "exams": [
                    {
                        "id": "EXAM-001",
                        "modality": "CT",
                        "status": "pending"
                    },
                    {
                        "id": "EXAM-002",
                        "modality": "MRI",
                        "status": "reviewed"
                    }
                ]
            })

        else:
            self.send_json(404, {
                "error": "Not found"
            })

    def send_json(self, status, data):
        body = json.dumps(data).encode("utf-8")

        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()

        self.wfile.write(body)


if __name__ == "__main__":
    server = HTTPServer(
    ("0.0.0.0", 80),
    CloudSentinelHandler
)

    print("CloudSentinel backend running on port 80")
    server.serve_forever()