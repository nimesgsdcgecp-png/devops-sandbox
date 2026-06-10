# ==========================================
# 1. PROVIDERS & CREDENTIALS
# ==========================================
terraform {
  required_providers {
    render = { source = "render-oss/render", version = "~> 1.0" }
    vercel = { source = "vercel/vercel", version = "~> 1.0" }
    neon   = { source = "kislerdm/neon", version = "~> 0.2" }
  }
}

# These variables will be passed in securely, never hardcoded
variable "neon_api_key" {}
variable "neon_org_id" {}
variable "render_api_key" {}
variable "render_owner_id" {}
variable "vercel_api_token" {}
variable "github_username" {
  description = "Your GitHub username for the repo URL"
  type        = string
}

provider "neon" { api_key = var.neon_api_key }
provider "render" { 
	api_key = var.render_api_key 
	owner_id = var.render_owner_id
}
provider "vercel" { api_token = var.vercel_api_token }

# ==========================================
# 2. DATABASE TIER (Neon Serverless Postgres)
# ==========================================
resource "neon_project" "sandbox_db_project" {
  name       = "terraform-sandbox-db"
  org_id = var.neon_org_id
  history_retention_seconds = 21600
}

resource "neon_database" "prod_db" {
  project_id = neon_project.sandbox_db_project.id
  branch_id  = neon_project.sandbox_db_project.default_branch_id
  name       = "system_users"
  owner_name = neon_role.db_user.name
}

resource "neon_role" "db_user" {
  project_id = neon_project.sandbox_db_project.id
  branch_id  = neon_project.sandbox_db_project.default_branch_id
  name       = "db_admin"
}

# ==========================================
# 3. BACKEND TIER (Spring Boot on Render)
# ==========================================
resource "render_web_service" "backend" {
  name   = "terraform-backend"
  plan   = "free"
  region = "singapore"
  
  # The new Render API groups all deployment settings inside runtime_source
  runtime_source = {
    docker = {
      repo_url    = "https://github.com/${var.github_username}/devops-sandbox"
      branch      = "main"
      context_dir = "backend"
    }
  }

  # Environment variables must now explicitly declare their 'value'
  env_vars = {
    "SPRING_DATASOURCE_URL" = {
      value = "jdbc:postgresql://${neon_project.sandbox_db_project.database_host}/${neon_database.prod_db.name}?sslmode=require"
    }
    "SPRING_DATASOURCE_USERNAME" = {
      value = neon_role.db_user.name
    }
    "SPRING_DATASOURCE_PASSWORD" = {
      value = neon_role.db_user.password
    }
  }
}

# ==========================================
# 4. FRONTEND TIER (Next.js on Vercel)
# ==========================================
resource "vercel_project" "frontend" {
  name      = "terraform-frontend"
  framework = "nextjs"
  
  git_repository = {
    type = "github"
    repo = "${var.github_username}/devops-sandbox"
  }
  
  root_directory = "frontend"

  # Dynamic Variable Injection: Terraform pulls the live URL from Render
  environment = [
    {
      target = ["production", "preview", "development"]
      key    = "BACKEND_URL"
      value  = render_web_service.backend.url
    }
  ]
}
