import sys
from PyQt5.QtWidgets import QApplication, QWidget, QLineEdit, QPushButton, QVBoxLayout, QMessageBox

class NameInputDialog(QWidget):
    def __init__(self):
        super().__init__()

        self.init_ui()

    def init_ui(self):
        self.setWindowTitle('Enter Your Name')
        self.setGeometry(300, 300, 300, 150)

        self.name_input = QLineEdit(self)
        ok_button = QPushButton('OK', self)
        ok_button.clicked.connect(self.show_greeting)

        layout = QVBoxLayout(self)
        layout.addWidget(self.name_input)
        layout.addWidget(ok_button)

    def show_greeting(self):
        user_name = self.name_input.text().strip()

        if user_name:
            greeting_message = f'Hello, {user_name}!'
            QMessageBox.information(self, 'Greeting', greeting_message)
            self.close()
        else:
            QMessageBox.warning(self, 'Warning', 'Please enter your name.')

def main():
    app = QApplication(sys.argv)
    dialog = NameInputDialog()
    dialog.show()
    sys.exit(app.exec_())

if __name__ == '__main__':
    main()
