# Data catalog for gold layer

The gold layer consists of dimension tables and fact tables for business specific metrics modelled in a star schema to support analytical and reporting use cases.

### 1. gold.dim_customers
- Purpose : contains customer details such as demographic and geographic details.
- Columns
  | Column name | Data type | Description|
  |----|-----|-----|
  | customer_key| INT | Surrogate key. Unique identifier for each customer record.|
  |customer_id| INT | Unique numerical identifier assigned to each customer.|
  |customer_number| VARCHAR(50) | Alphanumeric identifier representing the customer, used for tracking and referencing.|
  |first_name|VARCHAR(50)| Customer's first name.|
  |last_name | VARCHAR (50)| Customer's last name.|
  |country|VARCHAR(50)| Customer's country of residence.|
  |marital_status| VARCHAR(50)| Marital status such as 'Married','Single'.|
  |gender| VARCHAR(50)| Gender such as 'Male','Female' and 'n/a'.|
  |birthdate| DATE|Customer's date of birth as YYYY-MM-DD.|
  |create_date|DATE|The date and time when customer record was created in the crm system.|

### 2. gold.dim_products
- Purpose : contains information about the products and their attributes.
- Columns :
  
  
  
