# 🚀 Deploying a Dockerized Apache Nano Website to Azure using Azure CLI + ACR + ACI

This project demonstrates how to:

* Build a Docker image from a local web app
* Push the image to **Azure Container Registry (ACR)**
* Deploy it using **Azure Container Instances (ACI)**
* Use **Managed Identity + AcrPull** role for secure access

---

## 📁 Project Structure

* `Dockerfile` → Docker config for Apache + Nano-based web content
* Images folder:

  * `myimage.png` → ACR image
  * `myrepo.png` → ACR registry
  * `Container-Instance.png` → ACI status in portal
  * `WebApp.png` → Running web app UI

---

## 🔨 Step-by-Step Setup

### ✅ 1. **Login to Azure and set your subscription**

```bash
az login
az account set --subscription "<your-subscription-name>"
```

---

### ✅ 2. **Create a Resource Group**

```bash
az group create --name myResourceGroup --location centralus
```

---

### ✅ 3. **Create Azure Container Registry (ACR)**

```bash
az acr create \
  --resource-group myResourceGroup \
  --name myrepo126 \
  --sku Basic \
  --admin-enabled true
```

📷 `myrepo.png`

---

### ✅ 4. **Login to ACR & Tag + Push Image**

```bash
az acr login --name myrepo126

# Build Docker image
docker build -t nano-website-apache .

# Tag image with ACR path
docker tag nano-website-apache myrepo126.azurecr.io/nano-website-apache:latest

# Push image
docker push myrepo126.azurecr.io/nano-website-apache:latest
```

📷 `myimage.png`

---

### ✅ 5. **Enable Managed Identity on Azure VM (if using VM)**

```bash
az vm identity assign --name Srv-01 --resource-group myResourceGroup
```

---

### ✅ 6. **Assign **\`\`** role to VM Identity**

```bash
# Get ACR resource ID
az acr show --name myrepo126 --query "id" --output tsv

# Assign AcrPull to the VM
az role assignment create \
  --assignee "$(az vm show --name Srv-01 --resource-group myResourceGroup --query identity.principalId --output tsv)" \
  --role AcrPull \
  --scope /subscriptions/<your-subscription-id>/resourceGroups/myResourceGroup/providers/Microsoft.ContainerRegistry/registries/myrepo126
```

---

### ✅ 7. **Deploy to Azure Container Instance (ACI)**

```bash
az container create \
  --resource-group myResourceGroup \
  --name nano-container \
  --image myrepo126.azurecr.io/nano-website-apache:latest \
  --dns-name-label nano-web-instance123 \
  --ports 80 \
  --os-type Linux \
  --cpu 1 \
  --memory 1.5 \
  --assign-identity
```

📷 `Container-Instance.png`

---

### ✅ 8. **Check Deployment**

```bash
az container show \
  --resource-group myResourceGroup \
  --name nano-container \
  --query "{FQDN:ipAddress.fqdn, Status:provisioningState}" \
  --output table
```

🔗 Open the app in your browser:
`http://nano-web-instance123.centralus.azurecontainer.io` 📷 `WebApp.png`

---

## 📄 Dockerfile Used

```Dockerfile
# Use Apache base image
FROM httpd:2.4
COPY ./nano-website/ /usr/local/apache2/htdocs/
```

📎 (Dockerfile included in repo)

---

## ✅ Clean Up (optional)

```bash
az container delete --name nano-container --resource-group myResourceGroup --yes
az group delete --name myResourceGroup --yes --no-wait
```

---

## 📦 Result

A live Nano-based web dashboard running securely on Azure Container Instance, pulling the image directly from your private ACR using managed identity.

---

## 💡 Next Steps

* Add CI/CD pipeline via GitHub Actions or Azure DevOps
* Enable HTTPS with custom domain
* Migrate to AKS or App Service for scaling

---

✅ **Maintained by:** `khodabakhshi.neda@gmail.com`
📁 Feel free to fork & enhance!
