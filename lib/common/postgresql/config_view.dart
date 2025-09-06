import 'package:postgres/postgres.dart';

class ConfigView {
  final Connection _conn;

  ConfigView(this._conn);

  /// Kiểm tra sự tồn tại của view
  Future<bool> _checkExistView(String viewName) async {
    try {
      final result = await _conn.execute('''
        SELECT EXISTS (
          SELECT 1
          FROM pg_views
          WHERE viewname = '$viewName'
        ) as view_exists
      ''');

      return result[0][0] as bool;
    } catch (e) {
      print('Lỗi khi kiểm tra view $viewName: $e');
      return false;
    }
  }

  /// 1. View thông tin chi tiết về cầu thủ
  Future<void> createPlayerDetails() async {
    final exists = await _checkExistView('player_details');
    if (!exists) {
      await _createPlayerDetailsView();
    }
  }

  Future<void> _createPlayerDetailsView() async {
    final query = '''
                CREATE OR REPLACE VIEW player_details AS
                SELECT 
                    p.player_id,
                    p.player_code,
                    p.full_name,
                    p.dob,
                    p.height_cm,
                    p.weight_kg,
                    t.team_id,
                    t.team_name,
                    t.team_code,
                    ps.shirt_number,
                    s.season_id,
                    s.name AS season_name
                FROM 
                    player p
                JOIN 
                    player_season ps ON p.player_id = ps.player_id
                JOIN 
                    season_team st ON ps.season_team_id = st.season_team_id
                JOIN 
                    team t ON st.team_id = t.team_id
                JOIN 
                    season s ON st.season_id = s.season_id;
                ''';
    await _conn.execute(query);
  }

  /// 2. View thông tin chi tiết về trận đấu
  Future<void> createMatchDetails() async {
    final exists = await _checkExistView('match_details');
    if (!exists) {
      await _createMatchDetailsView();
    }
  }

  Future<void> _createMatchDetailsView() async {
    final query = '''
                CREATE OR REPLACE VIEW match_details AS
                SELECT 
                    m.match_id,
                    m.match_datetime,
                    r.round_id,
                    r.round_no,
                    s.season_id,
                    s.name AS season_name,
                    home_team.team_id AS home_team_id,
                    home_team.team_name AS home_team_name,
                    away_team.team_id AS away_team_id,
                    away_team.team_name AS away_team_name,
                    m.home_color,
                    m.away_color,
                    m.home_points,
                    m.away_points,
                    m.home_fouls,
                    m.away_fouls,
                    m.attendance,
                    mv.stadium_id,
                    stadium.name AS stadium_name,
                    stadium.ticket_price,
                    CASE 
                        WHEN m.home_points > m.away_points THEN home_team.team_id
                        WHEN m.away_points > m.home_points THEN away_team.team_id
                        ELSE NULL -- Không có đội thắng (trường hợp hiếm)
                    END AS winner_team_id,
                    CASE 
                        WHEN m.home_points > m.away_points THEN home_team.team_name
                        WHEN m.away_points > m.home_points THEN away_team.team_name
                        ELSE NULL -- Không có đội thắng (trường hợp hiếm)
                    END AS winner_team_name
                FROM 
                    match m
                JOIN 
                    round r ON m.round_id = r.round_id
                JOIN 
                    season s ON r.season_id = s.season_id
                JOIN 
                    season_team home_st ON m.home_team_id = home_st.season_team_id
                JOIN 
                    team home_team ON home_st.team_id = home_team.team_id
                JOIN 
                    season_team away_st ON m.away_team_id = away_st.season_team_id
                JOIN 
                    team away_team ON away_st.team_id = away_team.team_id
                JOIN 
                    match_venue mv ON m.match_id = mv.match_id
                JOIN 
                    stadium ON mv.stadium_id = stadium.stadium_id;
                ''';
    await _conn.execute(query);
  }

  /// 3. View thông tin chi tiết về cầu thủ trong trận đấu
  Future<void> createMatchPlayerDetails() async {
    final exists = await _checkExistView('match_player_details');
    if (!exists) {
      await _createMatchPlayerDetailsView();
    }
  }

