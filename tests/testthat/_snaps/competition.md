# sudden deaths are parsed correctly

    Code
      df
    Output
                  home_team               guest_team        event pairing_order
      1 TG Wangen-Eisenharz TSV Grötzingen-Karlsruhe        floor             1
      2 TG Wangen-Eisenharz TSV Grötzingen-Karlsruhe pommel_horse             1
            home_gymnast
      1 Drechsel, Manuel
      2  Schober, Pascal
                                                     home_gymnast_url home_starts
      1 https://www.deutsche-turnliga.de/vereine/turner.html?ID=21327        TRUE
      2 https://www.deutsche-turnliga.de/vereine/turner.html?ID=21853       FALSE
        home_d_value home_end_value home_score_value guest_gymnast
      1          3.9          11.25                0 Weiss, Sverre
      2          3.5          12.00                0  Steele, Adam
                                                    guest_gymnast_url guest_d_value
      1 https://www.deutsche-turnliga.de/vereine/turner.html?ID=21278           4.0
      2 https://www.deutsche-turnliga.de/vereine/turner.html?ID=21397           3.6
        guest_end_value guest_score_value
      1            12.0                 3
      2            12.2                 1

