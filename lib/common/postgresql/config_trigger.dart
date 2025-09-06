import 'package:postgres/postgres.dart';

class ConfigTrigger {
  final Connection _conn;

  ConfigTrigger(this._conn);

  /// Trigger để đảm bảo mỗi mùa giải có ít nhất 8 đội
  Future<void> enforceMinTeamsPerSeason() async {
    final exists = await _triggerExists(
      'enforce_min_teams_per_season',
      'season_team',
    );
    if (!exists) {
      await _createMinTeamsPerSeasonTrigger();
    }
  }

  /// Tạo trigger đảm bảo mỗi mùa giải có ít nhất 8 đội
  Future<void> _createMinTeamsPerSeasonTrigger() async {
    // Xóa trigger nếu đã tồn tại
    final dropTrigger = '''
      DROP TRIGGER IF EXISTS enforce_min_teams_per_season ON season_team;
    ''';
    await _conn.execute(dropTrigger);

    // Xóa function nếu đã tồn tại
    final dropFunction = '''
      DROP FUNCTION IF EXISTS check_min_teams_per_season();
    ''';
    await _conn.execute(dropFunction);

    // Tạo function cho trigger sử dụng cú pháp khác
    final createFunction = '''
      CREATE OR REPLACE FUNCTION check_min_teams_per_season()
      RETURNS TRIGGER
      LANGUAGE plpgsql
      AS E'
      BEGIN
        -- Kiểm tra khi xóa một đội khỏi mùa giải
        IF TG_OP = ''DELETE'' THEN
          IF (SELECT COUNT(*) FROM season_team WHERE season_id = OLD.season_id) < 8 THEN
            RAISE EXCEPTION ''Mỗi mùa giải phải có ít nhất 8 đội tham gia'';
          END IF;
        END IF;
        RETURN NULL;
      END;'
    ''';
    await _conn.execute(createFunction);

    // Tạo trigger
    final createTrigger = '''
      CREATE TRIGGER enforce_min_teams_per_season
        AFTER DELETE ON season_team
        FOR EACH ROW
      EXECUTE FUNCTION check_min_teams_per_season();
    ''';
    await _conn.execute(createTrigger);
  }

  /// Kiểm tra sự tồn tại của trigger đảm bảo mã cầu thủ phản ánh thông tin về đội bóng
  Future<void> checkPlayerCodeFormat() async {
    final exists = await _triggerExists('enforce_player_code_format', 'player');
    if (!exists) {
      await _createPlayerCodeFormatTrigger();
    }
  }

  /// Tạo trigger đảm bảo mã cầu thủ phản ánh thông tin về đội bóng
  Future<void> _createPlayerCodeFormatTrigger() async {
    // Xóa trigger nếu đã tồn tại
    String dropTrigger = '''
      DROP TRIGGER IF EXISTS enforce_player_code_format ON player;
    ''';
    await _conn.execute(dropTrigger);

    dropTrigger = '''
      DROP TRIGGER IF EXISTS enforce_player_code_format ON player_season;
    ''';
    await _conn.execute(dropTrigger);

    // Xóa function nếu đã tồn tại
    final dropFunction = '''
      DROP FUNCTION IF EXISTS check_player_code_format();
    ''';
    await _conn.execute(dropFunction);

    // Tạo function cho trigger với cách tiếp cận đơn giản hơn
    final createFunction = '''
      CREATE OR REPLACE FUNCTION check_player_code_format()
      RETURNS TRIGGER
      LANGUAGE plpgsql
      AS '
      DECLARE
            team_code_val TEXT;
            player_code_val TEXT;
            expected_prefix TEXT;
        BEGIN
            -- Lấy team_code từ đội bóng mà cầu thủ tham gia trong mùa giải
            SELECT t.team_code INTO team_code_val
            FROM team t
                     JOIN season_team st ON t.team_id = st.team_id
            WHERE st.season_team_id = NEW.team_id;

            -- Lấy mã cầu thủ hiện tại
            SELECT p.player_code INTO player_code_val
            FROM player p
            WHERE p.player_id = NEW.player_id;
            
            -- Tạo tiền tố mong muốn
            expected_prefix := team_code_val || ''_'';

            -- Kiểm tra xem mã cầu thủ có bắt đầu bằng mã đội không
            -- Sử dụng substring để so sánh thay vì LIKE
            IF NOT (LEFT(player_code_val, LENGTH(expected_prefix)) = expected_prefix) THEN
                -- Tạo mã cầu thủ mới dựa trên mã đội và ID cầu thủ
                UPDATE player
                SET player_code = team_code_val || ''_'' || NEW.player_id
                WHERE player_id = NEW.player_id;
            END IF;

            RETURN NEW;
      END;
      '
    ''';
    await _conn.execute(createFunction);

    // Tạo trigger
    final createTrigger = '''
      CREATE TRIGGER enforce_player_code_format
        AFTER INSERT OR UPDATE ON player_season
        FOR EACH ROW
      EXECUTE FUNCTION check_player_code_format();
    ''';
    await _conn.execute(createTrigger);
  }

