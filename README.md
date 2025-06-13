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
     These **customers should be incentivised through seasonal discounts and loyalty discounts**, and perhaps **marketing messages can be regularly sent** to these customers
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
This is the dashboard of the different insights gained about the product categories.

<img width="1224" alt="Screenshot 2025-06-13 at 12 28 01 PM" src="https://github.com/user-attachments/assets/8f147583-1763-4fef-9e59-cb05ed727ef9" />

When we take a closer look at the sales by product category, we can identify the top-selling and bottom-selling categories. The top 3 categories (apart from Other and Superstore). are Men's Fashion, Mobile's and Tablets and Women's Fashion. On the other end, categories such as Books, School & Education and Computing perform poorly in terms of sales. The first improvement which should be done is to gather more data on the items labelled in the "Other" category. Several orders fall under this vague category, which could skew our analysis of best-performing categories. Additionally, Superstore is also a generic category, hence the direct category of these items should be collected for a better analysis. However, with the data we do have, these are the steps the business can take to leverage on the top-selling categories, and increase sales of poorly performing categories.
1. **Promote high performing categories on the homepage**, and offer seasonal discounts on these products to promote customer retention.
2. Provide **bundle offers** with low-selling item categories.
3. There is a huge preference to buy clothing on the platform, and to further this demand, the platform can** collaborate with international women and men's clothing brands** to sell their products on their platform.
4. To appeal to younger audience, the platform can **work with local influencers** to promote products such as clothes.
5. Target parents and students through intentional **advertising of school products** to gain demand in that category.
6. Onboard verified sellers in poor-performing categories to improve product quality.
7. Run A/B tests for different landing page layouts or ad creatives featuring poor-performing categories.

However, refunds are just as important as sales, as they imply customer dissatisfaction and waste of resources. Some categories which perform extremely well in terms of sales have just as high refund rates. All the categories labelled in blue have refund rates of over 0.4, hence there is a dire need to tackle this issue.
1. As mentioned above, **customer pain points must be identified accurately**. This would allow the platform to take more decisive and effective action.
2. **Ensure complete product specifications**, compatibility notes, and clear model numbers.
3.** Partner with authorised sellers** to guarantee authenticity.
4. Flag sellers with repeated negative reviews or damaged products.
5. Include **better product visuals**, such as a 360 degree view for electronics.
6. The platform can **include a 10% non-refundable fee for refunds if the product has no defect and is delivered on time**; this would deter customers from making hefty purchases without thought because of the guarantee that they can refund the item and gain their money back.
7. Operational efficiency can be enhanced so customers get their products on time.

**Trends over Time**

<img width="1216" alt="Screenshot 2025-06-13 at 1 06 31 PM" src="https://github.com/user-attachments/assets/a5971218-c429-4c6b-a277-4681dac5bc3e" />

Over the span of three years, the business has demonstrated consistent and healthy growth in gross revenue. This upward trend signifies a strong market presence, increasing customer base, and potentially successful sales and marketing strategies. A year-on-year comparison indicates that despite possible seasonal fluctuations, the business has maintained positive momentum—highlighting good product-market fit and operational scalability.

Additionally, the refund rates have also dropped significantly with each year, going from roughly 0.8, to 0.4 to 0.2. This indicates strong improvements in business performance. This trend suggests enhancements in product quality, customer experience, and fulfilment accuracy, as well as more efficient refund handling. A lower refund rate reduces operational costs, boosts net revenue retention, and reflects growing customer satisfaction and trust, all of which are positive indicators of a maturing and more efficient e-commerce platform.

Now let us analyse the distribution of sales across each month. There are 3 peaks, with one of them being extremely high in March, May and November respectively. 
The peak in March could be attributed due to Q1 events to clear inventory or new product launches, however it is tough to identify the driving factor for this peak.
The peak in May is likely due to the surge of shopping before Eid, a major festival in Pakistan which often occurs in June. 
The large peak in November may be due to 11.11 or Black Friday sales, End-of-Year clearance sales or pre-winter shopping, however it is difficult to identify the exact factor as well.

The first step to be taken is for the platform to understand the driving factors of these surges. This would allow for them to identify key categories and SKUs to capitalise on this surge.
-- These peak periods should be prioritised in inventory planning, logistics capacity, customer support, and marketing budget allocation.
-- Targeted marketing campaigns can be timed and tailored to these months to capitalise on higher consumer engagement.
-- Off-peak months offer an opportunity to explore loyalty programmes, bundled discounts, or category diversification to smoothen revenue across the year.

Lastly, let us analyse the payments methods used by customers.
<img width="1162" alt="Screenshot 2025-06-13 at 2 21 30 PM" src="https://github.com/user-attachments/assets/e0fc850c-e680-482f-ac8d-6c68f4daa8e9" />
Through the first graph, when we compare the proportion of complete orders to refunds for each payment type, a huge proportion of COD payments result in refunds. This could potentially be due to buyer's remorse, and causes revenue leakage. Hence, it would be best for business performance to further promote cashless payment options. 
For fraudulent orders, although PAYAXIS accounts for 9 out of 10 of them, we cannot draw any conclusions due to the extremely small sample size.
-- We can see there is a huge preference for cash on delivery. It could be due to customers feel a sense of assurance when they pay after receiving their products.
-- It could also indicate easy access to cash or limited cashless options.
-- The e-commerce platform can venture into the latest popular financial systems, such as EasyPaisa and SadaPay.
-- EASYPAY, JAZZ, PAYAXIS and BANKALFALAH are other common payment methods, and to further increase user base using these methods, the platform can offer discounts and cashbacks when these methods are used, and improve customer experience and transparency related to online payment to garner trust.

The last figure gives us new insights. The most common payment methods surprisingly do not have the greatest transaction value. Hence, payment methods such as "Finance Settlement" and "MCBLITE" indicate high-spending customers. To leverage upon this, the platform can run these key strategies:
1. Promote high-ticket items (e.g. electronics, appliances) via exclusive campaigns using FINANCESETTLEMENT, MCBLITE, etc to boost sales of high-margin products through trusted, high-value channels.
2. Partner with these payment providers to offer cashback or loyalty rewards for using their services which improves customer loyalty and incentivises use.
3. When users choose high-ATV payment methods, show add-on bundles or premium services (e.g. extended warranty, express delivery).
4. Test and optimise checkout flow for FINANCESETTLEMENT, BANKALFALAH, etc. Ensure zero friction (speed, error handling, mobile compatibility).
5. Conduct post-purchase surveys for users of high-value methods to understand why they prefer it and what might improve their experience.





For a much more detailed analysis, refer to the SQL and Python files where statistical analysis is also performed. 


