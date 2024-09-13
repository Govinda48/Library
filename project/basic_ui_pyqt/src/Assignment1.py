'''

Create a basic PyQt application with a main window that includes a QLabel displaying
the text "Hello, PyQt!" in the center of the window.

'''

import sys
from PyQt5.QtWidgets import QWidget, QApplication, QVBoxLayout, QLabel
from PyQt5.QtCore import Qt
class MainWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Main Window")


        self.setGeometry(500, 300, 500, 300)
        self.mainLayout = QVBoxLayout(self)

        

        self.setLayout(self.mainLayout)

        self.LabelUI()

    def LabelUI(self):

        self.lable = QLabel("Hello Core2Web")

        self.mainLayout.addWidget(self.lable, 0,

        Qt.AlignmentFlag.AlignCenter) # set the label in the main layout window

if __name__ == "__main__":
    app = QApplication(sys.argv)
    main_Window = MainWindow()
    main_Window.show()
    sys.exit(app.exec_())