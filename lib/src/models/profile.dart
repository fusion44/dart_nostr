import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import 'nip05_verification_result.dart';

part 'profile.g.dart';

@Collection(ignore: {'props'})
class Profile extends Equatable {
  final Id id = Isar.autoIncrement;
  final String name;
  final String picture;
  final String about;
  final IsarLink<Nip05> nip05 = IsarLink<Nip05>();

  Profile({
    this.name = '',
    this.picture = '',
    this.about = '',
  });

  @override
  List<Object> get props => [name, picture, about, nip05];

  Profile.fromJson(Map<String, dynamic> json, Nip05? nip05)
      : name = json['name'] ?? '',
        picture = json['picture'] ?? '',
        about = json['about'] ?? '' {
    if (nip05 != null) {
      this.nip05.value = nip05;
      return;
    }
    if (json.containsKey('nip05')) {
      this.nip05.value = Nip05.fromJson(json['nip05']);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'picture': picture,
      'about': about,
      if (nip05.value != null) 'nip05': nip05.value!.toJson()
    };
  }
}
