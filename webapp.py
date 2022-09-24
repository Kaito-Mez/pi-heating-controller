from flask import Flask, render_template, send_from_directory, request
from flask_socketio import SocketIO
from gpioController import gpioController
import eventlet

#Initialize objects
controller = gpioController()
app = Flask(__name__, template_folder="web/")
socketio = SocketIO(app)


#Global dictionary that keeps track of
#the direction of rotation of the motor.
jsonData = {
    "current":0,
    "target": 0,
    "direction": 0
}


#returns -1 if decreasing, 0 if not moving, 1 if increasing
def get_servo_direction(target_angle, current_angle):
    '''Returns:\n
    \t-1: Motor decreasing\n
    \t0: Motor stationary\n
    \t1: Motor increasing\n .'''


    '''
    Derives the direction the motor must be traveling
    based on the current angle and the target angle.
    There is a range for the current_angle to be considered
    stationary due to the analogue nature of the input and
    output of the servo.
    The range of stationary angles changes depending on the
    target angle.
    '''

    def iswithinThreshold(angle, lower_bounds, upper_bounds) -> bool:
        '''Checks whether a given angle is within given bounds'''

        return (lower_bounds <= angle and angle <= upper_bounds)


    #For target angles above 60 degrees the stationary threshold is:
    # target - 0.5 < current < target + 1
    upper_threshold = target_angle + 1
    lower_threshold = target_angle - 0.5
    moving = 0

    
    # For target angles less than 61 degrees the stationary threshold is:
    # target - 0.5 < current < target + 2
    if target_angle <= 60:
        upper_threshold += 1

    # The last ~5 degrees get weird    
    # For target angles less than 6 degrees the stationary threshold is:
    # target - 0.5 < current < target + 3
    if target_angle <= 5:
        upper_threshold += 1

    # Motor is still
    if (iswithinThreshold(current_angle, lower_threshold, upper_threshold)):
        moving = 0
    
    # Motor is reducing in angle
    elif current_angle > target_angle:
        moving = -1
    
    #Motor is increasing in angle
    elif current_angle < target_angle:
        moving = 1

    return moving



def emit_update():
    '''Emit an update event to the websocket'''
    socketio.emit("update", jsonData)

def emit_init():
    '''Emit an initialize event to the websocket'''
    socketio.emit("init", jsonData)

def update_loop():
    '''
    Eventloop that emits update events to the front
    end, providing the front end realtime servo info.
    '''

    # Keeps track of the most recent angle sent to the
    # front-end.
    lastAngle = jsonData['current']


    while True:
        
        # Update the current angle.
        jsonData['current'] = controller.get_current_angle()

        # If the current angle differs from the last
        # angle sent to the front end then send an update
        if round(jsonData['current']) != lastAngle:

            lastAngle = round(jsonData['current'])
            jsonData['direction'] = get_servo_direction(jsonData['target'], jsonData['current'])
            emit_update()
        
        eventlet.sleep(0.1)

'''
These app routes are for the web build of the 
flutter client and point browser clients to the
relevant html, css and js that the web client
compiles to.
'''
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


'''Event handlers for websockets'''

@socketio.on('change_target')
def handle_target_change(data):
    '''Called when the client changes the target angle'''

    jsonData['target'] = data['target']
    controller.set_target_angle(jsonData['target'])
    emit_update()

@socketio.on('disconnect')
def disconnect():
    '''On Client Disconnect'''

    print("disconnected")

@socketio.on('connect')
def connect():
    '''On Client Connect'''

    print("a client connected", request.namespace, request.sid)
    emit_init()



if __name__ == '__main__':
    # Run update_loop in the background and then run the flask app

    # Running the update_loop on socketio thread is important
    # as it allows it to emit socket events.
    socketio.start_background_task(target=update_loop)
    socketio.run(app, host='0.0.0.0')