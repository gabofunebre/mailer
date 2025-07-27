# Mailer Service

Microservicio de envío de correos por HTTP mediante SMTP. Diseñado para ser utilizado desde aplicaciones backend (Flask, FastAPI, etc.) mediante una API REST.

## Características

- Envía correos con HTML y adjuntos vía SMTP (SMTP2GO, u otro).
- Expone un único endpoint `POST /send` para envío de correos.
- Dockerizable y desacoplado del resto del sistema.
- Preparado para producción y uso interno.
- Cuerpo del mail en HTML.
- Adjuntos opcionales (formato base64).

## Uso

### Levantar el contenedor

```bash
make up
```

### Enviar un mail

```http
POST /send
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

- Docker
- Red Docker externa llamada `mailer_net`
- Cuenta SMTP válida (como SMTP2GO)
