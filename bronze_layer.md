## Bronze layer
It is a first layer and stores raw data as-is from sources. Data is ingested from CSV files into PostgreSQL database.

<b>Analyze source system</b> : As specified, focus is only the latest dataset. Historization is not required. There are 6 csv files coming from CRM and ERP systems. All csv files are fully loaded (no batch loading).
