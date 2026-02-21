# tempus

A new Flutter project.

## File Structure

```
lib/
 ├── core/              # Global shared resources
 │    ├── theme/        # App-wide styling and color palettes
 │    └── widgets/      # Reusable UI components used across multiple features
 ├── features/          # Feature-based modules
 │    └── feature_name/ # Example of a single feature's internal structure
 │         ├── data/    # Data layer: Models, API services, and repositories
 │         ├── logic/   # Domain layer: BLoC files and state management
 │         └── presentation/
 │              ├── pages/    # Full screen views
 │              └── widgets/  # UI components specific to this feature only
 ├── main.dart          # Entry point, initialization, and root routing logic
```
