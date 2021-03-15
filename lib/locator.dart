import 'package:chatlytical/repository/user_repository.dart';
import 'package:chatlytical/services/fake_auth_service.dart';
import 'package:chatlytical/services/firebase_auth_service.dart';
import 'package:chatlytical/services/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthenticationService());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => UserRepository());
}
