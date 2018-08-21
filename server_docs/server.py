from flask import Flask 
import os
import subprocess


app = Flask(__name__)


@app.route('/')
def index():
    for filename in os.listdir('/www/web/scripts/'):
    	if filename.endswith(".sh"):
		File = "./" + filename
		subprocess.call([File]) > results.txt

    return render_template('/www/web/templates/index.html', output='/www/web/scripts/results.txt')


if __name__ == '__main__':  
     app.run(host='0.0.0.0', port=443, debug=True, ssl_context=('/www/web/ssl/server.crt', '/www/web/ssl/server.key'))
