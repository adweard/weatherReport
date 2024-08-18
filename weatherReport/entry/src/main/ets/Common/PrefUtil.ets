import {Context} from '@ohos.abilityAccessCtrl'
import GlobalContext from './GlobalContext'
import {preferences} from '@kit.ArkData'

const PREFERENCES_NAME = 'CityPreferences';
export class PrefUtil{
  createPreferences(context:Context){
    let codePreference:Function=(()=>{
      let preference:Promise<preferences.Preferences>=preferences.getPreferences(context,'codePreferences')
      return preference
    })
    GlobalContext.getInstance().setValue(PREFERENCES_NAME,codePreference)
  }

  saveCity(key:string,value:Object){
    let codePreferenceGetter :Function= GlobalContext.getInstance().getValue(PREFERENCES_NAME) as Function
    codePreferenceGetter().then( async (preference:preferences.Preferences)=>{
      await preference.put(key,value)
      preference.flush()
    }).catch((err:Error)=>{
      console.error('获取preferences失败,err:'+err)
    })


  }
  async getCity(key:string):Promise<string>{
    let code:string=''
    let codePreferenceGetter: Function = GlobalContext.getInstance().getValue(PREFERENCES_NAME) as Function
    code=await(await codePreferenceGetter()).get(key,code)//传入键与默认值，如果键对应的值为null或非默认类型则返回默认值
    return code
  }

  async hasKey(key:string):Promise<boolean>{
    let codePreferenceGetter:Function=GlobalContext.getInstance().getValue(PREFERENCES_NAME) as Function
    let judge:boolean=await (await codePreferenceGetter()).has(key)
    return judge
  }


  async deleteCity(key:string){
    let codePreferenceGetter:Function=GlobalContext.getInstance().getValue(PREFERENCES_NAME) as Function
    let codePreference:Promise<preferences.Preferences> = await codePreferenceGetter()
    let Pref=await codePreference
    console.info(`删除的代号：${key}`)
    Pref.delete(key).then(()=>{
      Pref.flush().then(()=>{
        console.info('删除持久化完成')
        Pref.has(key).then((ans)=>{
          if(ans){
            console.info('删除城市代码失败')
          }
          else{
            console.info('删除城市代码成功')
          }
        })
      })
    })

  }

  async clearCity(){//清空历史数据
    let codePreferenceGetter:Function=GlobalContext.getInstance().getValue(PREFERENCES_NAME) as Function
    let codePreference:Promise<preferences.Preferences> = await codePreferenceGetter()
    await (await codePreference).clear();
    await (await codePreference).flush();
    console.info('我的键值被删除了！');
  }
}

export default new PrefUtil()