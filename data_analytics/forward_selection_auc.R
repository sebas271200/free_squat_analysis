library(caret)
library(ROCR)

# Leer los datos
data_freesquat <- read.csv("C:/Users/josei/OneDrive/Documentos/CIIBI proyectos/Analisys Free Squat/database/data_freesquat.csv")

# Seleccionar las variables de interés (omitir la columna ID)
mydata <- data_freesquat[2:365]

accuracy <- function(model, data, outcome) {
  predictions <- predict(model, data, type = "response")
  predictions <- ifelse(predictions > 0.5, 1, 0)
  mean(predictions == outcome)
}

# Función para calcular AUC
calculate_auc <- function(model, data, outcome) {
  predictions <- predict(model, data, type = "response")
  pred_obj <- prediction(predictions, outcome)
  auc <- as.numeric(performance(pred_obj, "auc")@y.values[[1]])
  return(auc)
}

# Modelo nulo (sin predictores)
model_null <- glm(target ~ 1, data = mydata, family = binomial)

# Lista de todas las variables predictoras posibles
predictors <- names(mydata)[names(mydata) != "target"]

best_features <- c()
best_auc <- 0
current_model <- model_null

for (predictor in predictors) {
  temp_features <- c(best_features, predictor)
  temp_formula <- as.formula(paste("target ~", paste(temp_features, collapse = " + ")))
  temp_model <- glm(temp_formula, data = mydata, family = binomial)
  temp_auc <- calculate_auc(temp_model, mydata, mydata$target)
  
  if (temp_auc > best_auc) {
    best_auc <- temp_auc
    best_features <- temp_features
    current_model <- temp_model
  }
}

# Fórmula del modelo con las mejores características
best_formula <- as.formula(paste("target ~", paste(best_features, collapse = " + ")))

# Ajustar el modelo final
final_model <- glm(best_formula, data = mydata, family = binomial)

# Visualización de la curva ROC y cálculo del AUC
predictions <- predict(final_model, mydata, type = "response")
roc_obj <- prediction(predictions, mydata$target)
roc_perf <- performance(roc_obj, "tpr", "fpr")

# Graficar la curva ROC
plot(roc_perf, main = "Curva ROC", col = "blue", lwd = 2)

# Calcular el AUC
auc_value <- performance(roc_obj, "auc")@y.values[[1]]
print(paste("AUC:", auc_value))

# Calcular accuracy del modelo final
final_accuracy <- accuracy(final_model, mydata, mydata$target)


# Mejor modelo y AUC obtenido
print("Mejores características:")
print(best_features)
print(length(best_features))
print(paste("AUC:", best_auc))

# Mostrar el accuracy del modelo final
print(paste("ACC:",final_accuracy))

new_dataset <- mydata[best_features]
new_dataset$target <-mydata$target 
