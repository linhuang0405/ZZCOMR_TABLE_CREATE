*&---------------------------------------------------------------------*
*& 包含               ZZCOMR_TABLE_CREATE_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_9100 INPUT.

  DATA OK_CODE LIKE SY-UCOMM.
  OK_CODE = SY-UCOMM.
  CASE OK_CODE.
    WHEN '&F03' OR '&F12'."退出
      LEAVE TO SCREEN 0.
    WHEN '&F15'.
      LEAVE PROGRAM.
    WHEN 'SHOW_ALL_ERROR'.
      PERFORM FRM_SHOW_ALL_ERROR.
    WHEN 'CREATE_ALL'.
      PERFORM FRM_CREATE_ALL.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.