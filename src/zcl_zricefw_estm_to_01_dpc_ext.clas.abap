class ZCL_ZRICEFW_ESTM_TO_01_DPC_EXT definition
  public
  inheriting from ZCL_ZRICEFW_ESTM_TO_01_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
protected section.

  methods MODELHEADERSET_GET_ENTITY
    redefinition .
  methods MODELHEADERSET_GET_ENTITYSET
    redefinition .
  methods MODELITEMSET_GET_ENTITY
    redefinition .
  methods MODELITEMSET_GET_ENTITYSET
    redefinition .
  methods MODELMEASURESET_GET_ENTITYSET
    redefinition .
  methods RICEFCOMPLEXITYT_GET_ENTITYSET
    redefinition .
  methods RICEFENGAGEMENTS_GET_ENTITYSET
    redefinition .
  methods RICEFENGTYPESET_GET_ENTITYSET
    redefinition .
  methods RICEFHEADERSET_GET_ENTITY
    redefinition .
  methods RICEFHEADERSET_GET_ENTITYSET
    redefinition .
  methods RICEFITEMSET_GET_ENTITY
    redefinition .
  methods RICEFITEMSET_GET_ENTITYSET
    redefinition .
  methods RICEFMEASURENEWS_GET_ENTITY
    redefinition .
  methods RICEFMEASURENEWS_GET_ENTITYSET
    redefinition .
  methods RICEFMEASURESET_GET_ENTITY
    redefinition .
  methods RICEFMEASURESET_GET_ENTITYSET
    redefinition .
  methods RICEFSETTINGSET_GET_ENTITYSET
    redefinition .
  methods MODELSETTINGSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZRICEFW_ESTM_TO_01_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.

    DATA lr_deep_entity TYPE zcl_zricefw_estm_to_01_mpc_ext=>ts_deep.

    DATA: ls_header    TYPE  zestm_header_sav,
          ls_item      TYPE  zestm_item_sav,
          lt_modelitem TYPE TABLE OF zestm_item_sav,
          ls_measure   TYPE  zestm_measur_sav,
          lt_measure   TYPE TABLE OF zestm_measur_sav,
          ls_setting   TYPE  zestm_settin_sav,
          lt_setting   TYPE TABLE OF zestm_settin_sav,
          lv_number    TYPE  char10.

    CASE iv_entity_set_name.
*————————————————————————-*
*             EntitySet –  HeaderSet
*————————————————————————-*
      WHEN 'ModelHeaderSet'.

        io_data_provider->read_entry_data(
         IMPORTING
         es_data = lr_deep_entity ).

        MOVE-CORRESPONDING lr_deep_entity TO ls_header.

        IF ls_header-model_id IS INITIAL.

          CALL FUNCTION 'NUMBER_GET_NEXT'
            EXPORTING
              nr_range_nr = '01'
              object      = 'ZESTM'
              quantity    = '00000000000000000001'
            IMPORTING
              number      = lv_number.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF.

          ls_header-model_id = lv_number.
          ls_header-createddate = sy-datum.
          ls_header-createdtime = sy-uzeit.
          ls_header-username = sy-uname.

          MODIFY zestm_header_sav FROM ls_header.

          LOOP AT lr_deep_entity-navtomodelitem INTO DATA(ls_item_data).

*          MOVE-CORRESPONDING ls_item_data TO ls_item.
* Eddited - PSJ001
            ls_item-header_id = ls_item_data-headerid.
            ls_item-header_name = ls_item_data-headername.
            ls_item-item_id = ls_item_data-itemid.
            ls_item-criteria = ls_item_data-criteria.
            ls_item-model_name = ls_item_data-modelname.
