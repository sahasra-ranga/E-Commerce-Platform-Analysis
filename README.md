# E-Commerce-Platform-Analysis
This is an analysis of the sales of an anonymous e-commerce platform from Pakistan between 2016 and 2018. This project explores how the data is cleaned and interpreted, the data is then analysed and visualised to draw conclusions. I aimed to find ways the platform can improve its business performance.

This is the link to the dataset publicly available on Kaggle
https://www.kaggle.com/datasets/zusmani/pakistans-largest-ecommerce-dataset

Step 1) Data Cleaning 
- Refer to Python file and SQL script
- Each column was analysed carefully, examined for null values, anomalies, standardisation errors and outliers and were rectified

Step 2) Exploratory Data Analysis
- Refer to SQL Script and Python file
- These were the main conclusions and areas of improvement drawn from the analyses
  1. The top 10% of customers in terms of total spent, and number of orders were identified.
     These **customers should be incentivised thriugh seasonal discounts and loyalty discounts**, and perhaps **marketing messages can be regularly sent** to these customers
     For customers who order particular items on a seasonal basis, reminders can be sent at the approximate date of purchase.
  2. The platform has low customer retention, with approximately half having ordered more than once. This indicates customer dissatisfaction or incentives to use other platforms to 
     shop. This indicates a low customer retention rate. Firstly, **reviews aand surveys should be conducted**, not only about the items but the user experience of the platform itself to 
     gain insights into customer pain points.
     Additionally, loyaltly points and benefits should be incorporated to encourage customers from using the platform
     <img width="478" alt="Screenshot 2025-06-11 at 5 35 17 PM" src="https://github.com/user-attachments/assets/e6e4498b-5814-4916-ab9e-f6c7b870a4a1" />
 again.
I attempted to find a pattern in customer sign-up dates, however there is no clear pattern. However, there is no consistent drop in terms of new customer sign-ups, which is a good indicator of business performance.

Next, we move onto the **products**, also known as SKUs in this dataset.
First, I identified the top 10% of products in terms of quantity sold and revenue generated (price*quantity).
For the top 10% of products in terms of quantity sold, these are my business recommendations
-- To capitalise on this, e-commerce platforms can be designed to **suggest complimentary or less popular products at check out.**
-- Additionally, **volume discounts**, such as "3 for $10" can encourage bulk purchase.
-- We can analyse the data to **optimise inventory and stock** so these items remain available for customers.
-- A **review section can be added** into these platforms, so good ratings can entice new customers to purchase these products.

For the top 10% of products in terms of revenue generated, these are my business recommendations
-- These products can be placed on the homepage, to gain further traction.
-- Moreover, the e-commerce platforms can **conduct flash sales and VIP discounts to promote purchase**.
-- The most important factor may be to add a review column, so **positive reviews make it easier for customers to make a hefty spend**.
-- These items should also have a **greater warranty and easy refund process**, to further encourage customers to make the purchase.

However, we should not only focus on what brings revenue for the platform but rather how it loses revenue.

Let us take a look at refunds, one of the factors driving loss of revenue.
The top 10% of products with the greatest refund rate were identified.
-- Customer pain points must be identified. Since every customer may not give a review, it could be incorporated into the refund process, to identify the issues with the products.
-- Moroever, product description and images can be improved to reflect the item more accurately.
-- After these changes, if the refund rates remain high, the platform can consider not selling these products, since the resources spent on these products can be diverted elsewhere which is more profitable.

Next, let us analyse the various product **categories**

