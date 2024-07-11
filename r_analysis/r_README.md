# R Analysis: Spotify Data

## Overview
This part of the project contains R scripts for analyzing the Spotify playlist data imported into MySQL. The main feature is a Shiny app that allows users to interactively explore their data. Additionally, static plots are provided as examples of visualizations users can create.

## Project Structure
- `shiny.r`: R script for the Shiny app to analyze data.
- `plots.r`: R script for generating static plots based on the data.

## Setup and Usage
### Prerequisites
- R (version 4.0 or later)
- R packages: `shiny`, `DBI`, `RMySQL`, `ggplot2`, `dplyr`, `tidyr`

### Installation
1. **Install R Packages:**
   Install the required R packages:
    ```r
    install.packages(c("shiny", "DBI", "RMySQL", "ggplot2", "dplyr", "tidyr"))
    ```

### Running the Shiny App
1. **Update Database Connection Details:**
   - Open the `shiny.r` script.
   - Update the database connection details with your MySQL database credentials.

2. **Run the Shiny App:**
    ```r
    shiny::runApp("shiny.r")
    ```

### Generating Static Plots
1. **Update Database Connection Details:**
   - Open the `plots.r` script.
   - Update the database connection details with your MySQL database credentials.

2. **Generate Plots:**
    ```r
    source("plots.r")
    ```

   The static plots will be generated and saved in the `example_plots/` folder.

## Example Plots
Below are examples of the static plots you can create using the `plots.r` script:

<div align="center">
  <img src="./examples/plot1.png" alt="Plot 1" width="600">
  <p>Figure 1: Description of Plot 1.</p>

  <img src="./examples/plot2.png" alt="Plot 2" width="600">
  <p>Figure 2: Description of Plot 2.</p>

  <img src="./examples/plot3.png" alt="Plot 3" width="600">
  <p>Figure 3: Description of Plot 3.</p>
</div>

## License
This project is licensed under the MIT License.

## Acknowledgements
- This project uses the [Shiny library](https://shiny.rstudio.com/) for building the interactive web application.
