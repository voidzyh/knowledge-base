---
title: PyTorch
category: ai-ml/frameworks
tags: [AI, 深度学习, PyTorch, Python, 框架]
created: 2025-12-27
updated: 2025-12-27
mastery: 2
difficulty: 3
review_dates:
  - 2025-12-28
  - 2025-12-30
  - 2026-01-03
  - 2026-01-10
  - 2026-01-24
  - 2026-03-24
status: learning
related:
  - ai-ml/basics/deep-learning-basics.md
  - ai-ml/tts/indextts2.md
---

# PyTorch

## 📋 基本信息
- **主题**: PyTorch 深度学习框架
- **分类**: AI/ML - 框架
- **标签**: #AI #深度学习 #PyTorch #Python #框架
- **创建日期**: 2025-12-27
- **掌握程度**: ⭐⭐⭐ (系统学习)
- **难度等级**: ⭐⭐⭐
- **开发者**: Meta (Facebook) AI Research
- **首次发布**: 2016年
- **许可证**: BSD 3-Clause

## 🎯 核心概念

### 定义
**PyTorch** 是由 Meta AI Research 开发的开源机器学习框架，基于 Torch 库，使用 Python 语言实现。它提供了两个高级功能：
1. **张量计算** - 类似 NumPy 的 GPU 加速张量运算
2. **自动微分** - 构建神经网络所需的自动微分系统

### 与 TensorFlow 对比

| 特性 | PyTorch | TensorFlow |
|------|---------|------------|
| **编程风格** | 动态图，Pythonic | 静态图，较为复杂 |
| **调试** | 易于调试 (Python pdb) | 调试困难 |
| **部署** | 需要 TorchScript | 原生支持 |
| **社区** | 学术界主流 | 工业界主流 |
| **学习曲线** | 平缓 | 陡峭 |

### PyTorch 的核心组件

```
PyTorch 架构
├── torch           # 核心张量库
├── torch.autograd   # 自动微分
├── torch.nn        # 神经网络模块
├── torch.optim     # 优化算法
├── torch.utils     # 工具函数 (DataLoader 等)
└── torchvision     # 计算机视觉工具包
```

## 🔍 详细解释

### 1. 张量 (Tensor)

张量是 PyTorch 的核心数据结构，类似于 NumPy 的数组，但可以在 GPU 上运行。

```python
import torch

# 创建张量
x = torch.tensor([1, 2, 3, 4])           # 从列表创建
x = torch.zeros(3, 4)                     # 全零张量
x = torch.ones(2, 3)                      # 全一张量
x = torch.randn(2, 3)                     # 随机正态分布

# 张量运算
y = x + 1                                  # 加法
z = torch.matmul(x, y)                   # 矩阵乘法

# GPU 转移
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
x = x.to(device)

# 张量形状操作
x = x.reshape(2, 6)                       # 重塑形状
x = x.permute(1, 0)                       # 交换维度
x = x.squeeze()                            # 去除维度为1的维度
```

### 2. 自动微分 (Autograd)

PyTorch 的自动微分系统用于计算梯度：

```python
import torch

# 启用梯度跟踪
x = torch.tensor([2.0, 3.0], requires_grad=True)
y = torch.tensor([1.0, 1.0], requires_grad=False)

# 前向计算
z = x * 2 + y

# 反向传播 (计算梯度)
z.sum().backward()

print(x.grad)  # tensor([2., 2.])
```

### 3. 神经网络模块 (nn.Module)

`nn.Module` 是所有神经网络模型的基类：

```python
import torch.nn as nn

class NeuralNetwork(nn.Module):
    def __init__(self):
        super(NeuralNetwork, self).__init__()
        # 定义层
        self.flatten = nn.Flatten()
        self.linear_relu_stack = nn.Sequential(
            nn.Linear(28*28, 512),
            nn.ReLU(),
            nn.Linear(512, 512),
            nn.ReLU(),
            nn.Linear(512, 10),
        )

    def forward(self, x):
        # 定义前向传播
        x = self.flatten(x)
        logits = self.linear_relu_stack(x)
        return logits

# 创建模型
model = NeuralNetwork()
```

### 4. 优化器 (Optimizer)

优化器用于更新模型参数：

```python
import torch.optim as optim

# 常用优化器
optimizer = optim.SGD(model.parameters(), lr=0.01, momentum=0.9)
optimizer = optim.Adam(model.parameters(), lr=0.001)
optimizer = optim.AdamW(model.parameters(), lr=0.001, weight_decay=0.01)

# 训练循环中使用
optimizer.zero_grad()  # 清空梯度
loss.backward()        # 反向传播计算梯度
optimizer.step()       # 更新参数
```

### 5. 数据加载 (DataLoader)

`DataLoader` 提供数据批处理和打乱：

