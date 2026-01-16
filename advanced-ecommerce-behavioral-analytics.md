This project analyzes end-to-end user behavior in an e-commerce platform using event-level clickstream data.
The objective is to evaluate funnel efficiency,identify drop-off points, and understand conversion behavior over time.

### Unlike basic funnel analysis, this project incorporates: ####

Session-level sequencing

Behavioral segmentation

Time-based metrics

Multi-touch attribution modeling

The analysis reflects real-world product, growth, and marketing analytics use cases.

# Business Objectives #

### The project was designed to answer the following business questions: ###

How efficient is the e-commerce funnel?

Where do users drop off most frequently?

Do users complete funnel stages within the same session?

How does funnel performance vary by category and brand?

When and why do users abandon carts?

How long do users take to convert?

Which user interactions contribute most to conversions?

# Dataset #

Source: Kaggle – E-Commerce Behavior Data from Multi-Category Store
Data Type: Event-level behavioral data
Granularity: One row per user action

# Key Attributes #

User actions (view, cart, purchase)

Timestamps for each event

Session identifiers

Product category and brand information

Pricing data

# Analysis Scope & Key Insights #
## Funnel Efficiency Measurement ##
What was analyzed

Percentage of users progressing from one funnel stage to the next

Overall funnel conversion rates

Key Business Insight

A significant drop-off occurs early in the funnel, indicating low intent or friction at discovery stages

Improving early-stage engagement can have a large downstream impact on revenue

## Funnel Drop-Off Analysis ##
What was analyzed

Identification of the largest user drop-off points between funnel stages

Key Business Insight

The highest attrition occurs between product view and add-to-cart

This suggests opportunities to improve:

Product page UX

Pricing transparency

Trust signals (reviews, delivery info)

## Session-Level Funnel Analysis ##
What was analyzed

Whether users complete funnel stages within the same session

Ordered event sequencing per session

Key Business Insight

Session-level funnels provide a more realistic view of user intent

Many users explore but delay purchasing, indicating multi-session decision journeys

## Funnel Segmentation by Category & Brand ##
What was analyzed

Funnel conversion rates segmented by:

Product category

Brand

Key Business Insight

Some categories attract high traffic but convert poorly

Certain brands show high intent with lower drop-off

Enables category-specific and brand-specific optimization strategies

## Cart Abandonment Analysis ##
What was analyzed

Identification of sessions where carts were abandoned

Time between cart addition and abandonment

Key Business Insight

Most cart abandonments happen shortly after adding items

Fast abandonment indicates:

Price sensitivity

Unexpected costs

Checkout friction

Business Impact

Enables precise timing for cart reminder emails

Supports targeted discount strategies

## Time-to-Conversion Metrics ##
What was analyzed

Time taken from first interaction to purchase

Distribution of conversion durations

Key Business Insight

A large share of conversions occur quickly

Longer conversion times suggest:

Research-heavy purchases

Higher price sensitivity

Business Impact

Helps define retargeting windows

Improves attribution accuracy

## Multi-Touch Attribution Modeling ##
What was analyzed

Contribution of different user interactions to conversions using:

First-touch attribution

Last-touch attribution

Linear attribution

Key Business Insight

Discovery interactions (product views) play a critical role

Last-touch attribution overvalues checkout-stage actions

Multi-touch models provide a more balanced view of user journeys
