# Short Gatekeeper Demo for Kubernetes 

This files are used to demonstrate two example use-case of Gatekeeper.
Gatekeeper is a specific version of the Open Policy Agent (OPA) and fully integrated in Kubernetes.

This demo shows how to:
- limit the allowed replicas in a deployment (min/max)
- restrict the usage of NodePort services

## Prequesites

- Docker Desktop
- Kubernetes Enabled in Docker Desktop
- ChatApp Image

## Demo
Start a Terminal in the main folder of this repo.
### 1. Set up the basics

This demo consists of two deplyoments and one network service. You can either deploy them one by one with the individual yaml files:

`kubectl apply -f deployments/source/chat-server-deployment.yml`

`kubectl apply -f deployments/source/userdb-deployment.yml`

`kubectl apply -f deployments/source/pse-chatnetwork-networkpolicy.yml`

or all at once with de complete yaml:

`kubectl apply -f deployments/chatapp-deployment-complete.yml`

To check wether the deployment was successful, verify that all pods are up and running:

`kubectl get pods`

To access the application check the services to see on which port the application is accessible on your localhost.

`kubectl get services`

If up and running you can acces the application in your webbrowser via: 
[localhost:YourPort]

### 2. Install Gatekeeper

To install Gatekeeper just use the official prebuild image.

`kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml`

If the installation succeded you should see a new namespace "gatekeeper-system" in your cluster.

To check use: `kubectl get namespaces`

To uninstall Gatekeeper just exhancge the "apply" keyword with "delete" or delete the "gatekeeper-system" namespace in your cluster. 

### 3. Setting up the Replica Limit Constraint 

First you need to import the constraint template which acts as a recipe-book for concrete constraint implementations.

`kubectl apply -f constrainttemplates/constraint-template-replica-limit.yml`

Afterwards import the concrete constraint, which restrict the replica to be within a range of two to five replicas.

`kubectl apply -f constraints/constraint-replica-limit.yml`

### 4. Audit the replica constraint

Check the violations of the constraint in your cluster:

`kubectl describe constraint replica-limit`

Without the name match (chat*) in the constraint,
you would see some violations by the gatekeeper-system and the userdb deployment.
To scale the userdb and provide multiple replicas, you would need to edit the whole mongo deployment to be able to share the same data amongst multiple pods.

For the sake of ease we just focus on the chat-server deployment.

Now edit the valid chat-server deployment.
You can either use vim or scale the deployment via command.

`kubectl scale --replicas=6 deployment/chat-server`

If you recheck the violations, the chat-server should now be listed as a violating deployment.
The violation doesn't get detected immediately as gatekeeper only checks for violations periodically.
So you may need to wait a short moment till you'll see the violation.

### 5. Setting up the NodePort constraint

Like before we first need to add the constraint template.

`kubectl apply -f constrainttemplates/constraint-template-node-port.yml`

And afterwards import the concrete constraint to disallow nodeport service.

`kubectl apply -f constraints/constraint-node-port.yml`

To check the violations on the constraint just use:

`kubectl describe constraint block-node-port`

As an alternative to NodePort the app should be accessed via an Ingress.



## Further information
The official install guide:
[https://open-policy-agent.github.io/gatekeeper/website/docs/install/]

A full library of predefined constraint templates:
[https://open-policy-agent.github.io/gatekeeper-library/website/]