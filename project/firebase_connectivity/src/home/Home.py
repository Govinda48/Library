#Home.py
import sys
from PyQt5.QtWidgets import QApplication, QLabel, QLineEdit, QPushButton, QVBoxLayout, QHBoxLayout, QFormLayout, QFileDialog, QRadioButton, QWidget, QMessageBox, QScrollArea, QSplitter
from PyQt5.QtGui import QPixmap
from PyQt5.QtCore import Qt
from google.cloud import firestore
import json
# Initialize Firestore client
credentials_path = './setup/infoform-1aa10-firebase-adminsdk-bvyvo-66ac539cc4.json'
with open(credentials_path) as json_file:
    credentials_info = json.load(json_file)
    
db = firestore.Client.from_service_account_info(credentials_info)

class C2W_UserProfileForm(QWidget):
    def __init__(self):
        super().__init__()
        
        self.c2w_init_ui()
        
    def c2w_init_ui(self):
        # Header
        header_label = QLabel('User Info')
        header_label.setAlignment(Qt.AlignCenter)
        header_label.setStyleSheet('background-color: #003A6B; color: white; padding: 10px; font-size: 22px; max-height:40px')

        # Form elements
        self.c2w_first_name_edit = QLineEdit()
        self.c2w_last_name_edit = QLineEdit()
        self.c2w_mobile_no_edit = QLineEdit()
        self.c2w_profile_photo_label = QLabel('No file selected')
        self.c2w_gender_radio_male = QRadioButton('Male')
        self.c2w_gender_radio_female = QRadioButton('Female')
        self.c2w_height_edit = QLineEdit()
        
        # Image label
        self.c2w_image_label = QLabel()
        self.c2w_image_label.setAlignment(Qt.AlignCenter)
        self.c2w_image_label.setFixedSize(200, 200)
        self.c2w_image_label.hide()
        
        # Buttons
        self.c2w_select_photo_button = QPushButton('Select Photo')
        self.c2w_submit_button = QPushButton('Save')
        self.c2w_view_record = QPushButton("View All Records")
        
        # self.c2w_submit_button.setStyleSheet("margin-top:100px")
        # Output label
        self.c2w_output_label = QLabel()
        self.c2w_output_label.setStyleSheet('font-size: 14px; margin-top: 10px;')
        
        # Form layout
        form_layout = QFormLayout()
        form_layout.addRow('Enter First Name:', self.c2w_first_name_edit)
        form_layout.addRow('Enter Last Name:', self.c2w_last_name_edit)
        form_layout.addRow('Enter Mobile No:', self.c2w_mobile_no_edit)
        form_layout.addRow('Select Profile Photo:', self.c2w_profile_photo_label)
        form_layout.addRow(self.c2w_select_photo_button)
        form_layout.addRow('Gender:', self.c2w_gender_radio_male)
        form_layout.addRow('', self.c2w_gender_radio_female)
        form_layout.addRow('Height (cm):', self.c2w_height_edit)
        
        # Button layout
        button_layout = QVBoxLayout()
        button_layout.addWidget(self.c2w_submit_button)
        button_layout.addWidget(self.c2w_view_record)

        # Left half layout (form)
        left_layout = QVBoxLayout()
        left_layout.addWidget(header_label)
        left_layout.addLayout(form_layout)
        left_layout.addLayout(button_layout)
        left_layout.addWidget(self.c2w_output_label)
        
        # Right half layout (records)
        self.records_widget = QWidget() # Widget to hold the records layout
        self.records_layout = QVBoxLayout(self.records_widget)
        
        # QVBoxLayout for the records
        self.records_layout.setAlignment(Qt.AlignTop) # Align records to the top
        
        # Scroll area for records
        scroll_area = QScrollArea()
        scroll_area.setWidgetResizable(True)
        scroll_area.setWidget(self.records_widget)
        
        # Splitter to divide the window into two halves
        splitter = QSplitter(Qt.Horizontal)
        splitter.addWidget(QWidget())
        splitter.addWidget(QWidget())
        splitter.setSizes([self.width() // 2, self.width() // 2])
        splitter.setStyleSheet("QSplitter::handle {background: lightgray;}")
        
        splitter.widget(0).setLayout(left_layout)
        splitter.widget(1).setLayout(QVBoxLayout())
        splitter.widget(1).layout().addWidget(scroll_area)
        
        main_layout = QVBoxLayout()
        main_layout.addWidget(splitter)
        
        self.setLayout(main_layout)
        
        # Connections
        self.c2w_select_photo_button.clicked.connect(self.c2w_select_photo)
        self.c2w_submit_button.clicked.connect(self.c2w_submit_form)
        self.c2w_view_record.clicked.connect(self.c2w_fetch_records)
        
    def c2w_select_photo(self):
        # Open a file dialog to select a profile photo
        options = QFileDialog.Options()
        options |= QFileDialog.DontUseNativeDialog
        file_name, _ = QFileDialog.getOpenFileName(self, "Select Profile Photo", "","Image Files (*.png *.jpg *.jpeg *.bmp);;All Files (*)", options=options)
        if file_name:
            # Set the selected file path as the label text
            self.c2w_profile_photo_label.setText(file_name)
            # Load the image and display it
            pixmap = QPixmap(file_name)
            self.c2w_image_label.setPixmap(pixmap.scaled(self.c2w_image_label.size(),
        Qt.KeepAspectRatio, Qt.SmoothTransformation))
            
    def c2w_submit_form(self):
        # Validation
        if not self.c2w_first_name_edit.text() or not self.c2w_last_name_edit.text() or not self.c2w_mobile_no_edit.text():
        # Display an error message if any of the required fields are empty
            QMessageBox.critical(self, "Error", "Please fill in all required fields.")
            return
        
        # Mobile number validation
        mobile_no = self.c2w_mobile_no_edit.text()
        if not mobile_no.isdigit() or len(mobile_no) != 10:
            QMessageBox.critical(self, "Error", "Please enter a valid 10-digit mobile number.")
            return
        
        # Get the values from the form
        first_name = self.c2w_first_name_edit.text()
        last_name = self.c2w_last_name_edit.text()
        profile_photo = self.c2w_profile_photo_label.text()
        gender = 'Male' if self.c2w_gender_radio_male.isChecked() else 'Female'
        height = self.c2w_height_edit.text()
        # # Form output text
        output_text = f"Name: {first_name} {last_name}\n" \
            f"Mobile No: {mobile_no}\n" \
            f"Profile Photo: {profile_photo}\n" \
            f"Gender: {gender}\n" \
            f"Height: {height} cm"
            
        # Get a reference to the Firestore collection
        user_profiles_ref = db.collection('user_profiles')
        
        # Create a new user profile entry
        user_profile = {
            'first_name': first_name,
            'last_name': last_name,
            'mobile_no': mobile_no,
            'profile_photo': profile_photo,
            'gender': gender,
            'height': height
        }
        
        # Add the user profile to Firestore
        new_user_ref = user_profiles_ref.add(user_profile)
        
        # Get the unique ID generated by Firestore
        user_id = new_user_ref[1].id
        
        # Display success message with QMessageBox
        success_message = f"Form submitted successfully.\n\n" \
                f"Firestore User ID: {user_id}\n" \
                f"{output_text}"
        QMessageBox.information(self, "Success", success_message)
        
    def c2w_fetch_records(self):
        # Fetch data from Firestore
        user_profiles_ref = db.collection('user_profiles')
        user_profiles = user_profiles_ref.stream()
        self.record_label=QLabel("self")
        
        # Display records in the right section
        count=1
        records_text = ""
        for user_profile in user_profiles:
            user_data = user_profile.to_dict()
            record_label = QLabel()
            records_text = f"Record : {count}\n" \
                f"Name: {user_data['first_name']} {user_data['last_name']}\n" \
                f"Mobile No: {user_data['mobile_no']}\n" \
                f"Gender: {user_data['gender']}\n" \
                f"Height: {user_data['height']} cm\n" \
                f"Firestore User ID: {user_profile.id}\n\n"
            record_label.setText(records_text)
            record_label.setStyleSheet("background-color: rgb(255, 255, 255); border: 1px solid black; padding: 5px; border-radius:10px")
            self.records_layout.addWidget(record_label)
            if count%2==0:
                record_label.setStyleSheet("background-color: #c3bcbc; border: 1px solid black; padding: 5px; border-radius:10px")

        count += 1
        if not count > 1:
            self.records_layout.addWidget(QLabel("No records found"))