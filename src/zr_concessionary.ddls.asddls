@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Concesionarios vista BO'
define root view entity ZR_CONCESSIONARY
  as select from zconcessionary as Concessionary

  composition [0..*] of ZR_CARS as _Cars
    
{
  key Concessionary.concessionary_id     as ConcessionaryId,

      Concessionary.name               as Name,
      Concessionary.street                as Street,
      Concessionary.city               as City,
      Concessionary.street_number         as StreetNumber,
      Concessionary.country                 as Country,
      Concessionary.zip_code        as ZipCode,
      Concessionary.cif                  as Cif,
      Concessionary.telephone             as Telephone,

  @Semantics.user.createdBy: true
      Concessionary.created_by           as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
      Concessionary.created_at           as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
      Concessionary.local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Concessionary.local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
      Concessionary.last_changed_at       as LastChangedAt,

      _Cars
}
