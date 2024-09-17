import CommonConstants from './CommonConstants'
import PrefUtil from './PrefUtil'
import Queue from './QueueUtil'

export default class historyHelper{
  static cityKeys:Array<string>=CommonConstants.CITY_KEY
  static queue=new Queue<string>()

  static async addHistory(city:string){
    try{
      for(let i:number=0;i<historyHelper.cityKeys.length;i++){
        if( await PrefUtil.hasKey(historyHelper.cityKeys[i]) ){
          if(city == await PrefUtil.getCity(historyHelper.cityKeys[i]))
            throw new Error()
        }
      }
      if(historyHelper.queue.size()==5){
        await PrefUtil.deleteCity(historyHelper.queue.front()!)
        historyHelper.queue.dequeue()
      }
      for(let i:number=0;i<5;i++){
        if( !await PrefUtil.hasKey(historyHelper.cityKeys[i]) ){
          PrefUtil.saveCity(historyHelper.cityKeys[i],city)
          historyHelper.queue.enqueue(historyHelper.cityKeys[i])
          break
        }
      }
    }
    catch(err){
      console.info('city already exists!')
    }

  }
  static async getHistory():Promise<Array<string>>{
    const cityCodeArray:Array<string>=[]
    if(historyHelper.queue.size()==0){
      return cityCodeArray
    }
    for (let i = 0; i < historyHelper.queue.size(); i++) {
      if (await PrefUtil.hasKey(historyHelper.cityKeys[i])) {
        const cityCode=await PrefUtil.getCity(historyHelper.cityKeys[i])
        console.info('获取的历史信息'+cityCode+"  "+historyHelper.cityKeys[i])
        cityCodeArray.push(cityCode)
      }
    }
    return cityCodeArray
  }

  static async InitQueue(){
    for (let i = 0; i < historyHelper.cityKeys.length; i++) {
      if (await PrefUtil.hasKey(historyHelper.cityKeys[i])) {
        historyHelper.queue.enqueue(historyHelper.cityKeys[i]);
      }
    }
  }

  static async clearHistory(){
    PrefUtil.clearCity().then(()=>{
      let count=historyHelper.queue.size()
      for(let i:number=0;i<count;i++){
        historyHelper.queue.dequeue()
      }
    })
  }

  static async deleteHistory(key:string){
    for(let i:number=0;i<5;i++){
      if( await PrefUtil.hasKey(historyHelper.cityKeys[i]) ){
        if(key === await PrefUtil.getCity(historyHelper.cityKeys[i])){
          await PrefUtil.deleteCity(historyHelper.cityKeys[i])
          break
        }
      }
      else{
        console.info('不存在键值')
      }
    }

    let count=historyHelper.queue.size()
    for(let i:number=0;i<count;i++){
      historyHelper.queue.dequeue()
    }
    historyHelper.InitQueue()

  }
}