# 🐳 Entorno de Pruebas: Druid + API Python 

Imagen Docker para levantar un clúster simple de Druid junto con una API Python para pruebas y desarrollo.

> 🧱 **Basado en**: [metabase/druid-docker](https://github.com/metabase/druid-docker)

Este proyecto proporciona un entorno liviano para desarrollo local y pruebas de consultas sobre datos en Apache Druid, expuestos a través de una API en Python.

## 🚀 Cómo levantar el proyecto

1.  **Construir las imagen:**

    En la carpeta raíz del proyecto ejecutar:
    ```bash
    docker-compose build --no-cache
    ```

    Levantar los servicios:

    ```bash
    docker-compose up
    ```

    🐛 **Posible error al iniciar Druid**

    Es probable que al inicio veas un error como este:

    ```
    Rows loaded: {"error":"Unknown exception","errorMessage":"org.apache.calcite.runtime.CalciteContextException: From line 1, column 33 to line 1, column 42: Object 'checkins' not found","errorClass":"org.apache.calcite.tools.ValidationException","host":null}
    ```

    Este error es esperado. Ocurre porque aún no se cargaron los datos en Druid.

    ✅ **Solución**

    Esperá a que el script `ingest.sh` termine de ejecutarse y veas el siguiente mensaje en consola:

    ```
    Rows loaded: [{"count":1000}]
    ```

    🌐 **Acceder a Druid**

    Una vez cargados los datos:

    Abrí tu navegador y accedé a: <http://localhost:8888>

    Deberías ver el datasource `checkins` creado y disponible para consultas.

    📡 **Probar la API**

    * Verificar si está viva: <http://localhost:5000/>
    * Consultar la cantidad de filas en el datasource `checkins`: <http://localhost:5000/query>

    🛠 **Requisitos**

    * Docker
    * Docker Compose
