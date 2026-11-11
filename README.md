# 轻记账 · Lite Ledger

极简、离线、开源的本地记账 App —— **不联网、不注册、无广告**。

首页一键记账，按日 / 周 / 月 / 年看统计，所有数据只保存在你自己的手机上。

<p align="center">
  <img src="docs/screenshots/home.png" width="256" alt="首页记账">
  <img src="docs/screenshots/stats.png" width="256" alt="统计">
  <img src="docs/screenshots/settings.png" width="256" alt="设置">
</p>

## 功能

- **首页快速记账**：金额、支出/收入、分类、账户、日期、备注，一屏完成
- **日 / 周 / 月 / 年统计**：支出趋势柱状图 + 分类占比
- **按天分组**：本月记录按日期排列，随手删除
- **本地存储**：数据存在设备本地（localStorage / WebView），不上传任何服务器
- **导入导出**：JSON 备份与恢复，换机不丢账
- **离线可用**：纯前端单页应用，无需网络
- **无权限**：Android 版不申请网络、定位、通讯录等任何权限

## 下载安装

1. 打开本仓库的 [Releases](../../releases) 页面，下载最新的 `LiteLedger.apk`
   - 也可以直接下载仓库里的 [dist/LiteLedger-1.0.0.apk](dist/LiteLedger-1.0.0.apk)
2. 在手机上点击安装；如提示，请允许「安装未知来源应用」
3. 打开即可使用，无需注册

> 也可以在手机浏览器打开网页版（GitHub Pages）后「添加到主屏幕」，效果一致。

## 从源码构建

### 网页版直接运行

```bash
cd app
python3 -m http.server 8080
# 浏览器打开 http://localhost:8080
```

也可以直接双击 `app/index.html` 打开。

### Android APK

需要 JDK 17 与 Android SDK（platform 34、build-tools 34.0.0）。

```bash
bash scripts/sync-web.sh          # 把 app/ 同步进 android/app/src/main/assets
cd android
./gradlew assembleDebug           # 产物：app/build/outputs/apk/debug/app-debug.apk
```

用 Android Studio 打开 `android/` 目录也可以直接构建。

### 用 GitHub Actions 自动打包

push 到 `main` 后，Actions 会自动构建 APK 并上传为构建产物；打 tag（如 `v1.0.0`）会自动创建 Release 并附上 APK。

## 签名（发布正式版时）

本地构建正式版：

```bash
keytool -genkeypair -keystore android/litledger-release.jks -alias litledger \
  -keyalg RSA -keysize 2048 -validity 10950
cp android/keystore.properties.example android/keystore.properties
# 编辑 keystore.properties 填入你的密码
cd android && ./gradlew assembleRelease
```

在 GitHub Actions 中签名，需要在仓库 Secrets 中配置：

| Secret | 说明 |
| --- | --- |
| `KEYSTORE_BASE64` | `base64 -i android/litledger-release.jks` 的结果 |
| `STORE_PASSWORD` | keystore 密码 |
| `KEY_ALIAS` | key 别名 |
| `KEY_PASSWORD` | key 密码 |

配置后，打 tag 构建出的就是正式签名版；未配置时工作流会回退到 debug 包（可直接安装，但不适合长期升级分发）。

> ⚠️ 请务必备份好 keystore 和密码。丢失后将无法为已安装用户推送升级包。

## 发布到 GitHub

本目录已经是一个可直接推送的 git 仓库。在 GitHub 新建一个空仓库（不要勾选初始化 README）后：

```bash
git remote add origin git@github.com:<你的用户名>/<仓库名>.git
git push -u origin main
```

发布版本时打一个 tag：

```bash
git tag v1.0.0
git push origin v1.0.0
```

Actions 会自动构建 APK 并创建 Release（带 APK 附件）。首次使用请在仓库 `Settings → Actions → General` 把 Workflow permissions 设为 **Read and write**。

想发布和 `dist/` 里签名一致的正式包，请先在仓库 Secrets 配置上表中的四个变量，并妥善备份 `android/litledger-release.jks`。

## 项目结构

```
app/                网页版（也是 APK 内的前端资源）
  index.html        单页应用：首页 / 统计 / 设置
  manifest.webmanifest
  sw.js             Service Worker（离线缓存）
  icon-192.png
  icon-512.png
android/            Android WebView 壳工程
  app/src/main/assets/   构建前由 scripts/sync-web.sh 同步
.github/workflows/  自动构建 APK / 部署网页版
scripts/sync-web.sh
docs/screenshots/
```

修改前端后，记得执行 `bash scripts/sync-web.sh` 再构建 APK。

## 隐私

- App 没有 `INTERNET` 权限，从系统层面就无法联网上传
- 没有账号、没有统计 SDK、没有广告
- 所有记录保存在本机，卸载 App 即删除；请先用「设置 → 导出」备份
- 详见 [PRIVACY.md](PRIVACY.md)

## 自定义

- 应用名：`android/app/src/main/res/values/strings.xml`
- 包名：`android/app/build.gradle` 中的 `namespace` 与 `applicationId`（同时改 `MainActivity.java` 的 package）
- 主题色：`app/index.html` 顶部的 CSS 变量 `--accent`
- 分类与账户：`app/index.html` 中的 `CATS` 与 `ACCOUNTS`

## License

[MIT](LICENSE)

---

## English

**Lite Ledger** is a minimal, offline, open-source expense tracker for Android (WebView) and the web. Quick add on the home screen, day/week/month/year stats, JSON backup, zero network permission, zero tracking. Download the APK from Releases or build it yourself with Gradle.
