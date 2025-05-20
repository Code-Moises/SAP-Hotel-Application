@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reservations Bo view'
define view entity ZR_RESERVATIONS 
    as select from zreservations as Reservations
        association to ZR_CLIENT as _Client on $projection.ClientId = _Client.ClientId
        association to ZR_ROOM as _Rooms on $projection.RoomId = _Rooms.RoomId
        association to parent ZR_HOTEL as _Hotel
            on $projection.HotelId = _Hotel.HotelId
   composition [0..*] of ZR_HOSTS as _Host 
   association [1..1] to ZR_CARDS as _Cards on $projection.ClientId = _Cards.ClientId
   association [0..1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency
{
    key reservation_id as ReservationId,
    hotel_id as HotelId,
    client_id as ClientId,
    room_id as RoomId,
    room_number as RoomNumber,
    card_number as CardNumber,
    start_date as StartDate,
    end_date as EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    total_price as TotalPrice,
    currency_code         as CurrencyCode,
    reservation_status as ReservationStatus,
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
      _Client,
      _Host,
      _Cards,
      _Currency,
      _Rooms
}
