from flask import Flask, request, jsonify
from flask_cors import CORS
import joblib
import numpy as np
import pandas as pd
import logging
from sklearn.ensemble import RandomForestClassifier
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Define paths using environment variables with fallbacks
DATASET_PATH = os.getenv('DATASET_PATH', r"C:\New folder\Sleep_health_and_lifestyle_dataset.csv")
MODEL_PATH = os.getenv('MODEL_PATH', 'sleep_model.joblib')
PORT = int(os.getenv('PORT', 5000))

# Load or train the model
try:
    logger.info("Attempting to load existing model...")
    if not os.path.exists(MODEL_PATH):
        raise FileNotFoundError(f"Model file not found at {MODEL_PATH}")
    model = joblib.load(MODEL_PATH)
    logger.info("Model loaded successfully")
except Exception as e:
    logger.error(f"Error loading model: {str(e)}", exc_info=True)
    if os.getenv('ENVIRONMENT') == 'production':
        raise RuntimeError("Model loading failed in production environment") from e
    logger.info("Training new model...")
    try:
        # Load the dataset from the specified path
        if not os.path.exists(DATASET_PATH):
            raise FileNotFoundError(f"Dataset file not found at {DATASET_PATH}")
        logger.info(f"Loading dataset from: {DATASET_PATH}")
        df = pd.read_csv(DATASET_PATH)
        logger.info(f"Dataset loaded successfully with {len(df)} rows")
        
        # Prepare features and target
        X = df[['Age', 'Sleep Duration', 'Stress Level', 'Physical Activity Level', 'Heart Rate']]
        y = df['Quality of Sleep']
        
        # Train the model
        model = RandomForestClassifier(n_estimators=100, random_state=42)
        model.fit(X, y)
        
        # Save the model
        joblib.dump(model, MODEL_PATH)
        logger.info("New model trained and saved successfully")
        
    except Exception as e:
        logger.error(f"Error training model: {str(e)}", exc_info=True)
        raise

@app.route('/test', methods=['GET'])
def test():
    return jsonify({"status": "ok", "message": "Server is running"})

@app.route('/predict', methods=['POST'])
def predict():
    try:
        logger.info("Received prediction request")
        data = request.get_json()
        logger.info(f"Request data: {data}")
        
        # Extract features
        features = np.array([[
            float(data['age']),
            float(data['sleepDuration']),
            float(data['stressLevel']),
            float(data['physicalActivityLevel']),
            float(data['heartRate'])
        ]])
        
        logger.info(f"Features array: {features}")
        
        # Make prediction
        prediction = model.predict(features)[0]
        logger.info(f"Model prediction (Quality of Sleep): {prediction}")
        
        # Generate advice
        advice = generate_advice(prediction, {
            'age': float(data['age']),
            'sleep_duration': float(data['sleepDuration']),
            'stress_level': float(data['stressLevel']),
            'physical_activity': float(data['physicalActivityLevel']),
            'heart_rate': float(data['heartRate'])
        })
        
        logger.info(f"Generated advice: {advice}")
        
        # Ensure we always return at least some basic advice
        if not advice:
            advice = ["Based on your inputs, your sleep patterns appear to be within normal ranges. Continue maintaining your current sleep habits."]
        
        return jsonify({
            'advice': advice,
            'error': None
        })
        
    except Exception as e:
        logger.error(f"Error in prediction: {str(e)}", exc_info=True)
        return jsonify({
            'advice': [],
            'error': str(e)
        }), 400

