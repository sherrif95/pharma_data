# Pharma Enterprise Data Platform

An end-to-end pharmaceutical data engineering and business intelligence project built with AWS, Databricks, and Power BI.

## Overview

This project demonstrates how pharmaceutical operational data can be generated, ingested, transformed, modelled, and presented through interactive analytics dashboards. It covers the journey from cloud-based data generation to executive decision support.

All data used in this project is synthetic and intended for demonstration purposes.

## Architecture

EventBridge Scheduler → AWS Lambda → Amazon S3 → Databricks Lakeflow → Bronze → Silver → Gold → Power BI

A Databricks job orchestrates the data pipeline and triggers the Power BI semantic model refresh after successful pipeline execution.

## Technology Stack

- **AWS:** EventBridge Scheduler, Lambda, Amazon S3
- **Data Engineering:** Databricks Lakeflow, SQL, Bronze/Silver/Gold architecture
- **Business Intelligence:** Power BI, DAX, Power Query
- **Automation:** File-arrival triggers and dependent semantic model refresh

## Analytics Domains

- Supply Chain and Inventory
- Manufacturing
- Commercial Sales and Demand Planning
- Quality and Regulatory
- Clinical Trials and Safety

## Key Capabilities

- Automated generation of synthetic pharmaceutical datasets
- Incremental ingestion from Amazon S3
- Layered lakehouse transformations
- Shared dimensional modelling and analytical fact tables
- Executive and domain-specific dashboards
- KPI monitoring and month-over-month comparisons
- Dynamic improvement, risk, and action insights
- Automated Power BI semantic model refresh

## Repository Structure

- `pharm_data_pipeline/transformations/`: Databricks transformation assets
- `docs/`: Project technical documentation
- `aws/`: AWS Lambda and configuration examples
- `power-bi/`: Dashboard screenshots and measures
- `architecture/`: Architecture diagrams

Additional folders will contain implementation assets as they are added.

## Data Disclaimer

This project uses synthetic data. It does not represent actual patients, clinical trials, pharmaceutical operations, suppliers, or commercial transactions.

## Documentation

See the TECHNICAL_DOCUMENTATION.md for the detailed project documentation covering the architecture, data layers, modelling, Power BI reporting, automation, and validation.
