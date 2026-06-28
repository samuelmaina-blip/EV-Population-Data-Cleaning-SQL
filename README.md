# Electric Vehicle Population Data: End-to-End SQL Engineering & Power BI Analytics

![EV Dashboard Preview](Screenshot%20(112).png)

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
Before manipulating any records, a comprehensive deduplication audit was implemented across the dataset's core transactional and machine-level attributes (including partial VINs, Department of Licensing IDs, and distinct regional coordinates). 
* **Logic:** Utilized a window function `ROW_NUMBER() OVER (PARTITION BY ...)` across the composite primary key attributes to isolate overlapping records.
* **Outcome:** Verified transaction-level uniqueness across the entire dataset, ensuring zero aggregate distortion during downstream counts.

### 2. Standardization and Text Normalization
Categorical variables and structural text fields were audited to eliminate trailing whitespaces, case inconsistencies, and formatting errors that frequently corrupt analytical group-by models:
* Standardized text formats for state regional identifiers and county listings.
* Executed conditional mutation updates to map geographical strings uniformly across out-of-state and in-state records.

### 3. Strategic Null and Missing Value Imputation
Dropping missing rows entirely would discard critical historical volume and skew macro market metrics. Instead, structural logic was applied to preserve total row integrity while removing data noise:
* Imputed unlinked or empty geographic fields, cities, and postal codes to a standardized `'Unknown'` string flag.
* Handled missing legislative district entries by converting them into appropriate operational placeholders.
* Standardized missing utility provider allocations to `'Non-WA'` or general defaults based on geographic location, preserving the dataset's overall baseline count of 150,482 rows.

---

## Phase 2: Interactive Executive Reporting (Power BI)

Once optimized via SQL, the dataset was connected downstream to Power BI. Because the heavy lifting and structural transformation were already handled at the database level, the Power Query schema remained lightweight, high-performing, and built entirely for analytics.

### Key Analytical Deliverables & Visual Architecture
* **Executive KPI Cards:** Positioned prominently on the left panel to provide immediate situational context, breaking down total marketplace scale: **150,482 Total EVs**, **37 Manufacturers**, and **127 Distinct Car Models**.
* **Vehicle Manufacture Year Profile:** An age-distribution timeline mapping active registered vehicles by their specific manufacture year (1997–2024), precisely detailing the manufacturing era footprint of the surviving EV ecosystem.
* **MSRP Distribution Framework:** Rather than using a cluttered, unaggregated price chart, financial metrics were categorized into clean corporate price brackets (*Lower than 50k*, *Above 50k*, etc.) via a structured matrix view to immediately pinpoint market pricing tiers.
* **Technical Range Profiling:** A comparative horizontal bar chart evaluating the average electric range variation across vehicle types, showing Battery Electric Vehicles (BEVs) leading at an average of **78.61 miles** vs. Plug-in Hybrid Electric Vehicles (PHEVs) at **30.66 miles**.
* **Geographic Density Mapping:** Integrated an interactive, color-coded geographic map component detailing the density and volume concentration of active vehicles by state and county bounds.
* **Dynamic Filtering Controls:** Implemented responsive slicers for *County*, *Make*, *Model*, and *Model Year*, allowing end-users to dynamically slice the entire canvas and isolate specific localized trends instantly.
