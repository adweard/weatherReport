import { getIndicesResult, getWeatherResult ,getAirResult, getWeatherResult7} from '../Common/HttpUtil';
import {getLocation} from '../Common/LocationUtil'
import CommonConstants from '../Common/CommonConstants'
import { JSON } from '@kit.ArkTS';
import weatherHttpModel from '../datamodel/weatherHttpModel'
import weatherInfo from '../datamodel/weatherInfo'
import weatherInfo7 from '../datamodel/weatherInfo7'
import indicesInfo from '../datamodel/IndicesInfo'
import airData from  '../datamodel/airInfo'
import locationData from '../datamodel/locationData'
import router from '@ohos.router';
import globalContext from '../Common/GlobalContext'
import { McLineChart, Options } from '@mcui/mccharts'


@Entry
@Component
struct Index {
  @State publish:string=''
  @State temp:string=''
  @State text:string=''
  @State windDir:string=''
  @State windSpeed:string=''
  @State category:string=''
  @State pm2p5:string=''
  @State exercise:string=''
  @State exeLevel:string=''
  @State exeCate:string=''
  @State carWash:string=''
  @State carLevel:string=''
  @State carCate:string=''
  @State location:string=''
  @State humidity:string=''
  @State pressure:string=''
  @State fxDateArray:Array<string>=[]
  @State tempMinArray:Array<string>=[]
  @State tempMaxArray:Array<string>=[]
  @State textDayArray:Array<string>=[]
  @State weatherLongData:Array<weatherInfo7>=[]
  @State seriesOption: Options = new Options({
    xAxis:{
      data:[this.fxDateArray[0],this.fxDateArray[1],this.fxDateArray[2],this.fxDateArray[3],this.fxDateArray[4],this.fxDateArray[5],this.fxDateArray[6]],
      axisLine: { // 轴线样式
        show: false // 是否显示
      },
      axisTick: { // 刻度线配置
        show: false, // 是否显示
        interval: 6, // 与文本的间隔
        length: 4, // 刻度的长度
        lineStyle: {
          color: '#ccc', // 刻度线颜色
          width: 2 // 刻度线宽度
        }
      },
      axisLabel: {  // x轴文本标签样式
        color: '#bf19ff',
        fontWeight: '600',
        fontFamily: 'sans-serif',
        fontSize: 20,
        interval: 1,
        margin: 8,
        overflow: 'truncate'
      },
    },
    yAxis: {
      axisLine: {
        // 轴线样式
        show: false, // 是否显示
      },
      axisTick: {
        // 刻度线配置
        show: false, // 是否显示
        interval: 4, // 与文本的间隔
        length: 1, // 刻度的长度
        lineStyle: {
          color: '#ccc', // 刻度线颜色
          width: 2 // 刻度线宽度
        }
      },
      splitLine: {
        // 坐标轴中的分隔线。
        show: false,
        lineStyle: {
          color: '#4f000000',
          width: 2
        }
      }
    },
    series:[
      {
        name:'最高气温',
        data:[Number(this.tempMaxArray[0]),Number(this.tempMaxArray[1]),Number(this.tempMaxArray[2]),Number(this.tempMaxArray[3]),Number(this.tempMaxArray[4]),Number(this.tempMaxArray[5]),Number(this.tempMaxArray[6])]
      },
      {
        name:'最低气温',
        data:[Number(this.tempMinArray[0]),Number(this.tempMinArray[1]),Number(this.tempMinArray[2]),Number(this.tempMinArray[3]),Number(this.tempMinArray[4]),Number(this.tempMinArray[5]),Number(this.tempMinArray[6])]
      }
    ]
  })

