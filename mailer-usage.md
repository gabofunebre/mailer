# Guía de uso del servicio `mailer`

El servicio `mailer` es un microservicio HTTP para enviar correos salientes desde tus aplicaciones. Utiliza autenticación por token y expone un único endpoint `/send`.

---

## 🔐 Seguridad

- Requiere token `Bearer` en el header `Authorization`
- Solo expone el puerto 3322 **dentro de la red Docker interna** (`mailer_net`)
- Ideal para uso backend a backend

---

## 📤 Endpoint

### `POST /send`

#### Headers requeridos

```
Authorization: Bearer TU_TOKEN
Content-Type: application/json
```

#### JSON esperado:

```json
{
  "to": "usuario@destino.com",
  "subject": "Asunto del correo",
  "body": "<p>HTML del mensaje</p>",
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

- Si el `MAILER_TOKEN` no coincide, el servicio devuelve `401 Unauthorized`
- Si el JSON está mal formado, devuelve `400 Bad Request`
- Si hay error con SMTP, devuelve `500` con el mensaje de error

---

## 🔁 Uso típico

1. Tu app genera el contenido del correo (HTML, asunto, etc.)
2. Hace un `POST /send` al `mailer`
3. El `mailer` lo envía por SMTP2GO usando tu dominio (`gabo.ar`)
4. Devuelve confirmación o error

---
