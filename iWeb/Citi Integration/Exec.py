import pandas as pd

input_csv_file = 'Book.csv'  # Replace with your input CSV file path
output_csv_file = 'merged_output.csv'  # Replace with your desired output CSV file path

df = pd.read_csv(input_csv_file)

if 'Column1' not in df.columns or 'Column2' not in df.columns:
    raise ValueError("CSV file must contain 'Column1' and 'Column2'")

df['MergedColumn'] = df['Column1'].astype(str) + ' ' + df['Column2'].astype(str)

df = df.drop(columns=['Column1', 'Column2'])

df.to_csv(output_csv_file, index=False)

print(f"Columns merged and saved to {output_csv_file}")
