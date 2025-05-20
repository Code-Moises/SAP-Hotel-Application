CLASS lhc_reservations DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS SetDefaultReservationStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Reservations~SetDefaultReservationStatus.

    METHODS ValidateReservationStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Reservations~ValidateReservationStatus.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Reservations RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Reservations RESULT result.

    METHODS acceptReservation FOR MODIFY
      IMPORTING keys FOR ACTION Reservations~acceptReservation RESULT result.

    METHODS rejectReservation FOR MODIFY
      IMPORTING keys FOR ACTION Reservations~rejectReservation RESULT result.
    METHODS ValidateDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Reservations~ValidateDate.
    METHODS ValidateHosts FOR VALIDATE ON SAVE
      IMPORTING keys FOR Reservations~ValidateHosts.

    METHODS ValidateCardNumber FOR VALIDATE ON SAVE
      IMPORTING keys FOR Reservations~ValidateCardNumber.
    METHODS deductDiscount FOR MODIFY
      IMPORTING keys FOR ACTION Reservations~deductDiscount RESULT result.
    METHODS setTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Reservations~setTotalPrice.
    METHODS ValidateClient FOR VALIDATE ON SAVE
      IMPORTING keys FOR Reservations~ValidateClient.
    METHODS ValidateRooms FOR VALIDATE ON SAVE
      IMPORTING keys FOR Reservations~ValidateRooms.
    METHODS ValidateReservationClients FOR VALIDATE ON SAVE
      IMPORTING keys FOR Reservations~ValidateReservationClients.
    METHODS ValidateRoomStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Reservations~ValidateRoomStatus.
    METHODS ValidateClientExistance FOR VALIDATE ON SAVE
      IMPORTING keys FOR Reservations~ValidateClientExistance.
    METHODS ValidateRoomsExistance FOR VALIDATE ON SAVE
      IMPORTING keys FOR Reservations~ValidateRoomsExistance.

ENDCLASS.

CLASS lhc_reservations IMPLEMENTATION.

  METHOD SetDefaultReservationStatus.
  READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
    ENTITY Reservations
    FIELDS ( ReservationStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_hotel).

  LOOP AT lt_hotel INTO DATA(ls_hotel).
    IF ls_hotel-ReservationStatus = ''.
      MODIFY ENTITIES OF ZR_HOTEL IN LOCAL MODE
        ENTITY Reservations
        UPDATE FIELDS ( ReservationStatus )
        WITH VALUE #(
          ( %key = ls_hotel-%key
            %is_draft = ls_hotel-%is_draft
            ReservationStatus = 'NEW' )
        ).
    ENDIF.
  ENDLOOP.
  ENDMETHOD.

METHOD ValidateReservationStatus.
    READ ENTITIES OF zr_hotel IN LOCAL MODE
      ENTITY Reservations
        FIELDS ( ReservationStatus )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_reservations)
        FAILED DATA(lt_failed)
        REPORTED DATA(lt_reported).

    LOOP AT lt_reservations INTO DATA(ls_reservation).
      IF ls_reservation-ReservationStatus IS NOT INITIAL AND
         NOT ( ls_reservation-ReservationStatus = 'CONFIRMED' OR
               ls_reservation-ReservationStatus = 'CANCELLED' OR
               ls_reservation-ReservationStatus = 'COMPLETED' )
               .

        APPEND VALUE #( %tky = ls_reservation-%tky ) TO failed-reservations.

        APPEND VALUE #( %tky = ls_reservation-%tky
                        %msg = new_message(
                                 id = 'ZHOTEL_MSG'
                                 number = '005'
                                 severity = if_abap_behv_message=>severity-error
                                 v1 = ls_reservation-ReservationStatus )
                        %element-ReservationStatus = if_abap_behv=>mk-on ) TO reported-reservations.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY Reservations
         FIELDS ( ReservationId ReservationStatus )
         WITH CORRESPONDING #( keys )
       RESULT DATA(reservations)
       FAILED failed.

    result = VALUE #( FOR reservation IN reservations
                       ( %tky                   = reservation-%tky

                         %features-%update      = COND #( WHEN reservation-ReservationStatus = 'CONFIRMED'
                                                          THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled   )
                         %features-%delete      = COND #( WHEN reservation-ReservationStatus = 'NEW'
                                                          THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled   )
                           %action-acceptreservation   = COND #( WHEN reservation-ReservationStatus = 'CONFIRMED'
                                                            THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled   )
                           %action-rejectreservation   = COND #( WHEN reservation-ReservationStatus = 'CANCELLED'
                                                            THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled   )
                      ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

