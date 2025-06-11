import pandas as pd
import scipy.stats as stats
import numpy as np
from scipy.stats import ttest_ind


df = pd.read_csv('/Users/rangasahasra/Downloads/Pakistan Largest Ecommerce Dataset.csv', low_memory=False)

# Optional cleaning steps
df.replace({'\\N': None, '-': None}, inplace=True)
df.dropna(how='all', inplace=True)  # drop completely empty rows

df.to_csv("cleaned_dataset.csv", index=False)


dfNew = pd.read_csv('/Users/rangasahasra/Downloads/Cleaned_ValidDataSet.csv', low_memory=False)

contingency = pd.crosstab(dfNew['payment_method'], dfNew['status'])

# Chi-Square Test
chi2, p, dof, expected = stats.chi2_contingency(contingency)

# Cramér's V
n = contingency.sum().sum()
cramers_v = np.sqrt(chi2 / (n * (min(contingency.shape)-1)))

print(f"Cramér's V: {cramers_v:.3f}")

# A low Cramér's Test value of 0.156 indicates a negligible relationship between payment type and order status

# Let us see if having a discount significantly increases the quantity of items bought
no_discount = dfNew[dfNew['discount_amount'] == 0]['qty_ordered']
with_discount = dfNew[dfNew['discount_amount'] > 0]['qty_ordered']

t_stat, p_value = ttest_ind(with_discount, no_discount, equal_var=False)  # Welch's t-test
print(f"T-statistic: {t_stat}")
print(f"P-value: {p_value}")
# T-Value - 3.92
# p-value - 8.96
# Hence, discounts do not significantly increase the quantity of items bought