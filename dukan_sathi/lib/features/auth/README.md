# Auth Feature Module (Clean Architecture)

Structure:
- `data/`: Remote Firebase Auth Data Source, Auth Models, Repository Implementation
- `domain/`: Auth Entities, Repository Interfaces, Use Cases (Login, SignUp, Logout)
- `presentation/`: Riverpod Auth State Notifiers, Login Screen, SignUp Screen
