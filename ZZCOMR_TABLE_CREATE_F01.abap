*&---------------------------------------------------------------------*
*& INCLUDE               ZZCOMR_TABLE_CREATE_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& FORM FRM_GET_DOCUMENT
*&---------------------------------------------------------------------*
*& TEXT get data from excel
*&---------------------------------------------------------------------*
*& -->  P1        TEXT
*& <--  P2        TEXT
*&---------------------------------------------------------------------*
FORM FRM_GET_DOCUMENT .

  DATA : LV_FILENAME      TYPE STRING,
         LT_RECORDS       TYPE SOLIX_TAB,
         LV_HEADERXSTRING TYPE XSTRING,
         LV_FILELENGTH    TYPE I.

  LV_FILENAME = p_file.

  IF GV_TYPE NE 'E'.
    PERFORM FRM_SET_INDICATOR USING TEXT-T90.
    PERFORM FRM_GET_DATA_FROM_EXCEL USING LV_FILENAME CHANGING LV_HEADERXSTRING.
  ENDIF.

  IF GV_TYPE NE 'E'.
    PERFORM FRM_SET_INDICATOR USING TEXT-T91.
    PERFORM FRM_CONVER_DATA USING LV_FILENAME LV_HEADERXSTRING.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& FORM FRM_SHOW
*&---------------------------------------------------------------------*
*& TEXT show alv
*&---------------------------------------------------------------------*
*& -->  P1        TEXT
*& <--  P2        TEXT
*&---------------------------------------------------------------------*
FORM FRM_SHOW .

  CALL SCREEN 9100.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form FRM_INIT
*&---------------------------------------------------------------------*
*& text init when you run this program
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_INIT .

  DATA:FUNCTXT TYPE SMP_DYNTXT.

  SSCRFIELDS-FUNCTXT_01 = TEXT-T01.
  FUNCTXT-TEXT = TEXT-T01.
  FUNCTXT-ICON_TEXT = TEXT-T01.
  FUNCTXT-ICON_ID = ICON_EXPORT.
  SSCRFIELDS-FUNCTXT_01 = FUNCTXT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_CHECK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_CHECK .

ENDFORM.

*&---------------------------------------------------------------------*
*& Form FRM_SET_INDICATOR
*&---------------------------------------------------------------------*
*& text Set Indicator
*&---------------------------------------------------------------------*
*&      --> TEXT_T01
*&---------------------------------------------------------------------*
FORM FRM_SET_INDICATOR  USING    P_TEXT_T01.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = P_TEXT_T01.   "text for process
ENDFORM.

*&---------------------------------------------------------------------*
*& Form FRM_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_DOUBLE_CLICK USING P_INDEX.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SHOW_SALV
*&---------------------------------------------------------------------*
*& text show salv
*&---------------------------------------------------------------------*
*&      --> LT_BSIS
*&---------------------------------------------------------------------*
FORM FRM_SHOW_SALV  TABLES   P_LT_TABLE.

  DATA: LO_ALV       TYPE REF TO CL_SALV_TABLE,
        LR_FUNCTIONS TYPE REF TO CL_SALV_FUNCTIONS_LIST.

  DATA: LR_COLUMNS TYPE REF TO CL_SALV_COLUMNS_TABLE,
        LR_COLUMN  TYPE REF TO CL_SALV_COLUMN.

  CL_SALV_TABLE=>FACTORY( IMPORTING R_SALV_TABLE = LO_ALV
                        CHANGING  T_TABLE   = P_LT_TABLE[] ).



  LR_FUNCTIONS = LO_ALV->GET_FUNCTIONS( ).
  LR_FUNCTIONS->SET_ALL( 'X' ).

  LO_ALV->SET_SCREEN_STATUS(
    PFSTATUS      =  'STANDARD_FULLSCREEN'
    REPORT        =  'SAPLKKBL'
    SET_FUNCTIONS = LO_ALV->C_FUNCTIONS_ALL ).

  LR_COLUMNS  =  LO_ALV->GET_COLUMNS( ).
  PERFORM FRM_CHANGE_FIELDNAME USING LR_COLUMNS 'SHEET_NAME'    TEXT-T92."Sheet Name
  PERFORM FRM_CHANGE_FIELDNAME USING LR_COLUMNS 'ROW'           TEXT-T93."Row
  PERFORM FRM_CHANGE_FIELDNAME USING LR_COLUMNS 'ERROR_MESSAGE' TEXT-T94."Error Message


  LO_ALV->SET_SCREEN_POPUP(
    START_COLUMN = 1
    END_COLUMN   = 100
    START_LINE   = 1
    END_LINE     = 20 ).

  LO_ALV->DISPLAY( ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SAVE_MESSAGE
*&---------------------------------------------------------------------*
*& text save message
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_SAVE_MESSAGE .


ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_START_INIT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_START_INIT .
  IF p_file IS INITIAL and GV_TYPE IS NOT INITIAL.
    GV_TYPE = 'E'.
    GV_MESSAGE = TEXT-E01.
  ENDIF.

  IF P_DEVCL IS INITIAL AND GV_TYPE IS NOT INITIAL.
    GV_TYPE = 'E'.
    GV_MESSAGE = TEXT-E02.
  ENDIF.

  IF P_DEVCL NE '$TMP' AND P_REQU IS INITIAL .
    GV_TYPE = 'E'.
    GV_MESSAGE = TEXT-E03.
  ENDIF.


  IF P_EXIST EQ 'X'.
    PERFORM FRM_GET_DATA_FROM_SYSTEM.
  ENDIF.





ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_GET_BUTTON
*&---------------------------------------------------------------------*
*& text button to confirm you choose
*&---------------------------------------------------------------------*
*&      --> TEXT_T10
*&      <-- LV_BUTTON
*&---------------------------------------------------------------------*
FORM FRM_GET_BUTTON  USING LV_TEXT  CHANGING P_LV_BUTTON.

  DATA: LV_ANSWER.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      TEXT_QUESTION         = LV_TEXT
      TEXT_BUTTON_1         = TEXT-M02
      ICON_BUTTON_1         = 'ICON_OKAY'
      TEXT_BUTTON_2         = TEXT-M03
      ICON_BUTTON_2         = 'ICON_CANCEL'
      DEFAULT_BUTTON        = '1'
      DISPLAY_CANCEL_BUTTON = ''
    IMPORTING
      ANSWER                = LV_ANSWER
    EXCEPTIONS
      TEXT_NOT_FOUND        = 1.
  P_LV_BUTTON = LV_ANSWER.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_CHECK_DATA
*&---------------------------------------------------------------------*
*& text check data
*&---------------------------------------------------------------------*
*&      <-- LV_ERROR
*&      <-- LV_MESSAGE
*&---------------------------------------------------------------------*
FORM FRM_CHECK_DATA  CHANGING P_LV_ERROR
                              P_LV_MESSAGE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_GET_FILE_NAME
*&---------------------------------------------------------------------*
*& text button event when press F4 of file(choose file from your PC)
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_GET_FILE_NAME .
  DATA:l_obj   TYPE REF TO cl_gui_frontend_services,
       it_file TYPE filetable WITH HEADER LINE,
       g_rc    TYPE i.
  CREATE OBJECT l_obj.
  CALL METHOD l_obj->file_open_dialog
    EXPORTING
      file_filter       = '*.XLS;*.XLSX;*.TXT'
      initial_directory = 'C:\DATA'
    CHANGING
      file_table        = it_file[]
      rc                = g_rc.
  READ TABLE it_file INDEX 1.
  p_file = it_file-filename.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_BUTTON_SELECT_SCREEN
*&---------------------------------------------------------------------*
*& text button event of download template
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_BUTTON_SELECT_SCREEN .
  CASE sscrfields-ucomm .
    WHEN 'FC01'.
      PERFORM FRM_DOWNLOAD_INFTY_TEMPLATE.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_DOWNLOAD_INFTY_template
*&---------------------------------------------------------------------*
*& text download template from smw0,filename:ZZCOMR_TABLE_CREATE
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_DOWNLOAD_INFTY_TEMPLATE .

  DATA FILENAME            TYPE STRING.
  DATA PATH                TYPE STRING.
  DATA FULLPATH            TYPE STRING.
  DATA FILE_FILTER         TYPE STRING.

  DATA KEY         TYPE WWWDATATAB.
  DATA DESTINATION TYPE RLGRAP-FILENAME.
  DATA RC          TYPE SY-SUBRC.
  IF SY-UCOMM = 'FC01'.
    CLEAR FILE_FILTER.
    FILE_FILTER = CL_GUI_FRONTEND_SERVICES=>FILETYPE_EXCEL.

    CLEAR FULLPATH.
    FILENAME = TEXT-T03.
    CL_GUI_FRONTEND_SERVICES=>FILE_SAVE_DIALOG(
      EXPORTING
        DEFAULT_FILE_NAME         = FILENAME
        FILE_FILTER               = FILE_FILTER
      CHANGING
        FILENAME                  = FILENAME
        PATH                      = PATH
        FULLPATH                  = FULLPATH
      EXCEPTIONS
        CNTL_ERROR                = 1
        ERROR_NO_GUI              = 2
        NOT_SUPPORTED_BY_GUI      = 3
        INVALID_DEFAULT_FILE_NAME = 4
           ).

    CHECK FULLPATH IS NOT INITIAL.

    DESTINATION = FULLPATH.

    KEY-RELID = 'MI'.
    KEY-OBJID = 'ZZCOMR_TABLE_CREATE'.

    CALL FUNCTION 'DOWNLOAD_WEB_OBJECT'
      EXPORTING
        KEY         = KEY
        DESTINATION = DESTINATION
      IMPORTING
        RC          = RC.
    IF RC = 0.

    ENDIF.
  ELSEIF SY-UCOMM = 'ONLI'.
    IF P_FILE IS INITIAL.
      MESSAGE TEXT-T03 TYPE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_CHANGE_BUTTON
*&---------------------------------------------------------------------*
*& text Change Select-option
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_CHANGE_BUTTON .

  LOOP AT SCREEN.
    IF P_DEVCL EQ '$TMP'.

      "there is no need TR for local object
      IF SCREEN-GROUP1 EQ 'TR'.
        SCREEN-INPUT  = 0.
      ENDIF.
      CLEAR:P_REQU.
    ELSE.
      IF SCREEN-GROUP1 EQ 'TR'.
        SCREEN-INPUT  = 1.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form FRM_GET_DATA_FROM_EXCEL
*&---------------------------------------------------------------------*
*& text Upload Excel
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_GET_DATA_FROM_EXCEL USING P_LV_FILENAME TYPE STRING
                           CHANGING P_LV_HEADERXSTRING TYPE XSTRING .

  DATA : LV_HEADERXSTRING TYPE XSTRING,
         LT_RECORDS       TYPE SOLIX_TAB,
         LV_FILELENGTH    TYPE I.

  P_LV_FILENAME = P_FILE.

  "upload data from file
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      FILENAME                = P_LV_FILENAME
      FILETYPE                = 'BIN'
    IMPORTING
      FILELENGTH              = LV_FILELENGTH
      HEADER                  = LV_HEADERXSTRING
    TABLES
      DATA_TAB                = LT_RECORDS
    EXCEPTIONS
      FILE_OPEN_ERROR         = 1
      FILE_READ_ERROR         = 2
      NO_BATCH                = 3
      GUI_REFUSE_FILETRANSFER = 4
      INVALID_TYPE            = 5
      NO_AUTHORITY            = 6
      UNKNOWN_ERROR           = 7
      BAD_DATA_FORMAT         = 8
      HEADER_NOT_ALLOWED      = 9
      SEPARATOR_NOT_ALLOWED   = 10
      HEADER_TOO_LONG         = 11
      UNKNOWN_DP_ERROR        = 12
      ACCESS_DENIED           = 13
      DP_OUT_OF_MEMORY        = 14
      DISK_FULL               = 15
      DP_TIMEOUT              = 16
      OTHERS                  = 17.
  IF SY-SUBRC IS NOT INITIAL.

    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.

  ENDIF.

  CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
    EXPORTING
      INPUT_LENGTH = LV_FILELENGTH
    IMPORTING
      BUFFER       = P_LV_HEADERXSTRING
    TABLES
      BINARY_TAB   = LT_RECORDS
    EXCEPTIONS
      FAILED       = 1
      OTHERS       = 2.

  IF SY-SUBRC IS NOT INITIAL.
    GV_TYPE = 'E'.

    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
          WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4
          INTO GV_MESSAGE.
    EXIT.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_CONVER_DATA
*&---------------------------------------------------------------------*
*& text Conver Data From Excel
*&---------------------------------------------------------------------*
*&      --> LT_RECORDS
*&---------------------------------------------------------------------*
FORM FRM_CONVER_DATA USING P_LV_FILENAME P_LV_HEADERXSTRING .


  DATA: LO_EXCEL_REF  TYPE REF TO CL_FDT_XL_SPREADSHEET .
  DATA: LV_SHEET_NAME TYPE STRING.
  TRY .
      LO_EXCEL_REF = NEW CL_FDT_XL_SPREADSHEET(
                         DOCUMENT_NAME = P_LV_FILENAME
                         XDOCUMENT     = P_LV_HEADERXSTRING
                       ) .
    CATCH CX_FDT_EXCEL_CORE INTO DATA(LS_CX_FDT_EXCEL_CORE).
      GV_TYPE = 'E'.
      GV_MESSAGE = LS_CX_FDT_EXCEL_CORE->GET_LONGTEXT( ).
  ENDTRY .
  IF GV_TYPE EQ 'E'.
    EXIT.
  ENDIF.

  "GET LIST OF WORKSHEETS
  LO_EXCEL_REF->IF_FDT_DOC_SPREADSHEET~GET_WORKSHEET_NAMES(
    IMPORTING
      WORKSHEET_NAMES = DATA(LT_WORKSHEETS) ).

  LOOP AT LT_WORKSHEETS ASSIGNING FIELD-SYMBOL(<FS_WOKSHEETNAME>).

    LV_SHEET_NAME = <FS_WOKSHEETNAME>.
    TRANSLATE LV_SHEET_NAME TO UPPER CASE.

    CASE LV_SHEET_NAME .
      WHEN 'TABLE'.
        PERFORM FRM_CREATE_TABLE_TABLE USING LO_EXCEL_REF <FS_WOKSHEETNAME> .
      WHEN 'FIELD'.
        PERFORM FRM_CREATE_TABLE_FIELD USING LO_EXCEL_REF <FS_WOKSHEETNAME> .
      WHEN 'ELEMENT'.
        PERFORM FRM_CREATE_TABLE_ELEMENT USING LO_EXCEL_REF <FS_WOKSHEETNAME> .
      WHEN 'DOMAIN'.
        PERFORM FRM_CREATE_TABLE_DOMAIN USING LO_EXCEL_REF <FS_WOKSHEETNAME> .
      WHEN 'DOMAINVALUERANGE'.
        PERFORM FRM_CREATE_TABLE_DD07T  USING LO_EXCEL_REF <FS_WOKSHEETNAME> .
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SET_DATA_INTO_FS
*&---------------------------------------------------------------------*
*& text Set P_FS_VALUE Into Field-symbol P_FS_GS_DOMAIN
*&---------------------------------------------------------------------*
*&      --> P_FIELDNAME
*&      --> P_FS_VALUE
*&      <-- P_FS_GS_DOMAIN
*&---------------------------------------------------------------------*
FORM FRM_SET_DATA_INTO_FS  USING    P_FIELDNAME
                                    P_FS_VALUE
                                    P_FS_KEY_VALUE
                           CHANGING P_FS_GS_DOMAIN.

  ASSIGN COMPONENT P_FIELDNAME OF STRUCTURE P_FS_GS_DOMAIN TO FIELD-SYMBOL(<FS_LINEA_VALUE>).
  IF <FS_LINEA_VALUE> IS ASSIGNED.
    IF P_FS_VALUE+0(1) EQ SPACE.
      <FS_LINEA_VALUE> = SPACE.
    ELSEIF P_FS_KEY_VALUE EQ 'X'.
      SPLIT P_FS_VALUE AT SPACE INTO <FS_LINEA_VALUE> DATA(LV_TEMP).
    ELSE.
      <FS_LINEA_VALUE> = P_FS_VALUE.
    ENDIF.

    UNASSIGN <FS_LINEA_VALUE>.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_GET_DATA_FROM_FS
*&---------------------------------------------------------------------*
*& text Get value from P_FS
*&---------------------------------------------------------------------*
*&      --> LV_TABIX_AFTER
*&      --> P_FS
*&      <-- P_VALUE
*&---------------------------------------------------------------------*
FORM FRM_GET_DATA_FROM_FS  USING    P_LV_TABIX_AFTER
                                    P_FS
                           CHANGING P_VALUE.

  ASSIGN COMPONENT P_LV_TABIX_AFTER OF STRUCTURE P_FS TO FIELD-SYMBOL(<FS_DATA_CHECK>).
  IF <FS_DATA_CHECK> IS ASSIGNED.
    P_VALUE = <FS_DATA_CHECK>.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_CREATE_TABLE_TABLE
*&---------------------------------------------------------------------*
*& text General Table By Table Sheet
*&---------------------------------------------------------------------*
*&      --> LO_EXCEL_REF
*&      --> <FS_WOKSHEETNAME>
*&---------------------------------------------------------------------*
FORM FRM_CREATE_TABLE_TABLE  USING     P_LO_EXCEL_REF TYPE REF TO CL_FDT_XL_SPREADSHEET
                                       P_FS_WOKSHEETNAME.


  DATA:LT_DFIES        TYPE DDFIELDS.
  DATA:LS_ALV_FILEDCAT_DOMAIN LIKE LINE OF GT_ALV_FILEDCAT_DOMAIN.

  DATA: IT_CREATE      TYPE REF TO CL_ALV_TABLE_CREATE,
        IT_DYNAMIC     TYPE REF TO DATA,
        IT_DYNAMIC_RES TYPE REF TO DATA.
  DATA: NEW_LINE TYPE REF TO DATA.

  PERFORM FRM_GET_DFIED_SHEET TABLES LT_DFIES USING P_FS_WOKSHEETNAME P_LO_EXCEL_REF .

  "field name
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_LT_FILENAME>) INDEX GV_EXCEL_FILED_NAME.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E05."Can't find Filed Name in sheet of Domain（Row 1）
    REPLACE 'WOKSHEETNAME' WITH P_FS_WOKSHEETNAME INTO GV_MESSAGE.
    EXIT.
  ENDIF.

  "ref table
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_LT_REF_TABLE>) INDEX GV_EXCEL_REF_TABLE.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E06."Can't find ref table in sheet of Domain（Row 4）
    REPLACE 'WOKSHEETNAME' WITH P_FS_WOKSHEETNAME INTO GV_MESSAGE.
    EXIT.
  ENDIF.

  "ref field
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_LT_REF_FIELD>) INDEX GV_EXCEL_REF_FIELD.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E07."Can't find ref field in sheet of Domain（Row 5）
    REPLACE 'WOKSHEETNAME' WITH P_FS_WOKSHEETNAME INTO GV_MESSAGE.
    EXIT.
  ENDIF.

  "Key Value
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_GS_EXCEL_KEY_VALUE>) INDEX GV_EXCEL_KEY_VALUE.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E08."Can't find ref field in sheet of &1（Row 6）
    REPLACE 'WOKSHEETNAME' WITH P_FS_WOKSHEETNAME INTO GV_MESSAGE.
    EXIT.
  ENDIF.


  PERFORM FRM_GET_FIELDCAT TABLES LT_DFIES GT_ALV_FILEDCAT_TABLE USING <FS_LT_FILENAME> <FS_LT_REF_TABLE> <FS_LT_REF_FIELD> P_FS_WOKSHEETNAME.

  "create FIELD-SYMBOLS dynamic
  CREATE OBJECT IT_CREATE.
  IT_CREATE->CREATE_DYNAMIC_TABLE(
      EXPORTING IT_FIELDCATALOG = GT_ALV_FILEDCAT_TABLE[]
      IMPORTING EP_TABLE        = IT_DYNAMIC      ).

  ASSIGN IT_DYNAMIC->* TO <FS_GT_TABLE>.
  CREATE DATA NEW_LINE LIKE LINE OF <FS_GT_TABLE>.
  ASSIGN NEW_LINE->* TO <FS_GS_TABLE>.

  PERFORM FRM_CREATE_INTERNAL_TABLE TABLES LT_DFIES GT_ALV_FILEDCAT_TABLE <FS_GO_EXCEL_DATA_SHEET> <FS_GT_TABLE> USING P_FS_WOKSHEETNAME <FS_GS_EXCEL_KEY_VALUE> CHANGING <FS_GS_TABLE> .

  DATA:LS_DD02V LIKE LINE OF GT_DD02V.
  LOOP AT <FS_GT_TABLE> ASSIGNING FIELD-SYMBOL(<FS_GS_TABLE>).
    MOVE-CORRESPONDING <FS_GS_TABLE> TO LS_DD02V.
    APPEND LS_DD02V TO GT_DD02V.
  ENDLOOP.
  SORT GT_DD02V BY TABNAME.

  UNASSIGN:<FS_GO_EXCEL_DATA_SHEET>.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_CREATE_TABLE_FIELD
