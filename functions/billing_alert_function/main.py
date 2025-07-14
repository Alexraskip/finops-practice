import os
from google.cloud import bigquery
import requests
import smtplib
from email.mime.text import MIMEText
from datetime import datetime

# === Config from env ===
PROJECT_ID = os.environ.get("PROJECT_ID")
DATASET_ID = os.environ.get("DATASET_ID")
ALERT_TABLES = os.environ.get("ALERT_TABLES", "daily_threshold_alerts,budget_alerts,anomaly_report,rightsizing_report").split(",")
SLACK_WEBHOOK_URL = os.environ.get("SLACK_WEBHOOK_URL")
EMAIL_SENDER = os.environ.get("EMAIL_SENDER")
EMAIL_RECIPIENT = os.environ.get("EMAIL_RECIPIENT")
EMAIL_PASSWORD = os.environ.get("EMAIL_PASSWORD")

client = bigquery.Client(project=PROJECT_ID)


def check_billing_alerts(event, context):
    """Main entry: triggered by Pub/Sub. Scans alert tables, sends Slack & email if needed."""

    combined_alerts = []

    for table in ALERT_TABLES:
        alerts = query_alerts(table)
        if alerts:
            print(f"⚠️ Found {len(alerts)} alerts in table: {table}")
            combined_alerts.append((table, alerts))
        else:
            print(f"✅ No alerts in table: {table}")

    if not combined_alerts:
        print("✅ No active alerts found across all tables.")
        return

    message = format_alert_message(combined_alerts)
    send_slack_notification(message)
    send_email_notification(message)


def query_alerts(table_name):
    """Query BigQuery alert table for active alerts."""
    query = f"""
        SELECT *
        FROM `{PROJECT_ID}.{DATASET_ID}.{table_name}`
        WHERE alert_status != 'OK'
        ORDER BY timestamp DESC
        LIMIT 100
    """
    query_job = client.query(query)
    return [dict(row.items()) for row in query_job]


def format_alert_message(alert_sets):
    """Builds a markdown message with all alerts grouped by table."""
    timestamp = datetime.utcnow().strftime("%Y-%m-%d %H:%M UTC")
    msg = f"🚨 *FinOps Alerts Detected* at {timestamp}\n\n"

    for table, alerts in alert_sets:
        msg += f"*Table:* `{table}` - {len(alerts)} alerts\n"
        for alert in alerts:
            msg += f"- Project: `{alert.get('project_id', 'N/A')}` | Cost: `{alert.get('cost', 'N/A')}` | Msg: {alert.get('alert_message', 'N/A')}\n"
        msg += "\n"

    return msg


def send_slack_notification(message):
    """Send alert to Slack."""
    if not SLACK_WEBHOOK_URL:
        print("⚠️ SLACK_WEBHOOK_URL not configured. Skipping Slack notification.")
        return

    try:
        response = requests.post(SLACK_WEBHOOK_URL, json={"text": message})
        response.raise_for_status()
        print("✅ Slack notification sent.")
    except Exception as e:
        print(f"❌ Failed to send Slack notification: {e}")


def send_email_notification(message):
    """Send alert email."""
    if not EMAIL_SENDER or not EMAIL_RECIPIENT:
        print("⚠️ EMAIL_SENDER or EMAIL_RECIPIENT not set. Skipping email.")
        return

    try:
        msg = MIMEText(message)
        msg["Subject"] = "🚨 FinOps Cost Alerts"
        msg["From"] = EMAIL_SENDER
        msg["To"] = EMAIL_RECIPIENT

        with smtplib.SMTP("smtp.gmail.com", 587) as server:
            server.starttls()
            if EMAIL_PASSWORD:
                server.login(EMAIL_SENDER, EMAIL_PASSWORD)
            server.send_message(msg)

        print("✅ Email alert sent.")
    except Exception as e:
        print(f"❌ Failed to send email: {e}")
