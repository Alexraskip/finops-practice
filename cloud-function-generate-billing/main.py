import functions_framework
from google.cloud import bigquery
import random
from datetime import datetime, timezone

@functions_framework.http
def generate_and_upload(request):
    client = bigquery.Client()
    table_id = "finops-practice.billing_data.exported_billing"
    num_records = 10

    now = datetime.now(timezone.utc)
    invoice_month = now.strftime('%Y-%m')
    usage_start_time = now.strftime('%Y-%m-%dT%H:%M:%SZ')
    usage_end_time = usage_start_time

    departments = ['Engineering', 'Marketing', 'Finance', 'HR', 'Sales']
    cost_centers = ['CC100', 'CC200', 'CC300', 'CC400', 'CC500']
    environments = ['Prod', 'Dev', 'Test']
    pricing_models = ['On-Demand', 'Spot', 'Committed']
    resource_sizes = ['Small', 'Medium', 'Large']
    usage_types = ['baseline', 'spike', 'forecasted']
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

    rows_to_insert = []
    for _ in range(num_records):
        billing_account_id = f'BA{random.randint(1,5):05d}'
        project_id = f'project-{random.randint(1, 10000):05d}'
        project_name = f'Project-{project_id[-5:]}'
        department = random.choice(departments) if random.random() >= 0.1 else None
        cost_center = random.choice(cost_centers) if random.random() >= 0.1 else None
        environment = random.choice(environments)
        service = random.choice(services)
        sku = random.choice(skus[service])
        pricing_model = random.choice(pricing_models)
        resource_size = random.choice(resource_sizes)
        utilization = round(random.uniform(10, 100), 1)
        usage_type = random.choices(usage_types, weights=[0.95, 0.03, 0.02])[0]
        base_usage = random.uniform(0.1, 100)
        if usage_type == 'spike':
            base_usage *= random.uniform(2, 5)
        cost_multiplier = 0.05
        if pricing_model == 'Spot':
            cost_multiplier *= 0.5
        elif pricing_model == 'Committed':
            cost_multiplier *= 0.7
        cost = round(base_usage * cost_multiplier, 2)
        usage_amount = round(base_usage, 2)

        rows_to_insert.append({
            'invoice_month': invoice_month,
            'billing_account_id': billing_account_id,
            'project_id': project_id,
            'project_name': project_name,
            'service_description': service,
            'sku_description': sku,
            'usage_start_time': usage_start_time,
            'usage_end_time': usage_end_time,
            'usage_amount': usage_amount,
            'usage_unit': 'unit',
            'cost': cost,
            'currency': 'USD',
            'labels_department': department,
            'labels_cost_center': cost_center,
            'environment': environment,
            'resource_size': resource_size,
            'utilization': utilization,
            'usage_type': usage_type,
            'pricing_model': pricing_model
        })

    errors = client.insert_rows_json(table_id, rows_to_insert)
    if errors == []:
        return "✅ Successfully inserted 10 rows.", 200
    else:
        print(errors)
        return f"❌ Errors inserting rows: {errors}", 500
