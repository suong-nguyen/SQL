/* Project walkthough

	1. KPI's: 
		- Total Loan Applications, MTD Loan Applications, PMTD Loan Applications, 
		- Total Funded Amount, MTD Total Funded Amount, PMTD Total Funded Amount, 
		- Total Amount Received, MTD Total Amount Received, PMTD Total Amount Received, 
		- Average Interest Rate, MTD Average Interest, PMTD Average Interest
		- Avg DTI, MTD Avg DTI, PMTD Avg DTI

	2. Good Loan Issued: Good Loan Percentage, Good Loan Applications, Good Loan Funded Amount, Good Loan Amount Received

	3. Bad Loan Issued: Bad Loan Percentage, Bad Loan Applications, Bad Loan Funded Amount, Bad Loan Amount Received

	4. Loan Status: Loan Status (yearly, MTD)

	5. More details by:
		MONTH: Month, Total Loan Applications, Total Funded Amount, Total Amount Received
		STATE: State, Total Loan Applications, Total Funded Amount, Total Amount Received
		TERM: Term, Total Loan Applications, Total Funded Amount, Total Amount Received
		EMPLOYEE LENGTH: Employee Length, Total Loan Applications, Total Funded Amount, Total Amount Received
		PURPOSE: Purpose, Total Loan Applications, Total Funded Amount, Total Amount Received
		HOME OWNERSHIP: Home Ownership, Total Loan Applications, Total Funded Amount, Total Amount Received

*/


/* 1. KPIs: application, funded amount, received amount */


-- Applications

	SELECT 'Total Loan Applications' AS Metric, COUNT(id) AS Value -- Total Loan Applications
	FROM loandata
	
	UNION ALL
	SELECT 'MTD Loan Applications' AS Metric, COUNT(id) AS Value -- MTD Loan Applications
	FROM loandata
	WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
	
	UNION ALL
	SELECT 'PMTD Loan Applications' AS Metric, COUNT(id) AS Value -- PMTD Loan Applications
	FROM loandata
	WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
	
	UNION ALL
	SELECT 
		'% Change' AS Metric, -- % loan application development of Current month vs. previous month
		((MTD_count - PMTD_count) / PMTD_count) * 100 AS Value 
	FROM 
	(	SELECT COUNT(id) AS MTD_count
		FROM loandata
		WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
	) AS MTD,
	
	(	SELECT COUNT(id) AS PMTD_count
		FROM loandata
		WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
	) AS PMTD;

	



-- Funded Amount

	Select 'Total Funded Amount' as Metric, sum(loan_amount) as value -- total amount received
	from loandata
	
	union all
	Select 'MTD Total Funded Amount' as Metric, sum(loan_amount) as value -- MTD Total Funded Amount
	from loandata
	where MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
	
	Union all
	Select 'PMTD Total Funded Amountt' as Metric, sum(loan_amount) as value -- MTD Total Funded Amount
	from loandata
	where MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

	UNION ALL
	SELECT 
		'% Change' AS Metric, -- % loan amount compared to previous month
		Round(((MTD_sum - PMTD_sum) / PMTD_sum) * 100,2) AS Value 
	FROM 
	(	SELECT sum(loan_amount) AS MTD_sum
		FROM loandata
		WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
	) AS MTD,
	
	(	SELECT sum(loan_amount) AS PMTD_sum
		FROM loandata
		WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
	) AS PMTD;






-- Amount received

	Select 'Total Amount Received' as Metric, sum(total_payment) as value -- Total Amount Received
	from loandata
	
	union all
	Select 'MTD Total Amount Received' as Metric, sum(total_payment) as value -- MTD Total Amount Received
	from loandata
	where MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
	
	Union all
	Select 'PMTD Total Amount Received' as Metric, sum(total_payment) as value -- MTD Total Amount Received
	from loandata
	where MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

	UNION ALL
	SELECT 
		'% Change' AS Metric, -- % loan amount compared to previous month
		Round(((MTD_sum - PMTD_sum) / PMTD_sum) * 100,2) AS Value 
	FROM 
	(	SELECT sum(total_payment) AS MTD_sum
		FROM loandata
		WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
	) AS MTD,
	
	(	SELECT sum(total_payment) AS PMTD_sum
		FROM loandata
		WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
	) AS PMTD;




