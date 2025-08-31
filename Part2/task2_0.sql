
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

SELECT
    (COUNT(T2.user_id) * 1.0) / COUNT(T1.user_id) AS conversion_rate
FROM
    (
        SELECT
            user_id
        FROM
            product_analyst
        WHERE
            product_id = 'tenwords_1w_9.99_offer'
            AND refunded = 'False'
        GROUP BY
            user_id
    ) AS T1
LEFT JOIN
    (
        SELECT
            DISTINCT T2_sub.user_id
        FROM
            product_analyst AS T2_sub
        JOIN
            (
                SELECT
                    user_id,
                    MIN(purchase_date) AS first_purchase_date
                FROM
                    product_analyst
                WHERE
                    product_id = 'tenwords_1w_9.99_offer'
                    AND refunded = 'False'
                GROUP BY
                    user_id
            ) AS T1_sub
        ON T2_sub.user_id = T1_sub.user_id
        WHERE
            T2_sub.purchase_date > T1_sub.first_purchase_date
            AND T2_sub.product_id = 'tenwords_1w_9.99_offer'
            AND T2_sub.refunded = 'False'
    ) AS T2
ON T1.user_id = T2.user_id  COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
