# 🚀 AWS App Runner Demo with Spring Boot and GitHub Actions CI/CD

![Image](https://github.com/user-attachments/assets/530423bb-7188-49b2-bcac-734275c8247d)

Welcome to a complete deployment pipeline for your **Spring Boot app** using:
- 🐳 Docker
- ☁️ Amazon ECR
- ⚙️ AWS App Runner
- 🤖 GitHub Actions

This project shows how to go from code ➡️ container ➡️ deployed app automatically using CI/CD. This `README.md` will guide you through every step including screenshots, IAM setup, Dockerization, and deployment.

---

## 🧰 Tech Stack

- ☕ Spring Boot (Java 21)
- 🐳 Docker (multi-stage)
- 🛢️ Amazon ECR
- 🚀 AWS App Runner
- 🔐 IAM for secure access
- 🤖 GitHub Actions (CI/CD)

---

You're welcome! Here's a **simple yet clear flow diagram** that shows the end-to-end process — **from code to cloud** — using your Spring Boot, Docker, GitHub Actions, ECR, and AWS App Runner stack.

---

## 🔁 Code to Cloud Flow Diagram

```mermaid
graph TD
  A[💻 Developer Writes Code] --> B[🐙 Push to GitHub Repo]
  B --> C[🤖 GitHub Actions Triggered]
  C --> D[📦 Build Spring Boot JAR]
  D --> E[🐳 Build Docker Image]
  E --> F[☁️ Push to Amazon ECR]
  F --> G[🚀 AWS App Runner Pulls Image]
  G --> H[🌐 App Deployed to Public URL]
```



---

### 📦 Components Explained:

| Symbol | Description                                   |
| ------ | --------------------------------------------- |
| 💻     | Developer writes Spring Boot code             |
| 🐙     | Code pushed to GitHub triggers workflow       |
| 🤖     | GitHub Actions builds app, pushes to ECR      |
| 🐳     | Docker image created and uploaded to AWS ECR  |
| 🚀     | App Runner pulls from ECR and deploys the app |
| 🌐     | App is now live on a public URL               |

---



## 📦 Dockerfile Explained

### 🔍 What is a Multi-Stage Build?

In Docker, a **multi-stage build** allows you to:
- Compile and build your application in one stage
- Copy only the final `.jar` to a clean runtime image in another stage

👉 This reduces image size and keeps the production image clean and secure.

### 🐳 Dockerfile Breakdown

```Dockerfile
# 🏗️ Stage 1: Builder
FROM eclipse-temurin:21-jdk AS builder
WORKDIR /app
COPY . .
RUN ./mvnw clean package -DskipTests
````

* Uses JDK to **build the Spring Boot JAR**
* Skips tests for faster CI builds
* Packages everything into `target/app.jar`

```Dockerfile
# 🚀 Stage 2: Runtime
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

* Uses a smaller JRE image (Java Runtime only)
* **Only the JAR** is copied from the builder stage
* Exposes port `8080` and starts your Spring Boot app

### ✅ Benefits:

* Smaller image size
* Faster startup
* No Maven or source code in the final container

---

## 📁 .dockerignore

Keeps your Docker image clean by ignoring unnecessary files:

```dockerignore
target/
.git
.gitignore
README.md
Dockerfile
```

---

## 🔐 IAM Setup (Security First)

### 🧑‍💻 IAM User for GitHub Actions

Create an IAM user (e.g., `springboot-app-runner`) with:

* `AmazonEC2ContainerRegistryFullAccess` ✅
* `AWSAppRunnerFullAccess` ✅
* Custom inline policy:

```json
{
  "Effect": "Allow",
  "Action": "iam:PassRole",
  "Resource": "arn:aws:iam::YOUR_ACCOUNT_ID:role/AppRunnerECRAccessRole"
}
```

This allows GitHub Actions to **pass a role to App Runner**.

![Image](https://github.com/user-attachments/assets/576b344a-d65f-42a6-8bb4-5e842f740a69) <br>
![Image](https://github.com/user-attachments/assets/e521d813-09a4-4279-9c91-33c3a7eaaad2) <br>
![Image](https://github.com/user-attachments/assets/5692957e-7cfd-4f87-bd1d-1fbae37ceed8) <br>
![Image](https://github.com/user-attachments/assets/b7c3a04c-ba5a-4470-809a-b2134c3bf59d) <br>
![Image](https://github.com/user-attachments/assets/ad722fb6-ccb8-4610-bd8b-9121667b0a1f) <br>

---

### 🎟️ IAM Role for App Runner (access-role-arn)

Create a new **IAM Role** with:

**Trust Policy (custom):**

```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
          "Effect": "Allow",
          "Principal": {
            "Service": "build.apprunner.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
	]
}
```

**Permissions:**

* Attach: `AmazonEC2ContainerRegistryReadOnly`

![Image](https://github.com/user-attachments/assets/4e942a1c-dedc-4ae1-8975-e515634d6074) <br>
![Image](https://github.com/user-attachments/assets/5b65b6fa-ab11-42db-98f5-1eceb57b5c02) <br>
![Image](https://github.com/user-attachments/assets/2b30efce-d2ad-43c3-9e12-4a7a38db69e7) <br>
![Image](https://github.com/user-attachments/assets/f072653c-136a-42f7-a284-033974c43351) <br>
![Image](https://github.com/user-attachments/assets/b8c88eb6-224c-4e01-907c-386d9f00571d) <br>

---

## 🏗️ GitHub Actions Workflow: Step-by-Step

### ✅ 1. Checkout Code

```yaml
- uses: actions/checkout@v3
```

➡️ Pulls your latest source code from GitHub.

---

### 🔐 2. Authenticate to AWS

```yaml
- uses: aws-actions/configure-aws-credentials@v4
```

➡️ Uses `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` to allow access to AWS services.

Below Shows a Step by Step Guide for the Key creation

![Image](https://github.com/user-attachments/assets/86988d36-c371-4b8b-85ff-552abafec1f5) <br>
![Image](https://github.com/user-attachments/assets/e4365766-6b0e-4ce9-8649-8f2808c98d9b) <br>
![Image](https://github.com/user-attachments/assets/5ff3599d-948d-47c5-887f-1087b400956d) <br>
![Image](https://github.com/user-attachments/assets/4d681427-7005-49fd-a8b2-c019c0bd8153) <br>

---

### 📦 3. Log in to Amazon ECR

```yaml
- uses: aws-actions/amazon-ecr-login@v2
```

➡️ Logs Docker into your ECR registry so it can push the image.

---

### 🐳 4. Build and Push Docker Image

```bash
docker build -t $IMAGE_URI .
docker push $IMAGE_URI
```

➡️ Builds your app into a Docker image and pushes it to ECR.

---

### 🚀 5. Deploy to App Runner

```yaml
- uses: awslabs/amazon-app-runner-deploy@main
  with:
    service: springboot-apprunner
    image: 66656744752.dkr.ecr.us-east-1.amazonaws.com/my-springboot-app:latest
    region: us-east-1
    access-role-arn: ${{ secrets.APP_RUNNER_ACCESS_ROLE_ARN }}
```

➡️ Deploys the latest image from ECR to **AWS App Runner**
➡️ Uses the **IAM role** to pull the image securely

---

## 📬 GitHub Secrets Required

In your GitHub repo → `Settings > Secrets and variables > Actions`:

| Key                          | Description                 |
| ---------------------------- | --------------------------- |
| `AWS_ACCESS_KEY_ID`          | From IAM user               |
| `AWS_SECRET_ACCESS_KEY`      | From IAM user               |
| `APP_RUNNER_ACCESS_ROLE_ARN` | IAM role used by App Runner |

---

## 📸 Screenshots

* ✅ Spring Initializr setup <br>
![Image](https://github.com/user-attachments/assets/e6461efa-9f87-497e-ab1f-efc6cf573751) <br>

* 📦 ECR repository screen <br>
![Image](https://github.com/user-attachments/assets/541f0b7d-55dd-4f02-a312-7126cd850c72) <br>

* 🚀 App Runner deployment success <br>
![Image](https://github.com/user-attachments/assets/6cda2bd7-87be-4997-8188-d0bf1e80ae87) <br>
![Image](https://github.com/user-attachments/assets/6e82a2d1-d406-460b-b139-6d083838c9d6) <br>

* 📬 Github Action Execution <br>
![Image](https://github.com/user-attachments/assets/72b0108b-5277-43f6-baa5-27ba3b4edabc) <br>

---

## 🌐 Final Result

Once deployed, App Runner will give you a public URL like:

```
https://pnxwcd9w25.ap-southeast-1.awsapprunner.com
```

You can test it by visiting:

```
GET /
Response:
{
  "status": "success",
  "data": {
    "message": "Server is online",
    "code": 200
  }
}
```

---

## 🚧 Future Improvements

* 🔜 Add custom domain to App Runner
* 🔜 Add health checks and alerting
* 🔜 Switch to Terraform IaC
* 🔜 Add staging environment

---

## 🙌 Acknowledgements

* AWS App Runner Docs
* GitHub Actions Marketplace
* You — for deploying Java apps the cloud-native way ☁️

---

## ✨ Done!

You now have:

✅ Dockerized Spring Boot app <br>
✅ Pushed to Amazon ECR <br>
✅ Deployed to AWS App Runner <br>
✅ Automated with GitHub Actions <br>

Enjoy shipping with confidence! 🛳️💻🌐