  Future<void> _createMatchPlayerDetailsView() async {
    final query = '''
                CREATE OR REPLACE VIEW match_player_details AS
                SELECT 
                    mp.match_player_id,
                    mp.match_id,
                    m.match_datetime,
                    r.round_id,
                    r.round_no,
                    s.season_id,
                    s.name AS season_name,
                    ps.player_id,
                    p.player_code,
                    p.full_name AS player_name,
                    t.team_id,
                    t.team_name,
                    ps.shirt_number,
                    mps.points,
                    mps.fouls,
                    CASE 
                        WHEN st.season_team_id = m.home_team_id THEN 'HOME'
                        ELSE 'AWAY'
                    END AS team_type
                FROM 
                    match_player mp
                JOIN 
                    match m ON mp.match_id = m.match_id
                JOIN 
                    round r ON m.round_id = r.round_id
                JOIN 
                    season s ON r.season_id = s.season_id
                JOIN 
                    player_season ps ON mp.player_id = ps.player_season_id
                JOIN 
                    player p ON ps.player_id = p.player_id
                JOIN 
                    season_team st ON ps.season_team_id = st.season_team_id
                JOIN 
                    team t ON st.team_id = t.team_id
                LEFT JOIN 
                    match_player_stats mps ON mp.match_player_id = mps.match_player_id;
                ''';
    await _conn.execute(query);
  }

  /// 4. View thông tin chi tiết về trọng tài trong trận đấu
  Future<void> createMatchRefereeDetails() async {
    final exists = await _checkExistView('match_referee_details');
    if (!exists) {
      await _createMatchRefereeDetailsView();
    }
  }

  Future<void> _createMatchRefereeDetailsView() async {
    final query = '''
                CREATE OR REPLACE VIEW match_referee_details AS
                SELECT 
                    mr.match_referee_id,
                    mr.match_id,
                    m.match_datetime,
                    r.round_id,
                    r.round_no,
                    s.season_id,
                    s.name AS season_name,
                    mr.referee_id,
                    ref.full_name AS referee_name,
                    mr.role,
                    CASE 
                        WHEN mr.role = 'MAIN' THEN 1000000 -- 1 triệu đồng/trận
                        WHEN mr.role = 'ASSISTANT' THEN 500000 -- 500 nghìn đồng/trận
                        WHEN mr.role = 'TABLE' THEN 500000 -- 500 nghìn đồng/trận
                        ELSE 0
                    END AS fee_per_match
                FROM 
                    match_referee mr
                JOIN 
                    match m ON mr.match_id = m.match_id
                JOIN 
                    round r ON m.round_id = r.round_id
                JOIN 
                    season s ON r.season_id = s.season_id
                JOIN 
                    referee ref ON mr.referee_id = ref.referee_id;
                ''';
    await _conn.execute(query);
  }

  /// 5. View bảng xếp hạng đội bóng
  Future<void> createTeamStandings() async {
    final exists = await _checkExistView('team_standings');
    if (!exists) {
      await _createTeamStandingsView();
    }
  }

