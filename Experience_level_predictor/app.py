from flask import Flask, request, render_template
import pandas as pd
import joblib

# Load the trained model and scaler
model = joblib.load("experience_level_model.pkl")
scaler = joblib.load("scaler.pkl")

# Initialize Flask app
app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def home():
    if request.method == "POST":
        # Get data from the form
        data = request.form

        # Create a DataFrame for input data
        input_data = pd.DataFrame([{
            'Age': int(data['Age']),
            'Weight (kg)': float(data['Weight']),
            'Height (m)': float(data['Height']),
            'Max_BPM': int(data['Max_BPM']),
            'Avg_BPM': int(data['Avg_BPM']),
            'Resting_BPM': int(data['Resting_BPM']),
            'Session_Duration (hours)': float(data['Session_Duration']),
            'Calories_Burned': float(data['Calories_Burned']),
            'Fat_Percentage': float(data['Fat_Percentage']),
            'Water_Intake (liters)': float(data['Water_Intake']),
            'Workout_Frequency (days/week)': int(data['Workout_Frequency']),
            'BMI': float(data['BMI']),
            'Gender_Male': int(data['Gender_Male']),
            'Workout_Type_HIIT': 1 if data['Workout_Type'] == 'HIIT' else 0,
            'Workout_Type_Strength': 1 if data['Workout_Type'] == 'Strength' else 0,
            'Workout_Type_Yoga': 1 if data['Workout_Type'] == 'Yoga' else 0
        }])

        # Scale input data
        scaled_data = scaler.transform(input_data)

        # Predict experience level
        prediction = model.predict(scaled_data)[0]

        # Render template with prediction
        return render_template("index.html", result=f"The predicted experience level is: {prediction}")

    return render_template("index.html")

if __name__ == "__main__":
    app.run(debug=True)