
# **📉 Customer Churn Analysis: MySQL Project**
================================================

## **🔍 Project Overview**

A comprehensive analysis of customer churn patterns that identifies at-risk customers and uncovers
business insights to improve retention rates.

### **🧹 Data Cleaning Highlights**

-> **Missing Value Treatment**: 
  - Replaced blank locations with "Unknown"
  - Imputed last login dates using signup dates

-> **Date Standardization**: 
  - Converted text dates to DATE format
  - Added calculated fields (subscription length, days inactive)

-> **Data Integrity Checks**: 
  - Validated age ranges
  - Ensured logical date sequences

### **📊 Key Analysis Findings**

-> **Churn Rate Metrics**: Calculated overall and segmented churn rates

-> **Demographic Insights**:
  - Highest churn by age group and gender
  - Subscription plan performance comparison

-> **Behavioral Patterns**:
  - Inactivity correlation with churn
  - Payment status impact on retention

-> **Temporal Trends**:
  - Monthly/Yearly churn patterns
  - Running totals to spot trends

### **💡 Business Value**

✔ Identifies high-risk customer segments  
✔ Reveals problematic subscription plans  
✔ Highlights seasonal churn patterns  
✔ Provides retention opportunity metrics  

## **⚙️ Technical Execution**

-> **Advanced SQL Features**:
  - Window functions for running totals
  - CASE statements for customer segmentation
  - CTEs for complex analysis

-> **Data Quality**:
  - Staging table approach for safety
  - Systematic data validation

**Perfect for demonstrating analytical SQL skills with real business impact!**  

*"Transforming raw customer data into retention strategies."*