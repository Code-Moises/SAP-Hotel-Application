@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Coches vista BO'
define view entity ZR_CARS
  as select from zcars as Car
    association to parent ZR_CONCESSIONARY as _Concessionary
        on $projection.ConcessionaryId = _Concessionary.ConcessionaryId

{
  key car_id          as CarId,
      concessionary_id  as ConcessionaryId,
      manufacturer_id     as ManufacturerId,
      model            as Model,
      manufacture_date     as ManufactureDate,
      kilometers       as Kilometers,
      fuel_type         as FuelType,
      hybrid           as Hybrid,
      price            as Price,

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
      
      _Concessionary
} 