*&---------------------------------------------------------------------*
*& text General Table By Field Sheet
*&---------------------------------------------------------------------*
*&      --> LO_EXCEL_REF
*&      --> <FS_WOKSHEETNAME>
*&---------------------------------------------------------------------*
FORM FRM_CREATE_TABLE_FIELD  USING     P_LO_EXCEL_REF TYPE REF TO CL_FDT_XL_SPREADSHEET
                                       P_FS_WOKSHEETNAME.


  DATA:LT_DFIES        TYPE DDFIELDS.
  DATA:LS_ALV_FILEDCAT_DOMAIN LIKE LINE OF GT_ALV_FILEDCAT_DOMAIN.

  DATA: IT_CREATE      TYPE REF TO CL_ALV_TABLE_CREATE,
        IT_DYNAMIC     TYPE REF TO DATA,
        IT_DYNAMIC_RES TYPE REF TO DATA.
  DATA: NEW_LINE TYPE REF TO DATA.

  PERFORM FRM_GET_DFIED_SHEET TABLES LT_DFIES USING P_FS_WOKSHEETNAME P_LO_EXCEL_REF .

  "field name
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_LT_FILENAME>) INDEX GV_EXCEL_FILED_NAME.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E05."Can't find Filed Name in sheet of Domain（Row 1）
    EXIT.
  ENDIF.

  "ref table
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_LT_REF_TABLE>) INDEX GV_EXCEL_REF_TABLE.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E06."Can't find ref table in sheet of Domain（Row 4）
    EXIT.
  ENDIF.

  "ref field
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_LT_REF_FIELD>) INDEX GV_EXCEL_REF_FIELD.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E07."Can't find ref field in sheet of Domain（Row 5）
    EXIT.
  ENDIF.

  "Key Value
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_GS_EXCEL_KEY_VALUE>) INDEX GV_EXCEL_KEY_VALUE.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E08."Can't find ref field in sheet of &1（Row 6）
    REPLACE 'WOKSHEETNAME' WITH P_FS_WOKSHEETNAME INTO GV_MESSAGE.
    EXIT.
  ENDIF.

  PERFORM FRM_GET_FIELDCAT TABLES LT_DFIES GT_ALV_FILEDCAT_TABLE_FIELD USING <FS_LT_FILENAME> <FS_LT_REF_TABLE> <FS_LT_REF_FIELD> P_FS_WOKSHEETNAME.


  "create FIELD-SYMBOLS dynamic
  CREATE OBJECT IT_CREATE.
  IT_CREATE->CREATE_DYNAMIC_TABLE(
      EXPORTING IT_FIELDCATALOG = GT_ALV_FILEDCAT_TABLE_FIELD[]
      IMPORTING EP_TABLE        = IT_DYNAMIC      ).

  ASSIGN IT_DYNAMIC->* TO <FS_GT_TABLE_FIELD>.
  CREATE DATA NEW_LINE LIKE LINE OF <FS_GT_TABLE_FIELD>.
  ASSIGN NEW_LINE->* TO <FS_GS_TABLE_FIELD>.

  PERFORM FRM_CREATE_INTERNAL_TABLE TABLES LT_DFIES GT_ALV_FILEDCAT_TABLE_FIELD <FS_GO_EXCEL_DATA_SHEET> <FS_GT_TABLE_FIELD> USING P_FS_WOKSHEETNAME <FS_GS_EXCEL_KEY_VALUE> CHANGING <FS_GS_TABLE_FIELD>.

  DATA:LS_DD03L LIKE LINE OF GT_DD03L.
  LOOP AT <FS_GT_TABLE_FIELD> ASSIGNING FIELD-SYMBOL(<FS_GS_TABLE_FIELD>).
    MOVE-CORRESPONDING <FS_GS_TABLE_FIELD> TO LS_DD03L.
    APPEND LS_DD03L TO GT_DD03L.
  ENDLOOP.
  SORT GT_DD03L BY TABNAME POSITION.

  UNASSIGN:<FS_GO_EXCEL_DATA_SHEET>.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_CREATE_TABLE_ELEMENT
*&---------------------------------------------------------------------*
*& text General Table By Element Sheet
*&---------------------------------------------------------------------*
*&      --> LO_EXCEL_REF
*&      --> <FS_WOKSHEETNAME>
*&---------------------------------------------------------------------*
FORM FRM_CREATE_TABLE_ELEMENT  USING P_LO_EXCEL_REF TYPE REF TO CL_FDT_XL_SPREADSHEET
                                       P_FS_WOKSHEETNAME.

  DATA:LT_DFIES        TYPE DDFIELDS.
  DATA:LS_ALV_FILEDCAT_DOMAIN LIKE LINE OF GT_ALV_FILEDCAT_DOMAIN.

  DATA: IT_CREATE      TYPE REF TO CL_ALV_TABLE_CREATE,
        IT_DYNAMIC     TYPE REF TO DATA,
        IT_DYNAMIC_RES TYPE REF TO DATA.
  DATA: NEW_LINE TYPE REF TO DATA.
  DATA: LT_DD01V TYPE TABLE OF DD01V,
        LS_DD01V LIKE LINE OF LT_DD01V.
  PERFORM FRM_GET_DFIED_SHEET TABLES LT_DFIES USING P_FS_WOKSHEETNAME P_LO_EXCEL_REF .

  "field name
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_LT_FILENAME>) INDEX GV_EXCEL_FILED_NAME.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E05."Can't find Filed Name in sheet of Domain（Row 1）
    EXIT.
  ENDIF.

  "ref table
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_LT_REF_TABLE>) INDEX GV_EXCEL_REF_TABLE.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E06."Can't find ref table in sheet of Domain（Row 4）
    EXIT.
  ENDIF.

  "ref field
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_LT_REF_FIELD>) INDEX GV_EXCEL_REF_FIELD.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E07."Can't find ref field in sheet of Domain（Row 5）
    EXIT.
  ENDIF.

  "Key Value
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_GS_EXCEL_KEY_VALUE>) INDEX GV_EXCEL_KEY_VALUE.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E08."Can't find ref field in sheet of &1（Row 6）
    REPLACE 'WOKSHEETNAME' WITH P_FS_WOKSHEETNAME INTO GV_MESSAGE.
    EXIT.
  ENDIF.

  PERFORM FRM_GET_FIELDCAT TABLES LT_DFIES GT_ALV_FILEDCAT_ELEMENT USING <FS_LT_FILENAME> <FS_LT_REF_TABLE> <FS_LT_REF_FIELD> P_FS_WOKSHEETNAME.


  "create FIELD-SYMBOLS dynamic
  CREATE OBJECT IT_CREATE.
  IT_CREATE->CREATE_DYNAMIC_TABLE(
      EXPORTING IT_FIELDCATALOG = GT_ALV_FILEDCAT_ELEMENT[]
      IMPORTING EP_TABLE        = IT_DYNAMIC      ).

  ASSIGN IT_DYNAMIC->* TO <FS_GT_ELEMENT>.
  CREATE DATA NEW_LINE LIKE LINE OF <FS_GT_ELEMENT>.
  ASSIGN NEW_LINE->* TO <FS_GS_ELEMENT>.

  PERFORM FRM_CREATE_INTERNAL_TABLE TABLES LT_DFIES GT_ALV_FILEDCAT_ELEMENT <FS_GO_EXCEL_DATA_SHEET> <FS_GT_ELEMENT> USING P_FS_WOKSHEETNAME <FS_GS_EXCEL_KEY_VALUE> CHANGING <FS_GS_ELEMENT>.


*  LOOP AT <FS_GT_ELEMENT> ASSIGNING FIELD-SYMBOL(<FS_GS_ELEMENT>).
*    MOVE-CORRESPONDING <FS_GS_ELEMENT> TO LS_DD01V.
*    APPEND LS_DD01V TO LT_DD01V.
*  ENDLOOP.
*  SORT LT_DD01V BY DOMNAME.
*
*  SELECT DOMNAME , COUNT( * ) AS CONUT
*    FROM @LT_DD01V AS DD01V
*   GROUP BY DOMNAME
*    INTO TABLE @DATA(LT_DD01V_COUNT).
*
*  DELETE LT_DD01V_COUNT WHERE CONUT LE 1.
*  LOOP AT LT_DD01V_COUNT ASSIGNING FIELD-SYMBOL(<FS_DD01V_COUNT>).
*    LT
*  ENDLOOP.

  UNASSIGN:<FS_GO_EXCEL_DATA_SHEET>.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form FRM_CREATE_TABLE_DOMAIN
