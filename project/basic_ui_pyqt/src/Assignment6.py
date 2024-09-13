# Build a PyQt application with a QRadioButton group for selecting a programming language (e.g., Python, Java, C++). Display a message indicating the selected language when a radio button is clicked.

import sys
from PyQt5.QtWidgets import QApplication, QWidget, QRadioButton, QVBoxLayout,QLabel
class RadioButtonApp(QWidget):
    def __init__(self):
        super().__init__()
        self.radioUI()

    def radioUI(self):
        self.setWindowTitle("Radio Button Example")
        self.setGeometry(300, 300, 400, 200) # (x, y, width, height)
        layout = QVBoxLayout()
        # Create radio buttons for options
        self.option1_radio = QRadioButton("Python", self)
        self.option2_radio = QRadioButton("Java", self)
        self.option3_radio = QRadioButton("C++", self)
        layout.addWidget(self.option1_radio)
        layout.addWidget(self.option2_radio)
        layout.addWidget(self.option3_radio)
        # Create a label to display the selected option
        self.selected_option_label = QLabel("Selected Option: None", self)
        layout.addWidget(self.selected_option_label)
        # Connect the radio buttons' toggled signal to a slot that updates the label
        self.option1_radio.toggled.connect(lambda:
        self.update_selected_option("Python"))
        self.option2_radio.toggled.connect(lambda:
        self.update_selected_option("Java"))
        self.option3_radio.toggled.connect(lambda:
        self.update_selected_option("C++"))
        self.setLayout(layout)

    def update_selected_option(self, option):
        if option:
            self.selected_option_label.setText(f"Selected Option: {option}")
            
if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = RadioButtonApp()
    window.show()
    sys.exit(app.exec_())