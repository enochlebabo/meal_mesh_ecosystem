 MealMesh Ecosystem
A modularized, full-stack food delivery platform featuring real-time data synchronization between customers, drivers, and vendors.
📁 Project Structure
This is a monorepo containing the following Flutter applications:
apps/meal_mesh_ios_user: The customer-facing iOS app for browsing restaurants and placing orders.
apps/meal_mesh_ios_driver: The driver app featuring live location tracking and order management.
apps/meal_mesh_web_admin: A centralized dashboard for platform-wide management.
apps/meal_mesh_web_restaurant: A dedicated portal for vendors to manage menus and incoming orders.
packages/: Shared business logic, UI components, and data models to ensure consistency across platforms.
firebase/: Configuration files for cloud functions, security rules, and database indexing.
