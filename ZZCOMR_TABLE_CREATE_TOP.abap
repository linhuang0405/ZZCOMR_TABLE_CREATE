*&---------------------------------------------------------------------*
*& INCLUDE               ZZCOMR_TABLE_CREATE_TOP
*&---------------------------------------------------------------------*
TABLES:DD01V,DD02V,DD03L,DD04V,E070,SSCRFIELDS.

TYPES:BEGIN OF TY_OUTPUT,
        SLBOX TYPE C,
        ICON  TYPE ICON-ID,

      END OF TY_OUTPUT.

TYPES:BEGIN OF TY_ERROR_TABLE,
        SHEET_NAME    TYPE STRING,
        ROW           TYPE STRING,
        ERROR_MESSAGE TYPE STRING,
      END OF TY_ERROR_TABLE.

DATA:GT_OUTPUT TYPE TABLE OF TY_OUTPUT,
     GS_OUTPUT LIKE LINE OF GT_OUTPUT.
DATA:GT_ERROR_TABLE TYPE TABLE OF TY_ERROR_TABLE,
     GS_ERROR_TABLE LIKE LINE OF GT_ERROR_TABLE.

DATA:GV_TYPE TYPE C,
     GV_MESSAGE TYPE STRING.

*&---------------------------------------------------------------------*
*&DEFINE ALV
*&---------------------------------------------------------------------*
DATA: GV_REPID                                  TYPE SY-REPID,
      GS_LAYOUT                                 TYPE LVC_S_LAYO,
      GS_REPID                                  TYPE SY-REPID,
      GT_ALV_FILEDCAT_TABLE                     TYPE LVC_T_FCAT,
      GT_ALV_FILEDCAT_TABLE_FIELD               TYPE LVC_T_FCAT,
      GT_ALV_FILEDCAT_ELEMENT                   TYPE LVC_T_FCAT,
      GT_ALV_FILEDCAT_DOMAIN                    TYPE LVC_T_FCAT,
      GT_ALV_FILEDCAT_DD07T                     TYPE LVC_T_FCAT,
      GS_ALV_FILED                              LIKE LVC_S_FCAT.

"Button of alv
DATA:GT_EXCLUDE_TABLE         TYPE UI_FUNCTIONS,
     GT_EXCLUDE_TABLE_FIELD   TYPE UI_FUNCTIONS,
     GT_EXCLUDE_ELEMENT       TYPE UI_FUNCTIONS,
     GT_EXCLUDE_DOMAIN        TYPE UI_FUNCTIONS.

"layout
DATA:GS_LAYOUT_TABLE          TYPE LVC_S_LAYO,
     GS_LAYOUT_TABLE_FIELD    TYPE LVC_S_LAYO,
     GS_LAYOUT_ELEMENT        TYPE LVC_S_LAYO,
     GS_LAYOUT_DOMAIN         TYPE LVC_S_LAYO.

"variant
DATA:GS_VARIANT_TABLE         TYPE DISVARIANT,
     GS_VARIANT_TABLE_FIELD   TYPE DISVARIANT,
     GS_VARIANT_ELEMENT       TYPE DISVARIANT,
     GS_VARIANT_DOMAIN        TYPE DISVARIANT.

FIELD-SYMBOLS:<FS_GT_TABLE>                     TYPE STANDARD TABLE,
              <FS_GT_TABLE_FIELD>               TYPE STANDARD TABLE,
              <FS_GT_ELEMENT>                   TYPE STANDARD TABLE,
              <FS_GT_DOMAIN>                    TYPE STANDARD TABLE,
              <FS_GT_DOMAIN_VALUE_RANGE>        TYPE STANDARD TABLE,
              <FS_GS_TABLE>   ,
              <FS_GS_TABLE_FIELD>   ,
              <FS_GS_ELEMENT> ,
              <FS_GS_DOMAIN>  ,
              <FS_GS_DOMAIN_VALUE_RANGE>  .
DATA:GT_DD01V           TYPE TABLE OF DD01V,"Domain
     GT_DD01V_IN_SYSTEM TYPE TABLE OF DD01V.
DATA:GT_DD02V           TYPE TABLE OF DD02V,"Table Config
     GT_DD02V_IN_SYSTEM TYPE TABLE OF DD02V.
DATA:GT_DD03L           TYPE TABLE OF DD03L,"Table Field
     GT_DD03L_IN_SYSTEM TYPE TABLE OF DD03L.
DATA:GT_DD04V           TYPE TABLE OF DD04V,"Element
     GT_DD04L_IN_SYSTEM TYPE TABLE OF DD04L.
DATA:GT_DD07V           TYPE TABLE OF DD07V,"Domain Value Range
     GT_DD07L_IN_SYSTEM TYPE TABLE OF DD07L.


FIELD-SYMBOLS:<FS_GO_EXCEL_DATA_SHEET> TYPE STANDARD TABLE.

DATA:GV_EXCEL_FILED_NAME TYPE I VALUE 1,
     GV_EXCEL_FILED_DESCRIPTION TYPE I VALUE 2,
     GV_EXCEL_REQUIRE_CHECK TYPE I VALUE 3,
     GV_EXCEL_REF_TABLE TYPE I VALUE 4,
     GV_EXCEL_REF_FIELD TYPE I VALUE 5,
     GV_EXCEL_KEY_VALUE TYPE I VALUE 6,"weather Key value or not?
     GV_EXCEL_DATA_FROM TYPE I VALUE 8,
     GV_FIELD_BEGIN     TYPE I VALUE 2.
DATA:GT_NEW_OBJECT      TYPE COMT_GOX_DEF_HEADER,
     GS_NEW_OBJECT      LIKE LINE OF GT_NEW_OBJECT.
DATA:GT_TRANSPORT       TYPE COMT_GOX_TRANS_OBJECT,
     GS_TRANSPORT       LIKE LINE OF GT_TRANSPORT.

*&---------------------------------------------------------------------*
* Defien Docking
*&---------------------------------------------------------------------*
DATA:GO_DOCKING_9100           TYPE REF TO CL_GUI_DOCKING_CONTAINER,  " Auto adjusting
     GO_CONTAINER_TABLE        TYPE REF TO CL_GUI_CONTAINER,          " Docking Of Table
     GO_CONTAINER_TABLE_FIELD  TYPE REF TO CL_GUI_CONTAINER,          " Docking Of Table Field
     GO_CONTAINER_ELEMENT      TYPE REF TO CL_GUI_CONTAINER,          " Docking Of  Element
     GO_CONTAINER_DOMAIN       TYPE REF TO CL_GUI_CONTAINER,          " Docking Of Domain
     GO_CONTAINER04 TYPE REF TO CL_GUI_CONTAINER,          " Docking4
     GO_SPLITTER01  TYPE REF TO CL_GUI_SPLITTER_CONTAINER, " Splitter1
     GO_SPLITTER02  TYPE REF TO CL_GUI_SPLITTER_CONTAINER, " Splitter2
     GO_GRID_TABLE            TYPE REF TO CL_GUI_ALV_GRID,
     GO_GRID_TABLE_FIELD      TYPE REF TO CL_GUI_ALV_GRID,
     GO_GRID_ELEMENT          TYPE REF TO CL_GUI_ALV_GRID,
     GO_GRID_DOMAIN           TYPE REF TO CL_GUI_ALV_GRID.