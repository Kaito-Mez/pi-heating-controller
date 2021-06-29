from tkinter import *

def show_values():
    print(angle_slider.get())

master = Tk()

angle_slider = Scale(master, from_=0, to=90, orient=HORIZONTAL)
angle_slider.pack()

Button(master, text = 'Set', command = show_values).pack()

mainloop()