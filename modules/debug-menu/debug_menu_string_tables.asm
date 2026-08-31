

highlight_palette_table [
  &no_highlight_str
  &no_highlight_str
  &no_highlight_str
  &no_highlight_str
  &no_highlight_str
  &highlight_str
  &no_highlight_str
  &no_highlight_str
  &no_highlight_str
  &no_highlight_str
  &no_highlight_str
]

highlight_str ~[PAL:8]►~
no_highlight_str ~[PAL:4] ~

travel_highlight_table [
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
  &travel_no_highlight_str
]

travel_highlight_str ~[PAL:8]►~
travel_no_highlight_str ~[PAL:0] ~

cheat_highlight_table [
  &no_highlight_str
  &no_highlight_str
  &highlight_str
  &no_highlight_str
  &no_highlight_str
]

toggle_highlight_table [
  &toggle_no_highlight_str
  &toggle_highlight_str
  &toggle_no_highlight_str
]

toggle_highlight_str ~ ON~
toggle_no_highlight_str ~OFF~

scene_lokup [
  &scene_worlds
  &scene_present
  &scene_past
  &scene_space

  &scene_boot
  &scene_logo
  &scene_title
  &scene_diary_menu
  &scene_prlg_space
  &scene_prlg_rococo
  &scene_prlg_hackers
  &scene_prlg_mayhem
  &scene_prlg_androids
  &scene_prlg_inventor
  
  &scene_rococo
  &scene_rococo_town
  &scene_hero_house
  &scene_rnd
  &scene_pops_house
  &scene_pops_upstairs
  &scene_cokers_house
  &scene_cokers_upstairs
  &scene_stellas_house
  &scene_stellas_upstairs
  &scene_police_station
  &scene_carls_house
  &scene_crispy_shop
  &scene_sewer_entrance
  &scene_flavons_house

  &scene_central_continent
  &scene_harbor
  &scene_fathers_yard
  &scene_fathers_house
  &scene_forest
  &scene_river
  &scene_family_tomb
  &scene_tomb_inner
  &scene_chicken_farm
  &scene_chicken_house

  &scene_cutscenes
  &scene_flavon_flashback
  &scene_flavon_escape
]


scene_worlds            ~-Overworld               ~
scene_present           ~  Present                ~
scene_past              ~  Past                   ~
scene_space             ~  Space                  ~
scene_boot              ~-Boot                    ~
scene_logo              ~  Boot Logo              ~
scene_title             ~  Title Screen           ~
scene_diary_menu        ~  Diary Menu             ~
scene_prlg_space        ~  Prologue - Space       ~
scene_prlg_rococo       ~  Prologue - Rococo      ~
scene_prlg_hackers      ~  Prologue - Hackers     ~
scene_prlg_mayhem       ~  Prologue - Mayhem      ~
scene_prlg_androids     ~  Prologue - Androids    ~
scene_prlg_inventor     ~  Prologue - Inventor    ~

scene_rococo            ~-Rococo                  ~
scene_rococo_town       ~  Rococo Town            ~  ;000A
scene_hero_house        ~  Your House             ~  ;000B
scene_rnd               ~  Research & Development ~  ;000C
scene_pops_house        ~  Pops House             ~  ;000D
scene_pops_upstairs     ~  Pops Upstairs          ~  ;000E
scene_cokers_house      ~  Coker's House          ~  ;000F
scene_cokers_upstairs   ~  Coker's Upstairs       ~  ;0010
scene_stellas_house     ~  Stella's House         ~  ;0011
scene_stellas_upstairs  ~  Stella's Upstairs      ~  ;0012
scene_police_station    ~  Police Station         ~  ;0013
scene_carls_house       ~  Carl's House           ~  ;0014
scene_crispy_shop       ~  Crispy Shop            ~  ;0015
scene_sewer_entrance    ~  Sewer Entrance         ~  ;0016
scene_flavons_house     ~  Flavon's House         ~  ;001A

scene_central_continent ~-Central Continent       ~
scene_harbor            ~  Harbor                 ~  ;0018
scene_fathers_yard      ~  Father's Yard          ~  ;0017
scene_fathers_house     ~  Father's House         ~  ;0019
scene_forest            ~  Forest                 ~  ;001C
scene_river             ~  River                  ~  ;001D
scene_family_tomb       ~  Family Tomb            ~  ;006F
scene_tomb_inner        ~  Family Tomb - Inner    ~  ;0070
scene_chicken_farm      ~  Chicken Farm           ~  ;0071
scene_chicken_house     ~  Chicken Farm - House   ~  ;0072

scene_cutscenes         ~-Cutscenes               ~
scene_flavon_flashback  ~  Flavon's Flashback     ~  ;006D
scene_flavon_escape     ~  Flavon's Escape        ~  ;006E


scene_index [
  #$0000 #$0001 #$0002 #$0003  ;4
  #$0000 #$01C1 #$0004 #$0005 #$0006 #$0036 #$0007 #$0035 #$0008 #$0009  ;10
  #$0000 #$000A #$000B #$000C #$000D #$000E #$000F #$0010 #$0011 #$0012 #$0013 #$0014 #$0015 #$0016 #$001A   ;15
  #$0000 #$0018 #$0017 #$0019 #$001C #$001D #$006F #$0070 #$0071 #$0072  ;10
  #$0000 #$006D #$006E  ;3
]

;total 42
