use vendors;

# inner join two aliases
SELECT 
    invoice_number,
    vendor_name,
    invoice_due_date,
    invoice_total - payment_total - credit_total AS balance_due
FROM
    vendors v
        JOIN
    invoices i ON v.vendor_id = i.vendor_id
WHERE
    invoice_total - payment_total - credit_total > 0
ORDER BY invoice_due_date;

# inner join one alias
SELECT 
    invoice_number, line_item_amount, line_item_description
FROM
    invoices
        JOIN
    invoice_line_items line_items ON invoices.invoice_id = line_items.invoice_id
WHERE
    account_number = 540
ORDER BY invoice_date;

# Two databases, one table
SELECT 
    vendor_name,
    customer_last_name,
    customer_first_name,
    vendor_state AS state,
    vendor_city AS city
FROM
    vendors v
        JOIN
    company.customers c ON v.vendor_zip_code = c.customer_zip
ORDER BY state , city;

# inner join, 2 conditions
USE company;
SELECT 
    customer_first_name, customer_last_name
FROM
    customers c
        JOIN
    employees e ON c.customer_first_name = e.first_name
        AND c.customer_last_name = e.last_name;

# Self Joins
USE vendors;
SELECT DISTINCT
    v1.vendor_name, v1.vendor_city, v1.vendor_state
FROM
    vendors v1
        JOIN
    vendors v2 ON v1.vendor_city = v2.vendor_city
        AND v1.vendor_state = v2.vendor_state
        AND v1.vendor_name <> v2.vendor_name
ORDER BY v1.vendor_state , v1.vendor_city;

# Joining multiple tables 
SELECT 
    vendor_name,
    invoice_number,
    invoice_date,
    line_item_amount,
    account_description
FROM
    vendors v
        JOIN
    invoices i ON v.vendor_id = i.vendor_id
        JOIN
    invoice_line_items li ON i.invoice_id = li.invoice_id
        JOIN
    general_ledger_accounts gl ON li.account_number = gl.account_number
WHERE
    invoice_total - payment_total - credit_total > 0
ORDER BY vendor_name , line_item_amount DESC;

# OUTER JOINS
-- Left Join
SELECT 
    vendor_name, invoice_number, invoice_total
FROM
    vendors v
        LEFT JOIN
    invoices i ON v.vendor_id = i.vendor_id
ORDER BY vendor_name;

-- Right Join
USE company;
SELECT 
    department_name, e.department_number, last_name
FROM
    departments d
        RIGHT JOIN
    employees e ON d.department_number = e.department_number
ORDER BY department_name;

-- Joining multiple tables using outer joins
SELECT 
    department_name, last_name, project_number
FROM
    departments d
        LEFT JOIN
    employees e ON d.department_number = e.department_number
        LEFT JOIN
    projects p ON e.employee_id = p.employee_id
ORDER BY department_name , last_name;

# Inner + outer join
SELECT 
    department_name, last_name, project_number
FROM
    departments d
        JOIN
    employees e ON e.department_number = d.department_number
        LEFT JOIN
    projects p ON e.employee_id = p.employee_id
ORDER BY department_name;

# Joins with 'USING' keyword.
USE vendors;
SELECT 
    invoice_number, vendor_name
FROM
    vendors
        JOIN
    invoices USING (vendor_id)
ORDER BY invoice_number;

# Natural Join will join on common rows. 
SELECT 
    invoice_number, vendor_name
FROM
    vendors
        NATURAL JOIN
    invoices
ORDER BY invoice_number;

# Cross join
SELECT 
    invoice_number,
    invoice_date,
    vendor_name,
    vendor_phone,
    terms_description
FROM
    invoices
        CROSS JOIN
    vendors t
        CROSS JOIN
    terms
ORDER BY invoice_date;

# UNION
USE company;

SELECT 
    'Active' AS source,
    invoice_number,
    invoice_total,
    invoice_date
FROM
    active_invoices
WHERE
    invoice_date > '2014-06-01' 
UNION SELECT 
    'Paid' AS source,
    invoice_number,
    invoice_total,
    invoice_date
FROM
    paid_invoices
WHERE
    invoice_date > '2014-06-01'
ORDER BY invoice_date;

# Union with rows from the same table
USE vendors;

