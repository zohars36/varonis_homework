import json, os, pathlib

def read_json_file(file_path):    
    file_path = os.path.join(pathlib.Path(__file__).parent.absolute(), file_path)
    with open(file_path, 'r') as file:
        data = json.load(file)        
    return data

