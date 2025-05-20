CLASS lhc_rooms DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS SetDefaultRoomType FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Rooms~SetDefaultRoomType.

    METHODS SetDefaultStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Rooms~SetDefaultStatus.

    METHODS ValidateRoomType FOR VALIDATE ON SAVE
      IMPORTING keys FOR Rooms~ValidateRoomType.

    METHODS ValidateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Rooms~ValidateStatus.
    METHODS setDefaultBasePrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Rooms~setDefaultBasePrice.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Rooms RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Rooms RESULT result.

    METHODS outOfService FOR MODIFY
      IMPORTING keys FOR ACTION Rooms~outOfService RESULT result.
    METHODS available FOR MODIFY
      IMPORTING keys FOR ACTION Rooms~available RESULT result.
    METHODS ValidateRoomNumber FOR VALIDATE ON SAVE
      IMPORTING keys FOR Rooms~ValidateRoomNumber.



ENDCLASS.

CLASS lhc_rooms IMPLEMENTATION.

  METHOD SetDefaultRoomType.
    READ ENTITIES OF zr_hotel IN LOCAL MODE
      ENTITY Rooms
        FIELDS ( RoomType )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_rooms).

    LOOP AT lt_rooms ASSIGNING FIELD-SYMBOL(<fs_room>).
      IF <fs_room>-RoomType IS INITIAL.
        MODIFY ENTITIES OF zr_hotel IN LOCAL MODE
          ENTITY Rooms
            UPDATE
              FIELDS ( RoomType )
              WITH VALUE #( ( %tky = <fs_room>-%tky
                              RoomType = 'DOUBLE' ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.




  METHOD SetDefaultStatus.
    READ ENTITIES OF zr_hotel IN LOCAL MODE
      ENTITY Rooms
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_rooms).

    LOOP AT lt_rooms ASSIGNING FIELD-SYMBOL(<fs_room>).
      IF <fs_room>-Status IS INITIAL.
        MODIFY ENTITIES OF zr_hotel IN LOCAL MODE
          ENTITY Rooms
            UPDATE
              FIELDS ( Status )
              WITH VALUE #( ( %tky = <fs_room>-%tky
                              Status = 'AVAILABLE' ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


METHOD ValidateRoomType.
  READ ENTITIES OF zr_hotel IN LOCAL MODE
    ENTITY Rooms
      FIELDS ( RoomType )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_rooms)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

  LOOP AT lt_rooms INTO DATA(ls_room).
    IF ls_room-RoomType IS NOT INITIAL AND
       NOT ( ls_room-RoomType = 'SINGLE' OR
             ls_room-RoomType = 'DOUBLE' OR
             ls_room-RoomType = 'SUITE' ).

      APPEND VALUE #( %tky = ls_room-%tky ) TO failed-rooms.

      APPEND VALUE #( %tky = ls_room-%tky
                      %msg = new_message(
                               id = 'ZHOTEL_MSG'
                               number = '003'
                               severity = if_abap_behv_message=>severity-error
                               v1 = ls_room-RoomType )
                      %element-RoomType = if_abap_behv=>mk-on ) TO reported-rooms.
    ENDIF.
  ENDLOOP.
ENDMETHOD.

 METHOD ValidateStatus.
  READ ENTITIES OF zr_hotel IN LOCAL MODE
    ENTITY Rooms
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_rooms)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

  LOOP AT lt_rooms INTO DATA(ls_room).
    IF ls_room-Status IS NOT INITIAL AND
       NOT ( ls_room-Status = 'AVAILABLE' OR
             ls_room-Status = 'OUT OF SER' ).

      APPEND VALUE #( %tky = ls_room-%tky ) TO failed-rooms.

      APPEND VALUE #( %tky = ls_room-%tky
                      %msg = new_message(
                               id = 'ZHOTEL_MSG'
                               number = '004'
                               severity = if_abap_behv_message=>severity-error
                               v1 = ls_room-Status )
                      %element-Status = if_abap_behv=>mk-on ) TO reported-rooms.
    ENDIF.
  ENDLOOP.
  ENDMETHOD.