*&---------------------------------------------------------------------*
*& text General Table By Domain Sheet
*&---------------------------------------------------------------------*
*&      --> LO_EXCEL_REF
*&      --> <FS_WOKSHEETNAME>
*&---------------------------------------------------------------------*
FORM FRM_CREATE_TABLE_DOMAIN  USING    P_LO_EXCEL_REF TYPE REF TO CL_FDT_XL_SPREADSHEET
                                       P_FS_WOKSHEETNAME.

  DATA:LT_DFIES        TYPE DDFIELDS.


  DATA: IT_CREATE      TYPE REF TO CL_ALV_TABLE_CREATE,
        IT_DYNAMIC     TYPE REF TO DATA,
        IT_DYNAMIC_RES TYPE REF TO DATA.
  DATA: NEW_LINE TYPE REF TO DATA.

  PERFORM FRM_GET_DFIED_SHEET TABLES LT_DFIES USING P_FS_WOKSHEETNAME P_LO_EXCEL_REF .


  "field name
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_LT_FILENAME>) INDEX GV_EXCEL_FILED_NAME.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E05."Can't find Filed Name in sheet of Domain（Row 1）
    EXIT.
  ENDIF.

  "ref table
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_LT_REF_TABLE>) INDEX GV_EXCEL_REF_TABLE.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E06."Can't find ref table in sheet of Domain（Row 4）
    EXIT.
  ENDIF.

  "ref field
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_LT_REF_FIELD>) INDEX GV_EXCEL_REF_FIELD.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E07."Can't find ref field in sheet of Domain（Row 5）
    EXIT.
  ENDIF.

  "Key Value
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_GS_EXCEL_KEY_VALUE>) INDEX GV_EXCEL_KEY_VALUE.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E08."Can't find ref field in sheet of &1（Row 6）
    REPLACE 'WOKSHEETNAME' WITH P_FS_WOKSHEETNAME INTO GV_MESSAGE.
    EXIT.
  ENDIF.

  PERFORM FRM_GET_FIELDCAT TABLES LT_DFIES GT_ALV_FILEDCAT_DOMAIN USING <FS_LT_FILENAME> <FS_LT_REF_TABLE> <FS_LT_REF_FIELD> P_FS_WOKSHEETNAME.



  "create FIELD-SYMBOLS dynamic
  CREATE OBJECT IT_CREATE.
  IT_CREATE->CREATE_DYNAMIC_TABLE(
      EXPORTING IT_FIELDCATALOG = GT_ALV_FILEDCAT_DOMAIN[]
      IMPORTING EP_TABLE        = IT_DYNAMIC      ).

  ASSIGN IT_DYNAMIC->* TO <FS_GT_DOMAIN>.
  CREATE DATA NEW_LINE LIKE LINE OF <FS_GT_DOMAIN>.
  ASSIGN NEW_LINE->* TO <FS_GS_DOMAIN>.

  PERFORM FRM_CREATE_INTERNAL_TABLE TABLES LT_DFIES GT_ALV_FILEDCAT_DOMAIN <FS_GO_EXCEL_DATA_SHEET> <FS_GT_DOMAIN> USING P_FS_WOKSHEETNAME <FS_GS_EXCEL_KEY_VALUE> CHANGING <FS_GS_DOMAIN>.


  UNASSIGN:<FS_GO_EXCEL_DATA_SHEET>.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form FRM_CREATE_TABLE_DD07T
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LO_EXCEL_REF
*&      --> <FS_WOKSHEETNAME>
*&---------------------------------------------------------------------*
FORM FRM_CREATE_TABLE_DD07T  USING    P_LO_EXCEL_REF TYPE REF TO CL_FDT_XL_SPREADSHEET
                                       P_FS_WOKSHEETNAME.

  DATA:LT_DFIES        TYPE DDFIELDS.


  DATA: IT_CREATE      TYPE REF TO CL_ALV_TABLE_CREATE,
        IT_DYNAMIC     TYPE REF TO DATA,
        IT_DYNAMIC_RES TYPE REF TO DATA.
  DATA: NEW_LINE TYPE REF TO DATA.

  PERFORM FRM_GET_DFIED_SHEET TABLES LT_DFIES USING P_FS_WOKSHEETNAME P_LO_EXCEL_REF .


  "field name
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_LT_FILENAME>) INDEX GV_EXCEL_FILED_NAME.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E05."Can't find Filed Name in sheet of Domain（Row 1）
    EXIT.
  ENDIF.

  "ref table
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_LT_REF_TABLE>) INDEX GV_EXCEL_REF_TABLE.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E06."Can't find ref table in sheet of Domain（Row 4）
    EXIT.
  ENDIF.

  "ref field
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_LT_REF_FIELD>) INDEX GV_EXCEL_REF_FIELD.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E07."Can't find ref field in sheet of Domain（Row 5）
    EXIT.
  ENDIF.

  "Key Value
  READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_GS_EXCEL_KEY_VALUE>) INDEX GV_EXCEL_KEY_VALUE.
  IF SY-SUBRC NE 0.
    GV_TYPE    = 'E'.
    GV_MESSAGE = TEXT-E08."Can't find ref field in sheet of &1（Row 6）
    REPLACE 'WOKSHEETNAME' WITH P_FS_WOKSHEETNAME INTO GV_MESSAGE.
    EXIT.
  ENDIF.

  PERFORM FRM_GET_FIELDCAT TABLES LT_DFIES GT_ALV_FILEDCAT_DD07T USING <FS_LT_FILENAME> <FS_LT_REF_TABLE> <FS_LT_REF_FIELD>  P_FS_WOKSHEETNAME.

  "create FIELD-SYMBOLS dynamic
  CREATE OBJECT IT_CREATE.
  IT_CREATE->CREATE_DYNAMIC_TABLE(
      EXPORTING IT_FIELDCATALOG = GT_ALV_FILEDCAT_DD07T[]
      IMPORTING EP_TABLE        = IT_DYNAMIC      ).

  ASSIGN IT_DYNAMIC->* TO <FS_GT_DOMAIN_VALUE_RANGE>.
  CREATE DATA NEW_LINE LIKE LINE OF GT_DD07V.
  ASSIGN NEW_LINE->* TO <FS_GS_DOMAIN_VALUE_RANGE>.

  PERFORM FRM_CREATE_INTERNAL_TABLE TABLES LT_DFIES GT_ALV_FILEDCAT_DD07T <FS_GO_EXCEL_DATA_SHEET> GT_DD07V USING P_FS_WOKSHEETNAME <FS_GS_EXCEL_KEY_VALUE> CHANGING <FS_GS_DOMAIN_VALUE_RANGE>.


  UNASSIGN:<FS_GO_EXCEL_DATA_SHEET>.
  SORT GT_DD07V BY DOMNAME.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_GET_DFIED_SHEET
*&---------------------------------------------------------------------*
*& text Get Table "DFIED" From Excel
*&---------------------------------------------------------------------*
*&      --> LT_DFIES
*&      --> P_FS_WOKSHEETNAME
*&      <-- <FS_GO_EXCEL_DATA_SHEET>
*&---------------------------------------------------------------------*
FORM FRM_GET_DFIED_SHEET  TABLES   P_LT_DFIES STRUCTURE DFIES
                          USING    P_FS_WOKSHEETNAME
                                   P_LO_EXCEL_REF TYPE REF TO CL_FDT_XL_SPREADSHEET.

  DATA:LR_DATA     TYPE REF TO DATA,
       LR_TABDESCR TYPE REF TO CL_ABAP_STRUCTDESCR,
       LT_DFIES    TYPE DDFIELDS.

  DATA(LO_DATA_REF) = P_LO_EXCEL_REF->IF_FDT_DOC_SPREADSHEET~GET_ITAB_FROM_WORKSHEET(
                                           P_FS_WOKSHEETNAME ).
  "EXCEL WORK SHEET DATA IN DYANMIC INTERNAL TABLE
  ASSIGN LO_DATA_REF->* TO <FS_GO_EXCEL_DATA_SHEET>.

  CREATE DATA LR_DATA LIKE LINE OF <FS_GO_EXCEL_DATA_SHEET>.
  LR_TABDESCR ?= CL_ABAP_STRUCTDESCR=>DESCRIBE_BY_DATA_REF( LR_DATA ).

  LT_DFIES   = CL_SALV_DATA_DESCR=>READ_STRUCTDESCR( LR_TABDESCR ).
  P_LT_DFIES[] = LT_DFIES.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_GET_FIELDCAT
*&---------------------------------------------------------------------*
*& text Create Fieldcat From Excel
*&---------------------------------------------------------------------*
*&      --> LT_DFIES
*&      --> GT_ALV_FILEDCAT_DOMAIN
*&      --> <FS_LT_FILENAME>
*&      --> <FS_LT_REF_TABLE>
*&      --> <FS_LT_REF_FIELD>
*&---------------------------------------------------------------------*
FORM FRM_GET_FIELDCAT  TABLES   P_LT_DFIES STRUCTURE DFIES
                                P_GT_ALV_FILEDCAT STRUCTURE GS_ALV_FILED
                       USING    P_FS_LS_FILENAME
                                P_FS_LS_REF_TABLE
                                P_FS_LS_REF_FIELD
                                P_FS_WOKSHEETNAME
  .


  DATA:LS_ALV_FILEDCAT LIKE LINE OF GT_ALV_FILEDCAT_DOMAIN.

  "generate fieldcat of Domain
  LOOP AT P_LT_DFIES ASSIGNING FIELD-SYMBOL(<FS_DFIES>) FROM GV_FIELD_BEGIN.

    "FIELDNAME
    ASSIGN COMPONENT <FS_DFIES>-fieldname OF STRUCTURE P_FS_LS_FILENAME TO FIELD-SYMBOL(<FS_VALUE>).
    IF <FS_VALUE> IS ASSIGNED..
      LS_ALV_FILEDCAT-FIELDNAME     = <FS_VALUE>.
    ENDIF.


    "REF_TABLE
    ASSIGN COMPONENT <FS_DFIES>-fieldname OF STRUCTURE P_FS_LS_REF_TABLE TO FIELD-SYMBOL(<FS_REF_TABLE>).
    IF <FS_VALUE> IS ASSIGNED..
      LS_ALV_FILEDCAT-REF_TABLE     = <FS_REF_TABLE>.
    ENDIF.

    "REF_FIELD
    ASSIGN COMPONENT <FS_DFIES>-fieldname OF STRUCTURE P_FS_LS_REF_FIELD TO FIELD-SYMBOL(<FS_REF_FIELD>).
    IF <FS_VALUE> IS ASSIGNED..
      LS_ALV_FILEDCAT-REF_FIELD     = <FS_REF_FIELD>.
    ENDIF.

    IF LS_ALV_FILEDCAT-FIELDNAME eq 'RECREATE'.
      CLEAR:LS_ALV_FILEDCAT-REF_TABLE,
            LS_ALV_FILEDCAT-REF_FIELD.

      LS_ALV_FILEDCAT-COLTEXT       = TEXT-T04."Create Again
      LS_ALV_FILEDCAT-INTTYPE       = 'CHAR'.
      LS_ALV_FILEDCAT-INTLEN        = '1'.
    ENDIF.


    APPEND LS_ALV_FILEDCAT TO P_GT_ALV_FILEDCAT.
    CLEAR:LS_ALV_FILEDCAT.

    AT LAST.
      LS_ALV_FILEDCAT-FIELDNAME     = 'EXIST'.  "
      LS_ALV_FILEDCAT-COLTEXT       = 'Exist In System?' .
      LS_ALV_FILEDCAT-DATATYPE      = 'CHAR'.
      LS_ALV_FILEDCAT-INTLEN        = '1'.
      IF P_FS_WOKSHEETNAME EQ 'Field'.
        LS_ALV_FILEDCAT-NO_OUT = 'X'.
      ENDIF.
      APPEND LS_ALV_FILEDCAT TO P_GT_ALV_FILEDCAT.
      CLEAR:LS_ALV_FILEDCAT.

      LS_ALV_FILEDCAT-FIELDNAME     = 'ICON_UPLOAD'.  "
      LS_ALV_FILEDCAT-COLTEXT       = 'ICON_UPLOAD' .
      LS_ALV_FILEDCAT-INTTYPE       = 'CHAR'.
      LS_ALV_FILEDCAT-INTLEN        = '4'.
      APPEND LS_ALV_FILEDCAT TO P_GT_ALV_FILEDCAT.
      CLEAR:LS_ALV_FILEDCAT.

      LS_ALV_FILEDCAT-FIELDNAME     = 'MESSAGE_UPLOAD'.  "
      LS_ALV_FILEDCAT-COLTEXT       = 'MESSAGE_UPLOAD' .
      LS_ALV_FILEDCAT-DATATYPE      = 'SSTR'.
      LS_ALV_FILEDCAT-INTLEN        = '255'.
      APPEND LS_ALV_FILEDCAT TO P_GT_ALV_FILEDCAT.
      CLEAR:LS_ALV_FILEDCAT.


      LS_ALV_FILEDCAT-FIELDNAME     = 'ICON'.  "
      LS_ALV_FILEDCAT-COLTEXT       = 'ICON' .
      LS_ALV_FILEDCAT-INTTYPE       = 'CHAR'.
      LS_ALV_FILEDCAT-INTLEN        = '4'.
      IF P_FS_WOKSHEETNAME EQ 'Field'.
        LS_ALV_FILEDCAT-NO_OUT = 'X'.
      ENDIF.
      APPEND LS_ALV_FILEDCAT TO P_GT_ALV_FILEDCAT.
      CLEAR:LS_ALV_FILEDCAT.

      LS_ALV_FILEDCAT-FIELDNAME     = 'MESSAGE'.  "
      LS_ALV_FILEDCAT-COLTEXT       = 'MESSAGE' .
      LS_ALV_FILEDCAT-DATATYPE      = 'SSTR'.
      LS_ALV_FILEDCAT-INTLEN        = '255'.
      IF P_FS_WOKSHEETNAME EQ 'Field'.
        LS_ALV_FILEDCAT-NO_OUT = 'X'.
      ENDIF.
      APPEND LS_ALV_FILEDCAT TO P_GT_ALV_FILEDCAT.
      CLEAR:LS_ALV_FILEDCAT.

      LS_ALV_FILEDCAT-FIELDNAME     = 'SLBOX'.  "
      LS_ALV_FILEDCAT-COLTEXT       = 'CHOOSE' .
      LS_ALV_FILEDCAT-DATATYPE      = 'CHAR'.
      LS_ALV_FILEDCAT-INTLEN        = '1'.
      APPEND LS_ALV_FILEDCAT TO P_GT_ALV_FILEDCAT.
      CLEAR:LS_ALV_FILEDCAT.
    ENDAT.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_CREATE_INTERNAL_TABLE
