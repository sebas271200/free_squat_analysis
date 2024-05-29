###Cargar libreria Galgo
library(galgo)
library(caret)
library(pROC)
library(e1071)

#Cargamos datos #De la base original se debe tranponer la parte de variables y generar otro csv
#Tambien se debe separar en otro archivo su clase
datos_sentadilla <- read.csv("C:/Users/guzma/OneDrive/MCPI/Proyectos/datos_sentadilla.csv", header=FALSE, row.names=1)
clase_sentadilla <- read.csv("C:/Users/guzma/OneDrive/MCPI/Proyectos/clase_sentadilla.csv", sep="", stringsAsFactors=TRUE)

#Primer paso configurar Galgo
bb.sentadilla = configBB.VarSel(
  data = datos_sentadilla, #datos de busqueda
  classes = clase_sentadilla$target, #Clases de los pacientes, FACTOR
  classification.method = "nearcent", 
  chromosomeSize = 5,
  maxSolutions = 726, #No de BB's #El doble de lo que se tenga mas 
  maxGenerations = 300, 
  goalFitness = 0.90, #alpha
  main = "Sentadilla",
  saveVariable = "bb.sentadilla",
  saveFrequency = 10,
  saveFile = "bb.sentadilla.rData"
)

blast(bb.sentadilla)

plot(bb.sentadilla, type="generankstability")

#USANDO LA LISTA ORDENADA DE MEJOR A PEOR CARACTERÍSTICA
#Crearemos un modelo usando la metodologia con la seleccion hacia delante
modelo_adelante = forwardSelectionModels(bb.sentadilla)

#El mejor es el #50 para mi caso
mejor_modelo = modelo_adelante$models[[1]]

#los nombres de las variables del mejor modelo
row.names(datos_sentadilla)[mejor_modelo]
