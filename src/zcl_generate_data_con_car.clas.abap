CLASS zcl_generate_data_con_car DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GENERATE_DATA_CON_CAR IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: lv_timestamp TYPE timestampl .
    GET TIME STAMP FIELD lv_timestamp .

    DELETE FROM zcars.
    DELETE FROM zconcessionary.

    DATA lt_concessionary TYPE STANDARD TABLE OF zconcessionary.
    APPEND VALUE #(
        client = sy-mandt
        name = 'Auto Málaga'
        street = 'Avenida del Sol'
        city = 'Málaga'
        street_number = '25'
        country = 'España'
        zip_code = '29001'
        cif = 'B12345678'
        telephone = '952123456'
        created_by = sy-uname
        created_at = lv_timestamp
        local_last_changed_by = sy-uname
        local_last_changed_at = lv_timestamp
        last_changed_at = lv_timestamp
      ) TO lt_concessionary.

      APPEND VALUE #(
        client = sy-mandt
        name = 'Madrid Motors'
        street = 'Gran Vía'
        city = 'Madrid'
        street_number = '15'
        country = 'España'
        zip_code = '28013'
        cif = 'B87654321'
        telephone = '913456789'
        created_by = sy-uname
        created_at = lv_timestamp
        local_last_changed_by = sy-uname
        local_last_changed_at = lv_timestamp
        last_changed_at = lv_timestamp
      ) TO lt_concessionary.

    INSERT zconcessionary FROM TABLE @lt_concessionary.
    COMMIT WORK.

    DATA lt_cars TYPE STANDARD TABLE OF zcars.
    APPEND VALUE #(
        client = sy-mandt
        manufacturer_id = 'F001'
        model = 'Model X'
        manufacture_date = '20220101'
        kilometers = 1000
        fuel_type = 'GASOLINE'
        hybrid = 'X'
        price = '55000'
        created_by = sy-uname
        created_at = lv_timestamp
        local_last_changed_by = sy-uname
        local_last_changed_at = lv_timestamp
        last_changed_at = lv_timestamp
      ) TO lt_cars.


      APPEND VALUE #(
       client = sy-mandt
       manufacturer_id = 'F002'
       model = 'Model Y'
       manufacture_date = '20220201'
       kilometers = 5000
       fuel_type = 'DIESEL'
       hybrid = 'X'
       price = '42000'
       created_by = sy-uname
       created_at = lv_timestamp
       local_last_changed_by = sy-uname
       local_last_changed_at = lv_timestamp
       last_changed_at = lv_timestamp
      ) TO lt_cars.

      APPEND VALUE #(
       client = sy-mandt
       manufacturer_id = 'F001'
       model = 'EcoRide'
       manufacture_date = '20220301'
       kilometers = 0
       fuel_type = 'ELECTRIC'
       hybrid = ' '
       price = '48000'
       created_by = sy-uname
       created_at = lv_timestamp
       local_last_changed_by = sy-uname
       local_last_changed_at = lv_timestamp
       last_changed_at = lv_timestamp
      ) TO lt_cars.

    INSERT zcars FROM TABLE @lt_cars.
    COMMIT WORK.

    out->write( 'Data demo inserted in zconcessionary and zcars.' ).

  ENDMETHOD.
ENDCLASS.
