from gpiozero import MCP3008
import time

pot = MCP3008(channel=0)
while True:
    print(pot.value)
    time.sleep(0.5)