from flask import Flask, jsonify
import requests
import os

app = Flask(__name__)

# Usa variable de entorno si existe
DRUID_URL = os.getenv("DRUID_URL", "http://localhost:8888")

@app.route('/', methods=['GET'])
def hello_world():
    return {"message": "hello world"}

@app.route('/query', methods=['GET'])
def query_druid():
    try:
        query = {
            "query": 'SELECT COUNT(*) AS "count" FROM checkins'
        }
        response = requests.post(f"{DRUID_URL}/druid/v2/sql", json=query)
        response.raise_for_status()  # Para que errores HTTP se capturen
        return jsonify(response.json())
    except requests.exceptions.RequestException as e:
        return jsonify({"error": str(e)}), 500
