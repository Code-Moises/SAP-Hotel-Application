@Metadata.allowExtensions: true
@EndUserText.label: 'Reservations Bo projection view'
@Search.searchable: true
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZC_RESERVATIONS
    as projection on ZR_RESERVATIONS as Reservations
{
    @Search.defaultSearchElement: true
    key ReservationId,
    HotelId,
    @ObjectModel.text.element: [ 'DniPass' ]
    ClientId,
    @ObjectModel.text.element: [ 'RoomNumber' ]
    RoomId,
    CardNumber,
    StartDate,
    EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TotalPrice,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency'} }]
    CurrencyCode,    
    @Consumption.valueHelpDefinition: [{ entity:
    {name: 'ZR_READ_DOMAIN' , element: 'value_low' },
    distinctValues: true
    }]
    ReservationStatus,
    CreatedBy,
    CreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    _Rooms.RoomNumber as RoomNumber,
    _Client.Email as Email,
    _Client.DniPass as DniPass,
    _Client.Name as Name,
    _Client.Telephone as Telephone,
    _Hotel : redirected to parent ZC_HOTEL,
    _Host : redirected to composition child ZC_HOSTS,
    _Currency
    
}
