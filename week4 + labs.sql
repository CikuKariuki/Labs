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