  Future<void> _createTeamStandingsView() async {
    final query = '''
                CREATE OR REPLACE VIEW team_standings AS
                WITH match_results AS (
                    SELECT
                        s.season_id,
                        s.name AS season_name,
                        home_st.team_id,
                        home_team.team_name,
                        m.match_id,
                        CASE
                            WHEN m.home_points > m.away_points THEN 2 -- Thắng 2 điểm
                            ELSE 0 -- Thua 0 điểm
                            END AS points,
                        CASE
                            WHEN m.home_points > m.away_points THEN 1
                            ELSE 0
                            END AS wins,
                        CASE
                            WHEN m.home_points > m.away_points THEN 0
                            ELSE 1
                            END AS losses,
                        CASE
                            WHEN m.home_points > m.away_points THEN 1
                            ELSE 0
                            END AS home_wins,
                        CASE
                            WHEN m.home_points > m.away_points THEN 0
                            ELSE 0
                            END AS away_wins,
                        m.home_points AS points_scored,
                        m.away_points AS points_conceded,
                        m.home_fouls AS fouls
                    FROM
                        match m
                            JOIN
                        round r ON m.round_id = r.round_id
                            JOIN
                        season s ON r.season_id = s.season_id
                            JOIN
                        season_team home_st ON m.home_team_id = home_st.season_team_id
                            JOIN
                        team home_team ON home_st.team_id = home_team.team_id

                    UNION ALL

                    SELECT
                        s.season_id,
                        s.name AS season_name,
                        away_st.team_id,
                        away_team.team_name,
                        m.match_id,
                        CASE
                            WHEN m.away_points > m.home_points THEN 2 -- Thắng 2 điểm
                            ELSE 0 -- Thua 0 điểm
                            END AS points,
                        CASE
                            WHEN m.away_points > m.home_points THEN 1
                            ELSE 0
                            END AS wins,
                        CASE
                            WHEN m.away_points > m.home_points THEN 0
                            ELSE 1
                            END AS losses,
                        CASE
                            WHEN m.away_points > m.home_points THEN 0
                            ELSE 0
                            END AS home_wins,
                        CASE
                            WHEN m.away_points > m.home_points THEN 1
                            ELSE 0
                            END AS away_wins,
                        m.away_points AS points_scored,
                        m.home_points AS points_conceded,
                        m.away_fouls AS fouls
                    FROM
                        match m
                            JOIN
                        round r ON m.round_id = r.round_id
                            JOIN
                        season s ON r.season_id = s.season_id
                            JOIN
                        season_team away_st ON m.away_team_id = away_st.season_team_id
                            JOIN
                        team away_team ON away_st.team_id = away_team.team_id
                ),
                    all_teams AS (
                        -- Lấy tất cả các đội trong tất cả các mùa giải
                        SELECT
                            s.season_id,
                            s.name AS season_name,
                            t.team_id,
                            t.team_name
                        FROM
                            season s
                                JOIN
                            season_team st ON s.season_id = st.season_id
                                JOIN
                            team t ON st.team_id = t.team_id
                    )
                SELECT
                    at.season_id,
                    at.season_name,
                    at.team_id,
                    at.team_name,
                    COALESCE(SUM(mr.points), 0) AS total_points,
                    COALESCE(SUM(mr.wins), 0) AS total_wins,
                    COALESCE(SUM(mr.losses), 0) AS total_losses,
                    COALESCE(SUM(mr.points_scored), 0) AS total_points_scored,
                    COALESCE(SUM(mr.points_conceded), 0) AS total_points_conceded,
                    COALESCE(SUM(mr.points_scored) - SUM(mr.points_conceded), 0) AS point_difference,
                    COALESCE(SUM(mr.home_wins), 0) AS home_wins,
                    COALESCE(SUM(mr.away_wins), 0) AS away_wins,
                    COALESCE(SUM(mr.fouls), 0) AS total_fouls
                FROM
                    all_teams at
                        LEFT JOIN
                    match_results mr ON at.season_id = mr.season_id AND at.team_id = mr.team_id
                GROUP BY
                    at.season_id, at.season_name, at.team_id, at.team_name
                ORDER BY
                    at.season_id,
                    total_points DESC,
                    point_difference DESC,
                    total_points_scored DESC,
                    away_wins DESC,
                    total_fouls ASC;
                ''';
    await _conn.execute(query);
  }

  /// 6. View thống kê điểm và lỗi của cầu thủ
  Future<void> createPlayerStatistics() async {
    final exists = await _checkExistView('player_statistics');
    if (!exists) {
      await _createPlayerStatisticsView();
    }
  }

