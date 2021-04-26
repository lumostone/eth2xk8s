# Testing Prysm beacon node and validator with k8s manifests and kind

This example demonstrates how to run one validator client and one beacon node using [Prysm](https://docs.prylabs.network/docs/getting-started) in a single node kubernetes cluster with [kind](https://kind.sigs.k8s.io/). This setup uses `hostPath` to store beacon and validator's data with the host mount added on the kind node. Please note this configuration is for testing only.

## Prerequisite

- [Install kind](https://kind.sigs.k8s.io/docs/user/quick-start#installation)
- Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/), the Kubernetes command-line tool

## Prepare the storage

1. Clone this repo.

    ```bash
    git clone https://github.com/lumostone/eth2xk8s.git
    ```

2. Create the data folders for beacon node and validator and change the ownership. For example:

    ```bash
    mkdir -p /data/prysm/validator-client-1 /data/prysm/wallet-1 /data/prysm/beacon

    chown -R 1001:2000 /data/prysm
    ```

3. Import validator accounts with the wallet directory created in the previous step.

4. Update the `extraMounts` in `prysm/cluster-config/kind-single-node.yaml` with the paths to the created data folders.

## Prepare the manifests

1. Create the validator wallet and import the validator account.

2. Replace `example-password` with your wallet password in `wallet-secret.yaml`.

3. Replace `<goerli eth1 node>` in `beacon-deployment.yaml` with your eth1 node endpoint.

## Create and config the cluster

1. Create a kind cluster with the `prysm/cluster-config/kind-single-node.yaml` configuration.

    ```bash
    kind create cluster --config=prysm/cluster-config/kind-single-node.yaml 
    ```

2. Apply the manifests to create the namespace and RBAC resources.

    ```bash
    kubectl apply -f namespace.yaml -f rbac.yaml
    ```

3. Create the beacon node and expose it as a service for validator client.

    ```bash
    kubectl apply -f beacon-deployment.yaml -f beacon-service.yaml
    ```

4. Create the validator client.

    ```bash
    kubectl apply -f wallet-secret.yaml -f validator-deployment.yaml
    ```
