from flask import Flask, render_template, request
import json
from time import sleep
import asyncio
import random

app = Flask(__name__)
print('objects created')


@app.route('/')
def index():
    return render_template('index.html')

@app.route('/getmethod', methods=['GET'])
def give_GET_data():
    #return str(controller.servo_data['Current'])
    # json.dumps({"Target":controller.servo_data["Target"], "Current":temp})
    return json.dumps({"Target":0, "Current":0})

@app.route('/postmethod', methods=['POST'])
def get_POST_data():
    jsdata = json.loads(request.form['servo_data'])
    print(jsdata["Target"])
    return('done')

if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0')