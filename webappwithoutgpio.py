from msilib.schema import Directory
from socket import socket
from flask import Flask, render_template, send_from_directory, request
from flask_socketio import SocketIO, send, emit
import json
from time import sleep
import threading
import asyncio
import random

app = Flask(__name__, template_folder="web/")
app.config["SECRET_KEY"] = 'secret!'
socketio = SocketIO(app)
print('objects created')

def update_loop(*args):
    moving = False
    current_angle = 0
    target_angle = 0
    
    direction = -1
    app = args[0]
    socket = args[1]

    while True:
        print("looping")

        sleep (0.5)


@app.route('/')
def index():
    return render_template('/index.html')

@app.route('/getmethod', methods=['GET'])
def give_GET_data():
    #return str(controller.servo_data['Current'])
    # json.dumps({"Target":controller.servo_data["Target"], "Current":temp})
    return json.dumps({"Target":random.randint(0, 90), "Current":random.randint(0, 90)})

@app.route('/postmethod', methods=['POST'])
def get_POST_data():
    jsdata = json.loads(request.form['target_angle'])
    return('done')


@app.route('/web/')
def render_page_web():
    return render_template("index.html")

@app.route('/web/<path:name>')
def return_flutter_doc(name):
    datalist = str(name).split('/')
    DIR_NAME = "web"
    if len(datalist) > 1:
        for i in range(0, len(datalist) - 1):
            DIR_NAME += '/' + datalist[i]
            
    return send_from_directory(DIR_NAME, datalist[-1])    


@socketio.on("update event")
def handle_update_motor_stats(cur_angle):
    print(cur_angle, "here")

@socketio.on('message')
def handle_message(data):
    print('received message: ' + data)

@socketio.on('connect')
def connect():
    print("a client connected")


if __name__ == '__main__':
    thread = threading.Thread(target=update_loop, args=[app, socketio])
    thread.start()
    socketio.run(app, host='0.0.0.0')