# Build a PyQt application with a QTabWidget containing multiple tabs. Each tab should have different content, such as text, buttons, or images.


import sys
from PyQt5.QtWidgets import (QApplication,QHBoxLayout,QPushButton,QWidget,)

class Window(QWidget):

    def __init__(self):
        super().__init__()
        self.setWindowTitle("QHBoxLayout Example")
        self.setGeometry(500, 500, 500, 500)
        layout = QHBoxLayout()
        layout.addWidget(QPushButton("Left-Most"))
        layout.addWidget(QPushButton("Center"), 1)
        layout.addWidget(QPushButton("Right-Most"), 2)
        self.setLayout(layout)
        print(self.children())

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = Window()
    window.show()
    sys.exit(app.exec_())
