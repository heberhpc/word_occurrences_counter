REPORT zword_counter_report.


INCLUDE zword_occurrences_count_class.


**********************************************************************
SELECTION-SCREEN BEGIN OF BLOCK main.


PARAMETERS: p_file TYPE string LOWER CASE.


SELECTION-SCREEN END OF BLOCK main.


**********************************************************************
DATA: it_lines TYPE STANDARD TABLE OF string.


**********************************************************************
START-OF-SELECTION.

  PERFORM get_file_lines.

  DATA(my_tokenizer) = NEW tokenizer( it_lines ).
  DATA(list) = my_tokenizer->get_tokens_list( ).

  SORT list BY occurrences.





  ULINE.

END-OF-SELECTION.

**********************************************************************
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  PERFORM select_file.




**********************************************************************
FORM get_file_lines.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename = p_file
      filetype = 'ASC'            " File Type (ASC or BIN)
    TABLES
      data_tab = it_lines.                 " Transfer table for file contents
  IF sy-subrc <> 0.
    " MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    " WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.


**********************************************************************
FORM select_file.

  CALL FUNCTION '/SAPDMC/LSM_F4_FRONTEND_FILE'
*  EXPORTING
*    pathname         =
    CHANGING
      pathfile = p_file
*  EXCEPTIONS
*     canceled_by_user = 1
*     system_error     = 2
*     others   = 3
    .
  IF sy-subrc <> 0.
* MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.


FORM test.

  DATA(report1) = NEW word_occurrences_repository( ).


  report1->add_word_occurrencces( 'heber ' ).
  report1->add_word_occurrencces( ' heber ' ).
  report1->add_word_occurrencces( ' heber' ).


  report1->add_word_occurrencces( 'SARA   ' ).
  report1->add_word_occurrencces( '   SARA' ).
  report1->add_word_occurrencces( '   SARA   ' ).

ENDFORM.




FORM test1.

  DATA it_lines_rascunho TYPE STANDARD TABLE OF string.

  it_lines_rascunho = VALUE #(
                                ( ` HEBER HENRIQUE pereira   coutinho`)
                                ( `coutinho`)
                                ( ` SARA MATOS DE OLIVEIRA   `)
                                ( `  `)
                             ).


  DATA(my_tokenizer) = NEW tokenizer( it_lines_rascunho ).


  DATA(list) = my_tokenizer->get_tokens_list( ).


ENDFORM.
