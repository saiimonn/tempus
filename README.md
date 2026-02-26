# tempus

A new Flutter project.

## File Structure

```
lib/
└── features/
    └── user_profile/
        ├── data/
        │   ├── data_sources/
        │   │   ├── sample_data_source.dart
        │   ├── models/
        │   │   └── sample_model.dart (JSON/DTO logic)
        │   └── repositories/
        │       └── sample_repository.dart (Implements Domain Repo)
        ├── domain/
        │   ├── entities/
        │   │   └── sample_entity.dart (Pure Business Logic)
        │   ├── repositories/
        │   │   └── sample_repository.dart (Abstract Interface)
        │   └── use_cases/
        │       └── get_sample.dart
        └── presentation/
            ├── bloc/ (or provider/riverpod)
            │   ├── sample_bloc.dart
            │   ├── sample_event.dart
            │   └── sample_state.dart
            ├── pages/
            │   └── sample_page.dart
            └── widgets/
                └── sample_avatar.dart

### Domain Layer (Business Logic)
- **entities/sample_entity.dart** | Pure data object for the UI.
- **repositories/sample_repository.dart** | Abstract contract for data needs.
- **use_cases/get_sample.dart** | Single-task business logic execution.

### Data Layer (Infrastructure)
- **data_sources/sample_data_source.dart**| Raw API calls and DB queries.
- **models/sample_model.dart** | Data parsing (JSON/DTO logic).
- **repositories/sample_repository_impl** | Contract implementation & mapping.

### Presentation Layer (UI & State)
- **bloc/sample_event.dart** | User actions (e.g., ButtonClick).
- **bloc/sample_state.dart** | UI states (Loading, Success, Error).
- **bloc/sample_bloc.dart** | Logic: Events → UseCases → States.
- **pages/sample_page.dart** | The main screen/Scaffold widget.
- **widgets/sample_avatar.dart** | Small, reusable UI components.
```
