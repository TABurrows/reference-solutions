
# TODO google_compute_target_pool main

# Health check for an elastic search data node mig
resource "google_compute_health_check" "autohealing" {
    name = "autohealing-health-check"
    check_interval_sec = 5
    timeout_sec = 5
    healthy_threshold = 2
    unhealthy_threshold = 10 # 50 seconds

    http_health_check = {
        request_path = "/"
        port = "9200"
    }
}


resource "google_compute_instance_group_manager" "main" {
    name = "es-data-nodes-mig"

    base_instance_name = "es-data-node-base"
    zone = var.subnet_name

    version {
        instance_template = google_compute_instance_template.main.self_link_unique
    }

    all_instances_config {
        metadata = {
            metadata_key = "metadata_value"
        }
        labels = {
            label_key = "label_value"
        }

    }

    target_pools = [ google_compute_target_pool.main.id]
    target_size = 2

    named_port {
        name = "elasticsearchTCP"
        port = 9200
    }

    auto_healing_policies {
        health_check = google_compute_health_check.autohealing.id
        initial_delay_sec = 300
    }

    wait_for_instances = true

}