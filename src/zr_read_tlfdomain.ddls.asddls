@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Domain Reader'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_READ_TLFDOMAIN as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:  'ZTLF')
{
    @UI.hidden: true
    key domain_name,
    @UI.hidden: true    
    key value_position,
    @UI.hidden: true    
    @Semantics.language: true
    key language,
    value_low,
    @Semantics.text: true
    text
}
