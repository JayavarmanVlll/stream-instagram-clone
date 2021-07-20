import 'package:stream_feed/stream_feed.dart';

/// Dummy application users.
enum DummyAppUser {
  /// A Stream chat developer
  sahil,

  /// A Stream feed developer
  sacha,

  /// A developer advocate
  nash,

  /// A developer advocate
  gordon,
}

/// Convenient class Extension on [DummyAppUser] enum
extension DummyAppUserX on DummyAppUser {
  /// Convenient method Extension to generate an [id] from [DummyAppUser] enum
  String? get id => {
        DummyAppUser.sahil: 'sahil-kumar',
        DummyAppUser.sacha: 'sacha-arbonel',
        DummyAppUser.nash: 'neevash-ramdial',
        DummyAppUser.gordon: 'gordon-hayes',
      }[this];

  /// Convenient method Extension to generate a [name] from [DummyAppUser] enum
  String? get name => {
        DummyAppUser.sahil: 'Sahil Kumar',
        DummyAppUser.sacha: 'Sacha Arbonel',
        DummyAppUser.nash: 'Neevash Ramdial',
        DummyAppUser.gordon: 'Gordon Hayes',
      }[this];

  /// Convenient method Extension to generate [data] from [DummyAppUser] enum
  Map<String, Object>? get data => {
        DummyAppUser.sahil: {
          'first_name': 'Sahil',
          'last_name': 'Kumar',
          'full_name': 'Sahil Kumar',
        },
        DummyAppUser.sacha: {
          'first_name': 'Sacha',
          'last_name': 'Arbonel',
          'full_name': 'Sacha Arbonel',
        },
        DummyAppUser.nash: {
          'first_name': 'Neevash',
          'last_name': 'Ramdial',
          'full_name': 'Neevash Ramdial',
        },
        DummyAppUser.gordon: {
          'first_name': 'Gordon',
          'last_name': 'Hayes',
          'full_name': 'Gordon Hayes',
        },
      }[this];

  /// Convenient method Extension to generate a [token] from [DummyAppUser] enum
  Token? get token => <DummyAppUser, Token>{
        DummyAppUser.sahil: const Token(
            '''eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoic2FoaWwta3VtYXIifQ.mz3eZld6bN4pnkPweZQQW2CFC27btTGlF-njU3gToXc'''),
        DummyAppUser.sacha: const Token(
            '''eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoic2FjaGEtYXJib25lbCJ9.CJfmbovNUhQYpEGVyyD_a3fz0a_O7JPV7rOjma4dksA'''),
        DummyAppUser.nash: const Token(
            '''eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoibmVldmFzaC1yYW1kaWFsIn0.tiDNecUMjkFpKQbzduXRmd0Deb-ZbOtZs5yLX0ynmjo'''),
        DummyAppUser.gordon: const Token(
            '''eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiZ29yZG9uLWhheWVzIn0.PClf8PU3EQFgNef99QumuBDX8ufYmJrvPIRGLC3OMLA'''),
      }[this];
}
