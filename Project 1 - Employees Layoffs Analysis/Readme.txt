
# **📊 Employees Layoffs Analysis: MySQL Project**
===================================================

## **🔍 Project Overview**

A **two-phase data analysis** project that cleans and analyzes employee layoff data to identify trends
in workforce reductions across companies, industries, and countries.

### **🛠️ Part 1: Data Cleaning**

-> **Duplicate Removal**: Used `ROW_NUMBER()` to identify and eliminate duplicate entries

-> **Standardization**: 
  - Fixed inconsistent values (e.g., "Crypto% → Crypto")
  - Formatted dates properly using `STR_TO_DATE()`
  - Trimmed whitespaces from text fields

-> **Null Handling**: 
  - Populated missing industry data via self-join
  - Removed records with no layoff metrics

### **📈 Part 2: Exploratory Analysis**

-> **Key Metrics**:
  - Identified companies with 100% layoffs
  - Calculated maximum layoffs by company/industry

-> **Trend Analysis**:
  - Yearly/monthly layoff patterns
  - Running totals using window functions

-> **Geographic Impact**:
  - Top 10 affected countries
  - Location-based layoff comparisons

-> **Company Stage Analysis**:
  - Layoff distribution across startup stages

## **💡 Business Insights**

✔ Revealed which industries were most affected  
✔ Highlighted companies with largest workforce reductions  
✔ Showed temporal trends in layoff patterns  
✔ Identified geographic hotspots for job cuts  

## **⚙️ Technical Highlights**

-> **Advanced SQL Features**:
  - Window functions (`DENSE_RANK()`, `OVER()`)
  - Common Table Expressions (CTEs)
  - Complex joins for data imputation

-> **Data Quality**:
  - Created staging tables for safe transformations
  - Systematic validation at each cleaning step

**Perfect for showcasing SQL skills in data preparation and analysis!** 🚀

*"From messy data to actionable insights with pure SQL power."*