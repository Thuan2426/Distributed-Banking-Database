# 🏦 Distributed Banking Database System (Techcombank Simulation)

## 📌 Project Overview
This project simulates a distributed database architecture for Techcombank, a leading commercial bank in Vietnam. The system is designed to handle high-volume credit transactions across 3 regional sites (North, Central, and South) using **SQL Server**, ensuring High Availability and optimizing Query Performance.

## 🛠️ Tech Stack
* **Database Engine:** Microsoft SQL Server
* **Techniques:** Data Fragmentation, Replication, Distributed Views, Two-Phase Commit (2PC), Stored Procedures, Triggers.

## 🚀 Key Features
* **16-Entity Database Design:** Designed a comprehensive Global Schema covering Branches, Employees, Customers, Contracts, and Transactions.
* **Data Fragmentation:** Implemented Primary and Derived Horizontal Fragmentation based on geographical locations to optimize local query latency.
* **Data Replication:** Applied Full Replication for low-update, high-query configuration tables (e.g., Interest Rates).
* **Distributed Reporting Views:** Created `Distributed Partitioned Views` to aggregate cross-site financial data (total balance, total debt) for the Head Office.
* **Secure Distributed Transactions:** Developed Stored Procedures utilizing Two-Phase Commit (2PC) for cross-branch money transfers, ensuring ACID properties and rollback mechanisms.

## 📂 Repository Structure
* `CREATEDATABASE.sql`: Global schema definition.
* `USEDATABASE_Site...sql`: Local database setup for each regional branch.
* `SQLProgramming.sql`: Advanced SQL scripts including Views, Triggers, and Stored Procedures.
* `Techcombank_Distributed_DB_Report.pdf`: Full project documentation and Relational Algebra Query Tree optimization.


