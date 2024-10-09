# client

A new Flutter project.

### Router
If you only want to route to another page. Simply use 
``` dart
final router = RouterProvider.of(context)
``` 
inside build widget.

If you want to access information inside the router, like values or pathvariables. Create
```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  router = RouterProvider.of(context);
}
```
### Installation
1. Clone the repository:
   ```bash
   cd [your-project-folder]
   git clone git@github.com:Itszipzon/mobileapplication_2024.git
   ```

2. If this is your first time running the project, make sure to install the necessary dependencies:
   ```bash
   flutter pub get
   ```

### Running the Project

1. Navigate to the client directory:
   ```bash
    cd client
   ```
2. To run the project, use the following command:
   ```bash
   flutter run -d chrome
   ```