METHOD setDefaultBasePrice.
  READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
    ENTITY Rooms
    FIELDS ( RoomType )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_rooms).

  LOOP AT lt_rooms INTO DATA(ls_room).
    IF ls_room-RoomType = 'SINGLE'.
      MODIFY ENTITIES OF ZR_HOTEL IN LOCAL MODE
        ENTITY Rooms
        UPDATE FIELDS ( BasePrice )
        WITH VALUE #(
          ( %key = ls_room-%key
            %is_draft = ls_room-%is_draft
            BasePrice = '80.00' )
        ).
    ELSEIF ls_room-RoomType = 'DOUBLE'.
      MODIFY ENTITIES OF ZR_HOTEL IN LOCAL MODE
        ENTITY Rooms
        UPDATE FIELDS ( BasePrice )
        WITH VALUE #(
          ( %key = ls_room-%key
            %is_draft = ls_room-%is_draft
            BasePrice = '90.00' )
        ).
    ELSEIF ls_room-RoomType = 'SUITE'.
      MODIFY ENTITIES OF ZR_HOTEL IN LOCAL MODE
        ENTITY Rooms
        UPDATE FIELDS ( BasePrice )
        WITH VALUE #(
          ( %key = ls_room-%key
            %is_draft = ls_room-%is_draft
            BasePrice = '110.00' )
        ).
    ELSE.
        MODIFY ENTITIES OF ZR_HOTEL IN LOCAL MODE
        ENTITY Rooms
        UPDATE FIELDS ( BasePrice )
        WITH VALUE #(
            ( %key = ls_room-%key
              %is_draft = ls_room-%is_draft
              BasePrice = '' )
        ).
    ENDIF.
  ENDLOOP.
ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY Rooms
         FIELDS ( RoomId Status )
         WITH CORRESPONDING #( keys )
       RESULT DATA(rooms)
       FAILED failed.

    result = VALUE #( FOR room IN rooms
                       ( %tky                   = room-%tky

                         %features-%update      = COND #( WHEN room-Status = 'OUT OF SER'
                                                          THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled   )
                           %action-outOfService   = COND #( WHEN room-Status = 'OUT OF SER'
                                                            THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled   )
                           %action-available   = COND #( WHEN room-Status = 'AVAILABLE'
                                                            THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled   )
                      ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

METHOD outOfService.

  MODIFY ENTITIES OF ZR_HOTEL IN LOCAL MODE
    ENTITY Rooms
      UPDATE FIELDS ( Status )
      WITH VALUE #(
        FOR key IN keys
        ( %tky               = key-%tky
          Status = 'OUT OF SER' )
      )
    FAILED failed
    REPORTED reported.

  READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
    ENTITY Rooms
      ALL FIELDS
      WITH CORRESPONDING #( keys )
    RESULT DATA(rooms).

  result = VALUE #(
    FOR room IN rooms
    ( %tky   = room-%tky
      %param = room )
  ).

ENDMETHOD.

METHOD available.
  MODIFY ENTITIES OF ZR_HOTEL IN LOCAL MODE
    ENTITY Rooms
      UPDATE FIELDS ( Status )
      WITH VALUE #(
        FOR key IN keys
        ( %tky               = key-%tky
          Status = 'AVAILABLE' )
      )
    FAILED failed
    REPORTED reported.

  READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
    ENTITY Rooms
      ALL FIELDS
      WITH CORRESPONDING #( keys )
    RESULT DATA(rooms).

  result = VALUE #(
    FOR room IN rooms
    ( %tky   = room-%tky
      %param = room )
  ).
ENDMETHOD.

METHOD ValidateRoomNumber.
  READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
    ENTITY Rooms
    FIELDS ( HotelId RoomId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_rooms)
    FAILED DATA(lc_failed)
    REPORTED DATA(lc_reported).

  LOOP AT lt_rooms INTO DATA(ls_room).
      SELECT COUNT(*) AS count
      FROM zrooms_d
      WHERE hotelid = @ls_room-hotelId
        AND roomnumber = @ls_room-RoomNumber
        AND roomid      <> @ls_room-roomId
      INTO @DATA(lv_count).

    IF lv_count > 0.
      APPEND VALUE #( %tky = ls_room-%tky ) TO failed-rooms.
      APPEND VALUE #(
        %tky = ls_room-%tky
        %msg = new_message(
                  id = 'ZHOTEL_MSG'
                  number = '021'
                  severity = if_abap_behv_message=>severity-error
                  v1 = ls_room-RoomId )
        %element-RoomId = if_abap_behv=>mk-on
      ) TO reported-rooms.
    ENDIF.
  ENDLOOP.
ENDMETHOD.

ENDCLASS.
