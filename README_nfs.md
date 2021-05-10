# Testing beacon node and validator with k8s manifests and NFS

This example demonstrates how to run one validator client and one beacon node using in a single node kubernetes cluster with [MicroK8s](https://microk8s.io/). This setup uses NFS to store beacon and validator's data. Please note this configuration is for testing only.

## Prerequisite

- [Install MicroK8s](https://microk8s.io/docs)
- Set up NFS (Example: [Guide for NFS installation and configuration on Ubuntu](https://ubuntu.com/server/docs/service-nfs)).

## Prepare the storage and manifests

1. Clone this repo.

    ```bash
    git clone https://github.com/lumostone/eth2xk8s.git
    ```

2. Create the data folders for beacon node and validator (and/or validator keys and secrets) on NFS.

3. Import validator keys.

4. Change the directory ownership. Assume the created data folders are under `/data`:

    ```bash
    chown -R 1001:2000 /data
    ```

5. Export the data directories:

    ```bash
    # Edit /etc/exports and add the created folders.
    sudo nano /etc/exports

    sudo exportfs -a 
    ```

6. Review all manifests and change the values if needed.

## Config the cluster

1. Create namespace. Remember to change `<namespace>` to the same namespace value as in the manifests. 

    ```bash
    kubectl create namespace <namespace>

2. Apply the manifests to create RBAC resources.

    ```bash
    microk8s kubectl apply -f rbac.yaml
    ```

## Deploy beacon node and validator clients
For Nimbus, create the Nimbus client with the following command:

```bash
kubectl apply -f nimbus-deployment.yaml
```

For Prysm:

1. Create the beacon node and expose it as a service for validator client.

    ```bash
    kubectl apply -f beacon-deployment.yaml -f beacon-service.yaml
    ```

2. Create the validator client and wallet secret.

    ```bash
    kubectl apply -f wallet-secret.yaml -f validator-deployment.yaml
    ```

For Lighthouse and Teku:

1. Create the beacon node and expose it as a service for validator client.

    ```bash
    kubectl apply -f beacon-deployment.yaml -f beacon-service.yaml
    ```

2. Create the validator client.

    ```bash
    kubectl apply -f validator-deployment.yaml
    ```
