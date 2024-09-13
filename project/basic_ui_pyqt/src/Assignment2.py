'''

Design a PyQt window with a QPushButton and QLabel. Upon clicking the button,
change the text of a QLabel to "Button Clicked!

'''

import sys
from PyQt5.QtWidgets import QWidget, QApplication, QVBoxLayout,QLabel, QPushButton
from PyQt5.QtCore import Qt
class MainWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Main Window")
        self.setGeometry(500, 300, 500, 300)

        self.mainLayout = QVBoxLayout(self)
        self.mainLayout.setSpacing(0) # Set spacing to zero
        self.setLayout(self.mainLayout)
        self.label1 = QLabel("Hello Core2web")
        self.label1.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.label1.setFixedSize(500, 30)
        self.mainLayout.addWidget(self.label1,alignment=Qt.AlignmentFlag.AlignCenter)

        self.addButton()
    def addButton(self):
        self.Button1 = QPushButton("Text Change")
        # create the butoon with paramerter "Text Change"
        self.Button1.setFixedSize(100, 30)
        self.Button1.clicked.connect(lambda:

        self.label1.setText("Hello Core2web" if self.label1.text() == "I amHere" else "I am Here")) #set function call on the button click

        self.mainLayout.addWidget(self.Button1,alignment=Qt.AlignmentFlag.AlignCenter)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    main_Window = MainWindow()
    main_Window.show()
    sys.exit(app.exec_())