*&---------------------------------------------------------------------*
*& text Set Data Into Internal Table From Excel
*&---------------------------------------------------------------------*
*&      --> LT_DFIES
*&      --> GT_ALV_FILEDCAT_DOMAIN
*&      --> <FS_GO_EXCEL_DATA_SHEET>
*&      --> <FS_GT_DOMAIN>
*&      <-- <FS_GS_DOMAIN>
*&---------------------------------------------------------------------*
FORM FRM_CREATE_INTERNAL_TABLE  TABLES   P_LT_DFIES STRUCTURE DFIES
                                         P_GT_ALV_FILEDCAT STRUCTURE GS_ALV_FILED
                                         P_FS_GO_EXCEL_DATA_SHEET TYPE STANDARD TABLE
                                         P_FS_GT_TAB TYPE STANDARD TABLE
                                  USING P_FS_WOKSHEETNAME
                                        P_FS_GS_EXCEL_KEY_VALUE
                                CHANGING P_FS_GS_TAB.

  DATA:LV_TABIX       TYPE SY-TABIX,
       LV_TABIX_AFTER TYPE SY-TABIX.
  DATA:LV_VALUE TYPE STRING.

  DATA:LV_MESSAGE TYPE STRING.
  DATA:LV_OBJECT_IN_SYSTEM TYPE C.

  IF P_CHECK EQ 'X'.
    READ TABLE <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_GO_EXCEL_DATA_SHEET_CHECK>) INDEX GV_EXCEL_REQUIRE_CHECK.
  ENDIF.
  "conver data to internal table
  LOOP AT <FS_GO_EXCEL_DATA_SHEET> ASSIGNING FIELD-SYMBOL(<FS_EXCEL_DATA>) FROM GV_EXCEL_DATA_FROM.
    CLEAR:P_FS_GS_TAB,LV_MESSAGE,LV_OBJECT_IN_SYSTEM.

    LOOP AT P_LT_DFIES ASSIGNING FIELD-SYMBOL(<FS_DFIES>) FROM GV_FIELD_BEGIN.

      LV_TABIX = SY-TABIX - 1.
      LV_TABIX_AFTER = SY-TABIX.

      READ TABLE P_GT_ALV_FILEDCAT ASSIGNING FIELD-SYMBOL(<FS_FIELDCAT>) INDEX LV_TABIX.
      IF SY-SUBRC EQ 0.

        ASSIGN COMPONENT LV_TABIX_AFTER OF STRUCTURE <FS_EXCEL_DATA> TO FIELD-SYMBOL(<FS_TABLE_VALUE>).
        IF <FS_TABLE_VALUE> IS ASSIGNED.

          "Check:object exist in system?
          IF LV_TABIX EQ 1 AND P_EXIST EQ 'X' AND ( P_FS_WOKSHEETNAME EQ 'Table' OR P_FS_WOKSHEETNAME EQ 'Element' OR P_FS_WOKSHEETNAME EQ 'Domain' ).
            PERFORM FRM_CHECK_OBJECT_IN_SYSTEM USING P_FS_WOKSHEETNAME <FS_TABLE_VALUE> CHANGING LV_OBJECT_IN_SYSTEM.
            IF LV_OBJECT_IN_SYSTEM EQ 'X'.
              PERFORM FRM_SET_DATA_INTO_FS USING 'EXIST' 'X' '' CHANGING P_FS_GS_TAB.
            ENDIF.
          ENDIF.

          IF <FS_TABLE_VALUE> IS NOT INITIAL.

            ASSIGN COMPONENT LV_TABIX_AFTER OF STRUCTURE P_FS_GS_EXCEL_KEY_VALUE TO FIELD-SYMBOL(<FS_KE_VALUE>).

            "set data from excel to field-symbol
            PERFORM FRM_SET_DATA_INTO_FS USING <FS_FIELDCAT>-FIELDNAME <FS_TABLE_VALUE> <FS_KE_VALUE> CHANGING P_FS_GS_TAB.
          ENDIF.

          IF P_CHECK EQ 'X'.

            CLEAR:LV_VALUE.
            PERFORM FRM_GET_DATA_FROM_FS USING LV_TABIX_AFTER <FS_GO_EXCEL_DATA_SHEET_CHECK> CHANGING LV_VALUE.
            IF LV_VALUE EQ 'X' AND <FS_TABLE_VALUE> IS INITIAL .

              IF LV_MESSAGE IS NOT INITIAL.
                LV_MESSAGE = LV_MESSAGE && ',' && P_FS_WOKSHEETNAME && '-' && <FS_FIELDCAT>-FIELDNAME.
              ELSE.
                LV_MESSAGE = TEXT-E16 && P_FS_WOKSHEETNAME && '-' && <FS_FIELDCAT>-FIELDNAME.
              ENDIF.

              PERFORM FRM_SET_DATA_INTO_FS USING 'ICON_UPLOAD'    ICON_RED_LIGHT '' CHANGING P_FS_GS_TAB.
              PERFORM FRM_SET_DATA_INTO_FS USING 'MESSAGE_UPLOAD' LV_MESSAGE     '' CHANGING P_FS_GS_TAB.

            ENDIF.
          ENDIF.

          UNASSIGN <FS_TABLE_VALUE>.
        ENDIF.

      ENDIF.


    ENDLOOP.

    IF P_CHECK IS INITIAL.
      CLEAR:LV_VALUE.
      PERFORM FRM_GET_DATA_FROM_FS USING 'ICON_UPLOAD' P_FS_GS_TAB CHANGING LV_VALUE.
      IF LV_VALUE IS INITIAL.
        PERFORM FRM_SET_DATA_INTO_FS USING 'ICON_UPLOAD'    ICON_YELLOW_LIGHT '' CHANGING P_FS_GS_TAB.
        PERFORM FRM_SET_DATA_INTO_FS USING 'MESSAGE_UPLOAD' TEXT-W01          '' CHANGING P_FS_GS_TAB."Not Check After Upload!
      ENDIF.
    ELSE.
      CLEAR:LV_VALUE.
      PERFORM FRM_GET_DATA_FROM_FS USING 'ICON_UPLOAD' P_FS_GS_TAB CHANGING LV_VALUE.
      IF LV_VALUE IS INITIAL.
        PERFORM FRM_SET_DATA_INTO_FS USING 'ICON_UPLOAD'    ICON_GREEN_LIGHT '' CHANGING P_FS_GS_TAB.
        PERFORM FRM_SET_DATA_INTO_FS USING 'MESSAGE_UPLOAD' TEXT-S04         '' CHANGING P_FS_GS_TAB."Upload check OK!
      ENDIF.
    ENDIF.

    "append to table
    APPEND P_FS_GS_TAB TO P_FS_GT_TAB.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_CREATE_CONTAINER_9100
*&---------------------------------------------------------------------*
*& text Create Container in Screen 9100
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_CREATE_CONTAINER_9100 .

  "create docking contain in 9100
  CREATE OBJECT GO_DOCKING_9100
    EXPORTING
      REPID                       = SY-REPID
      DYNNR                       = '9100'
*     side                        = cl_gui_docking_container=>dock_at_right      "ALV start from top-right
      SIDE                        = CL_GUI_DOCKING_CONTAINER=>DOCK_AT_TOP        "ALV start from top-left
      EXTENSION                   = 1000                                         "Width of screen
*     ratio                       = 95                                           "screen ratio. can't < 95
      STYLE                       = CL_GUI_CONTROL=>WS_CHILD                     " Draggable？
    EXCEPTIONS
      CNTL_ERROR                  = 1
      CNTL_SYSTEM_ERROR           = 2
      CREATE_ERROR                = 3
      LIFETIME_ERROR              = 4
      LIFETIME_DYNPRO_DYNPRO_LINK = 5
      OTHERS                      = 6.
  IF SY-SUBRC NE 0.
    GV_TYPE = 'E'.
    GV_MESSAGE = TEXT-E04.
    EXIT.
  ENDIF.

  "like this:
  "********************************     ********************************
  "*                              *     *               \              *
  "*                              *  -> *     alv1      \      alv2    *
  "*                              *     *               \              *
  "*        alv                   *  -> *------------------------------*
  "*                              *     *               \              *
  "*                              *  -> *     alv3      \      alv4    *
  "*                              *     *               \              *
  "********************************     ********************************
  CREATE OBJECT GO_SPLITTER01
    EXPORTING
      PARENT  = GO_DOCKING_9100
      ROWS    = 2
      COLUMNS = 2.

  CALL METHOD GO_SPLITTER01->SET_COLUMN_WIDTH
    EXPORTING
      ID    = 1
      WIDTH = 20.

  "1th alv
  CALL METHOD GO_SPLITTER01->GET_CONTAINER
    EXPORTING
      ROW       = 1
      COLUMN    = 1
    RECEIVING
      CONTAINER = GO_CONTAINER_TABLE.

  CALL METHOD GO_SPLITTER01->SET_COLUMN_WIDTH
    EXPORTING
      ID    = 2
      WIDTH = 30.

  "2th alv
  CALL METHOD GO_SPLITTER01->GET_CONTAINER
    EXPORTING
      ROW       = 1
      COLUMN    = 2
    RECEIVING
      CONTAINER = GO_CONTAINER_TABLE_FIELD.

  CALL METHOD GO_SPLITTER01->SET_COLUMN_WIDTH
    EXPORTING
      ID    = 3
      WIDTH = 30.

  "3th alv
  CALL METHOD GO_SPLITTER01->GET_CONTAINER
    EXPORTING
      ROW       = 2
      COLUMN    = 1
    RECEIVING
      CONTAINER = GO_CONTAINER_ELEMENT.

  CALL METHOD GO_SPLITTER01->SET_COLUMN_WIDTH
    EXPORTING
      ID    = 4
      WIDTH = 30.

  "4th alv
  CALL METHOD GO_SPLITTER01->GET_CONTAINER
    EXPORTING
      ROW       = 2
      COLUMN    = 2
    RECEIVING
      CONTAINER = GO_CONTAINER_DOMAIN.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_FIELDCAT_9100
*&---------------------------------------------------------------------*
*& text set fieldcat
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_FIELDCAT_9100 .


  DELETE GT_ALV_FILEDCAT_TABLE       WHERE FIELDNAME EQ 'SLBOX'.
  DELETE GT_ALV_FILEDCAT_TABLE_FIELD WHERE FIELDNAME EQ 'SLBOX'.
  DELETE GT_ALV_FILEDCAT_ELEMENT     WHERE FIELDNAME EQ 'SLBOX'.
  DELETE GT_ALV_FILEDCAT_DOMAIN      WHERE FIELDNAME EQ 'SLBOX'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_LAYOUT
*&---------------------------------------------------------------------*
*& text create Layout
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_LAYOUT .

  GS_LAYOUT_TABLE-SEL_MODE     = 'D'.
  GS_LAYOUT_TABLE-ZEBRA        = 'X'.
  GS_LAYOUT_TABLE-CWIDTH_OPT   = 'X'.

  GS_LAYOUT_TABLE_FIELD-SEL_MODE     = 'D'.
  GS_LAYOUT_TABLE_FIELD-ZEBRA        = 'X'.
  GS_LAYOUT_TABLE_FIELD-CWIDTH_OPT   = 'X'.

  GS_LAYOUT_ELEMENT-SEL_MODE     = 'D'.
  GS_LAYOUT_ELEMENT-ZEBRA        = 'X'.
  GS_LAYOUT_ELEMENT-CWIDTH_OPT   = 'X'.

  GS_LAYOUT_DOMAIN-SEL_MODE     = 'D'.
  GS_LAYOUT_DOMAIN-ZEBRA        = 'X'.
  GS_LAYOUT_DOMAIN-CWIDTH_OPT   = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*& FORM FRM_CREATE_GRID_9100
*&---------------------------------------------------------------------*
*& TEXT create Grid
*&---------------------------------------------------------------------*
*& -->  P1        TEXT
*& <--  P2        TEXT
*&---------------------------------------------------------------------*
FORM FRM_CREATE_GRID_9100 .

  PERFORM FRM_CREATE_OOALV_BY_CONTAINER USING  GO_GRID_TABLE                 GO_CONTAINER_TABLE.
  PERFORM FRM_CREATE_OOALV_BY_CONTAINER USING  GO_GRID_TABLE_FIELD           GO_CONTAINER_TABLE_FIELD.
  PERFORM FRM_CREATE_OOALV_BY_CONTAINER USING  GO_GRID_ELEMENT               GO_CONTAINER_ELEMENT    .
  PERFORM FRM_CREATE_OOALV_BY_CONTAINER USING  GO_GRID_DOMAIN                GO_CONTAINER_DOMAIN     .

ENDFORM.

*&---------------------------------------------------------------------*
*& Form FRM_CREATE_OOALV_BY_CONTAINER
*&---------------------------------------------------------------------*
*& text Create GRID of OOALV
*&---------------------------------------------------------------------*
*&      --> GO_GRID_TABLE
*&      --> GO_CONTAINER_TABLE
*&---------------------------------------------------------------------*
FORM FRM_CREATE_OOALV_BY_CONTAINER  USING    P_GO_GRID_TABLE TYPE REF TO CL_GUI_ALV_GRID
                                             P_GO_CONTAINER_TABLE TYPE REF TO CL_GUI_CONTAINER.

  CREATE OBJECT P_GO_GRID_TABLE
    EXPORTING
      I_PARENT          = P_GO_CONTAINER_TABLE
    EXCEPTIONS
      ERROR_CNTL_CREATE = 1
      ERROR_CNTL_INIT   = 2
      ERROR_CNTL_LINK   = 3
      ERROR_DP_CREATE   = 4
      OTHERS            = 5.
  IF SY-SUBRC <> 0.
    GV_TYPE = 'E'.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
    WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4 INTO GV_MESSAGE.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_ALV_BTN_EXCLUDE_9100
*&---------------------------------------------------------------------*
*& text Add Button To Oo Alv
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_ALV_BTN_EXCLUDE_9100 .

  DATA:LS_EXCLUDE   TYPE UI_FUNC.
  LS_EXCLUDE = CL_GUI_ALV_GRID=>MC_FC_LOC_INSERT_ROW.
  APPEND LS_EXCLUDE TO GT_EXCLUDE_TABLE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_ALV_DISPLAY_9100
*&---------------------------------------------------------------------*
*& text Show alv
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_ALV_DISPLAY_9100 .

  PERFORM FRM_SHOW_ALV TABLES GT_EXCLUDE_TABLE       <FS_GT_TABLE>       GT_ALV_FILEDCAT_TABLE       USING GS_VARIANT_TABLE       GS_LAYOUT_TABLE       GO_GRID_TABLE.
  PERFORM FRM_SHOW_ALV TABLES GT_EXCLUDE_TABLE_FIELD <FS_GT_TABLE_FIELD> GT_ALV_FILEDCAT_TABLE_FIELD USING GS_VARIANT_TABLE_FIELD GS_LAYOUT_TABLE_FIELD GO_GRID_TABLE_FIELD.
  PERFORM FRM_SHOW_ALV TABLES GT_EXCLUDE_ELEMENT     <FS_GT_ELEMENT>     GT_ALV_FILEDCAT_ELEMENT     USING GS_VARIANT_ELEMENT     GS_LAYOUT_ELEMENT     GO_GRID_ELEMENT.
  PERFORM FRM_SHOW_ALV TABLES GT_EXCLUDE_DOMAIN      <FS_GT_DOMAIN>      GT_ALV_FILEDCAT_DOMAIN      USING GS_VARIANT_DOMAIN      GS_LAYOUT_DOMAIN      GO_GRID_DOMAIN.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_ALV_EVENT_9100
*&---------------------------------------------------------------------*
*& text add event for 9100
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_ALV_EVENT_9100 .

  PERFORM FRM_HANDLD_EVENT USING GO_GRID_TABLE '1'.
  PERFORM FRM_HANDLD_EVENT USING GO_GRID_TABLE_FIELD '2'.
  PERFORM FRM_HANDLD_EVENT USING GO_GRID_ELEMENT '3'.
  PERFORM FRM_HANDLD_EVENT USING GO_GRID_DOMAIN '4'.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form FRM_HANDLD_EVENT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GO_GRID_TABLE
