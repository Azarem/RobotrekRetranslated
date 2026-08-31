; Debug menu (movable). No ?BANK — packer places this file.
; Patch calls JSL $@debug_menu_core each frame while $0594=$02.

?INCLUDE 'chunk_018000'
?INCLUDE 'chunk_048000'
?INCLUDE 'chunk_0B8000'
?INCLUDE 'debug_menu_strings'
?INCLUDE 'debug_menu_string_tables

!temp_mode            0BD0
!temp_row             0BD2
!temp_index           0BD4
!temp_phase           0BD6
!temp_max             0BD8
!temp_saved_056E      0BDA
!temp_saved_056A      0BDC
!temp_saved_0B70      0BE0
!temp_saved_0B72      0BE2
!temp_cheat_vanish    0BE4
!temp_cheat_autorun   0BE6
!main_len             0006
!cheat_flags          0BFE
!cheat_bit_vanish     0001
!cheat_bit_autorun    0002
!cheat_bit_wtw        0004
!cheat_len            0003
!fast_travel_height   000D
!fast_travel_center   0006     ;  (height / 2)
!fast_travel_len      002A
!fast_travel_adjust   001D     ;  (len - height)

; WRAM $7F:F000 — mode ($0BD0), cursor row ($0BD2), travel idx ($0BD4)
;   open phase ($0BD6): 0=wait render, 1=wait Start release, 2=active, 3=wait Start release to close
;   cursor OAM byte index (0BD8), input debounce ($0BDE)
;   saved $056E ($0BDA), saved $056A ($0BDC), saved $0B70 ($0BE0), saved $0B72 ($0BE2)
; Cursor row is drawn with [PAL:8] + ► in consolestring_debug_main0–5 (see debug_menu_strings.asm).

debug_menu_core {
    LDA $0594
    CMP #$02
    BEQ debug_menu_tick

debug_menu_open:
    PHP
    LDA #$02
    STA $0594
    LDA #$0B
    STA $INIDISP
    REP #$20
    
; Inventory-style freeze (code_0B817E): halt actor queue + block player control bit.

    LDA $056A
    STA $temp_saved_056A
    LDA $056E
    STA $temp_saved_056E
    LDA $0B70
    STA $temp_saved_0B70
    LDA $0B72
    STA $temp_saved_0B72

    LDA $0560            ;Start mask
    STA $056A
    STZ $056C
    STZ $056E
    STZ $0B70
    LDA #$0040
    TSB $0B72

    LDA #$main_len-1
    STA $temp_max

    STZ $temp_mode
    STZ $temp_row
    STZ $temp_index
    STZ $temp_phase

    JSR $&debug_redraw_main_cursor

    PLP
    RTL
}

debug_menu_tick {
    PHP
    REP #$20
    LDA $0560
    TSB $056A
    BIT #$1000
    BEQ debug_menu_tick_run
    JMP $&debug_menu_close

  debug_menu_tick_run:
    LDA $temp_mode
    BEQ debug_menu_main_tick
    DEC
    BEQ debug_menu_travel_tick
    DEC
    BEQ debug_menu_cheats_tick
    DEC
    BEQ debug_menu_inventory_tick
    PLP
    RTL
}

debug_menu_main_tick {
    LDA $0560
    BIT #$8000
    BNE debug_menu_main_cancel
    BIT #$0080
    BNE debug_menu_main_confirm
    BIT #$0800
    BNE debug_menu_main_up
    BIT #$0400
    BNE debug_menu_main_down
    PLP
    RTL
}

debug_menu_inventory_tick {
    LDA $0560
    PLP
    RTL
}
    
debug_menu_travel_tick {
    LDA $0560
    BIT #$8000
    BNE debug_menu_travel_cancel
    BIT #$0080
    BNE debug_menu_travel_confirm
    BIT #$0800
    BNE debug_menu_travel_up
    BIT #$0400
    BNE debug_menu_travel_down
    PLP
    RTL
}
    
debug_menu_main_up {
    DEC $temp_row
    BPL debug_menu_action
    LDA $temp_max
    STA $temp_row

  debug_menu_action:
    JSR $&debug_play_sfx
    JSR $&debug_redraw_main_cursor
    PLP
    RTL
}

debug_menu_main_down {
    INC $temp_row
    LDA $temp_max
    CMP $temp_row
    BCS debug_menu_action
    STZ $temp_row
    BRA debug_menu_action
    
  debug_menu_main_confirm:
    LDA $temp_row
    INC
    STA $temp_mode
    STZ $temp_row
    DEC
    BEQ debug_enter_travel
    DEC
    BEQ debug_enter_cheats
    BRA debug_menu_action
}
    
  debug_menu_main_cancel:
    JMP $&debug_menu_close
    
debug_menu_cheats_tick {
    LDA $0560
    BIT #$8000
    BNE debug_menu_travel_cancel
    BIT #$0080
    BNE debug_menu_cheat_confirm
    BIT #$0800
    BNE debug_menu_main_up
    BIT #$0400
    BNE debug_menu_main_down
    PLP
    RTL
}

  debug_menu_travel_up:
    JMP debug_travel_do_up
    
  debug_menu_travel_down:
    JMP debug_travel_do_down
    
