# Testing beacon node and validator with k8s manifests and kind

This example demonstrates how to run one validator client and one beacon node in a single node kubernetes cluster with [kind](https://kind.sigs.k8s.io/). This setup uses `hostPath` to store beacon and validator's data with the host mount added on the kind node. Please note this configuration is for testing only.

## Prerequisite

- [Install kind](https://kind.sigs.k8s.io/docs/user/quick-start#installation)
- Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/), the Kubernetes command-line tool

## Prepare the storage and manifests

1. Clone this repo.

    ```bash
    git clone https://github.com/lumostone/eth2xk8s.git
    ```

2. Create the data folders for beacon node, validator (and/or validator keys and secrets).

3. Import validator keys.

4. Change the directory ownership. Assume the created data folders are under `/data`:

    ```bash
    chown -R 1001:2000 /data
    ```

5. Update the `extraMounts` in `cluster-config/kind-single-node.yaml` (in each client folder) with the paths to the created data folders.

6. Review all manifests and change the values if needed.

## Create and config the cluster

1. Create a kind cluster with the `cluster-config/kind-single-node.yaml` configuration.

    ```bash
    kind create cluster --config=cluster-config/kind-single-node.yaml 
    ```

2. Create namespace. Remember to change `<namespace>` to the same namespace value as in the manifests. 

    ```bash
    kubectl create namespace <namespace>

3. Apply the manifests to create RBAC resources.

    ```bash
    kubectl apply -f rbac.yaml
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
