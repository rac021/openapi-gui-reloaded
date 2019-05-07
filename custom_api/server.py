from os import curdir
from os.path import join as pjoin

from urllib.parse import unquote

from http.server import BaseHTTPRequestHandler, HTTPServer

class StoreHandler(BaseHTTPRequestHandler):
    store_path = pjoin(curdir, '/usr/src/app/arkhineo_open_api/arkh_open_api.yaml')

    def do_GET(self):
        if self.path == '/':
            with open(self.store_path) as fh:
                self.send_response(200)
                self.send_header('Content-type', 'text/plain')
                self.end_headers()
                self.wfile.write(fh.read().encode())

    def do_POST(self):
        if self.path == '/':
            length = self.headers['content-length']
            data = self.rfile.read(int(length))

            with open(self.store_path, 'w') as fh:
                fh.write( unquote(data.decode()))

            self.send_response(200)


server = HTTPServer(('', 9090), StoreHandler)
server.serve_forever()
