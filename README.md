# HarmonyOS WebView Shell - 鸿蒙套壳 APP 模板

![HarmonyOS](https://img.shields.io/badge/HarmonyOS-NEXT%20API22-red)
![ArkTS](https://img.shields.io/badge/ArkTS-5.0-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-鸿蒙6-orange)

> 纯 ArkTS 开发的 HarmonyOS 6（NEXT）WebView 套壳应用模板。
> **只需修改一个 URL，即可将任意网页打包为鸿蒙原生 APP。**

---

## 核心功能

| 功能 | 说明 |
|------|------|
| 🌐 **WebView 全屏加载** | 加载指定网址，支持 JS、DOM Storage、图片访问 |
| 🔙 **智能返回键** | 网页内自动后退历史；首页双击退出，防误触 |
| 🎨 **品牌启动页** | 自定义全屏 Splash，2 秒后自动跳转主页 |
| 📷 **相机 & 相册** | 拦截 H5 文件选择，调起系统相册/相机上传 |
| 🔐 **权限自动管理** | 启动时申请相机、相册权限；不需要可一键删除 |
| 📱 **沉浸式体验** | 隐藏底部导航指示条，内容全屏沉浸展示 |
| 🎥 **WebView 权限授予** | 自动授予网页请求的设备权限（如摄像头） |

## 快速开始

### 环境要求

- [DevEco Studio](https://developer.huawei.com/consumer/cn/deveco-studio/) 5.0+ （ 建议6.0.2+ ）
- HarmonyOS SDK API 22 (鸿蒙 NEXT / 鸿蒙6)
- 真机或模拟器

### 使用步骤

1. Clone 本项目并用 DevEco Studio 打开
2. 修改 `entry/src/main/ets/pages/Index.ets` 中的 URL：
   ```text
   private url: string = 'https://your-website.com/';
   ```
3. 替换图标和启动图（见下方自定义部分）
4. 连接真机，点击 Run

## 自定义配置

### 修改应用名称

编辑 `entry/src/main/resources/base/element/string.json` 中的 `app_name` 字段。

### 替换图标和启动图

| 文件路径 | 用途 | 说明 |
|---------|------|------|
| `AppScope/resources/base/media/foreground.png` | 桌面图标前景 | 主体内容居中，留 1/6 安全边距 |
| `AppScope/resources/base/media/background.png` | 桌面图标背景 | 纯色或纹理底图 |
| `entry/src/main/resources/base/media/startIcon.png` | 系统启动页图标 | 系统短暂显示的小图标 |
| `entry/src/main/resources/base/media/splash.png` | 全屏启动图 | Splash 页面全屏展示 |

> 鸿蒙使用分层图标（foreground + background 叠加），系统会自动裁剪为圆形。

### 增减权限

编辑 `entry/src/main/module.json5` 中的 `requestPermissions` 数组。

**如果你的网页不需要拍照/相册功能**，可以：
1. 删除 `module.json5` 中 `CAMERA`、`READ_IMAGEVIDEO`、`WRITE_IMAGEVIDEO` 三个权限
2. 删除 `Index.ets` 中的 `requestPermissions()` 方法和 `onShowFileSelector` 回调
3. 删除 `string.json` 中对应的 `permission_*_reason` 字符串

### 修改启动页时长

编辑 `entry/src/main/ets/pages/Splash.ets` 中的延时时间（默认 2000ms）：
```typescript
this.timerId = setTimeout(() => {
  router.replaceUrl({ url: 'pages/Index' });
}, 2000); // ← 修改这个值
```

## 项目结构

```
├── AppScope/                          # 应用级配置和图标资源
│   ├── app.json5                      # 应用名称、图标、版本
│   └── resources/base/media/          # 桌面图标 (foreground + background)
├── entry/src/main/
│   ├── ets/
│   │   ├── entryability/
│   │   │   └── EntryAbility.ets       # 应用入口，沉浸式配置
│   │   └── pages/
│   │       ├── Splash.ets             # 全屏启动页 (可自定义时长)
│   │       └── Index.ets              # WebView 主页 + 离线页 + 返回拦截
│   ├── resources/                     # 字符串、颜色、启动图等资源
│   └── module.json5                   # 模块配置、权限声明
```

## 常见问题

**Q: 编译后能脱离 DevEco Studio 独立运行吗？**
A: 可以。编译出 `.hap` 文件后，通过 `hdc install xxx.hap` 安装到手机即可独立运行。

**Q: 网页里的文件上传按钮没反应？**
A: 确保 `module.json5` 中声明了 `READ_IMAGEVIDEO` 权限，且 `onShowFileSelector` 回调未被删除。

**Q: 如何去掉启动页直接进入 WebView？**
A: 将 `EntryAbility.ets` 中的 `loadContent('pages/Splash')` 改为 `loadContent('pages/Index')`。

## 贡献与交流

欢迎大家提交 Issue 和 Pull Request，一起完善这个项目！

- Bug 反馈：请通过 Issue 提交，并尽量附上复现步骤
- 功能建议：欢迎提出你的想法
- 代码贡献：Fork 后提交 PR 即可

如果这个项目对你有帮助，欢迎点个 Star ⭐

## 联系方式

- Email: lixinze@bzpt.edu.cn

## 开源协议

[MIT](LICENSE)
