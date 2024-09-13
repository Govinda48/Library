import os
import tkinter as tk
from tkinter import messagebox,ttk

class CardGeneratorApp:
    
    def __init__(self):

        self.root = tk.Tk()
        self.screen_width = self.root.winfo_screenwidth()
        self.screen_height = self.root.winfo_screenheight()
        self.root.title("Card Generator")
        self.root.geometry("600x500+100+50")

        self.setup_ui()

    def Generate_Card(self):
        self.name = self.Name_Input.get()
        self.age = self.Age_input.get()
        self.email = self.Email_input.get()
        self.company = self.CmpName_Input.get()
        self.package = self.Package_Input.get()

        self.card_text = f"Full Name : {self.name}\nAge: {self.age} \nEmail: {self.email}\nCompany : {self.company}\nSalary : {self.package}"        
        self.card_label.config(text=self.card_text,bg="skyblue" , height=8,width=40,font=("Poppins",12))

    def setup_ui(self):
        self.Main_Frame  = tk.Frame(self.root,height=500,width=600,)
        self.Main_Frame.pack()

        self.Full_Name = tk.Label(self.Main_Frame,text="Full Name : ",font="Poppins")
        self.Full_Name.pack(pady=20)
        self.Full_Name.place(x=50, y=30)

        self.Name_Input = ttk.Entry(self.Main_Frame,width=25,font=("Poppins"))
        self.Name_Input.pack()
        self.Name_Input.place(x=250,y=30)

        self.Age = tk.Label(self.Main_Frame,text="Age  : ",font="Poppins")
        self.Age.pack(pady=20)
        self.Age.place(x=50,y=60)

        self.Age_input = ttk.Entry(self.Main_Frame,width=25,font="Poppins")
        self.Age_input.pack()
        self.Age_input.place(x=250,y=60)

        self.Email = tk.Label(self.Main_Frame,text="Email ID :  ",font="Poppins")
        self.Email.pack()
        self.Email.place(x=50,y=30*3)

        self.Email_input = ttk.Entry(self.Main_Frame,width=25,font="Poppins")
        self.Email_input.pack()
        self.Email_input.place(x=250,y=30*3)
    
        self.Work_btn= tk.Checkbutton(self.Main_Frame,text="Do you work? ",font=("Poppins",12))
        self.Work_btn.pack()
        self.Work_btn.place(x=50,y=30*4)

        self.Company_Name = tk.Label(self.Main_Frame,text="Company Name : ",font="Poppins")
        self.Company_Name.pack(pady=20)
        self.Company_Name.place(x=50, y=30*5)

        self.CmpName_Input = ttk.Entry(self.Main_Frame,width=25,font=("Poppins"))
        self.CmpName_Input.pack()
        self.CmpName_Input.place(x=250,y=30*5)

        self.Full_Package = tk.Label(self.Main_Frame,text="Package : ",font="Poppins")
        self.Full_Package.pack(pady=20)
        self.Full_Package.place(x=50, y=30*6)

        self.Package_Input = ttk.Entry(self.Main_Frame,width=25,font=("Poppins"))
        self.Package_Input.pack()
        self.Package_Input.place(x=250,y=30*6)

        self.Generate_Btn = tk.Button(self.Main_Frame,text="Generate Card",bg="green",width=20,command=self.Generate_Card,font=("Poppins",12,"bold"))
        self.Generate_Btn.pack()
        self.Generate_Btn.place(x=100,y=30*9)

        self.card_label = tk.Label(self.Main_Frame,text="")
        self.card_label.pack()
        self.card_label.place(x=50,y=30*11)

        
        
    def run(self):
        self.root.mainloop()
