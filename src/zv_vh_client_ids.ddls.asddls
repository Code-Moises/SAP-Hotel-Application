@EndUserText.label: 'Value Help for Client Cards'
@Search.searchable: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZV_VH_CLIENT_IDs 
    as select from zclient
{
    @Search.defaultSearchElement: true
    key client_id   as ClientId,
    name as Name,
    dni_pass as DniPass
}
