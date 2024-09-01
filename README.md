### Author: Hamdy Abdel-Shafy
### Date: September 2024
### Affiliation: Department of Animal Production, Cairo University, Faculty of Agriculture

## Overview

This script is designed to import, analyze, and visualize data related to blood parameters, specifically focusing on glucose, MDA, and insulin levels across different groups.
The analysis includes Principal Component Analysis (PCA), Linear Regression, and Random Forest modeling to explore relationships and feature importance.

### Table of Contents
1. [Requirements](#requirements)
2. [Installation](#installation)
3. [Data Import](#data-import)
4. [Principal Component Analysis (PCA)](#principal-component-analysis-pca)
5. [Linear Regression Analysis](#linear-regression-analysis)
6. [Random Forest Analysis](#random-forest-analysis)
7. [Feature Importance Visualization](#feature-importance-visualization)
8. [Running the Script](#running-the-script)

---

## Requirements

Before running this script, ensure you have the following R packages installed:

- `readxl`: For importing Excel files.
- `ggplot2`: For creating visualizations.
- `randomForest`: For building random forest models.
- `ggthemes`: For additional themes and color palettes in plots.

You can install these packages by running:

```r
install.packages(c("readxl", "ggplot2", "randomForest", "ggthemes"))
```

## Installation

1. Clone or download the script to your local machine.
2. Ensure that the Excel file `simulated_data.xlsx` is in the same directory as the script.

## Data Import

The script starts by importing real data from an Excel file named `simulated_data.xlsx`. The file path is specified, and the `read_excel()` function from the `readxl` package is used to load the data into R.

```r
file_path <- "simulated_data.xlsx"
data <- read_excel(file_path)
head(data)
```

### Explanation:
- **`file_path`**: The location of your Excel file. Make sure this path is correct.
- **`read_excel(file_path)`**: Reads the data from the specified Excel file.
- **`head(data)`**: Displays the first few rows of the dataset to confirm it has been loaded correctly.

## Principal Component Analysis (PCA)

PCA is used to reduce the dimensionality of the dataset by transforming the original variables into a set of linearly uncorrelated components.

```r
pca_result <- prcomp(data[, c("MDA", "Insulin")], scale. = TRUE)
summary(pca_result)
pca_data <- as.data.frame(pca_result$x)
pca_data$Groups <- data$Groups

ggplot(pca_data, aes(x = PC1, y = PC2, color = Groups)) +
  geom_point(size = 2) +
  labs(title = "PCA of MDA and Insulin",
       x = "Principal Component 1",
       y = "Principal Component 2") +
  theme_minimal()
```

### Explanation:
- **`prcomp()`**: Performs PCA on the MDA and Insulin variables, standardizing them.
- **`summary(pca_result)`**: Displays the proportion of variance explained by each principal component.
- **`ggplot()`**: Plots the first two principal components to visualize the separation between groups.

## Linear Regression Analysis

A linear regression model is fitted to predict glucose levels using MDA, Insulin, and Group as predictor variables.

```r
linear_model <- lm(Glucose ~ MDA + Insulin + Groups, data = data)
summary(linear_model)
coefficients(linear_model)
```

### Explanation:
- **`lm()`**: Fits a linear model where Glucose is the dependent variable and MDA, Insulin, and Groups are independent variables.
- **`summary()`**: Provides a summary of the model, including coefficients and p-values.
- **`coefficients()`**: Extracts the coefficients of the model.

## Random Forest Analysis

A random forest model is trained to predict glucose levels using the same predictors. The model's performance is evaluated, and the importance of each feature is calculated.

```r
rf_model <- randomForest(Glucose ~ MDA + Insulin + Groups, data = data, ntree = 100)
print(rf_model)

predictions <- predict(rf_model, newdata = data)
rss <- sum((predictions - actuals)^2)
tss <- sum((actuals - mean(actuals))^2)
rsq <- 1 - (rss / tss)
cat("R-squared:", rsq, "\n")
```

### Explanation:
- **`randomForest()`**: Trains a random forest model with 100 trees.
- **`predict()`**: Predicts glucose levels using the trained model.
- **`R-squared`**: A statistical measure that represents the proportion of variance for the dependent variable that's explained by the independent variables.

## Feature Importance Visualization

The importance of each feature in predicting glucose levels is visualized using different types of plots, such as bar plots, dot plots, and bubble plots.

```r
importance_plot <- importance(rf_model)
importance_df <- as.data.frame(importance_plot)
importance_df$Feature <- rownames(importance_df)

ggplot(importance_df, aes(x = reorder(Feature, IncNodePurity), y = IncNodePurity)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Feature Importance from Random Forest",
       x = "Feature",
       y = "Increase in Node Purity") +
  theme_minimal()
```

### Explanation:
- **`importance()`**: Calculates the importance of each feature.
- **`ggplot()`**: Creates various types of plots to visualize feature importance.

## Running the Script

1. Make sure you have installed all the required R packages.
2. Place your Excel file (`simulated_data.xlsx`) in the same directory as this script.
3. Run the script in R or RStudio.

The script will:
- Import the data from Excel.
- Perform PCA to analyze and visualize the relationship between blood parameters.
- Fit a linear regression model to predict glucose levels.
- Train a random forest model to further analyze feature importance.
- Visualize the importance of each feature in predicting glucose levels.

---

## License

This project is licensed under the [MIT License](LICENSE).

