# AeroGT - Infraestructura de Base de Datos

## Arquitectura de Alta Disponibilidad
- **Nodo Principal (Escritura):** IP .10 - Contiene lógica transaccional (_TRX).
- **Nodo Réplica (Lectura):** IP .20 - Contiene lógica de consultas y reportes (_QRY).

## Estructura de Carpetas
- **01_NODOS_PRINCIPALES_TRX**: DDL base y paquetes de persistencia.
- **02_NODOS_REPLICA_QRY**: Vistas y paquetes de solo lectura.
- **03_SCRIPTS_MIGRACION**: Cargas masivas iniciales.
- **04_GLOBAL_TYPES**: Objetos y tipos globales del sistema.
