*&---------------------------------------------------------------------*
*& INCLUDE              ZZCOMR_TABLE_CREATE_PB0
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_9100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_9100 OUTPUT.
  SET PF-STATUS '9100_STD'.
  SET TITLEBAR  '9100_TITLE1'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module DISPLAY_ALV_9100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE DISPLAY_ALV_9100 OUTPUT.
  IF GO_DOCKING_9100 IS NOT BOUND.
    PERFORM FRM_CREATE_CONTAINER_9100.
    PERFORM FRM_CREATE_GRID_9100.
    PERFORM FRM_FIELDCAT_9100.
    PERFORM FRM_LAYOUT.
    PERFORM FRM_ALV_BTN_EXCLUDE_9100.
    PERFORM FRM_ALV_EVENT_9100.
    PERFORM FRM_ALV_DISPLAY_9100.
    "PERFORM FRM_SET_FILTER_FOR_OOALV.
  ELSE.
*    PERFORM FRM_REFRESH_ALV_9100 USING G_GRID_T.
*    PERFORM FRM_REFRESH_ALV_9100 USING G_GRID_L.
*    PERFORM FRM_REFRESH_ALV_9100 USING G_GRID_R.
  ENDIF.

ENDMODULE.