  Future<void> _createPlayerStatisticsView() async {
    final query = '''
                CREATE OR REPLACE VIEW player_statistics AS
                SELECT 
                    s.season_id,
                    s.name AS season_name,
                    p.player_id,
                    p.player_code,
                    p.full_name AS player_name,
                    t.team_id,
                    t.team_name,
                    ps.shirt_number,
                    COUNT(DISTINCT mp.match_id) AS matches_played,
                    COALESCE(SUM(mps.points), 0) AS total_points,
                    COALESCE(SUM(mps.fouls), 0) AS total_fouls,
                    CASE 
                        WHEN COUNT(DISTINCT mp.match_id) > 0 THEN 
                            ROUND(COALESCE(SUM(mps.points), 0)::NUMERIC / COUNT(DISTINCT mp.match_id), 2)
                        ELSE 0
                    END AS points_per_match,
                    CASE 
                        WHEN COUNT(DISTINCT mp.match_id) > 0 THEN 
                            ROUND(COALESCE(SUM(mps.fouls), 0)::NUMERIC / COUNT(DISTINCT mp.match_id), 2)
                        ELSE 0
                    END AS fouls_per_match
                FROM 
                    player p
                JOIN 
                    player_season ps ON p.player_id = ps.player_id
                JOIN 
                    season_team st ON ps.season_team_id = st.season_team_id
                JOIN 
                    team t ON st.team_id = t.team_id
                JOIN 
                    season s ON st.season_id = s.season_id
                LEFT JOIN 
                    match_player mp ON ps.player_season_id = mp.player_id
                LEFT JOIN 
                    match_player_stats mps ON mp.match_player_id = mps.match_player_id
                GROUP BY 
                    s.season_id, s.name, p.player_id, p.player_code, p.full_name, t.team_id, t.team_name, ps.shirt_number;
                ''';
    await _conn.execute(query);
  }

  /// 7. View top 10 cầu thủ ghi nhiều điểm nhất
  Future<void> createTopScores() async {
    final exists = await _checkExistView('top_scorers');
    if (!exists) {
      await _createTopScoresView();
    }
  }

  Future<void> _createTopScoresView() async {
    final query = '''
                CREATE OR REPLACE VIEW top_scorers AS
                SELECT 
                    s.season_id,
                    s.name AS season_name,
                    p.player_id,
                    p.player_code,
                    p.full_name AS player_name,
                    t.team_id,
                    t.team_name,
                    ps.shirt_number,
                    COALESCE(SUM(mps.points), 0) AS total_points,
                    COUNT(DISTINCT mp.match_id) AS matches_played,
                    CASE 
                        WHEN COUNT(DISTINCT mp.match_id) > 0 THEN 
                            ROUND(COALESCE(SUM(mps.points), 0)::NUMERIC / COUNT(DISTINCT mp.match_id), 2)
                        ELSE 0
                    END AS points_per_match
                FROM 
                    player p
                JOIN 
                    player_season ps ON p.player_id = ps.player_id
                JOIN 
                    season_team st ON ps.season_team_id = st.season_team_id
                JOIN 
                    team t ON st.team_id = t.team_id
                JOIN 
                    season s ON st.season_id = s.season_id
                LEFT JOIN 
                    match_player mp ON ps.player_season_id = mp.player_id
                LEFT JOIN 
                    match_player_stats mps ON mp.match_player_id = mps.match_player_id
                GROUP BY 
                    s.season_id, s.name, p.player_id, p.player_code, p.full_name, t.team_id, t.team_name, ps.shirt_number
                ORDER BY 
                    s.season_id, total_points DESC;
                ''';
    await _conn.execute(query);
  }

  /// 8. View top 10 cầu thủ mắc ít lỗi nhất (có tham gia ít nhất 5 trận)
  Future<void> createTopFoulsPlayers() async {
    final exists = await _checkExistView('least_fouls_players');
    if (!exists) {
      await _createTopFoulsPlayersView();
    }
  }