debug_menu_travel_confirm {
    JMP debug_travel_do_confirm
}

debug_menu_travel_cancel {
    LDA $temp_mode
    DEC
    STA $temp_row
    STZ $temp_mode
    LDA #$main_len-1
    STA $temp_max
    BRA debug_menu_action
}

debug_enter_travel {
    JSR $&find_current_scene
    BRA debug_menu_action
}

debug_enter_cheats {
    JSR debug_cheat_do_enter
    BRA debug_menu_action
}

debug_menu_cheat_confirm {
    JSR debug_cheat_do_confirm
    BRA debug_menu_action
}

debug_travel_do_up {
    DEC $temp_index
    BMI debug_menu_travel_null
    
    JSR $&debug_play_sfx

    LDA $temp_phase
    CMP #$0003
    BCC debug_menu_travel_nudge

    DEC $temp_phase
    BRA debug_menu_travel_up_store

  debug_menu_travel_nudge:
    DEC $temp_row
    BPL debug_menu_travel_up_store

    STZ $temp_row
    DEC $temp_phase
    BRA debug_menu_travel_up_store

  debug_menu_travel_null:
    STZ $temp_index
    STZ $temp_phase
    STZ $temp_row

  debug_menu_travel_up_store:
    JSR &debug_redraw_main_cursor
    PLP
    RTL
}

debug_travel_do_down {
    LDA $temp_index
    INC
    CMP #$fast_travel_len
    BCS debug_menu_travel_down_null
    STA $temp_index
    
    JSR $&debug_play_sfx
    
    LDA $temp_phase
    CMP #$fast_travel_height-2
    BCC debug_menu_travel_nudge_down
    
    LDA $temp_row
    INC
    CMP #$fast_travel_adjust+1
    BCS debug_menu_travel_nudge_down

    STA $temp_row
    BRA debug_menu_travel_down_store
    
  debug_menu_travel_nudge_down:
    INC $temp_phase
    BRA debug_menu_travel_down_store

  debug_menu_travel_down_null:
    LDA #$fast_travel_len-1
    STA $temp_index
    LDA #$fast_travel_height-1
    STA $temp_phase
    LDA #$fast_travel_adjust
    STA $temp_row

  debug_menu_travel_down_store:
    JSR &debug_redraw_main_cursor
    PLP
    RTL
}

debug_travel_do_confirm {
    LDA $temp_index
    ASL
    TAX
    LDA $@scene_index, X
    BEQ debug_menu_travel_null_index
    STA $05A6
    JSR debug_play_sfx
    JMP debug_menu_close

  debug_menu_travel_null_index:
    PLP
    RTL
}

find_current_scene {
    STZ $0BFC
    LDX #$0000

  find_scene_loop:
    LDA $@scene_index, X
    CMP $05A8
    BEQ find_scene_found
    INX
    INX
    BRA find_scene_loop

  find_scene_found:
    TXA
    LSR
    STA $temp_index
    SEC
    SBC #$fast_travel_center
    BMI find_scene_negative

    CMP #$fast_travel_adjust
    BCS find_scene_positive

    STA $temp_row
    LDA #$fast_travel_center
    STA $temp_phase
    BRA find_scene_end

  find_scene_negative:
    LDA $temp_index
    STA $temp_phase
    STZ $temp_row
    BRA find_scene_end

  find_scene_positive:
    SEC
    SBC #$fast_travel_adjust
    CLC
    ADC #$fast_travel_center
    STA $temp_phase
    LDA #$fast_travel_adjust
    STA $temp_row

  find_scene_end:
    RTS
}

debug_cheat_do_enter {
    LDA #$cheat_len-1
    STA $temp_max
    LDY #$cheat_len
    LDX #$FFFE
    LDA $cheat_flags

  debug_enter_cheat_loop:
    DEY
    BMI debug_enter_cheat_ret
    INX
    INX
    STZ $temp_cheat_vanish, X
    LSR
    BCS debug_enter_inc_flag
    BRA debug_enter_cheat_loop

  debug_enter_inc_flag:
    INC $temp_cheat_vanish, X
    BRA debug_enter_cheat_loop

  debug_enter_cheat_ret:
    RTS
}

debug_cheat_do_confirm {
    LDA $temp_row
    TAY
    ASL
    TAX
    LDA $temp_cheat_vanish, X
    EOR #$0001
    STA $temp_cheat_vanish, X
    TAX

    LDA #$0001

  debug_cheat_confirm_loop:
    DEY
    BMI debug_cheat_confirm_continue
    ASL
    BRA debug_cheat_confirm_loop


  debug_cheat_confirm_continue:
    CPX #$0000
    BEQ debug_cheat_reset
    TSB $cheat_flags
    RTS

  debug_cheat_reset:
    TRB $cheat_flags
    RTS
}



