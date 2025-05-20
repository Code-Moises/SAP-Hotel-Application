@EndUserText.label: 'Value Help for Room Id'
@Search.searchable: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZV_VH_ROOM_IDs 
    as select from zrooms
{
    @Search.defaultSearchElement: true
    key room_id   as RoomId,
    room_type as RoomType,
    room_number as RoomNumber
}
