from flask import Flask, request, render_template
import numpy as np
import pandas as pd
from tensorflow.keras.models import load_model
from sklearn.preprocessing import StandardScaler

print("Starting Flask app...")

# Initialize Flask app
app = Flask(__name__)

# Load the trained model
MODEL_PATH = 'workout_type_classifier.h5'
model = load_model(MODEL_PATH)

# Define the scaler (ensure consistent preprocessing)
scaler = StandardScaler()

# Feature order (used during training)
feature_order = [
    'Age', 'Weight (kg)', 'Height (m)', 'Max_BPM', 
    'Avg_BPM', 'Resting_BPM', 'BMI', 'Calories_Burned'
]

# Workout labels
workout_labels = {0: "Yoga", 1: "HIIT", 2: "Cardio", 3: "Strength"}

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Extract user input from the form
        user_input = [float(request.form[feature]) for feature in feature_order]

        # Preprocess the input
        input_df = pd.DataFrame([user_input], columns=feature_order)
        scaled_data = scaler.fit_transform(input_df)  # Scale data
        processed_data = scaled_data.reshape(1, -1)

        # Make prediction
        prediction = model.predict(processed_data)
        predicted_class = int(np.argmax(prediction))
        workout_type = workout_labels[predicted_class]

        # Return the result
        return render_template('index.html', prediction_text=f"Recommended Workout Type: {workout_type}")

    except Exception as e:
        return render_template('index.html', prediction_text="Error occurred. Please check your inputs!")

if __name__ == "__main__":
    app.run(debug=True)