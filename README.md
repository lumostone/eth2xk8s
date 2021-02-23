# Eth2xK8s: Ethereum Staking with Kubernetes

## Testing the manifests with kind running a single node

This example demonstrates how to run one validator client and one beacon node using Prsym in a single node kubernetes with kind. This setup uses `hostPath` to store beacon and validator's data with the host mount added on the kind node. Please note this configuration is for testing only.

### Prerequisite

* [kind](https://kind.sigs.k8s.io/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

### Prepare the manifests

1. Create the data folders for beacon node and validator on the host machine. For examples:
    ```
    mkdir -p /data/prysm/validator /data/prysm/beacon
    ```

2. Clone this repo.
    ```
    git clone https://github.com/eth2xk8s/eth2xk8s.git
    ```

3. Update the `extraMounts` in `kind-host-path/config/single-node.yaml` with the path to the created data folder.

4. Create the validator wallet and replace `example-password` with your wallet password in `wallet-secret.yaml`.

5. Replace `<goerli eth1 node>` in `kind-host-path/beacon-deployment.yaml` with your eth1 node endpoint.

### Create and config the cluster

1. Navigate to `kind-host-path` directory and create a kind cluster with the `single-node.yaml` configuration.
    ``` 
    cd eth2xk8s/kind
    kind create cluster --config=config/single-node.yaml
    ```

2. Create the namespace and rbac resources.

    ```
    kubectl apply -f namespace.yaml -f rbac.yaml
    ```

3. Create the beacon node and expose it as a service for validator client.

    ```
    kubectl apply -f beacon-deployment.yaml -f beacon-service.yaml
    ```

4. Create the validator client.
    ```
    kubectl apply -f wallet-secret.yaml -f validator-deployment.yaml
    ```
