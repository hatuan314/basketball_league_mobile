import 'package:postgres/postgres.dart';

class ConfigType {
  final Connection _conn;
  final String _schemaName;

  ConfigType(this._conn, this._schemaName);

  Future<void> createRefereeRoleType() async {
    final exists = await _checkTypeExists('referee_role');
    if (!exists) {
      await _createRefereeRoleEnum();
    }
  }

  Future<void> createPhoneType() async {
    final exists = await _checkTypeExists('phone_type');
    if (!exists) {
      await _createPhoneTypeEnum();
    }
  }

  Future<bool> _checkTypeExists(String typeName) async {
    final query = '''
      SELECT 1 
      FROM pg_type t
      JOIN pg_namespace n ON n.oid = t.typnamespace
      WHERE t.typname = '$typeName'
      AND n.nspname = '$_schemaName';
    ''';

    final result = await _conn.execute(query);
    return result.isNotEmpty;
  }

  Future<void> _createRefereeRoleEnum() {
    final query = '''
      CREATE TYPE $_schemaName.referee_role AS ENUM (
        'MAIN',      -- Trọng tài chính
        'ASSISTANT', -- Trợ lý
        'TABLE'      -- Trọng tài bàn
      );
    ''';

    return _conn.execute(query);
  }

  Future<void> _createPhoneTypeEnum() {
    final query = '''
      CREATE TYPE $_schemaName.phone_type AS ENUM (
        'MOBILE',
        'HOME',
        'WORK'
      );
    ''';

    return _conn.execute(query);
  }

  Future<void> listMyType() async {
    final query = '''
                  SELECT 
                      t.typname AS tên_kiểu_dữ_liệu,
                      CASE t.typtype
                          WHEN 'e' THEN 'ENUM'
                          WHEN 'c' THEN 'COMPOSITE'
                          WHEN 'd' THEN 'DOMAIN'
                          WHEN 'r' THEN 'RANGE'
                          ELSE t.typtype::text
                      END AS loại_kiểu_dữ_liệu,
                      n.nspname AS schema,
                      pg_catalog.format_type(t.oid, NULL) AS định_dạng_đầy_đủ,
                      CASE WHEN t.typtype = 'e' THEN
                          (SELECT string_agg(e.enumlabel, ', ' ORDER BY e.enumsortorder)
                          FROM pg_catalog.pg_enum e
                          WHERE e.enumtypid = t.oid)
                      ELSE NULL
                      END AS giá_trị_enum
                  FROM 
                      pg_catalog.pg_type t
                      JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
                  WHERE 
                      -- Loại bỏ các kiểu dữ liệu hệ thống
                      n.nspname NOT IN ('pg_catalog', 'information_schema')
                      -- Chỉ lấy các kiểu dữ liệu do người dùng tạo
                      AND (t.typrelid = 0 OR (SELECT c.relkind = 'c' FROM pg_catalog.pg_class c WHERE c.oid = t.typrelid))
                      AND NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type el WHERE el.oid = t.typelem AND el.typarray = t.oid)
                  ORDER BY 
                      n.nspname, t.typname;
                ''';
    final results = await _conn.execute(query);
    for (final row in results) {
      print("type: ${row[0]}");
    }
  }
}
