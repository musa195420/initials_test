# 📲 Flutter Frontend - RidingApp

### Frontend codebase for a ride-hailing application like Uber, built with Flutter and integrated with a Node.js + Supabase backend.

---

## 📦 Tech Stack

<table>
  <tr><th>Component</th><th>Tech Used</th></tr>
  <tr><td>Framework</td><td>Flutter</td></tr>
  <tr><td>Language</td><td>Dart</td></tr>
  <tr><td>State Management</td><td>Riverpod</td></tr>
  <tr><td>Routing</td><td>GoRouter</td></tr>
  <tr><td>Service Locator</td><td>GetIt</td></tr>
  <tr><td>Maps</td><td>Open Maps API, GeoEncoding</td></tr>
  <tr><td>Storage</td><td>Supabase Storage Bucket</td></tr>
  <tr><td>API</td><td>HTTP (REST API calls to Node.js)</td></tr>
  <tr><td>App Safety</td><td>Run in Guarded Zone</td></tr>
  <tr><td>Theming</td><td>Centralized App Theme</td></tr>
</table>

---

## 📁 Folder Structure

<table>
  <tr><th>Folder/File</th><th>Description</th></tr>
  <tr><td>/lib/</td><td>Main Flutter application code</td></tr>
  <tr><td>/lib/screens/</td><td>All UI screens (Login, Ride, Profile, etc.)</td></tr>
  <tr><td>/lib/models/</td><td>App-specific data models</td></tr>
  <tr><td>/lib/services/</td><td>API communication, singleton logic, storage handling</td></tr>
  <tr><td>/lib/router/</td><td>Route configuration using GoRouter</td></tr>
  <tr><td>/lib/providers/</td><td>Riverpod state management files</td></tr>
  <tr><td>/lib/helper/</td><td>Theme, constants, util methods</td></tr>
  <tr><td>/assets/</td><td>Images and icons</td></tr>
  <tr><td>pubspec.yaml</td><td>Dependencies and asset declarations</td></tr>
</table>

---

## ⦾ Key Features

• ⦿ User registration & login with Supabase auth  
• ⦿ Profile management with image upload  
• ⦿ Apply as driver (upload CNIC & license using image_picker)  
• ⦿ Ride request, status updates, and history  
• ⦿ Real-time tracking of drivers using geo-coordinates  
• ⦿ Snackbar and toast-based feedback system  
• ⦿ Strong validation and error handling logic  
• ⦿ App theme switching and centralized styling  
• ⦿ Zone-guarded app launch to catch global errors  
• ⦿ Clean, modular, and scalable folder structure  

---

## ⦾ API Integration

• ◎ Communicates with backend using HTTP REST calls  
• ◎ Handles JWT token securely for authenticated endpoints  
• ◎ Shows real-time status (ride updates, driver location)  
• ◎ Integrates with Supabase for auth and file storage  

---

## 🛠️ How to Run

```bash
# Clone the frontend repo
git clone https://github.com/musa195420/initials_test -b rideApp

# Navigate to the project folder
cd initials_test

# Get Flutter dependencies
flutter pub get

# Run the app
flutter run
