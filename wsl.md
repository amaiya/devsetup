# How to Setup WSL

1. Install WSL (start Command Prompt as Adminstrator): `wsl --install`
2. Install [Windows Terminal](https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701?hl=en-us&gl=US)
3. Disable Terminal Bell in Settings of Windows Terminal
4. Add support for tab-switching in Windows Terminal JSON with:
  - `{ "command": "nextTab", "keys": "ctrl+pgdn" }`
  - `{ "command": "prevTab", "keys": "ctrl+pgup" }`
5. [OPTIONAL[ Edit Windows Terminal JSON to disable Ctrl-V paste (comment out or remove)
6. Install Mamba/Conda:
  - `wget https://raw.githubusercontent.com/amaiya/devsetup/main/setup-conda.sh`
  - `bash setup-conda.sh`
7. workplace setup:  Extra steps may be needed to install SSL certificates

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



<!--
WSL/system: everything works (even requests is set correctly with no environment variable needed)
WSL/venv: Everything works after  6 workaround setps
WSL/mamba: Everything works except urllib
-->
