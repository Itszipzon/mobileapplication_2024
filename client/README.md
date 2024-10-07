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
