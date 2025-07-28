# Mailer Service

Microservicio de envío de correos por HTTP mediante SMTP. Diseñado para ser utilizado desde aplicaciones backend (Flask, FastAPI, etc.) mediante una API REST.

## Características

- Envía correos con HTML y adjuntos vía SMTP (MailerSend, u otro proveedor).
- Expone un único endpoint `POST /send` para envío de correos.
- Dockerizable y desacoplado del resto del sistema.
- Seguridad mediante token Bearer.
- Cuerpo del mail en HTML.
- Adjuntos opcionales (en base64).
- Logs automáticos desde el contenedor para trazabilidad.

## Uso

### Levantar el contenedor

```bash
make up
```

### Enviar un mail

```http
POST /send
Authorization: Bearer TU_TOKEN
Content-Type: application/json

{
  "to": "destinatario@example.com",
  "subject": "Bienvenido",
  "body": "<p>Gracias por registrarte.</p>",
  "from": "no-reply@tudominio.com",
  "attachments": [
    {
      "filename": "archivo.pdf",
      "content": "BASE64...",
      "content_type": "application/pdf"
    }
  ]
}
```

## Requisitos

- Docker y Docker Compose
- Red Docker externa llamada `mailer_net`
- Cuenta SMTP válida (MailerSend recomendado)
- Variables de entorno configuradas en `.env`:

```env
SMTP_USER=usuario_mailersend
SMTP_PASS=clave_mailersend
SMTP_FROM=no-reply@tudominio.com
SMTP_SERVER=smtp.mailersend.net
SMTP_PORT=587
MAILER_TOKEN=secreto123
```

## Notas

Este servicio está pensado para ser utilizado solo dentro de entornos internos y no expuesto al host.
