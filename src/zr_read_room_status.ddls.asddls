@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Domain Reader'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZR_READ_ROOM_STATUS as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:  'ZSTATUS_HOTEL')
{
    @UI.hidden: true
    key domain_name,
    @UI.hidden: true    
    key value_position,
    @Semantics.language: true
    @UI.hidden: true    
    key language,
    value_low,
    @Semantics.text: true
    @UI.hidden: true    
    text
}
