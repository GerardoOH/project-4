CREATE TABLE checkin_checkout_history_update (
    user_id VARCHAR(50),
    gym_id VARCHAR(50),
    checkin_time TIMESTAMP,
    checkout_time TIMESTAMP,
    workout_type VARCHAR(50),
    calories_burned INT
);

CREATE TABLE subscription_plans (
    subscription_plan VARCHAR(50),
    price_per_month DECIMAL(5, 2),
    features TEXT
);


CREATE TABLE users_data (
    user_id VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    birthdate DATE,
    sign_up_date DATE,
    user_location VARCHAR(50),
    subscription_plan VARCHAR(50)
);

CREATE TABLE gym_locations_data (
    gym_id VARCHAR(50),
    location VARCHAR(50),
    gym_type VARCHAR(50),
    facilities TEXT
);

-- Modificar la tabla users_data para añadir una restricción PRIMARY KEY
ALTER TABLE users_data
ADD CONSTRAINT pk_user_id PRIMARY KEY (user_id);

-- Modificar la tabla gym_locations_data para añadir una restricción PRIMARY KEY
ALTER TABLE gym_locations_data
ADD CONSTRAINT pk_gym_id PRIMARY KEY (gym_id);

-- Modificar la tabla subscription_plans para añadir una restricción UNIQUE
ALTER TABLE subscription_plans
ADD CONSTRAINT unique_subscription_plan UNIQUE (subscription_plan);

-- Relacionar la tabla checkin_checkout_history_update con users_data y gym_locations_data
ALTER TABLE checkin_checkout_history_update
ADD CONSTRAINT fk_user
FOREIGN KEY (user_id) REFERENCES users_data(user_id);

ALTER TABLE checkin_checkout_history_update
ADD CONSTRAINT fk_gym
FOREIGN KEY (gym_id) REFERENCES gym_locations_data(gym_id);

-- Relacionar la tabla users_data con subscription_plans
ALTER TABLE users_data
ADD CONSTRAINT fk_subscription_plan
FOREIGN KEY (subscription_plan) REFERENCES subscription_plans(subscription_plan);


