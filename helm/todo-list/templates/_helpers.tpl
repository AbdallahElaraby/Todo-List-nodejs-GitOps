{{- define "todo-list.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "todo-list.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "todo-list.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

