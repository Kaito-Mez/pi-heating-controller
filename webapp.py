from flask import Flask, render_template, request
import json
from gpioController import gpioController
from time import sleep
import asyncio
import random

controller = gpioController()
app = Flask(__name__)
print('objects created')


@app.route('/')
def index():
    return render_template('index.html')

@app.route('/test')
def test():
    return render_template('test.html')

@app.route('/getmethod', methods=['GET'])
def give_GET_data():
    #return str(controller.servo_data['Current'])
    temp = str(random.randint(0, 90))
    print(temp)
    # json.dumps({"Target":controller.servo_data["Target"], "Current":temp})
    controller.update_current()
    return json.dumps(controller.servo_data)

@app.route('/postmethod', methods=['POST'])
def get_POST_data():
    jsdata = json.loads(request.form['servo_data'])
    print(jsdata["Target"])
    angle = float(jsdata["Target"])
    controller.change_target(angle)
    return('done')

if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0')