def generate_advice(prediction, inputs):
    """Generate personalized sleep advice based on model prediction and inputs"""
    advice = []
    
    # Quality of Sleep based advice
    if prediction < 5:
        advice.extend([
            "Your sleep quality is below average. Here are some specific steps to improve it:",
            "1. Create a consistent sleep schedule - go to bed and wake up at the same time every day, even on weekends",
            "2. Develop a relaxing bedtime routine: take a warm bath, read a book, or practice gentle stretching",
            "3. Keep your bedroom cool (around 65°F/18°C), dark, and quiet",
            "4. Avoid caffeine after 2 PM and limit alcohol consumption"
        ])
    elif prediction > 8:
        advice.extend([
            "Your sleep quality is excellent! Here are some tips to maintain it:",
            "1. Continue your current sleep schedule and bedtime routine",
            "2. Keep your bedroom environment optimal for sleep",
            "3. Maintain your current exercise and stress management practices"
        ])
    
    # Sleep duration advice
    if inputs['sleep_duration'] < 6:
        advice.extend([
            "Your sleep duration is significantly below recommended levels. Here's how to increase it:",
            "1. Gradually adjust your bedtime 15 minutes earlier each week until you reach 7-9 hours",
            "2. Limit daytime naps to 20-30 minutes before 3 PM",
            "3. Avoid using electronic devices 1 hour before bedtime",
            "4. Consider using blue light filters on your devices in the evening"
        ])
    elif inputs['sleep_duration'] < 7:
        advice.extend([
            "To reach optimal sleep duration (7-9 hours):",
            "1. Create a wind-down routine starting 1 hour before bedtime",
            "2. Use relaxation techniques like deep breathing or progressive muscle relaxation",
            "3. Keep a sleep diary to track your sleep patterns and identify areas for improvement"
        ])
    elif inputs['sleep_duration'] > 9:
        advice.extend([
            "Your sleep duration is longer than recommended. Consider these adjustments:",
            "1. Gradually reduce sleep time by 15 minutes every few days",
            "2. Increase morning light exposure to help regulate your circadian rhythm",
            "3. Engage in morning exercise to boost energy levels",
            "4. Unless recovering from sleep debt, aim for 7-9 hours of sleep"
        ])
    
    # Stress level advice
    if inputs['stress_level'] > 7:
        advice.extend([
            "High stress levels detected. Here are specific stress-reduction techniques:",
            "1. Practice 4-7-8 breathing: inhale for 4 seconds, hold for 7, exhale for 8",
            "2. Try progressive muscle relaxation before bed",
            "3. Keep a worry journal to write down concerns before bedtime",
            "4. Consider mindfulness meditation or guided sleep meditation",
            "5. Create a 'worry time' earlier in the day to address concerns"
        ])
    elif inputs['stress_level'] > 5:
        advice.extend([
            "Moderate stress levels detected. Consider these stress management techniques:",
            "1. Practice daily relaxation exercises",
            "2. Establish a consistent exercise routine",
            "3. Try journaling or talking to a friend about your concerns",
            "4. Consider aromatherapy with lavender or chamomile before bed"
        ])
    
    # Physical activity advice
    if inputs['physical_activity'] < 3:
        advice.extend([
            "Low physical activity detected. Here's how to incorporate more movement:",
            "1. Start with 30 minutes of moderate exercise daily (walking, swimming, cycling)",
            "2. Break exercise into smaller sessions throughout the day",
            "3. Try morning exercise to boost energy and improve sleep quality",
            "4. Consider joining a fitness class or finding an exercise buddy",
            "5. Use a step counter to gradually increase daily steps"
        ])
    elif inputs['physical_activity'] > 7:
        advice.extend([
            "While high physical activity is beneficial, consider these timing tips:",
            "1. Avoid intense exercise within 3 hours of bedtime",
            "2. Schedule vigorous workouts earlier in the day",
            "3. Consider gentle evening activities like yoga or stretching",
            "4. Monitor how exercise timing affects your sleep quality"
        ])
    elif inputs['physical_activity'] < 5:
        advice.extend([
            "To improve sleep through physical activity:",
            "1. Aim for 30 minutes of moderate exercise most days",
            "2. Try different types of exercise to find what you enjoy",
            "3. Include both cardio and strength training",
            "4. Consider outdoor exercise for natural light exposure"
        ])
    
    # Heart rate advice
    if inputs['heart_rate'] > 100:
        advice.extend([
            "Elevated heart rate detected. Consider these steps:",
            "1. Practice deep breathing exercises",
            "2. Try progressive muscle relaxation",
            "3. Consider consulting a healthcare provider",
            "4. Monitor your heart rate during different activities",
            "5. Avoid stimulants like caffeine and nicotine"
        ])
    elif inputs['heart_rate'] > 85:
        advice.extend([
            "Slightly elevated heart rate. Try these relaxation techniques:",
            "1. Practice regular deep breathing exercises",
            "2. Consider gentle yoga or tai chi",
            "3. Take regular breaks during the day",
            "4. Monitor stress levels and implement stress-reduction techniques"
        ])
    
    # Age-specific advice
    if inputs['age'] < 18:
        advice.extend([
            "As a teen, optimize your sleep with these tips:",
            "1. Maintain a consistent sleep schedule, even on weekends",
            "2. Limit screen time 1 hour before bed",
            "3. Create a relaxing bedtime routine",
            "4. Keep your bedroom cool, dark, and quiet",
            "5. Avoid caffeine and energy drinks",
            "6. Get regular exercise, but not close to bedtime"
        ])
    elif inputs['age'] > 65:
        advice.extend([
            "For better sleep as an older adult:",
            "1. Consider shorter, more frequent sleep periods",
            "2. Take a short nap (20-30 minutes) early in the day if needed",
            "3. Stay active during the day with regular exercise",
            "4. Limit fluid intake before bedtime",
            "5. Ensure your bedroom is comfortable and properly lit",
            "6. Consider using a white noise machine if needed"
        ])
    
    # Time-based combined advice
    if inputs['sleep_duration'] < 7 and inputs['stress_level'] > 5:
        advice.extend([
            "For better sleep with high stress and low duration:",
            "1. Create a 1-hour wind-down routine before bed",
            "2. Practice stress-reduction techniques daily",
            "3. Consider cognitive behavioral therapy for insomnia (CBT-I)",
            "4. Keep a sleep diary to track patterns",
            "5. Try relaxation apps or guided meditation"
        ])
    
    if inputs['physical_activity'] < 4 and inputs['sleep_duration'] < 7:
        advice.extend([
            "To improve sleep through activity and duration:",
            "1. Start with 20 minutes of morning exercise",
            "2. Gradually increase activity levels",
            "3. Create a consistent sleep schedule",
            "4. Track your sleep and activity patterns",
            "5. Consider consulting a sleep specialist"
        ])
    
    # General sleep hygiene tips
    advice.extend([
        "General sleep hygiene tips:",
        "1. Keep your bedroom temperature between 65-68°F (18-20°C)",
        "2. Use your bed only for sleep and intimacy",
        "3. Avoid large meals and excessive fluids before bedtime",
        "4. Consider using a white noise machine or earplugs if needed",
        "5. Invest in a comfortable mattress and pillows"
    ])
    
    # Remove any duplicate advice
    advice = list(dict.fromkeys(advice))
    
    logger.info(f"Generated {len(advice)} pieces of advice")
    return advice

if __name__ == '__main__':
    logger.info("Starting Flask server...")
    # Use environment variable for host in production
    host = '0.0.0.0' if os.getenv('ENVIRONMENT') == 'production' else 'localhost'
    debug = os.getenv('ENVIRONMENT') != 'production'
    app.run(host=host, port=PORT, debug=debug) 