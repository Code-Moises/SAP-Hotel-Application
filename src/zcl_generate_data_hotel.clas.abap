CLASS zcl_generate_data_hotel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GENERATE_DATA_HOTEL IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: lv_timestamp TYPE timestampl .
    GET TIME STAMP FIELD lv_timestamp .

    DELETE FROM zhotel.

    DATA lt_hotel TYPE STANDARD TABLE OF zhotel.
    APPEND VALUE #(
        client = sy-mandt
        name = 'Barceló'
        street = 'Avenida del Sol'
        city = 'Málaga'
        street_number = '25'
        stars = 4
        telephone = '952123456'
        created_by = sy-uname
        created_at = lv_timestamp
        local_last_changed_by = sy-uname
        local_last_changed_at = lv_timestamp
        last_changed_at = lv_timestamp
      ) TO lt_hotel.

      APPEND VALUE #(
        client = sy-mandt
        name = 'Madrid Motors'
        street = 'Gran Vía'
        city = 'Madrid'
        street_number = '15'
        stars = 4
        telephone = '913456789'
        created_by = sy-uname
        created_at = lv_timestamp
        local_last_changed_by = sy-uname
        local_last_changed_at = lv_timestamp
        last_changed_at = lv_timestamp
      ) TO lt_hotel.

    INSERT zhotel FROM TABLE @lt_hotel.
    COMMIT WORK.


    out->write( 'Data demo inserted in zconcessionary and zcars.' ).

  ENDMETHOD.
ENDCLASS.
