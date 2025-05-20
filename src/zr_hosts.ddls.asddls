@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hosts Bo view'

//It is actually Guests not hosts
define view entity ZR_HOSTS 
    as select from zhosts as host
        association to parent ZR_RESERVATIONS as _Reservation
            on $projection.ReservationId = _Reservation.ReservationId
        association [1..1] to ZR_HOTEL as _Hotel on $projection.HotelId = _Hotel.HotelId
        association [0..1] to ZR_CLIENT as _Client on $projection.ClientId = _Client.ClientId
       
{
    key host_id as HostId,
    client_id as ClientId,
    reservation_id as ReservationId,
    hotel_id as HotelId,
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
    _Reservation,
    _Client
}
