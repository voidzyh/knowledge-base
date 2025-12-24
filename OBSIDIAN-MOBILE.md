# Obsidian 移动端配置指南

## 📱 概览

通过 Obsidian Mobile + Git 插件，实现知识库的移动端访问和同步。

---

## 🛠️ 设置步骤

### 步骤 1: 安装 Obsidian Mobile

**iOS**:
1. App Store 搜索 "Obsidian"
2. 下载并安装

**Android**:
1. Google Play 搜索 "Obsidian"
2. 下载并安装

---

### 步骤 2: 克隆仓库到 Obsidian

#### 方法 A: 使用 Obsidian Git 插件（推荐）

**桌面端设置**:

1. 安装 Obsidian Git 插件
   - 设置 → 社区插件
   - 浏览 → 搜索 "Git"
   - 安装 "Obsidian Git"

2. 配置插件
   - 设置 → Git 插件
   - 配置以下设置:
     ```
     Auto-save interval: 5 minutes
     Auto-commit interval: 10 minutes
     Auto-push interval: 15 minutes
     Pull on startup: Yes
     Pull on file change: No
     ```

3. 配置 Git 路径
   - 确保系统有 Git
   - Mac: `/usr/bin/git`
   - Windows: `C:\Program Files\Git\bin\git.exe`

**移动端设置**:

1. 打开 Obsidian mobile app
2. 点击"创建新仓库"或"打开文件夹"
3. 选择"克隆仓库"
4. 输入仓库地址:
   ```
   https://github.com/voidzyh/knowledge-base.git
   ```
5. 选择本地存储路径
6. 克隆完成

#### 方法 B: 手动克隆（备选）

**桌面端**:
```bash
cd ~/Documents
git clone https://github.com/voidzyh/knowledge-base.git obsidian-knowledge-base
```

然后在 Obsidian 中打开这个文件夹作为 vault。

**移动端**:
1. 使用 Git 客户端 app（如 Working Copy）
2. 克隆仓库到 app 的本地存储
3. 在 Obsidian 中打开该文件夹

---

### 步骤 3: 配置移动端同步

#### Obsidian Git 插件设置

**桌面端**:

1. 打开设置 → Git 插件
2. 配置自动同步:
   - **Auto-save interval**: 5 分钟
   - **Auto-commit interval**: 10 分钟
   - **Auto-push interval**: 15 分钟
   - **Pull on startup**: ✅
   - **Pull interval**: 5 分钟

3. 配置 Git 命令:
   - **Git executable path**: `/usr/bin/git` (Mac)
   - **Default commit message**: `Update from Obsidian Mobile`

4. 配置忽略文件:
   ```
   .obsidian/workspace
   .obsidian/workspace-mobile
   .DS_Store
   .trash/
   ```

**移动端**:

1. 打开设置 → Git 插件
2. 配置相同的设置
3. 测试同步:
   - 点击"立即拉取"按钮
   - 检查是否有冲突

---

## 🔄 同步工作流

### 日常同步

**从桌面到移动**:
1. 桌面端修改文件
2. Obsidian Git 自动提交并推送
3. 移动端打开 Obsidian
4. 插件自动拉取最新内容

**从移动到桌面**:
1. 移动端编辑文件
2. Obsidian Git 自动提交并推送
3. 桌面端打开 Obsidian
4. 插件自动拉取最新内容

### 手动同步

**如果自动同步失败**:

**桌面端**:
```bash
cd ~/Documents/obsidian-knowledge-base
git pull origin main
```

或在 Obsidian 中:
- 命令面板 (Cmd/Ctrl + P)
- 输入 "Git: Pull"
- 执行

**移动端**:
- 命令面板
- 输入 "Git: Pull"
- 执行

---

## ⚠️ 常见问题

### 问题 1: 同步冲突

**症状**: 拉取时出现合并冲突

**解决方案**:

1. **保留本地更改**:
   ```bash
   git commit -m "Local changes"
   git pull --rebase origin main
   ```

2. **保留远程更改**:
   ```bash
   git reset --hard origin/main
   ```

3. **手动合并**:
   ```bash
   git pull origin main
   # 手动解决冲突
   git add .
   git commit -m "Resolve conflicts"
   ```

### 问题 2: Git 认证失败

**症状**: 推送时提示权限错误

**解决方案**:

1. **使用 SSH 密钥**:
   ```bash
   # 生成 SSH 密钥
   ssh-keygen -t ed25519 -C "your_email@example.com"

   # 添加到 GitHub
   cat ~/.ssh/id_ed25519.pub
   # 复制内容到 GitHub Settings → SSH Keys

   # 修改远程 URL
   git remote set-url origin git@github.com:voidzyh/knowledge-base.git
   ```

