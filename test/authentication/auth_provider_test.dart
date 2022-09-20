import 'dart:async';

import 'package:davar/locator.dart';
import 'package:davar/src/authentication/auth_provider.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'auth_provider_test.mocks.dart';

@GenerateNiceMocks([MockSpec<IAuthenticationRepository<User>>(as: #MockAuthenticationRepository)])
void main() {
  late IAuthenticationRepository<User> aR;
  late AuthProvider sut;
  const User emptyUser = User();
  const User notEmptyUser =
      User(id: 2, email: 'test', name: 'notEmptyUser', authToken: 'testToken');

  setUpAll(() {
    setupLocator();
    locator.allowReassignment = true;
  });

  group('AuthenticationProvider should:', () {
    group('- emmit default value', () {
      setUp(() {
        aR = MockAuthenticationRepository();
        locator.registerSingleton<IAuthenticationRepository<User>>(aR);
        sut = AuthProvider();
      });

      test('empty user', () async {
        // arrange
        // act
        User u = sut.user;
        // assert
        // verify(ss.deleteAll()).called(1);
        expect(emptyUser, u);
      });
      test('isLoading true', () async {
        // arrange
        // act
        bool isLoading = sut.isLoading;
        // assert
        expect(true, isLoading);
      });
    });
    group('emmit user from AuthenticationRepository stream:', () {
      late StreamController<User> controller;
      setUp(() {
        aR = MockAuthenticationRepository();
        locator.registerSingleton<IAuthenticationRepository<User>>(aR);
        sut = AuthProvider();
        controller = StreamController<User>.broadcast(sync: false);
      });
      tearDown(() {
        controller.close();
      });

      test('empty user id isNonPositive', () async {
        // arrange
        Stream<User> stream = controller.stream;
        // act
        stream.listen(
          expectAsync1(
            (event) {
              expect(event.id, isNonPositive);
            },
          ),
        );
        controller.add(emptyUser);
      });
    });
  });
}
