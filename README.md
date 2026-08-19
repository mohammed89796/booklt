Booklt

Booklt is a full-stack booking application that allows users to discover service providers, explore their services and book appointments through a simple mobile experience.

Features

* User authentication
* Browse service providers
* View provider details
* View available services
* Check provider availability
* Select a service
* Book appointments
* Modern Flutter UI
* RESTful backend API

Tech Stack

Mobile App

* Flutter
* Dart

Backend

* Node.js
* Express.js
* MongoDB
* Mongoose

Authentication

* Clerk

Tools

* Git
* GitHub
* Postman

Architecture

The project follows a client-server architecture:

Flutter App
    |
    v
REST API
    |
    v
Node.js / Express
    |
    v
MongoDB

Booking Flow

Provider List
      |
      v
Provider Details
      |
      v
Available Services
      |
      v
Select Service
      |
      v
Check Availability
      |
      v
Book Appointment

Project Structure

booklt/
|
├── lib/
│   ├── screens/
│   ├── widgets/
│   ├── models/
│   ├── services/
│   └── ...
|
├── server/
│   ├── models/
│   ├── routes/
│   ├── middleware/
│   └── ...
|
└── README.md

Installation

Clone the repository

git clone https://github.com/mohammed89796/booklt.git
cd booklt

Install Flutter dependencies

flutter pub get

Install backend dependencies

cd server
npm install

Run the backend

npm start

Run the Flutter application

flutter run

API

The backend provides RESTful APIs for:

* Users
* Authentication
* Providers
* Services
* Availability
* Bookings

Future Improvements

* Online payment integration
* Push notifications
* Booking cancellation and rescheduling
* Provider dashboard
* Reviews and ratings
* Location-based provider discovery
* Booking history

Author

Mohammed Magdy

GitHub: https://github.com/mohammed89796
