export default class hourInfo{
  fxTime:string
  temp:string
  icon:string
  text:string
  wind360:string
  windDir:string
  windScale:string
  windSpeed:string
  humidity:string
  pop:string
  precip:string
  pressure:string
  cloud:string
  dew:string

  /*
  "fxTime": "2024-08-01T10:00+08:00",
            "temp": "30",
            "icon": "100",
            "text": "晴",
            "wind360": "347",
            "windDir": "北风",
            "windScale": "1-3",
            "windSpeed": "1",
            "humidity": "68",
            "pop": "7",
            "precip": "0.0",
            "pressure": "922",
            "cloud": "82",
            "dew": "22" */

  constructor() {
    this.fxTime=''
    this.temp=''
    this.icon=''
    this.text=''
    this.wind360=''
    this.windDir=''
    this.windScale=''
    this.windSpeed=''
    this.humidity=''
    this.pop=''
    this.precip=''
    this.pressure=''
    this.cloud=''
    this.dew=''
  }

}