  /// Kiểm tra sự tồn tại của trigger đảm bảo mỗi đội có tối đa 20 cầu thủ
  Future<void> checkMaxPlayersPerTeam() async {
    final exists = await _triggerExists(
      'enforce_max_players_per_team',
      'player_season',
    );
    if (!exists) {
      await _createMaxPlayersPerTeamTrigger();
    }
  }

  /// Tạo trigger đảm bảo mỗi đội có tối đa 20 cầu thủ
  Future<void> _createMaxPlayersPerTeamTrigger() async {
    // Xóa trigger nếu đã tồn tại
    final dropTrigger = '''
      DROP TRIGGER IF EXISTS enforce_max_players_per_team ON player_season;
    ''';
    await _conn.execute(dropTrigger);

    // Xóa function nếu đã tồn tại
    final dropFunction = '''
      DROP FUNCTION IF EXISTS check_max_players_per_team();
    ''';
    await _conn.execute(dropFunction);

    // Tạo function cho trigger
    final createFunction = '''
      CREATE OR REPLACE FUNCTION check_max_players_per_team()
      RETURNS TRIGGER
      LANGUAGE plpgsql
      AS E'
      BEGIN
        IF (SELECT COUNT(*) FROM player_season WHERE team_id = NEW.team_id) > 20 THEN
          RAISE EXCEPTION ''Mỗi đội bóng chỉ được phép có tối đa 20 cầu thủ'';
        END IF;
        RETURN NEW;
      END;'
    ''';
    await _conn.execute(createFunction);

    // Tạo trigger
    final createTrigger = '''
      CREATE TRIGGER enforce_max_players_per_team
        BEFORE INSERT OR UPDATE ON player_season
        FOR EACH ROW
      EXECUTE FUNCTION check_max_players_per_team();
    ''';
    await _conn.execute(createTrigger);
  }

  /// Kiểm tra sự tồn tại của trigger đảm bảo màu áo của đội trong trận đấu nằm trong danh sách màu áo đã đăng ký
  Future<void> enforceTeamColorRegistration() async {
    final exists = await _triggerExists(
      'enforce_team_color_registration',
      'match',
    );
    if (!exists) {
      await _createTeamColorRegistrationTrigger();
    }
  }

