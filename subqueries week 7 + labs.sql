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

-- page 192

