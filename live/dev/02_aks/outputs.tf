output "cluster_name" {
  value = module.aks.cluster_name
}

output "cluster_id" {
  value = module.aks.cluster_id
}

output "resource_group_name" {
  value = module.aks.resource_group_name
}

output "kubelet_identity_object_id" {
  value = module.aks.kubelet_identity_object_id
}
