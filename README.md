# 🚀 **Deploy an EKS Cluster with Terraform – Like a Boss!**  

![banner](https://imgur.com/H3vXZeI.png)

---

## 📌 **Project Overview**  

![EKS Cluster Deployment](https://imgur.com/7iDEQQH.png)

This project uses **Terraform** to provision an **Amazon EKS Cluster** on AWS. By leveraging **Infrastructure as Code (IaC)**, we automate the deployment of Kubernetes clusters with modular and reusable Terraform configurations.  

🔹 **Kubernetes (K8s)** manages containerized applications efficiently.  
🔹 **EKS (Elastic Kubernetes Service)** is a managed K8s solution on AWS.  
🔹 **Terraform** simplifies infrastructure provisioning with reusable modules.  

With this setup, you can deploy, manage, and scale Kubernetes workloads seamlessly!  

---

## 📁 **Project Structure**  

The repository follows a **modular structure** for better organization and reusability:  

```tree
EKS-CLUSTER-TERRAFORM/
│── modules/                   # Terraform modules  
│   ├── eks/                   # EKS module  
│   │   ├── main.tf            # Defines EKS cluster  
│   │   ├── outputs.tf         # Outputs for EKS cluster  
│   │   ├── variables.tf       # Variables for EKS cluster  
│   ├── vpc/                   # VPC module  
│   │   ├── main.tf            # Defines networking resources  
│   │   ├── outputs.tf         # Outputs for VPC  
│   │   ├── variables.tf       # Variables for VPC  
│  
│── .gitignore                 # Git ignore file  
│── LICENSE                    # License file  
│── kubectl.sha256             # Checksum for kubectl  
│── .terraform.lock.hcl         # Terraform lock file  
│── kubernetes.tf              # Kubernetes resources definition  
│── main.tf                    # Root Terraform configuration  
│── outputs.tf                 # Root outputs  
│── provider.tf                 # Provider configurations  
│── README.md                   # Documentation (this file)  
```

🔹 **`modules/eks`** – Manages EKS cluster deployment.  
🔹 **`modules/vpc`** – Handles VPC and networking setup.  
🔹 **`provider.tf`** – Defines the AWS provider.  
🔹 **`main.tf`** – Root Terraform script to call modules.  
🔹 **`outputs.tf`** – Stores and displays useful deployment details.  

---

## 🎯 **Why Terraform for EKS?**  

Using Terraform for EKS offers **several advantages** over manual provisioning:  

✔ **Automated & Repeatable Deployments** – Reduce human error.  
✔ **Infrastructure as Code (IaC)** – Easily track changes.  
✔ **Dependency Awareness** – Ensures resources are created in the correct order.  
✔ **Scalability & Reusability** – Modular design for better maintainability.  

---

## ⚡ **Prerequisites**  

Before you begin, ensure you have the following installed:  

✅ **AWS Account** – Sign up at [AWS](https://aws.amazon.com/) if you don’t have one.  
✅ **Terraform** – Install from [Terraform's official site](https://developer.hashicorp.com/terraform/downloads).  
✅ **AWS CLI** – Install and configure credentials ([guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)).  
✅ **kubectl** – Kubernetes CLI tool ([installation guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/)).  
✅ **VS Code (Optional)** – Recommended IDE for managing Terraform code.  

---

## 🚀 **Deployment Steps**  

### 1️⃣ **Clone the Repository**  

```bash
git clone https://github.com/NotHarshhaa/eks-cluster-terraform
cd eks-cluster-terraform
```

---

### 2️⃣ **Initialize, Plan & Apply Terraform**  

Run the following Terraform commands:  

```bash
terraform init      # Initialize Terraform backend  
terraform plan      # Preview infrastructure changes  
terraform apply     # Deploy infrastructure  
```

📌 **Expected Outputs:**  

- EKS Cluster Name  
- Node IP Addresses  
- VPC ID  

---

### 3️⃣ **Connect to Your EKS Cluster**  

After deployment, retrieve cluster credentials:  

```bash
aws eks update-kubeconfig --name <EKS_CLUSTER_NAME> --region <AWS_REGION>
```

Verify cluster connectivity:  

```bash
kubectl get nodes
```

---

### 4️⃣ **Terraform Cloud Integration (Optional)**  

If you want to integrate with **Terraform Cloud**:  

1️⃣ Go to [Terraform Cloud](https://www.terraform.io/)  
2️⃣ Create a new **Workspace** and connect your GitHub repository.  
3️⃣ Add the following environment variables:  

```plaintext
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION
CONFIRM_DESTROY
```

4️⃣ **Run the Terraform plan & apply in Terraform Cloud.**  

---

### 5️⃣ **Destroy the Infrastructure**  

To **delete the deployed resources**, run:  

```bash
terraform destroy
```

Alternatively, if using **Terraform Cloud**, go to:  
**Settings → Destruction & Deletion → Queue destroy plan.**  

---

## 🎉 **Congratulations! You've Successfully Deployed an EKS Cluster with Terraform!**  

![Success](https://imgur.com/7iMQJlY.gif)

---

## **⭐ Hit the Star!**  

If you find this repository helpful and plan to use it for learning, please consider giving it a star ⭐. Your support motivates me to keep improving and adding more valuable content! 🚀  

---

## 🛠️ **Author & Community**  

This project is crafted with passion by **[Harshhaa](https://github.com/NotHarshhaa)** 💡.  

I’d love to hear your feedback! Feel free to open an issue, suggest improvements, or just drop by for a discussion. Let’s build a strong DevOps community together!  

---

## 📧 **Let's Connect!**  

Stay connected and explore more DevOps content with me:  

[![LinkedIn](https://img.shields.io/badge/LinkedIn-%230077B5.svg?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/harshhaa-vardhan-reddy)  [![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/NotHarshhaa)  [![Telegram](https://img.shields.io/badge/Telegram-26A5E4?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/prodevopsguy)  [![Dev.to](https://img.shields.io/badge/Dev.to-0A0A0A?style=for-the-badge&logo=dev.to&logoColor=white)](https://dev.to/notharshhaa)  [![Hashnode](https://img.shields.io/badge/Hashnode-2962FF?style=for-the-badge&logo=hashnode&logoColor=white)](https://hashnode.com/@prodevopsguy)  

---

## 📢 **Stay Updated!**  

Want to stay up to date with the latest DevOps trends, best practices, and project updates? Follow me on my blogs and social channels!  

![Follow Me](https://imgur.com/2j7GSPs.png)
