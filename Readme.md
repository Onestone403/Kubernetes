# Short Gatekeeper Demo for Kubernetes 

This files are used to demonstrate two example use-case of Gatekeeper.
Gatekeeper is a specific version of the Open Policy Agent (OPA) and fully integrated in Kubernetes.

This demo shows how to:
- limit the allowed replicas in a deyployment
- restrict the usage of NodePort Services

## Prequesites

Docker Desktop
Kubernetes Enabled in Docker Desktop
ChatApp Image

## Demo
Start a Terminal in the main folder of this repo.
### 1. Set up the basic

This demo consists of two deplyoments and one network service. You can either deploy them one by one with the individual yaml files:
`kubectl apply -f deployments/source/chat-server-deployment.yml
`
`kubectl apply -f deployments/source/userdb-deployment.yml
`
`kubectl apply -f deployments/source/pse-chatnetwork-networkpolicy.yml
`

or all at one with de complete yaml:
`kubectl apply -f deployments/chatapp-deplyoment-complete.yml
`

### 2. Install Gatekeeper
To install Gatekeeper just use the official prebuild image.
Further infos: [https://open-policy-agent.github.io/gatekeeper/website/docs/install/]

`kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
`

If the installation succeded you should see a new namespace "gatekeeper-system" in your cluster.

To unsitall Gatekeeper just exhancge the "apply" keyowrd with "delete" or delete the gatekeeper namespace in your cluster. 

### 3. Import the Replica Limit Constraint Template

`kubectl apply -f constraintTemplate/constraint-template-replica-limit.yml `

### 4. Evaluate the replica constraint