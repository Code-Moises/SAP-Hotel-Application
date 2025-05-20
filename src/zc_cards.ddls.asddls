@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Client Cards BO projection view'
@Search.searchable: true
@Metadata.allowExtensions: true

define view entity ZC_CARDS 
    as projection on ZR_CARDS
{
    key ClientId,
    @Search.defaultSearchElement: true 
    key CardNumber,
    HotelId,
    CardType,
    CreatedBy,
    CreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    
    _Client : redirected to parent ZC_CLIENT,
    _Hotel : redirected to ZC_HOTEL
}
