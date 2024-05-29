library(caret)

datos = new_dataset

#Seperamos en conjunto A (80%) y Conjunto B (20%)
indices<-createDataPartition(datos$target,
                             times=1,
                             p=0.8, #proporcion de los datos 80% entrenamiento 
                             list=FALSE) #Indica que los índices se devolverán como un vector en lugar de una lista.

datosA<-datos[indices,] #contendrá el 80% de los datos originales, seleccionados aleatoriamente.
datosB<-datos[-indices,] # contendrá el 20% restante de los datos originales, que no están presentes en datosA.


#validación Cruzada ( crossvalidation k =3)
#divide los datos de entrenamiento para (datos) en k conjutos diferentes
indicesTrain <-createFolds(y=datosA$target,
                           k=3, list=TRUE, #Se devolveran como una lista
                           returnTrain = TRUE) #Se devolderan los indices 


##empezamos con  Fold 1
datosEntrenamientoFold <-datosA[indicesTrain$Fold1,]#Selecciona los datos de entrenamiento para el primer pliegue de la validación cruzada.
datosPruebaFold <-datosA[-indicesTrain$Fold1,] #contiene los índices de las filas en datosA que se utilizarán como datos de entrenamiento para este pliegue. Por lo tanto, 
#datosEntrenamientoFold contendrá las filas de datosA correspondientes a este primer pliegue.
#Entrenamos el modelo
modelofold<-glm("target ~ .", 
                data=datosEntrenamientoFold[,c(best_features,"target")],
                family="binomial")

#obtenemos el AUC de ENTRENAMIENTO en el FOLD
library(pROC)
prediccionesFold <-predict(modelofold, newdata = datosEntrenamientoFold,
                           type="response")
tablita<-data.frame(Original = datosEntrenamientoFold$target,
                    Predicciones = prediccionesFold)
mi_curva <- roc(tablita$Original, tablita$Predicciones,
                levels=c(0,1), plot = TRUE, ci=TRUE,
                smooth=FALSE, direction='auto', col="blue",
                main="Mi curva chida")
mi_curva$auc
#obtenemos el AUC de PRUEBA en el FOLD
prediccionesFold <-predict(modelofold, newdata = datosPruebaFold,
                           type="response")
tablita<-data.frame(Original = datosPruebaFold$target,
                    Predicciones = prediccionesFold)
mi_curva <- roc(tablita$Original, tablita$Predicciones,
                levels=c(0,1), plot = TRUE, ci=TRUE,
                smooth=FALSE, direction='auto', col="blue",
                main="Mi curva chida")
mi_curva$auc




##empezamos con  Fold 2
datosEntrenamientoFold <-datosA[indicesTrain$Fold2,]
datosPruebaFold <-datosA[-indicesTrain$Fold2,]
#Entrenamos el modelo
modelofold<-glm("target ~ .", 
                data=datosEntrenamientoFold[,c(best_features,"target")],
                family="binomial")
#obtenemos el AUC de ENTRENAMIENTO en el FOLD
library(pROC)
prediccionesFold <-predict(modelofold, newdata = datosEntrenamientoFold,
                           type="response")
tablita<-data.frame(Original = datosEntrenamientoFold$target,
                    Predicciones = prediccionesFold)
mi_curva <- roc(tablita$Original, tablita$Predicciones,
                levels=c(0,1), plot = TRUE, ci=TRUE,
                smooth=FALSE, direction='auto', col="blue",
                main="Mi curva chida")
mi_curva$auc
#obtenemos el AUC de PRUEBA en el FOLD
prediccionesFold <-predict(modelofold, newdata = datosPruebaFold,
                           type="response")
tablita<-data.frame(Original = datosPruebaFold$target,
                    Predicciones = prediccionesFold)
mi_curva <- roc(tablita$Original, tablita$Predicciones,
                levels=c(0,1), plot = TRUE, ci=TRUE,
                smooth=FALSE, direction='auto', col="blue",
                main="Mi curva chida")
