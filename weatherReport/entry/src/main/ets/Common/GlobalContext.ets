import locationData from '../datamodel/locationData'
export default class GlobalContext{
  private constructor() {
  }
  public static instance:GlobalContext
  public toolMap:Map<string,Object>=new Map()
  public static getInstance(){
    if(!GlobalContext.instance){
      GlobalContext.instance=new GlobalContext()
      return GlobalContext.instance
    }
    else{
      return GlobalContext.instance
    }
  }
  getValue(key:string){
    return this.toolMap.get(key)
  }
  setValue(key:string,value:Object){
    this.toolMap.set(key,value)
  }
}