* End Of Edit - psj001
            ls_item-model_id = lv_number.
            APPEND ls_item TO lt_modelitem.
          ENDLOOP.
          MODIFY ZESTM_item_SAV FROM TABLE lt_modelitem.

          LOOP AT lr_deep_entity-navtomodelmeasure INTO DATA(ls_measure_data).

            MOVE-CORRESPONDING ls_measure_data TO ls_measure.
            ls_measure-model_id = lv_number.
            APPEND ls_measure TO lt_measure.
          ENDLOOP.
          MODIFY zestm_measur_sav FROM TABLE lt_measure.



          LOOP AT lr_deep_entity-navtomodelsetting INTO DATA(ls_setting_data).

            MOVE-CORRESPONDING ls_setting_data TO ls_setting.
            ls_setting-header_id = ls_setting_data-headerid.
            ls_setting-item_id = ls_setting_data-itemid.
            ls_setting-model_id = lv_number.
            APPEND ls_setting TO lt_setting.
          ENDLOOP.
          MODIFY zestm_settin_sav FROM TABLE lt_setting.

          copy_data_to_ref(
          EXPORTING
          is_data = lr_deep_entity
          CHANGING
          cr_data = er_deep_entity
          ).

        ELSE.

          DATA(lv_model_id) =  ls_header-model_id.

          select SINGLE * FROM zestm_header_sav
            INTO @DATA(ls_header_fetch) WHERE  model_id = @lv_model_id.
*
*
*          ls_header-createddate = sy-datum.
*          ls_header-createdtime = sy-uzeit.
*          ls_header-username = sy-uname.

          ls_header-zmodelname = ls_header_fetch-zmodelname.
          ls_header-engagepartner = ls_header_fetch-engagepartner.
          ls_header-engagemanager = ls_header_fetch-engagemanager.
          ls_header-engangement_type = ls_header_fetch-engangement_type.
          ls_header-createddate = ls_header_fetch-createddate.
          ls_header-createdtime = ls_header_fetch-createdtime.
          ls_header-username = ls_header_fetch-username.
*
          MODIFY zestm_header_sav FROM ls_header.

          LOOP AT lr_deep_entity-navtomodelitem INTO ls_item_data.

*          MOVE-CORRESPONDING ls_item_data TO ls_item.
* Eddited - PSJ001
            ls_item-header_id = ls_item_data-headerid.
            ls_item-header_name = ls_item_data-headername.
            ls_item-item_id = ls_item_data-itemid.
            ls_item-criteria = ls_item_data-criteria.
            ls_item-model_name = ls_header-zmodelname.
* End Of Edit - psj001
            ls_item-model_id = lv_model_id.
            APPEND ls_item TO lt_modelitem.
          ENDLOOP.

          DELETE FROM ZESTM_item_SAV WHERE model_id = lv_model_id.
          COMMIT WORK.
          MODIFY ZESTM_item_SAV FROM TABLE lt_modelitem.

          LOOP AT lr_deep_entity-navtomodelmeasure INTO ls_measure_data.

            MOVE-CORRESPONDING ls_measure_data TO ls_measure.
            ls_measure-model_id = lv_model_id.
            APPEND ls_measure TO lt_measure.
          ENDLOOP.
          DELETE FROM zestm_measur_sav WHERE model_id = lv_model_id.
          COMMIT WORK.
          MODIFY zestm_measur_sav FROM TABLE lt_measure.



          LOOP AT lr_deep_entity-navtomodelsetting INTO ls_setting_data.

            MOVE-CORRESPONDING ls_setting_data TO ls_setting.
            ls_setting-header_id = ls_setting_data-headerid.
            ls_setting-item_id = ls_setting_data-itemid.
            ls_setting-model_id = ls_header-model_id.
            APPEND ls_setting TO lt_setting.
          ENDLOOP.
          MODIFY zestm_settin_sav FROM TABLE lt_setting.

          copy_data_to_ref(
          EXPORTING
          is_data = lr_deep_entity
          CHANGING
          cr_data = er_deep_entity
          ).

        ENDIF.



    ENDCASE.
  ENDMETHOD.


  METHOD modelheaderset_get_entity.
