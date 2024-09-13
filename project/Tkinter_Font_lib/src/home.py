from PIL import Image, ImageTk
import tkinter as tk
import os
from tkinter import ttk, messagebox

class C2W_TkinterLibraryApp:
    def __init__(self):
        self.c2w_root = tk.Tk()
        self.c2w_screen_width = self.c2w_root.winfo_screenwidth()
        self.c2w_screen_height = self.c2w_root.winfo_screenheight()
        self.c2w_root.title("TKINTER Library")
        self.c2w_root.geometry(f"{self.c2w_screen_width}x{self.c2w_screen_height}")
        self.c2w_root.configure(bg="#192f44")
        self.setup_ui()
    
    def setup_ui(self):
        self.c2w_background_frame = tk.Frame(self.c2w_root,  bg='#0A2472', width=self.c2w_screen_width, height= self.c2w_screen_height)
        self.c2w_background_frame.pack()
        
        self.c2w_left_frame = tk.frame = tk.Frame(self.c2w_background_frame,  bg="#00072D", width = self.c2w_screen_width//6,height=self.c2w_screen_height)
        self.c2w_left_frame.pack(side=tk.LEFT)
        
        # Set up button styling
        style = ttk.Style()
        style.configure("Rounded.TButton", borderwidth = 0, relief="flat", background="#BCD2E8", padding=10, font = ("Poppins",12))
        style.map("Rounded.TButton", foreground=[('pressed','black'),('active','white')])
        
        # Create the Font Library button
        self.c2w_button_label = ttk.Button(self.c2w_left_frame, text="Fonts Library", style="Rounded.TButton", command=self.c2w_show_font_tab)
        self.c2w_button_label.pack()
        self.c2w_button_label.place(x=60, y=350, anchor='nw')
        
        #Load an display an image
        script_directory = os.path.dirname(os.path.abspath(__file__))
        img_path = os.path.join(script_directory, "D:/python_project/project/Tkinter_Font_lib/assets/images.png")
        img = ImageTk.PhotoImage(Image.open(img_path))
        self.c2w_label = tk.Label(self.c2w_left_frame, image = img, background="#00072D")
        self.c2w_label.image = img
        self.c2w_label.pack()
        self.c2w_label.place(x=40,y=20, anchor='nw')
        
        # Set up the right frame for dynamic content
        rgba_color = (222, 55, 48, 255)
        tk_color = "#{:02x}{:02x}{:02x}".format(*rgba_color[:3])
        self.c2w_right_frame = tk.Frame(self.c2w_background_frame, bg="#BCD2E8",width=(self.c2w_screen_width - self.c2w_screen_width//6),height=self.c2w_screen_height)
        self.c2w_right_frame.pack(side=tk.RIGHT)
        
        #Set up a label with welcome text
        self.c2w_original_label_text = "Welcome To Core2web"
        self.c2w_right_label = tk.Label(self.c2w_right_frame,text=self.c2w_original_label_text,background='#BCD2E8',font=("Poppins",50,"bold"),fg=tk_color)
        self.c2w_right_label.pack()
        self.c2w_right_label.place(x=300, y=200, anchor='nw')
        
        #Creat a 'Back button
        self.c2w_back_button = ttk.Button(self.c2w_left_frame, text="Back",style="Rounded.TButton",command=self.c2w_reset_ui)
        self.c2w_back_button.pack()
        self.c2w_back_button.place(x=60, y=400, anchor='nw')
        
        #Track whether font Library is open and additional widgets
        self.font_library_opened = False
        self.additional_widgets = []
        
    def c2w_show_font_tab(self):
        #Show Font Library tab
        if self.font_library_opened:
            messagebox.showinfo("Already Opend", "Font Library is already opened!")
        else:
            #Destroy existing widgets
            for widget in self.additional_widgets:
                widget.destroy()
            self.additional_widgets = []
            
            #Set up Font Library tab
            rgba_color = (222,55,48,255)
            tk_color = "#{:02x}{:02x}{:02x}".format(*rgba_color[:3])
            
            #Creat and pack widgets for Font Library
            self.c2w_heading_label = tk.Label(self.c2w_right_frame,text = "Font Library", background= '#BCD2E8', font=("Poppins", 20, "bold"),fg = tk_color)
            self.c2w_heading_label.pack()
            self.c2w_heading_label.place(x=60*2, y = 150, anchor='nw')
            
            self.input_label = ttk.Entry(self.c2w_right_frame, width=60, font = ("Poppins", 12))
            self.input_label.insert(0, "Enter Your Text Here...")
            self.input_label.pack()
            self.input_label.place(x=60*2, y=200, anchor='nw')
            
            self.c2w_right_label.config(text="")
            self.font_library_opened = True
            
            #Create button for different fonts
            self.c2w_button_label1 = ttk.Button(self.c2w_right_frame, text='Poppins', style='Rounded.TButton', command=self.c2w_poppinClicked)
            self.c2w_button_label1.pack()
            self.c2w_button_label1.place(x=60*2, y=350, anchor='nw')
            
            self.c2w_button_label2 = ttk.Button(self.c2w_right_frame, text='Modern', style='Rounded.TButton', command=self.c2w_modernClicked)
            self.c2w_button_label2.pack()
            self.c2w_button_label2.place(x=60*5, y=350, anchor='nw')
            
            self.c2w_button_label3 = ttk.Button(self.c2w_right_frame, text='Calibri', style='Rounded.TButton', command=self.c2w_courierClicked)
            self.c2w_button_label3.pack()
            self.c2w_button_label3.place(x=60*8, y=350, anchor='nw')
            
            self.c2w_button_label4 = ttk.Button(self.c2w_right_frame, text='Ms Sans Serif', style='Rounded.TButton', command=self.c2w_sanserifClicked)
            self.c2w_button_label4.pack()
            self.c2w_button_label4.place(x=60*11, y=350, anchor='nw')
            
            self.c2w_button_label5 = ttk.Button(self.c2w_right_frame, text='Courier', style='Rounded.TButton', command=self.c2w_calibriClicked)
            self.c2w_button_label5.pack()
            self.c2w_button_label5.place(x=60*14, y=350, anchor='nw')
            
            self.c2w_show_label = tk.Label(self.c2w_right_frame,text="",background="#BCD2E9", font=("Poppins", 50, "bold"), fg=tk_color)
            self.c2w_show_label.pack()
            self.c2w_show_label.place(x=60*2, y=500, anchor='nw')
    
            
    def c2w_poppinClicked(self):
        #Change the font and display enetered text
        self.c2w_show_label.config(text=self.input_label.get(),font=("Poppins", 30, "bold"))
        
    def c2w_modernClicked(self):
        #Change the font and display enetered text
        self.c2w_show_label.config(text=self.input_label.get(),font=("Modern", 30 ,"bold"))
        
    def c2w_courierClicked(self):
        #Change the font and display enetered text
        self.c2w_show_label.config(text=self.input_label.get(),font=("Courier",30,"bold"))
        
    def c2w_sanserifClicked(self):
        #Change the font and display enetered text
        self.c2w_show_label.config(text=self.input_label.get(),font=("Ms Sans Serif",30,"bold"))
        
    def c2w_calibriClicked(self):
        #Change the font and display enetered text
        self.c2w_show_label.config(text=self.input_label.get(),font=("Calibri",30,"bold"))
        
    def c2w_reset_ui(self):
        #Reset UI when going back
        self.font_library_opened = False
        
        for widget in self.additional_widgets:
            widget.destroy()
        self.additional_widgets = []
        self.c2w_heading_label.destroy()
        self.input_label.destroy()
        self.c2w_button_label1.destroy()
        self.c2w_button_label2.destroy()
        self.c2w_button_label3.destroy()
        self.c2w_button_label4.destroy()
        self.c2w_button_label5.destroy()
        self.c2w_show_label.destroy()
        
        self.c2w_right_label.config(text=self.c2w_original_label_text)
    
    def run(self):
        #Run the Tkinter main loop
        self.c2w_root.mainloop()
