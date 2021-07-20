import 'package:stream_feed/stream_feed.dart';

/// Demo application users.
enum DemoAppUser {
  /// A Stream chat developer
  sahil,

  /// A Stream feed developer
  sacha,

  /// A developer advocate
  nash,

  /// A developer advocate
  gordon,
}

/// Convenient class Extension on [DemoAppUser] enum
extension DemoAppUserX on DemoAppUser {
  /// Convenient method Extension to generate an [id] from [DemoAppUser] enum
  String? get id => {
        DemoAppUser.sahil: 'sahil-kumar',
        DemoAppUser.sacha: 'sacha-arbonel',
        DemoAppUser.nash: 'neevash-ramdial',
        DemoAppUser.gordon: 'gordon-hayes',
      }[this];

  /// Convenient method Extension to generate a [name] from [DemoAppUser] enum
  String? get name => {
        DemoAppUser.sahil: 'Sahil Kumar',
        DemoAppUser.sacha: 'Sacha Arbonel',
        DemoAppUser.nash: 'Neevash Ramdial',
        DemoAppUser.gordon: 'Gordon Hayes',
      }[this];

  /// Convenient method Extension to generate [data] from [DemoAppUser] enum
  Map<String, Object>? get data => {
        DemoAppUser.sahil: {
          'first_name': 'Sahil',
          'last_name': 'Kumar',
          'full_name': 'Sahil Kumar',
        },
        DemoAppUser.sacha: {
          'first_name': 'Sacha',
          'last_name': 'Arbonel',
          'full_name': 'Sacha Arbonel',
        },
        DemoAppUser.nash: {
          'first_name': 'Neevash',
          'last_name': 'Ramdial',
          'full_name': 'Neevash Ramdial',
        },
        DemoAppUser.gordon: {
          'first_name': 'Gordon',
          'last_name': 'Hayes',
          'full_name': 'Gordon Hayes',
        },
      }[this];

  /// Convenient method Extension to generate a [token] from [DemoAppUser] enum
  Token? get token => <DemoAppUser, Token>{
        DemoAppUser.sahil: const Token(
            '''eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoic2FoaWwta3VtYXIifQ.mz3eZld6bN4pnkPweZQQW2CFC27btTGlF-njU3gToXc'''),
        DemoAppUser.sacha: const Token(
            '''eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoic2FjaGEtYXJib25lbCJ9.CJfmbovNUhQYpEGVyyD_a3fz0a_O7JPV7rOjma4dksA'''),
        DemoAppUser.nash: const Token(
            '''eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoibmVldmFzaC1yYW1kaWFsIn0.tiDNecUMjkFpKQbzduXRmd0Deb-ZbOtZs5yLX0ynmjo'''),
        DemoAppUser.gordon: const Token(
            '''eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiZ29yZG9uLWhheWVzIn0.PClf8PU3EQFgNef99QumuBDX8ufYmJrvPIRGLC3OMLA'''),
      }[this];
}
