# Guía de uso del servicio `mailer`

El servicio `mailer` es un microservicio HTTP para enviar correos salientes desde tus aplicaciones backend. Utiliza autenticación por token, opera sobre SMTP (MailerSend) y expone un único endpoint: `/send`.

---

## 🔐 Seguridad

- Requiere token tipo Bearer en el header `Authorization`
- No está expuesto al host: solo accesible desde servicios conectados a la red Docker interna `mailer_net`
- Recomendado exclusivamente para comunicación **backend a backend**

---

## 📤 Endpoint

### `POST /send`

#### Headers requeridos:

```http
Authorization: Bearer TU_TOKEN
Content-Type: application/json
```

#### Cuerpo esperado (JSON):

```json
{
  "to": "usuario@destino.com",
  "subject": "Asunto del correo",
  "body": "<p>Contenido HTML del mensaje</p>",
  "from": "no-reply@gabo.ar",        // opcional
  "attachments": [                   // opcional
    {
      "filename": "archivo.pdf",
      "content": "BASE64_DEL_ARCHIVO",
      "content_type": "application/pdf"
    }
  ]
}
```

---

## ✅ Ejemplo con `curl`

```bash
curl -X POST http://mailer:3322/send \
  -H "Authorization: Bearer TU_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "usuario@example.com",
    "subject": "Bienvenido",
    "body": "<p>Gracias por registrarte.</p>"
  }'
```

---

## 🧠 Consideraciones

- Si el `MAILER_TOKEN` es incorrecto o falta → `401 Unauthorized`
- Si faltan campos requeridos → `400 Bad Request`
- Si ocurre un error en el envío SMTP → `500 Internal Server Error`
- Se puede adjuntar cualquier archivo en Base64 con su tipo MIME correcto

---

## 🔁 Flujo de uso

1. Tu aplicación genera el correo (HTML, asunto, etc.)
2. Hace un `POST` al servicio `mailer` usando el token secreto
3. El servicio envía el correo a través de MailerSend (SMTP)
4. Se registra el resultado (log del contenedor) y se responde con `200 OK` si fue exitoso

---

## 🛠️ Requisitos de red

- El contenedor `mailer` debe estar en la red `mailer_net`
- Las apps que deseen enviar correos deben estar también en esa red

---

## 🌐 Configuración vía `.env`

Estas variables deben estar configuradas:

```env
SMTP_USER=usuario_de_mailersend
SMTP_PASS=contraseña_de_mailersend
SMTP_FROM=no-reply@gabo.ar
SMTP_SERVER=smtp.mailersend.net
SMTP_PORT=587
MAILER_TOKEN=secreto123
```

---
