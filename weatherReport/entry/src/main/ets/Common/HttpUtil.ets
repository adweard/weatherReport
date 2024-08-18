import {http} from '@kit.NetworkKit'
import weatherHttpModel from '../datamodel/weatherHttpModel'
import {weatherHttp7} from '../datamodel/weatherHttpModel'
import indicesHttpModel from '../datamodel/IndicesHttpModel'
import airHttpModel from '../datamodel/airHttpModel'
import hourHttpModel from '../datamodel/hourHttpModel'
import locationHttpModel from '../datamodel/locationHttpModel'

export function getWeatherResult(url:string,location:string):Promise<weatherHttpModel>{
  let httpRequest=http.createHttp()
  let responseResult=httpRequest.request(
    url,
    {
    method:http.RequestMethod.GET,
      header:{
        'Content-Type':'application/json' },
      extraData:{
      'key':'d65a72a0886447348710e76daadc6cb9',
      'location':location//'108.93,34.17'
    },
    readTimeout:60000,
    connectTimeout:60000
  })
  let result:string=''
  let serverData:weatherHttpModel=new weatherHttpModel()
  return responseResult.then((data)=>{
    console.info(`${data.result}`)
    result=`${data.result}`
    let resultJSON:weatherHttpModel=JSON.parse(result)
    serverData.code=resultJSON.code
    serverData.updateTime=resultJSON.updateTime
    serverData.fxLink=resultJSON.updateTime
    serverData.now=resultJSON.now
    return serverData
  })
}

export function getWeatherResult7(location:string):Promise<weatherHttp7>{
  let httpRequest=http.createHttp()
  let responseResult=httpRequest.request(
    'https://devapi.qweather.com/v7/weather/7d',
    {
      method:http.RequestMethod.GET,
      header:{
        'Content-Type':'application/json' },
      extraData:{
        'key':'d65a72a0886447348710e76daadc6cb9',
        'location':location//'108.93,34.17'
      },
      readTimeout:60000,
      connectTimeout:60000
    })
  let result:string=''
  let serverData:weatherHttp7=new weatherHttp7()
  return responseResult.then((data)=>{
    console.info(`${data.result}`)
    result=`${data.result}`
    let resultJSON:weatherHttp7=JSON.parse(result)
    serverData.code=resultJSON.code
    serverData.updateTime=resultJSON.updateTime
    serverData.fxLink=resultJSON.updateTime
    /*for(let i=0;i<resultJSON.daily.length;i++){
      serverData.daily[i]=resultJSON.daily[i]
    }*/
    serverData.daily=resultJSON.daily

    return serverData
  })
}

export function getHourResult(location:string):Promise<hourHttpModel>{
  let httpRequest=http.createHttp()
  let responseResult=httpRequest.request(
    'https://devapi.qweather.com/v7/weather/24h',
    {
      method:http.RequestMethod.GET,
      header:{
        'Content-Type':'application/json' },
      extraData:{
        'key':'d65a72a0886447348710e76daadc6cb9',
        'location':location//'108.93,34.17'
      },
      readTimeout:60000,
      connectTimeout:60000
    })
  let result:string=''
  let serverData:hourHttpModel=new hourHttpModel()
  return responseResult.then((data)=>{
    console.info(`${data.result}`)
    result=`${data.result}`
    let resultJSON:hourHttpModel=JSON.parse(result)
    serverData.code=resultJSON.code
    serverData.updateTime=resultJSON.updateTime
    serverData.fxLink=resultJSON.updateTime
    serverData.hourly=resultJSON.hourly
    return serverData
  })
}

export function getIndicesResult(location:string):Promise<indicesHttpModel>{
  let httpRequest=http.createHttp()
  let responseResult=httpRequest.request(
    'https://devapi.qweather.com/v7/indices/1d',
    {
      method:http.RequestMethod.GET,
      header:{
        'Content-Type':'application/json' },
      extraData:{
        'key':'d65a72a0886447348710e76daadc6cb9',
        'location':location,//'108.93,34.17'
        'type':'1,2,3,4,5,6'
      },
      readTimeout:60000,
      connectTimeout:60000
    })
  let result:string=''
  let serverData:indicesHttpModel=new indicesHttpModel()
  return responseResult.then((data)=>{
    console.info(`${data.result}`)
    result=`${data.result}`
    let resultJSON:indicesHttpModel=JSON.parse(result)
    serverData.code=resultJSON.code
    serverData.updateTime=resultJSON.updateTime
    serverData.fxLink=resultJSON.updateTime
    serverData.daily=resultJSON.daily

    return serverData
  })
}

export function getAirResult(location:string):Promise<airHttpModel>{
  let httpRequest=http.createHttp()
  let responseResult=httpRequest.request(
    'https://devapi.qweather.com/v7/air/now',
    {
      method:http.RequestMethod.GET,
      header:{
        'Content-Type':'application/json' },
      extraData:{
        'key':'d65a72a0886447348710e76daadc6cb9',
        'location':location,//'108.93,34.17'
        'type':'1,2'
      },
      readTimeout:60000,
      connectTimeout:60000
    })
  let result:string=''
  let serverData:airHttpModel=new airHttpModel()
  return responseResult.then((data)=>{
    console.info(`${data.result}`)
    result=`${data.result}`
    let resultJSON:airHttpModel=JSON.parse(result)
    serverData.code=resultJSON.code
    serverData.updateTime=resultJSON.updateTime
    serverData.fxLink=resultJSON.updateTime
    serverData.now=resultJSON.now
    return serverData
  })
}

export function getCityLocation(locationId:string):Promise<locationHttpModel>{
  let httpRequest =http.createHttp()
  let responseResult =httpRequest.request(
    'https://geoapi.qweather.com/v2/city/lookup',
    {
      method:http.RequestMethod.GET,
      header:{ 'Content-Type':'application/json' },
      extraData:{
        'key':'d65a72a0886447348710e76daadc6cb9',
        'location':locationId
      },
      readTimeout:60000,
      connectTimeout:60000
    })
  let result:string=''
  let serverData:locationHttpModel=new locationHttpModel()
  return responseResult.then((data)=>{
    console.info(`${data.result}`)
    result=`${data.result}`
    let resultJSON:locationHttpModel=JSON.parse(result)
    serverData.code=resultJSON.code
    serverData.location=resultJSON.location
    return serverData
  })
}

