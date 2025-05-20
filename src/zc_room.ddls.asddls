@EndUserText.label: 'Room BO projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

define view entity ZC_ROOM 
    as projection on ZR_ROOM as Room
{
    key RoomId,
    HotelId,
    @Consumption.valueHelpDefinition: [{ entity:
    {name: 'ZV_VH_ROOM_TYPE' , element: 'value_low' },
    distinctValues: true
    }]    
    RoomType,
    @Search.defaultSearchElement: true
    RoomNumber,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    BasePrice,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency'} }]
    CurrencyCode,    
    Attachment,
    MimeType,
    FileName,
    @Consumption.valueHelpDefinition: [{ entity:
    {name: 'ZR_READ_ROOM_STATUS' , element: 'value_low' },
    distinctValues: true
    }]    
    Status,
    CreatedBy,
    CreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    
    _Hotel : redirected to parent ZC_HOTEL,
    _Currency
    
}
