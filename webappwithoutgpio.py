from socket import socket
from flask import Flask, render_template, request
from flask_socketio import SocketIO
import json
from time import sleep
import asyncio
import random

app = Flask(__name__)
socketio = SocketIO(app)
print('objects created')


@app.route('/')
def index():
    return render_template('index.html')

@app.route('/getmethod', methods=['GET'])
def give_GET_data():
    #return str(controller.servo_data['Current'])
    # json.dumps({"Target":controller.servo_data["Target"], "Current":temp})
    return json.dumps({"Target":random.randint(0, 90), "Current":random.randint(0, 90)})

@app.route('/postmethod', methods=['POST'])
def get_POST_data():
    jsdata = json.loads(request.form['target_angle'])
    return('done')

@

if __name__ == '__main__':
    socketio.run(app)