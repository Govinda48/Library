import tkinter as tk 



class HelloCore2webApp:
    def __init__(self):
        self.root =  tk.Tk()
        self.root.title("Hello Core2web")

        self.root.geometry("300x200")


        self.label = tk.Label(self.root, text="")
        self.label.pack(pady=10)


        self.hello_button = tk.Button(self.root, text="Click Me",command=self.display_message)
        self.hello_button.pack(pady=10)

    def display_message(self):
        self.label.config(text="Hello,Core2web!")

    def run(self):
        self.root.mainloop()

if __name__ == '__main__':

    app = HelloCore2webApp()
    app.run()
