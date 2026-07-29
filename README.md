# 🎬 Netflix Streaming Platform Analytics Database

### Designing a Scalable Relational Database for Streaming Platform Operations

*SQL-Based Database System for Managing Users, Content, Subscriptions, Watch History, Ratings, Payments, and Business Analytics*

---

![ER Diagram](Images/ER_Diagram.png)

---

# 📊 Database Overview

| Metric | Value |
|---------|------:|
| Database | Netflix Streaming Platform |
| Database Type | Relational Database |
| Tables | 16 |
| Normalization | Third Normal Form (3NF) |
| Primary Keys | 16 |
| Foreign Key Relationships | 20+ |
| Business Queries | 25+ |
| SQL Triggers | 4 |
| SQL Events | 1 |
| Database Engine | MySQL |

---

# 🎯 Business Problem

Streaming platforms generate millions of user interactions every day, including subscriptions, payments, content browsing, watch history, ratings, and personalized viewing activity. Managing this large volume of data without a structured relational database can lead to duplicate records, inconsistent information, inefficient reporting, and poor business visibility.

This project was developed to design a fully normalized relational database that centralizes streaming platform operations, maintains data integrity, and supports analytical reporting for business decision-making.

The system addresses key business questions such as:

- Which movies and TV shows receive the highest audience engagement?
- Which subscription plans generate the highest revenue?
- Which users spend the most time watching content?
- How do viewing patterns change over time?
- Which content receives the highest customer ratings?
- How can repetitive platform operations be automated using SQL?

---

# 📈 Executive Summary

The Netflix Streaming Platform Analytics Database was designed to centralize user management, subscription plans, payments, content information, watch history, ratings, watchlists, creators, languages, regions, devices, and notifications within a single relational database.

The database minimizes redundancy through normalization while maintaining referential integrity across all business entities. SQL-based analytical queries provide valuable insights into user engagement, subscription performance, revenue trends, content popularity, multilingual availability, and viewing behavior.

Automated business rules further improve operational efficiency by validating content records, updating subscription status after successful payments, restricting unauthorized content modifications, revoking user access after subscription cancellation, and generating subscription expiry notifications.

Overall, this project demonstrates how SQL can be used to build scalable database systems that support both operational management and business analytics for modern subscription-based streaming platforms.

---

# 🔍 Business Query Analysis

| Business Area | Business Question | Business Value |
|-------------------------|-----------------------------------------------------------------------|----------------------------------------------------------------|
| 👥 User Analytics | Identify the most active users based on viewing activity. | Understand customer engagement and platform usage. |
| 🎬 Content Performance | Retrieve the most-watched movies during the latest three months. | Evaluate audience preferences and content popularity. |
| 📺 Upcoming Releases | Identify TV shows scheduled for release within the next six months. | Support release planning and content scheduling. |
| 🌍 Language Analytics | Retrieve titles available in both English and Spanish. | Analyze multilingual content availability. |
| ⭐ Rating Analysis | Identify movies receiving consistently low ratings. | Support content quality evaluation. |
| 💳 Subscription Analytics | Analyze subscription cancellations over the latest six months. | Monitor customer retention trends. |
| 💰 Revenue Reporting | Generate monthly subscription revenue for the latest twelve months. | Track revenue growth and business performance. |
| 🎥 Director Performance | Identify the highest-rated directors based on average content ratings. | Evaluate creator performance. |
| 📑 Watchlist Analysis | Find users with multiple unwatched titles in their watchlist. | Understand future viewing intent. |
| ⏱ Viewing Behaviour | Identify users who partially watched multiple titles. | Analyze content completion behavior and user engagement. |

---

# ⚙ Business Automation

| Business Rule | Business Value |
|-------------------------------|--------------------------------------------------------------------------------|
| 💳 Subscription Status Automation | Automatically updates subscription status after successful payment, reducing manual intervention. |
| ❌ User Access Management | Revokes user access automatically after subscription cancellation. |
| ✅ Content Validation | Prevents invalid content records from being inserted into the database. |
| 🎬 Verified Creator Validation | Ensures only verified creators can update content information. |
| ⏰ Subscription Expiry Notifications | Automatically generates notifications before subscription expiration. |

---

# 🏗 Database Architecture

The database consists of sixteen normalized tables organized into five major business modules.

### 👤 User Management

- Users
- Devices
- Notifications

### 💳 Subscription Management

- Subscription Plans
- Subscriptions
- Payments

### 🎬 Content Management

- Content
- Creators
- Genres
- Content Genres
- Content Languages
- Content Regions

### 📊 User Engagement

- Watch History
- Ratings
- Watchlist

### 🔗 Relationship Management

- Content Genres (Many-to-Many Mapping)

---

# 🧩 Database Design

The database follows **Third Normal Form (3NF)** to reduce redundancy, improve consistency, and maintain efficient relationships between entities.

### Key Relationships

- One User → Multiple Subscriptions
- One User → Multiple Payments
- One User → Multiple Watch History Records
- One User → Multiple Ratings
- One User → Multiple Watchlist Items
- One Subscription Plan → Multiple Users
- One Creator → Multiple Content Titles
- One Content → Multiple Ratings
- One Content → Multiple Languages
- One Content → Multiple Regions
- One Content → Multiple Genres

---

# ⭐ Key Features

- Fully Normalized Relational Database (3NF)
- User & Account Management
- Subscription Plan Management
- Payment Tracking
- Content Library Management
- Watch History Analytics
- Ratings & Reviews
- Watchlist Management
- Device Management
- Notification System
- Revenue Reporting
- Business Analytics Queries
- SQL Triggers
- SQL Events
- Data Validation & Integrity

---

# 🛠 Technologies Used

| Category | Technologies |
|----------|--------------|
| Database | MySQL |
| Query Language | SQL |
| Database Design | MySQL Workbench |
| Data Modeling | Enhanced Entity Relationship Diagram (ERD) |
| SQL Concepts | Joins, Aggregate Functions, Subqueries, Triggers, Events |

---

# 💡 Project Outcomes

- Designed a scalable relational database for a subscription-based streaming platform.
- Applied database normalization to improve data consistency and reduce redundancy.
- Developed SQL queries that generate meaningful business insights from streaming data.
- Implemented SQL Triggers and Events to automate routine platform operations.
- Demonstrated how SQL supports operational efficiency, reporting, and data-driven decision-making.

---

# 🚀 Future Enhancements

- Recommendation Engine Support
- Stored Procedures for Business Operations
- SQL Views for Executive Reporting
- Role-Based Access Control
- Performance Optimization
- Business Intelligence Dashboard Integration

---

