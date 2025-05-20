CLASS lhc_clients DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS ValidateDni FOR VALIDATE ON SAVE
      IMPORTING keys FOR Clients~ValidateDni.

    METHODS ValidateEmail FOR VALIDATE ON SAVE
      IMPORTING keys FOR Clients~ValidateEmail.

    METHODS ValidateTlf FOR VALIDATE ON SAVE
      IMPORTING keys FOR Clients~ValidateTlf.

ENDCLASS.

CLASS lhc_clients IMPLEMENTATION.

  METHOD ValidateDni.
        READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY clients
        FIELDS ( DniPass )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_hotels)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    LOOP AT lt_hotels INTO DATA(ls_hotel).
      IF ls_hotel-DniPass IS INITIAL .
        APPEND VALUE #( %tky = ls_hotel-%tky ) TO failed-clients.
        APPEND VALUE #( %tky = ls_hotel-%tky
                        %msg = new_message(
                                 id       = 'ZHOTEL_MSG'
                                 number   = '006'
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = ls_hotel-Name )
                        %element-Name = if_abap_behv=>mk-on ) TO reported-clients.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD ValidateEmail.
      READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY clients
        FIELDS ( Email )
        WITH CORRESPONDING #( keys )
      RESULT DATA(clients)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    LOOP AT clients INTO DATA(client).
      IF client-Email IS NOT INITIAL AND
         NOT client-Email CP '*@*.*'.
        APPEND VALUE #( %tky = client-%tky ) TO failed-clients.
        APPEND VALUE #(
            %tky = client-%tky
            %msg = new_message(
                      id       = 'ZHOTEL_MSG'
                      number   = '007'
                      severity = if_abap_behv_message=>severity-error
                      v1       = client-Email )
            %element-Email = if_abap_behv=>mk-on ) TO reported-clients.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD ValidateTlf.
      READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY clients
        FIELDS ( Telephone )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_clients)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    LOOP AT lt_clients INTO DATA(ls_clients).
      IF ls_clients-Telephone IS NOT INITIAL AND
         NOT ( ls_clients-Telephone CP '+34*' OR
               ls_clients-Telephone CP '+49*' ).

        APPEND VALUE #( %tky = ls_clients-%tky ) TO failed-clients.

        APPEND VALUE #( %tky = ls_clients-%tky
                        %msg = new_message(
                                 id       = 'ZHOTEL_MSG'
                                 number   = '002'
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = ls_clients-Telephone )
                        %element-Telephone = if_abap_behv=>mk-on ) TO reported-clients.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
