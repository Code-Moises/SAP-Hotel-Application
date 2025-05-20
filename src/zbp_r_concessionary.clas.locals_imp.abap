CLASS lhc_concessionary DEFINITION
  INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS setdefaultcity FOR DETERMINE ON MODIFY
      IMPORTING keys FOR concessionary~setdefaultcity.

    METHODS errortlf FOR VALIDATE ON SAVE
      IMPORTING keys FOR concessionary~errortlf.

    METHODS setzipcode FOR DETERMINE ON MODIFY
      IMPORTING keys FOR concessionary~setzipcode.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR concessionary RESULT result.

    METHODS errorname FOR VALIDATE ON SAVE
      IMPORTING keys FOR concessionary~errorname.
ENDCLASS.

CLASS lhc_concessionary IMPLEMENTATION.


METHOD setdefaultcity.
    READ ENTITIES OF ZR_CONCESSIONARY IN LOCAL MODE
      ENTITY concessionary
        FIELDS ( City )
        WITH CORRESPONDING #( keys )
      RESULT DATA(concessionaires)
      .

    LOOP AT concessionaires REFERENCE INTO DATA(concessionaire).
      IF concessionaire->City IS INITIAL.
        MODIFY ENTITIES OF ZR_CONCESSIONARY IN LOCAL MODE
          ENTITY concessionary
            UPDATE FIELDS ( City )
            WITH VALUE #( ( %key = concessionaire->%key
                            %is_draft = concessionaire->%is_draft
                            City = 'Málaga' ) ) .
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

METHOD errortlf.
    READ ENTITIES OF ZR_CONCESSIONARY IN LOCAL MODE
      ENTITY concessionary
        FIELDS ( Telephone )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_concessionaires)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    LOOP AT lt_concessionaires INTO DATA(ls_concessionaire).
      IF ls_concessionaire-Telephone IS NOT INITIAL AND
         NOT ( ls_concessionaire-Telephone CP '+34*' OR
               ls_concessionaire-Telephone CP '+49*' ).

        APPEND VALUE #( %tky = ls_concessionaire-%tky ) TO failed-concessionary.

        APPEND VALUE #( %tky = ls_concessionaire-%tky
                        %msg = new_message(
                                 id       = 'ZPHONE_MSG'
                                 number   = '001'
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = ls_concessionaire-Telephone )
                        %element-Telephone = if_abap_behv=>mk-on ) TO reported-concessionary.
      ENDIF.
    ENDLOOP.
ENDMETHOD.

METHOD setzipcode.
  READ ENTITIES OF ZR_CONCESSIONARY IN LOCAL MODE
    ENTITY concessionary
    FIELDS ( City )
    WITH CORRESPONDING #( keys )
    RESULT DATA(concessionaires).

  LOOP AT concessionaires INTO DATA(concessionaire).
    IF concessionaire-City = 'Alhaurín de la Torre'.
      MODIFY ENTITIES OF ZR_CONCESSIONARY IN LOCAL MODE
        ENTITY concessionary
        UPDATE FIELDS ( ZipCode )
        WITH VALUE #(
          ( %key = concessionaire-%key
            %is_draft = concessionaire-%is_draft
            ZipCode = '29130' )
        ).

    ELSE.
        MODIFY ENTITIES OF ZR_CONCESSIONARY IN LOCAL MODE
        ENTITY concessionary
        UPDATE FIELDS ( ZipCode )
        WITH VALUE #(
            ( %key = concessionaire-%key
              %is_draft = concessionaire-%is_draft
              ZipCode = '' )
        ).
    ENDIF.

  ENDLOOP.
ENDMETHOD.


  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD ErrorName.
      READ ENTITIES OF ZR_CONCESSIONARY IN LOCAL MODE
      ENTITY concessionary
        FIELDS ( Name )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_concessionaires)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    LOOP AT lt_concessionaires INTO DATA(ls_concessionaire).
      IF ls_concessionaire-Name IS INITIAL .
        APPEND VALUE #( %tky = ls_concessionaire-%tky ) TO failed-concessionary.
        APPEND VALUE #( %tky = ls_concessionaire-%tky
                        %msg = new_message(
                                 id       = 'ZPHONE_MSG'
                                 number   = '002'
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = ls_concessionaire-Name )
                        %element-Name = if_abap_behv=>mk-on ) TO reported-concessionary.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
