

   MEMBER('DotNetColorPickerDemo.clw')                     ! This is a MEMBER module


   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('DOTNETCOLORPICKERDEMO001.INC'),ONCE        !Local module procedure declarations
MainOLEEventHandler    PROCEDURE(*SHORT ref,SIGNED OLEControlFEQ,LONG OLEEvent),LONG
MainOLEPropChange      PROCEDURE(SIGNED OLEControlFEQ,STRING ChangedProperty)
MainOLEPropEdit        PROCEDURE(SIGNED OLEControlFEQ,STRING EditedProperty),LONG
                     END


!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
Main PROCEDURE 

Window               WINDOW('.NET Color Picker Demo'),AT(,,364,212),FONT('Segoe UI',10),RESIZE,AUTO,ICON(ICON:Clarion), |
  GRAY,SYSTEM,IMM
                       BUTTON('Close'),AT(319,189),USE(?Close)
                       OLE,AT(2,1,361,185),USE(?OLE)
                       END
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END


  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Main')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Close
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  SELF.Open(Window)                                        ! Open window
  Do DefineListboxStyle
  	?OLE{PROP:Create} = 'ClaColorPicker'    
  OCXRegisterEventProc(?OLE,MainOLEEventHandler)
  OCXRegisterPropChange(?OLE,MainOLEPropChange)
  OCXRegisterPropEdit(?OLE,MainOLEPropEdit)
  Resizer.Init(AppStrategy:Spread)                         ! Controls will spread out as the window gets bigger
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('Main',Window)                              ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.Opened
    INIMgr.Update('Main',Window)                           ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue

!---------------------------------------------------
MainOLEEventHandler FUNCTION(*SHORT ref,SIGNED OLEControlFEQ,LONG OLEEvent)
! The order doesn't look right but it's correct :-)
ColorGrp        GROUP
B               BYTE
G               BYTE
R               BYTE
A               BYTE
                END
ColorLng        Long,Over(ColorGrp)
  CODE
    Case OLEEvent 
        Of 301
        If OcxGetParamCount(ref)
            ! OcxGetParam(ref, 1) = STRING  Alpha,Red,Green,Blue
            ! OcxGetParam(ref, 2) = LONG Color as Argb
        End
    End  
  RETURN(True)
!---------------------------------------------------
MainOLEPropChange PROCEDURE(SIGNED OLEControlFEQ,STRING ChangedProperty)
  CODE
!---------------------------------------------------
MainOLEPropEdit FUNCTION(SIGNED OLEControlFEQ,STRING EditedProperty)
  CODE
  RETURN(0)

Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window
  SELF.SetStrategy(?Close, Resize:Reposition, Resize:LockSize) ! Override strategy for ?Close
  SELF.SetStrategy(?OLE, Resize:LockXPos+Resize:LockYPos, Resize:Resize) ! Override strategy for ?OLE

