"""
@author: Pedro Emilio Mayorga Ruiz 
@date: 18 mayo 2024
@email: pedromayorga522@gmail.com 
"""
import pandas as pd  # Importa la biblioteca pandas para la manipulación de datos
import numpy as np  # Importa la biblioteca numpy para operaciones numéricas
import os  # Importa la biblioteca os para interactuar con el sistema operativo

def calcular_estadisticas_y_sumar(df):
    
    #Calcula las sumas y estadísticas para cada columna del DataFrame.
    #Parameters:
    #df (DataFrame): El DataFrame que contiene los datos originales.
    #Returns:
    #DataFrame: Un DataFrame que contiene las sumas y estadísticas calculadas.

    sumas_df = pd.DataFrame()  # DataFrame vacío para almacenar las sumas de cada columna
    
    # Diccionario para almacenar DataFrames de estadísticas
    estadisticas_dict = {
        'media': pd.DataFrame(),
        'varianza': pd.DataFrame(),
        'asimetria': pd.DataFrame(),
        'curtosis': pd.DataFrame(),
        'desviacion_estandar': pd.DataFrame(),
        'maximo': pd.DataFrame(),
        'rango_dinamico': pd.DataFrame()
    }

    # Iterar sobre cada columna del DataFrame original
    for columna in df.columns:
        datos_columna = df[columna]  # Extraer los datos de la columna actual
        sumas = []  # Lista para almacenar las sumas de bloques de 180 filas
        medias = []  # Lista para almacenar las medias de bloques de 180 filas
        varianzas = []  # Lista para almacenar las varianzas de bloques de 180 filas
        asimetrias = []  # Lista para almacenar las asimetrías de bloques de 180 filas
        curtosis = []  # Lista para almacenar las curtosis de bloques de 180 filas
        desviaciones_estandar = []  # Lista para almacenar las desviaciones estándar de bloques de 180 filas
        maximos = []  # Lista para almacenar los valores máximos de bloques de 180 filas
        rangos_dinamicos = []  # Lista para almacenar los rangos dinámicos de bloques de 180 filas

        # Iterar en bloques de 180 filas
        for i in range(0, len(df), 180):
            datos_bloque = datos_columna.iloc[i:i+180]  # Extraer un bloque de 180 filas
            sumas.append(datos_bloque.sum())  # Calcular y almacenar la suma del bloque
            medias.append(datos_bloque.mean())  # Calcular y almacenar la media del bloque
            varianzas.append(datos_bloque.var())  # Calcular y almacenar la varianza del bloque
            asimetrias.append(datos_bloque.skew())  # Calcular y almacenar la asimetría del bloque
            curtosis.append(datos_bloque.kurtosis())  # Calcular y almacenar la curtosis del bloque
            desviaciones_estandar.append(datos_bloque.std())  # Calcular y almacenar la desviación estándar del bloque
            maximos.append(datos_bloque.max())  # Calcular y almacenar el valor máximo del bloque
            rangos_dinamicos.append(datos_bloque.max() - datos_bloque.min())  # Calcular y almacenar el rango dinámico del bloque

        # Agregar las listas de sumas y estadísticas al DataFrame y diccionario correspondientes
        sumas_df[f'{columna}_suma'] = sumas  # Renombrar la columna para reflejar que contiene sumas
        estadisticas_dict['media'][f'{columna}_media'] = medias  # Renombrar la columna para reflejar que contiene medias
        estadisticas_dict['varianza'][f'{columna}_varianza'] = varianzas  # Renombrar la columna para reflejar que contiene varianzas
        estadisticas_dict['asimetria'][f'{columna}_asimetria'] = asimetrias  # Renombrar la columna para reflejar que contiene asimetrías
        estadisticas_dict['curtosis'][f'{columna}_curtosis'] = curtosis  # Renombrar la columna para reflejar que contiene curtosis
        estadisticas_dict['desviacion_estandar'][f'{columna}_desviacion_estandar'] = desviaciones_estandar  # Renombrar la columna para reflejar que contiene desviaciones estándar
        estadisticas_dict['maximo'][f'{columna}_maximo'] = maximos  # Renombrar la columna para reflejar que contiene máximos
        estadisticas_dict['rango_dinamico'][f'{columna}_rango_dinamico'] = rangos_dinamicos  # Renombrar la columna para reflejar que contiene rangos dinámicos

    # Concatenar todas las estadísticas en un solo DataFrame
    resultados_df = sumas_df  # Inicialmente, solo contiene las sumas
    for estadistica, df_estadistica in estadisticas_dict.items():
        resultados_df = pd.concat([resultados_df, df_estadistica], axis=1)  # Añadir cada DataFrame de estadísticas

    return resultados_df

# Ruta del archivo CSV de entrada
#archivo_csv = 'C:/Users/Pedro/OneDrive/Escritorio/Sentadilla libre/data/avanzados/20240505_113831_cuate_1/Xsens DOT_1_D422CD006775_20240502_122851.csv'
archivo_csv = 'C:/Users/josei/OneDrive/Documentos/CIIBI proyectos/Analisys Free Squat/database/recordings_processed/avanzados/20240505_123031_ada_1/Xsens DOT_1_D422CD006775_20240505_122953.csv'
# Cargar el archivo CSV
df = pd.read_csv(archivo_csv)  # Lee el archivo CSV y lo almacena en un DataFrame

# Asignar nombres a las columnas
df.columns = ['PacketCounter', 'SampleTimeFine', 'Euler_X', 'Euler_Y', 'Euler_Z', 'Acc_X', 'Acc_Y', 'Acc_Z', 'Gyr_X', 'Gyr_Y', 'Gyr_Z']

# Aplicar la función y obtener el DataFrame con las estadísticas y sumas
resultados_df = calcular_estadisticas_y_sumar(df)  # Calcula las sumas y estadísticas

# Ruta para el nuevo archivo CSV
nuevo_archivo_csv = 'C:/Users/josei/OneDrive/Documentos/CIIBI proyectos/Analisys Free Squat/scripts/Xsens DOT_1_D422CD006775_20240505_122953.csv'

# Crear el directorio si no existe
os.makedirs(os.path.dirname(nuevo_archivo_csv), exist_ok=True)  # Crea el directorio si no existe

# Guardar el resultado en un nuevo archivo CSV
resultados_df.to_csv(nuevo_archivo_csv, index=False)  # Guarda el DataFrame resultante en un archivo CSV sin incluir el índice

print(f'Archivo guardado en: {nuevo_archivo_csv}')  # Imprime la ruta del archivo guardado