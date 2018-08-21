from flask import Flask, 

app = Flask(__name__)


@app.route('/')
def index():
    return 'Flask is running!'


#if __name__ == '__main__':
#    app.run()
if __name__ == '__main__':  
     app.run(host='0.0.0.0', port=443, debug=True, ssl_context=('/www/web/ssl/server.crt', '/www/web/ssl/server.key'))
