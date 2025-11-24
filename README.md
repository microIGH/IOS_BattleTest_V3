# Battle Test - Aplicación de Quizzes Educativos iOS

[![iOS](https://img.shields.io/badge/Platform-iOS-blue.svg)](https://developer.apple.com/ios)
[![Swift](https://img.shields.io/badge/Language-Swift-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-Academic-blue.svg)](https://www.unam.mx)

Aplicación iOS de cuestionarios educativos con sistema de gamificación, soporte multiidioma y arquitectura MVC + Managers.

## 📋 Descripción

Battle Test es una aplicación móvil diseñada para el aprendizaje interactivo mediante quizzes educativos en tres idiomas (español, inglés y francés). Implementa un sistema completo de gamificación con 15 achievements categorizados, niveles, puntos y rachas de aciertos. Incluye persistencia local con UserDefaults, sincronización con backend REST y funcionalidad de compartir resultados en redes sociales.

## ✨ Características Principales

- **🌍 Multiidioma:** Soporte completo para español, inglés y francés con localización automática
- **💾 Persistencia Local:** UserDefaults para progreso del usuario con sincronización instantánea
- **🎮 Gamificación Avanzada:** 15 achievements categorizados (velocidad, precisión, consistencia, explorador, perfeccionista)
- **🔄 Sincronización:** Integración con API REST alojada en Railway
- **📱 Offline-first:** Sistema de fallback local cuando no hay conexión
- **🎨 UI Nativa:** UIKit programático con soporte para modo oscuro/claro automático
- **📤 Compartir Resultados:** Captura de pantalla automática + texto personalizado para redes sociales

## 🏗️ Arquitectura

### MVC + Managers Pattern

```
┌──────────────┐
│ ViewControllers │
└───────┬────────┘
        │
┌───────▼────────┐
│   Managers     │ (Business Logic)
└───┬────────┬───┘
    │        │
┌───▼────┐ ┌─▼─────────┐
│UserDefs│ │ APIService│
└────────┘ └───────────┘
```

### Capas Implementadas

1. **Models (`Models/`)**
   - `Student.swift`: Modelo de usuario con XP, nivel, rachas
   - `Achievement.swift`: 15 achievements con criterios
   - `Quiz.swift`, `Question.swift`, `Subject.swift`
   - `QuizResult.swift`, `QuizSession.swift`

2. **Managers (`Managers/` + `Models/*Manager.swift`)**
   - `QuizEngine.swift`: Lógica de cuestionarios
   - `StudentManager.swift`: Progreso del usuario
   - `AchievementManager.swift`: Sistema de logros
   - `QuizDataManager.swift`: Datos locales + fallback
   - `UserProgressManager.swift`: Persistencia

3. **Network (`Network/`)**
   - `APIService.swift`: Retrofit-style networking
   - `NetworkMonitor.swift`: Detección WiFi/Cellular
   - `ConnectionBannerView.swift`: Feedback visual

4. **Views & Controllers (`ViewControllers/`, `Views/`)**
   - Tab Bar Navigation (Dashboard, Subjects, Profile)
   - Custom UIViews (CircularProgressView, AchievementGridView)
   - UIKit programático (NSLayoutConstraint)

## 🛠️ Tecnologías Implementadas

### Requisitos Módulos 4 y 5 - UNAM

| Requisito | Implementación | Estado |
|-----------|----------------|--------|
| **Launch Screen** | Configurado con Assets | ✅ |
| **App Icons** | 1024x1024 en Assets.xcassets | ✅ |
| **Modo Oscuro** | Automático según sistema | ✅ |
| **Navegación** | TabBarController + NavigationController | ✅ |
| **Multiidioma** | Localizable.strings (ES/EN/FR) | ✅ |
| **Detección Red** | NetworkMonitor con NWPathMonitor | ✅ |
| **Aviso Datos** | ConnectionBannerView automático | ✅ |
| **Backend** | Railway 24/7 con fallback offline | ✅ |

### Stack Tecnológico

- **Lenguaje:** Swift 5.9
- **UI:** UIKit (100% programático)
- **Persistencia:** UserDefaults
- **Networking:** URLSession + Codable
- **Arquitectura:** MVC + Managers
- **Navegación:** UITabBarController + UINavigationController
- **Localización:** NSLocalizedString + Localizable.strings

## 📂 Estructura del Proyecto

```
BattleTest_V1/
├── Models/
│   ├── Student.swift              # Usuario con XP, nivel, rachas
│   ├── Achievement.swift          # Modelo de logros
│   ├── AchievementManager.swift   # Sistema de achievements
│   ├── Quiz.swift                 # Modelo de cuestionario
│   ├── Question.swift             # Modelo de pregunta
│   ├── Subject.swift              # Asignaturas
│   ├── QuizResult.swift           # Resultados de quiz
│   ├── QuizSession.swift          # Sesión activa
│   ├── QuizDataManager.swift      # Datos locales + API
│   └── UserProgressManager.swift  # Persistencia UserDefaults
├── Network/
│   ├── NetworkMonitor.swift       # Detección WiFi/Cellular/Offline
│   ├── APIService.swift           # Networking con Railway
│   └── ConnectionBannerView.swift # Banner de conectividad
├── Managers/
│   └── QuizEngine.swift           # Lógica de quizzes
├── ViewControllers/
│   ├── RegistrationViewController.swift      # Registro inicial
│   ├── MainTabBarController.swift            # Tab Bar principal
│   ├── DashboardViewController.swift         # Tab 1: Dashboard gamificado
│   ├── SubjectsViewController.swift          # Tab 2: Grid de materias
│   ├── QuizListViewController.swift          # Lista de quizzes
│   ├── QuizViewController.swift              # Quiz en progreso
│   ├── QuizResultsViewController.swift       # Resultados + compartir
│   └── ProfileViewController.swift           # Tab 3: Perfil de usuario
├── Views/
│   ├── CircularProgressView.swift     # Círculo de progreso animado
│   ├── AchievementGridView.swift      # Grid de achievements
│   ├── WeeklyProgressChart.swift      # Gráfica semanal
│   ├── StatsCardView.swift            # Tarjetas de estadísticas
│   ├── SubjectCollectionViewCell.swift # Celda de materia
│   ├── QuestionView.swift             # Vista de pregunta
│   └── PenaltyDotsView.swift          # Indicador de errores
├── Supporting Files/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── LaunchScreen.storyboard
└── Resources/
    ├── Assets.xcassets
    ├── Localizable.strings (es)   # Español
    ├── Localizable.strings (en)   # Inglés
    └── Localizable.strings (fr)   # Francés
```

## 🔄 Flujo de Datos

### Carga de Quizzes

```swift
// 1. Usuario entra a SubjectsViewController
NetworkMonitor detecta conectividad
    ↓
Si online → APIService.fetchQuizzes()
    ↓
Filtrar por idioma del dispositivo (client-side)
    ↓
QuizDataManager caché local
    ↓
Si offline → QuizDataManager.getAllSubjects() (fallback)
    ↓
SubjectsViewController renderiza
```

### Persistencia de Progreso

```swift
// 1. Usuario completa quiz
QuizResultsViewController → StudentManager.completeQuiz()
    ↓
Student.addQuizResult() → Calcula XP, nivel, rachas
    ↓
AchievementManager.checkForNewAchievements()
    ↓
UserProgressManager.saveStudent() → UserDefaults
    ↓
NotificationCenter.post("studentDidUpdate")
    ↓
ProfileViewController + DashboardViewController se actualizan
```

### Compartir Resultados

```swift
// 1. Usuario toca botón "Compartir"
QuizResultsViewController.shareResults()
    ↓
Captura de pantalla de la vista (UIGraphicsImageRenderer)
    ↓
Genera texto personalizado con estadísticas
    ↓
UIActivityViewController presenta opciones
    ↓
Usuario selecciona WhatsApp/Instagram/Messages/etc.
```

## 🚀 Instalación y Configuración

### Requisitos Previos

- macOS Sonoma 14.0+ (para Xcode 15)
- Xcode 15.0 o superior
- iOS 14.0+ (Deployment Target)
- Cuenta de Apple Developer (para dispositivo físico)
- Conexión a internet (solo primera carga)

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/microIGH/IOS_BattleTest_V3.git
   cd iOS_BattleTest_V1
   ```

2. **Abrir en Xcode**
   - Doble click en `BattleTest_V1.xcodeproj`
   - O: `open BattleTest_V1.xcodeproj` en Terminal

3. **Seleccionar Team (si es necesario)**
   - Proyecto → Signing & Capabilities
   - Seleccionar tu Apple ID en "Team"

4. **Ejecutar la aplicación**
   - Seleccionar simulador (iPhone 15 Pro recomendado)
   - Cmd + R para compilar y ejecutar

### Configuración del Backend

El proyecto está configurado para usar la API de Railway:

```swift
// Network/APIService.swift
private let baseURL = "https://quiz-api-movil-production.up.railway.app"
```

Para usar un backend diferente, modificar esta constante.

## 📸 Capturas de Pantalla

### Launch Screen
<img src="screenshots/LaunchScreen.png" width="250" alt="Launch Screen"/>

### Registro Inicial
<img src="screenshots/inicio.png" width="250" alt="Registro"/>

### Dashboard Gamificado
<img src="screenshots/dashboard.png" width="250" alt="Dashboard"/>

### Selección de Materias
<img src="screenshots/subjects.png" width="250" alt="Materias"/>

### Lista de Quizzes
<img src="screenshots/quizes.png" width="250" alt="Lista de Quizzes"/>

### Quiz en Progreso
<img src="screenshots/quiz.png" width="250" alt="Quiz"/>

### Resultados del Quiz
<img src="screenshots/Pantalla de resultados.png" width="250" alt="Resultados"/>

### Perfil de Usuario
<img src="screenshots/profile.png" width="250" alt="Perfil"/>

> **Nota:** Las imágenes están en la carpeta `screenshots/` en la raíz del proyecto.

## 🎯 Características Destacadas

### 1. Sistema de Gamificación (15 Achievements)

```swift
// 5 categorías de achievements
🏃 Velocidad: Rápido (<2min), Relámpago (<1min), Sonic (<30seg)
🎯 Precisión: Perfecto (100%), Experto (95%+), Maestro (90%+)
🔥 Consistencia: Dedicado (3 días), Comprometido (7 días), Imparable (30 días)
🌍 Explorador: Curioso (2 materias), Viajero (3 materias), Polímata (4 materias)
💎 Perfeccionista: Resiliente (5 intentos), Persistente (10 intentos), Diamante (10 perfectos)
```

### 2. Detección de Red con Feedback Visual

```swift
// NetworkMonitor usa NWPathMonitor
enum NetworkStatus {
    case wifi        // Conexión WiFi
    case cellular    // Datos celulares (muestra aviso)
    case offline     // Sin conexión (usa caché local)
}

// ConnectionBannerView se muestra automáticamente
- Verde: "Conectado a WiFi"
- Amarillo: "Usando datos celulares"
- Rojo: "Sin conexión - Modo offline"
```

### 3. Compartir Resultados

```swift
// Captura de pantalla + texto personalizado
let image = captureScreenshot() // UIGraphicsImageRenderer
let text = """
🎯 Battle Test - Resultados

Quiz: \(quizTitle)
Puntuación: \(correctAnswers)/\(totalQuestions) (\(percentage)%)
Tiempo: \(minutes) min \(seconds) seg
Estado: \(isPassing ? "✅ Aprobado" : "❌ Reprobado")

⭐ Achievements desbloqueados: \(newAchievements.count)

#BattleTest #Educación
"""

// Compartir vía UIActivityViewController
let activityVC = UIActivityViewController(
    activityItems: [image, text],
    applicationActivities: nil
)
```

### 4. Sistema de Penalización

```swift
// 3 errores → Reinicio del quiz
private var penaltyCount = 0
private let maxPenalties = 3

func checkAnswer(_ selectedOption: String) {
    if selectedOption != currentQuestion.correctAnswer {
        penaltyCount += 1
        if penaltyCount >= maxPenalties {
            resetQuiz() // Reinicia desde pregunta 1
        }
    }
}
```

### 5. Localización Multiidioma

```swift
// Detección automática según idioma del dispositivo
let deviceLanguage = Locale.current.language.languageCode?.identifier
let appLanguage = ["es", "en", "fr"].contains(deviceLanguage) 
    ? deviceLanguage 
    : "es" // Fallback a español

// Uso en código
label.text = NSLocalizedString("welcome_message", comment: "")

// Localizable.strings (es)
"welcome_message" = "¡Bienvenido a Battle Test!";

// Localizable.strings (en)
"welcome_message" = "Welcome to Battle Test!";
```

## 🧪 Testing

### Casos de Prueba Implementados

- ✅ Registro de nuevo usuario con validación de email
- ✅ Persistencia de progreso entre sesiones
- ✅ Cálculo correcto de nivel, XP y rachas
- ✅ Detección de achievements al completar quiz
- ✅ Filtrado de quizzes por idioma del dispositivo
- ✅ Funcionamiento offline con datos locales
- ✅ Compartir resultados en redes sociales
- ✅ Modo oscuro/claro automático
- ✅ Sistema de penalización (3 errores)
- ✅ Navegación fluida sin memory leaks

### Ejecutar Tests (Pendiente)

```bash
# Unit Tests
Cmd + U en Xcode

# UI Tests
Xcode → Product → Test
```

## 🗺️ Roadmap

### Versión Actual (1.0.0)
- [x] Sistema de quizzes multiidioma
- [x] Persistencia UserDefaults
- [x] Integración con API Railway
- [x] 15 achievements categorizados
- [x] Compartir resultados
- [x] Detección de red + banner
- [x] Modo oscuro/claro

### Próximas Características
- [ ] Core Data para persistencia avanzada
- [ ] Sign in with Apple
- [ ] Sincronización en la nube (CloudKit)
- [ ] Modo multijugador en tiempo real
- [ ] Notificaciones push para rachas
- [ ] Análisis de rendimiento por materia
- [ ] Widgets de iOS para progreso

## 🤝 Decisiones de Diseño

| Decisión | Alternativa | Justificación |
|----------|-------------|---------------|
| UIKit Programático | SwiftUI | Mayor control sobre layouts, debugging más fácil |
| UserDefaults | Core Data | Datos simples sin relaciones complejas |
| MVC + Managers | VIPER | Menos boilerplate, más directo para proyecto educativo |
| URLSession | Alamofire | Sin dependencias externas, networking nativo |
| Tab Bar | Side Menu | Navegación estándar de iOS, UX familiar |

## 📝 Configuración del Proyecto

### Versiones y Requisitos

```swift
// Info.plist
Minimum Deployment: iOS 14.0
Swift Language Version: 5.9
Xcode Version: 15.0+

// Capabilities
- Background Modes: Remote notifications (futuro)
- Network: Required
```

### Backend API

**Endpoint Implementado:**
```
GET /api/quizzes/es
```

**Response:**
```json
[
    {
        "id": 1,
        "language": "es",
        "subject": "Biología",
        "title": "Células y Tejidos",
        "minQuestionsNumber": 5,
        "questions": [
            {
                "question": "¿Cuál es la función del núcleo celular?",
                "options": ["Respiración", "Control genético", "Fotosíntesis", "Digestión"],
                "correctAnswer": "Control genético"
            }
        ]
    }
]
```

## 👨‍💻 Autor

**Israel García Hernández**
- Diplomado en Desarrollo de Aplicaciones para Dispositivos Móviles con iOS
- Universidad Nacional Autónoma de México (UNAM)
- Dirección General de Tecnologías de la Información y Comunicación (DGTIC)
- Módulos 4 y 5: Desarrollo iOS Avanzado

## 📄 Licencia

Este proyecto es material académico desarrollado como parte del Diplomado en Desarrollo de Aplicaciones para Dispositivos Móviles de la UNAM.

**Licencia Académica - UNAM DGTIC**

Prohibido el uso comercial. Permitido el uso educativo con atribución apropiada.

---

## 🔗 Enlaces Útiles

- [API Backend (Railway)](https://quiz-api-movil-production.up.railway.app/)
- [Documentación iOS](https://developer.apple.com/documentation)
- [Swift Language Guide](https://docs.swift.org/swift-book/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

---

**Desarrollado con ❤️ usando Swift y UIKit**
