import hourInfo from './hourInfo'
export default class hourHttpModel{
  code:string
  updateTime:string
  fxLink:string
  hourly:Array<hourInfo>

  constructor() {
    this.code=''
    this.updateTime=''
    this.fxLink=''
    this.hourly=[]
  }
}