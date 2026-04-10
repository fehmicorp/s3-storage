### Fehmi CDN Object Storage ###

Lightweight CDN object storage service built using **MinIO** and **NGINX**, packaged as a Docker image.

This project provides an S3-compatible object storage gateway that can be used for:

* Static asset storage
* Application file storage
* CDN delivery
* Multi-client object storage
* Developer asset hosting

The storage backend is powered by MinIO while NGINX acts as a reverse proxy to expose CDN routes.

---

# Architecture

```
Internet
   │
   ├── Port 80
   │      │
   │      └── NGINX API Gateway
   │             │
   │             └── /cdn → MinIO API (9000)
   │
   └── Port 8081
          │
          └── MinIO Management Console (9001)
```

---

# Features

* S3-compatible object storage
* API-key protected CDN/API gateway
* Optional pre-signed URL support for temporary frontend access
* Bucket lifecycle rules
* Trash bucket for deleted objects
* Multi-client bucket isolation
* Docker-based deployment
* GitHub Container Registry support
* Production-ready reverse proxy

---

# Access URLs

### CDN/API Access

```
http://localhost/cdn/<bucket>/<object>
```

### MinIO Console

```
http://localhost:8081
```

Login using the credentials defined in the `.env` file.

---

# Deployment

## Using Docker Compose

Create `.env` file:

```
MINIO_ROOT_USER=admin
MINIO_ROOT_PASSWORD=securepassword
MINIO_REGION=asia-south-1
MINIO_REGION_NAME=india-lucknow

# API keys used by nginx gateway
CDN_SERVER_API_KEY=change-this-server-key
CDN_FRONTEND_API_KEY=change-this-frontend-key
```

Run the stack:

```
docker compose up -d
```

---

# Security Model (API style)

`assets` is private by default. Access is granted through the gateway:

1. **Server key (full access)**
   * Header: `Authorization: Bearer <CDN_SERVER_API_KEY>`
   * Intended for backend services / microservices.

2. **Frontend key (read-only)**
   * Header: `Authorization: Bearer <CDN_FRONTEND_API_KEY>`
   * Allows `GET/HEAD/OPTIONS` only.

3. **Pre-signed URLs (temporary access)**
   * Any request that contains a valid MinIO/S3 signature query (`X-Amz-Signature`) is forwarded.
   * Recommended for browser downloads without sharing long-lived keys.

Rate limiting is enabled at the gateway (`30 req/s` per client IP, burst `60`).

---

# Request Examples

Backend upload:

```bash
curl -X PUT "http://localhost/cdn/assets/image.jpg" \
  -H "Authorization: Bearer $CDN_SERVER_API_KEY" \
  --data-binary @image.jpg
```

Frontend download:

```bash
curl "http://localhost/cdn/assets/image.jpg" \
  -H "Authorization: Bearer $CDN_FRONTEND_API_KEY"
```

---

# Docker Image

Pull from GitHub Container Registry:

```
docker pull ghcr.io/fehmicorp/s3-storage:latest
```

---

# Bucket Structure

```
assets            → Protected developer assets
system-trash      → Temporary deleted files
system-archive    → Long-term archived objects
```

Lifecycle rules automatically remove objects from `system-trash` after 90 days.

---

# Development

Build image locally:

```
docker build -t fehmi/cdn-storage .
```

Push to GitHub Packages:

```
docker tag fehmi/cdn-storage ghcr.io/fehmicorp/s3-storage:latest
docker push ghcr.io/fehmicorp/s3-storage:latest
```

---

# Roadmap

Future improvements planned:

* Signed CDN URLs with expiry policies
* Hotlink protection
* Rate limiting per API key
* Multi-region storage
* Automatic bucket provisioning
* Web-based management API

---

# License

GNU AGPL v3
