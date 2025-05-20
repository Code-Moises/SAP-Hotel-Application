@EndUserText.label: 'Hotel BO projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

@ObjectModel.semanticKey: ['HotelId']

define root view entity ZC_HOTEL
  provider contract transactional_query 
    as projection on ZR_HOTEL as Hotel
{
    key HotelId,
    @Search.defaultSearchElement: true
    Name,
    Street,
    StreetNumber,
    City,
    @Consumption.valueHelpDefinition: [{ entity:
    {name: 'ZR_READ_STARS' , element: 'value_low' },
    distinctValues: true
    }]    
    Stars,
    @Consumption.valueHelpDefinition: [{ entity:
    {name: 'ZR_READ_TLFDOMAIN' , element: 'value_low' },
    distinctValues: true
    }]    
    Telephone,
    CreatedBy,
    CreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    
    _Rooms : redirected to composition child ZC_ROOM,
    _Reservations : redirected to composition child ZC_RESERVATIONS,
    _Clients : redirected to composition child ZC_CLIENT
}