*&-----------------------------------------------------------------------------------------------------------------------------------------*
*                                                       MODIFICATION HISTORY                                                               |
*------------------------------------------------------------------------------------------------------------------------------------------|
* Change Date |Developer        |RICEFW/Defect#   | Transport#     | Description                                                           |
*------------------------------------------------------------------------------------------------------------------------------------------|
* 31-OCT-2020 | Vinodh Annaiah  |                 |                | This method is to read the values of Model and its details            |
*------------------------------------------------------------------------------------------------------------------------------------------|

    DATA: lo_message_cont TYPE REF TO /iwbep/if_message_container.

    TRY.

        DATA(ls_key) = it_key_tab[ name = 'ModelID' ].

        CALL METHOD /iwbep/if_mgw_conv_srv_runtime~get_message_container
          RECEIVING
            ro_message_container = lo_message_cont. "Message Container Interface

        SELECT SINGLE * FROM zestm_header_sav
                        INTO @DATA(ls_mod_head)
                        WHERE model_id = @ls_key-value.
        IF sy-subrc = 0.
          MOVE-CORRESPONDING ls_mod_head TO ER_ENTITY.
        ELSE.
          IF lo_message_cont IS BOUND.
            CALL METHOD lo_message_cont->add_message
              EXPORTING
                iv_msg_type               = 'E'
                iv_msg_id                 = '8I'
                iv_msg_number             = '000'
                iv_msg_text               = 'No record based on provided Model ID' && space && ls_key-value
                iv_add_to_response_header = abap_true.
            RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
          ENDIF.
        ENDIF.

      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

  ENDMETHOD.


  method MODELHEADERSET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->MODELHEADERSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
        DATA : lt_headerdata TYPE TABLE OF  zestm_header_sav,
           ls_headerdata LIKE LINE OF lt_headerdata,
           ls_entityset  LIKE LINE OF et_entityset.


**** get from table
    SELECT *
      FROM zestm_header_sav
      INTO TABLE lt_headerdata.
    IF sy-subrc = 0.
      IF lt_headerdata IS NOT INITIAL.
        LOOP AT lt_headerdata INTO ls_headerdata.
          ls_entityset-model_id = ls_headerdata-model_id.
          ls_entityset-zmodelname = ls_headerdata-zmodelname.
          ls_entityset-createddate = ls_headerdata-createddate.
          ls_entityset-createdtime = ls_headerdata-createdtime.
          ls_entityset-engagemanager = ls_headerdata-engagemanager.
          ls_entityset-engagepartner = ls_headerdata-engagepartner.
          ls_entityset-engangement_type = ls_headerdata-engangement_type.
          ls_entityset-username = ls_headerdata-username.



*          TRANSLATE ls_headerdata-icon TO LOWER CASE.
*          ls_entityset-icon = ls_headerdata-icon.
          APPEND ls_entityset TO et_entityset.
        ENDLOOP.
      ENDIF.
    ENDIF.

*    select * from zestm_header_sav into CORRESPONDING FIELDS OF et_entityset.

  endmethod.


  METHOD modelitemset_get_entity.


  ENDMETHOD.


  METHOD modelitemset_get_entityset.

*&-----------------------------------------------------------------------------------------------------------------------------------------*
*                                                       MODIFICATION HISTORY                                                               |
*------------------------------------------------------------------------------------------------------------------------------------------|
* Change Date |Developer        |RICEFW/Defect#   | Transport#     | Description                                                           |
*------------------------------------------------------------------------------------------------------------------------------------------|
* 31-OCT-2020 | Vinodh Annaiah  |                 |                | This method is to read the values of Model and its details            |
*------------------------------------------------------------------------------------------------------------------------------------------|

    TRY.

        DATA(ls_key) = it_key_tab[ name = 'ModelID' ].
        DATA ls_entityset  LIKE LINE OF et_entityset.

        SELECT * FROM zestm_item_sav
                 INTO TABLE @DATA(lt_mod_item)
                 WHERE model_id = @ls_key-value.
        IF sy-subrc = 0.
*          MOVE-CORRESPONDING lt_mod_item TO et_entityset.
*          Edited - PSJ001
          loop at lt_mod_item into DATA(ls_item).
            ls_entityset-criteria = ls_item-criteria.
             ls_entityset-headerid = ls_item-header_id.
             ls_entityset-headername = ls_item-header_name.
             ls_entityset-itemid = ls_item-item_id.
             ls_entityset-modelid = ls_item-model_id.
             ls_entityset-modelname = ls_item-model_name.
            APPEND ls_entityset TO et_entityset.
          ENDLOOP.
