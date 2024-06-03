# How to Setup WSL with CUDA Support

1. **Install WSL2** by following [these instructions](https://www.c-sharpcorner.com/article/how-to-install-windows-subsystem-for-linux-wsl2-on-windows-11/):
    - Start Command Prompt as Adminstrator
    - Run this to see the OS options: `wsl --list --online`
    - Run this to install your choice: `wsl --install -d DISTRO-NAME`
2. **Configure Terminal**:
    - Search Windows Terminal and open it
    - Select **Settings** and choose the `DISTRO-NAME` you chose as the default.
3. [OPTIONAL] **Corporate Firewalls**: If you're behind a corporate firewall, see **Workarounds for Corporate Firewalls** below to install your company's certficates and get around other problems.
4. **Accessing Windows folders**: Create a symbolic links to easily access your the home directory on the C drive of your Windows machine: `ln -s /mnt/c/Users/<your_Windows_username>`.
5. **`build-essentials`**: Install `build-essential` package needed to compile software: `sudo apt install build-essentials`
6. [OPTIONAL] **Install Mamba/Conda**:
    - `wget https://raw.githubusercontent.com/amaiya/devsetup/main/setup-conda.sh`
    - `bash setup-conda.sh`
7. **Enabling GPU Support**: To run GPU-accelreated AI/ML models within WSL2, follow [these steps](https://docs.nvidia.com/cuda/wsl-user-guide/index.html#getting-started-with-cuda-on-wsl). This [site](https://docs.nvidia.com/deploy/cuda-compatibility/) is a helpful information on compatibility between drivers and CUDA.
8. **CUDA Environment Variables**: Add the following to your `.bashrc` file:
    ```sh
    export CUDA_HOME=/usr/local/cuda
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64
    export PATH=$PATH:$CUDA_HOME/bin
    ```
9. **Test CUDA with `nvcc`**: Run `nvcc --version` as a test.
10. **PyTorch**: Install PyTorch: `mamba  install pytorch cudnn`
11. **Test CUDA with PyTorch**: Run the following in a standard Python shell:
    ```python
    In [1]: import torch
    In [2]: torch.cuda.is_available()
    Out[2]: True
    ```

## Workarounds for Corporate Firewalls

You may need to [configure](https://askubuntu.com/questions/73287/how-do-i-install-a-root-certificate/94861#94861) the Ubuntu WSL system with your corporate SSL certificates:

1. Download your company's `.crt` certificate files.
2. Create a directory for extra CA certificates in /usr/local/share/ca-certificates: `sudo mkdir /usr/local/share/ca-certificates/extra`
3. Copy the CA .crt file to this directory: `sudo cp foo.crt /usr/local/share/ca-certificates/extra/foo.crt`
4. Let Ubuntu add the .crt file's path relative to /usr/local/share/ca-certificates to /etc/ca-certificates.conf: `sudo update-ca-certificates`
5. Point `pip` to your CA certificates: `pip config set global.cert /etc/ssl/certs`
6. Point `requests` to your CA certificates by adding this to your `.bashrc` file: `export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt`

The above should work fairly well with the system Python in WSL/Ubuntu.  However, if using Conda or Mamba, you may need some extra workarounds shown below.
For instance, issues with `urllib` (e.g., when running `nltk.download`) have been observed. 

If you get an SSL error to the effect of [unsafe legacy renegotiation disabled](https://stackoverflow.com/questions/75763525/curl-35-error0a000152ssl-routinesunsafe-legacy-renegotiation-disabled) (perhaps when you're trying to install something with `mamba` or `conda`, you can disable it with: 
```sh
 OPENSSL_CONF=<(cat /etc/ssl/openssl.cnf ; echo Options = UnsafeLegacyRenegotiation) mamba install pytorch cpuonly -c pytorch
```

#### For problems with `urllib`:
```python
# You'll have to add this to the top of your code:
import urllib.request as urlrq
import ssl
try:
   _create_unverified_https_context = ssl._create_unverified_context
except AttributeError:
   pass
else:
   ssl._create_default_https_context = _create_unverified_https_context
print(urlrq.urlopen('https://www.google.com').status) # returns 200
```
[Reference](https://stackoverflow.com/questions/38916452/nltk-download-ssl-certificate-verify-failed)



The following steps assume that you have bundled the CA `.crt` files into a single file, `ca-bundle.crt`. (e.g., `/etc/ssl/certs/ca-certificates.crt`). 

#### For problems with `pip`:
```python
# if problems with pip
pip config set global.cert path/to/ca-bundle.crt
pip config list
```

#### For problems with `conda` and `mamba`:
```python
conda config --set ssl_verify path/to/ca-bundle.crt
conda config --show ssl_verify
```
You can also disable SSL verification: `conda config --set ssl_verify false` [reference](https://stackoverflow.com/questions/33699577/conda-update-fails-with-ssl-error-certificate-verify-failed).

#### For problems with `git`:
```python
git config --global http.sslVerify true
git config --global http.sslCAInfo path/to/ca-bundle.crt
```
[Reference](https://stackoverflow.com/questions/39356413/how-to-add-a-custom-ca-root-certificate-to-the-ca-store-used-by-pip-in-windows/52961564#52961564)

#### For problems with `requests`:
```python
# If you still having problems with `requests`, try adding this to the top of your code
import requests
import os
os.environ['REQUESTS_CA_BUNDLE'] = 'path/to/ca-bundle.crt'
print(requests.get('https://www.google.com').status_code) # returns 200
```

#### For problems with `httpx`:
```python
import httpx
client = httpx.Client(verify="/path/to/ca-bundle.crt")
# Btw, you can supply this to other libraries like `openai`
from openai import OpenAI
client = OpenAI(http_client=client)
```

If you don't have a certificate, you can also set `verify=False`.

#### No network access in WSL2 when VPN is activated
Follow [these instructions](https://github.com/microsoft/WSL/issues/10380#issuecomment-1909996792) and add the following flags to a file called `C:\Users\_username_\.wslconfig` file:
```
[experimental]
networkingMode=mirrored
dnsTunneling=true
```

#### The `llama-cpp-python` package is giving an error when trying to use the GPU in WSL2
This appears to be a bug in `llama-cpp-python`. As a workaround, follow the steps described [here](https://github.com/abetlen/llama-cpp-python/issues/1064#issuecomment-1887952683).



<!--
WSL/system: everything works (even requests is set correctly with no environment variable needed)
WSL/venv: Everything works after  6 workaround setps
WSL/mamba: Everything works except urllib
-->
