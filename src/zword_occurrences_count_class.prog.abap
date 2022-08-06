**********************************************************************
CLASS word_occurrences_repository DEFINITION.

  PUBLIC SECTION.
    TYPES: ty_zword_occurrence TYPE STANDARD TABLE OF zword_occurrence WITH DEFAULT KEY.



    METHODS:add_word_occurrencces IMPORTING VALUE(in_word) TYPE string
                                  RETURNING VALUE(result)  TYPE abap_bool.

    METHODS get_word_list RETURNING VALUE(word_list) TYPE ty_zword_occurrence.


  PRIVATE SECTION.
    DATA: word_list TYPE STANDARD TABLE OF zword_occurrence WITH KEY id word.

    METHODS: normalize_word IMPORTING VALUE(word_in)  TYPE string
                            RETURNING VALUE(word_out) TYPE string.


ENDCLASS.
CLASS word_occurrences_repository IMPLEMENTATION.

  METHOD add_word_occurrencces.

    DATA(normalized_word) = normalize_word( in_word ).


    IF line_exists( word_list[ word =  normalized_word ] ).
      DATA(indx) = line_index(  word_list[ word = normalized_word ] ).
      DATA(occurrencces) = word_list[ indx ]-occurrences.
      word_list[ indx ]-occurrences = occurrencces + 1 .
      result = abap_true.

    ELSE.
      DATA st_line TYPE zword_occurrence.
      st_line = VALUE #( word = normalized_word occurrences = 1 ).
      APPEND st_line TO word_list.
      result = abap_true.
    ENDIF.

  ENDMETHOD.

  METHOD: get_word_list.
    word_list = me->word_list.
  ENDMETHOD.


  METHOD: normalize_word.
    word_out = condense( to_upper( word_in ) ).
  ENDMETHOD.

ENDCLASS.


**********************************************************************
**********************************************************************
CLASS tokenizer DEFINITION CREATE PUBLIC.



  PUBLIC SECTION.
    TYPES: ty_list_lines TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    TYPES: ty_zword_occurrence TYPE STANDARD TABLE OF zword_occurrence WITH DEFAULT KEY.

    METHODS: constructor IMPORTING VALUE(it_lines) TYPE ty_list_lines.
    METHODS: get_tokens_list RETURNING VALUE(it_tokens) TYPE ty_zword_occurrence.

  PRIVATE SECTION.
    DATA: list_lines TYPE ty_list_lines,
          list_words TYPE STANDARD TABLE OF string.
    DATA repo TYPE REF TO word_occurrences_repository.
    DATA: counter TYPE REF TO word_occurrences_repository.

    METHODS: tokenizer_process.
    METHODS: count_words.




ENDCLASS.
CLASS tokenizer IMPLEMENTATION.

  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  METHOD: constructor.
    me->list_lines = it_lines.
  ENDMETHOD.

  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  METHOD: get_tokens_list.

    tokenizer_process( ).
    count_words( ).
    it_tokens = repo->get_word_list(  ).


  ENDMETHOD.


  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  METHOD: tokenizer_process.

    LOOP AT list_lines INTO DATA(st_current_line).
      DATA: a TYPE string,
            b TYPE string.

      DATA(line) = condense( st_current_line ).

      DO.
        SPLIT line AT ' ' INTO a b.

        IF a IS NOT INITIAL.
          APPEND a TO list_words.
        ENDIF.

        IF b IS NOT INITIAL.
          line = b.
        ELSE.
          EXIT.
        ENDIF.

      ENDDO.

    ENDLOOP.

  ENDMETHOD.


  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  METHOD: count_words.

    repo = NEW word_occurrences_repository(  ).

    LOOP AT list_words INTO DATA(current_word).
      repo->add_word_occurrencces( current_word ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.


**********************************************************************
