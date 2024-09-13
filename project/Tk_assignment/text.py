from tkinter import *

def close_win(e):
   main_window.destroy()
main_window = Tk()

main_window.attributes('-fullscreen',True)
main_window.config(bg="#1b2036")
main_canvas = Canvas(
    main_window,
    bg='red',
    height= 715,
    width=1300,
    bd=0,
    highlightthickness=0,
    relief='ridge',
)
scroll_bar_frame=Frame(main_canvas,height=715,bg="white")


frame_12= Frame(
    
    main_canvas,
    bg="white",
    relief="sunken",
    borderwidth=0,
    width=100,
    height=200
)
mls_descript2=Label(
    frame_12,
    text='Multilevel Search is a 2D data \nstructure in which each node \nhas a next and child pointer.',
    background="#1b2036",
    border=0,
    font=('Poppins Bold',18*-1),
    fg="white",
    justify=LEFT
)
main_canvas.pack()
main_canvas.create_window(0,0, window=frame_12,anchor="nw")
#main_canvas.create_window(1280,357,window=scroll_bar_frame,anchor="e")
vbar=Scrollbar(main_window,orient=VERTICAL)
vbar.pack(side=RIGHT,fill = Y)
main_canvas.config(yscrollcommand=vbar.set)
vbar.config(command=main_canvas.yview)
for i in range(100):
    frame_13= Frame(
    frame_12,
    bg="yellow",
    relief="sunken",
    borderwidth=0,
    width=100,
    height=200
    )  
    frame_13.pack(padx=5,pady=5)

main_window.bind('<Escape>', lambda e: close_win(e))
main_window.mainloop()