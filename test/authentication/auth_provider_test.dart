import 'dart:async';

import 'package:davar/locator.dart';
import 'package:davar/src/authentication/auth_provider.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_authentication_repository.dart';
import 'package:davar/src/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'auth_provider_test.mocks.dart';

@GenerateNiceMocks([MockSpec<IAuthenticationRepository<User>>(as: #MockAuthenticationRepository)])
void main() {
  late IAuthenticationRepository<User> aR;
  late AuthProvider sut;
  const User emptyUser = AppConst.emptyUser;
  const User unknownUser = AppConst.unknownUser;

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
        // arrange // act
        // assert
        expect(sut.user, emptyUser);
      });
      test('status AuthenticationStatus.unknown', () async {
        expect(sut.status, AuthenticationStatus.unknown);
      });
    });
    group('when authentication repository Stream<User> emits', () {
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

      test('emptyUser then unknownUser, status=AuthenticationStatus.unknown', () async {
        // arrange // act
        expect(sut.status, AuthenticationStatus.unknown);
        controller.add(emptyUser);
        controller.add(unknownUser);
      });
      test('emptyUser, then user=emptyUser', () async {
        // arrange
        Stream<User> stream = controller.stream;
        // act
        stream.listen(
          expectAsync1(
            (event) {
              expect(event, emptyUser);
            },
          ),
        );
        controller.add(emptyUser);
      });
    });
  });
}
