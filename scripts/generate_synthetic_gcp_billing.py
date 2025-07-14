import csv
import random
from datetime import datetime, timedelta

# Configuration
num_projects = 10000
num_billing_accounts = 5
days = 730  # 2 years
output_file = 'synthetic_gcp_billing_export.csv'

departments = ['Engineering', 'Marketing', 'Finance', 'HR', 'Sales']
cost_centers = ['CC100', 'CC200', 'CC300', 'CC400', 'CC500']
environments = ['Prod', 'Dev', 'Test']
pricing_models = ['On-Demand', 'Spot', 'Committed']
resource_sizes = ['Small', 'Medium', 'Large']
usage_types = ['normal', 'spike', 'forecasted']

services = [
    'Compute Engine', 'Cloud Storage', 'BigQuery', 'Cloud Functions',
    'Cloud Pub/Sub', 'Cloud SQL', 'Cloud Run', 'Kubernetes Engine'
]
skus = {
    'Compute Engine': ['N1 Standard VM', 'N2 Highmem VM', 'Preemptible VM'],
    'Cloud Storage': ['Standard Storage', 'Nearline Storage', 'Coldline Storage'],
    'BigQuery': ['On-demand Query', 'Flat-rate Query'],
    'Cloud Functions': ['Invocations', 'Compute Time'],
    'Cloud Pub/Sub': ['Message Delivery', 'Message Ingest'],
    'Cloud SQL': ['Instance Hours', 'Storage GB'],
    'Cloud Run': ['CPU Seconds', 'Memory GB-seconds'],
    'Kubernetes Engine': ['GKE Cluster Management', 'Node Usage']
}

header = [
    'invoice.month', 'billing_account_id', 'project.id', 'project.name',
    'service.description', 'sku.description', 'usage_start_time', 'usage_end_time',
    'usage.amount', 'usage.unit', 'cost', 'currency',
    'labels.department', 'labels.cost_center', 'environment',
    'resource.size', 'utilization', 'usage_type', 'pricing_model'
]

start_date = datetime(2023, 1, 1)

print(f'Generating synthetic billing data for {num_projects} projects over {days} days...')

with open(output_file, mode='w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(header)

    for project_id in range(1, num_projects + 1):
        billing_account_id = ((project_id - 1) % num_billing_accounts) + 1
        department = random.choice(departments)
        cost_center = random.choice(cost_centers)
        environment = random.choice(environments)

        for day in range(days):
            service = random.choice(services)
            sku = random.choice(skus[service])
            pricing_model = random.choice(pricing_models)
            resource_size = random.choice(resource_sizes)

            # Random utilization %
            utilization = round(random.uniform(10, 100), 1)

            # Simulate cost spikes
            usage_type = random.choices(
                ['normal', 'spike', 'forecasted'],
                weights=[0.95, 0.03, 0.02],
                k=1
            )[0]

            base_usage = random.uniform(0.1, 100)
            if usage_type == 'spike':
                base_usage *= random.uniform(2, 5)

            cost_multiplier = 0.05
            if pricing_model == 'Spot':
                cost_multiplier *= 0.5  # cheaper
            elif pricing_model == 'Committed':
                cost_multiplier *= 0.7

            cost = round(base_usage * cost_multiplier, 2)
            usage_amount = round(base_usage, 2)

            usage_start = (start_date + timedelta(days=day)).strftime('%Y-%m-%dT00:00:00Z')
            usage_end = (start_date + timedelta(days=day)).strftime('%Y-%m-%dT23:59:59Z')

            invoice_month = (start_date + timedelta(days=day)).strftime('%Y-%m')

            row = [
                invoice_month, f'BA{billing_account_id:05d}', f'project-{project_id:05d}', f'Project-{project_id:05d}',
                service, sku, usage_start, usage_end,
                usage_amount, 'unit', cost, 'USD',
                department, cost_center, environment,
                resource_size, utilization, usage_type, pricing_model
            ]

            writer.writerow(row)

print(f'✅ Done! File saved as {output_file}')