*          End Of Edit- psj001
        ENDIF.
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

  ENDMETHOD.


  METHOD modelmeasureset_get_entityset.
*&-----------------------------------------------------------------------------------------------------------------------------------------*
*                                                       MODIFICATION HISTORY                                                               |
*------------------------------------------------------------------------------------------------------------------------------------------|
* Change Date |Developer        |RICEFW/Defect#   | Transport#     | Description                                                           |
*------------------------------------------------------------------------------------------------------------------------------------------|
* 31-OCT-2020 | Vinodh Annaiah  |                 |                | This method is to read the values of Model and its details            |
*------------------------------------------------------------------------------------------------------------------------------------------|

    TRY.
        DATA(ls_key) = it_key_tab[ name = 'ModelID' ].

        SELECT * FROM zestm_measur_sav
                 INTO TABLE @DATA(lt_mod_measure)
                 WHERE model_id = @ls_key-value.
        IF sy-subrc = 0.
          MOVE-CORRESPONDING lt_mod_measure TO et_entityset.
        ENDIF.
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.
  ENDMETHOD.


  METHOD modelsettingset_get_entityset.
*&-----------------------------------------------------------------------------------------------------------------------------------------*
*                                                       MODIFICATION HISTORY                                                               |
*------------------------------------------------------------------------------------------------------------------------------------------|
* Change Date |Developer        |RICEFW/Defect#   | Transport#     | Description                                                           |
*------------------------------------------------------------------------------------------------------------------------------------------|
* 31-OCT-2020 | Vinodh Annaiah  |                 |                | This method is to read the values of Model and its details            |
*------------------------------------------------------------------------------------------------------------------------------------------|

    TRY.
        DATA(ls_key) = it_key_tab[ name = 'ModelID' ].
        DATA ls_entityset  LIKE LINE OF et_entityset.

        SELECT * FROM zestm_settin_sav
                 INTO TABLE @DATA(lt_mod_setting)
                 WHERE model_id = @ls_key-value.
        IF sy-subrc = 0.
*          MOVE-CORRESPONDING lt_mod_setting TO et_entityset.
          LOOP at lt_mod_setting INTO DATA(ls_item).
            ls_entityset-headerid = ls_item-header_id.
            ls_entityset-itemid = ls_item-item_id.
            ls_entityset-model_id = ls_item-model_id.
            ls_entityset-model_name = ls_item-model_name.
            ls_entityset-setting_name = ls_item-setting_name.
            ls_entityset-setting_type = ls_item-setting_type.
            ls_entityset-setting_value = ls_item-setting_value.
             APPEND ls_entityset TO et_entityset.
          ENDLOOP.


        ENDIF.
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.
  ENDMETHOD.


  METHOD ricefcomplexityt_get_entityset.
**TRY.
*CALL METHOD SUPER->RICEFCOMPLEXITYT_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

    "" taking all the engagement settings:
    TYPES: BEGIN OF ty_complexity,
             zeng_complexity TYPE zeng_complexity,
           END OF ty_complexity.
    DATA :lt_headerdata TYPE TABLE OF ty_complexity,
          ls_headerdata LIKE LINE OF lt_headerdata,
          ls_entityset  LIKE LINE OF et_entityset.

    SELECT DISTINCT zeng_complexity
     FROM zestm_engagment
     INTO CORRESPONDING FIELDS OF TABLE lt_headerdata.
    IF sy-subrc = 0.
      SORT lt_headerdata BY zeng_complexity.
      LOOP AT lt_headerdata INTO ls_headerdata.

        ls_entityset-zeng_complexity = ls_headerdata-zeng_complexity.
        APPEND ls_entityset TO et_entityset.

      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD ricefengagements_get_entityset.
