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

@app.route('/getmethod', methods=['GET'])
def give_GET_data():
    #return str(controller.servo_data['Current'])
    # json.dumps({"Target":controller.servo_data["Target"], "Current":temp})
    controller.update_current_angle()
    return json.dumps(controller.servo_data)

@app.route('/postmethod', methods=['POST'])
def get_POST_data():
    jsdata = json.loads(request.form['target_angle'])
    angle = float(jsdata)
    controller.set_target_angle(angle)
    return('done')

if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0')