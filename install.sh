source venv/bin/activate;
pip3 install -r requirements.txt;
pre-commit install;
python3 export_db_csv.py;