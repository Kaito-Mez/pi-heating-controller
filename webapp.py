from flask import Flask, render_template, send_from_directory, request
from flask_socketio import SocketIO
from gpioController import gpioController
import random
import eventlet

controller = gpioController()
app = Flask(__name__, template_folder="web/")
app.config["SECRET_KEY"] = 'secret!'
socketio = SocketIO(app)

needs_update = False


jsonData = {
    "current":0,
    "target": 0,
    "direction": 0,
}

print('objects created')

#returns -1 if decreasing, 0 if not moving, 1 if increasing
def get_servo_direction(target_angle, current_angle):
    threshhold = target_angle + 1
    moving = 0

    #threshold increased by 1 for lower angles
    if target_angle <= 45:
        threshhold += 1

    if current_angle >= target_angle and current_angle < threshhold:
        moving = 0

    elif current_angle > target_angle:
        moving = -1
    
    elif current_angle < target_angle:
        moving = 1

    return moving

def emit_update():
    socketio.emit("update", jsonData)

def update_loop():
    #min angle is 2.1
    #max angle is 90
    #actual angle will be just under +2 of target
        

    lastAngle = jsonData['current']
    while True:
        #update current
        
        jsonData['current'] = controller.get_current_angle()

        if round(jsonData['current']) != lastAngle and needs_update == True:
            needs_update = False
            lastAngle = round(jsonData['current'])

            jsonData['direction'] = get_servo_direction(jsonData['target'], jsonData['current'])
            emit_update()
        
        eventlet.sleep(0.1)


@app.route('/')
def index():
    return render_template('/index.html')

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


@socketio.on('change_target')
def handle_message(data):
    jsonData['target'] = data['target']
    controller.change_target(jsonData['target'])
    needs_update = True

@socketio.on('disconnect')
def disconnect():
    print("disconnected")

@socketio.on('connect')
def connect():
    print("a client connected", request.namespace, request.sid)
    emit_update()


if __name__ == '__main__':
    socketio.start_background_task(target=update_loop)
    print("next")
    socketio.run(app, host='0.0.0.0')