  /// Tạo trigger đảm bảo màu áo của đội trong trận đấu nằm trong danh sách màu áo đã đăng ký
  Future<void> _createTeamColorRegistrationTrigger() async {
    // Xóa trigger nếu đã tồn tại
    final dropTrigger = '''
      DROP TRIGGER IF EXISTS enforce_team_color_registration ON match;
    ''';
    await _conn.execute(dropTrigger);

    // Xóa function nếu đã tồn tại
    final dropFunction = '''
      DROP FUNCTION IF EXISTS check_team_color_registration();
    ''';
    await _conn.execute(dropFunction);

    // Tạo function cho trigger
    final createFunction = '''
      CREATE OR REPLACE FUNCTION check_team_color_registration()
      RETURNS TRIGGER
      LANGUAGE plpgsql
      AS E'
      DECLARE
        home_season_id INT;
        away_season_id INT;
        home_team_actual_id INT;
        away_team_actual_id INT;
        color_exists BOOLEAN;
      BEGIN
        -- Lấy thông tin mùa giải và đội bóng
        SELECT st.season_id, st.team_id INTO home_season_id, home_team_actual_id
        FROM season_team st
        WHERE st.season_team_id = NEW.home_team_id;

        SELECT st.season_id, st.team_id INTO away_season_id, away_team_actual_id
        FROM season_team st
        WHERE st.season_team_id = NEW.away_team_id;

        -- Kiểm tra màu áo đội nhà
        SELECT EXISTS (
          SELECT 1 FROM team_color
          WHERE season_id = home_season_id
            AND team_id = home_team_actual_id
            AND color_name = NEW.home_color
        ) INTO color_exists;

        IF NOT color_exists THEN
          RAISE EXCEPTION ''Màu áo % không nằm trong danh sách màu áo đã đăng ký của đội nhà'', NEW.home_color;
        END IF;

        -- Kiểm tra màu áo đội khách
        SELECT EXISTS (
          SELECT 1 FROM team_color
          WHERE season_id = away_season_id
            AND team_id = away_team_actual_id
            AND color_name = NEW.away_color
        ) INTO color_exists;

        IF NOT color_exists THEN
          RAISE EXCEPTION ''Màu áo % không nằm trong danh sách màu áo đã đăng ký của đội khách'', NEW.away_color;
        END IF;

        RETURN NEW;
      END;'
    ''';
    await _conn.execute(createFunction);

    // Tạo trigger
    final createTrigger = '''
      CREATE TRIGGER enforce_team_color_registration
        BEFORE INSERT OR UPDATE ON match
        FOR EACH ROW
      EXECUTE FUNCTION check_team_color_registration();
    ''';
    await _conn.execute(createTrigger);
  }

  /// Kiểm tra sự tồn tại của trigger đảm bảo mỗi đội chỉ đăng ký tối đa 12 cầu thủ cho một trận đấu
  Future<void> enforceMaxPlayersPerMatch() async {
    final exists = await _triggerExists(
      'enforce_max_players_per_match',
      'match_player',
    );
    if (!exists) {
      await _createMaxPlayersPerMatchTrigger();
    }
  }

  /// Tạo trigger đảm bảo mỗi đội chỉ đăng ký tối đa 12 cầu thủ cho một trận đấu
  Future<void> _createMaxPlayersPerMatchTrigger() async {
    // Xóa trigger nếu đã tồn tại
    final dropTrigger = '''
      DROP TRIGGER IF EXISTS enforce_max_players_per_match ON match_player;
    ''';
    await _conn.execute(dropTrigger);

    // Xóa function nếu đã tồn tại
    final dropFunction = '''
      DROP FUNCTION IF EXISTS check_max_players_per_match();
    ''';
    await _conn.execute(dropFunction);

    // Tạo function cho trigger
    final createFunction = '''
      CREATE OR REPLACE FUNCTION check_max_players_per_match()
      RETURNS TRIGGER
      LANGUAGE plpgsql
      AS E'
      DECLARE
        home_count INT;
        away_count INT;
        match_home_team_id INT;
        match_away_team_id INT;
      BEGIN
        -- Lấy thông tin đội nhà và đội khách của trận đấu
        SELECT home_team_id, away_team_id INTO match_home_team_id, match_away_team_id
        FROM match
        WHERE match_id = NEW.match_id;

        -- Đếm số cầu thủ của đội nhà trong trận đấu
        SELECT COUNT(*) INTO home_count
        FROM match_player mp
          JOIN player_season ps ON mp.player_id = ps.player_season_id
        WHERE mp.match_id = NEW.match_id AND ps.team_id = match_home_team_id;

        -- Đếm số cầu thủ của đội khách trong trận đấu
        SELECT COUNT(*) INTO away_count
        FROM match_player mp
          JOIN player_season ps ON mp.player_id = ps.player_season_id
        WHERE mp.match_id = NEW.match_id AND ps.team_id = match_away_team_id;

        -- Kiểm tra số lượng cầu thủ
        IF home_count > 12 THEN
          RAISE EXCEPTION ''Đội nhà chỉ được đăng ký tối đa 12 cầu thủ cho một trận đấu'';
        END IF;

        IF away_count > 12 THEN
          RAISE EXCEPTION ''Đội khách chỉ được đăng ký tối đa 12 cầu thủ cho một trận đấu'';
        END IF;

        RETURN NEW;
      END;'
    ''';
    await _conn.execute(createFunction);

    // Tạo trigger
    final createTrigger = '''
      CREATE TRIGGER enforce_max_players_per_match
        BEFORE INSERT OR UPDATE ON match_player
        FOR EACH ROW
      EXECUTE FUNCTION check_max_players_per_match();
    ''';
    await _conn.execute(createTrigger);
  }

