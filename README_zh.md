# tensor

在这个模块中，我们使用C语言构建了一个小型的`Tensor`，类似于`torch.Tensor`或`numpy.ndarray`。当前的代码实现了一个简单的一维浮点张量，我们可以访问和切片。我们看到张量对象同时维护一个`Storage`，它在物理内存中保存一维数据，以及一个`View`，它在内存中具有一些起始、结束和步长信息。这使我们能够在不创建任何额外内存的情况下高效地对张量进行切片，因为`Storage`被重用，而`View`更新以反映新的起始、结束和步长。然后我们可以看到如何将我们的C语言张量包装成一个Python模块，就像PyTorch和numpy那样。

1D Tensor的源代码在 [tensor1d.h](tensor1d.h) 和 [tensor1d.c](tensor1d.c) 文件中。你可以简单地通过以下命令编译并运行：



```bash
gcc -Wall -O3 tensor1d.c -o tensor1d
./tensor1d
```

代码包含了`Tensor`类，同时还有一个简短的`int main`，它只是一个玩具示例。我们现在可以将这个C代码包装成一个Python模块，以便在Python中访问。为此，可以将其编译为共享库：


```bash
gcc -O3 -shared -fPIC -o libtensor1d.so tensor1d.c
```

这将生成一个`libtensor1d.so`共享库，我们可以使用 [cffi](https://cffi.readthedocs.io/en/latest/) 库从Python中加载它，可以在 [tensor1d.py](tensor1d.py) 文件中看到这一点。然后，我们可以在Python中像这样使用它：

```python
import tensor1d

# 生成一个包含 [0, 1, 2, ..., 19] 的1D张量
t = tensor1d.arange(20)

# 获取和设置元素
print(t[3]) # 打印3.0
t[-1] = 100.0 # 将最后一个元素设置为100.0

# 切片，打印 [5, 7, 9, 11, 13]
print(t[5:15:2])

# 切片的切片效果良好！打印 [9, 11, 13]
# （注意结束范围超出范围并被裁剪）
print(t[5:15:2][2:7])

# 向整个张量添加一个标量
t = t + 10.0

# 将两个相同大小的张量相加
t2 = tensor1d.arange(20)
t3 = t + t2

# 使用广播将两个张量相加
t4 = t + tensor1d.tensor([10.0])
```

最后，测试用例使用 [pytest](https://docs.pytest.org/en/stable/) ，可以在 [test_tensor1d.py](test_tensor1d.py) 文件中找到。你可以通过 `pytest test_tensor1d.py` 运行这些测试。

理解这个主题非常值得，因为你可以使用torch张量进行相当复杂的操作，并且你必须小心和了解代码底层的内存，当我们创建新存储还是只是一个新视图时，函数可能会或可能不会仅接受“连续”的张量。另一个陷阱是，当你创建一个大张量的小切片时，假设大张量会被垃圾回收，但实际上大张量仍然存在，因为小切片只是大张量存储的一个视图。我们自己的张量也是如此。

像 `torch.Tensor` 这样的生产级张量具有更多的功能，我们在这里不会涉及。你可以有不同的 `dtype` 而不仅仅是浮点型，不同的 `device`，不同的 `layout`，张量还可以是量化的、加密的等等。



TODOs:

- 将我们自己的实现更接近 `torch.Tensor`
- 改进测试
- 实现2D张量，在这种情况下我们必须开始考虑2D形状/步长
- 为2D张量实现广播

推荐资源:
- [PyTorch internals](http://blog.ezyang.com/2019/05/pytorch-internals/)
- [Numpy paper](https://arxiv.org/abs/1102.1523)

### License

MIT