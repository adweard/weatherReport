import airInfo from './airInfo'
export default class weatherHttpModel{
  code:string
  updateTime:string
  fxLink:string
  now:airInfo

  constructor() {
    this.code=''
    this.updateTime=''
    this.fxLink=''
    this.now=new airInfo()
  }
}