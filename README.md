# 🚀 GitOps Deployment with ArgoCD and Helm

This repository contains the GitOps configuration and Helm charts used to deploy a Todo List Node.js application and MongoDB to a Kubernetes cluster. It integrates with ArgoCD for Continuous Deployment and uses an NFS server for persistent volume storage.

> 🛠️ **Note**: This repository is intended to be used by another automation repository that provisions the infrastructure using **Ansible** and **Terraform**. This repo handles the deployment phase using GitOps practices.
---

## 🧰 Tech Stack

- **CI Tool**: GitHub Actions (in the source code repo)  
- **CD Tool**: ArgoCD  
- **Kubernetes Resources**:
  - MongoDB StatefulSet  
  - MongoDB Headless Service  
  - MongoDB Persistent Volumes (backed by NFS)  
  - Application Deployment (Node.js Todo App)  
  - Application Service (NodePort)  
- **Helm**: Used for templating and managing Kubernetes resources

---

## 📂 Repo Structure

```
todo-list-gitops/
├── argocd/
│   └── application.yaml              # ArgoCD Application resource
├── helm/
│   ├── Chart.yaml                    # Helm chart metadata
│   ├── templates/                    # K8s manifests templates
│   └── values.yaml                   # Customizable variables (image tag, volume paths, etc.)
└── README.md
```

---

## ⚙️ Configuration Instructions

Before deploying, **edit the following fields in `helm/values.yaml` only**:

### 🔧 Persistent Volume Path

Update the path where MongoDB data should be stored on your NFS server:

```yaml
mongoVolumes:
  enabled: true
  basePath: /home/ec2-user/statefulset/nfs  # ✅ Edit this path if needed
```

### 🌐 NFS Server IP

Specify the IP address of your NFS server:

```yaml
mongoVolumes:
  nfsServer: 10.0.1.10  # ✅ Replace with your actual NFS server IP
```

✅ **No need to change the application image — it updates automatically. Just make sure the NFS server IP and mount path are correct.**

---

## 🚀 ArgoCD Setup 

### 🔧 Install ArgoCD

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
kubectl create namespace argocd
helm install argocd argo/argo-cd --namespace argocd
```

### 🌐 Access ArgoCD UI

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:80
```

Then open your browser at `http://localhost:8080`.

### 📥 Deploy GitOps Application

1. Clone this repository:

```bash
git clone https://github.com/YourUsername/YourReponame.git
cd todo-list-gitops
```

2. Apply the ArgoCD Application configuration:

```bash
kubectl apply -f argocd/application.yaml
```

---

## 🚀 ArgoCD Integration

The ArgoCD instance should point to this repository. It will automatically detect changes (like updated Helm values) and sync the cluster state.

The `application.yaml` file defines:

- Source: this GitOps repository and path to Helm chart  
- Destination: target K8s cluster and namespace  
- Sync policy: manual or automated

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: todo-app
spec:
  source:
    repoURL: https://github.com/YourUsername/YourReponame
    targetRevision: HEAD
    path: helm
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  project: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

> **Note**: Replace `YourUsername` with your actual GitHub username or organization name.

> **Note**: Replace `YourReponame` with your actual Repository name.
---

## 📝 License

MIT License  
© 2025 Abdallah Elaraby