*&      <-- P_TYPE : 1:TABLE,2:TABLE_FIELD 3:ELEMENT,4:DOMAIN
*&
*&---------------------------------------------------------------------*
FORM FRM_HANDLD_EVENT  USING    P_GO_GRID TYPE REF TO CL_GUI_ALV_GRID P_TYPE.

  CREATE OBJECT GO_EVENT_RECEIVER.
  " Registered Events Handle Method
  SET HANDLER GO_EVENT_RECEIVER->HANDLE_HOTSPOT_CLICK              FOR P_GO_GRID.
  SET HANDLER GO_EVENT_RECEIVER->HANDLE_COMMAND                    FOR P_GO_GRID.

  CASE P_TYPE.
    WHEN '1'.
      SET HANDLER GO_EVENT_RECEIVER->HANDLE_TOOLBAR_TABLE               FOR P_GO_GRID.
      SET HANDLER GO_EVENT_RECEIVER->HANDLE_DOUBLE_CLICK_TABLE          FOR P_GO_GRID.
    WHEN '2'.
      "SET HANDLER GO_EVENT_RECEIVER->HANDLE_TOOLBAR_TABLE_FIELD         FOR P_GO_GRID.
      SET HANDLER GO_EVENT_RECEIVER->HANDLE_DOUBLE_CLICK_TABLE_FIEL     FOR P_GO_GRID.
    WHEN '3'.
      SET HANDLER GO_EVENT_RECEIVER->HANDLE_TOOLBAR_ELEMENT             FOR P_GO_GRID.
      SET HANDLER GO_EVENT_RECEIVER->HANDLE_DOUBLE_CLICK_ELEMENT        FOR P_GO_GRID.
    WHEN '4'.
      SET HANDLER GO_EVENT_RECEIVER->HANDLE_TOOLBAR_DOMAIN              FOR P_GO_GRID.
      SET HANDLER GO_EVENT_RECEIVER->HANDLE_DOUBLE_CLICK_DOMAIN         FOR P_GO_GRID.
    WHEN OTHERS.
  ENDCASE.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SHOW_ALV
*&---------------------------------------------------------------------*
*& text show OO ALV
*&---------------------------------------------------------------------*
*&      --> GT_EXCLUDE_TABLE
*&      --> <FS_GT_TABLE>
*&      --> GT_ALV_FILEDCAT_TABLE
*&      --> GS_VARIANT_TABLE
*&      --> GS_LAYOUT_TABLE
*&---------------------------------------------------------------------*
FORM FRM_SHOW_ALV  TABLES   P_GT_EXCLUDE
                            P_FS_OUTPUT
                            P_GT_ALV_FILEDCAT
                   USING    P_GS_VARIANT
                            P_GS_LAYOUT
                            P_GO_GRID TYPE REF TO CL_GUI_ALV_GRID.

  CALL METHOD P_GO_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      IS_VARIANT                    = P_GS_VARIANT
      I_SAVE                        = 'A'
      IS_LAYOUT                     = P_GS_LAYOUT
      IT_TOOLBAR_EXCLUDING          = P_GT_EXCLUDE[]
    CHANGING
      IT_OUTTAB                     = P_FS_OUTPUT[]
      IT_FIELDCATALOG               = P_GT_ALV_FILEDCAT[]
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1
      PROGRAM_ERROR                 = 2
      TOO_MANY_LINES                = 3
      OTHERS                        = 4.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_ADD_BUTTON
*&---------------------------------------------------------------------*
*& text add button for ooalv
*&---------------------------------------------------------------------*
*&      --> P_MT_TOOLBAR
*&      --> P_FUNCTION
*&      --> P_ICON
*&      --> P_QUICKINFO
*&      --> P_BUTN_TYPE
*&      --> P_DISABLED
*&      --> P_TEXT
*&---------------------------------------------------------------------*
FORM FRM_ADD_BUTTON  TABLES   P_MT_TOOLBAR STRUCTURE STB_BUTTON
                     USING    P_FUNCTION
                              P_ICON
                              P_QUICKINFO
                              P_BUTN_TYPE
                              P_DISABLED
                              P_TEXT.

  DATA: LS_TOOLBAR TYPE STB_BUTTON.

  CLEAR: LS_TOOLBAR.
  LS_TOOLBAR-FUNCTION  = P_FUNCTION.          " Function Code
  LS_TOOLBAR-ICON      = P_ICON.            " Icon
  LS_TOOLBAR-QUICKINFO = P_QUICKINFO.        " Quick Info
  LS_TOOLBAR-BUTN_TYPE = P_BUTN_TYPE.        " 0:Normal Button
  LS_TOOLBAR-DISABLED  = ''.                  " '':Enable ,'X':disabled
  LS_TOOLBAR-TEXT      = P_TEXT.                  " Text Showed In Button
  APPEND LS_TOOLBAR TO P_MT_TOOLBAR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SHOW_ALL_TABLE_FILED
*&---------------------------------------------------------------------*
*& text Show All Field In Table
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_SHOW_ALL_TABLE_FILED .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SHOW_ALL_ELEMENT
*&---------------------------------------------------------------------*
*& text Show All Element
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_SHOW_ALL_ELEMENT .
  "CLEAR:
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SHOW_ALL_DOMAIN
*&---------------------------------------------------------------------*
*& text Show All Dimain
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_SHOW_ALL_DOMAIN .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_CREATE_TABLE
*&---------------------------------------------------------------------*
*& text Create Table
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_CREATE_TABLE CHANGING P_LV_TYPE P_LV_MESSAGE..


  DATA: LT_NEW_OBJECT         TYPE COMT_GOX_DEF_HEADER,
        LT_OLD_OBJECT         LIKE LT_NEW_OBJECT,
        LV_DOMA_NAME          TYPE CHAR32,
        LV_DEVCLASS           TYPE DEVCLASS,
        LV_REQUEST_WB         TYPE TRKORR,
        LS_NEW_OBJECT         LIKE LINE OF LT_NEW_OBJECT,
        LS_NEW_OBJECT_DETAILS TYPE LINE OF COMT_GOX_TABLE_ENTRY_FIELDS.

  DATA ET_BAPIRETURN         TYPE BAPIRETTAB.
  DATA ET_TRANSPORT          TYPE COMT_GOX_TRANS_OBJECT.
  DATA LV_GOTSTATE           TYPE DDGOTSTATE.
  DATA:LV_ICON               TYPE CHAR4,
       LV_MESSAGE            TYPE STRING.
  DATA:LV_TITLE              TYPE STRING.
  DATA:LT_ROW                TYPE  LVC_T_ROID.
  DATA:LS_STABLE             TYPE LVC_S_STBL.
  DATA:LS_TPARA_WA           TYPE TPARA.
  DATA:LV_TABNAME_PRE        TYPE STRING,
       LV_TABNAME_AFTER      TYPE STRING,
       LV_FIRST              TYPE C.

  DATA:LS_DD02V LIKE DD02V,
       LS_DD09L LIKE DD09L,
       LS_DD09V LIKE DD09V.
  DATA:LV_PARENT_GUID TYPE COMS_GOX_DEF_HEADER-KEY_GUID.

  LS_STABLE-ROW = 'X'.
  LS_STABLE-COL = 'X'.

  CALL METHOD GO_GRID_TABLE->GET_SELECTED_ROWS( IMPORTING ET_ROW_NO = LT_ROW ).


  LOOP AT LT_ROW ASSIGNING FIELD-SYMBOL(<FS_ROW>).
    READ TABLE <FS_GT_TABLE> ASSIGNING FIELD-SYMBOL(<FS_GS_TABLE>) INDEX <FS_ROW>-ROW_ID.
    IF SY-SUBRC EQ 0.
      CLEAR:ET_BAPIRETURN,
            ET_TRANSPORT,
            LV_ICON,
            LV_MESSAGE,
            LT_NEW_OBJECT,
            LS_NEW_OBJECT,
            LS_TPARA_WA
            .
      MOVE-CORRESPONDING <FS_GS_TABLE> TO LS_DD02V.
      MOVE-CORRESPONDING <FS_GS_TABLE> TO LS_DD09L.
      MOVE-CORRESPONDING <FS_GS_TABLE> TO LS_DD09V.
      LV_TITLE = TEXT-T09 && LS_DD02V-TABNAME."Creating Table:
      PERFORM FRM_SET_INDICATOR USING LV_TITLE.

      TRY.
          DATA(LV_GUID) = CL_SYSTEM_UUID=>IF_SYSTEM_UUID_STATIC~CREATE_UUID_C32( ).
        CATCH CX_UUID_ERROR .
      ENDTRY.
      LV_PARENT_GUID = LV_GUID.

      LS_NEW_OBJECT = VALUE #( OBJECT_TYPE = 'TABLE'  OBJECT_NAME = LS_DD02V-TABNAME KEY_GUID = LV_GUID ) .

      "Set Data Into LS_NEW_OBJECT-DETAILS.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'TABCLASS'    LS_DD02V-TABCLASS.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'TABKAT'      LS_DD09V-TABKAT.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'TABART'      LS_DD09V-TABART.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'PUFFERUNG'   LS_DD09V-PUFFERUNG." something problem
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'CONTFLAG'    LS_DD02V-CONTFLAG.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'MAINFLAG'    LS_DD02V-MAINFLAG.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'BUFFALLOW'   LS_DD09V-BUFALLOW.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'SCHFELDANZ'  LS_DD09V-SCHFELDANZ.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'PROTOKOLL'   LS_DD09V-PROTOKOLL.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'ROWORCOLST'  LS_DD09V-ROWORCOLST.

      PERFORM FRM_SET_DOMAIN_DESC_WITH_LA TABLES LS_NEW_OBJECT-OBJECT_TEXT USING LS_DD02V-DDLANGUAGE LS_DD02V-DDTEXT.
      APPEND LS_NEW_OBJECT TO LT_NEW_OBJECT.

      LOOP AT GT_DD03L ASSIGNING FIELD-SYMBOL(<FS_DD03L>) WHERE TABNAME EQ LS_DD02V-TABNAME.

        CLEAR:LS_NEW_OBJECT.

        TRY.
            LV_GUID = CL_SYSTEM_UUID=>IF_SYSTEM_UUID_STATIC~CREATE_UUID_C32(
                   ).
          CATCH CX_UUID_ERROR .
        ENDTRY.
        LS_NEW_OBJECT = VALUE #( OBJECT_TYPE = 'TABLE_FIELD'  OBJECT_NAME = <FS_DD03L>-FIELDNAME KEY_GUID = LV_GUID ) .

        LS_NEW_OBJECT-KEY_GUID           = LV_GUID.
        LS_NEW_OBJECT-PARENT_KEY         = LV_PARENT_GUID.
        LS_NEW_OBJECT-OBJECT_NAME        = <FS_DD03L>-FIELDNAME. "FIELD NAME
        LS_NEW_OBJECT-POSITION           = <FS_DD03L>-POSITION. "SY-TABIX


        PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'FIELDNAME'     <FS_DD03L>-FIELDNAME.
        PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'AS4LOCAL'      <FS_DD03L>-AS4LOCAL.
        PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'POSITION'      <FS_DD03L>-POSITION.
        PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'KEYFLAG'       <FS_DD03L>-KEYFLAG.
        PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'NOTNULL'       <FS_DD03L>-NOTNULL.
        PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'ROLLNAME'      <FS_DD03L>-ROLLNAME.
        PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'COMPTYPE'      <FS_DD03L>-COMPTYPE.

        APPEND  LS_NEW_OBJECT TO LT_NEW_OBJECT.

      ENDLOOP.

      IF LV_ICON NE ICON_RED_LIGHT.
        PERFORM FRM_GOX_GEN_TABLE_STD TABLES LT_NEW_OBJECT LT_OLD_OBJECT ET_BAPIRETURN ET_TRANSPORT USING LS_DD02V-TABNAME CHANGING P_LV_TYPE LV_ICON P_LV_MESSAGE.
      ENDIF.

      IF LV_ICON NE ICON_RED_LIGHT.
        PERFORM FRM_DDIF_TABL_PUT USING LS_DD02V CHANGING P_LV_TYPE LV_ICON P_LV_MESSAGE.
      ENDIF.

      IF LV_ICON NE ICON_RED_LIGHT.

        "Active Table
        CALL FUNCTION 'DDIF_TABL_ACTIVATE'
          EXPORTING
            NAME     = LS_DD02V-TABNAME
            AUTH_CHK = ' '.
        IF SY-SUBRC NE 0.
          P_LV_TYPE    = 'E'.
          LV_ICON      = ICON_RED_LIGHT.
          P_LV_MESSAGE = TEXT-E13."Error in DDIF_DTEL_ACTIVATE
        ELSE.
          LV_ICON      = ICON_GREEN_LIGHT.
          P_LV_MESSAGE = TEXT-S01."Successfully！
        ENDIF.
      ENDIF.

      LV_MESSAGE = P_LV_MESSAGE.
      PERFORM FRM_SET_DATA_INTO_FS USING 'ICON'    LV_ICON    '' CHANGING <FS_GS_TABLE>.
      PERFORM FRM_SET_DATA_INTO_FS USING 'MESSAGE' LV_MESSAGE '' CHANGING <FS_GS_TABLE>.
    ENDIF.
  ENDLOOP.

  IF P_LV_TYPE NE 'E'.
    P_LV_TYPE = 'S'.
  ENDIF.
  PERFORM FRM_REFRESH_TABLE_DISPLAY USING GO_GRID_TABLE  LS_STABLE.
  IF P_EXIST EQ 'X'.
    PERFORM FRM_GET_DD02V.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_CREATE_ELEMENT
*&---------------------------------------------------------------------*
*& text Create Element
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_CREATE_ELEMENT CHANGING P_LV_TYPE P_LV_MESSAGE.

  DATA: LT_NEW_OBJECT         TYPE COMT_GOX_DEF_HEADER,
        LT_OLD_OBJECT         LIKE LT_NEW_OBJECT,
        LV_DOMA_NAME          TYPE CHAR32,
        LV_DEVCLASS           TYPE DEVCLASS,
        LV_REQUEST_WB         TYPE TRKORR,
        LS_NEW_OBJECT         LIKE LINE OF LT_NEW_OBJECT,
        LS_NEW_OBJECT_DETAILS TYPE LINE OF COMT_GOX_TABLE_ENTRY_FIELDS.

  DATA:LT_DD04V TYPE TABLE OF DD04V,
       LS_DD04V LIKE LINE OF LT_DD04V.

  DATA ET_BAPIRETURN  TYPE BAPIRETTAB.
  DATA ET_TRANSPORT   TYPE COMT_GOX_TRANS_OBJECT.
  DATA LV_GOTSTATE    TYPE DDGOTSTATE.
  DATA:LV_ICON        TYPE CHAR4,
       LV_MESSAGE     TYPE STRING.
  DATA:LV_TITLE       TYPE STRING.
  DATA:LT_ROW         TYPE  LVC_T_ROID.
  DATA:LS_STABLE      TYPE LVC_S_STBL.
  DATA:LS_TPARA_WA    TYPE TPARA.
  LS_STABLE-ROW = 'X'.
  LS_STABLE-COL = 'X'.

  CALL METHOD GO_GRID_ELEMENT->GET_SELECTED_ROWS( IMPORTING ET_ROW_NO = LT_ROW ).


  LOOP AT LT_ROW ASSIGNING FIELD-SYMBOL(<FS_ROW>).
    READ TABLE <FS_GT_ELEMENT> ASSIGNING FIELD-SYMBOL(<FS_GS_ELEMENT>) INDEX <FS_ROW>-ROW_ID.
    IF SY-SUBRC EQ 0.

      CLEAR:LT_DD04V,
            LS_DD04V,
            ET_BAPIRETURN,
            ET_TRANSPORT,
            LV_ICON,
            LV_MESSAGE,
            LT_NEW_OBJECT,
            LS_NEW_OBJECT,
            LS_TPARA_WA
            .
      MOVE-CORRESPONDING <FS_GS_ELEMENT> TO LS_DD04V.
      LV_TITLE = TEXT-T08 && LS_DD04V-ROLLNAME."Creating Element:
      PERFORM FRM_SET_INDICATOR USING LV_TITLE.

      TRY.
          DATA(LV_GUID) = CL_SYSTEM_UUID=>IF_SYSTEM_UUID_STATIC~CREATE_UUID_C32( ).
        CATCH CX_UUID_ERROR .
      ENDTRY.

      LS_NEW_OBJECT = VALUE #( OBJECT_TYPE = 'ELEMENT'  OBJECT_NAME = LS_DD04V-ROLLNAME KEY_GUID = LV_GUID ) .

      "Set Data Into LS_NEW_OBJECT-DETAILS.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'DESCRIPTION'  LS_DD04V-DDTEXT.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'DOMNAME'      LS_DD04V-DOMNAME.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'DDLANGUAGE'   LS_DD04V-DDLANGUAGE.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'ROUTPUTLEN'   LS_DD04V-ROUTPUTLEN.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'REPTEXT'      LS_DD04V-REPTEXT.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'HEADLEN'      LS_DD04V-HEADLEN.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'SCRTEXT_S'    LS_DD04V-SCRTEXT_S.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'SCRLEN1'      LS_DD04V-SCRLEN1.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'SCRTEXT_M'    LS_DD04V-SCRTEXT_M.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'SCRLEN2'      LS_DD04V-SCRLEN2.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'SCRTEXT_L'    LS_DD04V-SCRTEXT_L.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'SCRLEN3'      LS_DD04V-SCRLEN3.

      PERFORM FRM_SET_DOMAIN_DESC_WITH_LA TABLES LS_NEW_OBJECT-OBJECT_TEXT USING LS_DD04V-DDLANGUAGE LS_DD04V-DDTEXT.

      APPEND LS_NEW_OBJECT TO LT_NEW_OBJECT.

      IF LV_ICON NE ICON_RED_LIGHT.
        PERFORM FRM_GOX_GEN_DTEL_STD TABLES LT_NEW_OBJECT LT_OLD_OBJECT ET_BAPIRETURN ET_TRANSPORT USING LS_DD04V-DOMNAME CHANGING P_LV_TYPE LV_ICON P_LV_MESSAGE.
      ENDIF.

