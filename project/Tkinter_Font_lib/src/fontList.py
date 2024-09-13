#fontList.py

import tkinter as tk
from tkinter import font

class FontListApp:
    def __init__(self,root):
        self.root=root
        self.root.title("Font List Example")
        
        #Get the list of available fonts
        available_fonts = font.families()
        
        #Create a text widget to display the font list
        font_list_text = tk.Text(root, wrap=tk.WORD, height=10, width=40)
        font_list_text.pack(padx=10,pady=10)
        
        #Insert the font list into the text widget
        for font_family in available_fonts:
            font_list_text.insert(tk.END, f"{font_family}\n")
            
if __name__=="__main__":
    root=tk.Tk()
    app = FontListApp(root)
    root.mainloop()