**TRY.
*CALL METHOD SUPER->RICEFENGAGEMENTS_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

    "" taking all the engagement settings:
    DATA :lt_headerdata TYPE TABLE OF zestm_engagment,
          ls_headerdata LIKE LINE OF lt_headerdata,
          ls_entityset  LIKE LINE OF et_entityset,
          lv_complexity TYPE c LENGTH 30,
          lv_engtype    TYPE c LENGTH 30.

    SELECT *
     FROM zestm_engagment
     INTO CORRESPONDING FIELDS OF TABLE lt_headerdata.
    IF sy-subrc = 0.
      SORT lt_headerdata BY zeng_complexity.
      LOOP AT lt_headerdata INTO ls_headerdata.

        ls_entityset-zeng_complexity = ls_headerdata-zeng_complexity.
        ls_entityset-zeng_type = ls_headerdata-zeng_type.

        APPEND ls_entityset TO et_entityset.

    ENDLOOP.
  ENDIF.

ENDMETHOD.


  METHOD ricefengtypeset_get_entityset.
**TRY.
*CALL METHOD SUPER->RICEFENGTYPESET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
    "" taking all the engagement settings:
    TYPES: BEGIN OF ty_engtype,
             zeng_type TYPE zeng_type,
           END OF ty_engtype.
    DATA :lt_headerdata TYPE TABLE OF ty_engtype,
          ls_headerdata LIKE LINE OF lt_headerdata,
          ls_entityset  LIKE LINE OF et_entityset.

    SELECT DISTINCT zeng_type
     FROM zestm_engagment
     INTO CORRESPONDING FIELDS OF TABLE lt_headerdata.
    IF sy-subrc = 0.

      LOOP AT lt_headerdata INTO ls_headerdata.

        ls_entityset-zeng_type = ls_headerdata-zeng_type.

        APPEND ls_entityset TO et_entityset.

      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD ricefheaderset_get_entity.
**TRY.
*CALL METHOD SUPER->RICEFHEADERSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

    DATA : lv_headerid TYPE zestm_id_ricef,
           ls_key_tab  LIKE LINE OF it_key_tab.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'HeaderId'.
    IF sy-subrc = 0.
      lv_headerid = ls_key_tab-value.
    ENDIF.

    IF lv_headerid IS NOT INITIAL.
      SELECT SINGLE header_id header_name
        FROM zestm_header_obj
        INTO er_entity
        WHERE header_id = lv_headerid.
      IF sy-subrc = 0.

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD ricefheaderset_get_entityset.
**TRY.
*CALL METHOD SUPER->RICEFHEADERSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

**** Main Entity sets call for the RICEF HEADER:

***** get the entity sets from the table ZESTM_HEADER_OBJ


    DATA : lt_headerdata TYPE TABLE OF  zestm_header_obj,
**      DATA : lt_headerdata TYPE TABLE OF  zestm_header_sav,
           ls_headerdata LIKE LINE OF lt_headerdata,
           ls_entityset  LIKE LINE OF et_entityset.


**** get from table
    SELECT *
      FROM zestm_header_obj
      INTO TABLE lt_headerdata.
    IF sy-subrc = 0.
      IF lt_headerdata IS NOT INITIAL.
        LOOP AT lt_headerdata INTO ls_headerdata.
          ls_entityset-header_id = ls_headerdata-header_id.
          ls_entityset-header_name = ls_headerdata-header_name.
          TRANSLATE ls_headerdata-icon TO LOWER CASE.
          ls_entityset-icon = ls_headerdata-icon.
          APPEND ls_entityset TO et_entityset.
        ENDLOOP.
      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD ricefitemset_get_entity.
**TRY.
*CALL METHOD SUPER->RICEFITEMSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.


    DATA :lv_headerid TYPE zestm_id_ricef,
          lv_itemid   TYPE zestm_itemid_ricef,
          ls_key_tab  LIKE LINE OF it_key_tab.
    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'HeaderId'.
    IF sy-subrc = 0.
      lv_headerid = ls_key_tab-value.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'ItemId'.
    IF sy-subrc = 0.
      lv_itemid = ls_key_tab-value.
    ENDIF.

    IF lv_headerid IS NOT INITIAL AND lv_itemid IS NOT INITIAL.
      SELECT SINGLE header_id item_id item_name
        FROM zestm_item_obj
        INTO CORRESPONDING FIELDS OF er_entity
        WHERE header_id = lv_headerid
        AND item_id = lv_itemid.
      IF sy-subrc = 0.

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD ricefitemset_get_entityset.
**TRY.
*CALL METHOD SUPER->RICEFITEMSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