*      IF LV_ICON NE ICON_RED_LIGHT.
*        PERFORM FRM_DDIF_DTEL_GET USING LS_DD04V LV_GOTSTATE LS_TPARA_WA CHANGING P_LV_TYPE LV_ICON P_LV_MESSAGE.
*      ENDIF.

      IF LV_ICON NE ICON_RED_LIGHT.
        PERFORM FRM_DDIF_DTEL_PUT USING LS_DD04V CHANGING P_LV_TYPE LV_ICON P_LV_MESSAGE.
      ENDIF.


      IF LV_ICON NE ICON_RED_LIGHT.
        "Active Object

        CALL FUNCTION 'DDIF_DTEL_ACTIVATE'
          EXPORTING
            name     = LS_DD04V-ROLLNAME
            auth_chk = ' '.

        IF SY-SUBRC NE 0.
          P_LV_TYPE    = 'E'.
          LV_ICON      = ICON_RED_LIGHT.
          P_LV_MESSAGE = TEXT-E13."Error in DDIF_DTEL_ACTIVATE
        ELSE.
          LV_ICON      = ICON_GREEN_LIGHT.
          P_LV_MESSAGE = TEXT-S01."Successfully！
        ENDIF.
      ENDIF.

      LV_MESSAGE = P_LV_MESSAGE.
      PERFORM FRM_SET_DATA_INTO_FS USING 'ICON'    LV_ICON    '' CHANGING <FS_GS_ELEMENT>.
      PERFORM FRM_SET_DATA_INTO_FS USING 'MESSAGE' LV_MESSAGE '' CHANGING <FS_GS_ELEMENT>.
    ENDIF.
  ENDLOOP.

  IF P_LV_TYPE NE 'E'.
    P_LV_TYPE = 'S'.
  ENDIF.
  PERFORM FRM_REFRESH_TABLE_DISPLAY USING GO_GRID_ELEMENT  LS_STABLE.

  IF P_EXIST EQ 'X'.
    PERFORM FRM_GET_DD04L.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_CREATE_DOMAIN
*&---------------------------------------------------------------------*
*& text Create Domain
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_CREATE_DOMAIN CHANGING P_LV_TYPE
                                P_LV_MESSAGE.

  DATA: LT_NEW_OBJECT         TYPE COMT_GOX_DEF_HEADER,
        LT_OLD_OBJECT         LIKE LT_NEW_OBJECT,
        LV_DOMA_NAME          TYPE CHAR32,
        LV_DEVCLASS           TYPE DEVCLASS,
        LV_REQUEST_WB         TYPE TRKORR,
        LS_NEW_OBJECT         LIKE LINE OF LT_NEW_OBJECT,
        LS_NEW_OBJECT_DETAILS TYPE LINE OF COMT_GOX_TABLE_ENTRY_FIELDS.

  DATA:LT_DD01V TYPE TABLE OF DD01V,
       LS_DD01V LIKE LINE OF LT_DD01V,
       LT_DD07V TYPE TABLE OF DD07V,
       LS_DD07V LIKE LINE OF LT_DD07V.

  DATA ET_BAPIRETURN  TYPE BAPIRETTAB.
  DATA ET_TRANSPORT   TYPE COMT_GOX_TRANS_OBJECT.
  DATA LV_GOTSTATE    TYPE DDGOTSTATE.
  DATA:LV_ICON    TYPE CHAR4,
       LV_MESSAGE TYPE STRING.
  DATA:LV_TITLE   TYPE STRING.
  DATA:LT_ROW     TYPE  LVC_T_ROID.
  DATA:LS_STABLE TYPE LVC_S_STBL.

  LS_STABLE-ROW = 'X'.
  LS_STABLE-COL = 'X'.

  CALL METHOD GO_GRID_DOMAIN->GET_SELECTED_ROWS( IMPORTING ET_ROW_NO = LT_ROW ).


  LOOP AT LT_ROW ASSIGNING FIELD-SYMBOL(<FS_ROW>).
    READ TABLE <FS_GT_DOMAIN> ASSIGNING FIELD-SYMBOL(<FS_GS_DOMAIN>) INDEX <FS_ROW>-ROW_ID.
    IF SY-SUBRC EQ 0.

      CLEAR:LS_DD01V,
            LT_DD07V,
            LS_DD07V,
            ET_BAPIRETURN,
            ET_TRANSPORT,
            LV_ICON,
            LV_MESSAGE,
            LT_NEW_OBJECT,
            LS_NEW_OBJECT
            .
      MOVE-CORRESPONDING <FS_GS_DOMAIN> TO LS_DD01V.
      LV_TITLE = TEXT-T08 && LS_DD01V-DOMNAME."Creating Domname:
      PERFORM FRM_SET_INDICATOR USING LV_TITLE.

      PERFORM FRM_GET_DD07 TABLES LT_DD07V USING LS_DD01V-DOMNAME CHANGING LS_DD01V-VALEXI.


      TRY.
          DATA(LV_GUID) = CL_SYSTEM_UUID=>IF_SYSTEM_UUID_STATIC~CREATE_UUID_C32( ).
        CATCH CX_UUID_ERROR .
      ENDTRY.

      LS_NEW_OBJECT = VALUE #( OBJECT_TYPE = 'DOMA'  OBJECT_NAME = LS_DD01V-DOMNAME KEY_GUID = LV_GUID ) .

      "Set Data Into LS_NEW_OBJECT-DETAILS.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'DDLANGUAGE'     LS_DD01V-DDLANGUAGE.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'DATATYPE'       LS_DD01V-DATATYPE.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'LENG'           LS_DD01V-LENG.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'OUTPUTLEN'      LS_DD01V-OUTPUTLEN.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'DECIMALS'       LS_DD01V-DECIMALS.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'LOWERCASE'      LS_DD01V-LOWERCASE.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'SIGNFLAG'       LS_DD01V-SIGNFLAG.
      PERFORM FRM_SET_OBJECT_DETAILS TABLES LS_NEW_OBJECT-DETAILS USING 'VALEXI'         LS_DD01V-VALEXI.


      PERFORM FRM_SET_DOMAIN_DESC_WITH_LA TABLES LS_NEW_OBJECT-OBJECT_TEXT USING LS_DD01V-DDLANGUAGE LS_DD01V-DDTEXT.

      APPEND LS_NEW_OBJECT TO LT_NEW_OBJECT.

      IF LV_ICON NE ICON_RED_LIGHT.
        PERFORM FRM_GOX_GEN_DOMA_STD TABLES LT_NEW_OBJECT LT_OLD_OBJECT ET_BAPIRETURN ET_TRANSPORT USING LS_DD01V-DOMNAME CHANGING P_LV_TYPE LV_ICON P_LV_MESSAGE.
      ENDIF.

