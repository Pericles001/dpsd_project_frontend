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


3.  **Install Dependencies**:



    `flutter pub get`

4.  **Run the App**:
    Run the application on your emulator or connected device:


    `flutter run`

* * *

## **Configuration**

### **Base URL and API Keys**

For **API communication**, the **base URL** and **API keys** need to be configured.

1.  **API Base URL**:
    The **base URL** points to the backend API. During development, you will be using your local network IP address to connect to the backend (running via Docker). In production, replace it with the actual backend URL.

2.  **Environment Variables**:
    For sensitive information like **API keys** and **base URL**, it is best practice to use **.env files**. This ensures that sensitive data is not exposed in the codebase.

#### **Steps to Configure the Environment Variables:**

1.  **Install `flutter_dotenv`**:
    Add the `flutter_dotenv` package to your `pubspec.yaml` file:


    `dependencies:   flutter:     sdk: flutter   flutter_dotenv: ^5.0.2`

2.  **Create a `.env` File**:
    Create a `.env` file in the root directory of your project and add the following configurations:


    `# .env API_BASE_URL=http://172.29.105.191:8080/api   # Local backend URL (change to your own IP) WEATHER_API_KEY=your-weather-api-key-here   # Weather API key`

3.  **Load the Variables**:
    In your Dart files, use the `flutter_dotenv` package to load the variables:

    `import 'package:flutter_dotenv/flutter_dotenv.dart';  class ApiService {   static final String baseUrl = dotenv.env['API_BASE_URL']!;   static final String weatherApiKey = dotenv.env['WEATHER_API_KEY']!;    // Example API call   Future<Map<String, dynamic>> fetchWeatherData(String city) async {     final response = await Dio().get(       'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$city?unitGroup=metric&key=$weatherApiKey&contentType=json',     );     return response.data;   } }`

    Ensure that the `.env` file is added to `.gitignore` to keep it out of version control:


    `# .gitignore .env`

* * *

## **File Structure Overview**

-   **lib**: Contains all the main Flutter code for the application.
    -   **api\_service.dart**: Handles the communication with the backend API, including login, user registration, pig vitals, etc.
    -   **housing\_ventilation**: Includes features for monitoring ventilation and ambient variables.
    -   **pig**: Includes features for pig management, including adding pigs and tracking their vitals.
    -   **auth**: Manages user authentication, including login and registration.
    -   **alerts**: A page for setting and viewing alerts.
    -   **faq**: A page for frequently asked questions (FAQ).
* * *

## **Backend Integration**

The frontend interacts with the backend API hosted at the **Kotlin-based backend** repository:
**[dpsd\_project\_backend](https://github.com/kakpalu/dpsd_project_backend)**

### **Backend Setup**

To run the backend locally via **Docker**:

1.  Clone the backend repository:


    `git clone https://github.com/kakpalu/dpsd_project_backend.git cd dpsd_project_backend`

2.  **Build the Docker image**:


    `docker-compose build`

3.  **Run the Docker container**:


    `docker-compose up -d`

4.  **Access the Swagger API Documentation**:
    Open `http://localhost:8001/api/swagger/` in your browser to view the API documentation.

5.  **Check Docker container status**:


    `docker-compose ps`

6.  **Access PostgreSQL Database**:
    You can access the database using the following commands:


    `docker exec -it pf_db bash psql -U postgres select * from farmers;`

* * *

## **Sensitive Information Handling**

### **Environment Variables**:

-   **Do not hardcode** API keys, tokens, or sensitive information in your code.
-   Use **`.env`** files to store sensitive data locally, and ensure **.env** is included in your `.gitignore` to prevent it from being pushed to version control.

### **.gitignore**:

Make sure to exclude the `.env` file from your version control by adding it to your `.gitignore`:


`# .gitignore .env`

* * *

## **API Endpoints**

### **User Authentication**

-   **POST** `/api/register`: Registers a new user.
-   **POST** `/api/login`: Logs in a user and returns a token.

### **Pig Management**

-   **POST** `/api/pigs`: Adds a new pig.
-   **GET** `/api/pigs`: Retrieves all pigs.
-   **POST** `/api/pig_vitals`: Adds vitals to a pig.
-   **GET** `/api/pig_vitals`: Retrieves vitals for a specific pig.

### **Ambient Variables**

-   **POST** `/api/ambient_variables`: Adds an ambient variable (e.g., temperature, humidity).
-   **GET** `/api/ambient_variables`: Retrieves all ambient variables.
* * *

## **Conclusion**

This **Pig Farmer Project** provides a management system for pig farming, allowing users to monitor and track the health of pigs, ambient variables, and vitals, while also supporting user authentication. It is a full-stack application that combines Flutter for the frontend with a Kotlin-based backend, making it easy for farmers to manage their operations.