  /// Kiểm tra sự tồn tại của trigger đảm bảo tổng điểm và lỗi của cầu thủ bằng với tổng điểm và lỗi của đội
  Future<void> updateMatchStats() async {
    final exists = await _triggerExists(
      'update_match_stats',
      'match_player_stats',
    );
    if (!exists) {
      await _createMatchStatsTrigger();
    }
  }

  /// Tạo trigger đảm bảo tổng điểm và lỗi của cầu thủ bằng với tổng điểm và lỗi của đội
  Future<void> _createMatchStatsTrigger() async {
    // Xóa trigger nếu đã tồn tại
    final dropTrigger = '''
      DROP TRIGGER IF EXISTS update_match_stats ON match_player_stats;
    ''';
    await _conn.execute(dropTrigger);

    // Xóa function nếu đã tồn tại
    final dropFunction = '''
      DROP FUNCTION IF EXISTS check_team_stats_consistency();
    ''';
    await _conn.execute(dropFunction);

    // Tạo function cho trigger
    final createFunction = '''
      CREATE OR REPLACE FUNCTION check_team_stats_consistency()
      RETURNS TRIGGER
      LANGUAGE plpgsql
      AS E'\n
      DECLARE\n
        home_team_id INT;\n
        away_team_id INT;\n
        home_points_sum INT;\n
        away_points_sum INT;\n
        home_fouls_sum INT;\n
        away_fouls_sum INT;\n
      BEGIN\n
        -- Lấy thông tin đội nhà và đội khách\n
        SELECT m.home_team_id, m.away_team_id INTO home_team_id, away_team_id\n
        FROM match m\n
        WHERE m.match_id = NEW.match_id;\n
\n
        -- Tính tổng điểm và lỗi của đội nhà\n
        SELECT COALESCE(SUM(mps.points), 0), COALESCE(SUM(mps.fouls), 0)\n
        INTO home_points_sum, home_fouls_sum\n
        FROM match_player mp\n
          JOIN match_player_stats mps ON mp.match_player_id = mps.match_player_id\n
          JOIN player_season ps ON mp.player_id = ps.player_season_id\n
        WHERE mp.match_id = NEW.match_id AND ps.team_id = home_team_id;\n
\n
        -- Tính tổng điểm và lỗi của đội khách\n
        SELECT COALESCE(SUM(mps.points), 0), COALESCE(SUM(mps.fouls), 0)\n
        INTO away_points_sum, away_fouls_sum\n
        FROM match_player mp\n
          JOIN match_player_stats mps ON mp.match_player_id = mps.match_player_id\n
          JOIN player_season ps ON mp.player_id = ps.player_season_id\n
        WHERE mp.match_id = NEW.match_id AND ps.team_id = away_team_id;\n
\n
        -- Cập nhật điểm và lỗi của trận đấu\n
        UPDATE match\n
        SET home_points = home_points_sum,\n
            away_points = away_points_sum,\n
            home_fouls = home_fouls_sum,\n
            away_fouls = away_fouls_sum\n
        WHERE match_id = NEW.match_id;\n
\n
        RETURN NEW;\n
      END;'
    ''';
    await _conn.execute(createFunction);

    // Tạo trigger
    final createTrigger = '''
      CREATE TRIGGER update_match_stats
        AFTER INSERT OR UPDATE ON match_player_stats
        FOR EACH ROW
      EXECUTE FUNCTION check_team_stats_consistency();
    ''';
    await _conn.execute(createTrigger);
  }

  /// Kiểm tra sự tồn tại của trigger đảm bảo mỗi đội thi đấu với tất cả các đội khác và không quá 4 trận với mỗi đội
  Future<void> enforceMatchLimitBetweenTeams() async {
    final exists = await _triggerExists(
      'enforce_match_limit_between_teams',
      'match',
    );
    if (!exists) {
      await _createMatchLimitBetweenTeamsTrigger();
    }
  }

