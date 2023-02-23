Scriptname ArialAffectionTriggerKissScript extends Quest  
{meant to let fragments trigger kisses & other anims}

OSexIntegrationMain Property ostim Auto

Actor Property PlayerRef Auto

GlobalVariable Property SmoochesNumKissLoops Auto

; track if a scene has been played from this mod
bool smoochesAISceneIsPlaying

; we may have a dom who needs to cum in the course of a scene
Actor domWhoNeedsToCum = None

; ostim settings we're manipulating
bool bUseAIControl 
; bool bUseAINPConNPC
bool bUseAIPlayerAggressed 
bool bUseAINonAggressive 
bool bDisableOSAControls
bool bAlwaysUndressAtAnimStart
bool bUseFurniture 


bool SmoochesLoggingEnabled = false

Function displayFlair(String flair, Bool override = false)
    If ((SmoochesLoggingEnabled == true) || override)
        displayFlair(flair)
        miscutil.PrintConsole("[Smooches of Skyrim] " + flair)
    EndIf
EndFunction


Function RunSmoochesScene(Actor dom, Actor sub, String sceneId, Int numLoops = 15)
    displayFlair("RunSmoochesScene " + sceneId)

    if (!sceneId || sceneId == "")
        return
    EndIf

    ; Disable OSA Controls
    bDisableOSAControls = ostim.DisableOSAControls
    ostim.HideAllSkyUIWidgets()
    ostim.DisableOSAControls = True

    ; Disable AI control
    bUseAIControl = ostim.UseAIControl
    ostim.UseAIControl = False
    bUseAINonAggressive = ostim.UseAINonAggressive
    ostim.UseAINonAggressive = False

    ; Disable Undress
    bAlwaysUndressAtAnimStart = ostim.AlwaysUndressAtAnimStart
    ostim.AlwaysUndressAtAnimStart = False

    ; Disable Furniture
    bUseFurniture = ostim.UseFurniture 
    ostim.UseFurniture = False

    ; Start the animation with the animation found
    ostim.StartScene(dom, sub, zStartingAnimation = sceneId)

    While (ostim.AnimationRunning())
        If (numLoops == 0)
            ostim.EndAnimation()
            Utility.Wait(3.0)
        Else
            Utility.Wait(1.0)
        EndIf
        numLoops -= 1
    EndWhile
    ; Init

    ostim.ShowAllSkyUIWidgets()

    ostim.DisableOSAControls = bDisableOSAControls
    ostim.UseAIControl = bUseAIControl
    ostim.UseAINonAggressive = bUseAINonAggressive
    ostim.AlwaysUndressAtAnimStart = bAlwaysUndressAtAnimStart
    ostim.UseFurniture = bUseFurniture
endFunction

Function RunPCSubScene(Actor dom)
    displayFlair("run pc sub scene.")
    ; Disable OSA Controls for that subby feel
    bDisableOSAControls = ostim.DisableOSAControls
    ostim.DisableOSAControls = True

    ; what's a satisfaction bar 
    ostim.HideAllSkyUIWidgets()

    ; Enable (yes, enable) AI control
    ; bUseAIControl = ostim.UseAIControl
    ; ostim.UseAIControl = True
    ; bUseAINPConNPC = ostim.UseAINPConNPC
    ; ostim.UseAINPConNPC = True
    ; bUseAINonAggressive = ostim.UseAINonAggressive
    ; ostim.UseAINonAggressive = True
    bUseAIPlayerAggressed = ostim.useAIPlayerAggressed
    ostim.useAIPlayerAggressed = True

    domWhoNeedsToCum = dom
    smoochesAISceneIsPlaying = true
    displayFlair("run pc sub scene.")
    ostim.StartScene(dom, PlayerRef, Aggressive = True, AggressingActor = dom)
    ostim.StartScene(dom, PlayerRef, Aggressive = True, AggressingActor = dom)
endFunction

string Function GetStandingNonsexualSceneIdForActionType(Actor dom, Actor sub, string actionType)
    Actor[] _Actors = new Actor[2]
    _Actors[0] = dom
    _Actors[1] = sub
    return OLibrary.GetRandomSceneSuperloadCSV(_Actors, AllActorTagsForAll = "standing;standing", AnyActionType = actionType, ActionBlacklistTypes = "sexual")
endFunction

Function TriggerKiss(Actor dom, Actor sub)
    ; ostim action is "kissing"
    ; TriggerOstimAnim(dom, sub, "kissing", SmoochesNumKissLoops.GetValueInt())
    string sceneId = GetStandingNonsexualSceneIdForActionType(dom, sub, "kissing")
    runSmoochesScene(dom, sub, sceneId, SmoochesNumKissLoops.GetValueInt())
endFunction

Function PlayerKissSpeaker(Actor akSpeaker)
    ; trigger a kiss with the PC kissing the speaker
    TriggerKiss(PlayerRef, akSpeaker)
endFunction

Function SpeakerKissPlayer(Actor akSpeaker)
    ; trigger a kiss with the speaker kissing the PC
    TriggerKiss(akSpeaker, PlayerRef)
