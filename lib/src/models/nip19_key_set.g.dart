// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nip19_key_set.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetNip19KeySetCollection on Isar {
  IsarCollection<Nip19KeySet> get nip19KeySets => this.collection();
}

const Nip19KeySetSchema = CollectionSchema(
  name: r'Nip19KeySet',
  id: -671924427215107784,
  properties: {
    r'pubKeyBech32': PropertySchema(
      id: 0,
      name: r'pubKeyBech32',
      type: IsarType.string,
    ),
    r'pubKeyHex': PropertySchema(
      id: 1,
      name: r'pubKeyHex',
      type: IsarType.string,
    ),
    r'relayUrl': PropertySchema(
      id: 2,
      name: r'relayUrl',
      type: IsarType.string,
    )
  },
  estimateSize: _nip19KeySetEstimateSize,
  serialize: _nip19KeySetSerialize,
  deserialize: _nip19KeySetDeserialize,
  deserializeProp: _nip19KeySetDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _nip19KeySetGetId,
  getLinks: _nip19KeySetGetLinks,
  attach: _nip19KeySetAttach,
  version: '3.0.5',
);

int _nip19KeySetEstimateSize(
  Nip19KeySet object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.pubKeyBech32.length * 3;
  bytesCount += 3 + object.pubKeyHex.length * 3;
  bytesCount += 3 + object.relayUrl.length * 3;
  return bytesCount;
}

void _nip19KeySetSerialize(
  Nip19KeySet object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.pubKeyBech32);
  writer.writeString(offsets[1], object.pubKeyHex);
  writer.writeString(offsets[2], object.relayUrl);
}

Nip19KeySet _nip19KeySetDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Nip19KeySet(
    pubKeyBech32: reader.readString(offsets[0]),
    pubKeyHex: reader.readString(offsets[1]),
    relayUrl: reader.readStringOrNull(offsets[2]) ?? '',
  );
  object.id = id;
  return object;
}

P _nip19KeySetDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _nip19KeySetGetId(Nip19KeySet object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _nip19KeySetGetLinks(Nip19KeySet object) {
  return [];
}

void _nip19KeySetAttach(
    IsarCollection<dynamic> col, Id id, Nip19KeySet object) {
  object.id = id;
}

extension Nip19KeySetQueryWhereSort
    on QueryBuilder<Nip19KeySet, Nip19KeySet, QWhere> {
  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension Nip19KeySetQueryWhere
    on QueryBuilder<Nip19KeySet, Nip19KeySet, QWhereClause> {
  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension Nip19KeySetQueryFilter
    on QueryBuilder<Nip19KeySet, Nip19KeySet, QFilterCondition> {
  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyBech32EqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pubKeyBech32',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyBech32GreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pubKeyBech32',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyBech32LessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pubKeyBech32',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyBech32Between(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pubKeyBech32',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyBech32StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pubKeyBech32',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyBech32EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pubKeyBech32',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyBech32Contains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pubKeyBech32',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyBech32Matches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pubKeyBech32',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyBech32IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pubKeyBech32',
        value: '',
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyBech32IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pubKeyBech32',
        value: '',
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyHexEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pubKeyHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyHexGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pubKeyHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyHexLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pubKeyHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyHexBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pubKeyHex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyHexStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pubKeyHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyHexEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pubKeyHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyHexContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pubKeyHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyHexMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pubKeyHex',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyHexIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pubKeyHex',
        value: '',
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      pubKeyHexIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pubKeyHex',
        value: '',
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition> relayUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relayUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      relayUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relayUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      relayUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relayUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition> relayUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relayUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      relayUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'relayUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      relayUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'relayUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      relayUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relayUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition> relayUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relayUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      relayUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relayUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterFilterCondition>
      relayUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relayUrl',
        value: '',
      ));
    });
  }
}

extension Nip19KeySetQueryObject
    on QueryBuilder<Nip19KeySet, Nip19KeySet, QFilterCondition> {}

extension Nip19KeySetQueryLinks
    on QueryBuilder<Nip19KeySet, Nip19KeySet, QFilterCondition> {}

extension Nip19KeySetQuerySortBy
    on QueryBuilder<Nip19KeySet, Nip19KeySet, QSortBy> {
  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterSortBy> sortByPubKeyBech32() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKeyBech32', Sort.asc);
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterSortBy>
      sortByPubKeyBech32Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKeyBech32', Sort.desc);
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterSortBy> sortByPubKeyHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKeyHex', Sort.asc);
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterSortBy> sortByPubKeyHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKeyHex', Sort.desc);
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterSortBy> sortByRelayUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relayUrl', Sort.asc);
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterSortBy> sortByRelayUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relayUrl', Sort.desc);
    });
  }
}

extension Nip19KeySetQuerySortThenBy
    on QueryBuilder<Nip19KeySet, Nip19KeySet, QSortThenBy> {
  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterSortBy> thenByPubKeyBech32() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKeyBech32', Sort.asc);
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterSortBy>
      thenByPubKeyBech32Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKeyBech32', Sort.desc);
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterSortBy> thenByPubKeyHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKeyHex', Sort.asc);
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterSortBy> thenByPubKeyHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKeyHex', Sort.desc);
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterSortBy> thenByRelayUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relayUrl', Sort.asc);
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QAfterSortBy> thenByRelayUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relayUrl', Sort.desc);
    });
  }
}

extension Nip19KeySetQueryWhereDistinct
    on QueryBuilder<Nip19KeySet, Nip19KeySet, QDistinct> {
  QueryBuilder<Nip19KeySet, Nip19KeySet, QDistinct> distinctByPubKeyBech32(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pubKeyBech32', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QDistinct> distinctByPubKeyHex(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pubKeyHex', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Nip19KeySet, Nip19KeySet, QDistinct> distinctByRelayUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relayUrl', caseSensitive: caseSensitive);
    });
  }
}

extension Nip19KeySetQueryProperty
    on QueryBuilder<Nip19KeySet, Nip19KeySet, QQueryProperty> {
  QueryBuilder<Nip19KeySet, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Nip19KeySet, String, QQueryOperations> pubKeyBech32Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pubKeyBech32');
    });
  }

  QueryBuilder<Nip19KeySet, String, QQueryOperations> pubKeyHexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pubKeyHex');
    });
  }

  QueryBuilder<Nip19KeySet, String, QQueryOperations> relayUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relayUrl');
    });
  }
}
