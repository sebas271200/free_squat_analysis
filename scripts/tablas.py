"""
@author: Pedro Emilio Mayorga Ruiz 
@date: 18 mayo 2024
@email: pedromayorga522@gmail.com 
"""
import pandas as pd  
import os

def calcular_estadisticas_y_sumar(df,num_sensor): 
    #Calcula las sumas y estadísticas para cada columna del DataFrame.
    #Parameters:
    #df (DataFrame): El DataFrame que contiene los datos originales.
    #Returns:
    #DataFrame: Un DataFrame que contiene las sumas y estadísticas calculadas.

    medias_df = pd.DataFrame()  # DataFrame vacío para almacenar las sumas de cada columna
    
    # Diccionario para almacenar DataFrames de estadísticas
    estadisticas_dict = {
        'mean': pd.DataFrame(),
        'variance': pd.DataFrame(),
        'skewness': pd.DataFrame(),
        'kurtosis': pd.DataFrame(),
        'standard_deviation': pd.DataFrame(),
        'max': pd.DataFrame(),
        'min': pd.DataFrame(),
        'dinamic_range': pd.DataFrame()
    }

    # Iterar sobre cada columna del DataFrame original
    for columna in df.columns[2:10]:
        datos_columna = df[columna]  # Extraer los datos de la columna actual
        #sumas = []  # Lista para almacenar las sumas de bloques de 180 filas
        medias = []  # Lista para almacenar las medias de bloques de 180 filas
        varianzas = []  # Lista para almacenar las varianzas de bloques de 180 filas
        asimetrias = []  # Lista para almacenar las asimetrías de bloques de 180 filas
        curtosis = []  # Lista para almacenar las curtosis de bloques de 180 filas
        desviaciones_estandar = []  # Lista para almacenar las desviaciones estándar de bloques de 180 filas
        maximos = []  # Lista para almacenar los valores máximos de bloques de 180 filas
        minimos = []
        rangos_dinamicos = []  # Lista para almacenar los rangos dinámicos de bloques de 180 filas
        
        init = 60 #para saltar el primer segundo donde se acomodan la barra
        
        # Iterar en bloques de 180 filas
        for i in range(init, len(df), 180):
            datos_bloque = datos_columna.iloc[i:i+180]  # Extraer un bloque de 180 filas
            #sumas.append(datos_bloque.sum())  # Calcular y almacenar la suma del bloque
            medias.append(datos_bloque.mean())  # Calcular y almacenar la media del bloque
            varianzas.append(datos_bloque.var())  # Calcular y almacenar la varianza del bloque
            asimetrias.append(datos_bloque.skew())  # Calcular y almacenar la asimetría del bloque
            curtosis.append(datos_bloque.kurtosis())  # Calcular y almacenar la curtosis del bloque
            desviaciones_estandar.append(datos_bloque.std())  # Calcular y almacenar la desviación estándar del bloque
            maximos.append(datos_bloque.max())  # Calcular y almacenar el valor máximo del bloque
            minimos.append(datos_bloque.min())  # Calcular y almacenar el valor mínimo del bloque
            rangos_dinamicos.append(datos_bloque.max() - datos_bloque.min())  # Calcular y almacenar el rango dinámico del bloque

        # Agregar las listas de sumas y estadísticas al DataFrame y diccionario correspondientes
        medias_df[f'{num_sensor}_{columna}_mean'] = medias  # Renombrar la columna para reflejar que contiene sumas
        estadisticas_dict['variance'][f'{num_sensor}_{columna}_variance'] = varianzas  # Renombrar la columna para reflejar que contiene varianzas
        estadisticas_dict['skewness'][f'{num_sensor}_{columna}_skewness'] = asimetrias  # Renombrar la columna para reflejar que contiene asimetrías
        estadisticas_dict['kurtosis'][f'{num_sensor}_{columna}_kurtosis'] = curtosis  # Renombrar la columna para reflejar que contiene curtosis
        estadisticas_dict['standard_deviation'][f'{num_sensor}_{columna}_standard_deviation'] = desviaciones_estandar  # Renombrar la columna para reflejar que contiene desviaciones estándar
        estadisticas_dict['max'][f'{num_sensor}_{columna}_max'] = maximos  # Renombrar la columna para reflejar que contiene máximos
        estadisticas_dict['min'][f'{num_sensor}_{columna}_min'] = minimos  # Renombrar la columna para reflejar que contiene mínimos
        estadisticas_dict['dinamic_range'][f'{num_sensor}_{columna}_dinamic_range'] = rangos_dinamicos  # Renombrar la columna para reflejar que contiene rangos dinámicos

    # Concatenar todas las estadísticas en un solo DataFrame
    resultados_df = medias_df  # Inicialmente, solo contiene las sumas
    for _, df_estadistica in estadisticas_dict.items():
        resultados_df = pd.concat([resultados_df, df_estadistica], axis=1)  # Añadir cada DataFrame de estadísticas

    return resultados_df


main_folder = "../../database/recordings_processed/"
type_patient = os.listdir(main_folder)

save_folder = "../../database/resume_dataset/"

for type in type_patient:

    patients = os.listdir(main_folder + type)
    for patient in patients:

        files = os.listdir(main_folder + type + "/" + patient)
        patient_df = pd.DataFrame()
        for file in files:
            archivo_csv = main_folder + type + "/" + patient + "/" + file
            num_sensor = file[6:11]

            df = pd.read_csv(archivo_csv)
            resultados_df = calcular_estadisticas_y_sumar(df,num_sensor)
            patient_df = pd.concat([patient_df, resultados_df], axis=1)
        new_file = save_folder + type + "/" + patient + ".csv"
        os.makedirs(os.path.dirname(new_file), exist_ok=True)
        patient_df.to_csv(new_file, index=False)
        print(f'Archivo guardado en: {new_file}')