```python
from torch.utils.data import DataLoader, Dataset

# 创建数据加载器
train_loader = DataLoader(
    dataset=train_dataset,
    batch_size=32,
    shuffle=True,      # 打乱数据
    num_workers=4,      # 多进程加载
    pin_memory=True     # 锁页内存，加速 GPU 传输
)

# 迭代数据
for batch_idx, (data, target) in enumerate(train_loader):
    # 训练代码
    pass
```

## 💻 代码示例

### 示例1: 完整训练流程

```python
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader

# 1. 定义模型
class SimpleNet(nn.Module):
    def __init__(self):
        super().__init__()
        self.fc = nn.Linear(10, 2)

    def forward(self, x):
        return self.fc(x)

# 2. 初始化
model = SimpleNet()
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.001)
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model.to(device)

# 3. 训练循环
num_epochs = 10

for epoch in range(num_epochs):
    model.train()  # 训练模式
    total_loss = 0

    for data, target in train_loader:
        data, target = data.to(device), target.to(device)

        # 前向传播
        output = model(data)
        loss = criterion(output, target)

        # 反向传播
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        total_loss += loss.item()

    print(f'Epoch {epoch+1}/{num_epochs}, Loss: {total_loss/len(train_loader):.4f}')

# 4. 保存模型
torch.save(model.state_dict(), 'model.pth')

# 5. 加载模型
model.load_state_dict(torch.load('model.pth'))
```

### 示例2: CNN 图像分类

```python
import torch
import torch.nn as nn
import torch.nn.functional as F

class CNN(nn.Module):
    def __init__(self, num_classes=10):
        super(CNN, self).__init__()
        # 卷积层
        self.conv1 = nn.Conv2d(3, 32, kernel_size=3, padding=1)
        self.conv2 = nn.Conv2d(32, 64, kernel_size=3, padding=1)
        # 池化层
        self.pool = nn.MaxPool2d(2, 2)
        # 全连接层
        self.fc1 = nn.Linear(64 * 8 * 8, 128)
        self.fc2 = nn.Linear(128, num_classes)
        # Dropout
        self.dropout = nn.Dropout(0.5)

    def forward(self, x):
        # 卷积 -> ReLU -> 池化
        x = self.pool(F.relu(self.conv1(x)))
        x = self.pool(F.relu(self.conv2(x)))
        # 展平
        x = x.view(x.size(0), -1)
        # 全连接 -> Dropout
        x = self.dropout(F.relu(self.fc1(x)))
        x = self.fc2(x)
        return x
```

### 示例3: GPU 加速使用

```python
# 检查 CUDA 可用性
print(f"CUDA available: {torch.cuda.is_available()}")
print(f"CUDA version: {torch.version.cuda}")
print(f"GPU count: {torch.cuda.device_count()}")

# 设备管理
device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
print(f"Using device: {device}")

# 模型和数据移到 GPU
model = model.to(device)
data = data.to(device)
target = target.to(device)
```

## 🔗 相关概念

