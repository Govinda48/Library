# Develop a simple PyQt application with a QTableWidget displaying a grid of data (e.g.numbers or names).

import sys
from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtCore import Qt

class TableModel(QtCore.QAbstractTableModel):
    def __init__(self, data):
        super(TableModel, self).__init__()
        self._data = data
    def data(self, index, role):
        if role == Qt.DisplayRole:
            return self._data[index.row()][index.column()]
    def rowCount(self, index):
        return len(self._data)

    def columnCount(self, index):
        return len(self._data[0])

class MainWindow(QtWidgets.QMainWindow):
    def __init__(self):
        super().__init__()
        self.table = QtWidgets.QTableView()
        data = [
        [4, 9, 2],
        [1, 0, 0],
        [3, 5, 0],
        [3, 3, 2],
        [7, 8, 9],
        ]
        self.model = TableModel(data)
        self.table.setModel(self.model)
        self.setCentralWidget(self.table)
if __name__ == "__main__":
    app=QtWidgets.QApplication(sys.argv)
    window=MainWindow()
    window.show()
    app.exec_()