2. **使用 Personal Access Token**:
   ```bash
   git remote set-url origin https://YOUR_TOKEN@github.com/voidzyh/knowledge-base.git
   ```

### 问题 3: 移动端性能问题

**症状**: Obsidian mobile 卡顿

**解决方案**:

1. **关闭不必要的插件**:
   - 设置 → 社区插件
   - 禁用非核心插件

2. **减少同步频率**:
   - Git 插件设置
   - 增加自动同步间隔

3. **优化仓库大小**:
   - 移除大文件
   - 使用 Git LFS（如需要）

---

## 📊 移动端使用场景

### 场景 1: 通勤学习

**时间**: 30 分钟地铁

**操作**:
1. Obsidian mobile 查看今日笔记
2. 阅读知识条目
3. 添加想法和笔记
4. 自动同步到云端

**技巧**:
- 离线下载需要的内容
- 使用语音输入快速记录

---

### 场景 2: 床上复习

**时间**: 睡前 20 分钟

**操作**:
1. 搜索 "review: due: today"
2. 阅读 2-3 个到期复习的知识点
3. 使用模板添加复习笔记:
   ```markdown
   ## 复习笔记 - 2025-12-24

   **主题**: YAML Frontmatter

   **理解程度**: ⭐⭐⭐⭐
   **需要补充**:
   - 实际应用场景
   - 更多代码示例
   ```
4. 同步到 GitHub

---

### 场景 3: 灵感捕捉

**时间**: 随时

**操作**:
1. 快速打开 Obsidian mobile
2. 创建新笔记
3. 语音或文字记录
4. 添加标签 #待整理
5. 同步到桌面

**桌面后续处理**:
- `/extract` 提取知识点
- `/connect` 建立关联
- 整理到对应目录

---

## 🎯 最佳实践

### 1. 同步策略

**自动同步**: 适合日常使用
- 桌面和移动都启用自动同步
- 设置合理的间隔（5-15分钟）

**手动同步**: 适合大量编辑
- 完成编辑后手动推送
- 避免频繁的小提交

### 2. 文件组织

**移动端友好命名**:
- 使用有意义的文件名
- 避免特殊字符
- 保持目录结构清晰

**示例**:
```
ai-ml/agent/ai-agent-basics.md ✅
AI Agent 基础.md ❌ (移动端可能有问题)
```

### 3. 插件选择

**推荐的移动端插件**:
1. **Obsidian Git** - 必须
2. **Dataview** - 查询元数据
3. **Templater** - 模板系统
4. **QuickAdd** - 快速输入

**不推荐的移动端插件**:
1. **Canvas** - 移动端性能差
2. **Excalidraw** - 移动端体验不佳

### 4. 性能优化

**减少仓库大小**:
- 定期清理无用文件
- 压缩图片
- 移除大附件

**优化加载速度**:
- 减少首页链接数
- 使用书签代替大量链接
- 关闭不必要的实时预览

---

## 🔧 高级配置

### 1. 多设备同步

**场景**: 桌面 + 笔记本 + 手机 + 平板

**解决方案**:
- 所有设备使用同一个 GitHub 仓库
- 每个设备配置独立的提交信息
- 定期合并冲突

### 2. 离线工作

**准备**:
1. 在 WiFi 下拉取最新内容
2. 下载需要参考的资料
3. 缓存常用查询

**工作**:
1. 正常编辑和记录
2. 插件会缓存更改
3. 连接网络后推送

### 3. 自动备份

**设置**:
1. GitHub Actions 自动备份
2. 定期打标签
3. 导出 Markdown 压缩包

---

## 📱 Obsidian Mobile 快捷操作

### 手势操作

- **左滑**: 显示文件菜单
- **右滑**: 快速预览
- **长按**: 多选模式

### 快速命令

- **下拉**: 同步（Git pull）
- **双指点击**: 显示命令面板
- **三指点击**: 快速搜索

---

## 🎉 完成检查清单

完成以下步骤以确保移动端设置成功：

- [ ] 安装 Obsidian Mobile app
- [ ] 克隆知识库仓库到移动端
- [ ] 安装并配置 Obsidian Git 插件
- [ ] 测试从桌面到移动的同步
- [ ] 测试从移动到桌面的同步
- [ ] 配置自动同步间隔
- [ ] 设置冲突解决策略
- [ ] 优化移动端性能
- [ ] 创建移动端快捷方式
- [ ] 测试离线工作

---

## 📚 相关资源

- [Obsidian Mobile 文档](https://help.obsidian.md/Mobile+app)
- [Obsidian Git 插件](https://github.com/denolehed/obsidian-git)
- [Git 基础教程](https://git-scm.com/docs/gittutorial)
- [GitHub Desktop](https://desktop.github.com/)

---

**配置日期**: 2025-12-24
**Obsidian 版本**: Mobile 1.5+
**状态**: 待配置
