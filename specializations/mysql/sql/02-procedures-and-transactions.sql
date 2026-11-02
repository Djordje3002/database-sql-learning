-- Stored procedure syntax / Sintaksa procedure. Run with mysql client / Pokreni kroz mysql klijent.

DELIMITER //

CREATE PROCEDURE learning_mark_order_paid(
  IN p_order_id BIGINT UNSIGNED,
  IN p_payment_reference VARCHAR(200)
)
BEGIN
  IF p_payment_reference IS NULL OR CHAR_LENGTH(TRIM(p_payment_reference)) = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment reference is required';
  END IF;

  UPDATE learning_orders
  SET status = 'paid'
  WHERE order_id = p_order_id
    AND status = 'new';

  IF ROW_COUNT() <> 1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order is missing or not new';
  END IF;
END //

DELIMITER ;

START TRANSACTION;
CALL learning_mark_order_paid(1, 'payment-demo-001');
SELECT order_id, status FROM learning_orders WHERE order_id = 1;
ROLLBACK;

-- Keep the transaction boundary in the caller / Granicu transakcije kontroliše pozivalac.