  Future<void> _createTopFoulsPlayersView() async {
    final query = '''
                CREATE OR REPLACE VIEW least_fouls_players AS
                WITH player_stats AS (
                    SELECT 
                        s.season_id,
                        s.name AS season_name,
                        p.player_id,
                        p.player_code,
                        p.full_name AS player_name,
                        t.team_id,
                        t.team_name,
                        ps.shirt_number,
                        COUNT(DISTINCT mp.match_id) AS matches_played,
                        COALESCE(SUM(mps.fouls), 0) AS total_fouls,
                        CASE 
                            WHEN COUNT(DISTINCT mp.match_id) > 0 THEN 
                                ROUND(COALESCE(SUM(mps.fouls), 0)::NUMERIC / COUNT(DISTINCT mp.match_id), 2)
                            ELSE 0
                        END AS fouls_per_match
                    FROM 
                        player p
                    JOIN 
                        player_season ps ON p.player_id = ps.player_id
                    JOIN 
                        season_team st ON ps.season_team_id = st.season_team_id
                    JOIN 
                        team t ON st.team_id = t.team_id
                    JOIN 
                        season s ON st.season_id = s.season_id
                    LEFT JOIN 
                        match_player mp ON ps.player_season_id = mp.player_id
                    LEFT JOIN 
                        match_player_stats mps ON mp.match_player_id = mps.match_player_id
                    GROUP BY 
                        s.season_id, s.name, p.player_id, p.player_code, p.full_name, t.team_id, t.team_name, ps.shirt_number
                )
                SELECT * 
                FROM player_stats
                WHERE matches_played >= 5 -- Chỉ xét cầu thủ tham gia ít nhất 5 trận
                ORDER BY season_id, fouls_per_match ASC, total_fouls ASC;
                ''';
    await _conn.execute(query);
  }

  /// 9. View tính lương trọng tài theo tháng
  Future<void> createRefereeMonthlySalary() async {
    final exists = await _checkExistView('referee_monthly_salary');
    if (!exists) {
      await _createRefereeMonthlySalaryView();
    }
  }

  Future<void> _createRefereeMonthlySalaryView() async {
    final query = '''
                CREATE OR REPLACE VIEW referee_monthly_salary AS
                SELECT 
                    ref.referee_id,
                    ref.full_name AS referee_name,
                    EXTRACT(YEAR FROM m.match_datetime) AS year,
                    EXTRACT(MONTH FROM m.match_datetime) AS month,
                    TO_CHAR(m.match_datetime, 'Month YYYY') AS month_year,
                    COUNT(CASE WHEN mr.role = 'MAIN' THEN 1 ELSE NULL END) AS main_referee_matches,
                    COUNT(CASE WHEN mr.role = 'ASSISTANT' THEN 1 ELSE NULL END) AS assistant_referee_matches,
                    COUNT(CASE WHEN mr.role = 'TABLE' THEN 1 ELSE NULL END) AS table_referee_matches,
                    COUNT(CASE WHEN mr.role = 'MAIN' THEN 1 ELSE NULL END) * 1000000 AS main_referee_salary,
                    COUNT(CASE WHEN mr.role IN ('ASSISTANT', 'TABLE') THEN 1 ELSE NULL END) * 500000 AS other_referee_salary,
                    (COUNT(CASE WHEN mr.role = 'MAIN' THEN 1 ELSE NULL END) * 1000000) + 
                    (COUNT(CASE WHEN mr.role IN ('ASSISTANT', 'TABLE') THEN 1 ELSE NULL END) * 500000) AS total_salary
                FROM 
                    referee ref
                JOIN 
                    match_referee mr ON ref.referee_id = mr.referee_id
                JOIN 
                    match m ON mr.match_id = m.match_id
                GROUP BY 
                    ref.referee_id, ref.full_name, EXTRACT(YEAR FROM m.match_datetime), EXTRACT(MONTH FROM m.match_datetime), TO_CHAR(m.match_datetime, 'Month YYYY')
                ORDER BY 
                    year DESC, month DESC, referee_id;
                ''';
    await _conn.execute(query);
  }

  /// 10. View thu nhập của các sân thi đấu
  Future<void> createStadiumRevenue() async {
    final exists = await _checkExistView('stadium_revenue');
    if (!exists) {
      await _createStadiumRevenueView();
    }
  }

