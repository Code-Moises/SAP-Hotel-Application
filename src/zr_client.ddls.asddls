    @AccessControl.authorizationCheck: #NOT_REQUIRED
    @EndUserText.label: 'Client BO view'
    define view entity ZR_CLIENT
    as select from zclient as Cliente
    association to parent ZR_HOTEL as _Hotel
        on $projection.HotelId = _Hotel.HotelId
    composition [0..*] of ZR_CARDS as _Cards
    
    {
      key client_id as ClientId,
      hotel_id as HotelId,
      name as Name,
      email as Email,
      telephone as Telephone,
      dni_pass as DniPass,
      @Semantics.user.createdBy: true
      created_by        as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at        as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at   as LastChangedAt,
      
      _Hotel,
      _Cards  
    }