### 前置知识
- **[Python 基础](https://github.com/)** - 面向对象编程 (建议掌握度: ⭐⭐⭐⭐)
- **[深度学习基础](ai-ml/basics/deep-learning-basics.md)** - 神经网络原理 (建议掌握度: ⭐⭐⭐)
- **[NumPy](https://numpy.org/)** - 数值计算 (建议掌握度: ⭐⭐⭐)

### 相关技术
- **[TensorFlow](https://tensorflow.org/)** - Google 的深度学习框架
- **[JAX](https://github.com/google/jax)** - Google 的新框架
- **[Keras](https://keras.io/)** - 高层神经网络 API

### 应用场景
- **计算机视觉** - 图像分类、目标检测
- **自然语言处理** - Transformer、BERT、GPT
- **语音处理** - ASR、TTS (如 IndexTTS2)
- **强化学习** - DQN、PPO

## 📚 深入学习资源

### 📖 官方文档
- **[PyTorch 官方文档](https://pytorch.org/docs/stable/index.html)** - 英文文档
- **[PyTorch 中文文档](https://pytorch.it-docs.cn/)** - 中文翻译
- **[PyTorch 教程](https://pytorch.org/tutorials/)** - 官方教程

### 🎥 视频教程
- **[2025最新PyTorch入门](https://www.bilibili.com/video/BV1TFtwzuESX/)** - B站，100集完整教程
- **[PyTorch 实战](https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi)** - 深度学习框架

### 📰 推荐文章
- **[PyTorch 入门全指南](https://blog.csdn.net/u013970991/article/details/156082998)** - CSDN
- **[PyTorch 最佳实践](https://pytorch.org/tutorials/beginner/basics/optimization_tutorial.html)** - 性能优化

### 💻 实战项目
- **[MNIST 手写数字识别](https://pytorch.org/tutorials/beginner/basics/intro.html)** - 入门经典
- **[CIFAR-10 图像分类](https://pytorch.org/tutorials/beginner/blitz/cifar10_tutorial.html)** - 进阶项目
- **[Transfer Learning](https://pytorch.org/tutorials/beginner/transfer_learning_tutorial.html)** - 迁移学习

## ⚠️ 常见误区和陷阱

### 误区1: 忽略 device 管理
- **错误**: 张量在不同设备上计算
- **正确**: 确保所有张量在同一设备
```python
# 正确做法
model = model.to(device)
data = data.to(device)
target = target.to(device)
```

### 误区2: 忘记 zero_grad
- **错误**: 梯度累积导致训练异常
- **正确**: 每个 batch 开始前清空梯度
```python
optimizer.zero_grad()  # 必须在 backward() 前调用
```

### 误区3: eval 模式忘记切换
- **错误**: 测试时使用 Dropout 和 BatchNorm 训练模式
- **正确**: 测试时切换到 eval 模式
```python
model.eval()  # 测试时
with torch.no_grad():  # 不计算梯度
    output = model(data)
model.train()  # 训练时记得切换回来
```

### 误区4: Batch size 设置不当
- **错误**: Batch size 太大或太小
- **建议**: 32/64/128 根据显存调整
- **显存不足**: 减小 batch size 或使用 gradient accumulation

### 陷阱: CUDA Out of Memory
**问题**: GPU 显存不足
```python
# 解决方案
# 1. 减小 batch size
train_loader = DataLoader(dataset, batch_size=16)  # 从 32 减到 16

# 2. 清空缓存
torch.cuda.empty_cache()

# 3. 使用梯度累积
accumulation_steps = 4
for i, (data, target) in enumerate(train_loader):
    output = model(data)
    loss = criterion(output, target)
    loss = loss / accumulation_steps
    loss.backward()

    if (i + 1) % accumulation_steps == 0:
        optimizer.step()
        optimizer.zero_grad()
```

## 🎯 实践技巧

### 1. 模型保存与加载
```python
# 保存模型
torch.save(model.state_dict(), 'model.pth')

# 加载模型
model = ModelClass()
model.load_state_dict(torch.load('model.pth'))
model.eval()  # 设置为评估模式
```

### 2. 检查点保存 (Checkpoint)
```python
# 保存训练状态
checkpoint = {
    'epoch': epoch,
    'model_state_dict': model.state_dict(),
    'optimizer_state_dict': optimizer.state_dict(),
    'loss': loss,
}
torch.save(checkpoint, 'checkpoint.pth')

# 加载检查点
checkpoint = torch.load('checkpoint.pth')
model.load_state_dict(checkpoint['model_state_dict'])
optimizer.load_state_dict(checkpoint['optimizer_state_dict'])
start_epoch = checkpoint['epoch'] + 1
```

### 3. 学习率调度
```python
from torch.optim.lr_scheduler import StepLR, CosineAnnealingLR

# 阶梯衰减
scheduler = StepLR(optimizer, step_size=30, gamma=0.1)

# 余弦退火
scheduler = CosineAnnealingLR(optimizer, T_max=num_epochs)

# 训练中使用
scheduler.step()
```

### 4. 混合精度训练 (加速)
```python
from torch.cuda.amp import autocast, GradScaler

scaler = GradScaler()

for data, target in train_loader:
    data, target = data.to(device), target.to(device)

    with autocast():  # 自动混合精度
        output = model(data)
        loss = criterion(output, target)

    scaler.scale(loss).backward()
    scaler.step(optimizer)
    scaler.update()
```

## 📝 个人笔记

### 理解要点
- PyTorch 使用动态图，调试方便，适合研究
- 张量是核心数据结构，类似 NumPy 但支持 GPU
- nn.Module 是所有模型的基类
- 记住训练五步: 前向 → 损失 → 清空梯度 → 反向 → 更新

### 常用代码片段
```python
# 设置随机种子
torch.manual_seed(42)

# 查看模型参数数量
total_params = sum(p.numel() for p in model.parameters())

# 只更新部分参数
optimizer = optim.Adam([
    {'params': model.fc.parameters(), 'lr': 1e-3},
    {'params': model.conv.parameters(), 'lr': 1e-4}
])
```

### 疑问记录
- [ ] 如何处理不平衡数据集？
- [ ] 如何进行模型量化和部署？
- [ ] 如何使用分布式训练？

---

**状态**: ✅ 系统学习完成，建议实践巩固

**下一步**:
1. 实践 MNIST 手写数字分类
2. 学习 Transfer Learning
3. 学习 Transformer 和 BERT
4. 继续学习 [IndexTTS2](ai-ml/tts/indextts2.md) 的部署