METHOD acceptReservation.

  MODIFY ENTITIES OF ZR_HOTEL IN LOCAL MODE
    ENTITY Reservations
      UPDATE FIELDS ( ReservationStatus )
      WITH VALUE #(
        FOR key IN keys
        ( %tky               = key-%tky
          ReservationStatus = 'CONFIRMED' )
      )
    FAILED failed
    REPORTED reported.

  READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
    ENTITY Reservations
      ALL FIELDS
      WITH CORRESPONDING #( keys )
    RESULT DATA(reservations).

  result = VALUE #(
    FOR reservation IN reservations
    ( %tky   = reservation-%tky
      %param = reservation )
  ).

ENDMETHOD.

METHOD rejectReservation.

  MODIFY ENTITIES OF ZR_HOTEL IN LOCAL MODE
    ENTITY Reservations
      UPDATE FIELDS ( ReservationStatus )
      WITH VALUE #(
        FOR key IN keys
        ( %tky               = key-%tky
          ReservationStatus = 'CANCELLED' )
      )
    FAILED failed
    REPORTED reported.

  READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
    ENTITY Reservations
      ALL FIELDS
      WITH CORRESPONDING #( keys )
    RESULT DATA(reservations).

  result = VALUE #(
    FOR reservation IN reservations
    ( %tky   = reservation-%tky
      %param = reservation )
  ).

ENDMETHOD.

METHOD ValidateDate.
  READ ENTITIES OF zr_hotel IN LOCAL MODE
    ENTITY Reservations
      FIELDS ( startdate enddate ReservationStatus )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_reservations)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

  LOOP AT lt_reservations INTO DATA(ls_reservation).
    IF ls_reservation-ReservationStatus IS NOT INITIAL AND
       ls_reservation-startdate > ls_reservation-enddate.

      APPEND VALUE #( %tky = ls_reservation-%tky ) TO failed-reservations.

      APPEND VALUE #(
        %tky = ls_reservation-%tky
        %msg = new_message(
                  id       = 'ZHOTEL_MSG'
                  number   = '008'
                  severity = if_abap_behv_message=>severity-error
                  v1       = ls_reservation-startdate
                  v2       = ls_reservation-enddate )
        %element-EndDate = if_abap_behv=>mk-on ) TO reported-reservations.

    ENDIF.
  ENDLOOP.
ENDMETHOD.

  METHOD ValidateCardNumber.
      READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY Reservations
      FIELDS ( CardNumber ReservationStatus )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_reservations)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

     LOOP AT lt_reservations INTO DATA(ls_reservation).
      IF ls_reservation-CardNumber IS INITIAL AND ls_reservation-ReservationStatus = 'CONFIRMED' .

        APPEND VALUE #( %tky = ls_reservation-%tky ) TO failed-reservations.

        APPEND VALUE #( %tky = ls_reservation-%tky
                        %msg = new_message(
                                 id = 'ZHOTEL_MSG'
                                 number = '011'
                                 severity = if_abap_behv_message=>severity-error
                                 v1 = ls_reservation-ReservationStatus )
                        %element-ReservationStatus = if_abap_behv=>mk-on ) TO reported-reservations.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

