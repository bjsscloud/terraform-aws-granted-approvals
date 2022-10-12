output "granted" {
  description = "Granted Approvals"
  value       = var.sso_granted["enabled"] ? module.granted[0] : null
}
