@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Room BO view'
define view entity ZR_ROOM
as select from zrooms as Rooms
association to parent ZR_HOTEL as _Hotel
    on $projection.HotelId = _Hotel.HotelId
  association [0..1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency    

{
  key room_id as RoomId,
  hotel_id as HotelId,
  room_type as RoomType,
  room_number as RoomNumber,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  base_price as BasePrice,
  currency_code         as CurrencyCode,
  status as Status,
  @Semantics.largeObject: { mimeType: 'MimeType', 
                            fileName: 'FileName', 
                            acceptableMimeTypes: ['image/png', 'image/jpeg'],
                            contentDispositionPreference: #ATTACHMENT }
  attachment as Attachment,
  @Semantics.mimeType: true
  mime_type as MimeType,
  file_name as FileName,                            
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
  _Currency
}