METHOD deductDiscount.
  DATA reservations_for_update TYPE TABLE FOR UPDATE ZR_RESERVATIONS.
   DATA(keys_with_valid_discount) = keys.

   LOOP AT keys_with_valid_discount ASSIGNING FIELD-SYMBOL(<key_with_valid_discount>)
     WHERE %param-discount_percent IS INITIAL OR %param-discount_percent > 100 OR %param-discount_percent <= 0.

     APPEND VALUE #( %tky                       = <key_with_valid_discount>-%tky ) TO failed-reservations.

     APPEND VALUE #( %tky                       = <key_with_valid_discount>-%tky
                     %msg                       = NEW /dmo/cm_flight_messages(
                                                      textid = /dmo/cm_flight_messages=>discount_invalid
                                                      severity = if_abap_behv_message=>severity-error )
                     %element-TotalPrice        = if_abap_behv=>mk-on
                     %op-%action-deductDiscount = if_abap_behv=>mk-on
                   ) TO reported-reservations.

     DELETE keys_with_valid_discount.
   ENDLOOP.

   CHECK keys_with_valid_discount IS NOT INITIAL.

   READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
     ENTITY Reservations
       FIELDS ( TotalPrice )
       WITH CORRESPONDING #( keys_with_valid_discount )
     RESULT DATA(reservations).

   LOOP AT reservations ASSIGNING FIELD-SYMBOL(<reservation>).
     DATA percentage TYPE decfloat16.
     DATA(discount_percent) = keys_with_valid_discount[ key draft %tky = <reservation>-%tky ]-%param-discount_percent.
     percentage =  discount_percent / 100 .
     DATA(reduced_fee) = <reservation>-TotalPrice * ( 1 - percentage ) .

     APPEND VALUE #( %tky       = <reservation>-%tky
                     TotalPrice = reduced_fee
                   ) TO reservations_for_update.
   ENDLOOP.

   MODIFY ENTITIES OF ZR_HOTEL IN LOCAL MODE
     ENTITY Reservations
      UPDATE FIELDS ( TotalPrice )
      WITH reservations_for_update.

   READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
     ENTITY Reservations
       ALL FIELDS WITH
       CORRESPONDING #( reservations )
     RESULT DATA(reservations_with_discount).

  result = VALUE #( FOR reservation IN reservations_with_discount ( %tky   = reservation-%tky
                                                                    %param = reservation ) ).