** get entityset for item level

    TYPES: BEGIN OF ty_item,
             header_id TYPE zestm_id_ricef,
             item_id   TYPE zestm_itemid_ricef,
             item_name TYPE zestm_itemname_ricef,
           END OF ty_item.

    DATA : lt_item     TYPE STANDARD TABLE OF ty_item,
           ls_item     LIKE LINE OF lt_item,
           ls_entity   LIKE LINE OF et_entityset,
           ls_key_tab  LIKE LINE OF it_key_tab,
           lv_headerid TYPE zestm_id_ricef.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'HeaderId'.
    IF sy-subrc = 0.
      lv_headerid = ls_key_tab-value.
    ENDIF.

    SELECT header_id item_id item_name
      FROM zestm_item_obj
      INTO TABLE lt_item
      WHERE header_id = lv_headerid.

    IF sy-subrc = 0.
      IF lt_item IS NOT INITIAL.
        LOOP AT lt_item INTO ls_item.
          ls_entity-header_id = ls_item-header_id.
          ls_entity-item_id = ls_item-item_id.
          ls_entity-item_name = ls_item-item_name.
          APPEND ls_entity TO et_entityset.
        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD ricefmeasurenews_get_entity.
**TRY.
*CALL METHOD SUPER->RICEFMEASURENEWS_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

** get measures  entity for item level
    DATA : ls_key_tab  LIKE LINE OF it_key_tab,
           lv_headerid TYPE zestm_id_ricef,
           lv_itemid   TYPE zestm_itemid_ricef.


    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'HeaderId'.
    IF sy-subrc = 0.
      lv_headerid = ls_key_tab-value.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'ItemId'.
    IF sy-subrc = 0.
      lv_itemid = ls_key_tab-value.
    ENDIF.

    IF lv_headerid IS NOT INITIAL AND lv_itemid IS NOT INITIAL.
      SELECT SINGLE *
       FROM zestm_measure_n
       INTO CORRESPONDING FIELDS OF er_entity
       WHERE header_id = lv_headerid
       AND item_id = lv_itemid.

      IF sy-subrc = 0.

      ENDIF.
    ENDIF.
  ENDMETHOD.


  method RICEFMEASURENEWS_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->RICEFMEASURENEWS_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
** get measures  entityset for item level
    DATA : lt_measure  TYPE STANDARD TABLE OF zestm_measure_n,
           ls_measure  TYPE zestm_measure_n,
           ls_key_tab  LIKE LINE OF it_key_tab,
           lv_headerid TYPE zestm_id_ricef,
           lv_itemid   TYPE zestm_itemid_ricef,
           ls_entity   LIKE LINE OF et_entityset,
           ls_entity_1 LIKE LINE OF et_entityset,
           lt_entityset type ZCL_ZRICEFW_ESTM_TO_01_MPC=>TT_RICEFMEASURE.


    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'HeaderId'.
    IF sy-subrc = 0.
      lv_headerid = ls_key_tab-value.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'ItemId'.
    IF sy-subrc = 0.
      lv_itemid = ls_key_tab-value.
    ENDIF.

    IF lv_headerid IS NOT INITIAL AND lv_itemid IS NOT INITIAL.
      SELECT *
       FROM zestm_measure_n
       INTO TABLE lt_measure
       WHERE header_id = lv_headerid
       AND item_id = lv_itemid.

      IF sy-subrc = 0.

        IF lt_measure IS NOT INITIAL.


          LOOP AT lt_measure INTO ls_measure.

              ls_entity-header_id = ls_measure-header_id.
              ls_entity-item_id = ls_measure-item_id.
              ls_entity-measure_type = ls_measure-measure_type.
              ls_entity-measure_name = ls_measure-measure_name.
              ls_entity-measure_active = ls_measure-measure_active.
              ls_entity-measure_value = ls_measure-measure_value.
              ls_entity-measure_engtype = ls_measure-measure_engtype.
              ls_entity-measure_seq  = ls_measure-measure_seq.
              APPEND ls_entity TO et_entityset.


          ENDLOOP.

            SORT et_entityset BY measure_seq.

