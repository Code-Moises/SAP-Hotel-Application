@EndUserText.label: 'Value Help for Client Cards'
@Search.searchable: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZV_VH_CLIENT_CARDS 
  as select from zclient_cards
{
  @Search.defaultSearchElement: true
  key card_number as CardNumber,
  key client_id   as ClientId,
      card_type   as CardType
}
