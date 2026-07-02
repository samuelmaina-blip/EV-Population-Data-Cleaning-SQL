# Electric Vehicle Population Data: End-to-End SQL Engineering & Power BI Analytics

![EV Dashboard Preview](Screenshot%20(242).png)

## Project Overview
This project establishes a robust end-to-end data pipeline, tracking the architectural isolation and structural transformation of an extensive Electric Vehicle (EV) dataset in SQL, concluding with an interactive executive dashboard in Power BI. 

The core objective was to simulate an enterprise-level data workflow: taking a massive, unpolished open-source production dataset, executing rigorous data quality auditing and imputation frameworks via a decoupled staging layer, and passing the optimized data downstream for business intelligence reporting.

* **Dataset Source:** Washington State Department of Licensing (Open Data Initiative)
* **Dataset Volume:** 150,000+ records tracking VIN metrics, geographic distribution, and technical specs.
* **Core Toolkit:** PostgreSQL (Staging environment & structural manipulation), Power BI Desktop (Data modeling & UI design)

---

## Phase 1: Architectural Isolation & Data Cleaning (SQL)

To safeguard production data and adhere to database engineering best practices, the raw source layer was kept entirely pristine. All cleaning operations were isolated inside a dedicated working layer named `vehicle_population_staging`.

### 1. High-Integrity Duplication Auditing
Before manipulating any records, a comprehensive deduplication audit was implemented across the dataset's core transactional and machine-level attributes.
* **Logic:** Utilized a window function `ROW_NUMBER() OVER (PARTITION BY ...)` across the composite primary key attributes to isolate overlapping records.
* **Outcome:** Verified transaction-level uniqueness across the entire dataset.

### 2. Standardization and Text Normalization
Categorical variables and structural text fields were audited to eliminate trailing whitespaces, case inconsistencies, and formatting errors that frequently corrupt analytical group-by models.

### 3. Strategic Null and Missing Value Imputation
Structural logic was applied to preserve total row integrity while removing data noise, such as converting missing geographic fields into standardized `'Unknown'` string flags to preserve the dataset's baseline count of 150,482 rows.

---

## Phase 2: Interactive Executive Reporting (Power BI)

Once optimized via SQL, the dataset was connected downstream to Power BI. 

### Key Analytical Deliverables & Visual Architecture
* **Executive KPI Cards:** Highlights **37 Total Brands** and **150.482K Total EVs**.
* **Top 10 Brands Analysis:** A ranked bar chart visualizing market dominance.
* **Inventory Age Profile:** An area chart mapping the trend of active registered vehicles by model year.
* **Technical Range Profiling:** Comparative column chart: Battery Electric Vehicles (BEV) average **79 miles** vs. Plug-in Hybrid Electric Vehicles (PHEV) at **31 miles**.
* **CAFV Eligibility Analysis:** An interactive donut chart segmenting vehicles by Clean Alternative Fuel Vehicle eligibility (Eligible, Not Eligible, Unresearched).
* **Dynamic Filtering:** Responsive sidebar slicers for **County**, **Make**, and **Model Year**.

---

*Created by Samuel | Data Analyst*
