'''

Develop a PyQt application with a QMainWindow that contains a QMenuBar. Include at
least two menus with corresponding actions, and display appropriate messages when
actions are triggered.

'''

import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QMenuBar, QAction,QMessageBox
class MyMainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("PyQt Menu Example")
        self.setGeometry(500, 100, 500, 300)
        self.create_menus()
    def create_menus(self):
        menubar = self.menuBar()
        # File menu
        file_menu = menubar.addMenu("File")
        open_action = QAction("Open", self)
        open_action.triggered.connect(self.show_message_open)
        file_menu.addAction(open_action)
        exit_action = QAction("Exit", self)
        exit_action.triggered.connect(self.show_message_exit)
        file_menu.addAction(exit_action)
        # Edit menu
        edit_menu = menubar.addMenu("Edit")
        cut_action = QAction("Cut", self)
        cut_action.triggered.connect(self.show_message_cut)
        edit_menu.addAction(cut_action)

        copy_action = QAction("Copy", self)
        copy_action.triggered.connect(self.show_message_copy)
        edit_menu.addAction(copy_action)
    def show_message_open(self):
        QMessageBox.information(self, "Open Action", "Open actiontriggered.")
    
    def show_message_exit(self):
        QMessageBox.information(self, "Exit Action", "Exit actiontriggered.")

        self.close()

    def show_message_cut(self):
        QMessageBox.information(self, "Cut Action", "Cut actiontriggered.")
    
    def show_message_copy(self):
        QMessageBox.information(self, "Copy Action", "Copy actiontriggered.")

if __name__ == "__main__":
    app = QApplication(sys.argv)
    main_window = MyMainWindow()
    main_window.show()
    sys.exit(app.exec_())