SELECT 
    'Active' AS source,
    invoice_number,
    invoice_total,
    invoice_date
FROM
    invoices
WHERE
    invoice_total - payment_total - credit_total > 0 
UNION SELECT 
    'Paid' AS source,
    invoice_number,
    invoice_total,
    invoice_date
FROM
    invoices
WHERE
    invoice_total - payment_total - credit_total <= 0
ORDER BY invoice_date;

SELECT 
    invoice_number,
    vendor_name,
    '33% Payment' AS payment_type,
    invoice_total AS total,
    invoice_total * 0.33 AS payment
FROM
    invoices i
        JOIN
    vendors v ON i.vendor_id = v.vendor_id
WHERE
    invoice_total > 10000 
UNION SELECT 
    invoice_number,
    vendor_name,
    '50% Payment' AS payment_type,
    invoice_total AS total,
    invoice_total * 0.5 AS payment
FROM
    invoices i
        JOIN
    vendors v ON i.vendor_id = v.vendor_id
WHERE
    invoice_total BETWEEN 500 AND 10000 
UNION SELECT 
    invoice_number,
    vendor_name,
    'Full amount' AS payment_type,
    invoice_total AS total,
    invoice_total AS payment
FROM
    invoices i
        JOIN
    vendors v USING (vendor_id)
WHERE
    invoice_total < 500
ORDER BY invoice_number;

# Full outer join using UNION
SELECT 
    last_name,
    first_name,
    invoice_total - payment_total - credit_total AS owes,
    invoice_due_date
FROM
    vendor_contacts vc
        LEFT JOIN
    invoices i ON vc.vendor_id = i.vendor_id 
UNION SELECT 
    last_name,
    first_name,
    invoice_total - payment_total - credit_total AS owes,
    invoice_due_date
FROM
    vendor_contacts vc
        RIGHT JOIN
    invoices i ON vc.vendor_id - i.vendor_id
ORDER BY invoice_due_date DESC;

# LABS
/* Write a select statement that returns all columns from the vendors table inner joined
with all columns from the invoices table. This should return 114 rows. */
SELECT 
    *
FROM
    vendors
        JOIN
    invoices USING (vendor_id);
    
/* Write a select statement that returns these four columns: vendor_name, invoice_number, 
invoice_date, balance_due (invoice_total - payment_total - credit_total). Return only (11)
rows with a non-zero balance. Sort the results by vendor_name. */
SELECT 
    vendor_name,
    invoice_number,
    invoice_date,
    invoice_total - payment_total - credit_total AS balance_due
FROM
    vendors v
        JOIN
    invoices i ON v.vendor_id = i.vendor_id
WHERE
    invoice_total - payment_total - credit_total > 0
ORDER BY vendor_name;

/* Write a select statement that returns these three columns: vendor_name, default_account,
account_description. Return 1 row for each vendor(should be 122 rows). Sort by account_description, 
then vendor_name. */
SELECT 
    vendor_name, default_account_number, account_description
FROM
    vendors v
        JOIN
    general_ledger_accounts gl ON v.default_account_number = gl.account_number
ORDER BY account_description;

/* Write a select statement that returns these 5 columns: vendor_name, invoice_date, 
invoice_number, invoice_sequence, line_item_amount. This should return 118 rows. Sort the 
result by vendor_name, invoice_date, invoice_number and invoice_sequence. */
SELECT 
    vendor_name,
    invoice_date,
    invoice_number,
    invoice_sequence,
    line_item_amount
FROM
    vendors v
        JOIN
    invoices i ON v.vendor_id = i.vendor_id
        JOIN
    invoice_line_items li ON i.invoice_id = li.invoice_id
ORDER BY vendor_name , invoice_date , invoice_number , invoice_sequence;

/* Write a select statement that returns these 3 columns: vendor_id, vendor_name, 
contact_name( concat vendors' first and last names). Return one row for each vendor whose 
contact has the same last name. Sort the result by last names. */
SELECT 
    v.vendor_id,
    vendor_name,
    CONCAT(vc1.first_name, ' ', vc1.last_name) AS contact_name
FROM
    vendors v
        JOIN
    vendor_contacts vc1 ON v.vendor_id = vc1.vendor_id
        JOIN
    vendor_contacts vc2 ON vc1.vendor_id = vc2.vendor_id
        AND vc1.last_name <> vc2.last_name