mi_curva$auc




##empezamos con  Fold 3
datosEntrenamientoFold <-datosA[indicesTrain$Fold3,]
datosPruebaFold <-datosA[-indicesTrain$Fold3,]
#Entrenamos el modelo
modelofold<-glm("target ~ .", 
                data=datosEntrenamientoFold[,c(best_features,"target")],
                family="binomial")
#obtenemos el AUC de ENTRENAMIENTO en el FOLD
library(pROC)
prediccionesFold <-predict(modelofold, newdata = datosEntrenamientoFold,
                           type="response")
tablita<-data.frame(Original = datosEntrenamientoFold$target,
                    Predicciones = prediccionesFold)


mi_curva <- roc(tablita$Original, tablita$Predicciones,
                levels=c(0,1), plot = TRUE, ci=TRUE,
                smooth=FALSE, direction='auto', col="blue",
                main="Mi curva chida")
mi_curva$auc



#obtenemos el AUC de PRUEBA en el FOLD
prediccionesFold <-predict(modelofold, newdata = datosPruebaFold,
                           type="response")
tablita<-data.frame(Original = datosPruebaFold$target,
                    Predicciones = prediccionesFold)


mi_curva <- roc(tablita$Original, tablita$Predicciones,
                levels=c(0,1), plot = TRUE, ci=TRUE,
                smooth=FALSE, direction='auto', col="blue",
                main="Mi curva chida")
mi_curva$auc




#Procedemos a crear un modelo representativo entrenado en su totalidad
#en el conjunto A(80%), obtendremos el desempeño en el mismo conjunto
#Entrenamos el modelo
modeloRepresentativo<-glm("target ~ .", 
                          data=datosA[,c(best_features,"target")],
                          family="binomial")

#obtenemos el AUC de ENTRENAMIENTO
library(pROC)
prediccionesA <-predict(modeloRepresentativo, 
                        newdata = datosA,
                        type="response")

tablita<-data.frame(Original = datosA$target,
                    Predicciones = prediccionesA)

#Binarizamos nuestras predicciones
predicciones_binarizadas = prediccionesA
predicciones_binarizadas[predicciones_binarizadas<0.5]=0
predicciones_binarizadas[predicciones_binarizadas>=0.5]=1



tablita1<-data.frame(Original = datosA$target,
                     Predicciones = predicciones_binarizadas)

mi_curva <- roc(tablita$Original, tablita$Predicciones,
                levels=c(0,1), plot = TRUE, ci=TRUE,
                smooth=FALSE, direction='auto', col="blue",
                main="Mi curva chida")


mi_curva$auc

#Obtenemos especifidad del entrenamiento
confusionMatrix(data = as.factor(tablita1$Predicciones),
                reference = as.factor(tablita1$Original),
                positive = '1')

###### Ahora usando este modelo representativo, vamos  obtener su desempeño en los
#datos del conjunto B (Prueba ciega/ Blind test)
prediccionesB <-predict(modeloRepresentativo, 
                        newdata = datosB,
                        type="response")
tablita<-data.frame(Original = datosB$target,
                    Predicciones = prediccionesB)
#Binarizamos nuestras predicciones
predicciones_binarizadas = prediccionesA
predicciones_binarizadas[predicciones_binarizadas<0.5]=0
predicciones_binarizadas[predicciones_binarizadas>=0.5]=1



tablita1<-data.frame(Original = datosA$target,
                     Predicciones = predicciones_binarizadas)



mi_curva <- roc(tablita$Original, tablita$Predicciones,
                levels=c(0,1), plot = TRUE, ci=TRUE,
                smooth=FALSE, direction='auto', col="blue",
                main="Mi curva chida")
mi_curva$auc

#Obtenemos especifidad del entrenamiento
confusionMatrix(data = as.factor(tablita1$Predicciones),
                reference = as.factor(tablita1$Original),
                positive='1')
