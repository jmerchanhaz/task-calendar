# Panel ejecutivo — Google Calendar + Google Tasks

Tu agenda y tus tareas en una sola vista, con foco del día, carga comprometida y
ritmo de cierre. Funciona en móvil y en escritorio.

Sin servidor y sin base de datos: los datos van de tu navegador a Google y de
vuelta. Nadie más los ve.

**Puesta en marcha: 3 pasos, unos 5 minutos.**

---

## Qué muestra

| Bloque | Contenido |
|---|---|
| Cinco señales | Vencidas · Vencen hoy · Resto de semana · Cerradas 7 d · Cumplimiento 30 d |
| Foco del día | Un objetivo único y hasta tres prioridades |
| Agenda de hoy | Eventos con duración, en formato de 24 horas, con el bloque en curso resaltado |
| Carga comprometida | Horas de calendario más horas estimadas de tareas, contra tu jornada |
| Tablero | Vencidas · Hoy · Esta semana · Después — con cierre en un clic |
| Ritmo de cierre | Tareas completadas y horas ocupadas, en 7, 14 o 30 días |
| Carga por proyecto | Tabla por lista de Google Tasks |

---

## Paso 1 — Crea tu copia

Pulsa **Use this template → Create a new repository**. Ponle el nombre que
quieras y déjalo público.

## Paso 2 — Publícalo

**GitHub Pages** — en tu repositorio: *Settings → Pages → Source: Deploy from a
branch → main / (root) → Save*. Al minuto estará en
`https://TU-USUARIO.github.io/TU-REPO/`.

**Cloudflare Pages** — *Workers & Pages → Create → Pages → Connect to Git*,
elige el repositorio y despliega sin comando de compilación. Si vas a usar un
dominio propio, añádelo en *Custom domains* del proyecto: Cloudflare crea el
registro DNS y emite el certificado por su cuenta.

Abre la dirección. Verás el panel funcionando con datos de ejemplo.

## Paso 3 — Conéctalo a tu cuenta

Pulsa **Entrar con Google**. Un asistente de tres pantallas te lleva de la mano:
enlaces directos a cada página de Google, botones para copiar los valores
exactos y validación del ID al final.

Al terminar te dará una línea para pegar en `config.js`. Con eso el panel te
reconoce desde cualquier dispositivo.

---

## Cómo se usa

Cada tarea abierta muestra dos botones:

| Botón | Efecto |
|---|---|
| **★** | Fija una prioridad. Máximo tres. |
| **◎** | Fija el objetivo del día. Es único: al poner uno, el anterior se libera. |
| Círculo | Completa la tarea. |

**Todo se escribe en Google Tasks.** Si abres la app de Google verás las marcas
`[P]` y `[1]` en el título. Y al revés: lo que marques desde tu teléfono aparece
aquí. Una sola fuente de verdad, sin base de datos intermedia.

Para que el panel calcule horas, escribe la duración entre corchetes en el
título o las notas: `[2h]`, `[90m]`, `[1.5h]`. No se muestra en pantalla.

---

## Configuración

Todo vive en `config.js`. Es el único archivo que se edita.

```js
window.JMH_CONFIG = {
  clientId: "123456789-xxxx.apps.googleusercontent.com",
  jornadaHoras: 8
};
```

`index.html` no se toca nunca.

---

## Si algo falla

### Error 403: `access_denied`
> «La app se está probando y solo pueden acceder los testers aprobados»

Tu correo no está en la lista de usuarios de prueba. En **Google Auth Platform →
Público**, sección *Usuarios de prueba*, añade tu dirección tal como aparece en
la pantalla de bloqueo. Guarda y reintenta al minuto.

Comprueba que arriba esté seleccionado el mismo proyecto donde creaste la
credencial. Tener varios proyectos es la causa más frecuente.

### Error 400: `origin_mismatch`
> «Registra el origen de JavaScript en Google Cloud Console»

La dirección desde la que abriste el panel no está autorizada. En **Google Auth
Platform → Clientes → tu cliente web**, campo *Orígenes autorizados de
JavaScript* — no el de URIs de redireccionamiento — añade tu origen exacto.

Cuatro detalles que rompen esto:

- Sin barra final: `https://midominio.com`, nunca `https://midominio.com/`
- Sin ruta: nada de `/panel` ni `/index.html`
- Siempre `https`, salvo `http://localhost` para pruebas locales
- `www.midominio.com` y `midominio.com` son orígenes distintos

Si publicas en dos sitios a la vez, registra ambos. No hay penalización.

> **Cloudflare Pages:** cada despliegue de vista previa genera una dirección
> propia (`abc123.proyecto.pages.dev`) y Google **no admite comodines**. Prueba
> siempre sobre tu dominio propio o sobre la URL de producción.

### El dominio propio no carga (`ERR_CONNECTION_TIMED_OUT`)

El nombre resuelve pero nadie responde por él. Casi siempre hay un registro
antiguo de reenvío o de parking del registrador. Bórralo primero: mientras
exista, el registro nuevo no toma efecto. Luego configura el dominio desde el
panel de tu hosting, no a mano.

La caché del navegador conserva el fallo. Comprueba en incógnito o limpia
`chrome://net-internals/#dns`.

### Aviso de «app no verificada»
Normal mientras la app esté en modo Testing. Pulsa *Configuración avanzada →
Continuar*. Desaparece solo tras la verificación formal de Google, que exige
política de privacidad y términos publicados.

---

## Límites conocidos

- **Hasta 100 usuarios** en modo Testing. Suficiente para uso personal o de
  equipo pequeño.
- **La sesión dura una hora.** Al volver, el panel reconecta solo si tu sesión de
  Google sigue activa; si no, basta un clic.
- **El gráfico depende del historial de Google Tasks**, que es acotado. Los días
  más antiguos pueden quedar subestimados.
- **El calendario es de solo lectura.** Las tareas sí se escriben.
- **Las marcas viven en el título.** Es el precio de no tener base de datos
  propia. Si otra herramienta tuya lee esos títulos, verá los prefijos.

## Privacidad

No hay servidor intermedio. El ID de cliente es público por diseño y no es una
contraseña. Tu sesión vive en el almacenamiento local del dispositivo y se borra
al cerrar sesión.

---

## Opcional (avanzado)

La carpeta `avanzado/` no hace nada por sí sola. Si no la necesitas, bórrala.

- `avanzado/setup.sh` — crea el proyecto de Google y activa las dos APIs desde la
  terminal con `gcloud`, para saltarte esas pantallas del asistente.
- `avanzado/deploy.yml` — despliegue por GitHub Actions con el `clientId` guardado
  como secreto del repositorio en lugar de escrito en `config.js`. Para
  activarlo: muévelo a `.github/workflows/deploy.yml`, ejecuta
  `gh secret set GOOGLE_CLIENT_ID` y cambia *Settings → Pages → Source* a
  *GitHub Actions*.

---

JAIRON MERCHÁN HAZ | JMH · ADVISORY | JMERCHANHAZ.COM
