# dpsd_project_frontend

## **Pig Farmer Project Frontend Documentation**

## **Overview**

This repository contains the **Frontend** application for the **Pig Farmer** project. The frontend is developed using **Flutter** and communicates with a **Kotlin**-based backend. It is designed for managing pigs, tracking pig vitals, monitoring environmental variables, and handling user authentication.

### **Technologies Used**
- **Flutter**: Framework for building the mobile app.
- **Dart**: Programming language for Flutter development.
- **Dio**: HTTP client for making requests to the backend API.
- **Shared Preferences**: For storing local data such as user information and settings.
- **flutter_dotenv**: For managing environment variables securely (API keys, URLs).

---

## **Features**

### 1. **User Authentication**
   - **Register User**: Allows new users to register by providing their first name, last name, email, and password.
   - **Login User**: Allows users to log in with their credentials.
   - **User Profile**: Enables users to view and update their profile information (name, email).

### 2. **Pig Management**
   - **Add Pig**: Users can add pigs with details like name, breed, age, and weight.
   - **Monitor Pigs**: View a list of pigs and their details.
   - **View Pig Vitals**: View the vitals (e.g., temperature, heart rate, respiratory rate, weight) for a specific pig.
   - **Add Pig Vitals**: Add vitals data for a pig, such as temperature, heart rate, and weight.
   - **Check Pig Diseases**: Enter symptoms to identify possible diseases in pigs.

### 3. **Ambient Variables**
   - **Monitor Ambient Variables**: Users can view and monitor environmental variables such as temperature, humidity, wind speed, etc.
   - **Add Ambient Variables**: Users can add and set threshold values for various environmental variables.
   
### 4. **Guidelines and FAQ**
   - **Guidelines**: Users can ask questions related to pig management and receive responses based on predefined information or AI-based responses (e.g., OpenAI, Gemini).
   - **FAQ Section**: Provides frequently asked questions with answers about pig management and the application.

### 5. **Alerts**
   - **Set Alerts**: Users can set alerts based on certain conditions (e.g., abnormal pig vitals or environmental conditions).

### 6. **User Settings**
   - **Change Password**: Users can change their account password.
   - **Delete Account**: Users can delete their account after confirmation.

---

## **Setup Instructions**

### **Prerequisites**
1. **Install Flutter**: Ensure Flutter is installed on your local machine.
   - [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)

2. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/dpsd_project2_frontend_iteration_1.git
   cd dpsd_project2_frontend_iteration_1
