import uuid
from azure.data.tables import TableServiceClient
from datetime import datetime

def getTableClient(conn_string, table_name):
    print(conn_string)
    table_service_client = TableServiceClient.from_connection_string(conn_str=conn_string)
    print(table_service_client)
    table_client = table_service_client.get_table_client(table_name=table_name)
    return table_client

    
def log(table_client, request, response):
    APP_NAME = 'RestApp'
    UUID = str(uuid.uuid4())

    my_entity = {
        'PartitionKey': APP_NAME,
        'RowKey': UUID,
        'request': request,
        'response': response
    }

    entity = table_client.create_entity(entity=my_entity)