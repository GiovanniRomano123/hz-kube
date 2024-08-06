# Summary
The code in this repository creates a deployment of a Kubernetes cluster (k3s) with Terraform via a CI/CD pipeline (GitHub Actions) on the Hetzner Cloud.

The deployment is based on the solution developed in this [tutorial](https://community.hetzner.com/tutorials/setup-your-own-scalable-kubernetes-cluster). 

This repository expands on the tutorial by enabling the deployment via a CI/CD pipeline.

## How to deploy the code in this repository
1. Create all the keys described in this [tutorial]( https://community.hetzner.com/tutorials/setup-your-own-scalable-kubernetes-cluster) and replace all the public keys in the ``terraform.yml`` file with the newly generated keys. 
2. Create GitHub Action Secrets and store the Hetzner Cloud Token under ``HCLOUD_TOKEN``and the worker private SSH key under ``WORKER_PRIVATE_SSH_KEY``.
3. If this is needed, run manually the workflow. 

## ToDo:
1. Ensure that the workflow is triggered only by meaningful events, especially the ``terraform apply`` step. 
2. Create a simpler solution for substituting the values for the public keys. 
