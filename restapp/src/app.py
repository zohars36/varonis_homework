import utils, logger, json, os, traceback
from os.path import join, dirname
from dotenv import load_dotenv
from flask import Flask, request, jsonify
from urllib.parse import urlparse, parse_qs
from datetime import datetime

#load local variables
dotenv_path = join(dirname(__file__), '.env')
load_dotenv(dotenv_path)

conn_string = os.environ.get("AZURE_TABLE_CONN_STRING")
log_table = logger.getTableClient(conn_string, "restLogs")

#load rest data file
rest_data = utils.read_json_file('./data/rest_data.json')
data = rest_data['resturants']        

app = Flask(__name__)

@app.route('/api/rest', methods=['POST'])
def show_rest():
    try:
        payload = request.get_json()
        style = payload.get('style')
        vegetarian = payload.get('vegetarian')
        open_hour = payload.get('open_hour')
        does_deliveries = payload.get('does_deliveries')        
        filtered_data = []

        if open_hour == "now":
            now = datetime.now()
            open_hour = now.hour
        
        for record in data:
            if record['style'] == style and record['vegetarian'] == vegetarian and record['does_deliveries'] == does_deliveries:
                if int(open_hour) >= int(record['openHour']) and int(open_hour) < int(record['closeHour']):
                    filtered_data.append(record)
        
        logger.log(log_table, json.dumps(payload), json.dumps(filtered_data))
        return jsonify(filtered_data), 200 
    
    except Exception as ex:
        print(ex)
        #traceback.print_exc()

if __name__ == '__main__':
    app.run(port=8000, debug=True)
