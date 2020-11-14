Primero se debe cargar la base de datos con el comando:

$ sqlite3 tsp.db <tsp.sql

Para compilar el programa basta con escribir en la terminal
desde el directorio TSP :

$ nim c src/main.nim

Una vez compilado para ejecutar el programa se debe escribir en la terminal:

$ ./src/main src/tsp.db data/archivo_instancia [semilla1,...,semillak]

Las mejores semillas para probar cada instancia vienen en el archivo data/seeds.txt
