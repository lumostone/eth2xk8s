# Testing Prysm beacon node and validator with k8s manifests and NFS

This example demonstrates how to run one validator client and one beacon node using [Prysm](https://docs.prylabs.network/docs/getting-started) in a single node kubernetes cluster with [MicroK8s](https://microk8s.io/). This setup uses NFS to store beacon and validator's data. Please note this configuration is for testing only.

## Prerequisite

- [Install MicroK8s](https://microk8s.io/docs)
- Set up NFS (Example: [Guide for NFS installation and configuration on Ubuntu](https://ubuntu.com/server/docs/service-nfs)).

## Prepare the storage

1. Clone this repo.

    ```bash
    git clone https://github.com/lumostone/eth2xk8s.git
    ```

2. Create and export the data folders for beacon node and validator with the correct ownership on NFS. For example:

    ```bash
    mkdir -p /data/prysm/validator-client-1 /data/prysm/beacon

    chown -R 1001:2000 /data/prysm 

    # Edit /etc/exports and add the created folders.
    sudo nano /etc/exports

    sudo exportfs -a 
    ```

## Prepare the manifests

1. Create the validator wallet and import the validator account.

2. Replace `example-password` with your wallet password in `wallet-secret.yaml`.

3. Replace `<goerli eth1 node>` in `beacon-deployment.yaml` with your eth1 node endpoint.

4. Change `volumes.nfs.server` in `beacon-deployment.yaml` and `validator-deployment.yaml` to the correct NFS server IP address.

## Config the cluster

1. Apply the manifests to create the namespace and RBAC resources.

    ```bash
    microk8s kubectl apply -f namespace.yaml -f rbac.yaml
    ```

2. Create the beacon node and expose it as a service for validator client.

    ```bash
    microk8s kubectl apply -f beacon-deployment.yaml -f beacon-service.yaml
    ```

3. Create the validator client.

    ```bash
    microk8s kubectl apply -f wallet-secret.yaml -f validator-deployment.yaml
    ```
