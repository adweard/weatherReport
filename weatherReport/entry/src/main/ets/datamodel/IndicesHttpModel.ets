import indicesInfo from './IndicesInfo'

export default class indicesHttpModel{
  code:string
  updateTime:string
  fxLink:string
  daily:Array<indicesInfo>

  constructor() {
    this.code=''
    this.updateTime=''
    this.fxLink=''
    this.daily=[]
  }
}