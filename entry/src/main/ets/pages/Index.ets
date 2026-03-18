import { webview } from '@kit.ArkWeb';
import { picker } from '@kit.CoreFileKit';
import { common, abilityAccessCtrl, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct WebShell {
  private webController: webview.WebviewController = new webview.WebviewController();
  // ★ 改成你的网址 ★
  private url: string = 'https://www.example.com/';
  @State private lastBackTime: number = 0;

  aboutToAppear() {
    this.requestPermissions();
  }

  async requestPermissions() {
    const permissions: Permissions[] = [
      'ohos.permission.CAMERA',
      'ohos.permission.READ_IMAGEVIDEO',
      'ohos.permission.WRITE_IMAGEVIDEO'
    ];
    try {
      const atManager = abilityAccessCtrl.createAtManager();
      const context = getContext(this) as common.UIAbilityContext;
      await atManager.requestPermissionsFromUser(context, permissions);
    } catch (err) {
      console.error('权限申请失败:', JSON.stringify(err));
    }
  }

  onBackPress(): boolean {
    if (this.webController.accessBackward()) {
      this.webController.backward();
      return true;
    }
    const now = Date.now();
    if (now - this.lastBackTime < 2000) {
      return false;
    }
    this.lastBackTime = now;
    promptAction.showToast({ message: '再按一次退出应用', duration: 2000 });
    return true;
  }

  build() {
    Column() {
      Web({ src: this.url, controller: this.webController })
        .javaScriptAccess(true)
        .domStorageAccess(true)
        .imageAccess(true)
        .mediaPlayGestureAccess(true)

        .onShowFileSelector((event: OnShowFileSelectorEvent) => {
          const fileSelectorResult: FileSelectorResult = event.result;

          try {
            const photoSelectOptions = new picker.PhotoSelectOptions();
            photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
            photoSelectOptions.maxSelectNumber = 1;
            const photoPicker = new picker.PhotoViewPicker();

            photoPicker.select(photoSelectOptions).then((result: picker.PhotoSelectResult) => {
              if (result && result.photoUris && result.photoUris.length > 0) {
                fileSelectorResult.handleFileList(result.photoUris);
              } else {
                fileSelectorResult.handleFileList([]);
              }
            }).catch((err: BusinessError) => {
              console.error('图片选择失败:', JSON.stringify(err));
              fileSelectorResult.handleFileList([]);
            });
          } catch (err) {
            console.error('Picker异常:', JSON.stringify(err));
            fileSelectorResult.handleFileList([]);
          }

          return true;
        })

        .onPermissionRequest((event: OnPermissionRequestEvent) => {
          if (event) {
            event.request.grant(event.request.getAccessibleResource());
          }
        })

        .width('100%')
        .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}