debug_menu_close {
    LDY #$&consolestring_debug_clear
    JSL $@code_0BCCD1
    JSR $&debug_poll_render
    SEP #$20
    STZ $0594
    LDA #$0F
    STA $INIDISP
    REP #$20
    
    ;Restore pad/masks
    LDA $temp_saved_056A
    ORA #$1000
    STA $056A
    LDA $temp_saved_056E
    STA $056E
    LDA $temp_saved_0B70
    STA $0B70
    LDA $temp_saved_0B72
    STA $0B72

    PLP
    RTL
}



; Stock pause frame poll (code_0081ED): code_048000 only — never JSL code_0081FC
; from inside the menu (re-enters the event dispatcher) or JSL code_0081ED (ends RTS).
debug_engine_poll {
    SEP #$20
    PEI ($32)
    JSL $@code_048000
    PLY
    STY $32
    REP #$20
    RTS
}


; Wait for console renderer to finish ($0EE2 bit 0).
debug_poll_render {
    PHP
  debug_poll_render_loop:
    JSR $&debug_engine_poll
    SEP #$20
    LDA $0EE2
    BIT #$01
    BNE debug_poll_render_loop
    PLP
    RTS
}

debug_consume_pad {
    PHP
    REP #$20
    STZ $0560
    STZ $0562
    PLP
    RTS
}

debug_main_string_table [
  &consolestring_debug_main
  &consolestring_debug_travel
  &consolestring_debug_cheats
  &consolestring_debug_main
  &consolestring_debug_main
  &consolestring_debug_main
]

debug_redraw_main_cursor {
    LDA $temp_mode
    ASL
    TAX
    LDA $@debug_main_string_table, X
    TAY
    JSL $@code_0BCCD1
    JSR $&debug_poll_render
    RTS
}

debug_play_sfx {
    SEP #$20
    LDA #$29
    STA $0879
    REP #$20
    RTS
}


-------------------------------------
; Override player movement COP (code_049B79) — runs from RTI, not code_0081FC.

;code_049B79 {
;    SEP #$20
;    LDA $0594
;    CMP #$02
;    BNE debug_player_movement_run
;    SEC
;    RTL

;  debug_player_movement_run:
;    REP #$20
;    PHD
;    PHX
;    LDY $056E
;    PHY
;    PHA
;    LDA #$0000
;    TCD
;    PHA
;    STZ $0EE0
;    LDA #$705F
;    STA $056E

;  code_049B8E:
;    JSR $&code_049C95
;    JSR $&code_049ED5
;    LDA $0560
;    BIT #$8FA0
;    BEQ code_049B8E
;    SEP #$20
;    LDA #$29
;    STA $0879
;    REP #$20
;    LDA $0560
;    STA $056A
;    AND #$0F00
;    STA $056C
;    LDA $0560
;    STZ $0560
;    BIT #$0800
;    BNE loc_049BFC
;    BIT #$0400
;    BNE loc_049C29
;    BIT #$0300
;    BEQ loc_049BC9
;    JMP $&code_049C5E

;  loc_049BC9:
;    BIT #$00A0
;    BNE loc_049BDC
;    BIT #$8000
;    BEQ code_049B8E
;    JSR $&code_049D3F
;    PLA
;    STZ $0EEC
;    BRA loc_049BED

;  loc_049BDC:
;    SEP #$20
;    LDA #$29
;    STA $0879
;    REP #$20
;    JSR $&code_049D3F
;    PLA
;    INC
;    STA $0EEC

;  loc_049BED:
;    JSR $&code_049ED5
;    STZ $0EE0
;    PLY
;    PLY
;    STY $056E
;    PLX
;    PLD
;    SEC
;    RTL

;  loc_049BFC:
;    STZ $0EE0
;    SEP #$20
;    LDA $03, S
;    AND #$0F
;    STA $18
;    LDA $03, S
;    LSR
;    LSR
;    LSR
;    LSR
;    STA $14
;    LDA $01, S
;    DEC
;    BMI loc_049C1B
;    STA $01, S
;    REP #$20
;    JMP $&code_049B8E

;  loc_049C1B:
;    LDA $14
;    BNE loc_049C21
;    LDA $18

;  loc_049C21:
;    DEC
;    STA $01, S
;    REP #$20
;    JMP $&code_049B8E

;  loc_049C29:
;    STZ $0EE0
;    SEP #$20
;    LDA $03, S
;    AND #$0F
;    STA $18
;    LDA $03, S
;    LSR
;    LSR
;    LSR
;    LSR
;    STA $14
;    LDA $01, S
;    INC
;    CMP $14
;    BCS loc_049C4A
;    STA $01, S
;    REP #$20
;    JMP $&code_049B8E

;  loc_049C4A:
;    LDA $14
;    BNE loc_049C55
;    LDA $01, S
;    INC
;    CMP $18
;    BCC loc_049C57

;  loc_049C55:
;    LDA #$00

;  loc_049C57:
;    STA $01, S
;    REP #$20
;    JMP $&code_049B8E
;}
