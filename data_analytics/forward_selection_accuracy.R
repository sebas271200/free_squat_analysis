library(caret)

data_freesquat <- read.csv("C:/Users/josei/OneDrive/Documentos/CIIBI proyectos/Analisys Free Squat/database/data_freesquat.csv")

# Select the interest variables (omitting the ID column)
mydata <- data_freesquat[2:365]

# Define the dependent variable
y <- mydata$target

accuracy <- function(model, data, outcome) {
  predictions <- predict(model, data, type = "response")
  predictions <- ifelse(predictions > 0.5, 1, 0)
  mean(predictions == outcome)
}

# Null model (without predictors)
model_null <- glm(target ~ 1, data = mydata, family = binomial)

# List of all possible predictor variables
predictors <- names(mydata)[names(mydata) != "target"]

best_features <- c()
best_accuracy <- 0
current_model <- model_null

for (predictor in predictors) {
  temp_features <- c(best_features, predictor)
  temp_formula <- as.formula(paste("target ~", paste(temp_features, collapse = " + ")))
  temp_model <- glm(temp_formula, data = mydata, family = binomial)
  temp_accuracy <- accuracy(temp_model, mydata, mydata$target)
  
  if (temp_accuracy > best_accuracy) {
    best_accuracy <- temp_accuracy
    best_features <- temp_features
    current_model <- temp_model
  }
}

# Best model and obtained accuracy
print(best_features)
print(best_accuracy)
print(length(best_features))

best_formula <- as.formula(paste("target ~", paste(best_features, collapse = " + ")))

new_dataset <- mydata[best_features]
new_dataset$target <-mydata$target 

