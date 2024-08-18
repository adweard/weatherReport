import { getIndicesResult, getWeatherResult ,getAirResult, getWeatherResult7, getHourResult, getCityLocation} from '../Common/HttpUtil';
import {getLocation} from '../Common/LocationUtil'
import CommonConstants from '../Common/CommonConstants'
import weatherInfo from '../datamodel/weatherInfo'
import weatherInfo7 from '../datamodel/weatherInfo7'
import indicesInfo from '../datamodel/IndicesInfo'
import airInfo from  '../datamodel/airInfo'
import hourInfo from '../datamodel/hourInfo'
import locationInfo from '../datamodel/locationInfo'
import weatherCard from '../datamodel/weatherCard'
import router from '@ohos.router';
import {curves} from '@kit.ArkUI'
import historyHelper from '../Common/historyHelper'
import Queue from '../Common/QueueUtil';
import getPixelMap from '../Common/ImageUtil'
import { image } from '@kit.ImageKit';
import calculateMinutes from '../Common/TimeHelper'



@Entry
@Component
struct Index {
  @State publish:string=''
  @State temp:string=''
  @State text:string=''
  @State windDir:string=''
  @State windScale:string=''
  @State category:string=''
  @State pm2p5:string=''
  @State location:string=''
  @State humidity:string=''
  @State pressure:string=''
  @State adm2:string='西安'
  @State adm1:string='陕西省'
  @State searchText:string=''
  @State textError:string=''
  @State isPresent: boolean = false
  @State queue:Queue<string>=new Queue<string>()

  @State cityCode:Array<string>=[]

  @State indicesName:Array<string>=[]
  @State indicesLevel:Array<string>=[]
  @State indicesCate:Array<string>=[]
  @State indicesType:Array<string>=[]
  @State indicesText:Array<string>=[]
  @State hourFxTimeArray:Array<string>=[]
  @State hourTempArray:Array<string>=[]
  @State hourIconArray:Array<string>=[]
  @State hourTextArray:Array<string>=[]
  @State weatherCardArray:Array<weatherCard>=[]

  @State fxDateArray:Array<string>=[]
  @State moonrise:Array<string>=[]
  @State moonset:Array<string>=[]
  @State moonPhase:Array<string>=[]
  @State moonPhaseIcon:Array<string>=[]
  @State tempMinArray:Array<string>=[]
  @State tempMaxArray:Array<string>=[]
  @State textDayArray:Array<string>=[]

  @State hourData:Array<hourInfo>=[]

  @State weatherLongData:Array<weatherInfo7>=[]
  @State indicesData:Array<indicesInfo>=[]

  @State flag: boolean = true;
  @State check: boolean = false
  @State isShow: Array<boolean> = [false,false,false,false,false,false]
  @State isRefreshing: boolean = false


  minTemp:number=0
  maxTemp:number=0
  obsTime:string=''
  weatherData=new weatherInfo()
  airData=new airInfo()
  locationData:Array<locationInfo>=[]

  layOutOptions:GridLayoutOptions= {
    regularSize:[1,1],
    irregularIndexes:[4]
  }


  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private contextForMoon:CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private contextArray: Array<CanvasRenderingContext2D> = [
    new CanvasRenderingContext2D(this.settings),
    new CanvasRenderingContext2D(this.settings),
    new CanvasRenderingContext2D(this.settings),
    new CanvasRenderingContext2D(this.settings),
    new CanvasRenderingContext2D(this.settings),
    new CanvasRenderingContext2D(this.settings),
    new CanvasRenderingContext2D(this.settings)]



  min(arr:Array<string>){
    let numArray:Array<number>=[]
    for(let i=0;i<arr.length;i++){
      numArray[i]=Number(arr[i])
    }
    this.minTemp=Math.min(...numArray)
  }

  max(arr:Array<string>){
    let numArray:Array<number>=[]
    for(let i=0;i<arr.length;i++){
      numArray[i]=Number(arr[i])
    }
    this.maxTemp=Math.max(...numArray)
  }

