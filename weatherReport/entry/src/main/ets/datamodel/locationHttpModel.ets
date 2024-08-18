import locationInfo from './locationInfo'

export default class locationHttpModel{
  code:string
  location:Array<locationInfo>

  constructor() {
    this.code=''
    this.location=[]
  }
}