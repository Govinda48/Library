from PyQt5 import QtWidgets
from PyQt5.QtWidgets import QApplication, QMainWindow
import sys

class MyWindow(QMainWindow):
    def __init__(self):
        super(MyWindow, self).__init__()
        self.setGeometry(100, 100, 800, 800)
        self.setWindowTitle("My First Window")
        self.initUI()
        
    def initUI(self): 
        self.label = QtWidgets.QLabel(self)
        self.label.setText("User Name Form!")    
           
    def addButton(self):
        button = QtWidgets.QPushButton('Add Button', self)
        button.move(30,70)
        button.clicked.connect(self.on_button_clicked)

def window():
    app =  QApplication(sys.argv)
    main_window = MyWindow()
    main_window.show()
    sys.exit(app.exec_())
    
window()
    # Create a label and set its properties