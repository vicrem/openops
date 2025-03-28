{{/*
Expand the name of the chart.
*/}}
{{- define "openops.name" -}}
{{- default .Chart.Name .Values.openops.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "openops.fullname" -}}
{{- if .Values.openops.fullnameOverride }}
{{- .Values.openops.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.openops.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "openops.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "openops.labels" -}}
helm.sh/chart: {{ include "openops.chart" . }}
{{ include "openops.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "openops.selectorLabels" -}}
app.kubernetes.io/name: {{ include "openops.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "openops.serviceAccountName" -}}
{{- if .Values.openops.serviceAccount.create }}
{{- default (include "openops.fullname" .) .Values.openops.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.openops.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Set Redis address and port
*/}}
{{- define "redisConf" -}}
{{- $redisPort := .Values.openops.session.redis.port | default 6379 }}
{{- $redisDb := .Values.openops.session.redis.database | default 0 }}
{{- if not .Values.openops.session.redis.deploy }}
{{- $redisUrl := required "A valid .Values.openops.session.redis.address entry required!" .Values.openops.session.redis.address }}
{{- dict "REDIS_URL" $redisUrl "REDIS_PORT" $redisPort "REDIS_DB" $redisDb | toJson}}
{{- else -}}
{{- $redisUrl := printf "openops-redis-master.%s.svc" .Release.Namespace }}
{{- dict "REDIS_URL" $redisUrl "REDIS_PORT" $redisPort "REDIS_DB" $redisDb | toJson }}
{{- end -}}
{{- end -}}


{{/*
Set Postgres address and port
*/}}
{{- define "postgresConf" -}}
{{- $postgresPort := .Values.openops.storage.postgres.port | default 5432 }}
{{- if not .Values.openops.storage.postgres.deploy }}
{{- $postgresUrl := required "A valid .Values.openops.storage.postgres.address entry required!" .Values.openops.storage.postgres.address }}
{{- dict "DATABASE_HOST" $postgresUrl "DATABASE_HOST_ALT" $postgresUrl "DATABASE_PORT" $postgresPort | toJson}}
{{- else -}}
{{- $postgresUrl := printf "openops-postgresql.%s.svc" .Release.Namespace }}
{{- dict "DATABASE_HOST" $postgresUrl "DATABASE_HOST_ALT" $postgresUrl "DATABASE_PORT" $postgresPort | toJson }}
{{- end -}}
{{- end -}}


{{/*
Generate random hex
*/}}
{{- define "randomHex" -}}
{{- $length := 32 }}
{{- printf "%x" (randAscii (divf $length 2 | ceil | int)) | trunc $length }}
{{- end }}

{{/*
Scheme
*/}}
{{- define "scheme" -}}
{{- if .Values.openops.ingress.tls.enabled }}
{{- printf "https" }}
{{- else -}}
{{- printf "http" }}
{{- end }}
{{- end }}
