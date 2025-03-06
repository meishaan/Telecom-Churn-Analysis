import pandas as pd
import numpy as np
import pymysql 

# Load dataset
df = pd.read_csv("d:/STUDY/Data Analytics/Churn Dataset/Customer Churn.csv")

# Remove duplicates
df = df.drop_duplicates()

# Remove double spaces from column names
df.columns = df.columns.str.replace(r'\s+', ' ', regex=True).str.strip()

# Handle missing values
df.fillna({
    "Age": df["Age"].median(), 
    "Tariff Plan": df["Tariff Plan"].mode()[0],  # Replace with most common value
}, inplace=True)

# Handle outliers using capping
cap_cols = ["Charge Amount", "Seconds of Use", "Subscription Length", "Age"]
for col in cap_cols:
    lower = df[col].quantile(0.05)
    upper = df[col].quantile(0.95)
    df[col] = df[col].clip(lower, upper)

# Save cleaned dataset
df.to_csv("Cleaned Data.csv", index=False)
print("Data Cleaning Completed!")

# Connect to MySQL
connection = pymysql.connect(
    host="localhost",
    user="root",
    password="Oriental#1",
    database="churn_analysis"
)
cursor = connection.cursor()

# Insert data into MySQL table
for _, row in df.iterrows():
    sql = """INSERT INTO customer_churn 
    (Call_Failure, Complains, Subscription_Length, Charge_Amount, Seconds_of_Use, 
    Frequency_of_Use, Frequency_of_SMS, Distinct_Called_Numbers, Age_Group, 
    Tariff_Plan, Status, Age, Customer_Value, Churn) 
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
    
    values = tuple(map(float, row))  # Convert all values to float
    cursor.execute(sql, values)

# Commit and close connection
connection.commit()
cursor.close()
connection.close()

print("Data successfully imported into MySQL!")
