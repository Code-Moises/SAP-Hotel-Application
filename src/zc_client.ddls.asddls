@EndUserText.label: 'Client BO projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

define view entity ZC_CLIENT
    as projection on ZR_CLIENT as Cliente
{
    key ClientId,
    HotelId,
    @Search.defaultSearchElement: true
    Name,
    Email,
    @Consumption.valueHelpDefinition: [{ entity:
    {name: 'ZR_READ_TLFDOMAIN' , element: 'value_low' },
    distinctValues: true
    }]     
    Telephone,
    DniPass,
    CreatedBy,
    CreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,

    
    _Hotel : redirected to parent ZC_HOTEL,
    _Cards : redirected to composition child ZC_CARDS
    
}
