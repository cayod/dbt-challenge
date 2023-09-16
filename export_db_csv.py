import psycopg2
from dotenv import load_dotenv
import os
from psycopg2 import sql

QUERY_TABLES = """
        SELECT n.nspname AS schema_name, c.relname AS table_name
        FROM pg_namespace n
        LEFT JOIN pg_class c ON n.oid = c.relnamespace
        WHERE n.nspname NOT LIKE 'pg_%'
        AND n.nspname != 'information_schema'
        AND c.relkind = 'r'
        ORDER BY schema_name, table_name
    """

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
    f = open(f'seeds/{table_name}.csv', 'w')

    # Write header
    f.write(','.join(header) + '\n')

    for row in rows:
        f.write(','.join(str(r) for r in row) + '\n')

    f.close()
    print(str(len(rows)) + ' rows written successfully to ' + f.name)

def get_tables(query):

    conn = init_db()

    # Create a cursor object to interact with the database
    cur = conn.cursor()

    # SQL query to retrieve schema names and table names
    query = sql.SQL(query)

    # Execute the query
    cur.execute(query)

    # Fetch all the results
    results = cur.fetchall()

    # Close the cursor and database connection
    cur.close()
    conn.close()

    data = []
    for row in results:
        schema_name, table_name = row
        data.append(f'{schema_name}.{table_name}')

    return data



data = get_tables(QUERY_TABLES)

for table in data:
    export(table)