ORDER BY vc1.last_name;

/* Write a select statement that returns these 3 columns: account_number, account_description,
invoice_id. Return one row for each account number that has never been used. This should return
54 rows. Remove the invoice_id column from the select clause. sort the result by account_number. */
SELECT 
    gl.account_number, account_description, invoice_id
FROM
    general_ledger_accounts gl
        LEFT JOIN
    invoice_line_items li ON gl.account_number = li.account_number
WHERE
    li.invoice_id IS NULL 
UNION SELECT 
    gl.account_number, account_description, invoice_id
FROM
    general_ledger_accounts gl
        RIGHT JOIN
    invoice_line_items li ON gl.account_number = li.account_number
WHERE
    li.invoice_id IS NULL
ORDER BY account_number;

/* Use the union operator to generate a result set consisting of two columns from the vendors table:
vendor_name and vendor_state. If the vendor is in Carlifonia the vendor state should be 'CA': 
otherwise the vendor_state value should be "outside CA'. Sort the result by vendor_name. */
SELECT 
    vendor_name, 'CA' AS vendor_state
FROM
    vendors
WHERE
    vendor_state = 'CA' 
UNION SELECT 
    vendor_name, 'Outside CA' AS vendor_state
FROM
    vendors
WHERE
    vendor_state <> 'CA'
ORDER BY vendor_name;

/* Write a SELECT statement that joins the Customers table to the Addresses table and returns 
these columns: first_name, last_name, line1, city, state, zip_code. Return one row for each 
address for the customer with an email address of allan.sherwood@yahoo.com Sort the result set 
by the zip_code column in ascending sequence. */
USE my_guitar_shop;

SELECT 
    first_name, last_name, line1, city, state, zip_code
FROM
    customers c
        JOIN
    addresses a ON c.customer_id = a.customer_id
WHERE
    c.email_address = 'allan.sherwood@yahoo.com'
ORDER BY zip_code;

/* Write a SELECT statement that joins the Customers table to the Addresses table and returns these 
columns: first_name, last_name, line1, city, state, zip_code. Return one row for each customer, but 
only return addresses that are the shipping address for a customer. Sort the result set by the 
zip_code column in ascending sequence. */
SELECT 
    first_name, last_name, line1, city, state, zip_code
FROM
    customers c
        JOIN
    addresses a ON c.customer_id = a.customer_id
WHERE
    c.shipping_address_id = a.address_id
ORDER BY zip_code;

/* Write a SELECT statement that joins the Customers, Orders, Order_Items, and Products tables. This 
statement should return these columns: last_name, first_name, order_date, product_name, item_price, 
discount_amount, and quantity. Use aliases for the tables. Sort the final result set by the last_name, 
order_date, and product_name columns. */
SELECT 
    last_name,
    first_name,
    order_date,
    product_name,
    item_price,
    discount_amount,
    quantity
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
        JOIN
    order_items oi ON o.order_id = oi.order_id
        JOIN
    products p ON oi.product_id = p.product_id
ORDER BY last_name , order_date , product_name;

/* Use the UNION operator to generate a result set consisting of three columns from the Orders 
table: ship_status( A calculated column that contains a value of SHIPPED or NOT SHIPPED), order_id,
order_date If the order has a value in the ship_date column, the ship_status column should 
contain a value of SHIPPED. Otherwise, it should contain a value of NOT SHIPPED. Sort the final 
result set by the order_date column. */
SELECT 
    'Shipped' AS ship_status, order_id, order_date
FROM
    orders
WHERE
    ship_date IS NOT NULL 
UNION SELECT 
    'Not Shipped' AS ship_status, order_id, order_date
FROM
    orders
WHERE
    ship_date IS NULL;
SELECT CURRENT_DATE() - '2022-01-01';

/* Write a SELECT statement that returns the ProductName and ListPrice columns from the Products 
table. Return one row for each product that has the same list price as another product. */
SELECT 
    p1.product_name, p1.list_price
FROM
    products p1
        JOIN
    products p2 ON p1.product_id <> p2.product_id
        AND p1.list_price = p2.list_price
ORDER BY list_price;