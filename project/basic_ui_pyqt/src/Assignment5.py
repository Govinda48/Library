import sys
from PyQt5.QtWidgets import QApplication, QWidget, QVBoxLayout, QComboBox
from PyQt5.QtGui import QColor

class ColorChangerApp(QWidget):
    def __init__(self):
        super().__init__()
        self.init_ui()

    def init_ui(self):
        layout = QVBoxLayout()
        color_combo = QComboBox(self)
        colors = ["Red", "Green", "Blue", "Yellow", "Cyan", "Magenta"]
        color_combo.addItems(colors)
        color_combo.currentIndexChanged.connect(self.change_color)
        layout.addWidget(color_combo)
        self.setLayout(layout)
        self.change_color(0)
        self.setGeometry(500, 300, 500, 400)
        self.setWindowTitle('Color Changer App')

    def change_color(self, index):
        color_name = self.sender().currentText() if self.sender() else "Red"
        color = QColor(color_name)
        self.setStyleSheet(f"background-color: {color.name()};")

if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = ColorChangerApp()
    ex.show()
    sys.exit(app.exec_())