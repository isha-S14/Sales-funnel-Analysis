# Sales Funnel Analysis using Advanced SQL

## Business Problem

An e-commerce business observed revenue stagnation despite steady website traffic.  
Initial assumptions suggested increasing marketing spend, but leadership wanted to first understand whether **conversion inefficiencies inside the sales funnel** were causing revenue leakage.

**Objective:**
- Analyze user movement across the sales funnel
- Identify stages with the highest drop-off
- Quantify the revenue impact of improving funnel performance
- Provide data-backed recommendations without increasing acquisition costs

---

## Funnel Logic

The funnel is modeled using **event-based tracking**, similar to GA4 or product analytics tools.

**Funnel Stages:**
1. **Visit** – User lands on the website  
2. **Product View** – User views a product page  
3. **Add to Cart** – User shows purchase intent  
4. **Checkout** – User initiates checkout  
5. **Purchase** – User completes the transaction  

Each stage is represented as an event, and users are tracked across stages using `user_id`.

Funnel sequencing is enforced using ordered logic inside SQL window functions.

---

## Key Insights

- The **largest drop-off** occurs between **Add to Cart → Checkout**
- A significant number of users show intent but fail to complete checkout
- Final purchases represent a small percentage of total visitors
- Funnel leakage is more impactful than traffic volume loss

**Business Interpretation:**
Improving mid-funnel experience yields higher ROI than increasing top-of-funnel traffic.

---

## Revenue Impact (Before & After Scenario)

A simulation was conducted assuming a **20% improvement** in the Add to Cart → Checkout stage.

**Assumptions:**
- Average Order Value (AOV): ₹2,000
- Improvement applied without increasing marketing spend

**Results:**
- ~20% increase in completed purchases
- Direct incremental revenue generation
- Zero additional customer acquisition cost

**Key takeaway:**
Funnel optimization delivers **cost-free revenue growth** compared to paid acquisition strategies.

---

## Tools Used

- **SQL**
  - Common Table Expressions (CTEs)
  - Window Functions (`LAG`)
  - Funnel sequencing logic
- **Relational Data Modeling**
  - Users, sessions, events, orders schema
- **Business Analytics**
  - Conversion rate analysis
  - Funnel leakage detection
  - Revenue impact modeling


