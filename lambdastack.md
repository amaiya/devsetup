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
  - `mamba install pytorch torchvision cudatoolkit=11.6` # or mamba install tensorflow=2.9 cudatoolkit=11.2 cudnn=8.1
  - `mamba install tensorflow`
  - `export LD_LIBRARY_PATH=/home/<username>/mambaforge/lib:$LD_LIBRARY_PATH`

3. Setup up `python-venv` virtual environment
  - `python3 -m venv myvenv --system-site-packages`
  - `source myvenv/bin/activate`
  - upgrade numpy and typing in virtual environment and any other packages that pip complains about

**Note:** The version of `cudatoolkit` should be the version returned by `nvcc --version`, not `nvidia-smi`.

4. Upgrade all pip dependencies of a package: `pip install -U --upgrade-strategy eager <package_name>`. To be used before moving machine to an air-gapped network.


REFERENCE: [TensorFlow GPU Info](https://www.tensorflow.org/install/source#gpu)
