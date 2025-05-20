CLASS lhc_host DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS ValidateHostsClients FOR VALIDATE ON SAVE
      IMPORTING keys FOR Host~ValidateHostsClients.
    METHODS ValidateDuplicateGuest FOR VALIDATE ON SAVE
      IMPORTING keys FOR Host~ValidateDuplicateGuest.

ENDCLASS.

CLASS lhc_host IMPLEMENTATION.

METHOD ValidateHostsClients.
  READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
    ENTITY Host
    FIELDS ( ClientId HotelId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_hosts)
    FAILED DATA(lc_failed)
    REPORTED DATA(lc_reported).

  LOOP AT lt_hosts INTO DATA(ls_host).

    IF ls_host-ClientId IS INITIAL OR ls_host-HotelId IS INITIAL.
      CONTINUE.
    ENDIF.

    READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY Clients
      FIELDS ( HotelId )
      WITH VALUE #( ( ClientId = ls_host-ClientId ) )
      RESULT DATA(lt_client)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    READ TABLE lt_client INTO DATA(ls_client) INDEX 1.
    IF ls_client-hotelid <> ls_host-hotelid.
      APPEND VALUE #( %tky = ls_host-%tky ) TO failed-host.
      APPEND VALUE #(
        %tky = ls_host-%tky
        %msg = new_message(
                  id = 'ZHOTEL_MSG'
                  number = '017'
                  severity = if_abap_behv_message=>severity-error
                  v1 = ls_host-Clientid
                  v2 = ls_host-hotelid )
        %element-HotelId = if_abap_behv=>mk-on
      ) TO reported-host.
    ENDIF.
  ENDLOOP.
ENDMETHOD.


METHOD ValidateDuplicateGuest.
  READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
    ENTITY Host
    FIELDS ( ClientId HotelId ReservationId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_hosts)
    FAILED DATA(lc_failed)
    REPORTED DATA(lc_reported).

  LOOP AT lt_hosts INTO DATA(ls_host).
      SELECT COUNT(*) AS count
      FROM zhosts_d
      WHERE clientid = @ls_host-ClientId
        AND reservationid = @ls_host-reservationid
        AND hostid <> @ls_host-HostId
      INTO @DATA(lv_count).

    IF lv_count > 0.
      APPEND VALUE #( %tky = ls_host-%tky ) TO failed-host.
      APPEND VALUE #(
        %tky = ls_host-%tky
        %msg = new_message(
                  id = 'ZHOTEL_MSG'
                  number = '020'
                  severity = if_abap_behv_message=>severity-error
                  v1 = ls_host-Clientid )
        %element-ClientId = if_abap_behv=>mk-on
      ) TO reported-host.
    ENDIF.
  ENDLOOP.
ENDMETHOD.


ENDCLASS.