  matchTime(obsTime:string):string{
    const regex = /T(\d{2}:\d{2})/;

    // 待匹配的字符串
    const dateTimeString = obsTime;

    // 使用正则表达式搜索字符串
    const match = dateTimeString.match(regex);

    // 检查是否找到了匹配项
    if (match !== null && match.length > 1) {
      // match[0] 是整个匹配的字符串（包括T），match[1] 是捕获组（即时间部分）
      const time = match[1];
      console.log(time); // 输出: 20:30
      return time
    } else {
      console.log("没有找到时间部分");
      return '暂无发布时间数据'
    }
  }


  matchImage(textDay:string):Resource{
    if(textDay==='晴'){
      return $r('app.media.sunny')
    } else if(textDay==='小雨'){
      return $r('app.media.smallRain')
    }else if(textDay==='中雨'){
      return $r('app.media.mediumRain')
    }else if(textDay==='大雨'){
      return $r('app.media.bigRain')
    }else if(textDay==='暴雨'){
      return $r('app.media.heavyRain')
    }else if(textDay==='阴'){
      return $r('app.media.yin')
    }else{
      return $r('app.media.cloudy')
    }
  }

  async getHistory(){
    this.cityCode=await historyHelper.getHistory()
    console.info('代码：'+this.cityCode[0])
  }
  clearHistory(){//全删
    historyHelper.clearHistory().then(()=>{
      this.getHistory()
      this.weatherCardArray=[]
    })
  }
  deleteHistory(key:string){//滑动删除
    console.info(`要删除的城市代码：${key}`)
    historyHelper.deleteHistory(key).then(()=>{
      this.getHistory()
    })
  }
  refresh(){
    this.check=false
    console.info(this.location+'现在的地址！')
    getWeatherResult(CommonConstants.url, this.location).then((serverData) => {
      this.weatherData = serverData.now
      this.obsTime = this.weatherData.obsTime
      this.temp = this.weatherData.temp
      this.text = this.weatherData.text
      this.windDir = this.weatherData.windDir
      this.windScale = this.weatherData.windScale
      this.humidity = this.weatherData.humidity
      this.pressure = this.weatherData.pressure
      this.publish=this.matchTime(this.obsTime)
    }).then(()=>{
      getWeatherResult7(this.location).then((serverData) => {
        this.weatherLongData = serverData.daily
        for(let i=0;i<this.weatherLongData.length;i++){
          this.fxDateArray[i]=this.weatherLongData[i].fxDate
          this.moonrise[i]=this.weatherLongData[i].moonrise
          this.moonset[i]=this.weatherLongData[i].moonset
          this.moonPhase[i]=this.weatherLongData[i].moonPhase
          this.moonPhaseIcon[i]=this.weatherLongData[i].moonPhaseIcon
          this.tempMinArray[i]=this.weatherLongData[i].tempMin
          this.tempMaxArray[i]=this.weatherLongData[i].tempMax
          this.textDayArray[i]=this.weatherLongData[i].textDay
        }
        this.min(this.tempMinArray)
        this.max(this.tempMaxArray)
        this.check=true
      }).then(()=>{
        getCityLocation(this.location).then(serverData=>{
          this.locationData=serverData.location
          this.adm2=this.locationData[0].adm2
          this.adm1=this.locationData[0].adm1
        })
        historyHelper.addHistory(this.searchText).then(async ()=>{
          this.getHistory().then(async ()=>{
            this.weatherCardArray=[]
            for (let i = 0; i < this.cityCode.length; i++) {
              console.info('weatherCardArray被初始化了!!! ' + this.cityCode[i]);

              try {
                const nowWeather = await getWeatherResult(CommonConstants.url, this.cityCode[i]);
                let text = nowWeather.now.text;
                let temp = nowWeather.now.temp;

                const dailyWeather = await getWeatherResult7(this.cityCode[i]);
                let tempMax = dailyWeather.daily[i].tempMax
                let tempMin = dailyWeather.daily[i].tempMin

                const locationData = await getCityLocation(this.cityCode[i]);
                let adm2 = locationData.location[0].adm2;
                let adm1 = locationData.location[0].adm1;
                let cityCode = locationData.location[0].id;
                this.weatherCardArray.push({text,temp,tempMax,tempMin,adm2,adm1,cityCode })

                console.info('我被初始化了！ ' + this.weatherCardArray[i].text);
                this.isRefreshing = false
              } catch (error) {
                console.error('Error updating weather card:', error);
              }
            }

          })

        })

      })
    })

    getHourResult(this.location).then((serverData)=>{
      this.hourData = serverData.hourly
      for(let i=0;i<this.hourData.length;i++){
        this.hourFxTimeArray[i]=this.hourData[i].fxTime
        this.hourTempArray[i]=this.hourData[i].temp
        this.hourIconArray[i]=this.hourData[i].icon
        this.hourTextArray[i]=this.hourData[i].text
      }
    })


    getIndicesResult(this.location).then((serverData) => {
      this.indicesData = serverData.daily
      for(let i=0;i<this.indicesData.length;i++){
        this.indicesName[i]= this.indicesData[i].name
        this.indicesLevel[i] = this.indicesData[i].level
        this.indicesCate[i] = this.indicesData[i].category
        this.indicesType[i] = this.indicesData[i].type
        this.indicesText[i] = this.indicesData[i].text
      }

    })
    getAirResult(this.location).then((serverData) => {
      this.airData = serverData.now
      this.category = this.airData.category
      this.pm2p5 = this.airData.pm2p5
    })


  }
  aboutToAppear() {
    getLocation().then((locData) => {
      this.location = `${locData.longitude},${locData.latitude}`
      console.info(`I did ${this.location}`)

      historyHelper.InitQueue().then(async ()=>{
        this.queue=historyHelper.queue
        this.getHistory().then(async ()=>{
          this.weatherCardArray=[]
          console.info('cityCode被初始化了!!!'+ this.cityCode[0])
          for (let i = 0; i < this.cityCode.length; i++) {
            console.info('weatherCardArray被初始化了!!! ' + this.cityCode[i]);

            try {
              const nowWeather = await getWeatherResult(CommonConstants.url, this.cityCode[i]);
              let text = nowWeather.now.text;
              let temp = nowWeather.now.temp;

              const dailyWeather = await getWeatherResult7(this.cityCode[i]);
              let tempMax = dailyWeather.daily[i].tempMax
              let tempMin = dailyWeather.daily[i].tempMin

              const locationData = await getCityLocation(this.cityCode[i]);
              let adm2 = locationData.location[0].adm2;
              let adm1 = locationData.location[0].adm1;
              let cityCode = locationData.location[0].id;
              this.weatherCardArray.push({text,temp,tempMax,tempMin,adm2,adm1,cityCode })

              console.info('我被初始化了！ ' + this.weatherCardArray[i].text);
            } catch (error) {
              console.error('Error updating weather card:', error);
            }
          }

        })

      })
      getWeatherResult(CommonConstants.url, this.location).then((serverData) => {
        this.weatherData = serverData.now
        this.obsTime = this.weatherData.obsTime
        this.temp = this.weatherData.temp
        this.text = this.weatherData.text
        this.windDir = this.weatherData.windDir
        this.windScale = this.weatherData.windScale
        this.humidity = this.weatherData.humidity
        this.pressure = this.weatherData.pressure
        this.publish=this.matchTime(this.obsTime)
      }).then(()=>{
        getWeatherResult7(this.location).then((serverData) => {
          this.weatherLongData = serverData.daily
          for(let i=0;i<this.weatherLongData.length;i++){
            this.fxDateArray[i]=this.weatherLongData[i].fxDate
            this.moonrise[i]=this.weatherLongData[i].moonrise
            this.moonset[i]=this.weatherLongData[i].moonset
            this.moonPhase[i]=this.weatherLongData[i].moonPhase
            this.moonPhaseIcon[i]=this.weatherLongData[i].moonPhaseIcon
            this.tempMinArray[i]=this.weatherLongData[i].tempMin
            this.tempMaxArray[i]=this.weatherLongData[i].tempMax
            this.textDayArray[i]=this.weatherLongData[i].textDay
          }
          this.min(this.tempMinArray)
          this.max(this.tempMaxArray)
          this.check=true
          console.info("Did I make it:"+`${this.check}`)
        })
      })

      getHourResult(this.location).then((serverData)=>{
        this.hourData = serverData.hourly
        for(let i=0;i<this.hourData.length;i++){
          this.hourFxTimeArray[i]=this.hourData[i].fxTime
          this.hourTempArray[i]=this.hourData[i].temp
          this.hourIconArray[i]=this.hourData[i].icon
          this.hourTextArray[i]=this.hourData[i].text
        }
      })


      getIndicesResult(this.location).then((serverData) => {
        this.indicesData = serverData.daily
        for(let i=0;i<this.indicesData.length;i++){
          this.indicesName[i]= this.indicesData[i].name
          this.indicesLevel[i] = this.indicesData[i].level
          this.indicesCate[i] = this.indicesData[i].category
          this.indicesType[i] = this.indicesData[i].type
          this.indicesText[i] = this.indicesData[i].text
        }

      })
      getAirResult(this.location).then((serverData) => {
        this.airData = serverData.now
        this.category = this.airData.category
        this.pm2p5 = this.airData.pm2p5
      })


    })
  }

