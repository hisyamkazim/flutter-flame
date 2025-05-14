abstract class QueryManager {
  String createTable();
  String deleteTable();
  String getTableName() => 'scores';
  String orderBy(String category, String type) => 'ORDER BY $category $type';
  String getTable();

  String insertRecord(Map<String, dynamic> record) {
    final columns = record.keys.join(', ');
    final values = record.values.map((value) => "'$value'").join(', ');
    return '''
          INSERT INTO ${getTableName()} ($columns) VALUES ($values)
        ''';
  }

  String dropTable() => '''
          DROP TABLE IF EXISTS ${getTableName()}
        ''';
}

class Version1 extends QueryManager {
  @override
  String createTable() => '''
          CREATE TABLE scores (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date datetime DEFAULT CURRENT_TIMESTAMP,
            score INTEGER
          )
        ''';

  @override
  String getTable() {
    return '''
      WITH RankedScores AS (
        SELECT 
          score,
          date,
          ROW_NUMBER() OVER (
            PARTITION BY score 
            ORDER BY date DESC
          ) as rn
        FROM ${getTableName()}
      )
      SELECT score, date
      FROM RankedScores
      WHERE rn = 1
      ORDER BY score DESC
      LIMIT 5
    ''';
  }

  @override
  String deleteTable() => '''
          DELETE FROM ${getTableName()}
        ''';
}
