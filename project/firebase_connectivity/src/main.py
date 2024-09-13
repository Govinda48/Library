#main.py
import sys
from PyQt5.QtWidgets import QApplication
from home.Home import C2W_UserProfileForm
from PyQt5 import QtGui
if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = C2W_UserProfileForm()
    ex.setWindowIcon(QtGui.QIcon('./assets/images/logo.png'))
    ex.setWindowTitle('User Info')
    ex.setGeometry(100, 100, 1300, 800)
    ex.show()
    sys.exit(app.exec_())