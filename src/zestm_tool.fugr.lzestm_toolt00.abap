*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 02.10.2020 at 14:18:33
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZESTM_ENGAGMENT.................................*
DATA:  BEGIN OF STATUS_ZESTM_ENGAGMENT               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZESTM_ENGAGMENT               .
CONTROLS: TCTRL_ZESTM_ENGAGMENT
            TYPE TABLEVIEW USING SCREEN '0007'.
*...processing: ZESTM_HEADER....................................*
TABLES: ZESTM_HEADER, *ZESTM_HEADER. "view work areas
CONTROLS: TCTRL_ZESTM_HEADER
TYPE TABLEVIEW USING SCREEN '0003'.
DATA: BEGIN OF STATUS_ZESTM_HEADER. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZESTM_HEADER.
* Table for entries selected to show on screen
DATA: BEGIN OF ZESTM_HEADER_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZESTM_HEADER.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZESTM_HEADER_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZESTM_HEADER_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZESTM_HEADER.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZESTM_HEADER_TOTAL.

*...processing: ZESTM_HEADER_OBJ................................*
DATA:  BEGIN OF STATUS_ZESTM_HEADER_OBJ              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZESTM_HEADER_OBJ              .
CONTROLS: TCTRL_ZESTM_HEADER_OBJ
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZESTM_ITEM......................................*
TABLES: ZESTM_ITEM, *ZESTM_ITEM. "view work areas
CONTROLS: TCTRL_ZESTM_ITEM
TYPE TABLEVIEW USING SCREEN '0005'.
DATA: BEGIN OF STATUS_ZESTM_ITEM. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZESTM_ITEM.
* Table for entries selected to show on screen
DATA: BEGIN OF ZESTM_ITEM_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZESTM_ITEM.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZESTM_ITEM_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZESTM_ITEM_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZESTM_ITEM.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZESTM_ITEM_TOTAL.

*...processing: ZESTM_ITEM_OBJ..................................*
DATA:  BEGIN OF STATUS_ZESTM_ITEM_OBJ                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZESTM_ITEM_OBJ                .
CONTROLS: TCTRL_ZESTM_ITEM_OBJ
            TYPE TABLEVIEW USING SCREEN '0002'.
*...processing: ZESTM_MEASURE...................................*
DATA:  BEGIN OF STATUS_ZESTM_MEASURE                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZESTM_MEASURE                 .
CONTROLS: TCTRL_ZESTM_MEASURE
            TYPE TABLEVIEW USING SCREEN '0006'.
*...processing: ZESTM_MEASURE_N.................................*
DATA:  BEGIN OF STATUS_ZESTM_MEASURE_N               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZESTM_MEASURE_N               .
CONTROLS: TCTRL_ZESTM_MEASURE_N
            TYPE TABLEVIEW USING SCREEN '0009'.
*...processing: ZESTM_SETTING...................................*
DATA:  BEGIN OF STATUS_ZESTM_SETTING                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZESTM_SETTING                 .
CONTROLS: TCTRL_ZESTM_SETTING
            TYPE TABLEVIEW USING SCREEN '0008'.
*.........table declarations:.................................*
TABLES: *ZESTM_ENGAGMENT               .
TABLES: *ZESTM_HEADER_OBJ              .
TABLES: *ZESTM_ITEM_OBJ                .
TABLES: *ZESTM_MEASURE                 .
TABLES: *ZESTM_MEASURE_N               .
TABLES: *ZESTM_SETTING                 .
TABLES: ZESTM_ENGAGMENT                .
TABLES: ZESTM_HEADER_OBJ               .
TABLES: ZESTM_ITEM_OBJ                 .
TABLES: ZESTM_MEASURE                  .
TABLES: ZESTM_MEASURE_N                .
TABLES: ZESTM_SETTING                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
