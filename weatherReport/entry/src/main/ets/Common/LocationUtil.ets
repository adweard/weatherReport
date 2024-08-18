import {geoLocationManager} from '@kit.LocationKit'
import {BusinessError} from '@kit.BasicServicesKit'
import  globalContext  from './GlobalContext'
import CommonConstants from '../Common/CommonConstants'
import locationData from '../datamodel/locationData'

export async function getLocation():Promise<locationData>{
  let request:geoLocationManager.SingleLocationRequest = {'locatingTimeoutMs': 10000, 'locatingPriority': geoLocationManager.LocatingPriority.PRIORITY_ACCURACY};
  let locData:locationData=new locationData()
  return geoLocationManager.getCurrentLocation(request).then((result) => {
    console.info('current location: ' + JSON.stringify(result));
    let record=JSON.stringify(result)
    let resultJSON:locationData=JSON.parse(record)
    locData.latitude=resultJSON.latitude
    locData.longitude=resultJSON.longitude
    return locData
  })
}

