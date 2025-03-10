# Data catalog for gold layer

The gold layer consists of dimension tables and fact tables for business specific metrics modelled in a star schema to support analytical and reporting use cases.

### 1. gold.dim_customers
- Purpose : contains customer details such as demographic and geographic details.
- Columns:
  | Column name | Data type | Description|
  |----|-----|-----|
  | customer_key| INT | Surrogate key. A unique identifier for each customer record.|
  |customer_id| INT | A unique numerical identifier assigned to each customer.|
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
  | Column name | Data type | Description|
  |----|-----|-----|
  |product_key| INT | Surrogate key. Unique identifier for each product record in the product dimension table|
  |product_id|INT|Unique identifier assigned for the product for internal tracking and referencing.|
  |product_number| VARCHAR(50)| An alphanumeric code repsenting product often used for categorization or inventory|
  |product_name|VARCHAR(50)| Product description on key details such as type, color and size.|
  |category_id|VARCHAR(50)| A unique identifoer for the product's category|
  |category|VARCHAR(50)| Broader classification of product such as Bokes, Clothing etc|
  |subcategory|VARCHAR(50)|A more detailed classification of the product within the category|
  |maintenance_required|VARCHAR(50)| Indicated whether the product requires maintenance e.g. 'Yes','No'|
  |cost|INT| Price of the product|
  |product_line|VARCHAR(50)| The specific product line to which product belongs such as 'Road','Mountain'.|
  |start_date|DATE| The date when the product was available for sale|
  
  ### 3. gold.fact_sales
  - Purpose : Stores transactional sales record.
  - Columns:
  
  | Column name | Data type | Description|
  |----|-----|-----|
  |order_number| VARCHAR(50)| A identifier for each sales order.|
  |product_key|INT| Surrogate key linking the order to the product dimension table.|
  |customer_key|INT| Surrogate key linking the order to the customer dimension table.|
  |order_date|DATE|The date when the order was placed.|
  |shipping_date|DATE|The date when order was shipped to customer.|
  |due_date|DATE| The date when order payment was due.|
  |sales_amount| INT|The total value.|
  |quantity|INT| The number of units of the product ordered.|
  |price|INT|The price per unit of the product.|
  