  build() {
    Column() {
      Row() {
        Column() {
          Text('我的位置')
            .fontSize(40)
            .fontColor(Color.White)
          Text(`${this.adm2}(${this.adm1})`)
            .fontSize(20)
            .fontColor(Color.White)
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
      }
      .justifyContent(FlexAlign.Center)

      Refresh({ refreshing: $$this.isRefreshing}){
        List({ space: 20 }) {
          ListItem() {
            Column() {
              Row() {
                Text(this.temp + "°")
                  .fontSize(80)
                  .fontColor(Color.White)
              }
              .justifyContent(FlexAlign.Center)

              Row() {
                Text('最高')
                  .fontSize(20)
                  .fontColor(Color.White)
                  .width(20)
                  .height(40)
                Text(this.tempMaxArray[0] + '° ')
                  .fontSize(40)
                  .fontColor(Color.White)
                Text('最低')
                  .fontSize(20)
                  .fontColor(Color.White)
                  .width(20)
                  .height(40)
                Text(this.tempMinArray[0] + '°')
                  .fontSize(40)
                  .fontColor(Color.White)
              }
              .justifyContent(FlexAlign.Center)

              Row() {
                Text(this.text)
                  .fontSize(20)
                  .fontColor(Color.White)
              }
              .justifyContent(FlexAlign.Center)
            }
            .alignItems(HorizontalAlign.Center)
          }
          .width('100%')

          ListItem() {
            Column() {
              Row() {
                Text(this.pm2p5 + '-' + this.category)
                  .fontSize(20)
                  .fontColor(Color.White)
                  .width("100%")
                  .padding(10)
              }
              .justifyContent(FlexAlign.Start)

              Row() {
                Canvas(this.context)
                  .width('90%')
                  .height('100%')
                  .onReady(() => {
                    let grad = this.context.createLinearGradient(50, 0, 300, 100)
                    grad.addColorStop(0.0, '#00ff00')
                    grad.addColorStop(0.1, '#fff5da30')
                    grad.addColorStop(0.3, '#fff30c1f')
                    grad.addColorStop(0.5, '#ff6a1fac')
                    grad.addColorStop(1.0, '#ffb01f1f')
                    this.context.fillStyle = grad
                    this.context.fillRect(0, 10, 310, 3)
                  })
              }
              .height(20)
              .justifyContent(FlexAlign.Center)

              Row() {
                Text('当前AQI（CN）为' + this.pm2p5)
                  .fontSize(15)
                  .fontColor(Color.White)
                  .width("100%")
                  .padding(10)
              }
              .justifyContent(FlexAlign.Start)
            }
            .alignItems(HorizontalAlign.Center)
          }
          .width('100%')
          .borderRadius(30)
          .backgroundColor("#ab64adf5")

          ListItemGroup() {

            ListItem() {
              Scroll() {
                Column() {
                  Row() {
                    Text('24小时预报')
                      .fontSize(15)
                      .width("100%")
                      .padding(10)
                      .fontColor("#c1b9d7f5")
                  }
                  .justifyContent(FlexAlign.Start)

                  Divider()
                    .vertical(false)
                    .width('90%')
                    .color("#8f64adf5")
                  List() {
                    ForEach(this.hourData, (item: hourInfo) => {
                      this.hourItem(item.fxTime, item.temp, item.icon)
                    })
                  }
                  .listDirection(Axis.Horizontal)
                  .scrollBar(BarState.Off)
                }

              }
            }
            .width('100%')
            .borderRadius(30)
            .backgroundColor("#ab64adf5")
          }
          .divider({ strokeWidth: 2, color: "#b7c7dcf1" })

          ListItemGroup() {
            ListItem() {
              Scroll() {
                Column() {
                  Row() {
                    Text('未来七天预报')
                      .fontSize(15)
                      .width("100%")
                      .padding(10)
                      .fontColor("#c1b9d7f5")
                  }

                  Divider()
                    .vertical(false)
                    .width('90%')
                    .color("#b7b7d7f8")
                  if (this.flag) {
                    List() {
                      ForEach(this.weatherLongData, (item: weatherInfo7, index: number) => {
                        this.listItem(item.iconDay, item.fxDate, item.tempMin, item.tempMax, index)
                      })
                    }
                    .onClick(() => {
                      this.flag = !this.flag
                    })
                    .width('100%')

                    .transition(TransitionEffect.OPACITY.combine(TransitionEffect.rotate({
                      x: 0,
                      y: 1,
                      z: 0,
                      centerX: '50%',
                      centerY: '50%',
                      angle: 180
                    }).animation({ duration: 1000 })))
                  } else {
                    List() {
                      ForEach(this.weatherLongData, (item: weatherInfo7, index: number) => {
                        this.listItem(item.iconNight, item.fxDate, item.tempMin, item.tempMax, index)
                      })
                    }
                    .onClick(() => {
                      this.flag = !this.flag
                    })
                    .width('100%')
                    .transition(TransitionEffect.OPACITY.combine(TransitionEffect.rotate({
                      x: 0,
                      y: 1,
                      z: 0,
                      centerX: '50%',
                      centerY: '50%',
                      angle: -180
                    }).animation({ duration: 1000 })))
                  }
                }

              }
              .scrollBar(BarState.Off)
            }
            .borderRadius(30)
            .backgroundColor("#ab64adf5")

          }
          .divider({ strokeWidth: 2, color: "#b7c7dcf1" })

          ListItemGroup() {
            ListItem() {
              Grid() {
                GridItem() {
                  Row() {
                    Column() {
                      Image($r('app.media.wind'))
                        .width(40)
                        .height(40)
                      Text("风速")
                    }
                    .width('50%')

                    Column() {
                      Text(`${this.windScale}级`)
                        .fontSize(30)
                        .fontColor(Color.White)
                      Text(`${this.windDir}`)
                        .fontSize(30)
                        .fontColor(Color.White)
                    }
                    .width('50%')
                  }
                  .alignItems(VerticalAlign.Center)
                  .justifyContent(FlexAlign.SpaceEvenly)
                  .onClick(() => {
                    router.pushUrl({
                      url: "pages/WeatherFor7Days"
                    })
                  })
                }
                .borderRadius(30)
                .backgroundColor("#ab64adf5")

                GridItem() {
                  Row() {
                    Column() {
                      Image($r('app.media.pressure'))
                        .width(40)
                        .height(40)
                      Text("气压")
                    }
                    .width('50%')

                    Column() {
                      Text(`${this.pressure}hpa`)
                        .fontSize(30)
                        .fontColor(Color.White)
                    }
                    .width('50%')
                  }
                  .alignItems(VerticalAlign.Center)
                  .justifyContent(FlexAlign.SpaceEvenly)
                }
                .borderRadius(30)
                .backgroundColor("#ab64adf5")

                GridItem() {
                  Row() {
                    Column() {
                      Image($r('app.media.humidity'))
                        .width(40)
                        .height(40)
                      Text("湿度")
                    }
                    .width('50%')

                    Column() {
                      Text(`${this.humidity}%`)
                        .fontSize(30)
                        .fontColor(Color.White)
                    }
                    .width('50%')
                  }
                  .alignItems(VerticalAlign.Center)
                  .justifyContent(FlexAlign.SpaceEvenly)
                }
                .borderRadius(30)
                .backgroundColor("#ab64adf5")

                GridItem() {
                  Row() {
                    Column() {
                      Image($r('app.media.pm2p5'))
                        .width(40)
                        .height(40)
                      Text("AQI")
                    }
                    .width('50%')

                    Column() {
                      Text(`${this.pm2p5}`)
                        .fontSize(30)
                        .fontColor(Color.White)
                      Text(`空气${this.category}`)
                        .fontSize(30)
                        .fontColor(Color.White)
                    }
                    .width('50%')
                  }
                  .alignItems(VerticalAlign.Center)
                  .justifyContent(FlexAlign.SpaceEvenly)
                }
                .borderRadius(20)
                .backgroundColor("#ab64adf5")

              }
              .width('100%')
              .columnsTemplate('1fr 1fr')
              .rowsTemplate('1fr 1fr')
              .columnsGap(10)
              .rowsGap(10)
              .height(300)

            }
          }

          ListItem() {
            Column() {
              Row() {
                Image($r(`app.media.${this.moonPhaseIcon[0]}`))
                  .width(15)
                  .height(15)
                Text(' ' + this.moonPhase[0])
                  .fontSize(15)
                  .fontColor(Color.White)
                  .width('90%')
              }
              .justifyContent(FlexAlign.Start)

              Row() {
                Column({ space: 5 }) {
                  Row() {
                    Text('月升')
                      .fontSize(15)
                      .fontColor(Color.White)
                      .width('30')
                    Blank()
                      .width('30%')
                    Text(this.moonrise[0])
                      .fontSize(15)
                      .fontColor(Color.White)
                      .width('40')

                  }
                  .justifyContent(FlexAlign.SpaceBetween)

                  Divider()
                    .strokeWidth(1)
                    .color('#75c7dcf1')
                    .width('90%')
                  Row() {
                    Text("月落")
                      .fontSize(15)
                      .fontColor(Color.White)
                      .width('30')
                    Blank()
                      .width('30%')
                    Text(this.moonset[0])
                      .fontSize(15)
                      .fontColor(Color.White)
                      .width('40')
                  }
                  .justifyContent(FlexAlign.SpaceBetween)
                }
                .width('55%')

                Row() {
                  if (this.check) {
                    this.moonCanvas(this.moonrise[0], this.moonset[0], this.publish)
                  } else {
                  }

                }
                .width('45%')

              }
              .justifyContent(FlexAlign.SpaceBetween)
            }

          }
          .height(100)
          .borderRadius(20)
          .backgroundColor("#ab64adf5")

          ListItem() {
            Grid() {
              ForEach(this.indicesData, (item: indicesInfo, index: number) => {
                GridItem() {
                  this.indicesItem(item.type, item.category)
                }
                .bindSheet(this.isShow[index], this.sheetBuilder(item.type, item.text, index), {
                  detents: [SheetSize.MEDIUM, SheetSize.LARGE, 200],
                  height: 300,
                  backgroundColor: '#ab1b73c8',
                  blurStyle: BlurStyle.Thick,
                  showClose: true,
                  title: {
                    title: item.name,
                    subtitle: `${this.category} ${this.tempMaxArray[0]}/${this.tempMinArray[0]}`
                  },
                  preferType: SheetType.CENTER,
                  shouldDismiss: ((sheetDismiss: SheetDismiss) => {
                    console.log("bind sheet shouldDismiss")
                    sheetDismiss.dismiss()
                  })
                })
                .onClick(() => {
                  this.isShow[index] = !this.isShow[index]
                })
                .backgroundColor("#ab64adf5")
              })
            }
            .columnsTemplate('1fr 1fr 1fr')
            .rowsTemplate('1fr 1fr')
            .columnsGap(5)
            .rowsGap(5)
            .width('100%')
            .backgroundColor("#40d7d6d5")
            .borderRadius(20)
            .height(200)
          } //天气指数

        }
        .height(690)
        .width('90%')
        .scrollBar(BarState.Off)
      }
      .onRefreshing(()=>{
        getLocation().then((locData) => {
          if(`${locData.longitude},${locData.latitude}`==this.location){
            this.isRefreshing=false
          }
          else{
            this.location = `${locData.longitude},${locData.latitude}`
            this.refresh()
          }
        })
      })

      Row(){
        Image($r('app.media.more'))
          .width(30)
          .height(30)
          .bindContentCover(this.isPresent, this.NavPage(), {
            modalTransition: ModalTransition.NONE,
            onDisappear: () => {
              this.isPresent = !this.isPresent;
            }
          })
          .onClick(() => {
            // 改变状态变量，显示模态界面
            this.isPresent = !this.isPresent;
          })
      }
      .padding({right:20,bottom:10})
      .width('100%')
      .backgroundColor("#ab64adf5")
      .justifyContent(FlexAlign.End)

    }
    .alignItems(HorizontalAlign.Center)
    .backgroundImage($r('app.media.background3'))
    .backgroundImageSize({width:'100%',height:"100%"})
    .backdropBlur(20)
    .width('100%')
    .height(900)


  }

  @Builder
  moonCanvas(moonrise:string,moonset:string,now:string){
    Column(){
      Canvas(this.contextForMoon)
        .width('90%')//103.68
        .height(100)
        .onReady(()=>{
          getPixelMap(getContext(this)).then((pixel)=>{
            let pixelMap=pixel
            let total=calculateMinutes(moonrise,moonset)
            let cur=calculateMinutes(moonrise,now)
            let weight=cur/total
            console.info("this is "+`${total},${cur},${weight}`)
            this.contextForMoon.beginPath()
            this.contextForMoon.lineWidth=1
            this.contextForMoon.strokeStyle = '#fff6c227';
            this.contextForMoon.arc(65,60,50,0,Math.PI,true)
            this.contextForMoon.setLineDash([10,5])
            this.contextForMoon.stroke()
            this.contextForMoon.drawImage(pixelMap,65-50*Math.cos(Math.PI*weight)-20,60-50*Math.sin(Math.PI*weight)-20)
            this.contextForMoon.closePath()
          })

        })
    }
    .width('100%')
  }

  @Builder
  listItem(icon:string,fxDate:string,tempMin:string,tempMax:string,index:number){//7天列表
    ListItem() {
      Column(){
        Row({space:15}) {
          Text(`${fxDate}`)
            .fontSize(20)
            .fontColor(Color.White)
          Image($r(`app.media.${icon}`))
            .width(30)
            .height(30)
          Text(`${tempMin}°`)
            .fontSize(20)
            .fontColor(Color.White)
          Row(){
            Canvas(this.contextArray[index])
              .width('90%')
              .height(10)
              .onReady(() =>{
                let weight:number=50.2/(this.maxTemp-this.minTemp)

                this.contextArray[index].beginPath()
                this.contextArray[index].lineWidth=20
                this.contextArray[index].moveTo((Number(tempMin)-this.minTemp+1)*weight,5)
                this.contextArray[index].lineTo((Number(tempMax)-this.minTemp+1)*weight,5)
                this.contextArray[index].strokeStyle = '#fff38106';
                this.contextArray[index].lineWidth = 10;
                this.contextArray[index].lineCap = 'round';
                this.contextArray[index].lineJoin='round'
                this.contextArray[index].stroke();
                this.contextArray[index].closePath();
              })
              .borderRadius(20)
              .backgroundColor("#8f50a2f3")
          }
          .width('20%')
          .height(10)
          .justifyContent(FlexAlign.Center)

          Text(`${tempMax}°`)
            .fontSize(20)
            .fontColor(Color.White)
        }
        .justifyContent(FlexAlign.Center)
        .padding(10)
        Divider()
          .vertical(false)
          .width('90%')
          .color("#b7b7d7f8")
      }
      .alignItems(HorizontalAlign.Center)

    }
    .width('100%')
  }

  @Builder
  hourItem(fxTime:string,temp:string,icon:string){//24小时列表
    ListItem() {
      Column({space:5}){
        Text(this.matchTime(fxTime.substring(5,fxTime.length)))
          .fontSize(20)
          .fontColor(Color.White)
        Image($r(`app.media.${icon}`))
          .width(20)
          .height(20)
        Text(temp+'°')
          .fontSize(20)
          .fontColor(Color.White)

      }
      .justifyContent(FlexAlign.SpaceEvenly)
      .padding(10)
    }
  }

  @Builder
  indicesItem(type:string,category:string){
    Column({space:10}){
      Image($r(`app.media.${type}`))
        .width(30)
        .height(30)
      Text(category)
        .fontSize(20)
        .fontColor(Color.White)
    }
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
    .padding(10)
  }
  @Builder
  sheetBuilder(type:string,text:string,index:number){
    Column({space:10}){
      Image($r(`app.media.${type}`))
        .width(40)
        .height(40)
      Text(text)
        .fontSize(30)
        .fontColor(Color.White)
    }
    .onClick(()=>{
      this.isShow[index]=!this.isShow[index]
    })
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
    .padding(10)
  }

  @Builder
  NavPage() { //模态转场
    Column({space:10}) {
      Blank()
        .height('5%')
      Row() {
        Text('天气')
          .fontColor(Color.White)
          .fontSize(30)

      }
      .padding(10)
      .justifyContent(FlexAlign.Start)
      .width('100%')

      Row() {
        Image($r("app.media.search"))
          .width(20)
          .height(20)
          .onClick(()=>{
            if(this.searchText===''){
              this.searchText='输入为空'
            }
            else{
              this.location=this.searchText
              this.refresh()
              console.info('我被点了！')
            }
          })
        TextInput({ placeholder: '请输入要查看的城市', text: this.searchText })
          .placeholderColor('#ffb8b7b7')
          .fontColor(Color.White)
          .fontSize(25)
          .onChange((value:string)=>{
            this.searchText=value
          })
      }
      .justifyContent(FlexAlign.Start)
      .padding({left:15})
      .backgroundColor('#ff4c4b4b')
      .width('95%')
      .borderRadius(21)

      Column() {
        Text("历史记录")
          .fontColor(Color.White)
          .fontSize(20)
        List() {
          ForEach(this.weatherCardArray,(item:weatherCard,index:number)=>{
            ListItem(){
              Row(){
                this.cardBuilder(item.adm2,item.adm1,item.text,item.temp,item.tempMin,item.tempMax)
              }
              .onClick(()=>{
                this.location=item.cityCode
                this.refresh()
                this.isPresent = !this.isPresent;
              })
              .margin({bottom:10})
              .borderRadius(20)
              .justifyContent(FlexAlign.Center)
              .width('100%')
            }
            .transition({ type: TransitionType.Delete, opacity: 0 })
            .swipeAction({
              end: {
                onAction: () => {
                  animateTo({ duration: 1000 }, () => {
                    this.weatherCardArray.splice(index, 1)
                    this.deleteHistory(item.cityCode)
                  })
                },
                actionAreaDistance: 56
              }
            })
            .width('100%')
          })
        }
        .width('100%')

        Text("清除历史记录")
          .fontColor(Color.White)
          .fontSize(20)
          .onClick(()=>{
            this.clearHistory()
          })
      }

    }
    .size({width:'100%',height:'100%'})
    .backgroundColor(Color.Black)
    .transition(TransitionEffect.translate({ y: 1000 })
      .animation({ curve: curves.springMotion(0.6, 0.8) }))
  }

  @Builder
  cardBuilder(adm2:string,adm1:string,text:string,temp:string,tempMin:string,tempMax:string){
    Row(){
      Column({space:10}){
        Text(`${adm2} (${adm1})` )
          .fontSize(20)
          .fontColor(Color.White)
        Text(`${text}`)
          .fontSize(20)
          .fontColor(Color.White)
      }
      .alignItems(HorizontalAlign.Start)
      .padding(10)
      Column(){
        Text(`${temp}`)
          .fontSize(40)
          .fontColor(Color.White)
        Text(`${tempMin}/${tempMax}` )
          .fontSize(20)
          .fontColor(Color.White)
      }
      .alignItems(HorizontalAlign.End)
      .padding(10)
    }
    .borderRadius(20)
    .justifyContent(FlexAlign.SpaceBetween)
    .width('90%')
    .backgroundImage($r('app.media.background3'))
    .backgroundImageSize({width:'100%',height:'100%'})
  }

}