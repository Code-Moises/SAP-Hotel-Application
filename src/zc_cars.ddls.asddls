@EndUserText.label: 'Coches BO projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

define view entity ZC_CARS 
    as projection on  ZR_CARS as Cars
{
    key CarId,
    ConcessionaryId,
    ManufacturerId,
    @Search.defaultSearchElement: true
    Model,
    ManufactureDate,
    Kilometers,
    FuelType,
    Hybrid,
    Price,
    CreatedBy,
    CreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    
    _Concessionary : redirected to parent ZC_CONCESSIONARY
}
