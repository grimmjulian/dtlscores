# parsing selection works

    Code
      l
    Output
      $type_id
      [1] "Mann"
      
      $type
      [1] "Männer"
      
      $season_id
      [1] "10"
      
      $season
      [1] "2016"
      
      $league_id
      [1] "111"
      
      $league
      [1] "2. Bundesliga Nord"
      
      $matchday_id
      [1] "332"
      
      $matchday
      [1] "3. Wettkampftag"
      

# parsing works for matchdays with 3 competitions

    Code
      df
    Output
        type_id   type season_id season league_id            league matchday_id
      1    Mann Männer        20   2025       776 3. Bundesliga Süd         694
      2    Mann Männer        20   2025       776 3. Bundesliga Süd         694
      3    Mann Männer        20   2025       776 3. Bundesliga Süd         694
               matchday            datetime
      1 1. Wettkampftag 2025-09-27 13:00:00
      2 1. Wettkampftag 2025-09-27 17:00:00
      3 1. Wettkampftag 2025-09-27 18:00:00
                                                                 location
      1                  Geothermie Arena | Utzweg 1 | 82008 Unterhaching
      2                    Murrtal-Arena | Jahnstraße 15 | 71522 Backnang
      3 Ebnetsporthalle Wangen | Danneckerweg 50 | 88239 Wangen im Allgäu
                                         title           home_team
      1 USC München - TSV Grötzingen-Karlsruhe         USC München
      2           TSG Backnang - WTG Heckengäu        TSG Backnang
      3          TG Wangen-Eisenharz - TV Bühl TG Wangen-Eisenharz
                      guest_team
      1 TSV Grötzingen-Karlsruhe
      2            WTG Heckengäu
      3                  TV Bühl
                                                       competition_url score  gp
      1 https://www.deutsche-turnliga.de/archiv/detailsm0.html?ID=2868 24:30 4:8
      2 https://www.deutsche-turnliga.de/archiv/detailsm0.html?ID=2869 25:42 3:9
      3 https://www.deutsche-turnliga.de/archiv/detailsm0.html?ID=2870 29:40 4:8
                    matchday_url
      1 matchdays/M-25-3S-1.html
      2 matchdays/M-25-3S-1.html
      3 matchdays/M-25-3S-1.html

