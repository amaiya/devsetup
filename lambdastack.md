## Lambda Stack Setup

1. Install Lambda Stack following the [latest instructions](https://lambdalabs.com/lambda-stack-deep-learning-software).
```python
# example
wget -nv -O- https://lambdalabs.com/install-lambda-stack.sh | sh -
sudo reboot
# to update
sudo apt-get update && sudo apt-get dist-upgrade
```

2. Install Mamba Virtual Environment
  - Run [setup-conda.sh](https://github.com/amaiya/devsetup/blob/main/setup-conda.sh)
  - `mamba install python=3.9`
  - `mamba install pytorch torchvision cudatoolkit=11.6 cudnn=8.4`
  - `mamba install tensorflow` 
  - `export LD_LIBRARY_PATH=/home/<username>/mambaforge/lib:$LD_LIBRARY_PATH`

3. Setup up `python-venv` virtual environment
  - `python3 -m venv myvenv --system-site-packages`
  - `source myvenv/bin/activate`
  - upgrade numpy and typing in virtual environment and any other packages that pip complains about

**Note:** The version of `cudatoolkit` should be the version returned by `nvcc --version`, not `nvidia-smi`.

4. Upgrade all pip dependencies of a package: `pip install -U --upgrade-strategy eager <package_name>`. To be used before moving machine to an air-gapped network.


REFERENCE: [TensorFlow GPU Info](https://www.tensorflow.org/install/source#gpu)



### Troubleshooting

#### Mamba
From July 2023, `mamba install cudatoolkit=11.6` not longer works. Error was `DNN library is not found`.
Solution was:
1. Tried different versions of `cudnn` starting from 8.1 until a the GPU version of TensorFlow was not being replaced with a CPU version. This worked: `mamba install cudnn=8.4`
2. Used `export XLA_FLAGS=--xla_gpu_cuda_data_dir=/usr/lib/cuda` based on [this post](https://stackoverflow.com/questions/68614547/tensorflow-libdevice-not-found-why-is-it-not-found-in-the-searched-path).
i.e.,
```shell
$ find / -type d -name nvvm 2>/dev/null
/usr/lib/cuda/nvvm
$ cd /usr/lib/cuda/nvvm
/usr/lib/cuda/nvvm$ ls
libdevice
/usr/lib/cuda/nvvm$ cd libdevice
/usr/lib/cuda/nvvm/libdevice$ ls
libdevice.10.bc
export XLA_FLAGS=--xla_gpu_cuda_data_dir=/usr/lib/cuda
```
#### Lambda Labs GPU Cloud
1. Install mamba
2. `mamba install -c "nvidia/label/cuda-12.3" cuda-toolkit cudnn` 
3. `mamba install tensorflow` (e.g., 2.15.1).  (This will install CUDNN if not done in previous setup.)
4. [optional] Running `pip install tensorflow[and-cuda]==2.15.1 ` also works (tried after STEP 3). Installing TF 2.16.1 with pip did not work for some reason.
5. `nvcc --version` will show new version.  Shows 12.4??
References:
https://discuss.tensorflow.org/t/tensorflow-version-2-16-just-released/23140
https://hamel.dev/notes/cuda.html
https://www.tensorflow.org/install/source#gpu
