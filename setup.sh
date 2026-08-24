#!/usr/bin/env bash
# ==============================================================================
# Aprovisiona el proyecto de Google Cloud del panel — sin abrir la consola web.
#
#   Uso:  ./setup.sh [ID_DEL_PROYECTO]
#   Req.: gcloud CLI  ->  https://cloud.google.com/sdk/docs/install
#
# Automatiza: creación del proyecto y habilitación de las APIs.
# NO automatiza: la creación del ID de cliente OAuth (Google no expone API
# pública para ello). Ese paso queda impreso al final, con el enlace directo.
# ==============================================================================
set -euo pipefail

PROJECT_ID="${1:-jmh-panel-$(date +%s | tail -c 7)}"
PROJECT_NAME="Panel ejecutivo JMH"

say(){ printf '\n\033[1;34m▸ %s\033[0m\n' "$1"; }

command -v gcloud >/dev/null || { echo "Falta gcloud CLI. Instálalo primero."; exit 1; }

say "Verificando sesión"
gcloud auth list --filter=status:ACTIVE --format='value(account)' | grep -q . \
  || gcloud auth login

say "Proyecto: $PROJECT_ID"
if gcloud projects describe "$PROJECT_ID" >/dev/null 2>&1; then
  echo "Ya existe. Se reutiliza."
else
  gcloud projects create "$PROJECT_ID" --name="$PROJECT_NAME"
fi
gcloud config set project "$PROJECT_ID" >/dev/null

say "Habilitando APIs (Calendar + Tasks)"
gcloud services enable calendar-json.googleapis.com tasks.googleapis.com

PNUM=$(gcloud projects describe "$PROJECT_ID" --format='value(projectNumber)')

cat <<EOF

──────────────────────────────────────────────────────────────
  LISTO LO AUTOMATIZABLE
    Proyecto : $PROJECT_ID  (número $PNUM)
    APIs     : Calendar API · Tasks API  → habilitadas

  FALTA UN PASO MANUAL (~4 minutos, una sola vez)
  Google no permite crear clientes OAuth de consumidor por API.

  1) Pantalla de consentimiento — tipo Externo:
     https://console.cloud.google.com/auth/overview?project=$PROJECT_ID
     Ámbitos a declarar:
       https://www.googleapis.com/auth/calendar.readonly
       https://www.googleapis.com/auth/tasks

  2) Crear ID de cliente OAuth → Aplicación web:
     https://console.cloud.google.com/auth/clients/create?project=$PROJECT_ID
     Orígenes de JavaScript autorizados (exactos, sin barra final):
       https://TU-USUARIO.github.io
       https://dash.jmerchanhaz.com

  3) Guarda el ID como secreto del repositorio:
     gh secret set GOOGLE_CLIENT_ID --body "TU-ID.apps.googleusercontent.com"

  Desde ahí, cada git push despliega solo.
──────────────────────────────────────────────────────────────
EOF