*      IF LV_ICON NE ICON_RED_LIGHT.
*        PERFORM FRM_DDIF_DOMA_GET TABLES LT_DD07V USING LS_DD01V LV_GOTSTATE CHANGING P_LV_TYPE LV_ICON P_LV_MESSAGE.
*      ENDIF.

      IF LV_ICON NE ICON_RED_LIGHT .
        PERFORM FRM_DDIF_DOMA_PUT TABLES LT_DD07V USING LS_DD01V CHANGING P_LV_TYPE LV_ICON P_LV_MESSAGE.
      ENDIF.

      IF LV_ICON NE ICON_RED_LIGHT.
        "Active Object
        CALL FUNCTION 'DDIF_DOMA_ACTIVATE'
          EXPORTING
            NAME     = LS_DD01V-DOMNAME
            AUTH_CHK = ' '.
        IF SY-SUBRC NE 0.
          P_LV_TYPE    = 'E'.
          LV_ICON      = ICON_RED_LIGHT.
          P_LV_MESSAGE = TEXT-E12."Error in DDIF_DOMA_ACTIVATE
        ELSE.
          LV_ICON      = ICON_GREEN_LIGHT.
          P_LV_MESSAGE = TEXT-S01."Successfully！
        ENDIF.
      ENDIF.

      LV_MESSAGE = P_LV_MESSAGE.
      PERFORM FRM_SET_DATA_INTO_FS USING 'ICON'    LV_ICON    '' CHANGING <FS_GS_DOMAIN>.
      PERFORM FRM_SET_DATA_INTO_FS USING 'MESSAGE' LV_MESSAGE '' CHANGING <FS_GS_DOMAIN>.
    ENDIF.
  ENDLOOP.
  IF P_LV_TYPE NE 'E'.
    P_LV_TYPE = 'S'.
  ENDIF.

  PERFORM FRM_REFRESH_TABLE_DISPLAY USING GO_GRID_DOMAIN  LS_STABLE.
  IF P_EXIST EQ 'X'.
    PERFORM FRM_GET_DD01V.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SHOW_ALL_ERROR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_SHOW_ALL_ERROR .

  DATA:LT_ERROR_TABLE TYPE TABLE OF TY_ERROR_TABLE,
       LS_ERROR_TABLE LIKE LINE  OF LT_ERROR_TABLE.

  PERFORM FRM_GET_ERROR_TABLE TABLES LT_ERROR_TABLE.
  IF P_EXIST EQ 'X'.
    PERFORM FRM_GET_OBJECT_IN_SYSTEM TABLES LT_ERROR_TABLE.
  ENDIF.

  PERFORM FRM_SHOW_SALV TABLES LT_ERROR_TABLE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_CHANGE_FIELDNAME
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LR_COLUMNS
*&      --> P_
*&---------------------------------------------------------------------*
FORM FRM_CHANGE_FIELDNAME  USING    P_LR_COLUMNS TYPE REF TO CL_SALV_COLUMNS_TABLE
                                    P_FIELDNAME
                                    P_FIELDESC
   .

  DATA:LR_COLUMN    TYPE REF TO CL_SALV_COLUMN.
  DATA:LV_SCRTEXT_L TYPE SCRTEXT_L,
       LV_SCRTEXT_M TYPE SCRTEXT_M,
       LV_SCRTEXT_S TYPE SCRTEXT_S.

  LV_SCRTEXT_L = LV_SCRTEXT_M = LV_SCRTEXT_S = P_FIELDESC.
  TRY.
      LR_COLUMN =  P_LR_COLUMNS->GET_COLUMN( COLUMNNAME = P_FIELDNAME   ).
    CATCH CX_SALV_NOT_FOUND .
  ENDTRY.
  "CALL THE BELOW METHOD TO CHANGE THE COLUMN ANME
  LR_COLUMN->SET_LONG_TEXT( VALUE = LV_SCRTEXT_L   ).
  LR_COLUMN->SET_MEDIUM_TEXT( VALUE = LV_SCRTEXT_M   ).
  LR_COLUMN->SET_SHORT_TEXT( VALUE = LV_SCRTEXT_S   ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_CREATE_ALL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_CREATE_ALL .

  DATA:LV_TYPE    TYPE C,
       LV_MESSAGE TYPE STRING.
  DATA:LV_BUTTON TYPE C.


  PERFORM FRM_CHECK_BEFORE_CREATE_ALL CHANGING LV_TYPE LV_MESSAGE.
  IF LV_TYPE EQ 'E'.
    MESSAGE LV_MESSAGE TYPE 'I' DISPLAY LIKE '  E'.
  ELSE.
    PERFORM FRM_GET_BUTTON USING TEXT-T95 CHANGING LV_BUTTON."CREATE CONFIRM!
    IF LV_BUTTON EQ 1.

      PERFORM FRM_ALL_SET_SELECT_ROW.

      "IF LV_TYPE NE 'E' .
        PERFORM FRM_CREATE_DOMAIN CHANGING LV_TYPE LV_MESSAGE.
      "ENDIF.

      "IF LV_TYPE NE 'E'.
        PERFORM FRM_CREATE_ELEMENT CHANGING LV_TYPE LV_MESSAGE.
      "ENDIF.

      "IF LV_TYPE NE 'E'.
        PERFORM FRM_CREATE_TABLE   CHANGING LV_TYPE LV_MESSAGE.
      "ENDIF.

    ENDIF.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SET_FILTER_FOR_OOALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_SET_FILTER_FOR_OOALV .

  DATA:LT_FILTER TYPE TABLE OF LVC_S_FILT,
       LS_FILTER LIKE LINE OF LT_FILTER.
  DATA:LR_FIELDNAME TYPE RANGE OF DD04V-ROLLNAME,
       LS_FIELDNAME LIKE LINE OF LR_FIELDNAME.

  DATA:LV_VALUE  TYPE STRING.
  DATA:LV_WHERE  TYPE STRING.

  "Set Filter For Table Field
  READ TABLE <FS_GT_TABLE> ASSIGNING FIELD-SYMBOL(<FS_GS_TABLE>) INDEX 1.
  IF SY-SUBRC EQ 0.
    PERFORM FRM_GET_DATA_FROM_FS USING 'TABNAME' <FS_GS_TABLE> CHANGING LV_VALUE.
    LT_FILTER = VALUE #( ( FIELDNAME = 'TABNAME' SIGN = 'I' OPTION = 'EQ' LOW = LV_VALUE ) ).
    PERFORM FRM_SET_FILTER TABLES LT_FILTER USING GO_GRID_TABLE_FIELD .
    LV_WHERE = 'TABNAME EQ ''' && LV_VALUE && ''''.
  ENDIF.

  "Set Filter For Element
  CLEAR:LT_FILTER.
  LOOP AT <FS_GT_TABLE_FIELD> ASSIGNING FIELD-SYMBOL(<FS_GS_TABLE_FIELD>) WHERE (LV_WHERE).
    PERFORM FRM_GET_DATA_FROM_FS USING 'FIELDNAME' <FS_GS_TABLE> CHANGING LV_VALUE.
    LS_FILTER = VALUE #( FIELDNAME = 'ROLLNAME' SIGN = 'I' OPTION = 'EQ' LOW = LV_VALUE ).
    APPEND LS_FILTER TO LT_FILTER.

    LS_FIELDNAME = VALUE #( SIGN = 'I' OPTION = 'EQ' LOW = LV_VALUE ).
    APPEND LS_FIELDNAME TO LR_FIELDNAME.

    AT LAST.
      PERFORM FRM_SET_FILTER TABLES LT_FILTER USING GO_GRID_ELEMENT .
    ENDAT.
  ENDLOOP.

  "Set Filter For Domain
  CLEAR:LT_FILTER,LV_WHERE.
  LV_WHERE = 'DOMNAME IN LR_FIELDNAME'.
  LOOP AT <FS_GT_ELEMENT> ASSIGNING FIELD-SYMBOL(<FS_GS_ELEMENT>) WHERE (LV_WHERE).
    PERFORM FRM_GET_DATA_FROM_FS USING 'FIELDNAME' <FS_GS_TABLE> CHANGING LV_VALUE.
    LS_FILTER = VALUE #( FIELDNAME = 'DOMNAME' SIGN = 'I' OPTION = 'EQ' LOW = LV_VALUE ).
    APPEND LS_FILTER TO LT_FILTER.

    AT LAST.
      PERFORM FRM_SET_FILTER TABLES LT_FILTER USING GO_GRID_DOMAIN .
    ENDAT.
  ENDLOOP.

  DATA: LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = 'X'.
  LS_STABLE-COL = 'X'.


  PERFORM FRM_REFRESH_TABLE_DISPLAY USING GO_GRID_TABLE_FIELD LS_STABLE.
  PERFORM FRM_REFRESH_TABLE_DISPLAY USING GO_GRID_ELEMENT LS_STABLE.
  PERFORM FRM_REFRESH_TABLE_DISPLAY USING GO_GRID_DOMAIN LS_STABLE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SET_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_FILTER
*&      --> GO_GRID_TABLE
*&---------------------------------------------------------------------*
FORM FRM_SET_FILTER  TABLES   P_LT_FILTER STRUCTURE LVC_S_FILT
                     USING    P_GO_GRID_TABLE TYPE REF TO CL_GUI_ALV_GRID..

CALL METHOD P_GO_GRID_TABLE->SET_FILTER_CRITERIA
  EXPORTING
    IT_FILTER = P_LT_FILTER[].

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_REFRESH_TABLE_DISPLAY
*&---------------------------------------------------------------------*
*& text Refresh OOALV
*&---------------------------------------------------------------------*
*&      --> GO_GRID_TABLE_FIELD
*&      --> LS_STABLE
*&---------------------------------------------------------------------*
FORM FRM_REFRESH_TABLE_DISPLAY  USING    P_GO_GRID_TABLE TYPE REF TO CL_GUI_ALV_GRID
                                         P_LS_STABLE LIKE LVC_S_STBL.

  P_GO_GRID_TABLE->REFRESH_TABLE_DISPLAY(
    EXPORTING
      IS_STABLE      =   P_LS_STABLE   " With Stable Rows/columns
*      I_SOFT_REFRESH =   I_SOFT_REFRESH  " Without Sort, Filter, Etc.
    EXCEPTIONS
      FINISHED       = 1
      OTHERS         = 2
  ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_CHECK_BEFORE_CREATE_ALL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_TYPE
*&      <-- LV_MESSAGE
*&---------------------------------------------------------------------*
FORM FRM_CHECK_BEFORE_CREATE_ALL  CHANGING P_LV_TYPE
                                           P_LV_MESSAGE.



  DATA:LT_ERROR_TABLE TYPE TABLE OF TY_ERROR_TABLE,
       LS_ERROR_TABLE LIKE LINE  OF LT_ERROR_TABLE.

  PERFORM FRM_GET_ERROR_TABLE TABLES LT_ERROR_TABLE.

  IF P_EXIST EQ 'X'.
    PERFORM FRM_GET_OBJECT_IN_SYSTEM TABLES LT_ERROR_TABLE.
  ENDIF.

  DESCRIBE TABLE  LT_ERROR_TABLE LINES DATA(LV_LINE).
  IF LV_LINE GT 1.
    P_LV_TYPE = 'E'.
    P_LV_MESSAGE = TEXT-E09."There are some error.Please check in " Show All Error"
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_GET_ERROR_TABLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_ERROR_TABLE
*&---------------------------------------------------------------------*
FORM FRM_GET_ERROR_TABLE  TABLES   P_LT_ERROR_TABLE STRUCTURE GS_ERROR_TABLE.

  DATA:LV_WHERE   TYPE STRING.
  DATA:LV_MESSAGE TYPE STRING.
  DATA:LS_ERROR_TABLE LIKE LINE OF P_LT_ERROR_TABLE.

  LV_WHERE = 'ICON_UPLOAD EQ ICON_RED_LIGHT'.
  LOOP AT <FS_GT_TABLE> ASSIGNING FIELD-SYMBOL(<FS_GS_TABLE>) WHERE (LV_WHERE).
    LS_ERROR_TABLE-SHEET_NAME = 'Table'.
    LS_ERROR_TABLE-ROW = SY-TABIX.

    PERFORM FRM_GET_DATA_FROM_FS USING 'MESSAGE_UPLOAD' <FS_GS_TABLE> CHANGING LV_MESSAGE.
    LS_ERROR_TABLE-ERROR_MESSAGE = LV_MESSAGE.

    APPEND LS_ERROR_TABLE TO P_LT_ERROR_TABLE.
  ENDLOOP.

  LOOP AT <FS_GT_TABLE_FIELD> ASSIGNING FIELD-SYMBOL(<FS_GS_TABLE_FIELD>) WHERE (LV_WHERE).
    LS_ERROR_TABLE-SHEET_NAME = 'Field'.
    LS_ERROR_TABLE-ROW = SY-TABIX.

    PERFORM FRM_GET_DATA_FROM_FS USING 'MESSAGE_UPLOAD' <FS_GS_TABLE_FIELD> CHANGING LV_MESSAGE.
    LS_ERROR_TABLE-ERROR_MESSAGE = LV_MESSAGE.

    APPEND LS_ERROR_TABLE TO P_LT_ERROR_TABLE.
  ENDLOOP.

  LOOP AT <FS_GT_ELEMENT> ASSIGNING FIELD-SYMBOL(<FS_GS_ELEMENT>) WHERE (LV_WHERE).
    LS_ERROR_TABLE-SHEET_NAME = 'Element'.
    LS_ERROR_TABLE-ROW = SY-TABIX.

    PERFORM FRM_GET_DATA_FROM_FS USING 'MESSAGE_UPLOAD' <FS_GS_ELEMENT> CHANGING LV_MESSAGE.
    LS_ERROR_TABLE-ERROR_MESSAGE = LV_MESSAGE.

    APPEND LS_ERROR_TABLE TO P_LT_ERROR_TABLE.
  ENDLOOP.

  LOOP AT <FS_GT_DOMAIN> ASSIGNING FIELD-SYMBOL(<FS_GS_DOMAIN>) WHERE (LV_WHERE).
    LS_ERROR_TABLE-SHEET_NAME = 'Domain'.
    LS_ERROR_TABLE-ROW = SY-TABIX.

    PERFORM FRM_GET_DATA_FROM_FS USING 'MESSAGE_UPLOAD' <FS_GS_DOMAIN> CHANGING LV_MESSAGE.
    LS_ERROR_TABLE-ERROR_MESSAGE = LV_MESSAGE.

    APPEND LS_ERROR_TABLE TO P_LT_ERROR_TABLE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SET_OBJECT_DETAILS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_NEW_OBJECT_DETAILS
*&      --> P_
*&      --> LS_DD01V_DATATYPE
*&---------------------------------------------------------------------*
FORM FRM_SET_OBJECT_DETAILS  TABLES   P_LS_NEW_OBJECT_DETAILS STRUCTURE COMS_GOX_TABLE_ENTRY_FIELDS
                             USING    FIELDNAME
                                      FIELDVALUE.
  DATA:LS_NEW_OBJECT_DETAILS TYPE LINE OF COMT_GOX_TABLE_ENTRY_FIELDS.
  ls_new_object_details = VALUE #( FIELDNAME = FIELDNAME FIELDVALUE = FIELDVALUE ).
  APPEND LS_NEW_OBJECT_DETAILS     TO P_LS_NEW_OBJECT_DETAILS.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SET_DOMAIN_DESC_WITH_LA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_NEW_OBJECT_OBJECT_TEXT
*&      --> LS_DD01V_DDLANGUAGE
*&      --> LS_DD01T_DDTEXT
*&---------------------------------------------------------------------*
FORM FRM_SET_DOMAIN_DESC_WITH_LA  TABLES   P_LT_OBJECT_TEXT STRUCTURE COMS_GOX_DEF_TEXT
                                  USING    P_DDLANGUAGE
                                           P_DDTEXT.

  DATA:LS_NEW_OBJECT_TEXT    TYPE LINE OF COMT_GOX_DEF_TEXT.
  LS_NEW_OBJECT_TEXT-DESCRIPTION = P_DDTEXT."Description
  LS_NEW_OBJECT_TEXT-LANGUAGE = P_DDLANGUAGE."Language
  APPEND LS_NEW_OBJECT_TEXT TO P_LT_OBJECT_TEXT.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form FRM_GOX_GEN_DOMA_STD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_NEW_OBJECT
*&      --> LT_OLD_OBJECT
*&      --> ET_BAPIRETURN
*&      --> ET_TRANSPORT
*&      --> LS_DD01V
*&      --> P_DEVCL
*&      --> P_CHECK
*&      <-- LV_ICON
*&      <-- LV_MESSAGE
*&---------------------------------------------------------------------*
FORM FRM_GOX_GEN_DOMA_STD  TABLES   P_LT_NEW_OBJECT STRUCTURE GS_NEW_OBJECT
                                    P_LT_OLD_OBJECT STRUCTURE GS_NEW_OBJECT
                                    P_ET_BAPIRETURN STRUCTURE BAPIRET2
                                    P_ET_TRANSPORT  STRUCTURE GS_TRANSPORT
                           USING    P_DOMNAME
                           CHANGING P_LV_TYPE
                                    P_LV_ICON
                                    P_LV_MESSAGE.
  DATA:IV_OBJECT_NAME TYPE  CHAR32.
  IV_OBJECT_NAME = P_DOMNAME.
  CALL FUNCTION 'GOX_GEN_DOMA_STD'
    EXPORTING
      IV_OBJECT_NAME = IV_OBJECT_NAME
      IT_OBJECT_NEW  = P_LT_NEW_OBJECT[]
      IT_OBJECT_OLD  = P_LT_OLD_OBJECT[]
      IV_DEVCLASS    = P_DEVCL
      IV_REQUEST_WB  = P_REQU
    IMPORTING
      ET_BAPIRETURN  = P_ET_BAPIRETURN[]
      ET_TRANSPORT   = P_ET_TRANSPORT[].
  READ TABLE P_ET_BAPIRETURN ASSIGNING FIELD-SYMBOL(<FS_BAPIRETURN>) WITH KEY TYPE = 'E'.
  IF SY-SUBRC EQ 0.
    P_LV_TYPE    = 'E'.
    P_LV_ICON    = ICON_RED_LIGHT.
    P_LV_MESSAGE = TEXT-E10."ERROR IN GOX_GEN_DOMA_STD
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_DDIF_DOMA_GET
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_DD07V
*&      --> LS_DD01V
*&      --> LS_DD01V_DDLANGUAGE
*&      --> LV_GOTSTATE
*&      <-- LV_ICON
*&      <-- LV_MESSAGE
*&---------------------------------------------------------------------*
FORM FRM_DDIF_DOMA_GET  TABLES   P_LT_DD07V STRUCTURE DD07V
                        USING    P_LS_DD01V STRUCTURE DD01V
                                 P_LV_GOTSTATE TYPE DDGOTSTATE
                        CHANGING P_LV_TYPE
                                 P_LV_ICON
                                 P_LV_MESSAGE.
  DATA:LV_DD01V TYPE DD01V.
    CALL FUNCTION 'DDIF_DOMA_GET'
      EXPORTING
        NAME          = P_LS_DD01V-DOMNAME
        STATE         = 'A'
        LANGU         = P_LS_DD01V-DDLANGUAGE
      IMPORTING
        GOTSTATE      = P_LV_GOTSTATE
        DD01V_WA      = LV_DD01V
*      TABLES
*        DD07V_TAB     = P_LT_DD07V
      EXCEPTIONS
        ILLEGAL_INPUT = 1.
  IF SY-SUBRC NE 0.
    P_LV_TYPE    = 'E'.
    P_LV_ICON    = ICON_RED_LIGHT.
    P_LV_MESSAGE = TEXT-E11."Error in DDIF_DOMA_GET
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_DDIF_DOMA_PUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_DD07V
*&      --> LS_DD01V
*&      <-- LV_ICON
*&      <-- LV_MESSAGE
*&---------------------------------------------------------------------*
FORM FRM_DDIF_DOMA_PUT  TABLES   P_LT_DD07V STRUCTURE DD07V
                        USING    P_LS_DD01V STRUCTURE DD01V
                        CHANGING P_LV_TYPE
                                 P_LV_ICON
                                 P_LV_MESSAGE.
  CALL FUNCTION 'DDIF_DOMA_PUT'
    EXPORTING
      NAME              = P_LS_DD01V-DOMNAME
      DD01V_WA          = P_LS_DD01V
    TABLES
      DD07V_TAB         = P_LT_DD07V[]
    EXCEPTIONS
      DOMA_NOT_FOUND    = 1
      NAME_INCONSISTENT = 2
      DOMA_INCONSISTENT = 3
      PUT_FAILURE       = 4
      PUT_REFUSED       = 5.
  IF SY-SUBRC NE 0.
    P_LV_TYPE    = 'E'.
    P_LV_ICON    = ICON_RED_LIGHT.
    P_LV_MESSAGE = TEXT-E11."Error in DDIF_DOMA_GET
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_GET_DD07
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_DD07T
*&      --> LS_DD01V_DOMNAME
*&---------------------------------------------------------------------*
FORM FRM_GET_DD07  TABLES   P_LT_DD07V STRUCTURE DD07V
                   USING    P_DOMNAME
                  CHANGING P_VALEXI.

  DATA:LS_DD07V LIKE LINE OF P_LT_DD07V.
  DATA:LV_VALPOS TYPE I VALUE 1.
  READ TABLE GT_DD07V ASSIGNING FIELD-SYMBOL(<FS_DD07T>) WITH KEY DOMNAME = P_DOMNAME BINARY SEARCH.
  IF SY-SUBRC EQ 0.
    P_VALEXI = 'X'.

    LOOP AT GT_DD07V ASSIGNING <FS_DD07T> FROM SY-TABIX.

      IF <FS_DD07T>-DOMNAME NE P_DOMNAME.
        EXIT.
      ENDIF.

      MOVE-CORRESPONDING <FS_DD07T> TO LS_DD07V.
      LS_DD07V-VALPOS = LV_VALPOS.
      APPEND LS_DD07V TO P_LT_DD07V.

      ADD 1 TO LV_VALPOS.
    ENDLOOP.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_GOX_GEN_DTEL_STD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_NEW_OBJECT
*&      --> LT_OLD_OBJECT
*&      --> ET_BAPIRETURN
*&      --> ET_TRANSPORT
*&      --> LS_DD04V_DOMNAME
*&      <-- P_LV_TYPE
*&      <-- LV_ICON
*&      <-- P_LV_MESSAGE
*&---------------------------------------------------------------------*
FORM FRM_GOX_GEN_DTEL_STD  TABLES   P_LT_NEW_OBJECT STRUCTURE GS_NEW_OBJECT
                                    P_LT_OLD_OBJECT STRUCTURE GS_NEW_OBJECT
                                    P_ET_BAPIRETURN STRUCTURE BAPIRET2
                                    P_ET_TRANSPORT  STRUCTURE GS_TRANSPORT
                           USING    P_ELEMENT_NAME
                           CHANGING P_LV_TYPE
                                    P_LV_ICON
                                    P_LV_MESSAGE.

  DATA:LV_ELEMENT_NAME TYPE CHAR32.

  LV_ELEMENT_NAME = P_ELEMENT_NAME.

  CALL FUNCTION 'GOX_GEN_DTEL_STD'
    EXPORTING
      IV_OBJECT_NAME = LV_ELEMENT_NAME
      IT_OBJECT_NEW  = P_LT_NEW_OBJECT[]
      IT_OBJECT_OLD  = P_LT_OLD_OBJECT[]
      IV_DEVCLASS    = P_DEVCL
      IV_REQUEST_WB  = P_REQU
    IMPORTING
      ET_BAPIRETURN  = P_ET_BAPIRETURN[]
      ET_TRANSPORT   = P_ET_TRANSPORT[]
      .
  IF SY-SUBRC NE 0.
    P_LV_TYPE    = 'E'.
    P_LV_ICON    = ICON_RED_LIGHT.
    P_LV_MESSAGE = TEXT-E10."Error in GOX_GEN_DOMA_STD
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& FORM FRM_DDIF_DTEL_GET
*&---------------------------------------------------------------------*
*& TEXT
*&---------------------------------------------------------------------*
*&      --> LT_DD07V
*&      --> LS_DD04V
*&      --> LV_GOTSTATE
*&      --> LS_TPARA_WA
*&      <-- P_LV_TYPE
*&      <-- LV_ICON
*&      <-- P_LV_MESSAGE
*&---------------------------------------------------------------------*
FORM FRM_DDIF_DTEL_GET  USING    P_LS_DD04V STRUCTURE DD04V
                                 P_LV_GOTSTATE TYPE DDGOTSTATE
                                 P_LS_TPARA_WA TYPE TPARA
                        CHANGING P_LV_TYPE
                                 P_LV_ICON
                                 P_LV_MESSAGE.

  CALL FUNCTION 'DDIF_DTEL_GET'
    EXPORTING
      NAME          = P_LS_DD04V-ROLLNAME
      STATE         = 'A'
      LANGU         = P_LS_DD04V-DDLANGUAGE
    IMPORTING
      GOTSTATE      = P_LV_GOTSTATE
      DD04V_WA      = P_LS_DD04V
      TPARA_WA      = P_LS_TPARA_WA
    EXCEPTIONS
      ILLEGAL_INPUT = 1.
  IF SY-SUBRC NE 0.
    P_LV_TYPE    = 'E'.
    P_LV_ICON    = ICON_RED_LIGHT.
    P_LV_MESSAGE = TEXT-E10."ERROR IN GOX_GEN_DOMA_STD
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& FORM FRM_DDIF_DTEL_PUT
*&---------------------------------------------------------------------*
*& TEXT
*&---------------------------------------------------------------------*
*&      --> LS_DD04V
*&      <-- P_LV_TYPE
*&      <-- LV_ICON
*&      <-- P_LV_MESSAGE
*&---------------------------------------------------------------------*
FORM FRM_DDIF_DTEL_PUT  USING    P_LS_DD04V STRUCTURE DD04V
                        CHANGING P_LV_TYPE
                                 P_LV_ICON
                                 P_LV_MESSAGE.

  CALL FUNCTION 'DDIF_DTEL_PUT'
    EXPORTING
      NAME              = P_LS_DD04V-ROLLNAME
      DD04V_WA          = P_LS_DD04V
    EXCEPTIONS
      DTEL_NOT_FOUND    = 1
      NAME_INCONSISTENT = 2
      DTEL_INCONSISTENT = 3
      PUT_FAILURE       = 4
      PUT_REFUSED       = 5.
  IF SY-SUBRC NE 0.
    P_LV_TYPE    = 'E'.
    P_LV_ICON    = ICON_RED_LIGHT.
    P_LV_MESSAGE = TEXT-E10."ERROR IN GOX_GEN_DOMA_STD
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_GOX_GEN_TABLE_STD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_NEW_OBJECT
*&      --> LT_OLD_OBJECT
*&      --> ET_BAPIRETURN
*&      --> ET_TRANSPORT
*&      --> LS_DD07V_DOMNAME
*&      <-- P_LV_TYPE
*&      <-- LV_ICON
*&      <-- P_LV_MESSAGE
*&---------------------------------------------------------------------*
FORM FRM_GOX_GEN_TABLE_STD  TABLES   P_LT_NEW_OBJECT STRUCTURE GS_NEW_OBJECT
                                     P_LT_OLD_OBJECT STRUCTURE GS_NEW_OBJECT
                                     P_ET_BAPIRETURN STRUCTURE BAPIRET2
                                     P_ET_TRANSPORT  STRUCTURE GS_TRANSPORT
                            USING    P_ELEMENT_NAME
                            CHANGING P_LV_TYPE
                                     P_LV_ICON
                                     P_LV_MESSAGE.
  DATA:LV_BJECT_NAME TYPE CHAR32.
  LV_BJECT_NAME = P_ELEMENT_NAME.

  CALL FUNCTION 'GOX_GEN_TABLE_STD'
    EXPORTING
      IV_OBJECT_NAME = LV_BJECT_NAME
      IT_OBJECT_NEW  = P_LT_NEW_OBJECT[]
      IT_OBJECT_OLD  = P_LT_OLD_OBJECT[]
      IV_DEVCLASS    = P_DEVCL
      IV_REQUEST_WB  = P_REQU
    IMPORTING
      ET_BAPIRETURN  = P_ET_BAPIRETURN[]
      ET_TRANSPORT   = P_ET_TRANSPORT[]
      .
  READ TABLE P_ET_BAPIRETURN ASSIGNING FIELD-SYMBOL(<FS_BAPIRETURN>) WITH KEY TYPE = 'E'.
  IF SY-SUBRC EQ 0.
    P_LV_TYPE    = 'E'.
    P_LV_ICON    = ICON_RED_LIGHT.
    P_LV_MESSAGE = TEXT-E14."Error In GOX_GEN_TABLE_STD
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_DDIF_TABL_PUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_DD04V
*&      <-- P_LV_TYPE
*&      <-- LV_ICON
*&      <-- P_LV_MESSAGE
*&---------------------------------------------------------------------*
FORM FRM_DDIF_TABL_PUT  USING    P_LS_DD02V STRUCTURE DD02V
                        CHANGING P_LV_TYPE
                                 P_LV_ICON
                                 P_LV_MESSAGE.

  DATA: LV_DDOBJNAME TYPE DDOBJNAME.
  LV_DDOBJNAME = P_LS_DD02V-TABNAME.

  CALL FUNCTION 'DDIF_TABL_PUT'
    EXPORTING
      NAME              = LV_DDOBJNAME
      DD02V_WA          = P_LS_DD02V
    EXCEPTIONS
      TABL_NOT_FOUND    = 1
      NAME_INCONSISTENT = 2
      TABL_INCONSISTENT = 3
      PUT_FAILURE       = 4
      PUT_REFUSED       = 5
      OTHERS            = 6.
  IF SY-SUBRC NE 0.
    P_LV_TYPE    = 'E'.
    P_LV_ICON    = ICON_RED_LIGHT.
    P_LV_MESSAGE = TEXT-E15."Error In DDIF_TABL_PUT
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_ALL_SET_SELECT_ROW
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_ALL_SET_SELECT_ROW .

  PERFORM FRM_SET_SELECT_ROW_TABLE.
  PERFORM FRM_SET_SELECT_ROW_ELEMENT.
  PERFORM FRM_SET_SELECT_ROW_DOMAIN.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SET_SELECT_ROW_TABLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_SET_SELECT_ROW_TABLE .

  DATA:LT_ROW  TYPE TABLE OF LVC_S_ROID,
       LS_ROW  LIKE LINE OF LT_ROW.

  LOOP AT <FS_GT_TABLE> ASSIGNING FIELD-SYMBOL(<FS_GS_TABLE>).
    LS_ROW-ROW_ID = SY-TABIX.
    APPEND LS_ROW TO LT_ROW.
  ENDLOOP.

  CALL METHOD GO_GRID_TABLE->SET_SELECTED_ROWS( EXPORTING IT_ROW_NO = LT_ROW ).


ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SET_SELECT_ROW_ELEMENT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_SET_SELECT_ROW_ELEMENT .

  DATA:LT_ROW  TYPE TABLE OF LVC_S_ROID,
       LS_ROW  LIKE LINE OF LT_ROW.

  LOOP AT <FS_GT_ELEMENT> ASSIGNING FIELD-SYMBOL(<FS_GS_ELEMENT>).
    LS_ROW-ROW_ID = SY-TABIX.
    APPEND LS_ROW TO LT_ROW.
  ENDLOOP.

  CALL METHOD GO_GRID_ELEMENT->SET_SELECTED_ROWS( EXPORTING IT_ROW_NO = LT_ROW ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SET_SELECT_ROW_DOMAIN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_SET_SELECT_ROW_DOMAIN .

  DATA:LT_ROW  TYPE TABLE OF LVC_S_ROID,
       LS_ROW  LIKE LINE OF LT_ROW.

  LOOP AT <FS_GT_DOMAIN> ASSIGNING FIELD-SYMBOL(<FS_GS_DOMAIN>).
    LS_ROW-ROW_ID = SY-TABIX.
    APPEND LS_ROW TO LT_ROW.
  ENDLOOP.

  CALL METHOD GO_GRID_DOMAIN->SET_SELECTED_ROWS( EXPORTING IT_ROW_NO = LT_ROW ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_CHECK_OBJECT_IN_SYSTEM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_FS_WOKSHEETNAME
*&      <-- LV_OBJECT_IN_SYSTEM
*&      <-- CASE
*&      <-- P_FS_WOKSHEETNAME
*&---------------------------------------------------------------------*
FORM FRM_CHECK_OBJECT_IN_SYSTEM  USING    P_FS_WOKSHEETNAME
                                          P_OBJECT_NAME
                                 CHANGING P_OBJECT_IN_SYSTEM.

  CASE P_FS_WOKSHEETNAME.
    WHEN 'Table'.
      READ TABLE GT_DD02V_IN_SYSTEM ASSIGNING FIELD-SYMBOL(<FS_DD02V_IN_SYSTEM>) WITH KEY TABNAME = P_OBJECT_NAME BINARY SEARCH.
      IF SY-SUBRC EQ 0.
        P_OBJECT_IN_SYSTEM = 'X'.
      ENDIF.
    WHEN 'Element'.
      READ TABLE GT_DD04L_IN_SYSTEM ASSIGNING FIELD-SYMBOL(<FS_DD04L_IN_SYSTEM>) WITH KEY ROLLNAME = P_OBJECT_NAME BINARY SEARCH.
      IF SY-SUBRC EQ 0.
        P_OBJECT_IN_SYSTEM = 'X'.
      ENDIF.
    WHEN 'Domain'.
      READ TABLE GT_DD01V_IN_SYSTEM ASSIGNING FIELD-SYMBOL(<FS_DD01V_IN_SYSTEM>) WITH KEY DOMNAME = P_OBJECT_NAME BINARY SEARCH.
      IF SY-SUBRC EQ 0.
        P_OBJECT_IN_SYSTEM = 'X'.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_GET_OBJECT_IN_SYSTEM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_ERROR_TABLE
*&---------------------------------------------------------------------*
FORM FRM_GET_OBJECT_IN_SYSTEM  TABLES P_LT_ERROR_TABLE STRUCTURE GS_ERROR_TABLE.

  DATA:LV_WHERE   TYPE STRING.
  DATA:LV_MESSAGE TYPE STRING.
  DATA:LS_ERROR_TABLE LIKE LINE OF P_LT_ERROR_TABLE.

  LV_WHERE = 'EXIST EQ ''X'''.
  LOOP AT <FS_GT_TABLE> ASSIGNING FIELD-SYMBOL(<FS_GS_TABLE>) WHERE (LV_WHERE).
    LS_ERROR_TABLE-SHEET_NAME = 'Table'.
    LS_ERROR_TABLE-ROW = SY-TABIX.
    LS_ERROR_TABLE-ERROR_MESSAGE = TEXT-E17."Object In System ,If you want to create continue，please unsign the "Check Exist in System?" in select screen
    APPEND LS_ERROR_TABLE TO P_LT_ERROR_TABLE.
  ENDLOOP.

  LV_WHERE = 'EXIST EQ ''X'''.
  LOOP AT <FS_GT_ELEMENT> ASSIGNING FIELD-SYMBOL(<FS_GS_ELEMENT>) WHERE (LV_WHERE).
    LS_ERROR_TABLE-SHEET_NAME = 'Element'.
    LS_ERROR_TABLE-ROW = SY-TABIX.
    LS_ERROR_TABLE-ERROR_MESSAGE = TEXT-E17."Object In System ,If you want to create continue，please unsign the "Check Exist in System?" in select screen
    APPEND LS_ERROR_TABLE TO P_LT_ERROR_TABLE.
  ENDLOOP.

  LV_WHERE = 'EXIST EQ ''X'''.
  LOOP AT <FS_GT_DOMAIN> ASSIGNING FIELD-SYMBOL(<FS_GS_DOMAIN>) WHERE (LV_WHERE).
    LS_ERROR_TABLE-SHEET_NAME = 'Domain'.
    LS_ERROR_TABLE-ROW = SY-TABIX.
    LS_ERROR_TABLE-ERROR_MESSAGE = TEXT-E17."Object In System ,If you want to create continue，please unsign the "Check Exist in System?" in select screen
    APPEND LS_ERROR_TABLE TO P_LT_ERROR_TABLE.
  ENDLOOP.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_GET_DATA_FROM_SYSTEM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_GET_DATA_FROM_SYSTEM .

  "Domain
  PERFORM FRM_GET_DD01V.

  "Table Config
  PERFORM FRM_GET_DD02V.

  "Element
  PERFORM FRM_GET_DD04L.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_GET_DD01V
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_GET_DD01V .
  "Domain
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE GT_DD01V_IN_SYSTEM
    FROM DD01V
   ORDER BY DOMNAME DDLANGUAGE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_GET_DD04L
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_GET_DD04L .
  "Element
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE GT_DD04L_IN_SYSTEM
    FROM DD04L
   ORDER BY ROLLNAME
    .
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_GET_DD02V
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_GET_DD02V .
  "Table Config
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE GT_DD02V_IN_SYSTEM
    FROM DD02V
   ORDER BY TABNAME DDLANGUAGE.
ENDFORM.