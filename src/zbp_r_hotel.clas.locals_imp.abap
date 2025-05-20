CLASS lhc_Hotel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Hotel RESULT result.
    METHODS validatename FOR VALIDATE ON SAVE
      IMPORTING keys FOR hotel~validatename.
    METHODS setdefaultcity FOR DETERMINE ON MODIFY
      IMPORTING keys FOR hotel~setdefaultcity.

    METHODS validatetlf FOR VALIDATE ON SAVE
      IMPORTING keys FOR hotel~validatetlf.

    METHODS deleteall_reservations FOR MODIFY
      IMPORTING keys FOR ACTION hotel~deleteall_reservations.
    METHODS validatestars FOR VALIDATE ON SAVE
      IMPORTING keys FOR hotel~validatestars.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR hotel RESULT result.
    METHODS copyhotel FOR MODIFY
      IMPORTING keys FOR ACTION hotel~copyhotel.


ENDCLASS.

CLASS lhc_Hotel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD ValidateName.
      READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY hotel
        FIELDS ( Name )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_hotels)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    LOOP AT lt_hotels INTO DATA(ls_hotel).
      IF ls_hotel-Name IS INITIAL .
        APPEND VALUE #( %tky = ls_hotel-%tky ) TO failed-hotel.
        APPEND VALUE #( %tky = ls_hotel-%tky
                        %msg = new_message(
                                 id       = 'ZHOTEL_MSG'
                                 number   = '001'
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = ls_hotel-Name )
                        %element-Name = if_abap_behv=>mk-on ) TO reported-hotel.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

METHOD setdefaultcity.
    READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY hotel
        FIELDS ( City )
        WITH CORRESPONDING #( keys )
      RESULT DATA(hotels)
      .

    LOOP AT hotels REFERENCE INTO DATA(ls_hotel).
      IF ls_hotel->City IS INITIAL.
        MODIFY ENTITIES OF ZR_HOTEL IN LOCAL MODE
          ENTITY hotel
            UPDATE FIELDS ( City )
            WITH VALUE #( ( %key = ls_hotel->%key
                            %is_draft = ls_hotel->%is_draft
                            City = 'Málaga' ) ) .
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD ValidateTlf.
      READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY hotel
        FIELDS ( Telephone )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_hotel)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    LOOP AT lt_hotel INTO DATA(ls_hotel).
      IF ls_hotel-Telephone IS NOT INITIAL AND
         NOT ( ls_hotel-Telephone CP '+34*' OR
               ls_hotel-Telephone CP '+49*' ).

        APPEND VALUE #( %tky = ls_hotel-%tky ) TO failed-hotel.

        APPEND VALUE #( %tky = ls_hotel-%tky
                        %msg = new_message(
                                 id       = 'ZHOTEL_MSG'
                                 number   = '002'
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = ls_hotel-Telephone )
                        %element-Telephone = if_abap_behv=>mk-on ) TO reported-hotel.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


    METHOD deleteAll_Reservations.

        DATA(parameter_choice) = keys[ 1 ]-%param-reservation_status.
        DATA(new_hotelId) = keys[ 1 ]-hotelid.

        SELECT * FROM ZRESERVATIONS WHERE reservation_status = @parameter_choice AND
        hotel_id = @new_hotelId
        INTO TABLE @DATA(ZRESERVATIONS_DELE).

        SELECT * FROM ZRESERVATIONS_D WHERE reservationstatus = @parameter_choice AND
        hotelid = @new_hotelId
        INTO TABLE @DATA(ZRESERVATIONS_D_DELE).

        DATA lt_delete_input type table for delete zr_hotel\\reservations.

        lt_delete_input = VALUE #( FOR ls_reservations_dele IN ZRESERVATIONS_DELE
        ( %is_draft = 0 reservationid = ls_reservations_dele-reservation_id ) ).


        MODIFY ENTITIES OF ZR_HOTEL IN LOCAL MODE
            ENTITY Reservations
            DELETE FROM lt_delete_input
            FAILED DATA(lt_failed)
           REPORTED DATA(lt_reported).

       lt_delete_input = VALUE #( FOR ls_reservations_dele_d IN ZRESERVATIONS_D_DELE
       ( %is_draft = 1 reservationid = ls_reservations_dele_d-reservationid ) ).


        MODIFY ENTITIES OF ZR_HOTEL IN LOCAL MODE
            ENTITY Reservations
            DELETE FROM lt_delete_input

            FAILED lt_failed
           REPORTED lt_reported.

    ENDMETHOD.

  METHOD ValidateStars.
        READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY hotel
        FIELDS ( Stars )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_hotels)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    LOOP AT lt_hotels INTO DATA(ls_hotel).
      IF ls_hotel-Stars > 5 OR ls_hotel-Stars < 1 .
        APPEND VALUE #( %tky = ls_hotel-%tky ) TO failed-hotel.
        APPEND VALUE #( %tky = ls_hotel-%tky
                        %msg = new_message(
                                 id       = 'ZHOTEL_MSG'
                                 number   = '010'
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = ls_hotel-Stars )
                        %element-Stars = if_abap_behv=>mk-on ) TO reported-hotel.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD copyHotel.
    DATA:
      hotels       TYPE TABLE FOR CREATE ZR_HOTEL\\hotel.

    READ TABLE keys WITH KEY %cid = '' INTO DATA(key_with_inital_cid).
    ASSERT key_with_inital_cid IS INITIAL.

    READ ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY hotel
       ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(hotel_read_result)
    FAILED failed.

    LOOP AT hotel_read_result ASSIGNING FIELD-SYMBOL(<hotel>).
      APPEND VALUE #( %cid      = keys[ KEY entity %key = <hotel>-%key ]-%cid
                      %is_draft = keys[ KEY entity %key = <hotel>-%key ]-%param-%is_draft
                      %data     = CORRESPONDING #( <hotel> EXCEPT HotelId )
                   )
        TO hotels ASSIGNING FIELD-SYMBOL(<new_hotel>).
    ENDLOOP.

    " create new BO instance
    MODIFY ENTITIES OF ZR_HOTEL IN LOCAL MODE
      ENTITY hotel
        CREATE FIELDS ( City Telephone StreetNumber
                        Street Stars Name )
          WITH hotels
      MAPPED DATA(mapped_create).

    " set the new BO instances
    mapped-hotel   =  mapped_create-hotel .
  ENDMETHOD.

ENDCLASS.