  Future<void> _createStadiumRevenueView() async {
    final query = '''
                CREATE OR REPLACE VIEW stadium_revenue AS
                SELECT 
                    s.stadium_id,
                    s.name AS stadium_name,
                    s.address,
                    s.capacity,
                    s.ticket_price,
                    COUNT(m.match_id) AS total_matches,
                    SUM(m.attendance) AS total_attendance,
                    SUM(m.attendance * s.ticket_price) AS total_revenue,
                    EXTRACT(YEAR FROM m.match_datetime) AS year,
                    EXTRACT(MONTH FROM m.match_datetime) AS month,
                    TO_CHAR(m.match_datetime, 'Month YYYY') AS month_year
                FROM 
                    stadium s
                JOIN 
                    match_venue mv ON s.stadium_id = mv.stadium_id
                JOIN 
                    match m ON mv.match_id = m.match_id
                GROUP BY 
                    s.stadium_id, s.name, s.address, s.capacity, s.ticket_price, 
                    EXTRACT(YEAR FROM m.match_datetime), EXTRACT(MONTH FROM m.match_datetime), TO_CHAR(m.match_datetime, 'Month YYYY')
                ORDER BY 
                    year DESC, month DESC, total_revenue DESC;
                ''';
    await _conn.execute(query);
  }

  /// 11. View kết quả các trận đấu theo vòng đấu
  Future<void> createRoundMatches() async {
    final exists = await _checkExistView('round_matches');
    if (!exists) {
      await _createRoundMatchesView();
    }
  }

  Future<void> _createRoundMatchesView() async {
    final query = '''
                CREATE OR REPLACE VIEW round_matches AS
                SELECT 
                    s.season_id,
                    s.name AS season_name,
                    r.round_id,
                    r.round_no,
                    r.start_date AS round_start_date,
                    r.end_date AS round_end_date,
                    m.match_id,
                    m.match_datetime,
                    home_team.team_id AS home_team_id,
                    home_team.team_name AS home_team_name,
                    away_team.team_id AS away_team_id,
                    away_team.team_name AS away_team_name,
                    m.home_points,
                    m.away_points,
                    m.home_fouls,
                    m.away_fouls,
                    stadium.stadium_id,
                    stadium.name AS stadium_name,
                    m.attendance,
                    CASE 
                        WHEN m.home_points > m.away_points THEN home_team.team_name
                        WHEN m.away_points > m.home_points THEN away_team.team_name
                        ELSE 'Hòa' -- Trường hợp hiếm
                    END AS winner
                FROM 
                    match m
                JOIN 
                    round r ON m.round_id = r.round_id
                JOIN 
                    season s ON r.season_id = s.season_id
                JOIN 
                    season_team home_st ON m.home_team_id = home_st.season_team_id
                JOIN 
                    team home_team ON home_st.team_id = home_team.team_id
                JOIN 
                    season_team away_st ON m.away_team_id = away_st.season_team_id
                JOIN 
                    team away_team ON away_st.team_id = away_team.team_id
                JOIN 
                    match_venue mv ON m.match_id = mv.match_id
                JOIN 
                    stadium ON mv.stadium_id = stadium.stadium_id
                ORDER BY 
                    s.season_id, r.round_no, m.match_datetime;
                ''';
    await _conn.execute(query);
  }

  /// 12. View cầu thủ ghi nhiều điểm nhất theo vòng đấu
  Future<void> createTopScorersByRound() async {
    final exists = await _checkExistView('top_scorers_by_round');
    if (!exists) {
      await _createTopScorersByRoundView();
    }
  }

  Future<void> _createTopScorersByRoundView() async {
    final query = '''
                CREATE OR REPLACE VIEW top_scorers_by_round AS
                WITH player_round_stats AS (
                    SELECT 
                        s.season_id,
                        s.name AS season_name,
                        r.round_id,
                        r.round_no,
                        p.player_id,
                        p.player_code,
                        p.full_name AS player_name,
                        t.team_id,
                        t.team_name,
                        ps.shirt_number,
                        SUM(mps.points) AS total_points,
                        RANK() OVER (PARTITION BY s.season_id, r.round_id ORDER BY SUM(mps.points) DESC) AS rank_in_round
                    FROM 
                        match m
                    JOIN 
                        round r ON m.round_id = r.round_id
                    JOIN 
                        season s ON r.season_id = s.season_id
                    JOIN 
                        match_player mp ON m.match_id = mp.match_id
                    JOIN 
                        match_player_stats mps ON mp.match_player_id = mps.match_player_id
                    JOIN 
                        player_season ps ON mp.player_id = ps.player_season_id
                    JOIN 
                        player p ON ps.player_id = p.player_id
                    JOIN 
                        season_team st ON ps.season_team_id = st.season_team_id
                    JOIN 
                        team t ON st.team_id = t.team_id
                    GROUP BY 
                        s.season_id, s.name, r.round_id, r.round_no, p.player_id, p.player_code, p.full_name, t.team_id, t.team_name, ps.shirt_number
                )
                SELECT 
                    season_id,
                    season_name,
                    round_id,
                    round_no,
                    player_id,
                    player_code,
                    player_name,
                    team_id,
                    team_name,
                    shirt_number,
                    total_points
                FROM 
                    player_round_stats
                WHERE 
                    rank_in_round = 1
                ORDER BY 
                    season_id, round_no;
                ''';
    await _conn.execute(query);
  }

