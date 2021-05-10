[![Automatically generate k8s yamls](https://github.com/lumostone/eth2xk8s/actions/workflows/helm-yaml-generation.yml/badge.svg?branch=master)](https://github.com/lumostone/eth2xk8s/actions/workflows/helm-yaml-generation.yml)

# Eth2xK8s: Ethereum Staking with Kubernetes

This repository contains Kubernetes (k8s) manifests and Helm charts that help Ethereum 2.0 stakers easily and safely install, upgrade and roll back Ethereum 2.0 clients. There are many [Ethereum 2.0 clients](https://ethereum.org/en/eth2/get-involved/#clients) and this project includes [Prysm](https://github.com/prysmaticlabs/prysm), [Lighthouse](https://github.com/sigp/lighthouse), [Teku](https://github.com/ConsenSys/teku/) and [Nimbus](https://github.com/status-im/nimbus-eth2).

**This project is still in development and it's NOT recommended to be used on mainnet.**

## Detailed guide for running clients on Prater

We've written [a blog post](https://lumostone.com/en/eth2-staking-with-k8s-prysm/) detailing the requirement and walkthrough for running Prysm on Prater. We'll add guides for other clients soon!

## Install beacon node and validator with Helm

If the goal is to run Ethereum 2.0 clients on mainnet, we recommend to use

- Production-grade k8s distribution to build a k8s cluster.
- [NFS](https://en.wikipedia.org/wiki/Network_File_System) as the persistent storage.
- [Helm](https://helm.sh/) to manage packages and releases.

### Prerequisite

- Install a k8s distribution and build a cluster.
- [Install Helm](https://helm.sh/docs/intro/install/) on the k8s controller node.

### Install and configure NFS

1. Set up NFS (Example: [Guide for NFS installation and configuration on Ubuntu](https://ubuntu.com/server/docs/service-nfs)).

2. Create beacon node, validator (and/or validator keys and secrets) data folders with the correct ownership (our Helm chart uses uid 1001 and gid 2000 by default) on NFS.

3. Import validator keys.

4. Export created data folders as described in the NFS configuration guide.

### Change the configurations to match your environment

1. Clone this repo.

    ```bash
    git clone https://github.com/lumostone/eth2xk8s.git
    ```

2. Change values in the target client's values.yaml. For example, `./prysm/helm/values.yaml`.

    We recommend checking each field in `values.yaml` to determine the desired configuration. Fields that need to be changed or verified before installing the chart are the following ones:

    For all clients:
    - **nfs.serverIp**: NFS server IP address.
    - **securityContext.runAsUser**: The user ID will be used to run all processes in the container. The user should have the access to the mounted NFS volume.
    - **securityContext.runAsGroup**: The group ID will be used to run all processes in the container. The group should have the access to the mounted NFS volume. We use the group ID to grant limited file access to the processes so it won't use the root group directly.
    - **image.versionTag**: Client version.

    For Prysm:
    - **beacon.dataVolumePath**: The path to the data directory on the NFS for the beacon node.
    - **beacon.web3Provider** and **beacon.fallbackWeb3Providers**: Ethereum 1.0 node endpoints.
    - **validatorClients.validatorClient1**
      - **.dataVolumePath**: The path to the data directory on the NFS for the validator client.
      - **.walletVolumePath**: The path to the data directory on the NFS for the wallet.
      - **.walletPassword**: The wallet password.

    For Lighthouse:
    - **beacon.dataVolumePath**: The path to the data directory on the NFS for the beacon node.
    - **beacon.eth1Endpoints**: Ethereum 1.0 node endpoints.
    - **validatorClients.validatorClient1.dataVolumePath**: The path to the data directory on the NFS for the validator client.

    For Teku:
    - **beacon.dataVolumePath**: The path to the data directory on the NFS for the beacon node.
    - **beacon.eth1Endpoint**: Ethereum 1.0 node endpoint.
    - **validatorClients.validatorClient1**
      - **.dataVolumePath**: The path to the data directory on the NFS for the validator client.
      - **.validatorKeysVolumePath**: The path to the data directory on the NFS for the validator keys.
      - **.validatorKeyPasswordsVolumePath**: The path to the data directory on the NFS for the validator key passwords.

    For Nimbus:
    - **nimbus.clients.client1**
      - **.web3Provider** and **.fallbackWeb3Providers**: Ethereum 1.0 node endpoints.
      - **.dataVolumePath**: The path to the data directory on the NFS for the beacon node.
      - **.validatorsVolumePath**: The path to the data directory on the NFS for the validator keystores.
      - **.secretsVolumePath**: The path to the data directory on the NFS for the validator keystore passwords.

### Install, upgrade, roll back and uninstall Helm chart

Replace `<release-name>` and `<namespace>` in the following command to the name you prefer.

1. Go the directory of the target client

2. Install the chart.

   ```bash
   helm install <release-name> ./helm -n <namespace> --create-namespace
   ```

3. Check installed manifests.

   ```bash
   helm get manifest <release-name> -n <namespace>
   ```

4. Upgrade a release.

   ```bash
   helm upgrade <release-name> ./helm -n <namespace>
   ```

5. Check release history.

   ```bash
   helm history <release-name> -n <namespace>
   ```

6. Roll back a release to the target revision. Retrieve the target revision from release history and replace the `<release-revision>`.

   ```bash
   helm rollback <release-name> <release-revision> -n <namespace>
   ```

7. Uninstall a release.

   ```bash
   helm uninstall <release-name> -n <namespace>
   ```

### Check client status

For Nimbus:

- Check the status of Nimbus client.

   ```bash
   kubectl logs -f -n <namespace> -lapp=nimbus-1
   ```

For other clients:

- Check the status of beacon node.

   ```bash
   kubectl logs -f -n <namespace> -lapp=beacon
   ```

- Check the status of the first validator (To check other validators, change -lapp to other validators' names).

   ```bash
   kubectl logs -f -n <namespace> -lapp=validator-client-1
   ```

## For Development or Testing

If you want to develop for this project or verify your configuration quickly without setting up NFS or other storage solution, we recommend the following setup:

- [kind](https://kind.sigs.k8s.io/) as the k8s distribution.
- [hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath) as the persistent storage.
- [Helm](https://helm.sh/) to manage packages and releases.

### How to run the client

1. Create the data folders for beacon node, validator (and/or validator keys and secrets).

2. Import validator keys.

3. Change the directory ownership. Assume the created data folders are under `/data`:

   ```bash
   chown -R 1001:2000 /data
   ```

4. Clone the repo.

5. Go the directory of the target client.

6. Update the `extraMounts` in `cluster-config/kind-single-node.yaml` with the paths to the created data directories.

7. Install kind and create a kind cluster.

   ```bash
   kind create cluster --config=prysm/cluster-config/kind-single-node.yaml 
   ```

8. Change values in `helm/values.yaml` to match your environment.

   - Set **persistentVolumeType** to `hostPath`.
   - Follow the [values.yaml configuration section](#change-the-configurations-to-match-your-environment) for more details.

9. Install the Helm chart `helm`.

## Testing k8s manifests

Please see [Testing manifests with hostPath](https://github.com/lumostone/eth2xk8s/blob/master/README_hospath.md) and [Testing manifests with NFS](https://github.com/lumostone/eth2xk8s/blob/master/README_nfs.md) for details.
