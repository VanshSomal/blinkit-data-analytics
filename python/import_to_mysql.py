import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy.engine import URL


# Path to your CSV file
csv_path = r"C:\PROGRAMMING-2026\Data Analytics\Blinkit Project\data\BlinkIT-Grocery-Data.csv"
# Read the CSV
df = pd.read_csv(csv_path)

# Convert blank values to NULL
df = df.replace("", pd.NA)

# MySQL connection
connection_url = URL.create(
    drivername="mysql+pymysql",
    username="root",
    password="Minions@1234",
    host="localhost",
    port=3306,
    database="blinkit_db"
)

engine = create_engine(connection_url)

# Upload the data
df.to_sql(
    name="blinkit_data",
    con=engine,
    if_exists="replace",
    index=False
)

print(f"Imported {len(df)} rows successfully!")