  /// 13. View đối đầu giữa các đội
  Future<void> createTeamHeadToHead() async {
    final exists = await _checkExistView('team_head_to_head');
    if (!exists) {
      await _createTeamHeadToHeadView();
    }
  }

  Future<void> _createTeamHeadToHeadView() async {
    final query = '''
                CREATE OR REPLACE VIEW team_head_to_head AS
                SELECT 
                    s.season_id,
                    s.name AS season_name,
                    home_team.team_id AS team1_id,
                    home_team.team_name AS team1_name,
                    away_team.team_id AS team2_id,
                    away_team.team_name AS team2_name,
                    COUNT(*) AS total_matches,
                    SUM(CASE WHEN m.home_points > m.away_points THEN 1 ELSE 0 END) AS team1_wins,
                    SUM(CASE WHEN m.away_points > m.home_points THEN 1 ELSE 0 END) AS team2_wins,
                    SUM(CASE WHEN m.home_points = m.away_points THEN 1 ELSE 0 END) AS draws,
                    SUM(m.home_points) AS team1_total_points,
                    SUM(m.away_points) AS team2_total_points
                FROM 
                    match m
                JOIN 
                    round r ON m.round_id = r.round_id
                JOIN 
                    season s ON r.season_id = s.season_id
                JOIN 
                    season_team home_st ON m.home_team_id = home_st.season_team_id
                JOIN 
                    team home_team ON home_st.team_id = home_team.team_id
                JOIN 
                    season_team away_st ON m.away_team_id = away_st.season_team_id
                JOIN 
                    team away_team ON away_st.team_id = away_team.team_id
                GROUP BY 
                    s.season_id, s.name, home_team.team_id, home_team.team_name, away_team.team_id, away_team.team_name
                ORDER BY 
                    s.season_id, team1_id, team2_id;
                ''';
    await _conn.execute(query);
  }

  /// 14. View thống kê số lượng cầu thủ đăng ký trong mỗi đội
  Future<void> createTeamPlayerCount() async {
    final exists = await _checkExistView('team_player_count');
    if (!exists) {
      await _createTeamPlayerCountView();
    }
  }

  Future<void> _createTeamPlayerCountView() async {
    final query = '''
                CREATE OR REPLACE VIEW team_player_count AS
                SELECT 
                    s.season_id,
                    s.name AS season_name,
                    t.team_id,
                    t.team_name,
                    COUNT(ps.player_id) AS registered_players,
                    20 - COUNT(ps.player_id) AS available_slots
                FROM 
                    team t
                JOIN 
                    season_team st ON t.team_id = st.team_id
                JOIN 
                    season s ON st.season_id = s.season_id
                LEFT JOIN 
                    player_season ps ON st.season_team_id = ps.season_team_id
                GROUP BY 
                    s.season_id, s.name, t.team_id, t.team_name
                ORDER BY 
                    s.season_id, t.team_name;
                ''';
    await _conn.execute(query);
  }

  /// Liệt kê tất cả các view hiện có trong database
  Future<void> listView() async {
    try {
      final result = await _conn.execute('''
        SELECT viewname
        FROM pg_views
        WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
        ORDER BY viewname
      ''');

      for (final row in result) {
        print("view: ${row[0]}");
      }
    } catch (e) {
      print('Lỗi khi liệt kê view: $e');
    }
  }
}