ENDMETHOD.

  METHOD setTotalPrice.
      READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY Reservations by \_Host
      FIELDS ( ClientId ReservationId )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_host)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

      DATA(count) = lines( lt_host ).

      READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY Reservations
      FIELDS ( RoomId )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_reservation)
      FAILED DATA(lc_failed)
      REPORTED DATA(lc_reported).

      DATA(lv_room_id) = lt_reservation[ 1 ]-roomid.
      IF lv_room_id is initial.
        return.
      ENDIF.

      READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY Rooms
      FIELDS ( RoomType BasePrice )
      WITH VALUE #( ( roomId = lv_room_id ) )
      RESULT DATA(lt_rooms)
      FAILED DATA(lr_failed)
      REPORTED DATA(lr_reported).

      DATA(lv_room_type) = lt_rooms[ 1 ]-RoomType.
      IF lv_room_type is initial.
        return.
      ENDIF.

      DATA(lv_room_price) = lt_rooms[ 1 ]-BasePrice.
      DATA(lv_total_price) = 0.

          CASE lv_room_type.
            WHEN 'DOUBLE'.
                lv_total_price = lv_room_price.
            WHEN 'SINGLE' .
                lv_total_price = lv_room_price.
            WHEN 'SUITE'.
              IF count = 2.
                lv_total_price = '120.00'.
              ELSEIF count = 3.
                lv_total_price = '130.00'.
              ELSE.
                lv_total_price = lv_room_price.
              ENDIF.
          ENDCASE.


    MODIFY ENTITIES OF ZR_HOTEL IN LOCAL MODE
    ENTITY Reservations
    UPDATE FIELDS ( TotalPrice )
    WITH VALUE #(
      FOR reservation IN lt_reservation
      (
        %tky = reservation-%tky
        TotalPrice = lv_total_price
      )
    )
    FAILED DATA(lm_failed)
    REPORTED DATA(lm_reported).
  ENDMETHOD.

 METHOD ValidateHosts.

      READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY Reservations by \_Host
      FIELDS ( ClientId ReservationId )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_host)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

      DATA(count) = lines( lt_host ).

      READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY Reservations
      FIELDS ( RoomId )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_reservation)
      FAILED DATA(lc_failed)
      REPORTED DATA(lc_reported).

      DATA(lv_room_id) = lt_reservation[ 1 ]-roomid.
      If lv_room_id IS INITIAL.
        RETURN.
      ENDIF.

      READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY Rooms
      FIELDS ( RoomType )
      WITH VALUE #( ( roomId = lv_room_id ) )
      RESULT DATA(lt_rooms)
      FAILED DATA(lr_failed)
      REPORTED DATA(lr_reported).

      DATA(lv_room_type) = lt_rooms[ 1 ]-RoomType.
      DATA(ls_reservation) = lt_reservation[ 1 ].


          CASE lv_room_type.
            WHEN 'SINGLE'.
              IF count > 0.
                APPEND VALUE #( %tky = ls_reservation-%tky ) TO failed-reservations.
                APPEND VALUE #(
                  %tky = ls_reservation-%tky
                  %msg = new_message(
                    id      = 'ZHOTEL_MSG'
                    number  = '012'
                    severity = if_abap_behv_message=>severity-error
                    v1      = ls_reservation-ReservationStatus )
                  %element-ReservationStatus = if_abap_behv=>mk-on
                ) TO reported-reservations.
              ENDIF.

            WHEN 'DOUBLE'.
              IF count > 1.
                APPEND VALUE #( %tky = ls_reservation-%tky ) TO failed-reservations.
                APPEND VALUE #(
                  %tky = ls_reservation-%tky
                  %msg = new_message(
                    id      = 'ZHOTEL_MSG'
                    number  = '013'
                    severity = if_abap_behv_message=>severity-error
                    v1      = ls_reservation-ReservationStatus )
                  %element-ReservationStatus = if_abap_behv=>mk-on
                ) TO reported-reservations.
              ENDIF.

            WHEN 'SUITE'.
              IF count > 3.
                APPEND VALUE #( %tky = ls_reservation-%tky ) TO failed-reservations.
                APPEND VALUE #(
                  %tky = ls_reservation-%tky
                  %msg = new_message(
                    id      = 'ZHOTEL_MSG'
                    number  = '014'
                    severity = if_abap_behv_message=>severity-error
                    v1      = ls_reservation-ReservationStatus )
                  %element-ReservationStatus = if_abap_behv=>mk-on
                ) TO reported-reservations.
              ENDIF.
          ENDCASE.
 ENDMETHOD.

  METHOD ValidateClient.
  READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
    ENTITY Reservations
    FIELDS ( ClientId hotelid )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_reservation)
    FAILED DATA(lt_failed_res)
    REPORTED DATA(lt_reported_res).

  SELECT clientid, hotelid FROM zhosts_d INTO TABLE @DATA(lt_host_clients).

  LOOP AT lt_reservation INTO DATA(ls_reservation).
    READ TABLE lt_host_clients
    WITH KEY clientid = ls_reservation-ClientId hotelid = ls_reservation-HotelId
    TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      APPEND VALUE #( %tky = ls_reservation-%tky ) TO failed-reservations.

      APPEND VALUE #(
        %tky = ls_reservation-%tky
        %msg = new_message(
                 id = 'ZHOTEL_MSG'
                 number = '015'
                 severity = if_abap_behv_message=>severity-error
                 v1 = ls_reservation-ClientId )
        %element-ClientId = if_abap_behv=>mk-on ) TO reported-reservations.
    ENDIF.
  ENDLOOP.
  ENDMETHOD.

METHOD ValidateRooms.

  READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
    ENTITY Reservations
    FIELDS ( RoomId HotelId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_reservation)
    FAILED DATA(lc_failed)
    REPORTED DATA(lc_reported).

  LOOP AT lt_reservation INTO DATA(ls_reservation).

    IF ls_reservation-roomid IS INITIAL OR ls_reservation-hotelid IS INITIAL.
      CONTINUE.
    ENDIF.

    READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY Rooms
      FIELDS ( HotelId )
      WITH VALUE #( ( RoomId = ls_reservation-roomid ) )
      RESULT DATA(lt_room)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    READ TABLE lt_room INTO DATA(ls_room) INDEX 1.
    IF ls_room-hotelid <> ls_reservation-hotelid.
      APPEND VALUE #( %tky = ls_reservation-%tky ) TO failed-reservations.
      APPEND VALUE #(
        %tky = ls_reservation-%tky
        %msg = new_message(
                  id = 'ZHOTEL_MSG'
                  number = '016'
                  severity = if_abap_behv_message=>severity-error
                  v1 = ls_reservation-roomid
                  v2 = ls_reservation-hotelid )
        %element-HotelId = if_abap_behv=>mk-on
      ) TO reported-reservations.
    ENDIF.

  ENDLOOP.

