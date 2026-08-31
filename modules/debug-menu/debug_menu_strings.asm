; Debug menu console strings (ROM bank $01).
; BOX position C4 must match [CLR:C4] in consolestring_debug_clear (close path only).
; Do NOT embed [CLR:C4] in main/travel strings — CLR clears an existing window;
; calling CLR before BOX has created that window will crash the game.
; Cursor: six PAL-highlighted variants (consolestring_debug_main0–5); no inline CLR on redraw.

?BANK 01

?INCLUDE 'debug_menu_string_tables'

consolestring_debug_main ~[BOR:0][PAL:4][BOX:A,1,C4][BOX:E,1,DC]\
[POS:106]DEBUG MENU[POS:11E]MAP[PAL:8][NUM:3,05A8][PAL:4] X[PAL:8][NUM:2,0BB2][PAL:4] Y[PAL:8][NUM:2,0BB4][PAL:4]\
[BOX:1A,10,184]\
[TBL:@highlight_palette_table+A,BD2] Fast Travel  [N]\
[TBL:@highlight_palette_table+8,BD2] Cheats       [N]\
[TBL:@highlight_palette_table+6,BD2] Inventory    [N]\
[TBL:@highlight_palette_table+4,BD2] Stats        [N]\
[TBL:@highlight_palette_table+2,BD2] Settings     [N]\
[TBL:@highlight_palette_table,BD2] Flags        [N]\
[N][PAL:4] A Select   B Cancel[BOR:8]~

consolestring_debug_travel ~[BOR:0][PAL:4][POS:106]FAS TRAVEL\
[BOX:1A,10,184]\
[POS:1C6][TBL:@travel_highlight_table+18,BD6][TBL:@scene_lokup,BD2]\
[POS:206][TBL:@travel_highlight_table+16,BD6][TBL:@scene_lokup+2,BD2]\
[POS:246][TBL:@travel_highlight_table+14,BD6][TBL:@scene_lokup+4,BD2]\
[POS:286][TBL:@travel_highlight_table+12,BD6][TBL:@scene_lokup+6,BD2]\
[POS:2C6][TBL:@travel_highlight_table+10,BD6][TBL:@scene_lokup+8,BD2]\
[POS:306][TBL:@travel_highlight_table+E,BD6][TBL:@scene_lokup+A,BD2]\
[POS:346][TBL:@travel_highlight_table+C,BD6][TBL:@scene_lokup+C,BD2]\
[POS:386][TBL:@travel_highlight_table+A,BD6][TBL:@scene_lokup+E,BD2]\
[POS:3C6][TBL:@travel_highlight_table+8,BD6][TBL:@scene_lokup+10,BD2]\
[POS:406][TBL:@travel_highlight_table+6,BD6][TBL:@scene_lokup+12,BD2]\
[POS:446][TBL:@travel_highlight_table+4,BD6][TBL:@scene_lokup+14,BD2]\
[POS:486][TBL:@travel_highlight_table+2,BD6][TBL:@scene_lokup+16,BD2]\
[POS:4C6][TBL:@travel_highlight_table,BD6][TBL:@scene_lokup+18,BD2][N]\
[PAL:4]A Warp     B Back[BOR:8]~

consolestring_debug_cheats ~[BOR:0][PAL:4][POS:106]  CHEATS  \
[BOX:1A,10,184]\
[TBL:@cheat_highlight_table+4,BD2] Vanish              [TBL:@toggle_highlight_table,BE4][N]\
[TBL:@cheat_highlight_table+2,BD2] Always Run          [TBL:@toggle_highlight_table,BE6][N]\
[TBL:@cheat_highlight_table,BD2] Walk Through Walls  [TBL:@toggle_highlight_table,BE8][N]\
[N]\
[N]\
[N]\
[N][PAL:4] A Toggle     B Back[BOR:8]~

consolestring_debug_clear ~[BOR:0][CLR:C4][CLR:DC][CLR:184][BOR:8]~
