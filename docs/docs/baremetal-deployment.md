# Bare-Metal Deployment

This document describes the initial HealthPulse bare-metal deployment using Terraform, EC2, and Nginx.

## Purpose

The bare-metal deployment demonstrates the traditional deployment model before containerization and Kubernetes orchestration.

## Infrastructure Provisioned

Terraform provisions the following AWS resources:

| Resource | Purpose |
|---------|---------|
| VPC | Isolated network for the application |
| Public Subnet | Hosts the EC2 instance |
| Internet Gateway | Provides internet access |
| Route Table | Routes public traffic |
| Security Group | Allows SSH, HTTP, and HTTPS |
| EC2 Instance | Hosts Nginx and the HealthPulse app |
| Elastic IP | Provides a static public IP |
| Key Pair | Enables SSH access |

## Automation

The EC2 instance is bootstrapped using `user_data.sh`.

The script:

- Installs Nginx
- Creates `/var/www/healthpulse`
- Adds a basic HealthPulse landing page
- Configures Nginx
- Exposes `/health`
- Enables and restarts Nginx

## Exposed Endpoints

| Endpoint | Purpose |
|---------|---------|
| `/` | Serves the HealthPulse application page |
| `/health` | Returns service health status |

## Validation Commands

```bash
curl http://<public-ip>/
curl http://<public-ip>/health
systemctl status nginx --no-pager
cat /etc/nginx/sites-available/healthpulse

Expected health response:

{"status":"healthy","deploy":"baremetal"}
Lessons Learned

This deployment shows what containers and orchestration later improve:

Manual server dependencies
Direct server management
Limited scalability
Harder rollback process
Environment drift risk
