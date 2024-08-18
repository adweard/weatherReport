import weatherInfo from './weatherInfo'
import weatherInfo7 from './weatherInfo7'
export default class weatherHttpModel{
  code:string
  updateTime:string
  fxLink:string
  now:weatherInfo

  constructor() {
    this.code=''
    this.updateTime=''
    this.fxLink=''
    this.now=new weatherInfo()
  }
}

export class weatherHttp7{
  code :string
  updateTime:string
  fxLink:string
  daily:Array<weatherInfo7>

  constructor() {
    this.code=''
    this.updateTime=''
    this.fxLink=''
    this.daily=[]
  }
}