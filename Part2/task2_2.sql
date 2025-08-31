

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

SELECT DISTINCT user_id
FROM (
    SELECT 
        t.user_id,
        t.purchase_date,
        t.refunded,
        @row_num := IF(@prev_user = t.user_id, @row_num + 1, 1) AS transaction_number,
        @prev_user := t.user_id
    FROM file3 t
    CROSS JOIN (SELECT @row_num := 0, @prev_user := NULL) vars
    ORDER BY t.user_id, t.purchase_date
) ranked
WHERE (transaction_number = 1 AND refunded = 'FALSE')
   OR (transaction_number = 2 AND refunded = 'TRUE')
GROUP BY user_id
HAVING SUM(transaction_number = 1 AND refunded = 'FALSE') > 0
   AND SUM(transaction_number = 2 AND refunded = 'TRUE') > 0  COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