  /// Tạo trigger đảm bảo mỗi đội thi đấu với tất cả các đội khác và không quá 4 trận với mỗi đội
  Future<void> _createMatchLimitBetweenTeamsTrigger() async {
    // Xóa trigger nếu đã tồn tại
    final dropTrigger = '''
      DROP TRIGGER IF EXISTS enforce_match_limit_between_teams ON match;
    ''';
    await _conn.execute(dropTrigger);

    // Xóa function nếu đã tồn tại
    final dropFunction = '''
      DROP FUNCTION IF EXISTS check_match_limit_between_teams();
    ''';
    await _conn.execute(dropFunction);

    // Tạo function cho trigger
    final createFunction = '''
      CREATE OR REPLACE FUNCTION check_match_limit_between_teams()
      RETURNS TRIGGER
      LANGUAGE plpgsql
      AS E'
      DECLARE
        season_id INT;
        match_count INT;
        home_team_actual_id INT;
        away_team_actual_id INT;
      BEGIN
        -- Lấy thông tin mùa giải và đội bóng
        SELECT st1.season_id, st1.team_id, st2.team_id
        INTO season_id, home_team_actual_id, away_team_actual_id
        FROM season_team st1, season_team st2
        WHERE st1.season_team_id = NEW.home_team_id AND st2.season_team_id = NEW.away_team_id;

        -- Đếm số trận đấu giữa hai đội trong mùa giải
        SELECT COUNT(*) INTO match_count
        FROM match m
          JOIN round r ON m.round_id = r.round_id
          JOIN season_team st_home ON m.home_team_id = st_home.season_team_id
          JOIN season_team st_away ON m.away_team_id = st_away.season_team_id
        WHERE r.season_id = season_id
          AND ((st_home.team_id = home_team_actual_id AND st_away.team_id = away_team_actual_id)
            OR (st_home.team_id = away_team_actual_id AND st_away.team_id = home_team_actual_id));

        IF match_count >= 4 THEN
          RAISE EXCEPTION ''Hai đội không được thi đấu quá 4 trận với nhau trong một mùa giải'';
        END IF;

        RETURN NEW;
      END;'
    ''';
    await _conn.execute(createFunction);

    // Tạo trigger
    final createTrigger = '''
      CREATE TRIGGER enforce_match_limit_between_teams
        BEFORE INSERT OR UPDATE ON match
        FOR EACH ROW
      EXECUTE FUNCTION check_match_limit_between_teams();
    ''';
    await _conn.execute(createTrigger);
  }

  /// Kiểm tra sự tồn tại của trigger đảm bảo mỗi trận đấu có đúng 4 trọng tài (3 chính và 1 bàn)
  Future<void> enforceRefereeCountPerMatch() async {
    final exists = await _triggerExists(
      'enforce_referee_count_per_match',
      'match_referee',
    );
    if (!exists) {
      await _createRefereeCountPerMatchTrigger();
    }
  }

  /// Tạo trigger đảm bảo mỗi trận đấu có đúng 4 trọng tài (3 chính và 1 bàn)
  Future<void> _createRefereeCountPerMatchTrigger() async {
    // Xóa trigger nếu đã tồn tại
    final dropTrigger = '''
      DROP TRIGGER IF EXISTS enforce_referee_count_per_match ON match_referee;
    ''';
    await _conn.execute(dropTrigger);

    // Xóa function nếu đã tồn tại
    final dropFunction = '''
      DROP FUNCTION IF EXISTS check_referee_count_per_match();
    ''';
    await _conn.execute(dropFunction);

    // Tạo function cho trigger
    final createFunction = '''
      CREATE OR REPLACE FUNCTION check_referee_count_per_match()
      RETURNS TRIGGER
      LANGUAGE plpgsql
      AS E'
      DECLARE
        main_ref_count INT;
        assistant_ref_count INT;
        table_ref_count INT;
        total_ref_count INT;
      BEGIN
        -- Đếm số lượng trọng tài theo vai trò
        SELECT
          COUNT(*) FILTER (WHERE role = ''MAIN''),
          COUNT(*) FILTER (WHERE role = ''ASSISTANT''),
          COUNT(*) FILTER (WHERE role = ''TABLE''),
          COUNT(*)
        INTO main_ref_count, assistant_ref_count, table_ref_count, total_ref_count
        FROM match_referee
        WHERE match_id = NEW.match_id;

        -- Kiểm tra số lượng trọng tài
        IF total_ref_count > 4 THEN
          RAISE EXCEPTION ''Mỗi trận đấu chỉ được có tối đa 4 trọng tài'';
        END IF;

        IF main_ref_count > 1 THEN
          RAISE EXCEPTION ''Mỗi trận đấu chỉ được có 1 trọng tài chính'';
        END IF;

        IF assistant_ref_count > 2 THEN
          RAISE EXCEPTION ''Mỗi trận đấu chỉ được có tối đa 2 trợ lý trọng tài'';
        END IF;

        IF table_ref_count > 1 THEN
          RAISE EXCEPTION ''Mỗi trận đấu chỉ được có 1 trọng tài bàn'';
        END IF;

        RETURN NEW;
      END;'
    ''';
    await _conn.execute(createFunction);

    // Tạo trigger
    final createTrigger = '''
      CREATE TRIGGER enforce_referee_count_per_match
        AFTER INSERT OR UPDATE ON match_referee
        FOR EACH ROW
      EXECUTE FUNCTION check_referee_count_per_match();
    ''';
    await _conn.execute(createTrigger);
  }

