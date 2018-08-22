from flask import Flask, render_template 
import os
import subprocess


app = Flask(__name__)

def run_scripts():
	end = []
	for filename in os.listdir('/www/web/scripts/'):
		out = subprocess.Popen(["/bin/sh", "-c", '/www/web/scripts/' + filename], 
           		stdout=subprocess.PIPE, 
           		stderr=subprocess.STDOUT)
		stdout,stderr = out.communicate()
		end.append(stdout)
	return end

@app.route('/')
def index():
	result = run_scripts()
	return render_template('index.html', outputs = result)

if __name__ == '__main__':  
     app.run(host='0.0.0.0', port=443, debug=True, ssl_context=('/www/web/ssl/server.crt', '/www/web/ssl/server.key'))
