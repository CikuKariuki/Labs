# SUBQUERIES
USE vendors;

SELECT 
    invoice_number, invoice_date, invoice_total
FROM
    invoices
WHERE
    invoice_total > (SELECT 
            AVG(invoice_total)
        FROM
            invoices)
ORDER BY invoice_total;

SELECT 
    invoice_number, invoice_date, invoice_total
FROM
    invoices
WHERE
    vendor_id IN (SELECT 
            vendor_id
        FROM
            vendors
        WHERE
            vendor_state = 'CA')
ORDER BY invoice_date;
 
SELECT 
    vendor_id, vendor_name, vendor_state
FROM
    vendors
WHERE
    vendor_id NOT IN (SELECT DISTINCT
            vendor_id
        FROM
            invoices)
ORDER BY vendor_id;

SELECT 
    invoice_number,
    invoice_date,
    invoice_total - payment_total - credit_total AS balance_due
FROM
    invoices
WHERE
    invoice_total - payment_total - credit_total > 0
        AND invoice_total - payment_total - credit_total < (SELECT 
            AVG(invoice_total - payment_total - credit_total)
        FROM
            invoices
        WHERE
            invoice_total - payment_total - credit_total > 0)
ORDER BY invoice_total DESC;

-- get invoices larger than the largest invoice for vendor 34
-- the all keyword will evaluate to true if the value returned is greater than the maximum returned by the subquery
SELECT 
    vendor_name, invoice_number, invoice_total
FROM
    invoices i
        JOIN
    vendors v ON i.vendor_id = v.vendor_id
WHERE
    invoice_total > ALL (SELECT 
            invoice_total
        FROM
            invoices
        WHERE
            vendor_id = 34)
ORDER BY invoice_total;

# ANY/SOME
-- get invoices smaller than the largest invoice for vendor 115
SELECT 
    vendor_name, invoice_total, invoice_number
FROM
    vendors v
        JOIN
    invoices i ON v.vendor_id = i.vendor_id
WHERE
    invoice_total < ANY (SELECT 
            invoice_total
        FROM
            invoices
        WHERE
            vendor_id = 115);

# get each invoice amount that's higher than the vendor's average invoice amount
SELECT 
    vendor_id, invoice_number, invoice_total
FROM
    invoices i
WHERE
    invoice_total > (SELECT 
            AVG(invoice_total)
        FROM
            invoices
        WHERE
            vendor_id = i.vendor_id)
ORDER BY vendor_id , invoice_total;