*          SORT et_entityset BY measure_type measure_value.

        ENDIF.

      ENDIF.
    ENDIF.
  endmethod.


  method RICEFMEASURESET_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->RICEFMEASURESET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

** get measures  entity for item level
    DATA : ls_key_tab  LIKE LINE OF it_key_tab,
           lv_headerid TYPE zestm_id_ricef,
           lv_itemid   TYPE zestm_itemid_ricef.


    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'HeaderId'.
    IF sy-subrc = 0.
      lv_headerid = ls_key_tab-value.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'ItemId'.
    IF sy-subrc = 0.
      lv_itemid = ls_key_tab-value.
    ENDIF.

    IF lv_headerid IS NOT INITIAL AND lv_itemid IS NOT INITIAL.
      SELECT SINGLE *
       FROM zestm_measure
       INTO CORRESPONDING FIELDS OF er_entity
       WHERE header_id = lv_headerid
       AND item_id = lv_itemid.

      IF sy-subrc = 0.

      ENDIF.
    ENDIF.
  endmethod.


  METHOD ricefmeasureset_get_entityset.
**TRY.
*CALL METHOD SUPER->RICEFMEASURESET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.


** get measures  entityset for item level
    DATA : lt_measure  TYPE STANDARD TABLE OF zestm_measure,
           ls_measure  TYPE zestm_measure,
           ls_key_tab  LIKE LINE OF it_key_tab,
           lv_headerid TYPE zestm_id_ricef,
           lv_itemid   TYPE zestm_itemid_ricef,
           ls_entity   LIKE LINE OF et_entityset,
           ls_entity_1 LIKE LINE OF et_entityset,
           lt_entityset type ZCL_ZRICEFW_ESTM_TO_01_MPC=>TT_RICEFMEASURE.


    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'HeaderId'.
    IF sy-subrc = 0.
      lv_headerid = ls_key_tab-value.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'ItemId'.
    IF sy-subrc = 0.
      lv_itemid = ls_key_tab-value.
    ENDIF.

    IF lv_headerid IS NOT INITIAL AND lv_itemid IS NOT INITIAL.
      SELECT *
       FROM zestm_measure
       INTO TABLE lt_measure
       WHERE header_id = lv_headerid
       AND item_id = lv_itemid.

      IF sy-subrc = 0.

        IF lt_measure IS NOT INITIAL.


          LOOP AT lt_measure INTO ls_measure.

              ls_entity-header_id = ls_measure-header_id.
              ls_entity-item_id = ls_measure-item_id.
              ls_entity-measure_type = ls_measure-measure_type.
              ls_entity-measure_name = ls_measure-measure_name.
              ls_entity-measure_active = ls_measure-measure_active.
              ls_entity-measure_value = ls_measure-measure_value.
              ls_entity-zeng_complexity = ls_measure-zeng_complexity.
              ls_entity-measure_engtype = ls_measure-measure_engtype.
              APPEND ls_entity TO et_entityset.


          ENDLOOP.


          SORT et_entityset BY measure_type.

        ENDIF.

      ENDIF.
    ENDIF.







  ENDMETHOD.


  METHOD ricefsettingset_get_entityset.
**TRY.
*CALL METHOD SUPER->RICEFSETTINGSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

    TYPES: BEGIN OF ty_engtype,
             settingtype TYPE zsettingtype,
             settingname TYPE zsettingname,
             settingvalue type zsettingvalue,
           END OF ty_engtype.
    DATA :lt_headerdata TYPE TABLE OF ty_engtype,
          ls_headerdata LIKE LINE OF lt_headerdata,
          ls_entityset  LIKE LINE OF et_entityset.

    SELECT settingtype settingname settingvalue
     FROM zestm_setting
     INTO CORRESPONDING FIELDS OF TABLE lt_headerdata.
    IF sy-subrc = 0.

      LOOP AT lt_headerdata INTO ls_headerdata.

        ls_entityset-settingtype = ls_headerdata-settingtype.
        ls_entityset-settingname = ls_headerdata-settingname.
        ls_entityset-settingvalue = ls_headerdata-settingvalue.
        APPEND ls_entityset TO et_entityset.

      ENDLOOP.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