  obsTime:string=''
  weatherData=new weatherInfo()
  indicesData:Array<indicesInfo>=[]
  airData=new airData()


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
  aboutToAppear() {
    getLocation().then((locData) => {
      this.location = `${locData.longitude},${locData.latitude}`
      console.info(`I did ${this.location}`)
      getWeatherResult(CommonConstants.url, this.location).then((serverData) => {
        this.weatherData = serverData.now
        this.obsTime = this.weatherData.obsTime
        this.temp = this.weatherData.temp
        this.text = this.weatherData.text
        this.windDir = this.weatherData.windDir
        this.windSpeed = this.weatherData.windSpeed
        this.humidity = this.weatherData.humidity
        this.pressure = this.weatherData.pressure
        this.publish=this.matchTime(this.obsTime)
      })

      getIndicesResult(this.location).then((serverData) => {
        this.indicesData = serverData.daily
        this.exercise = this.indicesData[0].name
        this.exeLevel = this.indicesData[0].level
        this.exeCate = this.indicesData[0].category

        this.carWash = this.indicesData[1].name
        this.carLevel = this.indicesData[1].level
        this.carCate = this.indicesData[1].category

      })
      getAirResult(this.location).then((serverData) => {
        this.airData = serverData.now
        this.category = this.airData.category
        this.pm2p5 = this.airData.pm2p5
      })
      getWeatherResult7(this.location).then((serverData) => {
        this.weatherLongData = serverData.daily
        for(let i=0;i<this.weatherLongData.length;i++){
          this.fxDateArray[i]=this.weatherLongData[i].fxDate
          this.tempMinArray[i]=this.weatherLongData[i].tempMin
          this.tempMaxArray[i]=this.weatherLongData[i].tempMax
          this.textDayArray[i]=this.weatherLongData[i].textDay
        }
        console.info(`Me ${this.tempMaxArray[0]}`)
        this.seriesOption.setVal({
          xAxis:{
            data:[this.fxDateArray[0],this.fxDateArray[1],this.fxDateArray[2],this.fxDateArray[3],this.fxDateArray[4],this.fxDateArray[5],this.fxDateArray[6]],
            axisLine: { // 轴线样式
              show: false // 是否显示
            },
            axisTick: { // 刻度线配置
              show: false, // 是否显示
              interval: 6, // 与文本的间隔
              length: 4, // 刻度的长度
              lineStyle: {
                color: '#ccc', // 刻度线颜色
                width: 2 // 刻度线宽度
              }
            },
            axisLabel: {  // x轴文本标签样式
              color: '#bf19ff',
              fontWeight: '600',
              fontFamily: 'sans-serif',
              fontSize: 20,
              interval: 1,
              margin: 8,
              overflow: 'truncate'
            },
          },
          yAxis: {
            axisLine: {
              // 轴线样式
              show: false, // 是否显示
            },
            axisTick: {
              // 刻度线配置
              show: false, // 是否显示
              interval: 4, // 与文本的间隔
              length: 1, // 刻度的长度
              lineStyle: {
                color: '#ccc', // 刻度线颜色
                width: 2 // 刻度线宽度
              }
            },
            splitLine: {
              // 坐标轴中的分隔线。
              show: false,
              lineStyle: {
                color: '#4f000000',
                width: 2
              }
            }
          },
          series:[
            {
              name:'最高气温',
              data:[Number(this.tempMaxArray[0]),Number(this.tempMaxArray[1]),Number(this.tempMaxArray[2]),Number(this.tempMaxArray[3]),Number(this.tempMaxArray[4]),Number(this.tempMaxArray[5]),Number(this.tempMaxArray[6])]
            },
            {
              name:'最低气温',
              data:[Number(this.tempMinArray[0]),Number(this.tempMinArray[1]),Number(this.tempMinArray[2]),Number(this.tempMinArray[3]),Number(this.tempMinArray[4]),Number(this.tempMinArray[5]),Number(this.tempMinArray[6])]
            }
          ]
        })
      })

    })
  }

