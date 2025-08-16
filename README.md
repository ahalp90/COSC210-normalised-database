# COSC210 Practical SQL Assignment: MovieDirect Database

This repository contains the SQL solution for the COSC210 Practical Assignment. The objective of this assignment is to construct a series of SQL views to query and analyse data from the "MovieDirect" database, a fictional movie shipment company.

The solution is provided in a single SQL script file, which defines eight distinct views as per the assignment requirements.

## Repository Contents

*   `README.md`: This file, providing an overview of the project and setup instructions.
*   `MovieDirect_Data.sql`: The SQL script required to create the database schema (tables) and populate them with the necessary data.
*   `cosc210_assignment.sql` (or your file name): The main SQL script containing the `CREATE VIEW` statements for the assignment.

## Setup and Usage

To run this project and test the views, follow these steps:

1.  **Create a Database**: In your chosen SQL environment (e.g., PostgreSQL, MySQL, SQL Server), create a new, empty database.
2.  **Load Data**: Execute the `MovieDirect_Data.sql` script. This will create the required tables (`Movies`, `Customers`, `Stock`, `Shipments`) and insert the sample data.
3.  **Create Views**: Execute the main assignment script (`cosc210_assignment.sql`). This will create all the views specified in the assignment brief.
4.  **Query the Views**: You can now query the data using the views. For example:
    ```sql
    SELECT * FROM movie_summary;
    SELECT * FROM binge_watcher;
    ```

---

## Views Created

This section details each of the views created as part of the assignment.

#### 1. `movie_summary(movie_title, release_date, media_type, retail_price)`
Provides a simple summary of each movie available in stock, combining information from the `Movies` and `Stock` tables.

#### 2. `old_shipments(first_name, last_name, movie_id, shipment_id, shipment_date)`
Lists all historical shipments that occurred before 1 January 2010, including the name of the customer who received the shipment.

#### 3. `richie(movie_title)`
Finds all movies in the database directed by Ron Howard.

#### 4. `retail_price_hike(movie_id, retail_price, new_price)`
Calculates a potential new retail price for all items in stock. The `new_price` column represents a 25% increase on the current `retail_price`.

#### 5. `profits_from_movie(movie_id, movie_title, total_profit)`
Calculates the total profit generated from movies that have been shipped. Profit is calculated as the sum of retail prices minus the sum of cost prices for all shipped units of a particular movie. The view only includes movies that have at least one shipment record.

#### 6. `binge_watcher(first_name, last_name)`
Identifies customers who can be considered "binge watchers" by finding those who have had more than one movie shipped to them on the same day.

#### 7. `the_sith(first_name, last_name)`
Lists all customers who have **never** had the movie 'Star Wars: Episode V - The Empire Strikes Back' shipped to them. This is achieved using a `NOT EXISTS` subquery to filter the customer list.

#### 8. `sole_angry_man(first_name, last_name)`
A more complex view that identifies the customer who had '12 Angry Men' shipped, but **only if** they were the single, sole customer to have ever received that movie. If more than one customer has received the movie, this view will return no results.

---

## Implementation Notes and Assumptions

During the implementation, several assumptions were made based on the provided instructions.

*   **Output Ordering**: The instructions did not specify any ordering requirements for the view outputs. As such, `ORDER BY` clauses have been omitted.
*   **Rounding**: No instructions were given for rounding financial calculations. Therefore, values in `retail_price_hike` and `profits_from_movie` are returned as precise floating-point numbers. In a production environment, these would likely be rounded to two decimal places.
*   **Distinct Values**: The use of `SELECT DISTINCT` was not explicitly requested. For views like `richie` or `binge_watcher`, this means a movie title or customer name could potentially appear multiple times if the underlying data structure allowed for it. The current implementation follows the instructions literally.
*   **Grouping Logic**: In views requiring aggregation (e.g., `profits_from_movie`), grouping has been performed by the primary key (`movie_id`) in addition to other attributes like `movie_title` to ensure correct and unambiguous aggregation.