-- Interest Rate

	Select 'Avg interest rate' as Metric, round(AVG(int_rate) *100,2) as value -- Avg interest rate
	from loandata
	
	union all
	Select 'MTD Avg interest rate' as Metric, round(AVG(int_rate) *100,2) as value -- MTD Avg interest rate
	from loandata
	where MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
	
	Union all
	Select 'PMTD Avg interest rate' as Metric, round(AVG(int_rate) *100,2) as value -- PMTD Avg interest rate
	from loandata
	where MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021



-- DTI

	Select 'Avg dti' as Metric, round(AVG(dti) *100,2) as value -- Avg dti
	from loandata
	
	union all
	Select 'MTD Avg dti' as Metric, round(AVG(dti) *100,2) as value -- MTD dti
	from loandata
	where MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
	
	Union all
	Select 'PMTD Avg dti' as Metric, round(AVG(dti) *100,2) as value -- PMTD dti
	from loandata
	where MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021





/* 2. Good Loan Issued: Good Loan Percentage, Good Loan Applications, Good Loan Funded Amount, Good Loan Amount Received */
	
	--- Good Loan Applications
	Select 
	'Good Loan Applications' as Metric,
	count(id) as Value
	from loandata
	where loan_status = 'Fully Paid' or loan_status ='Current'
	
	
	union all
	-- Good Loan Percentage
	Select 
	'% Good Loan' as Metric,
	 100*count(case when loan_status = 'Fully Paid' or loan_status ='Current' then id end)/count(id) as Value
	 from loandata
		

	union all
	--- Good Loan Funded Amount
	Select
	'Good Loan Funded Amount' as Metric,
	sum(loan_amount) as Value
	from loandata
	where loan_status = 'Fully Paid' or loan_status ='Current'


	union all
	-- Good Loan Amount Received
	Select'Good Loan Amount Received' as Metric,
	sum(total_payment) as Value
	from loandata
	where loan_status = 'Fully Paid' or loan_status ='Current'




/* 3. Bad Loan Issued: Bad Loan Percentage, Bad Loan Applications, Bad Loan Funded Amount, Bad Loan Amount Received */
	
	--- Bad Loan Applications
	Select 
	'Bad Loan Applications' as Metric,
	count(id) as Value
	from loandata
	where loan_status = 'Charged Off' 
	
	
	union all
	-- Bad Loan Percentage
	Select 
	'% Bad Loan' as Metric,
	 100*count(case when loan_status = 'Charged Off' then id end)/count(id) as Value
	 from loandata
		

	union all
	--- Bad Loan Funded Amount
	Select
	'Bad Loan Funded Amount' as Metric,
	sum(loan_amount) as Value
	from loandata
	where loan_status = 'Charged Off' 


	union all
	-- Bad Loan Amount Received
	Select'Bad Loan Amount Received' as Metric,
	sum(total_payment) as Value
	from loandata
	where loan_status = 'Charged Off' 




/*4. Loan Status: Loan Status */

	--- Year overview
	SELECT
		loan_status,
		COUNT(id) AS Application_Count,
		ROUND(COUNT(id) * 100/ SUM(COUNT(id)) OVER(), 2) AS Application_Count_PCT,
		SUM(total_payment) AS Total_Amount_Received,
		ROUND(SUM(total_payment) * 100/ SUM(SUM(total_payment)) OVER(), 2) AS Total_Amount_Received_PCT,
		SUM(loan_amount) AS Total_Funded_Amount,
		ROUND(SUM(loan_amount) * 100/ SUM(SUM(loan_amount)) OVER(), 2) AS Total_Funded_Amount_PCT,
		round(AVG(int_rate * 100),2) AS Interest_Rate,
		round(AVG(dti * 100),2) AS DTI		
	FROM loandata
	GROUP BY loan_status

	

	--- MTD overview

	SELECT 
		loan_status, 
		SUM(total_payment) AS MTD_Total_Amount_Received,
		round((SUM(total_payment) / (SELECT SUM(total_payment) FROM loandata WHERE MONTH(issue_date) = 12)) * 100,1) AS Percentage_of_total,
		SUM(loan_amount) AS MTD_Total_Funded_Amount,
		round((SUM(loan_amount) / (SELECT SUM(loan_amount) FROM loandata WHERE MONTH(issue_date) = 12)) * 100,1) AS Percentage_of_total,
		round(SUM(total_payment) / (SELECT SUM(loan_amount) FROM loandata WHERE MONTH(issue_date) = 12) * 100,1) AS Percentage_Received_of_Funded
	FROM loandata
	WHERE MONTH(issue_date) = 12 
	GROUP BY loan_status