  build() {
  Scroll(){
    Column() {
      Row(){
        Text(this.temp)
          .fontSize(40)
          .fontColor(Color.Black)
          .width('15%')
        Text('°C')
          .fontSize(20)
          .fontColor(Color.Black)
          .width('5%')
        Blank()
          .width('30%')

        Column(){
          Image(this.matchImage(this.text))
            .width('25%')
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)

      }
      Row(){
        Text('西安（当地）')
          .fontSize(15)
          .fontColor(Color.Black)
          .width('30%')
          .margin({left:10})
        Blank()
          .width('70%')
      }
      .justifyContent(FlexAlign.Start)
      Row(){
        Text(this.text+' '+ this.windDir)//天气和风向
          .fontSize(15)
          .fontColor(Color.Black)
          .width('30%')
          .margin({left:10})
        Blank()
          .width('70%')
      }
      .justifyContent(FlexAlign.Start)
      Row(){
        Text("发布时间 "+this.publish)//天气和风向
          .fontSize(15)
          .fontColor(Color.Black)
          .width('30%')
          .margin({left:10})
        Blank()
          .width('70%')
      }

      Divider()

      Grid(){
        GridItem(){
          Row(){
            Column(){
              Image($r('app.media.wind'))
                .width(20)
                .height(20)
              Text("风速")
                .fontSize(1)
            }
            .width('50%')
            Column(){
              Text(`${this.windSpeed}级`)
                .fontSize(20)
              Text(`${this.windDir}`)
                .fontSize(20)
            }
            .width('50%')
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.SpaceEvenly)
          .onClick(()=>{
            router.pushUrl({
              url:"pages/WeatherFor7Days"
            })
          })
        }
        GridItem(){
          Row(){
            Column(){
              Image($r('app.media.pressure'))
                .width(20)
                .height(20)
              Text("气压")
            }
            .width('50%')
            Column(){
              Text(`${this.pressure}hpa`)
                .fontSize(20)
            }
            .width('50%')
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.SpaceEvenly)
        }
        GridItem(){
          Row(){
            Column(){
              Image($r('app.media.humidity'))
                .width(20)
                .height(20)
              Text("湿度")
            }
            .width('50%')
            Column(){
              Text(`${this.humidity}%`)
                .fontSize(20)
            }
            .width('50%')
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.SpaceEvenly)
        }
        GridItem(){
          Row(){
            Column(){
              Image($r('app.media.pm2p5'))
                .width(20)
                .height(20)
              Text("PM2.5")
            }
            .width('50%')
            Column(){
              Text(`${this.pm2p5}`)
                .fontSize(20)
              Text(`空气${this.category}`)
                .fontSize(20)
            }
            .width('50%')
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.SpaceEvenly)
        }
      }
      .columnsTemplate('1fr 1fr')
      .rowsTemplate('1fr 1fr')
      .columnsGap(30)
      .rowsGap(20)
      .height(200)

      Scroll(){
        List(){
          ForEach(this.weatherLongData,(item:weatherInfo7)=>{
            this.listItem(item.textDay,item.fxDate)
          })
        }
        .width('100%')
        .height(100)
        .listDirection(Axis.Horizontal)
        .scrollBar(BarState.Off)
        .borderRadius(30)
        .backgroundColor("#7455a2ee")

      }

      Row(){
        McLineChart({
          options:this.seriesOption
        })
      }
      .height(300)

    }
    .backgroundImage($r('app.media.background3'))
    .backgroundImageSize({width:'100%',height:"100%"})
    .backdropBlur(20)
    .width('100%')
  }

  }

  @Builder
  listItem(textDay:string,fxDate:string){
    ListItem(){
      Column(){
        Row(){
          Image(this.matchImage(textDay))
            .width(30)
            .height(30)
        }
        Row(){
          Text(`${textDay}`)
            .fontSize(20)
        }
        Row(){
          Text(fxDate.substring(5,fxDate.length))
            .fontSize(20)
        }
      }
      .justifyContent(FlexAlign.Center)
    }
    .width('20%')
    .height(120)
  }
}