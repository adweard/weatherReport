export default class weatherCard{
  adm2:string
  adm1:string
  cityCode:string
  text:string
  temp:string=''
  tempMax: string
  tempMin: string

  constructor() {
    this.adm2=''
    this.adm1=''
    this.cityCode=''
    this.text=''
    this.temp=''
    this.tempMax=''
    this.tempMin=''
  }
}