/*5. More detail by: Month, state, term, employee length, purpose, home ownership */


-- MONTH: Month, Total Loan Applications, Total Funded Amount, Total Amount Received

	WITH MonthlyTotals AS 
	(
		SELECT 
			MONTH(issue_date) AS MonthNumber,
			DATENAME(MONTH, issue_date) AS Month, 
			COUNT(id) AS Total_Loan_Applications,
			SUM(loan_amount) AS Total_Funded_Amount,
			SUM(total_payment) AS Total_Amount_Received
		FROM loandata
		GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
	)
	SELECT 
		Month,
		Total_Loan_Applications,
		Total_Funded_Amount,
		Total_Amount_Received,
		CASE 
			WHEN Lag(Total_Funded_Amount) OVER (ORDER BY MonthNumber) = 0 THEN NULL
			ELSE round(((Total_Funded_Amount - Lag(Total_Funded_Amount) OVER (ORDER BY MonthNumber)) / Lag(Total_Funded_Amount) OVER (ORDER BY MonthNumber)) * 100,0) 
		END AS Funded_Amount_Percentage_Increase,
		CASE 
			WHEN Lag(Total_Amount_Received) OVER (ORDER BY MonthNumber) = 0 THEN NULL
			ELSE round(((Total_Amount_Received - Lag(Total_Amount_Received) OVER (ORDER BY MonthNumber)) / Lag(Total_Amount_Received) OVER (ORDER BY MonthNumber)) * 100,0) 
		END AS Amount_Received_Percentage_Increase
	FROM MonthlyTotals
	ORDER BY MonthNumber;



	
--STATE: State, Total Loan Applications, Total Funded Amount, Total Amount Received

	SELECT 
		address_state AS State, 
		COUNT(id) AS Total_Loan_Applications,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Amount_Received,
	FROM loandata
	GROUP BY address_state
	ORDER BY 4



--TERM: Term, Total Loan Applications, Total Funded Amount, Total Amount Received
	SELECT 
		term AS Term, 
		COUNT(id) AS Total_Loan_Applications,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Amount_Received
	FROM loandata
	GROUP BY term
	ORDER BY term



--EMPLOYEE LENGTH: Employee Length, Total Loan Applications, Total Funded Amount, Total Amount Received

	SELECT 
		emp_length AS Employee_Length, 
		COUNT(id) AS Total_Loan_Applications,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Amount_Received,
		round(COUNT(id) * 100 / (Select(COUNT(id)) from loandata),0) AS Total_Loan_Applications_Percentage,
		Round((SUM(loan_amount) / (SELECT SUM(loan_amount) FROM loandata)) * 100,0) AS Percent_of_Total_Funded_Amount,
		Round((SUM(total_payment) / (SELECT SUM(total_payment) FROM loandata)) * 100,0) AS Percent_of_Total_Amount_Received
	FROM loandata
	GROUP BY emp_length
	ORDER BY 2 desc



	
--PURPOSE: Purpose, Total Loan Applications, Total Funded Amount, Total Amount Received

	SELECT 
		purpose AS PURPOSE, 
		COUNT(id) AS Total_Loan_Applications,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Amount_Received,
		round(COUNT(id) * 100 / (Select(COUNT(id)) from loandata),0) AS Total_Loan_Applications_Percentage,
		Round((SUM(loan_amount) / (SELECT SUM(loan_amount) FROM loandata)) * 100,0) AS Percent_of_Total_Funded_Amount,
		Round((SUM(total_payment) / (SELECT SUM(total_payment) FROM loandata)) * 100,0) AS Percent_of_Total_Amount_Received
	FROM loandata
	GROUP BY purpose
	ORDER BY 2 desc





--HOME OWNERSHIP: Home Ownership, Total Loan Applications, Total Funded Amount, Total Amount Received
	SELECT 
		home_ownership AS Home_Ownership, 
		COUNT(id) AS Total_Loan_Applications,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Amount_Received,
		round(COUNT(id) * 100 / (Select(COUNT(id)) from loandata),0) AS Total_Loan_Applications_Percentage,
		Round((SUM(loan_amount) / (SELECT SUM(loan_amount) FROM loandata)) * 100,0) AS Percent_of_Total_Funded_Amount,
		Round((SUM(total_payment) / (SELECT SUM(total_payment) FROM loandata)) * 100,0) AS Percent_of_Total_Amount_Received
	FROM loandata
	GROUP BY home_ownership
	ORDER BY 2 desc
