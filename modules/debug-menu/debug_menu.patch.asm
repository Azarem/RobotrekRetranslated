; Debug menu patch — replaces the Start-button pause screen with a developer menu.

?INCLUDE 'chunk_008000'
?INCLUDE 'unk21_0BB58F'

!cheat_flags             0BFE
!cheat_bit_vanish        0001
!cheat_bit_autorun       0002
!cheat_bit_wtw             04

-------------------------------------
; Replace pause handler (code_008199)
; Menu runs one frame per main-loop tick (after code_048000).
; $0594=$02 = debug menu active (distinct from stock pause $0594=$01).

code_008199 {
    LDA $0594
    BMI debug_pause_skip
    BNE debug_pause_tick
    LDA $0561
    BIT #$10
    BEQ debug_pause_skip
    JSL $@debug_menu_core
    RTL

  debug_pause_tick:
    CMP #$02
    BNE debug_pause_skip
    JSL $@debug_menu_core
    RTL

  ;debug_pause_release:
  ;  LDA $0561
  ;  BIT #$10
  ;  BNE debug_pause_skip
  ;  STZ $0594

  debug_pause_skip:
    RTL
}

-------------------------------------
;Allow start button to be pressed on overworld

unk21_0BB5A9 [
  unk21 < [
    unk25 <  >   ;00
    unk26 <  >   ;01
    unk25 <  >   ;02
    unk25 <  >   ;03
    unk24 < &code_0BD9EA >   ;04
    unk24 < &code_0BDA76 >   ;05
    unk24 < &code_0BDAD6 >   ;06
    unk24 < &code_0BDB34 >   ;07
    unk25 <  >   ;08
    unk26 <  >   ;09
    unk25 <  >   ;0A
    unk25 <  >   ;0B
  ], [
    unk22 < #$40F0 >
  ] >
]

-------------------------------------
; Skip COP actor dispatch while debug menu is open ($0594=$02).
; Stock pause blocks inside code_008199; our tick-based menu must freeze actors here.

code_0081FC {
    LDA $0594
    CMP #$02
    BEQ debug_0081fc_done
    JSL $@code_0480CB

  code_008200:
    LDX $CB
    CPX $C9
    BEQ debug_0081fc_done
    TXA
    INC
    AND #$1F
    STA $CB
    LDA #$00
    XBA
    LDA $A9, X
    STZ $A9, X
    BMI debug_0081fc_done
    TAX
    STX $CD
    PEA $&code_008200-1
    JMP ($00D1, X)

  debug_0081fc_done:
    JSL $@code_0480BA
    RTL
}

---------------------------------------
;Hook for vanish cheat

  loc_00F565:

    LDA $cheat_flags
    BIT #$cheat_bit_vanish
    BNE do_vanish

    LDA $0014
    ORA $0018
    BNE loc_00F56E

  do_vanish:
    RTS 


---------------------------------------
;Hook for auto-run cheat

code_00C84E {
    TYX 
    LDA $30
    CMP #$000F
    BEQ loc_00C8C6
    STZ $0006
    LDA $cheat_flags
    BIT #$cheat_bit_autorun
    BNE ns_do_run_mode

  ns_test_run_mode:
    LDA $0560
    BIT #$8000
    BNE ns_do_run_mode

  ns_do_normal_mode:
    STZ $0004
    LDA #$0009
    STA $0BAE
    STA $7F101A, X
    BRA loc_00C87E

  ns_do_run_mode:
    LDA #$000B
    STA $0BAE
    STA $7F101A, X
    LDA #$0018
    STA $0004
}

code_00C8CD {
    TYX 
    LDA $30
    CMP #$000F
    BEQ loc_00C945
    STZ $0006
    LDA $cheat_flags
    BIT #$cheat_bit_autorun
    BNE ew_do_run_mode

  ew_test_run_mode:
    LDA $0560
    BIT #$8000
    BNE ew_do_run_mode

  ew_do_normal_mode:
    STZ $0004
    LDA #$0009
    STA $0BAE
    STA $7F101A, X
    BRA loc_00C8FD

  ew_do_run_mode:
    LDA #$000B
    STA $0BAE
    STA $7F101A, X
    LDA #$0018
    STA $0004
}

