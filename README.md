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
   │      └── NGINX
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
* CDN-style asset access
* Bucket lifecycle rules
* Trash bucket for deleted objects
* Multi-client bucket isolation
* Docker-based deployment
* GitHub Container Registry support
* Production-ready reverse proxy

---

# Access URLs

### CDN Access

```
http://localhost/cdn/<bucket>/<object>
```

Example:

```
http://localhost/cdn/assets/image.jpg
```

---

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
```

Run the stack:

```
docker compose up -d
```

---

# Docker Image

Pull from GitHub Container Registry:

```
docker pull ghcr.io/fehmicorp/s3-storage:latest
```

Run container manually:

```
docker run -d \
 -p 80:80 \
 -p 8081:9001 \
 -e MINIO_ROOT_USER=admin \
 -e MINIO_ROOT_PASSWORD=password \
 -v $(pwd)/data:/data \
 ghcr.io/fehmicorp/s3-storage:latest
```

---

# Bucket Structure

The system uses the following buckets.

```
assets            → Public developer assets
system-trash      → Temporary deleted files
system-archive    → Long-term archived objects
```

Lifecycle rules automatically remove objects from `system-trash` after 90 days.

---

# Security Model

Each client can be assigned a dedicated bucket:

```
<client-uuid>
```

Access policies allow:

* Bucket owner access
* Shared bucket access
* Read-only public assets

---

# Object Access Example

Upload using S3 API:

```
PUT /assets/image.jpg
```

Access through CDN:

```
http://localhost/cdn/assets/image.jpg
```

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

* Signed CDN URLs
* Hotlink protection
* Rate limiting
* Multi-region storage
* Automatic bucket provisioning
* Web-based management API

---

# License

GNU AGPL v3