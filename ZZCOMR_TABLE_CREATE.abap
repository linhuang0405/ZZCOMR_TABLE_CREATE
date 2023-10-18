*&---------------------------------------------------------------------*
*& COPY RIGHT BY Joker
*&---------------------------------------------------------------------*
*Program name  ZZCOMR_TABLE_CREATE
*Program Desc  Create table element domain from excel
*Module  In    ALL
*Create  By    Jokr
*Create Date   2023.08.11
*FS
*&---------------------------------------------------------------------*
*Logic：
* 1.
* 2.
* 3.
*&---------------------------------------------------------------------*
*Change Log：
*&---------------------------------------------------------------------*
*  TR NO.          Change Date     Change BY       Change Document
*  A4HK123456      2023.08.11       Joker          Init
*
*&---------------------------------------------------------------------*
REPORT ZZCOMR_TABLE_CREATE.

"Define Golobal Data
INCLUDE ZZCOMR_TABLE_CREATE_TOP.

"Class For Ooalv
INCLUDE ZZCOMR_TABLE_CREATE_CAL.

"Select Screen
INCLUDE ZZCOMR_TABLE_CREATE_SCN.

"Perform
INCLUDE ZZCOMR_TABLE_CREATE_F01.

"Pbo
INCLUDE ZZCOMR_TABLE_CREATE_PB0.

"Pai
INCLUDE ZZCOMR_TABLE_CREATE_PAI.