  /// Kiểm tra sự tồn tại của trigger đảm bảo một trọng tài chỉ điều khiển tối đa 1 trận đấu trong mỗi vòng đấu
  Future<void> enforceRefereeMatchLimitPerRound() async {
    final exists = await _triggerExists(
      'enforce_referee_match_limit_per_round',
      'match_referee',
    );
    if (!exists) {
      await _createRefereeMatchLimitPerRoundTrigger();
    }
  }

  /// Tạo trigger đảm bảo một trọng tài chỉ điều khiển tối đa 1 trận đấu trong mỗi vòng đấu
  Future<void> _createRefereeMatchLimitPerRoundTrigger() async {
    // Xóa trigger nếu đã tồn tại
    final dropTrigger = '''
      DROP TRIGGER IF EXISTS enforce_referee_match_limit_per_round ON match_referee;
    ''';
    await _conn.execute(dropTrigger);

    // Xóa function nếu đã tồn tại
    final dropFunction = '''
      DROP FUNCTION IF EXISTS check_referee_match_limit_per_round();
    ''';
    await _conn.execute(dropFunction);

    // Tạo function cho trigger
    final createFunction = '''
      CREATE OR REPLACE FUNCTION check_referee_match_limit_per_round()
      RETURNS TRIGGER
      LANGUAGE plpgsql
      AS E'
      DECLARE
        round_id_val INT;
        match_count INT;
      BEGIN
        -- Lấy vòng đấu của trận đấu hiện tại
        SELECT m.round_id INTO round_id_val
        FROM match m
        WHERE m.match_id = NEW.match_id;

        -- Đếm số trận đấu mà trọng tài đã tham gia trong vòng đấu
        SELECT COUNT(*) INTO match_count
        FROM match_referee mr
          JOIN match m ON mr.match_id = m.match_id
        WHERE m.round_id = round_id_val AND mr.referee_id = NEW.referee_id;

        IF match_count > 1 THEN
          RAISE EXCEPTION ''Trọng tài chỉ được điều khiển tối đa 1 trận đấu trong mỗi vòng đấu'';
        END IF;

        RETURN NEW;
      END;'
    ''';
    await _conn.execute(createFunction);

    // Tạo trigger
    final createTrigger = '''
      CREATE TRIGGER enforce_referee_match_limit_per_round
        BEFORE INSERT OR UPDATE ON match_referee
        FOR EACH ROW
      EXECUTE FUNCTION check_referee_match_limit_per_round();
    ''';
    await _conn.execute(createTrigger);
  }

  /// Kiểm tra sự tồn tại của trigger đảm bảo mỗi đội đăng ký ít nhất 3 màu áo mỗi mùa giải
  Future<void> enforceMinTeamColors() async {
    final exists = await _triggerExists(
      'enforce_min_team_colors',
      'team_color',
    );
    if (!exists) {
      await _createMinTeamColorsTrigger();
    }
  }

