import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QVBoxLayout, QGraphicsView, QGraphicsScene, QGraphicsPixmapItem, QWidget, QDesktopWidget
from PyQt5.QtGui import QPixmap, QImage
from PIL import Image
import fitz # PyMuPDF
from PyQt5 import QtCore, QtGui, QtWidgets

class C2W_PythonInfo(object):
    def infoPage(self, parent):
        self.c2w_dialog = QtWidgets.QDialog(parent)
        self.c2w_ui = Ui_C2W_PythonInfoDialog()
        self.c2w_ui.setupUi(self.c2w_dialog)
        self.c2w_dialog.show()
        
class PDFViewer(QtWidgets.QWidget):
    def __init__(self, pdf_path):
        super().__init__()
        
        self.init_ui(pdf_path)
        
    def init_ui(self, pdf_path):
        layout = QtWidgets.QVBoxLayout(self)
        # Create a QGraphicsView to display the PDF
        self.c2w_pdf_view = QtWidgets.QGraphicsView(self)
        layout.addWidget(self.c2w_pdf_view)
        # Create a QGraphicsScene
        self.c2w_pdf_scene = QtWidgets.QGraphicsScene(self)
        self.c2w_pdf_view.setScene(self.c2w_pdf_scene)
        # Load and display the PDF
        self.c2w_load_pdf(pdf_path)
    
    def c2w_load_pdf(self, pdf_path):
        # Open the PDF document using PyMuPDF
        pdf_document = fitz.open(pdf_path)
        # Iterate through each page and add it to the QGraphicsScene
        y_position = 0
        for page_number in range(pdf_document.page_count):
            page = pdf_document.load_page(page_number)
            
            image = page.get_pixmap()
            # Convert PyMuPDF Pixmap to PIL Image
            pil_image = Image.frombytes("RGB", (image.width, image.height),
            image.samples)
            # Convert PIL Image to QImage
            qimage = QImage(pil_image.tobytes(), pil_image.width, pil_image.height,
            QImage.Format_RGB888)
            # Convert QImage to QPixmap
            pixmap = QPixmap.fromImage(qimage)
            # Create QGraphicsPixmapItem and add to the scene
            image_item = QGraphicsPixmapItem(pixmap)
            image_item.setPos(0, y_position)
            y_position += image_item.pixmap().height()
            self.c2w_pdf_scene.addItem(image_item)
        # Close the PDF document
        pdf_document.close()
        
