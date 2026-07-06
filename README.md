# ¡Riégame! 🌿

**¡Riégame!** es una aplicación móvil desarrollada en Flutter diseñada para los amantes de las plantas. Permite gestionar de manera inteligente el cuidado de tu jardín personal, llevando un control estricto de los riegos, la exposición solar y ofreciendo asistencia mediante Inteligencia Artificial.

---

## ✨ Funcionalidades Principales

### 📋 Gestión de Colección
*   **Registro de Plantas:** Añade nuevas integrantes a tu jardín con datos como nombre, apodo, observaciones, frecuencia de riego recomendada y objetivo de horas de sol.
*   **Edición y Control:** Mantén la información de tus plantas siempre actualizada.
*   **Borrado Atómico:** Sistema de eliminación segura que limpia automáticamente todos los historiales (riegos y sol) asociados a una planta para mantener la base de datos optimizada.

### 💧 Control de Cuidados
*   **Registro de Riego:** Notifica cada vez que riegas una planta con un solo toque.
*   **Seguimiento Solar:** Registra las horas de exposición al sol diarias para asegurar que tus plantas reciban la energía necesaria.
*   **Algoritmo de Salud:** Cálculo en tiempo real del estado de cada planta (Excelente, Próximo Riego o Necesita Riego) basado en su frecuencia específica.

### 🤖 Asistente con IA (Gemini)
*   **Consulta Botánica:** Chat integrado con la IA de Google (Gemini) especializado exclusivamente en botánica.
*   **Restricción de Seguridad:** El asistente está configurado para responder únicamente dudas sobre plagas, sustratos, podas y cuidados generales, rechazando temas ajenos al mundo vegetal.

### 📊 Estadísticas y Métricas
*   **Dashboard Global:** Gráficas circulares que muestran la salud general de todo tu jardín.
*   **Métricas por Planta:** Porcentaje de cumplimiento de riego, comparativas semanales y mensuales de cuidados.
*   **Gamificación:** Identificación de la "Planta más cuidada" de tu colección.

### 🔔 Notificaciones y Recordatorios
*   **Alertas Locales:** Confirmaciones inmediatas al realizar acciones de cuidado.
*   **Gestión de Permisos:** Integración nativa con Android para el manejo de notificaciones de importancia alta.

---

## 🛠️ Stack Tecnológico

*   **Framework:** [Flutter](https://flutter.dev/) (Multiplataforma).
*   **Base de Datos:** [Firebase Firestore](https://firebase.google.com/products/firestore) (Sincronización en tiempo real).
*   **IA:** [Google Gemini API](https://ai.google.dev/) (Modelo Gemini Flash).
*   **Gráficos:** [FL Chart](https://pub.dev/packages/fl_chart).
*   **Notificaciones:** `flutter_local_notifications`.
*   **Arquitectura:** MVVM (Model-View-ViewModel) para una separación clara de la lógica de negocio y la UI.

---

## 🚀 Configuración e Instalación

1.  **Clonar el repositorio:**
    ```bash
    git clone https://github.com/tu-usuario/riegame.git
    ```

2.  **Configurar Variables de Entorno:**
    Crea un archivo `.env` en la raíz del proyecto y añade tu API Key de Gemini:
    ```env
    GEMINI_API_KEY=tu_api_key_aqui
    ```

3.  **Configurar Firebase:**
    *   Crea un proyecto en [Firebase Console](https://console.firebase.google.com/).
    *   Descarga el archivo `google-services.json` (para Android) y colócalo en `android/app/`.
    *   Habilita Firestore Database.

4.  **Instalar dependencias:**
    ```bash
    flutter pub get
    ```

5.  **Ejecutar la app:**
    ```bash
    flutter run
    ```

---

## 📂 Estructura del Proyecto

*   `lib/models/`: Definición de las entidades de datos (Planta, Riego, HoraSol).
*   `lib/services/`: Lógica de comunicación con Firebase, Gemini y servicios de sistema.
*   `lib/viewmodels/`: Intermediarios que procesan los datos para la interfaz.
*   `lib/screens/`: Pantallas principales de la aplicación.
*   `lib/widgets/`: Componentes de UI reutilizables.
*   `lib/utils/`: Lógica pura de cálculo de fechas y estados.

---

## 📝 Documentación
El código sigue los estándares de documentación de Dart (`///`), lo que facilita su mantenimiento y la generación automática de documentación técnica.

---
Desarrollado con ❤️ para amantes de la naturaleza. 🌱
---
## Nombres y Apellidos: Brunella Alor Aquino
## Ingenieria de Software VI
