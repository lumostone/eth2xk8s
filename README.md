[![Automatically generate k8s yamls](https://github.com/lumostone/eth2xk8s/actions/workflows/helm-yaml-generation.yml/badge.svg?branch=master)](https://github.com/lumostone/eth2xk8s/actions/workflows/helm-yaml-generation.yml)

# Eth2xK8s: Ethereum Staking with Kubernetes

This repository contains Kubernetes (k8s) manifests and Helm charts that help Ethereum 2.0 stakers easily and safely install, upgrade and roll back Ethereum 2.0 clients. There are many [Ethereum 2.0 clients](https://ethereum.org/en/eth2/get-involved/#clients) and this project starts with [Prysm](https://docs.prylabs.network/docs/getting-started).

**This project is still in development and it's NOT recommended to be used on mainnet.**

## Install Prysm beacon node and validator with Helm

If the goal is to run Prysm on mainnet, we recommend to use

- Production-grade k8s distribution to build a k8s cluster.
- [NFS](https://en.wikipedia.org/wiki/Network_File_System) as the persistent storage.
- [Helm](https://helm.sh/) to manage packages and releases.

### Prerequisite

- Install a k8s distribution and build a cluster.
- [Install Helm](https://helm.sh/docs/intro/install/) on the k8s controller node.

### Install and configure NFS

1. Set up NFS (Example: [Guide for NFS installation and configuration on Ubuntu](https://ubuntu.com/server/docs/service-nfs)).

2. Create beacon node and validator data folders with the correct ownership (our Helm chart uses uid 1001 and gid 2000 by default) on NFS.

3. Create the wallet folder on NFS and import validator accounts (Example: [Import your validator accounts into Prysm](https://docs.prylabs.network/docs/mainnet/joining-eth2#step-4-import-your-validator-accounts-into-prysm)).

4. Export created data and wallet folders as described in the NFS configuration guide.

### Change the configurations to match your environment

1. Clone this repo.

    ```bash
    git clone https://github.com/lumostone/eth2xk8s.git
    ```

2. Change values in `./prysm/helm/values.yaml`.

   We recommend checking each field in `values.yaml` to determine the desired configuration. Fields that need to be changed or verified before installing the chart are the following ones:

   - **nfs.serverIp**: NFS server IP address.
   - **image.version**: Prysm client version.
   - **beacon.dataVolumePath**: The path to the data directory on the NFS for the beacon node.
   - **beacon.web3Provider** and **beacon.fallbackWeb3Providers**: Ethereum 1 node endpoints.
   - **validatorClients.validatorClient1.dataVolumePath**: The path to the data directory on the NFS for the validator.
   - **validatorClients.validatorClient1.walletVolumePath**: The path to the data directory on the NFS for the wallet.
   - **validatorClients.validatorClient1.walletPassword**: The wallet password.

### Install, upgrade, roll back and uninstall Helm chart

Replace `[release-name]` in the following command to the name you prefer.

- Install the chart.

   ```bash
   helm install [release-name] ./prysm/helm -nprysm --create-namespace
   ```

- Check installed manifests.

   ```bash
   helm get manifest [release-name] -nprysm
   ```

- Upgrade a release.

   ```bash
   helm upgrade [release-name] ./prysm/helm -nprysm
   ```

- Check release history.

   ```bash
   helm history [release-name] -nprysm
   ```

- Roll back a release to the target revision. Retrieve the target revision from release history and replace the `[release-revision]`.

   ```bash
   helm rollback [release-name] [release-revision] -nprysm
   ```

- Uninstall a release.

   ```bash
   helm uninstall [release-name] -nprysm
   ```

### Check client status

- Check the status of beacon node.

   ```bash
   kubectl logs -f -nprysm -lapp=beacon
   ```

- Check the status of the first validator (To check other validators, change -lapp to other validators' names).

   ```bash
   kubectl logs -f -nprysm -lapp=validator-client-1
   ```

## For Development or Testing

If you want to develop for this project or verify your configuration quickly without setting up NFS or other storage solution, we recommend the following setup:

- [kind](https://kind.sigs.k8s.io/) as the k8s distribution.
- [hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath) as the persistent storage.
- [Helm](https://helm.sh/) to manage packages and releases.

### How to run the Prysm client

1. Clone the repo.

2. Create the data folders for beacon node and validator. For example:

   ```bash
   mkdir -p /data/prysm/validator-client-1 /data/prysm/wallet-1 /data/prysm/beacon
   ```

3. Import validator accounts with the wallet directory created in the previous step.

4. Change the directory ownership:
   
   ```bash
   chown -R 1001:2000 /data/prysm
   ```

5. Update the `extraMounts` in `prysm/cluster-config/kind-single-node.yaml` with the paths to the created data directories.

6. Install kind and create a kind cluster.

   ```bash
   kind create cluster --config=prysm/cluster-config/kind-single-node.yaml 
   ```

7. Change values in `prysm/helm/values.yaml` to match your environment.

   - Set **persistentVolumeType** to `hostPath`.
   - Follow the [values.yaml configuration section](#change-the-configurations-to-match-your-environment) for more details.

8. Install the Helm chart `prysm/helm`.

## Testing k8s manifests

Please see [Testing manifests with Prysm and hostPath](https://github.com/lumostone/eth2xk8s/blob/master/prysm/host-path/README.md) and [Testing manifests with Prysm and NFS](https://github.com/lumostone/eth2xk8s/blob/master/prysm/nfs/README.md) for details.
