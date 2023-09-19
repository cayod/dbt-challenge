import psycopg2
from dotenv import load_dotenv
import os
import pandas as pd


tables_name = ['person.address', 'person.countryregion', 'sales.creditcard', 'sales.customer', 'person.person', 'sales.salesorderdetail', 'sales.salesorderheader', 'person.stateprovince', 'production.product', 'sales.salesorderheadersalesreason', 'sales.salesreason']

# Load environment variables
load_dotenv()

def init_db():
    cnx = psycopg2.connect(host=os.getenv('DB_HOST'),
                            dbname=os.getenv('DB_NAME'),
                            user=os.getenv('DB_USER'),
                            password=os.getenv('DB_PASS'),
                            port=os.getenv('DB_PORT'))
    
    return cnx

def fetch_table_data(table_name):

    cnx = init_db()

    cursor = cnx.cursor()
    cursor.execute(f'select * from {table_name}')

    header = [row[0] for row in cursor.description]

    rows = cursor.fetchall()

    # Closing connection
    cnx.close()

    return header, rows


def export(table_name):
    header, rows = fetch_table_data(table_name)

    # Create csv file
    table = table_name.split('.')[1]
    f = open(f'seeds/{table}.csv', 'w')

    # Write header
    f.write(','.join(header) + '\n')

    for row in rows:
        f.write(','.join(str(r) for r in row) + '\n')

    f.close()
    print(str(len(rows)) + ' rows written successfully to ' + f.name)


# Delete , from csv file
def clean_csv(table):
    with open(f'seeds/{table}.csv', 'r') as f:
        lines = f.readlines()

    with open(f'seeds/{table}.csv', 'w') as f:
        for l in lines:
            f.write(l.replace(", ", " "))

    with open(f'seeds/{table}.csv', 'r') as f:
        lines = f.readlines()

    if table == 'address':
        with open(f'seeds/{table}.csv', 'w') as f:
            for line in lines:
                f.write(line.replace(",,", ","))
    
    if table == 'person':
        df = pd.read_csv(f'seeds/{table}.csv')
        df = df.replace('"', "'", regex=True)
        df.to_csv(f'seeds/{table}.csv', index=False)



# for table in tables_name:
export('person.address')
clean_csv('person.address'.split('.')[1])
