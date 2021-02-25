USE vendors;

CREATE TABLE IF NOT EXISTS invoices_dup AS SELECT * FROM
    invoices;
CREATE TABLE IF NOT EXISTS old_invoices AS SELECT * FROM
    invoices
WHERE
    invoice_total - payment_total - credit_total = 0;
    
CREATE TABLE IF NOT EXISTS vendor_balance AS SELECT vendor_id, SUM(invoice_total) AS sum_of_invoices FROM
    invoices
WHERE
    (invoice_total - payment_total - credit_total) <> 0
GROUP BY vendor_id;

DROP TABLE old_invoices;
INSERT INTO invoices_dup 
SELECT * FROM invoices WHERE terms_id = 4;

UPDATE invoices_dup 
SET 
    vendor_id = 125
WHERE
    invoice_id = 1;
    
UPDATE invoices_dup 
SET 
    terms_id = 10
WHERE
    vendor_id = (SELECT 
            vendor_id
        FROM
            vendors
        WHERE
            vendor_name = 'Pacific Bell');
	
DELETE FROM invoices_dup
WHERE vendor_id = (SELECT vendor_id FROM vendors WHERE vendor_state = 'WI');

# LABS
/* Insert this row into the terms table:
terms_id : 6, terms_description: Net due 120 days, terms_due_days: 120. */
INSERT INTO terms(terms_description, terms_due_days) 
VALUES ('Net due 120 days', 120);

/* Update the row you just added by changing the terms_description to Net due 125 days and the 
terms_due_days to 125. */
UPDATE terms 
SET 
    terms_description = 'Net due 125 days',
    terms_due_days = 125
WHERE
    terms_due_days = 120;

/* Delete the row from the terms table. */
DELETE FROM terms 
WHERE
    terms_due_days = 125;

/* insert this row into the invoices table. invoice_id: autoincemented, vendor_id: 32, 
invoice_number: AX-014-027, invoice_date: 8/1/2014, invoice_total: $434.58, payment_total: $0.00,
credit_total: $0.00, terms_id: 2, invoice_due_date: 8/31/2014, payment_date: null. */
INSERT INTO invoices VALUES(default ,32, 'AX-014-027','2014-08-01', '434.58', '0.00', '0.00', 2, '2014-08-31', null);

/*Write an INSERT statement that adds this row to the Categories table: category_name: Brass
Code the INSERT statement so MySQL automatically generates the category_id column. */
USE my_guitar_shop;
INSERT INTO categories VALUES(default, 'Brass');

/*Write an UPDATE statement that modifies the drums category in the Categories table. This 
statement should change the category_name column to “Woodwinds”, and it should use the 
category_id to identify the row. */ 
UPDATE categories 
SET 
    category_name = 'Woodwinds'
WHERE
    category_id = 3;
    
/*Write a DELETE statement that deletes the Keyboards category in the Categories table. */
DELETE FROM categories 
WHERE
    category_id = 4;
    
/* Write an UPDATE statement that modifies the 'Fender Stratocaster' product. This statement 
should change the discount_percent column from 30% to 35%. */
UPDATE products 
SET 
    discount_percent = '35.00'
WHERE
    product_name = 'Fender Stratocaster';
    
/* Write an UPDATE statement that modifies the Customers table. Change the first_name column to
“Al” for the customer with an email address of 'allan.sherwood@yahoo.com'. */
UPDATE customers 
SET 
    first_name = 'Al'
WHERE
    email_address = 'allan.sherwood@yahoo.com';
    
DROP TABLE invoices_dup;