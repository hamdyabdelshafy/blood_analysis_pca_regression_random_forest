
# Import real data from Excel
# Load necessary library
library(readxl)

# Define the file path (ensure it matches the path used for exporting)
file_path <- "simulated_data.xlsx"

# Read the data from the Excel file
data <- read_excel(file_path)

# Display the first few rows of the imported data
head(data)


##################################
#### Diagnosing Using PCA
##################################


# Perform PCA on the blood parameters (excluding the response variable 'Glucose')
pca_result <- prcomp(data[, c("MDA", "Insulin")], scale. = TRUE)

# Display summary of PCA results
summary(pca_result)

# Create a PCA data frame
pca_data <- as.data.frame(pca_result$x)
pca_data$Groups <- data$Groups

# Plot PCA results
library(ggplot2)
ggplot(pca_data, aes(x = PC1, y = PC2, color = Groups)) +
  geom_point(size = 2) +
  labs(title = "PCA of MDA and Insulin",
       x = "Principal Component 1",
       y = "Principal Component 2") +
  theme_minimal()



# The PCA plot we've generated shows a clear separation between the diabetic and non-diabetic groups along the first principal component (PC1). 
# This separation suggests that PC1 captures most of the variation related to diabetes status.
# To determine which blood parameters are strongly related to diabetes, you should examine the loadings of each parameter on the principal components.
# The loadings indicate how much each original variable (blood parameter) contributes to each principal component.

# Extract the loadings (contributions of each variable to the principal components)
loadings <- pca_result$rotation

# Display the loadings for the first two principal components
loadings[, 1:2]



#################################
### Linear Regression Analysis
#################################

# Fit a linear regression model
linear_model <- lm(Glucose ~ MDA + Insulin + Groups, data = data)

# Summarize the model to see coefficients and p-values
summary(linear_model)

# Print coefficients and p-values
coefficients(linear_model)



##################
### Random forest
##################

# Load the randomForest package
if (!require(randomForest)) install.packages("randomForest", dependencies=TRUE)
library(randomForest)

# Fit the Random Forest model for regression
rf_model <- randomForest(Glucose ~ MDA + Insulin + Groups, data = data, ntree = 100)

# Print the model summary
print(rf_model)

# Predict on the data
predictions <- predict(rf_model, newdata = data)

# Calculate the R-squared and other metrics
actuals <- data$Glucose
rss <- sum((predictions - actuals)^2)
tss <- sum((actuals - mean(actuals))^2)
rsq <- 1 - (rss / tss)
cat("R-squared:", rsq, "\n")

# Plot feature importance
importance_plot <- importance(rf_model)
print(importance_plot)

# Create a feature importance plot
importance_df <- as.data.frame(importance_plot)
importance_df$Feature <- rownames(importance_df)

# Create a feature importance plot
ggplot(importance_df, aes(x = reorder(Feature, IncNodePurity), y = IncNodePurity)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Feature Importance from Random Forest",
       x = "Feature",
       y = "IncNodePurity") +
  theme_minimal()

# Use IncNodePurity for plotting since IncMSE is not available
ggplot(importance_df, aes(x = reorder(Feature, IncNodePurity), y = IncNodePurity)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Feature Importance from Random Forest",
       x = "Feature",
       y = "Increase in Node Purity") +
  theme_minimal()




#############

# Load necessary libraries
library(ggplot2)
library(ggthemes)  # For additional themes and color palettes

# Calculate feature importance
importance_df <- as.data.frame(importance_plot)
importance_df$Feature <- rownames(importance_df)
importance_df <- importance_df[order(importance_df$IncNodePurity, decreasing = TRUE), ]

# Create a more attractive plot
ggplot(importance_df, aes(x = reorder(Feature, IncNodePurity), y = IncNodePurity, fill = Feature)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  coord_flip() +
  scale_fill_brewer(palette = "Set3") +  # Use a color palette for better visual appeal
  labs(title = "Feature Importance from Random Forest",
       x = "Feature",
       y = "IncNodePurity") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 12, color = "black"),
        axis.title = element_text(size = 14),
        plot.title = element_text(size = 16, face = "bold"),
        panel.grid.major = element_line(color = "grey90"),
        panel.grid.minor = element_line(color = "grey95"))


# Enhanced feature importance plot as a dot plot with error bars
ggplot(importance_df, aes(x = reorder(Feature, IncNodePurity), y = IncNodePurity)) +
  geom_point(size = 4, color = "blue") +
  geom_errorbar(aes(ymin = IncNodePurity - sd(IncNodePurity), ymax = IncNodePurity + sd(IncNodePurity)), width = 0.2) +
  coord_flip() +
  labs(title = "Feature Importance from Random Forest (Dot Plot)",
       x = "Feature",
       y = "IncNodePurity") +
  theme_classic() +
  theme(axis.text.y = element_text(size = 12, color = "black"),
        axis.title = element_text(size = 14),
        plot.title = element_text(size = 16, face = "bold"),
        panel.grid.major = element_line(color = "grey90"))



# Simulate average values for each feature (for illustrative purposes)
importance_df$AvgValue <- runif(nrow(importance_df), min = 0, max = 100)

# Bubble plot for feature importance
ggplot(importance_df, aes(x = reorder(Feature, IncNodePurity), y = IncNodePurity, size = AvgValue, color = IncNodePurity)) +
  geom_point(alpha = 0.7) +
  scale_size(range = c(3, 15), name = "Average Value") +
  scale_color_gradient(low = "lightblue", high = "darkblue") +
  coord_flip() +
  labs(title = "Feature Importance from Random Forest (Bubble Plot)",
       x = "Feature",
       y = "IncNodePurity") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 12, color = "black"),
        axis.title = element_text(size = 14),
        plot.title = element_text(size = 16, face = "bold"))


