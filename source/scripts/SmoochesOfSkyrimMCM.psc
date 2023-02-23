Scriptname SmoochesOfSkyrimMCM extends SKI_ConfigBase  

GlobalVariable Property SmoochesEnableFollowers Auto

GlobalVariable Property SmoochesEnableHeadPatAnims Auto
GlobalVariable Property SmoochesEnableGropingAnims Auto
GlobalVariable Property SmoochesEnableSpankingAnims Auto

GlobalVariable Property SmoochesNumKissLoops Auto

Int SetEnableFollowers

; animation enable toggles ;
Int SetEnableGropingAnims
Int SetEnableHeadPatAnims
Int SetEnableSpankingAnims
; end animation enable toggles ;

; multiplier for animation duration
 ; TODO rename sceneLoops or something
Int SetNumKissLoops

ArialAffectionTriggerKissScript Main

Event OnPageReset(String Page)
    If (Page == "Smooch Configuration")
        SetCursorFillMode(TOP_TO_BOTTOM)

        SetNumKissLoops = AddSliderOption("Number of Kiss Loops", SmoochesNumKissLoops.GetValueInt(), "{0}")

        SetEnableFollowers = AddToggleOption("Enable Follower Kisses", SmoochesEnableFollowers.GetValueInt())

        SetEnableGropingAnims = AddToggleOption("Enable Groping Animations", SmoochesEnableGropingAnims.GetValueInt())
        SetEnableHeadPatAnims = AddToggleOption("Enable Head Pat Animations", SmoochesEnableHeadPatAnims.GetValueInt())
        ; SetEnableSpankingAnims = AddToggleOption("Enable Spanking Animations", SmoochesEnableSpankingAnims.GetValueInt())
    EndIf
EndEvent


Event OnOptionHighlight(Int Option)
    If (Option == SetEnableFollowers)
        SetInfoText("Should the player get the dialogue option to kiss followers?")
    ElseIf (Option == SetNumKissLoops)
        SetInfoText("Number of times to loop the kiss. Does not currently affect other animations.")
    ElseIf (Option == SetEnableGropingAnims)
        SetInfoText("Enable groping animations as possible responses (only female PC currently)")
    ElseIf (Option == SetEnableHeadPatAnims)
        SetInfoText("Enable head pat animations as possible responses (only female PC currently)")
    ElseIf (Option == SetEnableSpankingAnims)
        SetInfoText("Enable spanking animations as possible responses (only female PC currently)")
    Endif
EndEvent

; TODO constants for intish values  
Event OnOptionSliderOpen(Int Option)
    If (Option == SetNumKissLoops)
        SetSliderDialogStartValue(SmoochesNumKissLoops.GetValue())
        SetSliderDialogDefaultValue(15)
        SetSliderDialogRange(10, 150)
        SetSliderDialogInterval(5)
    EndIf
EndEvent

Event OnOptionSliderAccept(Int Option, Float Value)
    If (Option == SetNumKissLoops)
        SmoochesNumKissLoops.SetValue(Value)
        SetSliderOptionValue(Option, Value, "{0}")
    EndIF
EndEvent

Event OnOptionSelect(Int Option)
    If (Option == SetEnableFollowers)
        If (SmoochesEnableFollowers.GetValueInt() == 1)
            SmoochesEnableFollowers.SetValue(0)
        Else
            SmoochesEnableFollowers.SetValue(1)
        EndIf
        SetToggleOptionValue(Option, SmoochesEnableFollowers.GetValueInt())
    EndIf
    If (Option == SetEnableGropingAnims)
        If (SmoochesEnableGropingAnims.GetValueInt() == 1)
            SmoochesEnableGropingAnims.SetValue(0)
        Else
            SmoochesEnableGropingAnims.SetValue(1)
        EndIf
        SetToggleOptionValue(Option, SmoochesEnableGropingAnims.GetValueInt())
    EndIf
    If (Option == SetEnableHeadPatAnims)
        If (SmoochesEnableHeadPatAnims.GetValueInt() == 1)
            SmoochesEnableHeadPatAnims.SetValue(0)
        Else
            SmoochesEnableHeadPatAnims.SetValue(1)
        EndIf
        SetToggleOptionValue(Option, SmoochesEnableHeadPatAnims.GetValueInt())
    EndIf
    If (Option == SetEnableSpankingAnims)
        If (SmoochesEnableSpankingAnims.GetValueInt() == 1)
            SmoochesEnableSpankingAnims.SetValue(0)
        Else
            SmoochesEnableSpankingAnims.SetValue(1)
        EndIf
        SetToggleOptionValue(Option, SmoochesEnableSpankingAnims.GetValueInt())
    EndIf
EndEvent

Event OnGameReload()
    Parent.OnGameReload()
EndEvent