ENDMETHOD.


METHOD ValidateReservationClients.
  READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
    ENTITY Reservations
    FIELDS ( ClientId HotelId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_reservation)
    FAILED DATA(lc_failed)
    REPORTED DATA(lc_reported).

  LOOP AT lt_reservation INTO DATA(ls_reservation).

    IF ls_reservation-ClientId IS INITIAL OR ls_reservation-hotelid IS INITIAL.
      CONTINUE.
    ENDIF.

    READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY Clients
      FIELDS ( HotelId )
      WITH VALUE #( ( ClientId = ls_reservation-ClientId ) )
      RESULT DATA(lt_client)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    READ TABLE lt_client INTO DATA(ls_client) INDEX 1.
    IF ls_client-hotelid <> ls_reservation-hotelid.
      APPEND VALUE #( %tky = ls_reservation-%tky ) TO failed-reservations.
      APPEND VALUE #(
        %tky = ls_reservation-%tky
        %msg = new_message(
                  id = 'ZHOTEL_MSG'
                  number = '019'
                  severity = if_abap_behv_message=>severity-error
                  v1 = ls_reservation-Clientid
                  v2 = ls_reservation-hotelid )
        %element-HotelId = if_abap_behv=>mk-on
      ) TO reported-reservations.
    ENDIF.
  ENDLOOP.
ENDMETHOD.

METHOD ValidateRoomStatus.

  READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
    ENTITY Reservations
    FIELDS ( RoomId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_reservations)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

  LOOP AT lt_reservations INTO DATA(ls_reservation).
    IF ls_reservation-roomid IS INITIAL.
      CONTINUE.
    ENDIF.

    READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY Rooms
      FIELDS ( Status )
      WITH VALUE #( ( RoomId = ls_reservation-roomid ) )
      RESULT DATA(lt_rooms)
      FAILED DATA(lr_failed)
      REPORTED DATA(lr_reported).

    READ TABLE lt_rooms INTO DATA(ls_room) INDEX 1.
    IF ls_room-status = 'OUT OF SER'.

      APPEND VALUE #( %tky = ls_reservation-%tky ) TO failed-reservations.

      APPEND VALUE #(
        %tky = ls_reservation-%tky
        %msg = new_message(
                  id = 'ZHOTEL_MSG'
                  number = '018'
                  severity = if_abap_behv_message=>severity-error
                  v1 = ls_reservation-roomid
                )
        %element-RoomId = if_abap_behv=>mk-on
      ) TO reported-reservations.

    ENDIF.
  ENDLOOP.

ENDMETHOD.

  METHOD ValidateClientExistance.
      READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY Reservations
      FIELDS ( ClientId ReservationStatus )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_reservations)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

     LOOP AT lt_reservations INTO DATA(ls_reservation).
      IF ls_reservation-ClientId IS INITIAL AND ls_reservation-ReservationStatus = 'CONFIRMED' .

        APPEND VALUE #( %tky = ls_reservation-%tky ) TO failed-reservations.

        APPEND VALUE #( %tky = ls_reservation-%tky
                        %msg = new_message(
                                 id = 'ZHOTEL_MSG'
                                 number = '022'
                                 severity = if_abap_behv_message=>severity-error
                                 v1 = ls_reservation-ReservationId )
                        %element-ReservationStatus = if_abap_behv=>mk-on ) TO reported-reservations.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD ValidateRoomsExistance.
      READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY Reservations
      FIELDS ( RoomId ReservationStatus )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_reservations)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

     LOOP AT lt_reservations INTO DATA(ls_reservation).
      IF ls_reservation-RoomId IS INITIAL .

        APPEND VALUE #( %tky = ls_reservation-%tky ) TO failed-reservations.

        APPEND VALUE #( %tky = ls_reservation-%tky
                        %msg = new_message(
                                 id = 'ZHOTEL_MSG'
                                 number = '023'
                                 severity = if_abap_behv_message=>severity-error
                                 v1 = ls_reservation-ReservationId )
                        %element-ReservationStatus = if_abap_behv=>mk-on ) TO reported-reservations.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
