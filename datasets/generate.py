#!/usr/bin/env python3
import pandas as pd
# Data for each table
category_data = {
    "name": ["Outdoor Sports", "Fitness", "Ball Sports"],
    "description": [
        "Equipment for outdoor activities like hiking and camping.",
        "Equipment for fitness training such as weights and resistance bands.",
        "Equipment for sports like soccer, basketball, and tennis.",
    ],
}

address_data = {
    "street_line1": [
        "123 Maple St",
        "456 Oak Ave",
        "pl. Svabody 13",
        "vulica Kastryčnickaja, 12",
        "vulica Pryvakzalnaja, 5",
    ],
    "street_line2": ["Apt 1", "Suite 202", "kv. 32", None, None],
    "city": ["Springfield", "Shelbyville", "Minsk", "Minsk", "Hrodna"],
    "province": ["Illinois", "Kentucky", "Minsk", "Minsk", "Hrodnienskaja"],
    "country": ["USA", "USA", "Belarus", "Belarus", "Belarus"],
    "postal_code": ["62704", "40065", "220050", "221140", "208900"],
}


# Saving CSV files
tables = {
    "CATEGORY": category_data,
    "ADDRESS": address_data,
}

file_paths = {}
for table_name, data in tables.items():
    df = pd.DataFrame(data)
    file_path = f"./{table_name.lower()}.csv"
    df.to_csv(file_path, index=False)
    file_paths[table_name] = file_path

file_paths
