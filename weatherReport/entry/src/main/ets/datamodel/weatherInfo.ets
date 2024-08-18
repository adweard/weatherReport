export default class weatherInfo{
  obsTime:string
  temp:string
  feelsLike:string
  icon:string
  text:string
  wind360:string
  windDir:string
  windScale:string
  windSpeed:string
  humidity:string
  precip:string
  pressure:string
  vis:string
  cloud:string
  dew:string

  /*
  "obsTime": "2024-07-29T21:16+08:00",
  "temp": "29",
  "feelsLike": "32",
  "icon": "104",
  "text": "阴",
  "wind360": "225",
  "windDir": "西南风",
  "windScale": "2",
  "windSpeed": "8",
  "humidity": "78",
  "precip": "0.0",
  "pressure": "1000",
  "vis": "30",
  "cloud": "95",
  "dew": "24" */

  constructor() {
    this.obsTime=''
    this.temp=''
    this.feelsLike=''
    this.icon=''
    this.text=''
    this.wind360=''
    this.windDir=''
    this.windScale=''
    this.windSpeed=''
    this.humidity=''
    this.precip=''
    this.pressure=''
    this.vis=''
    this.cloud=''
    this.dew=''
  }

}