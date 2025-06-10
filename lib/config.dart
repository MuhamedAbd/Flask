class Config {
  // For development (emulator)
  static const String devApiUrl = 'http://10.0.2.2:5000';
  
  // For production (deployed backend)
  static const String prodApiUrl = 'https://sleep-health-api.onrender.com';  // Replace with your actual Render URL
  
  // Use this to switch between development and production
  static const bool isDevelopment = false;  // Set to false when building for production
  
  // Get the current API URL based on environment
  static String get apiUrl => isDevelopment ? devApiUrl : prodApiUrl;
  
  // API endpoints
  static String get healthEndpoint => '$apiUrl/health';
  static String get predictEndpoint => '$apiUrl/predict';
} 