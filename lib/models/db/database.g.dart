// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class WordRecord extends DataClass implements Insertable<WordRecord> {
  final String strQuestion;
  final String strAnswer;
  final DateTime strTime;
  final bool isMemorized;
  WordRecord(
      {@required this.strQuestion,
      @required this.strAnswer,
      @required this.strTime,
      @required this.isMemorized});
  factory WordRecord.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return WordRecord(
      strQuestion: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_question']),
      strAnswer: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_answer']),
      strTime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}str_time']),
      isMemorized: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_memorized']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || strQuestion != null) {
      map['str_question'] = Variable<String>(strQuestion);
    }
    if (!nullToAbsent || strAnswer != null) {
      map['str_answer'] = Variable<String>(strAnswer);
    }
    if (!nullToAbsent || strTime != null) {
      map['str_time'] = Variable<DateTime>(strTime);
    }
    if (!nullToAbsent || isMemorized != null) {
      map['is_memorized'] = Variable<bool>(isMemorized);
    }
    return map;
  }

  WordRecordsCompanion toCompanion(bool nullToAbsent) {
    return WordRecordsCompanion(
      strQuestion: strQuestion == null && nullToAbsent
          ? const Value.absent()
          : Value(strQuestion),
      strAnswer: strAnswer == null && nullToAbsent
          ? const Value.absent()
          : Value(strAnswer),
      strTime: strTime == null && nullToAbsent
          ? const Value.absent()
          : Value(strTime),
      isMemorized: isMemorized == null && nullToAbsent
          ? const Value.absent()
          : Value(isMemorized),
    );
  }

  factory WordRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return WordRecord(
      strQuestion: serializer.fromJson<String>(json['strQuestion']),
      strAnswer: serializer.fromJson<String>(json['strAnswer']),
      strTime: serializer.fromJson<DateTime>(json['strTime']),
      isMemorized: serializer.fromJson<bool>(json['isMemorized']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'strQuestion': serializer.toJson<String>(strQuestion),
      'strAnswer': serializer.toJson<String>(strAnswer),
      'strTime': serializer.toJson<DateTime>(strTime),
      'isMemorized': serializer.toJson<bool>(isMemorized),
    };
  }

  WordRecord copyWith(
          {String strQuestion,
          String strAnswer,
          DateTime strTime,
          bool isMemorized}) =>
      WordRecord(
        strQuestion: strQuestion ?? this.strQuestion,
        strAnswer: strAnswer ?? this.strAnswer,
        strTime: strTime ?? this.strTime,
        isMemorized: isMemorized ?? this.isMemorized,
      );
  @override
  String toString() {
    return (StringBuffer('WordRecord(')
          ..write('strQuestion: $strQuestion, ')
          ..write('strAnswer: $strAnswer, ')
          ..write('strTime: $strTime, ')
          ..write('isMemorized: $isMemorized')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      strQuestion.hashCode,
      $mrjc(
          strAnswer.hashCode, $mrjc(strTime.hashCode, isMemorized.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is WordRecord &&
          other.strQuestion == this.strQuestion &&
          other.strAnswer == this.strAnswer &&
          other.strTime == this.strTime &&
          other.isMemorized == this.isMemorized);
}

class WordRecordsCompanion extends UpdateCompanion<WordRecord> {
  final Value<String> strQuestion;
  final Value<String> strAnswer;
  final Value<DateTime> strTime;
  final Value<bool> isMemorized;
  const WordRecordsCompanion({
    this.strQuestion = const Value.absent(),
    this.strAnswer = const Value.absent(),
    this.strTime = const Value.absent(),
    this.isMemorized = const Value.absent(),
  });
  WordRecordsCompanion.insert({
    @required String strQuestion,
    @required String strAnswer,
    @required DateTime strTime,
    this.isMemorized = const Value.absent(),
  })  : strQuestion = Value(strQuestion),
        strAnswer = Value(strAnswer),
        strTime = Value(strTime);
  static Insertable<WordRecord> custom({
    Expression<String> strQuestion,
    Expression<String> strAnswer,
    Expression<DateTime> strTime,
    Expression<bool> isMemorized,
  }) {
    return RawValuesInsertable({
      if (strQuestion != null) 'str_question': strQuestion,
      if (strAnswer != null) 'str_answer': strAnswer,
      if (strTime != null) 'str_time': strTime,
      if (isMemorized != null) 'is_memorized': isMemorized,
    });
  }

  WordRecordsCompanion copyWith(
      {Value<String> strQuestion,
      Value<String> strAnswer,
      Value<DateTime> strTime,
      Value<bool> isMemorized}) {
    return WordRecordsCompanion(
      strQuestion: strQuestion ?? this.strQuestion,
      strAnswer: strAnswer ?? this.strAnswer,
      strTime: strTime ?? this.strTime,
      isMemorized: isMemorized ?? this.isMemorized,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (strQuestion.present) {
      map['str_question'] = Variable<String>(strQuestion.value);
    }
    if (strAnswer.present) {
      map['str_answer'] = Variable<String>(strAnswer.value);
    }
    if (strTime.present) {
      map['str_time'] = Variable<DateTime>(strTime.value);
    }
    if (isMemorized.present) {
      map['is_memorized'] = Variable<bool>(isMemorized.value);
    }
    return map;
  }
}

class $WordRecordsTable extends WordRecords
    with TableInfo<$WordRecordsTable, WordRecord> {
  final GeneratedDatabase _db;
  final String _alias;
  $WordRecordsTable(this._db, [this._alias]);
  final VerificationMeta _strQuestionMeta =
      const VerificationMeta('strQuestion');
  GeneratedTextColumn _strQuestion;
  @override
  GeneratedTextColumn get strQuestion =>
      _strQuestion ??= _constructStrQuestion();
  GeneratedTextColumn _constructStrQuestion() {
    return GeneratedTextColumn(
      'str_question',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strAnswerMeta = const VerificationMeta('strAnswer');
  GeneratedTextColumn _strAnswer;
  @override
  GeneratedTextColumn get strAnswer => _strAnswer ??= _constructStrAnswer();
  GeneratedTextColumn _constructStrAnswer() {
    return GeneratedTextColumn(
      'str_answer',
      $tableName,
      false,
    );
  }

  final VerificationMeta _strTimeMeta = const VerificationMeta('strTime');
  GeneratedDateTimeColumn _strTime;
  @override
  GeneratedDateTimeColumn get strTime => _strTime ??= _constructStrTime();
  GeneratedDateTimeColumn _constructStrTime() {
    return GeneratedDateTimeColumn(
      'str_time',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isMemorizedMeta =
      const VerificationMeta('isMemorized');
  GeneratedBoolColumn _isMemorized;
  @override
  GeneratedBoolColumn get isMemorized =>
      _isMemorized ??= _constructIsMemorized();
  GeneratedBoolColumn _constructIsMemorized() {
    return GeneratedBoolColumn('is_memorized', $tableName, false,
        defaultValue: Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [strQuestion, strAnswer, strTime, isMemorized];
  @override
  $WordRecordsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'word_records';
  @override
  final String actualTableName = 'word_records';
  @override
  VerificationContext validateIntegrity(Insertable<WordRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('str_question')) {
      context.handle(
          _strQuestionMeta,
          strQuestion.isAcceptableOrUnknown(
              data['str_question'], _strQuestionMeta));
    } else if (isInserting) {
      context.missing(_strQuestionMeta);
    }
    if (data.containsKey('str_answer')) {
      context.handle(_strAnswerMeta,
          strAnswer.isAcceptableOrUnknown(data['str_answer'], _strAnswerMeta));
    } else if (isInserting) {
      context.missing(_strAnswerMeta);
    }
    if (data.containsKey('str_time')) {
      context.handle(_strTimeMeta,
          strTime.isAcceptableOrUnknown(data['str_time'], _strTimeMeta));
    } else if (isInserting) {
      context.missing(_strTimeMeta);
    }
    if (data.containsKey('is_memorized')) {
      context.handle(
          _isMemorizedMeta,
          isMemorized.isAcceptableOrUnknown(
              data['is_memorized'], _isMemorizedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {strQuestion};
  @override
  WordRecord map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return WordRecord.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $WordRecordsTable createAlias(String alias) {
    return $WordRecordsTable(_db, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $WordRecordsTable _wordRecords;
  $WordRecordsTable get wordRecords => _wordRecords ??= $WordRecordsTable(this);
  WordsDao _wordsDao;
  WordsDao get wordsDao => _wordsDao ??= WordsDao(this as MyDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [wordRecords];
}
