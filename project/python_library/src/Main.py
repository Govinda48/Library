import sys
from PyQt5.QtWidgets import QApplication, QWidget
from Home import C2W_Home;

class Widget(QWidget, C2W_Home):
    def __init__(self,parent=None):
        super().__init__(parent)
        self.c2w_ui = C2W_Home()
        self.c2w_ui.setupUi(self)
if __name__ == '__main__':
    app = QApplication(sys.argv)
    widget = Widget()
    widget.show()
    sys.exit(app.exec())