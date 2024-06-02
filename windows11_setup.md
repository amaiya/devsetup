# Setting a Python development environment on Windows 11

1. Download the latest Windows 11 NVIDIA driver for your graphics card from [here](https://www.nvidia.com/Download/index.aspx). On June 1st, 2024, the latest driver version was 552.22.
2. Install [Miniconda](https://docs.anaconda.com/free/miniconda/). (Install for all users and set as system python.)
3. If you're behind a corporate firewall, run this `conda config --set ssl_verify path/to/ca-bundle.crt` (where `ca-bundle.crt` contains certificates for your company.)
4. Go to the [PyTorch - Get Started](https://pytorch.org/get-started/locally/) page and run the recommended command (e.g., `conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia`).
5. Run this at a Python prompt to verify things are working:
   ```python
   In [1]: import torch

   In [2]: torch.cuda.is_available()
   Out[2]: True

   In [3]: torch.cuda.get_device_name()
   Out[3]: 'NVIDIA RTX A1000 6GB Laptop GPU'
   ```
6. Download and install [Visual Studio Community Edition](https://visualstudio.microsoft.com/vs/community/) and make sure you select the following options:
    1. Desktop development with C++
	2. Python development
	3. Linux embedded development with C++

7. Install `pip` if it is not already installed: `conda install pip`
8. The `nvcc` package is required to build `llama-cpp-python` with cuda support: `conda install cuda -c nvidia`
9. Install `llama-cpp-python` by running the following in a command prompt:
    ```sh
	# Windows
	$env:CMAKE_ARGS = "-DLLAMA_CUDA=ON"
	pip install --upgrade --force-reinstall llama-cpp-python --no-cache-dir
	```
10. If the previous command, returns an error that says "No Cuda Toolset found", try the solution [here](https://github.com/NVlabs/tiny-cuda-nn/issues/164#issuecomment-1280749170)
