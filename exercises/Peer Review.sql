/*
Question 1
List the top 5 countries for the average 'creditLimit', make sure to only consider the countries that have a sales.
Get the 'avergageCredit' per 'country' to understand if there could be potential to expand the business with the country's clients.
*/

DROP VIEW IF EXISTS topAvg_creditLimit;
CREATE VIEW topAvg_creditLimit AS
	SELECT country
		FROM customers
		WHERE salesRepEmployeeNumber IS NOT NULL
		GROUP BY country
		ORDER BY AVG(creditLimit) DESC LIMIT 5;

SELECT country, count(customerNumber) AS numberOfCustomers, FORMAT(AVG(creditLimit),2) AS avgCreditLimit, FORMAT(count(customerNumber)*AVG(creditLimit),2) AS potentialCredit
	FROM customers
    WHERE country IN (SELECT country FROM topAvg_creditLimit)
		AND salesRepEmployeeNumber IS NOT NULL
	GROUP BY country;

/*
Question 2
From out top potential countries we want to see the current status, lets find out the total number of orders and sales to compare with our potential.
*/

SELECT country, COUNT(DISTINCT(O.orderNumber)) AS numberOfOrders, FORMAT(SUM(quantityOrdered * priceEach),2) AS totalSales
	FROM customers C RIGHT JOIN 
		 orders O ON
         C.customerNumber = O.customerNumber LEFT JOIN
			orderdetails D ON
            O.orderNumber = D.orderNumber
	WHERE country IN (SELECT country FROM topavg_creditlimit)
    GROUP BY country;

/*
Question 3
Get the list of employee's that are in charge of Spain check the sales for each of the employees and find out if there are any high performers.
*/

SELECT employeeNumber, lastName, firstName, FORMAT(SUM(quantityOrdered * priceEach),2) as totalSales
	FROM employees E JOIN
		 customers C ON
         E.employeeNumber = C.salesRepEmployeeNumber JOIN
			orders O ON
            C.customerNumber = O.customerNumber JOIN
				orderdetails D ON
                O.orderNumber = D.orderNumber
	WHERE country = 'Spain'
    GROUP BY employeeNumber, lastName, firstName;
    