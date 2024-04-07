#!/bin/bash

# Prompt for Nexus repository details
read -p 'Enter Nexus Repository URL (without http:// or https://): ' nexus_repo_url
read -p 'Enter Nexus Repository Port: ' nexus_repo_port
read -p 'Enter Docker Registry Username: ' registry_username
read -p 'Enter Docker Registry Password: ' registry_password
read -p 'Enter Docker Registry Email: ' registry_email
read -p 'Enter Namespace (default if empty): ' k8s_namespace
read -p 'Enter Secret Name: ' secret_name

# Combine URL and port
nexus_full_url="${nexus_repo_url}:${nexus_repo_port}"

# Base64 encode the username and password
encoded_credentials=$(echo -n "${registry_username}:${registry_password}" | base64)

# Prepare .dockerconfigjson content
docker_config_json=$(cat <<EOF
{
  "auths": {
    "${nexus_full_url}": {
      "username": "${registry_username}",
      "password": "${registry_password}",
      "email": "${registry_email}",
      "auth": "${encoded_credentials}"
    }
  }
}
EOF
)

# Base64 encode the entire .dockerconfigjson
encoded_docker_config_json=$(echo -n "${docker_config_json}" | base64 -w0)

# Determine the namespace string for the YAML
namespace_str=""
if [ ! -z "$k8s_namespace" ]; then
  namespace_str="  namespace: $k8s_namespace"
fi

# Generate Kubernetes secret YAML
cat > "${secret_name}.yaml" <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: ${secret_name}
${namespace_str}
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: ${encoded_docker_config_json}
EOF

echo "Generated Kubernetes secret YAML: ${secret_name}.yaml"
