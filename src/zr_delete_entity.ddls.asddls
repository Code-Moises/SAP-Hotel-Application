@EndUserText.label: 'Delete Abstract Entity'
@Metadata.allowExtensions: true
define abstract entity ZR_DELETE_ENTITY
{
    @Consumption.valueHelpDefinition: [{ entity:
    {name: 'ZR_READ_DOMAIN' , element: 'value_low' },
    distinctValues: true
    }]
    reservation_status    : zstatus_reserv;
}
