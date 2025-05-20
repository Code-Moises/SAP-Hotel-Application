@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hotel BO view'
define root view entity ZR_HOTEL
as select from zhotel as Hotel
composition [0..*] of ZR_ROOM as _Rooms
composition [0..*] of ZR_RESERVATIONS as _Reservations
composition [0..*] of ZR_CLIENT as _Clients
{
  key hotel_id as HotelId,
  name as Name,
  street as Street,
  street_number as StreetNumber,
  city as City,
  stars as Stars,
  telephone as Telephone,
  @Semantics.user.createdBy: true
  created_by           as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at           as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at       as LastChangedAt,
  
  _Rooms,
  _Reservations,
  _Clients
}
