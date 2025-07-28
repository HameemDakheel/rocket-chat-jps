# Rocket.Chat on Jelastic PaaS (Modern)

> **Note: This is a modernized version of the original Jelastic Rocket.Chat package.**
> The previous version is deprecated. This package has been updated to use the latest versions of Rocket.Chat and MongoDB, providing a more stable and secure installation.

---

<img align="left" width="150" src="images/rocketchat.png">

**Rocket.Chat** is a free, unlimited, and open-source platform for your business needs. Replace email, HipChat & Slack with the ultimate team chat software solution. Communicate with your team, share files, chat in real-time, or switch to video/audio conferencing.

This package automates the deployment of Rocket.Chat using pre-built Docker containers to [Jelastic PaaS](https://jelastic.com/), a platform that supports Java, PHP, Node.js, Ruby, Python, Docker, and Kubernetes, available in public, private, on-premise, virtual private, hybrid, and multi-cloud configurations.

&nbsp;

## Key Improvements

*   **Latest Rocket.Chat:** Always deploys the `latest` version of Rocket.Chat.
*   **Modern Database:** Uses an up-to-date MongoDB 7.x image for better performance and security.
*   **Simplified Setup:** The installation logic has been streamlined, removing complex replica set configurations for a faster and more reliable deployment.

## Deployment to the Cloud

1.  Get a Jelastic account from a hosting provider.
2.  Click the **DEPLOY TO JELASTIC** button below. This will redirect you to the installation widget.

<p align="center">
<a href="https://jelastic.com/install-application/?manifest=https://raw.githubusercontent.com/HameemDakheel/rocket-chat/master/manifest.yml">
  <img src="images/deploy-to-jelastic.svg" alt="Deploy to Jelastic" width="150">
</a>
</p>

> **Note:** If you are already registered with Jelastic,  you can deploy this application by navigating to **Import > URL** and pasting the manifest link below. This application is not available in the Marketplace.
> ```
> https://raw.githubusercontent.com/HameemDakheel/rocket-chat/master/manifest.yml
> ```

## Installation Process

In the installation window, you can customize:

*   __Environment__ name
*   __Display Name__
*   Destination __Region__

Then, click on __Install__.

<p align="center">
<img src="images/install.png" width="500">
</p>

Once the deployment is complete, you will see a success confirmation. Click **Open in Browser** to access your Rocket.Chat instance and complete the initial administrator setup.

<p align="center">
<img src="images/success.png" width="350">
</p>

For production environments, we recommend attaching a custom domain and securing it with a valid SSL certificate, which can be easily done using the Let's Encrypt SSL Add-On.