endFunction

Function SpeakerHugPlayer(Actor akSpeaker)
    ; trigger a hug with the speaker hugging the PC
    ; currently can't search for hugs
    ; TODO fix 
    ; TriggerOstimAnim(akSpeaker, PlayerRef, "kissing", SmoochesNumKissLoops.GetValueInt())
    displayFlair("Hugs are disabled! How did you get here?")
endFunction

Function SpeakerGropePlayer(Actor akSpeaker)
    ; speaker gropes player's breasts
    ; ostim actiontype gropingbreast
    ; TriggerOstimAnim(akSpeaker, PlayerRef, "gropingbreast")
    string sceneId = GetStandingNonsexualSceneIdForActionType(akSpeaker, PlayerRef, "gropingbreast")
    runSmoochesScene(akSpeaker, PlayerRef, sceneId, SmoochesNumKissLoops.GetValueInt())
endFunction

Function SpeakerPatPlayer(Actor akSpeaker)
    ; speaker pats player on the head
    ; make it a little quicker
    ; ostim action is pattinghead
    ; TriggerOstimAnim(akSpeaker, PlayerRef, "pattinghead", 8)

    string sceneId = GetStandingNonsexualSceneIdForActionType(akSpeaker, PlayerRef, "pattinghead")
    runSmoochesScene(akSpeaker, PlayerRef, sceneId, 8)
endFunction

Function SpeakerSpankPlayer(Actor akSpeaker)
    ; speaker spanks player 
    ; ostim actiontype is spank
    ; TriggerOstimAnim(akSpeaker, PlayerRef, "spank", 12)
   displayFlair("Spanks are disabled! How did you get here?")

    string sceneId = GetStandingNonsexualSceneIdForActionType(akSpeaker, PlayerRef, "spank")
    runSmoochesScene(akSpeaker, PlayerRef, sceneId, 12)
endFunction

Function SpeakerUsePlayer(Actor akSpeaker)
    Utility.wait(1)
    RunPCSubScene(akSpeaker)
endFunction

;; EVENT HANDLERS ;;

Event OStimEnd(string eventName, string strArg, float numArg, Form sender)
    displayFlair("smooches caught ostimend")
    ; just reenable controls anyway but maybe don't if it wasn't our scene
    ; use metadata??
    ostim.DisableOSAControls = False
    ostim.ShowAllSkyUIWidgets()
    ; ostim.useAIPlayerAggressed = bUseAIPlayerAggressed

    if (Ostim.IsActorActive(PlayerRef) && smoochesAISceneIsPlaying)
        displayFlair("smooches caught ostimend and conditions met")
        while(OStim.AnimationRunning())
            utility.wait(1.0)
        endWhile
        displayFlair("ostimend while loop done")

        if (smoochesAISceneIsPlaying)
            displayFlair("smooches caught ostimend and smoochesAISceneIsPlaying")
            smoochesAISceneIsPlaying = false
            ; restore settings
            ostim.useAIPlayerAggressed = bUseAIPlayerAggressed

            if (domWhoNeedsToCum == None)
                ; notify that you succeeded
                displayFlair("You gave satisfaction.")
                Debug.MessageBox("You pleased the dom!")
            Else
                ; dom was not satisfied but it's not the script's problem anymore
                domWhoNeedsToCum = None
                ; notify that you failed
                displayFlair("You failed to please.")
                Debug.MessageBox("You failed to please the dom!")
            endIf
        endIf
    endIf
endEvent

Event OStimOrgasm(string eventName, string strArg, float numArg, Form sender)
    displayFlair("Smooches received an ostim orgasm.")        
    actor orgasmer = ostim.GetMostRecentOrgasmedActor()
    if (orgasmer == domWhoNeedsToCum)
        displayFlair("the dom has come")
        domWhoNeedsToCum = None
    EndIf
endEvent

Event OStimStart(string eventName, string strArg, float numArg, Form sender)
    ; domActor = ostim.GetDomActor()
    ; subActor = ostim.GetSubActor()
    ; thirdActor = ostim.GetThirdActor()
    displayFlair("Smooches received an ostim start.")        
    if (smoochesAISceneIsPlaying)
        if (Ostim.IsActorActive(PlayerRef))
            displayFlair("smoochesAISceneIsPlaying is true & player is in ostim scene")
        Else
            displayFlair("moochesAISceneIsPlaying is true & player is not in ostim scene")
        endif
    Else
        if (Ostim.IsActorActive(PlayerRef))
            displayFlair("smoochesAISceneIsPlaying is False & player is in ostim scene")
        Else
            displayFlair("smoochesAISceneIsPlaying is False &player is not in ostim scene")
        endif
    endIf
EndEvent

Function OnInit()
    displayFlair("smooches oninit")
    ; RegisterForModEvent("ostim_orgasm", "OStimOrgasm")
    ;RegisterForModEvent("ostim_end", "OStimEnd")
    ;RegisterForModEvent("ostim_start", "OStimStart")
endFunction

;; END EVENT HANDLERS ;;