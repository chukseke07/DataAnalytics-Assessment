# DataAnalytics-Assessment

This repository contains SQL scripts to address various analytical use cases on customer data. Each script is written in MySQL, follows best practices for formatting and clarity, and is designed to run independently.

---

## 📌 Per-Question Explanations

### Q1: Funded Plans Customer Report

**Goal**: Identify customers who have:
- At least one **funded savings plan** (`is_regular_savings = 1`, `amount > 0`)
- Exactly one **funded investment plan** (`is_a_fund = 1`, `amount > 0`)

**Output Columns**:
- `owner_id`: Customer ID  
- `name`: Full name  
- `savings_count`: Number of savings plans  
- `investment_count`: Number of investment plans (always 1)  
- `total_deposits`: Combined amount saved/invested (in Naira)

**Notes**:
- Amounts are stored in **kobo**, so all are converted to **Naira** using `amount / 100`.
- Customers with more than one investment plan are excluded to focus on exclusive plan combinations.

**Tables Used**:
- `users_customuser`
- `savings_savingsaccount`
- `plans_plan`

---

### Q2: Segment Customers by Transaction Frequency

**Goal**: Categorize customers into **High**, **Medium**, and **Low** transaction frequency groups.

**Approach**:
- Retrieved savings transaction counts over the last 12 months.
- Computed **average monthly transactions** per customer.
- Applied classification rules:
  - **High**: ≥10 transactions/month
  - **Medium**: 3–9 transactions/month
  - **Low**: ≤2 transactions/month
- Aggregated counts and averages by category for reporting.

---

### Q3: Identify Inactive Accounts (No Inflows in 365 Days)

**Goal**: Flag active savings and investment accounts with **no inflow transactions in the last year**.

**Approach**:
- Used `MAX(transaction_date)` to find the latest inflow per account.
- Calculated days since the last inflow using `DATEDIFF(CURRENT_DATE, last_transaction_date)`.
- Filtered accounts where `DATEDIFF > 365`.

**Tables Referenced**:
- `plans_plan`
- `savings_plan`
- `investment_plan`
- Relevant transaction tables

---

### Q4: Estimate Customer Lifetime Value (CLV)

**Goal**: Estimate CLV per customer based on transaction behavior and tenure.

**Approach**:
- Defined **tenure** as the number of months since `date_joined`.
- Counted all transactions and summed their values.
- Calculated **average profit** per transaction as **0.1% of total value**.
used formula**
- Rounded results to two decimal places and sorted by CLV.

---

## ⚠️ Challenges

### 1. Schema Assumptions
- Some table names and relationships had to be inferred from context (e.g., `savings_savingsaccount`).
- Required iterative testing and schema validation.

### 2. Join Complexity
- Managing joins across savings, investment, and transaction tables needed care.
- Used conditional logic (`IFNULL`, `GREATEST()`) to handle partial data and avoid null-related errors.

### 3. CLV Calculation
- Prevented division by zero in tenure calculation using:
```sql
GREATEST(tenure_months, 1)

