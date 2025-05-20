@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Client Cards BO view'
define view entity ZR_CARDS 
    as select from zclient_cards as Cards
        association to parent ZR_CLIENT as _Client
            on $projection.ClientId = _Client.ClientId
        association [1..1] to ZR_HOTEL as _Hotel on $projection.HotelId = _Hotel.HotelId
{
    key client_id as ClientId,
    key card_number as CardNumber,
    card_type as CardType,
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
  _Client,
  _Hotel,
  _Client.HotelId as HotelId
}
