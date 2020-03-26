DELIMITER $$
	CREATE PROCEDURE get_inovoices_with_balance()
	BEGIN
		SELECT 
			invoice_id,
            invoice_total-payment_total AS balance
		FROM invoices
        WHERE (invoice_total-payment_total)>0;
	END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS get_inovoices_with_balance;
DELIMITER $$
	CREATE PROCEDURE get_inovoices_with_balance()
	BEGIN
		SELECT *
		FROM invoices_with_balance
        WHERE balance>0;
	END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS get_clients_with_state;
DELIMITER $$
	CREATE PROCEDURE get_clients_with_state
    (
		state CHAR(2)
    )
    BEGIN
		SELECT *
        FROM clients c
        WHERE c.state = state;
	END$$
DELIMITER ;