import { image } from '@kit.ImageKit';
import { resourceManager } from '@kit.LocalizationKit';

export default function getPixelMap(context:Context):Promise<image.PixelMap>{
  const resourceMgr:resourceManager.ResourceManager=context.resourceManager
  return resourceMgr.getRawFileContent('moon.png').then((fileData:Uint8Array)=>{
    const buffer=fileData.buffer.slice(0)
    const imageSource:image.ImageSource=image.createImageSource(buffer)
    return imageSource.createPixelMap()
  })
}