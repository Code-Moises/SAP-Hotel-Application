@EndUserText.label: 'Concesionario BO projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

@ObjectModel.semanticKey: ['ConcessionaryId']

define root view entity ZC_CONCESSIONARY
  provider contract transactional_query 
  as projection on ZR_CONCESSIONARY as Concessionary
{
      key ConcessionaryId,
      @Search.defaultSearchElement: true
      Name,
      Street,
      City,
      StreetNumber,
      Country,
      ZipCode,
      Cif,
      Telephone,
      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,

      _Cars : redirected to composition child ZC_CARS
}