---------------------------------------
;Hook for wtw cheat

code_00DDF4 {
    PHX 
    LDA $7F0012, X
    CLC 
    ADC $7F0014, X
    CMP #$0003
    BCS loc_00DE3F
    JSL $@code_0AF4B6
    STZ $31
    STZ $33
    LDA $7FA000, X
    AND #$0F
    CMP #$05
    BEQ loc_00DE36
    JSL $@code_08F4AA
    BCS loc_00DE36
    LDA $7FA000, X
    STA $32
    BIT #$F0
    BNE loc_00DE36

    STZ $30
    TAX
    LDA $cheat_flags
    BIT #$cheat_bit_wtw
    BNE collision_w_finish
    TXA

    AND #$0F
    STA $30
    CMP #$0A
    BEQ loc_00DE36
    CMP #$0F
    BEQ loc_00DE3A

  collision_w_finish:
    REP #$20
    PLX 
    CLC 
    RTS 
}

code_00DEB5 {
    PHX 
    LDA $7F0012, X
    CLC 
    ADC $7F0014, X
    CMP #$0003
    BCS loc_00DF00
    JSL $@code_0AF4B6
    STZ $31
    STZ $33
    LDA $7FA000, X
    AND #$0F
    CMP #$0A
    BEQ loc_00DEF7
    JSL $@code_08F479
    BCS loc_00DEF7
    LDA $7FA000, X
    STA $32
    BIT #$F0
    BNE loc_00DEF7

    STZ $30
    TAX
    LDA $cheat_flags
    BIT #$cheat_bit_wtw
    BNE collision_e_finish
    TXA

    AND #$0F
    STA $30
    CMP #$05
    BEQ loc_00DEF7
    CMP #$0F
    BEQ loc_00DEFB

  collision_e_finish:
    REP #$20
    PLX 
    CLC 
    RTS 
}


code_00DF84 {
    PHX 
    LDA $7F0012, X
    CLC 
    ADC $7F0014, X
    CMP #$0003
    BCS loc_00DFCF
    JSL $@code_0AF4B6
    STZ $31
    STZ $33
    LDA $7FA000, X
    AND #$0F
    CMP #$03
    BEQ loc_00DFC6
    JSL $@code_08F4FE
    BCS loc_00DFC6
    LDA $7FA000, X
    STA $32
    BIT #$F0
    BNE loc_00DFC6
    
    STZ $30
    TAX
    LDA $cheat_flags
    BIT #$cheat_bit_wtw
    BNE collision_n_finish
    TXA

    AND #$0F
    STA $30
    CMP #$0C
    BEQ loc_00DFC6
    CMP #$0F
    BEQ loc_00DFCA

  collision_n_finish:
    REP #$20
    PLX 
    CLC 
    RTS 
}

code_00E045 {
    PHX 
    LDA $7F0012, X
    CLC 
    ADC $7F0014, X
    CMP #$0003
    BCS loc_00E090
    JSL $@code_0AF4B6
    STZ $31
    STZ $33
    LDA $7FA000, X
    AND #$0F
    CMP #$0C
    BEQ loc_00E087
    JSL $@code_08F4DD
    BCS loc_00E087
    LDA $7FA000, X
    STA $32
    BIT #$F0
    BNE loc_00E087
    
    STZ $30
    TAX
    LDA $cheat_flags
    BIT #$cheat_bit_wtw
    BNE collision_s_finish
    TXA

    AND #$0F
    STA $30
    CMP #$03
    BEQ loc_00E087
    CMP #$0F
    BEQ loc_00E08B
    
  collision_s_finish:
    REP #$20
    PLX 
    CLC 
    RTS 
}
