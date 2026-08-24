# Panel ejecutivo — Google Calendar + Google Tasks

Tu agenda y tus tareas en una sola vista, con seguimiento de carga y ritmo de
cierre. Funciona en móvil y escritorio. Sin servidor, sin base de datos: los
datos van de tu navegador a Google y de vuelta.

**Puesta en marcha: 3 pasos, unos 5 minutos.**

---

## Paso 1 — Crea tu copia

Pulsa **Use this template → Create a new repository** en la parte superior de
este repositorio. Ponle el nombre que quieras y déjalo público.

> ¿Prefieres descargarlo? Baja el ZIP y sube los archivos a un repositorio nuevo.

## Paso 2 — Publícalo

En tu repositorio: **Settings → Pages → Source: Deploy from a branch → main / (root) → Save**.

Al minuto tendrás tu panel en:

```
https://TU-USUARIO.github.io/TU-REPO/
```

Ábrelo. Verás el panel funcionando con datos de ejemplo.

## Paso 3 — Conéctalo a tu cuenta

Pulsa **Entrar con Google**. El propio panel abre un asistente de tres pantallas
que te lleva de la mano: enlaces directos a cada pantalla de Google, botones para
copiar los valores exactos que hay que pegar, y validación del ID al final.

Cuando termines, el asistente te dará una línea para pegar en `config.js`. Eso es
todo lo que hace falta para que el panel te reconozca desde cualquier dispositivo.

---

## Por qué hay que pasar por Google

Google exige que cada copia del panel se registre con su propia credencial antes
de tocar un calendario ajeno. No existe forma de saltarse ese registro: no es una
limitación de este proyecto. La buena noticia es que se hace una sola vez y el
asistente reduce el trámite a copiar y pegar.

Lo que el asistente te pedirá crear:

| En Google | Qué es |
|---|---|
| Proyecto | El contenedor de tu configuración |
| Calendar API + Tasks API | Los dos servicios que el panel consulta |
| Pantalla de consentimiento | Lo que verás al iniciar sesión |
| ID de cliente OAuth | La credencial que identifica a tu panel |

Añade tu correo como **usuario de prueba** en la pantalla de consentimiento. Si no
lo haces, Google bloqueará el acceso.

---

## Cómo se usa

El panel lee tus listas de Google Tasks tal como están. Tres marcas opcionales en
el texto de una tarea activan funciones extra:

| Escribe | Efecto |
|---|---|
| `[1]` o `#foco` | Se convierte en el objetivo único del día |
| `[P]` o `⭐` | Se convierte en prioridad (hasta tres) |
| `[2h]`, `[90m]` | Suma horas a la carga del día |

Las marcas no se muestran en pantalla. Al completar una tarea en el panel, se
completa también en Google Tasks.

---

## Configuración

Todo vive en `config.js`:

```js
window.JMH_CONFIG = {
  clientId: "123456789-xxxx.apps.googleusercontent.com",
  jornadaHoras: 8
};
```

`index.html` no necesita tocarse nunca.

---

## Límites conocidos

- **Hasta 100 usuarios** mientras la app siga en modo Testing, con aviso de «app
  no verificada». Para uso personal o de equipo pequeño es suficiente.
- **La sesión dura una hora.** Al volver, el panel reconecta solo si tu sesión de
  Google sigue activa; si no, basta un clic.
- **El gráfico depende del historial de Google Tasks**, que es acotado. Los días
  más antiguos pueden quedar subestimados.
- **El calendario es de solo lectura.** Las tareas sí se escriben.

## Privacidad

No hay servidor intermedio. El ID de cliente es público por diseño y no es una
contraseña. Tu sesión vive en el almacenamiento local del dispositivo.

---

## Opcional (avanzado)

La carpeta `avanzado/` no hace nada por sí sola. Si no la necesitas, bórrala.

- `avanzado/setup.sh` — crea el proyecto de Google y activa las dos APIs desde la
  terminal con `gcloud`, para saltarte esas pantallas del asistente.
- `avanzado/deploy.yml` — despliegue por GitHub Actions con el `clientId` guardado
  como secreto del repositorio en lugar de escrito en `config.js`. Para activarlo:
  muévelo a `.github/workflows/deploy.yml`, ejecuta
  `gh secret set GOOGLE_CLIENT_ID` y cambia **Settings → Pages → Source** a
  *GitHub Actions*.

---

JAIRON MERCHÁN HAZ | JMH · ADVISORY | JMERCHANHAZ.COM
