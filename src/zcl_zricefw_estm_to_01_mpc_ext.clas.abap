CLASS zcl_zricefw_estm_to_01_mpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zricefw_estm_to_01_mpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ts_deep,
*        ls_header         TYPE zestm_header_sav,
        model_id          TYPE string,
        total_stimate     TYPE string,
        no_of_objects     TYPE string,
        app_dev_hours     TYPE string,
        func_dev_hours    TYPE string,
        reporting_hours   TYPE string,
        data_hours        TYPE string,
        buss_hours        TYPE string,
        itc_cycles        TYPE string,
        uat_cycles        TYPE string,
        complexity_type   TYPE string,
        engangement_type  TYPE string,
        zmodelname        TYPE string,
        createddate       TYPE string,
        createdtime       TYPE string,
        engagemanager     TYPE string,
        engagepartner     TYPE string,
        history           TYPE string,
        username          TYPE string,
        navtomodelmeasure TYPE STANDARD TABLE OF ts_modelmeasure WITH DEFAULT KEY,
        navtomodelitem    TYPE STANDARD TABLE OF ts_modelitem WITH DEFAULT KEY,
        navtomodelsetting TYPE STANDARD TABLE OF ts_modelsetting WITH DEFAULT KEY,
      END OF ts_deep .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZRICEFW_ESTM_TO_01_MPC_EXT IMPLEMENTATION.
ENDCLASS.
