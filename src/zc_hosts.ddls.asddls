@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hosts Bo projection view'
@Search.searchable: true
@Metadata.allowExtensions: true

//It is actually Guests not hosts
define view entity ZC_HOSTS 
    as projection on ZR_HOSTS as Host
{
    key HostId,
    @Search.defaultSearchElement: true
    ClientId,
    ReservationId,
    HotelId,
    CreatedBy,
    CreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    _Client.Name as Name,
    _Client.Email as Email,
    _Client.DniPass as DniPass,
    _Client.Telephone as Telephone,
    
    _Reservation : redirected to parent ZC_RESERVATIONS,
    _Hotel : redirected to ZC_HOTEL
}
