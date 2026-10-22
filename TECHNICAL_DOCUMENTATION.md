# Pharma Enterprise Data & Analytics Platform
## Technical Documentation

> **Data notice:** This project uses synthetic data for portfolio and demonstration purposes. It does not represent real patients, clinical trials, suppliers, manufacturing operations, or commercial transactions.
> 
>  **AI notice:** This project uses AI to debug code and in some instances like in AWS lambda, use AI entirely to generate the code that generates synthetic daily data.
>
> **Scroll to bottom for link to Power BI report**

## Contents
1. [Executive summary](#1-executive-summary)
2. [Business objectives and scope](#2-business-objectives-and-scope)
3. [Architecture](#3-architecture)
4. [AWS data generation and storage](#4-aws-data-generation-and-storage)
5. [Databricks lakehouse design](#5-databricks-lakehouse-design)
6. [Data inventory and modelling risks](#6-data-inventory-and-modelling-risks)
7. [Power BI semantic model](#7-power-bi-semantic-model)
8. [Power BI report pages](#8-power-bi-report-pages)
9. [KPI and measure definitions](#9-kpi-and-measure-definitions)
10. [Dynamic insights](#10-dynamic-insights)
11. [Automation and operations](#11-automation-and-operations)
12. [Validation checklist](#12-validation-checklist)
13. [Portfolio presentation](#13-portfolio-presentation)
14. [Reference configuration](#14-reference-configuration)

---

## 1. Executive summary

This project implements an automated pharmaceutical enterprise data platform that turns synthetic operational data into curated analytics and Power BI decision-support dashboards. It demonstrates an end-to-end workflow spanning data generation, cloud object storage, incremental ingestion, lakehouse transformations, semantic modelling, visual analytics, and scheduled refresh.

The platform covers six operational domains:

- Supply chain and inventory
- Manufacturing and plant capacity
- Commercial sales and demand planning
- Quality and regulatory compliance
- Clinical trial operations
- Product safety and adverse-event monitoring

The data is synthetic and intended for portfolio demonstration. It must not be used for real operational, clinical, or regulatory decisions.

## 2. Business objectives and scope

### Objectives

- Automate recurring generation and landing of realistic pharmaceutical operational datasets.
- Use a lakehouse pattern to ingest and transform raw files into Bronze, Silver, and Gold layers.
- Model reusable dimensions separately from analytical fact tables for Power BI.
- Provide executive and domain-specific dashboards for monitoring performance, risk, and intervention priorities.
- Demonstrate cloud orchestration, incremental data processing, dimensional modelling, DAX, and BI refresh automation.

### In scope

- AWS S3 as the raw data landing zone and static master-data store.
- AWS Lambda for scheduled synthetic data generation.
- Amazon EventBridge Scheduler for automated invocation.
- Databricks Lakeflow file-arrival ingestion and pipeline transformations.
- Bronze, Silver, and Gold data layers.
- Power BI semantic model, report pages, KPI measures, month-over-month comparisons, and dynamic insight panels.
- Databricks job orchestration that triggers Power BI semantic-model refresh after the pipeline succeeds.

### Known limitations

- All generated records are synthetic.
- True market share cannot be calculated without competitor or total-market data.

## 3. Architecture

### End-to-end flow

```text
Amazon EventBridge Scheduler
          |
          v
      AWS Lambda
          |
          v
       Amazon S3
          |
          v
Databricks File Arrival Trigger
          |
          v
  Databricks Lakeflow
          |
          v
        Bronze
          |
          v
        Silver
          |
          v
         Gold
          |
          v
       Power BI
```

### Orchestration sequence

1. EventBridge Scheduler invokes the Lambda generator on its configured schedule.
2. Lambda reads stable master data from S3 and writes new synthetic operational files to domain-specific prefixes.
3. Databricks detects new or changed files through a file-arrival trigger on the S3 storage location.
4. The Lakeflow pipeline ingests and transforms data through Bronze, Silver, and Gold.
5. A Databricks Lakeflow Job runs the Power BI refresh task after the pipeline task succeeds.
6. Power BI refreshes the connected semantic model and updates report visuals after successful refresh.

The configured Databricks file-arrival trigger is active. Its documented settings include a five-minute wait after the last change. The Lakeflow Job includes the pipeline task and a dependent Power BI refresh task. The Power BI connection is named `power_bi_connection`, the workspace is `Prod`, and the semantic model is `Pharma Dashboard`. The gateway field is intentionally blank in the current configuration.

## 4. AWS data generation and storage

### S3 bucket and prefixes

Bucket: `my-projects-data-sherrif`

| Prefix | Purpose | Generation behaviour |
|---|---|---|
| `01_master_data/` | Stable reference data used by the generator and joins | Static; do not regenerate daily |
| `02_supply_chain/` | Purchase orders, shipments, inventory, supplier performance and risk | Recurring operational data |
| `03_manufacturing/` | Production batches and plant capacity | Recurring operational data |
| `04_demand_commercial/` | Sales and demand forecast versus actual | Recurring operational data |
| `05_quality/` | Quality events | Recurring operational data |
| `06_regulatory/` | Regulatory events | Recurring operational data |
| `07_rnd_clinical/` | Clinical programs and clinical trials | Recurring operational data |
| `08_safety/` | Adverse events | Recurring operational data |
| `09_data_quality/` | Downstream data-quality outputs | Not generated by the Lambda raw-data generator |
| `10_analytics/` | Downstream analytical outputs | Not generated by the Lambda raw-data generator |

### Static master data

The `01_master_data/` prefix contains:

- `dim_product.csv`
- `dim_country.csv`
- `dim_supplier.csv`
- `dim_plant.csv`
- `dim_distribution_centre.csv`

These files are stable reference inputs and should not be regenerated as part of the daily operational-data process.

### Lambda function

Function: `daily_inventory_generator`

The function reads static master data and generates synthetic operational datasets under the relevant S3 prefixes. The run date is taken from the event's `run_date` when provided; otherwise, the function uses the current date. Monthly generation defaults to the first day of the month (`run_date.day == 1`).

| Domain | Generated datasets |
|---|---|
| Supply chain | `purchase_orders`, `shipments`, `supplier_risk_events`, `critical_supplier_dependencies`, `supply_network_edges`, `inventory_monthly`, `supplier_performance_monthly` |
| Manufacturing | `production_batches`, `plant_capacity_monthly` |
| Demand and commercial | `sales`, `demand_forecast_actual` |
| Quality | `quality_events` |
| Regulatory | `regulatory_events` |
| R&D and clinical | `clinical_programs`, `clinical_trials` |
| Safety | `adverse_events` |

`09_data_quality/` and `10_analytics/` are downstream output locations, not part of Lambda's raw-data generation.

### Operational guidance

- Keep master data stable between generation runs so IDs remain referentially consistent.
- Use the current date for normal scheduled runs; use historical dates only for controlled backfills.
- Keep raw generation separate from downstream data-quality and analytics outputs.
- Inspect Lambda logs and S3 object creation when diagnosing missing pipeline updates.

## 5. Databricks lakehouse design

Catalog: `prod_global`

### Bronze layer

Schema: `prod_global.bronze_layer`

Bronze tables ingest raw operational files with minimal transformation. The project uses Lakeflow streaming tables and file-arrival ingestion to support incremental processing when new files arrive. This reduces the need to reprocess all raw files for every arrival. Batch or materialized ingestion remains an alternative if the latency or operating model changes.

Documented Bronze tables include:

- `purchase_orders`
- `shipments`
- `sales`
- `inventory_monthly`
- `demand_forecast_actual`
- `supplier_performance_monthly`
- `supplier_risk_events`
- `quality_events`
- `regulatory_events`
- `adverse_events`
- `production_batches`
- `plant_capacity_monthly`
- `clinical_programs`
- `clinical_trials`
- `critical_supplier_dependencies`
- `supply_network_edges`

### Silver layer

Schema: `prod_global.silver_layer`

Silver standardizes and prepares ingested datasets for analysis. It contains cleaned operational tables and master-data dimensions used by Gold transformations. It is the intended layer for resolving schema, type, and data-quality issues before business-facing aggregation.

### Gold layer

Schema: `prod_global.gold_layer`

Gold contains seven principal analytical tables and five shared dimensions.

| Gold analytical table | Purpose |
|---|---|
| `supply_chain_control_tower` | Inventory position, demand context, stockout risk and inventory coverage |
| `inventory_risk` | Inventory days, safety-stock exposure and inventory risk band |
| `supplier_risk` | Supplier performance, risk events, critical dependencies and risk indicators |
| `demand_performance` | Forecast units, actual demand, forecast bias and forecast error |
| `manufacturing_performance` | Production output, yield, utilisation, batch status and capacity context |
| `quality_regulatory` | Quality and regulatory events combined for cross-domain reporting |
| `clinical_safety` | Clinical programs/trials joined with safety/adverse-event records |

### Shared Gold dimensions

| Dimension | Business key and principal attributes |
|---|---|
| `dim_product` | `ProductID`, `ProductName`, `TherapeuticArea`, `DosageForm`, `ProductType`, `StorageClass` |
| `dim_country` | `CountryCode`, `Country`, `Region` |
| `dim_supplier` | `SupplierID`, `SupplierName`, `CountryCode`, `MaterialCategory`, `BaseUnitCost`, `NominalLeadTimeDays`, `StrategicRisk` |
| `dim_plant` | `PlantID`, `PlantName`, `CountryCode`, `PlantType`, `MonthlyCapacityUnits` |
| `dim_distribution_centre` | `DCID`, `DCName`, `CountryCode`, `StorageCapacityUnits` |

### Dimensional modelling decisions

- Keep descriptive dimension attributes in shared Gold dimensions and retain business keys in Gold analytical tables.
- Connect dimensions to facts in Power BI using matching keys.
- Remove duplicate dimension-derived descriptive columns from facts when the shared dimension supplies the same attribute.
- Retain joins that define the analytical grain of a fact, such as inventory joined to demand, quality joined to regulatory events, and trials joined to adverse events.
- Use distinct event IDs for event counts where joins can create duplicate rows.
- Aggregate trial enrollment at `TrialID` grain before summing when a trial has multiple related adverse-event rows.

## 6. Data inventory and modelling risks

| Dataset | Key fields | Grain / modelling note |
|---|---|---|
| `sales` | `SalesID`, `SaleDate`, `ProductID`, `CountryCode`, `UnitsSold`, `UnitPrice`, `Channel`, `NetSales` | Sales record grain; no customer identifier |
| `demand_forecast_actual` | `Month`, `ProductID`, `CountryCode`, `ForecastUnits`, `ActualDemandUnits`, `ForecastBiasUnits`, `ForecastErrorPct` | Monthly product-country demand grain |
| `inventory_monthly` | `Month`, `ProductID`, `CountryCode`, `OnHandUnits`, `SafetyStockUnits`, `InventoryDays`, `StockoutRisk` | Monthly product-country inventory grain |
| `supplier_performance_monthly` | `SupplierID`, `Month`, `OnTimeDeliveryPct`, `QualityAcceptancePct`, `AvgLeadTimeDays`, `DeliveryCount` | Monthly supplier grain |
| `purchase_orders` | `PurchaseOrderID`, `OrderDate`, `SupplierID`, `ProductID`, `OrderedUnits`, `ExpectedReceiptDate`, `ActualReceiptDate`, `UnitCost`, `POStatus` | Purchase-order grain |
| `shipments` | `ShipmentID`, `ShipmentDate`, `ProductID`, `OriginDCID`, `DestinationCountryCode`, `PlannedUnits`, `PlannedTransitDays`, `ActualDelayDays`, `TransportMode`, `ShippedUnits`, `OnTimeFlag` | Shipment grain |
| `production_batches` | `BatchID`, `ProductionDate`, `ProductID`, `PlantID`, `PlannedUnits`, `YieldPct`, `BatchStatus`, `ProducedUnits` | Batch grain |
| `plant_capacity_monthly` | `Month`, `PlantID`, `AvailableCapacityUnits`, `ProducedUnits`, `UtilisationPct`, `CapacityStatus` | Monthly plant grain |
| `quality_events` | `QualityEventID`, `EventDate`, `ProductID`, `PlantID`, `SupplierID`, `EventType`, `Severity`, `ClosedFlag`, `ResolutionDays` | Quality-event grain |
| `regulatory_events` | `RegulatoryEventID`, `EventDate`, `ProductID`, `CountryCode`, `EventType`, `Status`, `Priority` | Regulatory-event grain |
| `clinical_trials` | `TrialID`, `ProgramID`, `StartDate`, `TargetEnrollment`, `ActualEnrollment`, `RecruitmentStatus`, `TrialType`, `EnrollmentAchievementPct` | Trial grain; aggregate before joining to event-level data |
| `adverse_events` | `AdverseEventID`, `ReportDate`, `ProductID`, `CountryCode`, `EventTerm`, `SeriousFlag`, `Outcome`, `PatientAge`, `PatientSex` | Adverse-event grain; no explicit closure status |

The documented `quality_regulatory` join links quality and regulatory events by `ProductID` and may multiply records. The `clinical_safety` join links trial and adverse-event records and may also multiply records. Distinct identifiers and grain-aware measures are essential.

## 7. Power BI semantic model

Power BI consumes the Gold dimensions and analytical tables. The semantic model should use shared dimensions for slicers and relationships, with measures centralised in a dedicated measures table where appropriate.

### Relationship guidance

- `dim_product[ProductID]` to each applicable fact `ProductID`.
- `dim_country[CountryCode]` to each applicable fact `CountryCode`.
- `dim_supplier[SupplierID]` to supplier-risk and quality facts where applicable.
- `dim_plant[PlantID]` to manufacturing and quality facts.
- `dim_distribution_centre[DCID]` to shipment origin distribution-centre fields where applicable.
- Use a dedicated calendar table for date filtering and mark it as the model's date table.
- Use single-direction dimension-to-fact filtering by default unless a documented requirement needs otherwise.
- Check relationship cardinality and avoid ambiguous filter paths before publishing.

### Date and comparison behaviour

Month-over-month comparisons should identify the latest selected date, derive the full current month and previous month, then remove the selected date filter before applying full-month date ranges. This supports a selection ending mid-month while comparing the full month to the full prior month.

Reference pattern:

```DAX
VAR MaxSelectedDate =
    MAXX(
        ALLSELECTED('Master Calendar'[Date]),
        'Master Calendar'[Date]
    )
VAR CurrentMonthStart =
    DATE(YEAR(MaxSelectedDate), MONTH(MaxSelectedDate), 1)
VAR CurrentMonthEnd =
    EOMONTH(MaxSelectedDate, 0)
VAR PreviousMonthStart =
    EOMONTH(MaxSelectedDate, -2) + 1
VAR PreviousMonthEnd =
    EOMONTH(MaxSelectedDate, -1)
```

Use `REMOVEFILTERS('Master Calendar'[Date])` before applying `DATESBETWEEN` for each full-month comparison. Validate behaviour against the report's intended semantics and available data.

## 8. Power BI report pages

The report uses a consistent Bayer-inspired design system: dark navy navigation/header, pale background, white visual cards, blue chart accents, and distinct green, red, and magenta insight panels.

| Page | Purpose and agreed visuals |
|---|---|
| **Executive Overview** | Enterprise KPIs; monthly actual vs forecast demand; enterprise health score; stockout risk; quality and regulatory trends; clinical/safety signal; country overview; Improvements, Risks, Action Points |
| **Supply Chain** | On-Time Delivery %, Inventory Days, Stockout Risk Items, Suppliers With Open Risk Events; on-time delivery trend; inventory-days trend; supplier performance Top 10; supplier risk by severity; inventory at risk by country; shipment performance by transport mode |
| **Manufacturing** | Production Output; Capacity Utilization %; Production Yield %; Batch Completion %; production output trend; plant capacity utilization; yield trend; batch status; production achievement by plant; yield by product; insight panels |
| **Commercial Demand** | Sales Revenue; Units Sold; Forecast Demand Next 3 Months; Demand Attainment %; combined units/revenue trend; revenue by channel; revenue by therapeutic area; Top 10 products by revenue; revenue by region; forecast accuracy by therapeutic area; insight panels |
| **Quality and Regulatory** | Total Quality Events; Open Quality Events; Total Regulatory Events; Open Regulatory Events; quality trend; quality by severity; events by type; regulatory events by country; regulatory status breakdown; quality events by plant; insight panels |
| **Clinical and Safety** | Total Clinical Trials; Active Trials; Total Safety Cases; Open Safety Cases; clinical-trial trend; safety-cases trend; safety cases by severity; trials by phase; safety cases by event term; safety cases by country; insight panels |

### Commercial Demand limitations

The source sales fields include `SalesID`, `SaleDate`, `ProductID`, `CountryCode`, `UnitsSold`, `UnitPrice`, `Channel`, and `NetSales`.

- Market share is not available without competitor or total-market data.
- Therapeutic-area analyses require the `ProductID` relationship to `dim_product`.

### Quality and Regulatory limitations

- Use `DISTINCTCOUNT(QualityEventID)` and `DISTINCTCOUNT(RegulatoryEventID)` for event counts.
- Use actual `ClosedFlag` values to determine open quality events.
- Use actual `RegulatoryStatus` values for open regulatory events.
- Do not assume a combined table's row count equals event count.

### Clinical and Safety limitations

- Total clinical trials should count distinct `TrialID`.
- Total safety cases should count distinct `AdverseEventID`.
- Trial-level enrollment should be aggregated once per `TrialID` to avoid duplication caused by joining adverse events.

## 9. KPI and measure definitions

| Measure | Definition / caution |
|---|---|
| Total Sales Revenue | Sum of `NetSales` from the sales fact |
| Total Units Sold | Sum of `UnitsSold` from the sales fact |
| Forecast Demand Next 3 Months | Sum `ForecastUnits` over a defined forward-looking three-month window; ensure date logic selects future months |
| Demand Attainment % | Actual demand divided by forecast demand using aligned periods and compatible grain |
| On-Time Delivery % | Delivery-count-weighted supplier on-time delivery percentage, or shipment-level `OnTimeFlag` if that is the intended definition. Do not mix grains |
| Inventory Days | Average or appropriately weighted inventory-days measure; document the aggregation |
| Stockout Risk Items | Distinct `ProductID`/`CountryCode` combinations with `StockoutRisk = High`, not raw row count |
| Production Utilization % | Average or weighted utilization; verify whether source values are stored as 0–1 or 0–100 |
| Quality Events | Distinct `QualityEventID` |
| Regulatory Events | Distinct `RegulatoryEventID` |
| Total Clinical Trials | Distinct `TrialID` |
| Active Trials | Distinct `TrialID` filtered by a validated active-status definition |
| Total Safety Cases | Distinct `AdverseEventID` |
| Open Safety Cases | Not directly supported by the documented source schema unless an explicit status field or clearly defined proxy is added |

Month-over-month insight measures should use the same underlying definitions as KPI cards. Fallback text should indicate that no qualifying movement was detected, not claim that no risk exists.

## 10. Dynamic Improvements, Risks and Action Points

Each report page has three text measures designed to respond to report filters:

- **Improvements:** positive movements in agreed KPIs.
- **Risks:** adverse movements in agreed KPIs.
- **Action Points:** practical follow-up actions triggered by adverse movements.

Implementation principles:

- Base insights on agreed page KPIs and valid supporting measures only.
- Use consistent month-over-month comparisons and handle divide-by-zero or missing prior-period values.
- Prioritise a small number of relevant insights so panels remain readable.
- Avoid interpreting increased event counts as proof of worsening underlying quality without considering reporting volumes and context.
- For safety, quality, and regulatory use cases, phrase insights as monitoring signals and investigation prompts, not clinical or legal conclusions.
- Provide fallback messages when no qualifying movement is detected.

## 11. Automation and operations

### Successful automated chain

1. EventBridge Scheduler invokes `daily_inventory_generator`.
2. Lambda writes operational data to S3.
3. Databricks file-arrival trigger detects new files.
4. Lakeflow pipeline executes Bronze, Silver, and Gold transformations.
5. Lakeflow Job waits for pipeline success and then runs the Power BI refresh task.
6. Power BI semantic model refresh completes, making updated data available to the report.

### Troubleshooting

| Symptom | Checks |
|---|---|
| No new files in S3 | Inspect EventBridge schedule, Lambda invocation status/logs, permissions, and destination prefixes |
| Files exist but pipeline did not run | Check file-arrival trigger state, watched storage path, arrival delay, and pipeline/job history |
| Pipeline fails | Inspect the failing task and source file/schema; verify paths, schema inference, and table ownership |
| Gold counts unexpectedly inflate | Check join grain, distinct keys, and whether one-to-many joins multiply fact rows |
| Power BI data is stale | Confirm pipeline success, dependent refresh task execution, connection authentication, and semantic-model refresh history |
| Visual shows blank or implausible comparisons | Check date context, full-month comparison logic, prior-month availability, relationships, and denominators |

### Security and credentials

- Do not hardcode AWS keys, tokens, or credentials in source code or documentation.
- Use AWS IAM roles and policies with least privilege for Lambda and S3 access.
- Use configured Databricks and Power BI connection mechanisms and review permissions periodically.
- Keep synthetic data clearly labelled, especially when screenshots or portfolio materials are shared publicly.

## 12. Validation checklist

- [ ] Confirm Lambda writes expected files to each domain prefix.
- [ ] Confirm static master-data files remain stable across runs.
- [ ] Confirm the Databricks file-arrival trigger detects newly written files.
- [ ] Confirm pipeline success and row counts for Bronze, Silver, and Gold.
- [ ] Validate primary keys and referential integrity for product, country, supplier, plant, and distribution-centre dimensions.
- [ ] Reconcile distinct event counts to source IDs to detect join multiplication.
- [ ] Validate trial enrollment at distinct `TrialID` grain.
- [ ] Test date, Year-Month, country, product, and channel filters.
- [ ] Test month-over-month calculations when the selected end date falls mid-month.
- [ ] Check fallback text for Improvements, Risks, and Action Points.
- [ ] Confirm Power BI refresh runs only after successful pipeline completion.
- [ ] Validate dashboard figures against source-level SQL aggregates before publishing.

## 13. Portfolio presentation

### Suggested project summary

Built an automated pharmaceutical enterprise analytics platform using AWS Lambda, EventBridge Scheduler, Amazon S3, Databricks Lakeflow, and Power BI. Implemented a Bronze/Silver/Gold lakehouse architecture, shared dimensional modelling, incremental file-arrival ingestion, and dependent semantic-model refresh orchestration. Developed executive and domain dashboards for supply chain, manufacturing, commercial demand, quality and regulatory, and clinical safety using reusable DAX measures and dynamic risk/action insights.

When presenting the project, explicitly disclose that the data is synthetic. Focus on architecture, modelling decisions, automation, validation, and dashboard design rather than claiming real pharmaceutical outcomes.

## 14. Reference configuration

| Component | Known project value |
|---|---|
| AWS S3 bucket | `my-projects-data-sherrif` |
| Lambda function | `daily_inventory_generator` |
| Databricks catalog | `prod_global` |
| Databricks Bronze schema | `bronze_layer` |
| Databricks Silver schema | `silver_layer` |
| Databricks Gold schema | `gold_layer` |
| Lakeflow pipeline | `pharm_data_pipeline` |
| Lakeflow Job Power BI task | `pharm_data_refresh` |
| Power BI connection | `power_bi_connection` |
| Power BI workspace | `Prod` |
| Power BI semantic model | `Pharma Dashboard` |
| File-arrival wait after last change | `00h05m` |

Some implementation details were not available in the documented project context, including the exact EventBridge cadence, complete Lambda source code, full SQL definitions for every Gold object, final Power BI relationship diagram, and validated status values for active trials/open safety cases. Record these from the deployed configuration rather than inferring them.