class Ui_C2W_PythonInfoDialog(object):
    def c2w_openLink(self, event):
        print("hello")
        # Open the link in the default web browser
        QtGui.QDesktopServices.openUrl(QtCore.QUrl("https://www.core2web.in/"))
        
    def setupUi(self, Widget):
        desktop = QDesktopWidget()
        # Get the primary screen (monitor)
        primary_screen = desktop.screenGeometry(desktop.primaryScreen())
        # Retrieve the width of the monitor
        monitor_width = primary_screen.width()
        monitor_height = primary_screen.height()
        Widget.setObjectName("Widget")
        Widget.resize(monitor_width, monitor_height)
        self.c2w_widget = QtWidgets.QWidget(Widget)
        self.c2w_widget.setGeometry(QtCore.QRect(0, 0, monitor_width, 50))
        self.c2w_widget.setStyleSheet("background:#0E1D35;")
        self.c2w_widget.setObjectName("widget")
        # Create a QLabel for the image
        self.c2w_imageLabel1 = QtWidgets.QLabel(self.c2w_widget)
        self.c2w_imageLabel1.setGeometry(QtCore.QRect(15, 0, 200, 50))
        self.c2w_imageLabel1.setObjectName("imageLabel")
        # Load an image using QPixmap
        pixmap1 = QtGui.QPixmap('./assets/images/core2web-logo.png')
        
        # Set Style on image
        # Set the pixmap to the QLabel
        self.c2w_imageLabel1.setPixmap(pixmap1)
        self.c2w_imageLabel1.mouseDoubleClickEvent=self.c2w_openLink
        self.c2w_frame = QtWidgets.QFrame(Widget)
        self.c2w_frame.setGeometry(QtCore.QRect(0, 50, monitor_width,
        monitor_height-50))
        self.c2w_frame.setStyleSheet("background:#2B3D5B;\nfont-style: poppins")
        self.c2w_frame.setFrameShape(QtWidgets.QFrame.StyledPanel)
        self.c2w_frame.setFrameShadow(QtWidgets.QFrame.Raised)
        self.c2w_frame.setObjectName("frame")
        self.c2w_tabWidget = QtWidgets.QTabWidget(self.c2w_frame)
        self.c2w_tabWidget.setGeometry(QtCore.QRect(0, 0, monitor_width,
        monitor_height-50))
        self.c2w_tabWidget.setObjectName("tabWidget")
        
        # Tab 1: Introduction
        self.c2w_tab = QtWidgets.QWidget()
        self.c2w_tab.setObjectName("tab")
        self.c2w_tabWidget.addTab(self.c2w_tab, "")
        
        # Tab 2: History
        self.c2w_tab_2 = QtWidgets.QWidget()
        self.c2w_tab_2.setObjectName("tab_2")
        self.c2w_tabWidget.addTab(self.c2w_tab_2, "")
        
        # Tab 3: Index
        self.c2w_tab_3 = QtWidgets.QWidget()
        self.c2w_tab_3.setObjectName("tab_3")
        self.c2w_tabWidget.addTab(self.c2w_tab_3, "")
        
        # Tab 3: Practice
        self.c2w_tab_4 = QtWidgets.QWidget()
        self.c2w_tab_4.setObjectName("tab_4")
        self.c2w_tabWidget.addTab(self.c2w_tab_4, "")
        
        self.c2w_tabStyle = """height:200px; width:50px; background-color:red;"""
        self.c2w_tab.setStyleSheet("background-color: #C3C3C3;")
        self.c2w_tab_2.setStyleSheet("background-color: #C3C3C3;")
        self.c2w_tab_3.setStyleSheet("background-color: #C3C3C3;")
        
        # Add PDFViewer to the Introduction tab
        self.c2w_pdf_viewer = PDFViewer('./assets/pdf/pdf1.pdf')
        layout = QtWidgets.QVBoxLayout(self.c2w_tab)
        layout.addWidget(self.c2w_pdf_viewer)
        
        # Add PDFViewer to the History tab
        self.c2w_pdf_viewer = PDFViewer('./assets/pdf/pdf2.pdf')
        layout = QtWidgets.QVBoxLayout(self.c2w_tab_2)
        layout.addWidget(self.c2w_pdf_viewer)
        
        # Add PDFViewer to the Index Tab
        self.c2w_pdf_viewer = PDFViewer('./assets/pdf/pdf3.pdf')
        layout = QtWidgets.QVBoxLayout(self.c2w_tab_3)
        layout.addWidget(self.c2w_pdf_viewer)
        self.retranslateUi(Widget)
        self.c2w_tabWidget.setCurrentIndex(0)
        QtCore.QMetaObject.connectSlotsByName(Widget)
        
    def retranslateUi(self, Widget):
        _translate = QtCore.QCoreApplication.translate
        Widget.setWindowTitle(_translate("Widget", "Python Library"))
        self.c2w_tabWidget.setTabText(self.c2w_tabWidget.indexOf(self.c2w_tab),
        _translate("Widget", "Introduction"))
        self.c2w_tabWidget.setTabText(self.c2w_tabWidget.indexOf(self.c2w_tab_2),
        _translate("Widget", "History"))
        self.c2w_tabWidget.setTabText(self.c2w_tabWidget.indexOf(self.c2w_tab_3),
        _translate("Widget", "Index"))
        self.c2w_tabWidget.setTabText(self.c2w_tabWidget.indexOf(self.c2w_tab_4),
        _translate("Widget", "Practice"))
