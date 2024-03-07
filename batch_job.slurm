#!/bin/bash
#SBATCH --job-name=hb_tfactivity
#SBATCH --output hb_tfactivity_%j.out
#SBATCH -e hb_tfactivity_%j.err
#SBATCH --mail-user=hmbaghda@mit.edu
#SBATCH --mail-type=ALL
#SBATCH --gres=gpu:1
#SBATCH --gpus-per-node=1
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=500G
#SBATCH --time=11:59:59

## User python environment
ENV_NAME="scLEMBAS"
CONDA_PATH="/nobackup/users/hmbaghda/Software/miniforge3/"


source ${CONDA_PATH}/etc/profile.d/conda.sh
conda activate $ENV_NAME
python 01_process_data.py
