# Key Insights — Pizza Sales Analysis

## Executive Summary

The Pizza Sales dashboard analyzes 2015 sales performance across revenue, orders, pizza volume, product performance, category mix, size mix, and ordering trends.

### Overall Performance

- **Total Revenue:** $817.86K
- **Total Orders:** 21,350
- **Total Pizzas Sold:** 49,574
- **Average Order Value:** $38.31
- **Average Pizzas per Order:** 2.32

The average order contains a little over two pizzas, with an average transaction value of $38.31.

---

## 1. Product Performance

### Top 5 Pizzas by Revenue

| Pizza | Revenue |
|---|---:|
| The Thai Chicken Pizza | $43,434 |
| The Barbecue Chicken Pizza | $42,768 |
| The Classic Deluxe Pizza | $38,181 |
| The Hawaiian Pizza | $32,273 |
| The Pepperoni Pizza | $30,162 |

**Insight:** The Thai Chicken Pizza generated the highest revenue among the products shown, followed closely by the Barbecue Chicken Pizza.

### Top 5 Pizzas by Quantity

| Pizza | Quantity Sold |
|---|---:|
| The Classic Deluxe Pizza | 2,453 |
| The Barbecue Chicken Pizza | 2,432 |
| The Hawaiian Pizza | 2,422 |
| The Pepperoni Pizza | 2,418 |
| The Thai Chicken Pizza | 2,371 |

**Insight:** The Classic Deluxe Pizza had the highest sales volume, while the Thai Chicken Pizza ranked highest by revenue. This shows why product performance should be evaluated using both volume and revenue.

### Top 5 Pizzas by Orders

| Pizza | Orders |
|---|---:|
| The Classic Deluxe Pizza | 2,329 |
| The Hawaiian Pizza | 2,280 |
| The Pepperoni Pizza | 2,278 |
| The Barbecue Chicken Pizza | 2,273 |
| The Thai Chicken Pizza | 2,225 |

**Insight:** The Classic Deluxe Pizza appeared in the largest number of orders among the top products shown.

---

## 2. Lowest-Performing Products

The dashboard highlights these products among the bottom five:

- The Soppressata Pizza
- The Calabrese Pizza
- The Mediterranean Pizza
- The Spinach Supreme Pizza
- The Brie Carre Pizza

### Bottom 5 by Revenue

| Pizza | Revenue |
|---|---:|
| The Soppressata Pizza | $16,426 |
| The Calabrese Pizza | $15,934 |
| The Mediterranean Pizza | $15,361 |
| The Spinach Supreme Pizza | $15,278 |
| The Brie Carre Pizza | $11,588 |

**Insight:** The Brie Carre Pizza generated the lowest revenue among the five displayed products, while the Soppressata Pizza generated the highest revenue within this bottom-five group.

The lower-volume products could be investigated further by comparing pricing, category, size, and order frequency.

---

## 3. Sales by Pizza Category

| Category | Share of Sales |
|---|---:|
| Classic | 26.91% |
| Supreme | 25.46% |
| Chicken | 23.96% |
| Veggie | 23.68% |

**Insight:** Classic pizzas represent the largest category share at 26.91%, but the four categories are relatively balanced. No single category dominates the sales mix.

---

## 4. Sales by Pizza Size

| Size | Share of Sales |
|---|---:|
| Large | 45.89% |
| Medium | 30.49% |
| Regular | 21.77% |
| X-Large | 1.72% |

**Insight:** Large pizzas account for nearly half of sales, making them the dominant size. Medium pizzas are the second-largest segment, while X-Large represents only a small share.

---

## 5. Pizza Volume by Category

| Category | Pizzas Sold |
|---|---:|
| Classic | 14,888 |
| Supreme | 11,987 |
| Veggie | 11,649 |
| Chicken | 11,050 |

**Insight:** Classic pizzas have the highest unit volume at 14,888 pizzas, while Chicken has the lowest volume among the four categories at 11,050.

---

## 6. Daily Ordering Trends

| Day | Orders |
|---|---:|
| Sunday | 2.7K |
| Monday | 2.9K |
| Tuesday | 3.0K |
| Wednesday | 3.1K |
| Thursday | 3.2K |
| Friday | 3.4K |
| Saturday | 3.1K |

**Insight:** Friday is the busiest day, with approximately 3.4K orders. Sunday has the lowest order volume at approximately 2.7K.

**Business implication:** Staffing, inventory preparation, and operational capacity can be planned around higher demand toward the end of the week.

---

## 7. Monthly Ordering Trends

| Month | Orders |
|---|---:|
| January | 1,929 |
| February | 1,648 |
| March | 1,864 |
| April | 1,829 |
| May | 1,765 |
| June | 1,771 |
| July | 1,860 |
| August | 1,835 |
| September | 1,638 |
| October | 1,782 |
| November | 1,844 |
| December | 1,585 |

**Insight:** January recorded the highest monthly order volume at 1,929 orders. December recorded the lowest at 1,585 orders.

The monthly pattern fluctuates rather than following a consistently increasing or decreasing trend.

---

## 8. Key Business Takeaways

1. **Overall sales:** The business generated approximately **$817.86K in revenue from 21,350 orders**, selling 49,574 pizzas during 2015.

2. **Product performance differs by metric:** The **Classic Deluxe Pizza** led by quantity and number of orders, while the **Thai Chicken Pizza** led the displayed top products by revenue.

3. **Classic is the largest category:** Classic pizzas contributed **26.91% of sales** and had the highest category volume at 14,888 pizzas.

4. **Large pizzas dominate the size mix:** Large pizzas represented **45.89% of sales**, followed by Medium at 30.49%.

5. **Friday is the busiest day:** Order volume peaks on Friday at approximately **3.4K orders**, while Sunday is the lowest at approximately 2.7K.

6. **Monthly demand varies:** January recorded the highest monthly order count, while December recorded the lowest in the dashboard.

7. **Lower-performing products need investigation:** The bottom-selling products show a gap versus the leading products. Further analysis should examine pricing, category, size, and order frequency to understand the difference.

---

## Suggested Next-Level Analysis

- Month-over-month revenue growth
- Revenue contribution by individual pizza
- Pareto analysis of products
- Peak ordering hours
- Weekday vs. weekend performance
- Average order value by category and size
- Product profitability analysis if cost data becomes available
- High-volume/low-revenue product analysis
- Low-volume/high-value product analysis

> **Note:** These insights are based on the values visible in the provided Power BI dashboard screenshots. They should be validated against the underlying SQL dataset before being treated as final business conclusions.
