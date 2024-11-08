# Manual de Contribución al Proyecto Soastereo

Este documento describe el flujo de trabajo recomendado para contribuir al proyecto **Soastereo**. Sigue estos pasos para garantizar que todos los desarrolladores trabajen de manera coordinada y que el código permanezca limpio y fácil de mantener.

## Tabla de Contenidos
1. [Estructura de Ramas](#estructura-de-ramas)
2. [Primer Descarga del Proyecto](#primer-descarga-del-proyecto)
3. [Enviar Cambios al Repositorio](#enviar-cambios-al-repositorio)
4. [Actualizar el Proyecto con los Últimos Cambios](#actualizar-el-proyecto-con-los-últimos-cambios)

---

## 1. Estructura de Ramas

Para facilitar el trabajo en equipo y evitar conflictos de código, seguimos una estructura de ramas:

- **main**: La rama principal del proyecto. Solo contiene código estable. No se deben hacer cambios directos en esta rama.
- **feature/<nombre-funcionalidad>**: Cada desarrollador trabaja en su propia rama basada en `main`. Crea una nueva rama para cada funcionalidad, mejora o corrección.
- **develop** (opcional): Si el proyecto es complejo, se puede usar una rama de integración para combinar cambios antes de fusionarlos en `main`.

### Nombres de Ramas
Usa el siguiente formato para nombrar tus ramas de trabajo:

```plaintext
feature/nombre-funcionalidad
bugfix/nombre-error
```

Ejemplos:
- `feature/login-page`
- `bugfix/fix-login-error`

---

## 2. Primer Descarga del Proyecto

Para descargar el proyecto por primera vez:

1. **Clona el repositorio**:

   ```bash
   git clone https://github.com/fingerbass/soastereo.git
   ```

2. **Navega al directorio del proyecto**:

   ```bash
   cd soastereo
   ```

3. **Crea una nueva rama** basada en `main`:

   ```bash
   git checkout -b feature/nombre-funcionalidad
   ```

Esta rama será tu espacio de trabajo para hacer cambios en el proyecto.

---

## 3. Enviar Cambios al Repositorio

Cuando hayas realizado cambios en tu rama y quieras compartirlos con el equipo:

1. **Guarda y confirma (commit) tus cambios** en tu rama local:

   ```bash
   git add .
   git commit -m "Descripción de los cambios realizados"
   ```

2. **Envía (push) los cambios a tu rama en el repositorio remoto**:

   ```bash
   git push origin feature/nombre-funcionalidad
   ```

3. **Crea un Pull Request (PR)** desde GitHub:
   - Ve a [GitHub](https://github.com/fingerbass/soastereo).
   - Haz clic en **Pull Requests** y selecciona **New Pull Request**.
   - Selecciona tu rama como la rama de origen (`feature/nombre-funcionalidad`) y `main` como la rama de destino.
   - Agrega una descripción detallada de los cambios y envía el PR.

4. **Espera la revisión**: Los demás desarrolladores revisarán tu PR, harán comentarios o sugerencias y lo aprobarán si está listo para fusionarse.

5. **Fusionar el PR**: Una vez aprobado, podrás fusionar el PR en `main`. **Nota**: Solo los colaboradores autorizados deben hacer merges a `main`.

---

## 4. Actualizar el Proyecto con los Últimos Cambios

Para asegurarte de que siempre estás trabajando con la versión más reciente del proyecto:

1. **Cambia a la rama `main`**:

   ```bash
   git checkout main
   ```

2. **Obtén los últimos cambios de `main` desde el repositorio remoto**:

   ```bash
   git pull origin main
   ```

3. **Fusiona los cambios recientes en tu rama de trabajo**:
   - Cambia a tu rama de trabajo:

     ```bash
     git checkout feature/nombre-funcionalidad
     ```

   - Fusiona los últimos cambios de `main` en tu rama:

     ```bash
     git merge main
     ```

   Esto traerá los últimos cambios de `main` a tu rama de trabajo. Si existen conflictos, Git te pedirá que los resuelvas antes de completar el merge.

4. **Continúa trabajando en tu rama** y repite el ciclo de `commit`, `push` y PR cuando estés listo para compartir cambios.

---

## Resumen del Flujo de Trabajo

1. **Crear una nueva rama** para cada tarea o funcionalidad.
2. **Hacer commit y push** en tu propia rama.
3. **Crear un Pull Request** para revisión y aprobación.
4. **Actualizar tu rama de trabajo** con los últimos cambios de `main`.

---

## Notas Adicionales

- **Evita hacer commits directamente en `main`**.
- **Comunicación**: Si encuentras un problema o necesitas ayuda, usa los comentarios en GitHub o una plataforma de comunicación interna.
- **Documentación**: Añade comentarios y documentación en el código cuando sea necesario para facilitar la comprensión de los cambios realizados.

---

Este flujo de trabajo ayudará a mantener el código organizado y reducirá los conflictos al trabajar en equipo. ¡Feliz codificación!
