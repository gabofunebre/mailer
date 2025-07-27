from flask import Flask, request, jsonify
from email.message import EmailMessage
import smtplib, base64
import os

app = Flask(__name__)

@app.route("/send", methods=["POST"])
def send_email():
    # Validación de token simple vía header Authorization
    auth_header = request.headers.get("Authorization")
    expected_token = os.getenv("MAILER_TOKEN")
    if not auth_header or auth_header != f"Bearer {expected_token}":
        return jsonify({"error": "Unauthorized"}), 401

    data = request.get_json()
    required = ["to", "subject", "body"]
    if not all(k in data for k in required):
        return jsonify({"error": "Missing required fields"}), 400

    msg = EmailMessage()
    msg["Subject"] = data["subject"]
    msg["From"] = data.get("from", os.getenv("SMTP_FROM", "no-reply@gabo.ar"))
    msg["To"] = data["to"]
    msg.set_content("Este correo requiere un cliente compatible con HTML")
    msg.add_alternative(data["body"], subtype="html")

    for att in data.get("attachments", []):
        try:
            content = base64.b64decode(att["content"])
            msg.add_attachment(
                content,
                maintype=att.get("content_type", "application/octet-stream").split("/")[0],
                subtype=att.get("content_type", "application/octet-stream").split("/")[1],
                filename=att["filename"]
            )
        except Exception as e:
            return jsonify({"error": f"Invalid attachment: {e}"}), 400

    try:
        with smtplib.SMTP("mail.smtp2go.com", 587) as s:
            s.starttls()
            s.login(os.getenv("SMTP_USER"), os.getenv("SMTP_PASS"))
            s.send_message(msg)
        return jsonify({"status": "sent", "to": data["to"]}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500