  /// Tạo trigger đảm bảo mỗi đội đăng ký ít nhất 3 màu áo mỗi mùa giải
  Future<void> _createMinTeamColorsTrigger() async {
    // Xóa trigger nếu đã tồn tại
    final dropTrigger = '''
      DROP TRIGGER IF EXISTS enforce_min_team_colors ON team_color;
    ''';
    await _conn.execute(dropTrigger);

    // Xóa function nếu đã tồn tại
    final dropFunction = '''
      DROP FUNCTION IF EXISTS check_min_team_colors();
    ''';
    await _conn.execute(dropFunction);

    // Tạo function cho trigger
    final createFunction = '''
      CREATE OR REPLACE FUNCTION check_min_team_colors()
      RETURNS TRIGGER
      LANGUAGE plpgsql
      AS E'
      DECLARE
        color_count INT;
      BEGIN
        -- Đếm số màu áo đã đăng ký của đội trong mùa giải
        SELECT COUNT(*) INTO color_count
        FROM team_color
        WHERE season_id = NEW.season_id AND team_id = NEW.team_id;

        IF color_count < 3 THEN
          RAISE EXCEPTION ''Mỗi đội phải đăng ký ít nhất 3 màu áo cho mỗi mùa giải'';
        END IF;

        RETURN NEW;
      END;'
    ''';
    await _conn.execute(createFunction);

    // Tạo trigger
    final createTrigger = '''
      CREATE TRIGGER enforce_min_team_colors
        AFTER DELETE ON team_color
        FOR EACH ROW
      EXECUTE FUNCTION check_min_team_colors();
    ''';
    await _conn.execute(createTrigger);
  }

  /// Trigger Tạo địa điểm thi đấu cho trận đấu nếu chưa có
  Future<void> createMatchVenue() async {
    final exists = await _triggerExists('create_match_venue', 'match');
    if (!exists) {
      await _createMatchVenueTrigger();
    }
  }

  /// Tạo trigger tạo địa điểm thi đấu cho trận đấu nếu chưa có
  Future<void> _createMatchVenueTrigger() async {
    // Xóa trigger nếu đã tồn tại
    final dropTrigger = '''
      DROP TRIGGER IF EXISTS create_match_venue ON match;
    ''';
    await _conn.execute(dropTrigger);

    // Tạo function cho trigger
    final createFunction = '''
      CREATE OR REPLACE FUNCTION create_match_venue_func()
        RETURNS TRIGGER
        LANGUAGE plpgsql
        AS E'
      DECLARE
        venue_id INT;
      BEGIN
        -- Kiểm tra xem trận đấu đã có địa điểm thi đấu chưa
        IF NEW.venue_id IS NULL THEN
          -- Lấy địa điểm thi đấu của đội nhà
          SELECT home_venue_id INTO venue_id
          FROM season_team
          WHERE season_team_id = NEW.home_team_id;

          -- Nếu có địa điểm thi đấu, gán cho trận đấu
          IF venue_id IS NOT NULL THEN
            NEW.venue_id := venue_id;
          END IF;
        END IF;

        RETURN NEW;
      END;'
    ''';
    await _conn.execute(createFunction);

    // Tạo trigger
    final createTrigger = '''
      CREATE TRIGGER create_match_venue
        BEFORE INSERT OR UPDATE ON match
        FOR EACH ROW
      EXECUTE FUNCTION create_match_venue_func();
    ''';
    await _conn.execute(createTrigger);
  }

  /// Kiểm tra sự tồn tại của trigger
  Future<bool> _triggerExists(String triggerName, String tableName) async {
    // Sử dụng cách an toàn hơn để tránh SQL injection
    final query = '''
      SELECT EXISTS (
        SELECT 1
        FROM pg_trigger
        WHERE tgname = '$triggerName' AND tgrelid::regclass::text = '$tableName'
      );
    ''';
    final result = await _conn.execute(query);
    return result[0][0] as bool;
  }

  Future<void> listTrigger() async {
    final query = '''
                  SELECT
                      event_object_schema as schema_name,
                      event_object_table as table_name,
                      trigger_name,
                      event_manipulation as event,
                      action_statement as definition,
                      action_timing as timing
                  FROM information_schema.triggers
                  ORDER BY schema_name, table_name, trigger_name;
                  ''';
    final result = await _conn.execute(query);
    for (final row in result) {
      print("trigger: ${row[2]}");
    }
  }
}
