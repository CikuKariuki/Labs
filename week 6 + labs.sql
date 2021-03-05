# AGGREGATE FUNCTIONS
USE vendors;

SELECT 
    COUNT(*) AS number_of_invoices,
    SUM(invoice_total - payment_total - credit_total) AS total_due
FROM
    invoices
WHERE
    invoice_total - payment_total - credit_total > 0;

SELECT 
    'After 1/1/2014' AS selection_date,
    COUNT(*) AS number_of_invoices,
    ROUND(AVG(invoice_total), 2) AS avg_invoice_amt
FROM
    invoices
WHERE
    invoice_date > '2014-01-014';
    
# WITH ROLLUP
-- includes a final summary row
SELECT 
    vendor_id,
    COUNT(*) AS invoice_count,
    SUM(invoice_total) AS invoice_total
FROM
    invoices
GROUP BY vendor_id WITH ROLLUP;

-- includes a summary row for each grouping level
SELECT 
    vendor_state, vendor_city, COUNT(*) AS qty_vendors
FROM
    vendors
WHERE
    vendor_state IN ('IA' , 'NJ')
GROUP BY vendor_state , vendor_city WITH ROLLUP
ORDER BY vendor_state DESC , vendor_city DESC;

    
# LABS
/* Write a select statement that returms one row for each vendor in the Invoices table that 
contains these columns: vendor_id from the vendors table and sum of the invoice_total from the 
invoices table. */
SELECT 
    v.vendor_id, SUM(invoice_total)
FROM
    vendors v
        JOIN
    invoices i ON v.vendor_id = i.vendor_id
GROUP BY vendor_id
ORDER BY vendor_id;

/* Write a select statement that returns one row for each vendor that contains these columns: 
vendor_name from vendors table, sum of the payment_total from the invoices table. */
SELECT 
    vendor_name, SUM(payment_total)
FROM
    vendors v
        JOIN
    invoices i ON v.vendor_id = i.vendor_id
GROUP BY vendor_name
ORDER BY payment_total DESC;

/* Write a select statement that returns one row for each vendor that contains these columns: vendor_name
from the vendors table, count of invoices for each vendor, sum of the invoice_total for each vendor. */
SELECT 
    vendor_name,
    COUNT(invoice_id) AS num_of_invoices,
    SUM(invoice_total)
FROM
    vendors v
        JOIN
    invoices i ON v.vendor_id = i.vendor_id
GROUP BY vendor_name
ORDER BY num_of_invoices DESC;

/* Extract the following information: the account_description, the count of items in the invoice_line_items
table that have the same account number, the sum of the line_item_amount columns in the invoice_line_items
table that have the same account number. Return only those whose count of line items is > 1. Group the 
result set by account description and sort according to sum of line items starting with the highest */
SELECT 
    account_description,
    COUNT(li.account_number) AS account_number,
    SUM(line_item_amount) AS line_item_amount
FROM
    general_ledger_accounts gl
        JOIN
    invoice_line_items li ON gl.account_number = li.account_number
GROUP BY account_description
HAVING COUNT(li.account_number) > 1
ORDER BY line_item_amount DESC;

/* Modify the solution to the above question so it only returns invoices dated in the second quarter of
2018(April 1 - June 30) This should still return 10 rows with different line item counts for each 
vendor. Join to the invoices table to code a search condition based on ivoice date. */
SELECT 
    account_description,
    invoice_date,
    COUNT(li.account_number) AS account_number,
    SUM(line_item_amount) AS line_item_amount
FROM
    general_ledger_accounts gl
        JOIN
    invoice_line_items li ON gl.account_number = li.account_number
        JOIN
    invoices i ON li.invoice_id = i.invoice_id
WHERE
    invoice_date BETWEEN '2018-04-01' AND '2018-06-30'
GROUP BY account_description
HAVING COUNT(li.account_number) > 1
ORDER BY line_item_amount DESC;

/* What is the total amount invoiced for each general ledger account number? Return these columns: account 
number from the invoice line items table, the sum of the line item amounts from the invoice line items 
table. Use the with rollup operator to include rows that give the grand total. */
SELECT 
    gl.account_number, SUM(line_item_amount) AS total_amount
FROM
    invoice_line_items li
        JOIN
    general_ledger_accounts gl ON li.account_number = gl.account_number
GROUP BY gl.account_number WITH ROLLUP
ORDER BY total_amount;

/* Which vendors are being paid from more than one account? Return these columns: vendor_name and count of 
distinct general ledger accounts that apply to that vendor's invoices. This should only return 2 rows. */
SELECT 
    vendor_name,
    COUNT(DISTINCT gl.account_number) AS num_of_accounts
FROM
    vendors v
        JOIN
    invoices i USING (vendor_id)
        JOIN
    invoice_line_items li USING (invoice_id)
        JOIN
    general_ledger_accounts gl USING (account_number)
GROUP BY vendor_name
HAVING COUNT(DISTINCT gl.account_number) > 1;
