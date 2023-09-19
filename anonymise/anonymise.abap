  METHOD anonymise.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""$"$\SE:(1) Class /CELONIS/CL_CTRL_ANONYMISE, Method ANONYMISE, Start                                                                                         A
*$*$-Start: (1)---------------------------------------------------------------------------------$*$*
ENHANCEMENT 1  ZCELONIS_FRIENDLY_ANONYMISE.    "active version
*
* Local Constants
  CONSTANTS: lc_hash         TYPE char100 VALUE 'FRIENDLY-SHA1',
             lc_default_hash TYPE char100 VALUE 'SHA1',
             lc_offset       TYPE i VALUE 4.
*
* Local Data
  DATA: lv_result    TYPE string,
        lv_tabname   TYPE ddobjname,
        lv_fieldname TYPE dfies-lfieldname,
        ls_dfies     TYPE dfies.
*
* Local Feld Symbols
  FIELD-SYMBOLS: <fs_table> TYPE any.
*
* Check hash algorithm before enhancement
  IF iv_hash_alg EQ lc_hash.
*
*   Get table name
    ASSIGN ('(/CELONIS/RP_BG_EXTRACT)TAB_C') TO <fs_table>.

    IF <fs_table> IS ASSIGNED.

      lv_tabname   = <fs_table>.
      lv_fieldname = iv_column.
*
*     Get fields list
      CALL FUNCTION 'DDIF_FIELDINFO_GET'
        EXPORTING
          tabname        = lv_tabname
          langu          = sy-langu
          lfieldname     = lv_fieldname
        IMPORTING
          dfies_wa       = ls_dfies
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.

      IF sy-subrc IS INITIAL.
*
*       Calculate hash with default algorithm
        /celonis/cl_ctrl_anonymise=>calculate_hash(
          EXPORTING
            iv_data     = iv_data
            iv_hash_alg = lc_default_hash
            iv_salt     = iv_salt
            io_log      = io_log
          IMPORTING
            ev_hash     = lv_result
        ).
*
*       Concatenate field description and 4-last digits of hash string
        DATA(lv_strlen) = strlen( lv_result ) - lc_offset.
        lv_result = |{ ls_dfies-scrtext_m } { lv_result+lv_strlen(lc_offset) }|.
        ev_result = |"{ lv_result }"|.

        RETURN. " Exit method

      ENDIF.

    ENDIF.

  ENDIF.

* Continue with original code...

ENDENHANCEMENT.
*$*$-End:   (1)---------------------------------------------------------------------------------$*$*

* Original Celonis code...

  ENDMETHOD.