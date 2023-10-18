*&---------------------------------------------------------------------*
*& INCLUDE               ZZCOMR_TABLE_CREATE_SCN
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  PARAMETERS:P_FILE  LIKE RLGRAP-FILENAME MEMORY ID F1.
  PARAMETERS:P_DEVCL TYPE DEVCLASS DEFAULT '$TMP'  .
  PARAMETERS:P_REQU  LIKE E070-TRKORR MODIF ID TR .
  PARAMETERS:P_CHECK AS CHECKBOX DEFAULT 'X'.
  PARAMETERS:P_EXIST AS CHECKBOX DEFAULT ''.
SELECTION-SCREEN END OF BLOCK B1.


SELECTION-SCREEN FUNCTION KEY 1.




*-----------------------------------------------------------------------
* AT SELECTION-SCREEN OUTPUT   --- PBO
*-----------------------------------------------------------------------
AT SELECTION-SCREEN OUTPUT.
  PERFORM FRM_CHANGE_BUTTON.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE. "UPLOAD FILE
  PERFORM FRM_GET_FILE_NAME.

AT SELECTION-SCREEN.
  "function code in screen
  PERFORM FRM_BUTTON_SELECT_SCREEN.

*-----------------------------------------------------------------------
* INITIALIZATION
*-----------------------------------------------------------------------
INITIALIZATION.
  PERFORM FRM_INIT.




*-----------------------------------------------------------------------
* START-OF-SELECTION
*-----------------------------------------------------------------------
START-OF-SELECTION.

  PERFORM FRM_START_INIT.
  PERFORM FRM_CHECK.

  IF GV_TYPE NE 'E'.
    PERFORM FRM_GET_DOCUMENT.
  ENDIF.



*-----------------------------------------------------------------------
* END-OF-SELECTION
*-----------------------------------------------------------------------

END-OF-SELECTION.
  IF GV_TYPE NE 'E' AND GV_TYPE NE 'S' AND SY-BATCH NE 'X'.
    PERFORM FRM_SHOW.
  ELSE.
    MESSAGE GV_MESSAGE TYPE 'I' DISPLAY LIKE GV_TYPE.
  ENDIF.